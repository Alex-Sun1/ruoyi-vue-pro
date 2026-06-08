package cn.iocoder.yudao.module.oms.service.outboundorder;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.oms.enums.ErrorCodeConstants.*;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils;
import cn.iocoder.yudao.module.oms.dal.dataobject.biz.BizAttachmentDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder.CargoOrderDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.outboundorder.OutboundOrderDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.outboundorder.OutboundOrderItemDO;
import cn.iocoder.yudao.module.oms.controller.admin.bizattachment.vo.BizAttachmentSaveReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo.OutboundOrderItemsReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo.OutboundOrderPageReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.bizattachment.vo.BizAttachmentRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo.OutboundOrderItemRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo.OutboundOrderRespVO;
import cn.iocoder.yudao.module.oms.dal.mysql.biz.BizAttachmentMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.cargoorder.CargoOrderMapper;
import cn.iocoder.yudao.module.oms.support.ContainerPrePlanSummaryService;
import cn.iocoder.yudao.module.oms.support.OmsLambdaQueryHelper;
import cn.iocoder.yudao.module.oms.support.OutboundReadinessUtils;
import cn.iocoder.yudao.module.oms.dal.mysql.outboundorder.OutboundOrderItemMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.outboundorder.OutboundOrderMapper;
import cn.iocoder.yudao.module.oms.integration.OmsYmsDispatchIntegration;
import cn.iocoder.yudao.module.oms.service.outboundorder.OutboundOrderService;
import cn.iocoder.yudao.module.oms.service.omsbizlifecycle.OmsBizLifecycleService;
import cn.iocoder.yudao.module.org.framework.datapermission.annotation.OrgDataScope;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;
import java.util.Optional;

@Service
public class OutboundOrderServiceImpl implements OutboundOrderService {

    private static final List<String> POOL_STATUSES = List.of(
        "PENDING_ACCEPT", "ACCEPTED", "IN_TRANSIT", "ARRIVED_PORT", "PICKED_UP",
        "ARRIVED_WAREHOUSE", "DEVANNING", "DEVANNED", "INBOUNDED"
    );

    private static final List<String> EDITABLE_OUTBOUND_STATUSES = List.of("CREATED", "APPOINTMENT_CONFIRMED");

    @Resource
    private OutboundOrderMapper baseMapper;
    @Resource
    private CargoOrderMapper cargoOrderMapper;
    @Resource
    private OutboundOrderItemMapper outboundOrderItemMapper;
    @Resource
    private BizAttachmentMapper attachmentMapper;
    @Resource
    private OmsBizLifecycleService lifecycleService;
    @Resource
    private OmsYmsDispatchIntegration omsYmsDispatchIntegration;
    @Resource
    private ContainerPrePlanSummaryService containerPrePlanSummaryService;

    @Override
    public OutboundOrderRespVO queryById(Long id) {
        return BeanUtils.toBean(baseMapper.selectById(id), OutboundOrderRespVO.class);
    }

    @Override
    @OrgDataScope(tableClass = OutboundOrderDO.class, warehouseColumn = "outbound_warehouse_id")
    public PageResult<OutboundOrderRespVO> queryPageList(OutboundOrderPageReqVO bo, PageParam pageQuery) {
        PageResult<OutboundOrderDO> page = baseMapper.selectPage(pageQuery, buildQueryWrapper(bo));
        return new PageResult<>(BeanUtils.toBean(page.getList(), OutboundOrderRespVO.class), page.getTotal());
    }

    @Override
    @OrgDataScope(tableClass = OutboundOrderDO.class, warehouseColumn = "outbound_warehouse_id")
    public List<OutboundOrderRespVO> queryList(OutboundOrderPageReqVO bo) {
        return BeanUtils.toBean(baseMapper.selectList(buildQueryWrapper(bo)), OutboundOrderRespVO.class);
    }

