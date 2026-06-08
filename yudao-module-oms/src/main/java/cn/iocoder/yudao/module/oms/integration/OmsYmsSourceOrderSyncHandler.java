package cn.iocoder.yudao.module.oms.integration;

import jakarta.annotation.Resource;

import lombok.extern.slf4j.Slf4j;
import cn.iocoder.yudao.module.oms.dal.dataobject.containerorder.ContainerOrderDO;
import cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerOrderStatusReqVO;
import cn.iocoder.yudao.module.oms.dal.mysql.containerorder.ContainerOrderMapper;
import cn.iocoder.yudao.module.oms.service.containerorder.ContainerOrderService;
import cn.iocoder.yudao.module.oms.service.outboundorder.OutboundOrderService;
import cn.iocoder.yudao.module.yms.integration.YmsSourceOrderSyncHandler;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.Set;

/**
 * YMS 园区作业动作回写 OMS 海柜订单 / 出库单状态与时间字段。
 *
 * <p>事件对应关系：
 * <pre>
 * 海柜拆柜（CONTAINER_ORDER + DEVANNING）：
 *   onYardTaskArrival  → containerStatus=ARRIVED_WAREHOUSE + actualArrivalTime
 *   DOCK_ASSIGNED      → 不变更状态（已通过 ARRIVED_WAREHOUSE 表达到仓）
 *   START_DOCK         → containerStatus=DEVANNING + devanningStartTime
 *   FINISH_DOCK        → containerStatus=DEVANNED  + devanningFinishTime
 *   LEAVE_YARD         → containerStatus=LEFT_YARD
 *
 * 装车（OUTBOUND_ORDER + *_LOADING）：
 *   FINISH_DOCK        → confirmOutbounded() → outboundStatus=OUTBOUNDED + actualOutboundTime
 * </pre>
 */
@Slf4j
@Component
public class OmsYmsSourceOrderSyncHandler implements YmsSourceOrderSyncHandler {

    private static final String SOURCE_CONTAINER = "CONTAINER_ORDER";
    private static final String SOURCE_OUTBOUND  = "OUTBOUND_ORDER";
    private static final Set<String> DEVANNING_TYPES = Set.of("DEVANNING");
    private static final Set<String> LOADING_TYPES   = Set.of(
        "DELIVERY_LOADING", "TRANSFER_LOADING", "PICKUP_LOADING", "RETURN_LOADING");

    @Resource
    private ContainerOrderMapper    containerOrderMapper;
    @Resource
    private ContainerOrderService  containerOrderService;
    @Resource
    private OutboundOrderService   outboundOrderService;

    public OmsYmsSourceOrderSyncHandler(
            ContainerOrderMapper containerOrderMapper,
            @Lazy ContainerOrderService containerOrderService,
            @Lazy OutboundOrderService outboundOrderService) {
        this.containerOrderMapper   = containerOrderMapper;
        this.containerOrderService  = containerOrderService;
        this.outboundOrderService   = outboundOrderService;
    }

    // ─── 状态动作回写 ──────────────────────────────────────────────────────────

    @Override
    public void onYardTaskAction(String sourceOrderType, Long sourceOrderId, String taskType, String action) {
        try {
            if (SOURCE_CONTAINER.equals(sourceOrderType) && DEVANNING_TYPES.contains(taskType)) {
                handleContainerAction(sourceOrderId, action);
            } else if (SOURCE_OUTBOUND.equals(sourceOrderType) && LOADING_TYPES.contains(taskType)) {
                handleOutboundAction(sourceOrderId, action, taskType);
            }
        } catch (Exception ex) {
            log.warn("YMS→OMS action sync failed: type={} id={} task={} action={} err={}",
                sourceOrderType, sourceOrderId, taskType, action, ex.getMessage());
        }
    }

    // ─── 到仓时间回写 ─────────────────────────────────────────────────────────

    @Override
    public void onYardTaskArrival(String sourceOrderType, Long sourceOrderId, String taskType,
                                  Date arrivalTime, String positionCode) {
        if (!SOURCE_CONTAINER.equals(sourceOrderType)) {
            return; // 装车类型到仓暂不同步出库单状态
        }
        ContainerOrderDO order = containerOrderMapper.selectById(sourceOrderId);
        if (order == null) return;

        ContainerOrderStatusReqVO bo = new ContainerOrderStatusReqVO();
        bo.setTargetStatus("ARRIVED_WAREHOUSE");
        bo.setActualArrivalTime(arrivalTime);
        bo.setContainerLocation(positionCode);
        bo.setRemark("YMS Check-in 自动回写");
        try {
            containerOrderService.updateStatus(sourceOrderId, bo);
            log.info("YMS→OMS arrival: container={} location={}", sourceOrderId, positionCode);
        } catch (Exception ex) {
            log.warn("YMS→OMS arrival sync failed: container={} err={}", sourceOrderId, ex.getMessage());
        }
    }

    // ─── 私有处理 ─────────────────────────────────────────────────────────────

    private void handleContainerAction(Long orderId, String action) {
        ContainerOrderDO order = containerOrderMapper.selectById(orderId);
        if (order == null) return;

        Date now = new Date();
        String targetStatus = switch (action) {
            case "START_DOCK"  -> "DEVANNING";
            case "FINISH_DOCK" -> "DEVANNED";
            // LEAVE_YARD = 空柜离开仓库园区，不代表已还柜给船公司，不变更 OMS 状态
            // 已还柜（EMPTY_RETURNED）由前端填写 emptyReturnTime 字段自动推进
            default            -> null;
        };
        if (targetStatus == null || targetStatus.equals(order.getContainerStatus())) return;

        ContainerOrderStatusReqVO bo = new ContainerOrderStatusReqVO();
        bo.setTargetStatus(targetStatus);
        bo.setRemark("YMS园区作业自动回写");
        if ("START_DOCK".equals(action))  bo.setDevanningStartTime(now);
        if ("FINISH_DOCK".equals(action)) bo.setDevanningFinishTime(now);

        containerOrderService.updateStatus(orderId, bo);
        log.info("YMS→OMS container: id={} -> {}", orderId, targetStatus);
    }

    private void handleOutboundAction(Long orderId, String action, String taskType) {
        if (!"FINISH_DOCK".equals(action)) {
            return; // 装车只在完成时回写出库单
        }
        try {
            outboundOrderService.confirmOutbounded(orderId);
            log.info("YMS→OMS outbound confirmed: id={} taskType={}", orderId, taskType);
        } catch (Exception ex) {
            // confirmOutbounded 有状态前置校验，不满足时静默跳过（不影响 YMS 主流程）
            log.warn("YMS→OMS outbound confirmOutbounded skipped: id={} err={}", orderId, ex.getMessage());
        }
    }
}
