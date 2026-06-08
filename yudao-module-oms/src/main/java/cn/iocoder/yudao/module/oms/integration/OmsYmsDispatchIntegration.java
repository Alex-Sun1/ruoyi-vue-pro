package cn.iocoder.yudao.module.oms.integration;

import jakarta.annotation.Resource;

import lombok.extern.slf4j.Slf4j;
import cn.iocoder.yudao.module.oms.dal.dataobject.containerorder.ContainerOrderDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.outboundorder.OutboundOrderDO;
import cn.iocoder.yudao.module.oms.dal.mysql.containerorder.ContainerOrderMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.outboundorder.OutboundOrderMapper;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsPushTaskReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardTaskRespVO;
import cn.iocoder.yudao.module.yms.service.YmsDispatchService;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;

import java.util.Date;

/**
 * OMS → YMS 园区任务推送（单体直调，幂等由 YMS pushTask 保证）。
 */
@Slf4j
@Service
public class OmsYmsDispatchIntegration {

    private static final String SOURCE_CONTAINER = "CONTAINER_ORDER";
    private static final String SOURCE_OUTBOUND = "OUTBOUND_ORDER";

    @Resource
    private YmsDispatchService ymsDispatchService;
    @Resource
    private ContainerOrderMapper containerOrderMapper;
    @Resource
    private OutboundOrderMapper outboundOrderMapper;

    /** @Lazy 打破 OMS ↔ YMS 循环依赖：ContainerOrderDO → 本类 → YmsDispatch → SyncHandler → ContainerOrderDO */
    public OmsYmsDispatchIntegration(
            @Lazy YmsDispatchService ymsDispatchService,
            ContainerOrderMapper containerOrderMapper,
            OutboundOrderMapper outboundOrderMapper) {
        this.ymsDispatchService = ymsDispatchService;
        this.containerOrderMapper = containerOrderMapper;
        this.outboundOrderMapper = outboundOrderMapper;
    }

    /**
     * 推送海柜拆柜任务到 YMS（幂等）。
     * 触发时机：
     *   1. containerStatus → PICKED_UP（提柜，YMS 提前建任务等候到仓）
     *   2. devanningAppointmentTime 首次填写或变更（更新 YMS 的 etaYardTime）
     * ARRIVED_WAREHOUSE 状态不再触发本方法，改由 YMS Check-in → sync handler 回写。
     */
    public void pushContainerDevanningTask(Long containerOrderId) {
        ContainerOrderDO order = containerOrderMapper.selectById(containerOrderId);
        if (order == null || order.getWarehouseId() == null) {
            return;
        }
        YmsPushTaskReqVO bo = new YmsPushTaskReqVO();
        bo.setTaskType("DEVANNING");
        bo.setWarehouseId(order.getWarehouseId());
        bo.setSourceOrderType(SOURCE_CONTAINER);
        bo.setSourceOrderId(order.getId());
        bo.setSourceOrderNo(order.getContainerOrderNo());
        bo.setContainerNo(order.getContainerNo());
        bo.setEtaYardTime(resolveContainerEta(order));
        pushSafely(bo, order.getId(), true);
    }

    /**
     * OMS 手动设置 ARRIVED_WAREHOUSE 时同步到 YMS：
     * - 任务不存在 → 先 push 新建，再推进到 ARRIVED
     * - 任务已存在 → 直接更新 gateInTime，并在 CREATED/PRE_ARRIVAL 时推进到 ARRIVED
     * 不触发 OMS sync handler 回写，避免循环。
     */
    public void syncContainerArrival(Long containerOrderId, Date arrivalTime) {
        ContainerOrderDO order = containerOrderMapper.selectById(containerOrderId);
        if (order == null || order.getWarehouseId() == null) return;
        // 先确保任务已创建（幂等）
        pushContainerDevanningTask(containerOrderId);
        // 再同步到仓时间 + 推进状态（不回调 OMS）
        try {
            ymsDispatchService.syncOmsArrival(SOURCE_CONTAINER, containerOrderId, arrivalTime);
            log.info("OMS→YMS arrival sync ok: containerOrderId={}", containerOrderId);
        } catch (Exception ex) {
            log.warn("OMS→YMS arrival sync failed: containerOrderId={} err={}", containerOrderId, ex.getMessage());
        }
    }

    /** 出库单确认预约后推送装车任务 */
    public void pushOutboundLoadingTask(Long outboundOrderId) {
        OutboundOrderDO order = outboundOrderMapper.selectById(outboundOrderId);
        if (order == null || order.getOutboundWarehouseId() == null) {
            return;
        }
        YmsPushTaskReqVO bo = new YmsPushTaskReqVO();
        bo.setTaskType(resolveLoadingTaskType(order.getOutboundDirection()));
        bo.setWarehouseId(order.getOutboundWarehouseId());
        bo.setSourceOrderType(SOURCE_OUTBOUND);
        bo.setSourceOrderId(order.getId());
        bo.setSourceOrderNo(order.getOutboundOrderNo());
        bo.setContainerNo(order.getContainerNo());
        bo.setDriverName(order.getContactName());
        bo.setDriverPhone(order.getContactPhone());
        bo.setEtaYardTime(order.getAppointmentTime() != null ? order.getAppointmentTime()
            : order.getEstimatedArrivalTime());
        pushSafely(bo, null, false);
    }

    private void pushSafely(YmsPushTaskReqVO bo, Long containerOrderId, boolean isContainer) {
        try {
            YmsYardTaskRespVO task = ymsDispatchService.pushTask(bo);
            log.info("OMS→YMS push ok: {}:{} -> yardTaskNo={}", bo.getSourceOrderType(), bo.getSourceOrderId(),
                task != null ? task.getYardTaskNo() : null);
            if (isContainer && containerOrderId != null) {
                clearContainerDownstreamException(containerOrderId);
            }
        } catch (Exception ex) {
            log.warn("OMS→YMS push failed: {}:{} - {}", bo.getSourceOrderType(), bo.getSourceOrderId(),
                ex.getMessage());
            if (isContainer && containerOrderId != null) {
                markContainerDownstreamException(containerOrderId);
            }
        }
    }

    private Date resolveContainerEta(ContainerOrderDO order) {
        if (order.getDevanningAppointmentTime() != null) {
            return order.getDevanningAppointmentTime();
        }
        if (order.getExpectedArrivalTime() != null) {
            return order.getExpectedArrivalTime();
        }
        return order.getActualArrivalTime();
    }

    private static String resolveLoadingTaskType(String direction) {
        if ("TRANSFER".equals(direction)) {
            return "TRANSFER_LOADING";
        }
        if ("PICKUP".equals(direction)) {
            return "PICKUP_LOADING";
        }
        return "DELIVERY_LOADING";
    }

    private void markContainerDownstreamException(Long containerOrderId) {
        ContainerOrderDO patch = new ContainerOrderDO();
        patch.setId(containerOrderId);
        patch.setDownstreamExceptionFlag(1);
        patch.setDownstreamExceptionCount(1);
        containerOrderMapper.updateById(patch);
    }

    private void clearContainerDownstreamException(Long containerOrderId) {
        ContainerOrderDO patch = new ContainerOrderDO();
        patch.setId(containerOrderId);
        patch.setDownstreamExceptionFlag(0);
        patch.setDownstreamExceptionCount(0);
        containerOrderMapper.updateById(patch);
    }
}