    @Override
    @OrgDataScope(tableClass = OutboundOrderDO.class, warehouseColumn = "outbound_warehouse_id")
    public Map<String, Long> queryStatusCount(OutboundOrderPageReqVO bo) {
        String status = bo == null ? null : bo.getOutboundStatus();
        if (bo != null) {
            bo.setOutboundStatus(null);
        }
        try {
            return baseMapper.selectList(buildQueryWrapper(bo)).stream()
                .filter(item -> StrUtil.isNotBlank(item.getOutboundStatus()))
                .collect(Collectors.groupingBy(OutboundOrderDO::getOutboundStatus, Collectors.counting()));
        } finally {
            if (bo != null) {
                bo.setOutboundStatus(status);
            }
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean updateByBo(OutboundOrderDO bo) {
        return baseMapper.updateById(bo) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean deleteWithValid(Long id) {
        OutboundOrderDO order = baseMapper.selectById(id);
        if (order == null) throw exception(OMS_BIZ_ERROR, "outbound order not found");
        if (!List.of("CREATED", "APPOINTMENT_CONFIRMED").contains(order.getOutboundStatus())) {
            throw exception(OMS_BIZ_ERROR, "只有已创建或已确认预约状态的出库单可以删除");
        }

        // 关联货物订单全部重置回出单工作台，主线同步回退
        List<OutboundOrderItemDO> items = outboundOrderItemMapper.selectList(
            Wrappers.<OutboundOrderItemDO>lambdaQuery()
                .eq(OutboundOrderItemDO::getOutboundOrderId, id));
        for (OutboundOrderItemDO item : items) {
            CargoOrderDO cargoUpdate = new CargoOrderDO();
            cargoUpdate.setId(item.getCargoOrderId());
            cargoUpdate.setOutboundOrderStatus("NONE");
            cargoUpdate.setOutboundBatchNo(null);
            cargoUpdate.setOutboundOrderTime(null);
            cargoUpdate.setPreOutboundStatus("NONE");
            cargoUpdate.setPreOutboundNo(null);
            cargoUpdate.setPreOutboundFlag(0);
            cargoOrderMapper.updateById(cargoUpdate);
            lifecycleService.transitionCargo(item.getCargoOrderId(), "INBOUNDED", "deleteOutboundOrder", "删除出库单回退至已入库");
        }

        // 逻辑删除 items 和出库单本身
        outboundOrderItemMapper.delete(
            Wrappers.<OutboundOrderItemDO>lambdaQuery()
                .eq(OutboundOrderItemDO::getOutboundOrderId, id));
        baseMapper.deleteById(id);
        return Boolean.TRUE;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean complete(Long id, String remark) {
        OutboundOrderDO order = baseMapper.selectById(id);
        if (order == null) throw exception(OMS_BIZ_ERROR, "出库单不存在");
        if ("COMPLETED".equals(order.getOutboundStatus())) throw exception(OMS_BIZ_ERROR, "出库单已完成");
        OutboundOrderDO update = new OutboundOrderDO();
        update.setId(id);
        update.setOutboundStatus("COMPLETED");
        update.setCompletedTime(new Date());
        update.setRemark(remark);
        baseMapper.updateById(update);

        Date now = new Date();
        List<OutboundOrderItemDO> items = outboundOrderItemMapper.selectList(
            Wrappers.<OutboundOrderItemDO>lambdaQuery()
                .eq(OutboundOrderItemDO::getOutboundOrderId, id));
        for (OutboundOrderItemDO item : items) {
            CargoOrderDO cargoUpdate = new CargoOrderDO();
            cargoUpdate.setId(item.getCargoOrderId());
            cargoUpdate.setOutboundOrderStatus("COMPLETED");
            cargoOrderMapper.updateById(cargoUpdate);
            lifecycleService.transitionCargo(item.getCargoOrderId(), "COMPLETED", "completeOutboundOrder", remark, now);
        }
        return Boolean.TRUE;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean confirmAppointment(Long id) {
        OutboundOrderDO order = baseMapper.selectById(id);
        if (order == null) throw exception(OMS_BIZ_ERROR, "出库单不存在");
        if (!"CREATED".equals(order.getOutboundStatus())) {
            throw exception(OMS_BIZ_ERROR, "只有已创建状态的出库单可以确认预约");
        }
        OutboundOrderDO update = new OutboundOrderDO();
        update.setId(id);
        update.setOutboundStatus("APPOINTMENT_CONFIRMED");
        boolean success = baseMapper.updateById(update) > 0;
        if (success) {
            List<OutboundOrderItemDO> items = outboundOrderItemMapper.selectList(
                Wrappers.<OutboundOrderItemDO>lambdaQuery()
                    .eq(OutboundOrderItemDO::getOutboundOrderId, id));
            for (OutboundOrderItemDO item : items) {
                lifecycleService.transitionCargo(item.getCargoOrderId(), "DELIVERY_APPOINTED", "confirmOutboundAppointment", null);
            }
            omsYmsDispatchIntegration.pushOutboundLoadingTask(id);
        }
        return success;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean confirmOutbounded(Long id) {
        OutboundOrderDO order = baseMapper.selectById(id);
        if (order == null) throw exception(OMS_BIZ_ERROR, "出库单不存在");
        if (!List.of("CREATED", "APPOINTMENT_CONFIRMED").contains(order.getOutboundStatus())) {
            throw exception(OMS_BIZ_ERROR, "只有已创建或已确认预约状态的出库单可以确认出库");
        }
        Date now = new Date();
        OutboundOrderDO update = new OutboundOrderDO();
        update.setId(id);
        update.setOutboundStatus("OUTBOUNDED");
        update.setActualOutboundTime(now);
        baseMapper.updateById(update);
        List<OutboundOrderItemDO> items = outboundOrderItemMapper.selectList(
            Wrappers.<OutboundOrderItemDO>lambdaQuery()
                .eq(OutboundOrderItemDO::getOutboundOrderId, id));
        for (OutboundOrderItemDO item : items) {
            lifecycleService.transitionCargo(item.getCargoOrderId(), "OUTBOUNDED", "confirmOutbounded", "确认出库", now);
        }
        return Boolean.TRUE;
    }

    @Override
    public List<OutboundOrderItemRespVO> queryItems(Long id) {
        return BeanUtils.toBean(outboundOrderItemMapper.selectList(
            Wrappers.<OutboundOrderItemDO>lambdaQuery()
                .eq(OutboundOrderItemDO::getOutboundOrderId, id)), OutboundOrderItemRespVO.class);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean addItems(Long id, OutboundOrderItemsReqVO bo) {
        OutboundOrderDO outboundOrder = requireEditableOutboundOrder(id);
        if (bo == null || bo.getCargoOrderIds() == null || bo.getCargoOrderIds().isEmpty()) {
            throw exception(OMS_BIZ_ERROR, "cargoOrderIds is required");
        }
        for (Long cargoOrderId : bo.getCargoOrderIds()) {
            attachCargoOrder(outboundOrder, cargoOrderId);
        }
        refreshHeaderAggregate(outboundOrder.getId());
        return Boolean.TRUE;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean removeItem(Long id, Long itemId) {
        OutboundOrderDO outboundOrder = requireEditableOutboundOrder(id);
        OutboundOrderItemDO item = outboundOrderItemMapper.selectById(itemId);
        if (item == null || !Objects.equals(item.getOutboundOrderId(), id)) {
            throw exception(OMS_BIZ_ERROR, "outbound order item not found");
        }
        Long cargoOrderId = item.getCargoOrderId();
        releaseCargoOrder(cargoOrderId);
        outboundOrderItemMapper.deleteById(itemId);
        List<OutboundOrderItemDO> remain = listItems(id);
        if (remain.isEmpty()) {
            resetHeaderToEmpty(outboundOrder);
        } else {
            refreshHeaderAggregate(id);
        }
        containerPrePlanSummaryService.refreshByCargoOrderId(cargoOrderId);
        return Boolean.TRUE;
    }

    @Override
    public List<BizAttachmentRespVO> queryAttachments(Long id) {
        return BeanUtils.toBean(attachmentMapper.selectList(new LambdaQueryWrapper<BizAttachmentDO>()
            .eq(BizAttachmentDO::getTargetType, "OUTBOUND_ORDER")
            .eq(BizAttachmentDO::getTargetId, id)
            .orderByDesc(BizAttachmentDO::getUploadTime)), BizAttachmentRespVO.class);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean uploadAttachment(Long id, BizAttachmentSaveReqVO bo) {
        OutboundOrderDO order = baseMapper.selectById(id);
        if (order == null) throw exception(OMS_BIZ_ERROR, "出库单不存在");
        BizAttachmentDO attachment = BeanUtils.toBean(bo, BizAttachmentDO.class);
        attachment.setTargetType("OUTBOUND_ORDER");
        attachment.setTargetId(order.getId());
        attachment.setTargetNo(order.getOutboundOrderNo());
        attachment.setBizRootId(order.getBizRootId());
        attachment.setAttachmentType(StrUtil.blankToDefault(bo.getAttachmentType(), "OTHER"));
        attachment.setCustomerVisibleFlag(Optional.ofNullable(attachment.getCustomerVisibleFlag()).orElse(0));
        attachment.setInternalVisibleFlag(Optional.ofNullable(attachment.getInternalVisibleFlag()).orElse(1));
        attachment.setUploadUserId(SecurityFrameworkUtils.getLoginUserId());
        attachment.setUploadUserName(SecurityFrameworkUtils.getLoginUserNickname());
        attachment.setUploadTime(new Date());
        attachmentMapper.insert(attachment);
        if ("POD".equals(bo.getAttachmentType()) && !"COMPLETED".equals(order.getOutboundStatus())) {
            Date podNow = new Date();
            OutboundOrderDO podUpdate = new OutboundOrderDO();
            podUpdate.setId(id);
            podUpdate.setOutboundStatus("POD_UPLOADED");
            podUpdate.setPodStatus("UPLOADED");
            podUpdate.setPodUploadTime(podNow);
            baseMapper.updateById(podUpdate);
            List<OutboundOrderItemDO> podItems = outboundOrderItemMapper.selectList(
                Wrappers.<OutboundOrderItemDO>lambdaQuery()
                    .eq(OutboundOrderItemDO::getOutboundOrderId, id));
            for (OutboundOrderItemDO item : podItems) {
                lifecycleService.transitionCargo(item.getCargoOrderId(), "POD_UPLOADED", "uploadOutboundPod", "POD已上传", podNow);
            }
        }
        return Boolean.TRUE;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean confirmSigned(Long id) {
        OutboundOrderDO order = baseMapper.selectById(id);
        if (order == null) throw exception(OMS_BIZ_ERROR, "出库单不存在");
        if (List.of("SIGNED", "POD_UPLOADED", "COMPLETED").contains(order.getOutboundStatus())) {
            throw exception(OMS_BIZ_ERROR, "出库单已签收或已完成");
        }
        OutboundOrderDO update = new OutboundOrderDO();
        update.setId(id);
        update.setOutboundStatus("SIGNED");
        baseMapper.updateById(update);

        Date now = new Date();
        List<OutboundOrderItemDO> items = outboundOrderItemMapper.selectList(
            Wrappers.<OutboundOrderItemDO>lambdaQuery()
                .eq(OutboundOrderItemDO::getOutboundOrderId, id));
        for (OutboundOrderItemDO item : items) {
            lifecycleService.transitionCargo(item.getCargoOrderId(), "DELIVERED", "confirmOutboundSigned", "确认签收", now);
        }
        return Boolean.TRUE;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean removeAttachment(Long attachmentId) {
        BizAttachmentDO attachment = attachmentMapper.selectById(attachmentId);
        if (attachment == null || !"OUTBOUND_ORDER".equals(attachment.getTargetType())) {
            throw exception(OMS_BIZ_ERROR, "附件不存在");
        }
        attachmentMapper.deleteById(attachmentId);
        return Boolean.TRUE;
    }

    private OutboundOrderDO requireEditableOutboundOrder(Long id) {
        OutboundOrderDO outboundOrder = baseMapper.selectById(id);
        if (outboundOrder == null) {
            throw exception(OMS_BIZ_ERROR, "outbound order not found");
        }
        if (!EDITABLE_OUTBOUND_STATUSES.contains(outboundOrder.getOutboundStatus())) {
            throw exception(OMS_BIZ_ERROR, "outbound order cannot be edited");
        }
        return outboundOrder;
    }

    private List<OutboundOrderItemDO> listItems(Long outboundOrderId) {
        return outboundOrderItemMapper.selectList(Wrappers.<OutboundOrderItemDO>lambdaQuery()
            .eq(OutboundOrderItemDO::getOutboundOrderId, outboundOrderId)
            .orderByAsc(OutboundOrderItemDO::getCreateTime));
    }

    private void attachCargoOrder(OutboundOrderDO outboundOrder, Long cargoOrderId) {
        CargoOrderDO order = cargoOrderMapper.selectById(cargoOrderId);
        if (order == null) {
            throw exception(OMS_BIZ_ERROR, "cargo order not found");
        }
        validatePoolOrder(order);
        Long exists = outboundOrderItemMapper.selectCount(Wrappers.<OutboundOrderItemDO>lambdaQuery()
            .eq(OutboundOrderItemDO::getOutboundOrderId, outboundOrder.getId())
            .eq(OutboundOrderItemDO::getCargoOrderId, cargoOrderId));
        if (exists != null && exists > 0) {
            throw exception(OMS_BIZ_ERROR, String.valueOf("cargo order already in outbound order: " + order.getCargoOrderNo()));
        }
        createOutboundOrderItem(outboundOrder, order);
        markCargoOutbound(order, outboundOrder.getOutboundOrderNo());
        containerPrePlanSummaryService.refreshByCargoOrderId(cargoOrderId);
    }

    private void createOutboundOrderItem(OutboundOrderDO outboundOrder, CargoOrderDO order) {
        OutboundOrderItemDO item = new OutboundOrderItemDO();
        item.setOutboundOrderId(outboundOrder.getId());
        item.setOutboundOrderNo(outboundOrder.getOutboundOrderNo());
        item.setCargoOrderId(order.getId());
        item.setCargoOrderNo(order.getCargoOrderNo());
        item.setActualCartonQty(order.getActualCartonQty());
        item.setActualPalletQty(order.getActualPalletQty());
        item.setActualWeight(order.getActualWeight());
        item.setActualCbm(order.getActualCbm());
        outboundOrderItemMapper.insert(item);
    }

    private void markCargoOutbound(CargoOrderDO order, String outboundOrderNo) {
        Date now = new Date();
        CargoOrderDO update = new CargoOrderDO();
        update.setId(order.getId());
        update.setOutboundBatchNo(outboundOrderNo);
        update.setOutboundOrderStatus("CREATED");
        update.setOutboundOrderTime(now);
        cargoOrderMapper.updateById(update);
        lifecycleService.transitionCargo(order.getId(), "OUTBOUND_ORDERED", "addOutboundItem", "添加至出库单", now);
    }

    private void releaseCargoOrder(Long cargoOrderId) {
        CargoOrderDO update = new CargoOrderDO();
        update.setId(cargoOrderId);
        update.setOutboundOrderStatus("NONE");
        update.setOutboundBatchNo(null);
        update.setOutboundOrderTime(null);
        cargoOrderMapper.updateById(update);
        lifecycleService.transitionCargo(cargoOrderId, "INBOUNDED", "removeOutboundItem", "移出出库单回退至已入库");
    }

    private void validatePoolOrder(CargoOrderDO order) {
        if (Objects.equals(order.getHoldFlag(), 1)) {
            throw exception(OMS_BIZ_ERROR, "cargo order is holding");
        }
        if (StrUtil.isNotBlank(order.getPreOutboundStatus()) && !"NONE".equals(order.getPreOutboundStatus())) {
            throw exception(OMS_BIZ_ERROR, "cargo order already has pre-outbound order");
        }
        if (StrUtil.isNotBlank(order.getOutboundOrderStatus()) && !"NONE".equals(order.getOutboundOrderStatus())) {
            throw exception(OMS_BIZ_ERROR, "cargo order already has outbound order");
        }
        if (!POOL_STATUSES.contains(order.getFulfillmentStatus())) {
            throw exception(OMS_BIZ_ERROR, "cargo order is not in outbound pool");
        }
        if (!OutboundReadinessUtils.INBOUNDED.equals(OutboundReadinessUtils.resolveReadiness(order))) {
            throw exception(OMS_BIZ_ERROR, "cargo order is not fully inbounded");
        }
    }

    private void refreshHeaderAggregate(Long outboundOrderId) {
        OutboundOrderDO outboundOrder = baseMapper.selectById(outboundOrderId);
        if (outboundOrder == null) {
            return;
        }
        List<OutboundOrderItemDO> items = listItems(outboundOrderId);
        if (items.isEmpty()) {
            resetHeaderToEmpty(outboundOrder);
            return;
        }
        List<CargoOrderDO> orders = new ArrayList<>();
        for (OutboundOrderItemDO item : items) {
            CargoOrderDO order = cargoOrderMapper.selectById(item.getCargoOrderId());
            if (order == null) {
                continue;
            }
            orders.add(order);
        }
        OutboundOrderDO update = new OutboundOrderDO();
        update.setId(outboundOrderId);
        update.setCargoOrderCount(orders.size());
        update.setCargoOrderId(orders.get(0).getId());
        update.setCargoOrderNo(orders.stream().map(CargoOrderDO::getCargoOrderNo).collect(Collectors.joining(",")));
        update.setCustomerName(orders.get(0).getCustomerName());
        update.setContainerNo(orders.stream().map(CargoOrderDO::getContainerNo).filter(StrUtil::isNotBlank).distinct().collect(Collectors.joining(",")));
        update.setShipmentCodes(orders.stream().map(CargoOrderDO::getShipmentCodes).filter(StrUtil::isNotBlank).collect(Collectors.joining(",")));
        update.setActualCartonQty(sum(orders, CargoOrderDO::getActualCartonQty));
        update.setActualPalletQty(sum(orders, CargoOrderDO::getActualPalletQty));
        update.setActualWeight(sum(orders, CargoOrderDO::getActualWeight));
        update.setActualCbm(sum(orders, CargoOrderDO::getActualCbm));
        baseMapper.updateById(update);
    }

    private void resetHeaderToEmpty(OutboundOrderDO outboundOrder) {
        OutboundOrderDO update = new OutboundOrderDO();
        update.setId(outboundOrder.getId());
        update.setCargoOrderCount(0);
        update.setCargoOrderId(null);
        update.setCargoOrderNo(null);
        update.setCustomerName(null);
        update.setContainerNo(null);
        update.setShipmentCodes(null);
        update.setActualCartonQty(BigDecimal.ZERO);
        update.setActualPalletQty(BigDecimal.ZERO);
        update.setActualWeight(BigDecimal.ZERO);
        update.setActualCbm(BigDecimal.ZERO);
        baseMapper.updateById(update);
    }

    private BigDecimal sum(List<CargoOrderDO> orders, java.util.function.Function<CargoOrderDO, BigDecimal> getter) {
        return orders.stream().map(getter).map(this::nvl).reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    private BigDecimal nvl(BigDecimal value) {
        return value == null ? BigDecimal.ZERO : value;
    }

    private LambdaQueryWrapper<OutboundOrderDO> buildQueryWrapper(OutboundOrderPageReqVO bo) {
        LambdaQueryWrapper<OutboundOrderDO> lqw = Wrappers.lambdaQuery();
        if (bo != null) {
            OmsLambdaQueryHelper.inStringCsv(lqw, OutboundOrderDO::getOutboundStatus, bo.getOutboundStatus());
            OmsLambdaQueryHelper.inStringCsv(lqw, OutboundOrderDO::getOutboundDirection, bo.getOutboundDirection());
            OmsLambdaQueryHelper.inLongCsv(lqw, OutboundOrderDO::getOutboundWarehouseId, bo.getOutboundWarehouseId());
            lqw.like(StrUtil.isNotBlank(bo.getOutboundWarehouseName()), OutboundOrderDO::getOutboundWarehouseName, bo.getOutboundWarehouseName());
            lqw.like(StrUtil.isNotBlank(bo.getCustomerName()), OutboundOrderDO::getCustomerName, bo.getCustomerName());
            lqw.like(StrUtil.isNotBlank(bo.getOutboundOrderNo()), OutboundOrderDO::getOutboundOrderNo, bo.getOutboundOrderNo());
            lqw.like(StrUtil.isNotBlank(bo.getPreOutboundNo()), OutboundOrderDO::getPreOutboundNo, bo.getPreOutboundNo());
            lqw.like(StrUtil.isNotBlank(bo.getCargoOrderNo()), OutboundOrderDO::getCargoOrderNo, bo.getCargoOrderNo());
            lqw.like(StrUtil.isNotBlank(bo.getContainerNo()), OutboundOrderDO::getContainerNo, bo.getContainerNo());
            lqw.like(StrUtil.isNotBlank(bo.getShipmentCodes()), OutboundOrderDO::getShipmentCodes, bo.getShipmentCodes());
            OmsLambdaQueryHelper.inStringCsv(lqw, OutboundOrderDO::getAppointmentStatus, bo.getAppointmentStatus());
            OmsLambdaQueryHelper.inStringCsv(lqw, OutboundOrderDO::getPodStatus, bo.getPodStatus());
            lqw.ge(bo.getBeginActualOutboundTime() != null, OutboundOrderDO::getActualOutboundTime, bo.getBeginActualOutboundTime());
            lqw.le(bo.getEndActualOutboundTime() != null, OutboundOrderDO::getActualOutboundTime, bo.getEndActualOutboundTime());
            lqw.ge(bo.getBeginCompletedTime() != null, OutboundOrderDO::getCompletedTime, bo.getBeginCompletedTime());
            lqw.le(bo.getEndCompletedTime() != null, OutboundOrderDO::getCompletedTime, bo.getEndCompletedTime());
            if (StrUtil.isNotBlank(bo.getKeyword())) {
                String keyword = bo.getKeyword();
                String field = bo.getKeywordField();
                if ("outboundOrderNo".equals(field)) {
                    lqw.like(OutboundOrderDO::getOutboundOrderNo, keyword);
                } else if ("preOutboundNo".equals(field)) {
                    lqw.like(OutboundOrderDO::getPreOutboundNo, keyword);
                } else if ("cargoOrderNo".equals(field)) {
                    lqw.like(OutboundOrderDO::getCargoOrderNo, keyword);
                } else if ("containerNo".equals(field)) {
                    lqw.like(OutboundOrderDO::getContainerNo, keyword);
                } else if ("shipmentCodes".equals(field)) {
                    lqw.like(OutboundOrderDO::getShipmentCodes, keyword);
                } else {
                    lqw.and(w -> w.like(OutboundOrderDO::getOutboundOrderNo, keyword)
                        .or().like(OutboundOrderDO::getPreOutboundNo, keyword)
                        .or().like(OutboundOrderDO::getCargoOrderNo, keyword)
                        .or().like(OutboundOrderDO::getContainerNo, keyword)
                        .or().like(OutboundOrderDO::getShipmentCodes, keyword));
                }
            }
        }
        lqw.orderByDesc(OutboundOrderDO::getCreateTime);
        return lqw;
    }
}
