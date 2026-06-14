package cn.iocoder.yudao.module.oms.service.preoutbound;

import cn.iocoder.yudao.framework.common.util.object.BeanUtils;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.oms.enums.ErrorCodeConstants.*;

import cn.hutool.core.util.IdUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils;
import cn.iocoder.yudao.module.oms.controller.admin.common.vo.OmsManualStatusReqVO;
import cn.iocoder.yudao.module.oms.dal.dataobject.biz.BizRootRelationDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder.CargoOrderDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.outboundorder.OutboundOrderDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.outboundorder.OutboundOrderItemDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.preoutbound.PreOutboundDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.preoutbound.PreOutboundItemDO;
import cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo.OutboundCreateReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.preoutbound.vo.PreOutboundItemsReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.preoutbound.vo.PreOutboundPageReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.preoutbound.vo.PreOutboundUpdateReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo.OutboundOrderRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.preoutbound.vo.PreOutboundItemRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.preoutbound.vo.PreOutboundRespVO;
import cn.iocoder.yudao.module.oms.dal.mysql.biz.BizRootRelationMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.cargoorder.CargoOrderMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.outboundorder.OutboundOrderItemMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.outboundorder.OutboundOrderMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.preoutbound.PreOutboundItemMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.preoutbound.PreOutboundMapper;
import cn.iocoder.yudao.module.oms.service.preoutbound.PreOutboundService;
import cn.iocoder.yudao.module.oms.service.omsbizlifecycle.OmsBizLifecycleService;
import cn.iocoder.yudao.module.oms.support.ContainerPrePlanSummaryService;
import cn.iocoder.yudao.module.oms.support.OmsLambdaQueryHelper;
import cn.iocoder.yudao.module.oms.support.OmsStatusTransitionGuard;
import cn.iocoder.yudao.module.oms.support.OutboundReadinessUtils;
import cn.iocoder.yudao.module.org.framework.datapermission.annotation.OrgDataScope;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
public class PreOutboundServiceImpl implements PreOutboundService {

    private static final List<String> POOL_STATUSES = List.of(
        "PENDING_ACCEPT", "ACCEPTED", "IN_TRANSIT", "ARRIVED_PORT", "PICKED_UP",
        "ARRIVED_WAREHOUSE", "DEVANNING", "DEVANNED", "INBOUNDED"
    );

    @Resource
    private PreOutboundMapper baseMapper;
    @Resource
    private PreOutboundItemMapper itemMapper;
    @Resource
    private CargoOrderMapper cargoOrderMapper;
    @Resource
    private OutboundOrderMapper outboundOrderMapper;
    @Resource
    private OutboundOrderItemMapper outboundOrderItemMapper;
    @Resource
    private BizRootRelationMapper bizRootRelationMapper;
    @Resource
    private ContainerPrePlanSummaryService containerPrePlanSummaryService;
    @Resource
    private OmsBizLifecycleService lifecycleService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public PreOutboundRespVO createEmpty(OutboundCreateReqVO bo) {
        if (bo == null || bo.getOutboundWarehouseId() == null) {
            throw exception(OMS_BIZ_ERROR, "outbound warehouse is required");
        }
        PreOutboundDO preOutbound = new PreOutboundDO();
        preOutbound.setPreOutboundNo("POB" + IdUtil.getSnowflakeNextIdStr());
        preOutbound.setPreOutboundStatus("PENDING_INBOUND");
        preOutbound.setCargoOrderCount(0);
        preOutbound.setOutboundDirection(defaultDirection(bo.getOutboundDirection()));
        preOutbound.setOutboundWarehouseId(bo.getOutboundWarehouseId());
        preOutbound.setOutboundWarehouseName(bo.getOutboundWarehouseName());
        preOutbound.setAppointmentNo(bo.getAppointmentNo());
        preOutbound.setAppointmentTime(bo.getAppointmentTime());
        preOutbound.setDeliveryTruck(bo.getDeliveryTruck());
        preOutbound.setLoadingType(bo.getLoadingType());
        preOutbound.setTransportType(bo.getTransportType());
        preOutbound.setDeliveryTag(bo.getDeliveryTag());
        preOutbound.setDestination(bo.getDestination());
        preOutbound.setDeliveryMethod(bo.getDeliveryMethod());
        preOutbound.setFollowRecord(bo.getFollowRecord());
        preOutbound.setRemark(bo.getRemark());
        baseMapper.insert(preOutbound);
        return toRespVO(preOutbound);
    }

    @Override
    public PreOutboundRespVO queryById(Long id) {
        return toRespVO(baseMapper.selectById(id));
    }

    @Override
    @OrgDataScope(tableClass = PreOutboundDO.class, warehouseColumn = "outbound_warehouse_id")
    public PageResult<PreOutboundRespVO> queryPageList(PreOutboundPageReqVO bo, PageParam pageQuery) {
        PageResult<PreOutboundDO> page = baseMapper.selectPage(pageQuery, buildQueryWrapper(bo));
        return new PageResult<>(page.getList().stream().map(this::toRespVO).toList(), page.getTotal());
    }

    @Override
    @OrgDataScope(tableClass = PreOutboundDO.class, warehouseColumn = "outbound_warehouse_id")
    public List<PreOutboundRespVO> queryList(PreOutboundPageReqVO bo) {
        return baseMapper.selectList(buildQueryWrapper(bo)).stream().map(this::toRespVO).toList();
    }

    @Override
    @OrgDataScope(tableClass = PreOutboundDO.class, warehouseColumn = "outbound_warehouse_id")
    public Map<String, Long> queryStatusCount(PreOutboundPageReqVO bo) {
        String status = bo == null ? null : bo.getPreOutboundStatus();
        if (bo != null) {
            bo.setPreOutboundStatus(null);
        }
        try {
            return baseMapper.selectList(buildQueryWrapper(bo)).stream()
                .filter(item -> StrUtil.isNotBlank(item.getPreOutboundStatus()))
                .collect(Collectors.groupingBy(PreOutboundDO::getPreOutboundStatus, Collectors.counting()));
        } finally {
            if (bo != null) {
                bo.setPreOutboundStatus(status);
            }
        }
    }

    private PreOutboundRespVO toRespVO(PreOutboundDO row) {
        if (row == null) {
            return null;
        }
        PreOutboundRespVO vo = BeanUtils.toBean(row, PreOutboundRespVO.class);
        vo.setCreateBy(row.getCreator());
        return vo;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public List<PreOutboundItemRespVO> queryItems(Long id) {
        PreOutboundDO preOutbound = requireEditablePreOutbound(id);
        ensureLegacyItem(preOutbound);
        List<PreOutboundItemDO> items = listItems(preOutbound.getId());
        return items.stream()
            .map(item -> toItemRespVO(item, loadCargoOrder(item.getCargoOrderId())))
            .toList();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean addItems(Long id, PreOutboundItemsReqVO bo) {
        PreOutboundDO preOutbound = requireEditablePreOutbound(id);
        if (bo == null || bo.getCargoOrderIds() == null || bo.getCargoOrderIds().isEmpty()) {
            throw exception(OMS_BIZ_ERROR, "cargoOrderIds is required");
        }
        for (Long cargoOrderId : bo.getCargoOrderIds()) {
            attachCargoOrder(preOutbound, cargoOrderId);
        }
        refreshHeaderAggregate(preOutbound.getId());
        containerPrePlanSummaryService.refreshByPreOutboundId(preOutbound.getId());
        return Boolean.TRUE;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean removeItem(Long id, Long itemId) {
        PreOutboundDO preOutbound = requireEditablePreOutbound(id);
        PreOutboundItemDO item = itemMapper.selectById(itemId);
        if (item == null || !Objects.equals(item.getPreOutboundId(), id)) {
            throw exception(OMS_BIZ_ERROR, "pre-outbound item not found");
        }
        if (listItems(id).size() <= 1) {
            throw exception(OMS_BIZ_ERROR, "cannot remove the last pre-outbound item in normal flow");
        }
        Long cargoOrderId = item.getCargoOrderId();
        releaseCargoOrder(cargoOrderId);
        bizRootRelationMapper.deactivateByTargetAndCargo("PRE_OUTBOUND", id, cargoOrderId);
        itemMapper.deleteById(itemId);
        List<PreOutboundItemDO> remain = listItems(id);
        if (remain.isEmpty()) {
            resetHeaderToEmpty(preOutbound);
            containerPrePlanSummaryService.refreshByCargoOrderId(cargoOrderId);
            return Boolean.TRUE;
        }
        refreshHeaderAggregate(id);
        containerPrePlanSummaryService.refreshByPreOutboundId(id);
        return Boolean.TRUE;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public OutboundOrderRespVO convert(Long id, OutboundCreateReqVO bo) {
        PreOutboundDO preOutbound = baseMapper.selectById(id);
        if (preOutbound == null) throw exception(OMS_BIZ_ERROR, "pre-outbound order not found");
        if ("CONVERTED".equals(preOutbound.getPreOutboundStatus())) throw exception(OMS_BIZ_ERROR, "pre-outbound order converted");
        if ("CANCELLED".equals(preOutbound.getPreOutboundStatus())) throw exception(OMS_BIZ_ERROR, "pre-outbound order cancelled");
        if (!"READY_TO_CONVERT".equals(preOutbound.getPreOutboundStatus())) {
            throw exception(OMS_BIZ_ERROR, "pre-outbound order is not ready to convert");
        }
        ensureLegacyItem(preOutbound);
        List<PreOutboundItemDO> items = listItems(id);
        if (items.isEmpty()) throw exception(OMS_BIZ_ERROR, "pre-outbound has no items");

        // validate all items and collect cargo orders in same order as items list
        List<CargoOrderDO> cargoOrders = new ArrayList<>();
        for (PreOutboundItemDO item : items) {
            CargoOrderDO order = cargoOrderMapper.selectById(item.getCargoOrderId());
            if (order == null) throw exception(OMS_BIZ_ERROR, "cargo order not found");
            if (!OutboundReadinessUtils.INBOUNDED.equals(OutboundReadinessUtils.resolveReadiness(order))) {
                throw exception(OMS_BIZ_ERROR, String.valueOf("cargo order is not fully inbounded: " + order.getCargoOrderNo()));
            }
            if (StrUtil.isNotBlank(order.getOutboundOrderStatus()) && !"NONE".equals(order.getOutboundOrderStatus())) {
                throw exception(OMS_BIZ_ERROR, "cargo order already has outbound order");
            }
            cargoOrders.add(order);
        }

        OutboundOrderDO outboundOrder = new OutboundOrderDO();
        outboundOrder.setBizRootIds(StrUtil.isBlank(preOutbound.getBizRootIds())
            ? joinBizRootIds(cargoOrders)
            : preOutbound.getBizRootIds());
        outboundOrder.setPreOutboundId(preOutbound.getId());
        outboundOrder.setPreOutboundNo(preOutbound.getPreOutboundNo());
        outboundOrder.setCargoOrderCount(cargoOrders.size());
        outboundOrder.setCargoOrderId(cargoOrders.get(0).getId());
        outboundOrder.setCargoOrderNo(joinCargoOrderNos(cargoOrders));
        outboundOrder.setOutboundOrderNo("OB" + IdUtil.getSnowflakeNextIdStr());
        outboundOrder.setOutboundStatus("CREATED");
        outboundOrder.setOutboundDirection(StrUtil.isBlank(bo.getOutboundDirection()) ? preOutbound.getOutboundDirection() : bo.getOutboundDirection());
        outboundOrder.setOutboundWarehouseId(bo.getOutboundWarehouseId() == null ? preOutbound.getOutboundWarehouseId() : bo.getOutboundWarehouseId());
        outboundOrder.setOutboundWarehouseName(StrUtil.isBlank(bo.getOutboundWarehouseName()) ? preOutbound.getOutboundWarehouseName() : bo.getOutboundWarehouseName());
        outboundOrder.setCustomerName(preOutbound.getCustomerName());
        outboundOrder.setContainerNo(preOutbound.getContainerNo());
        outboundOrder.setShipmentCodes(preOutbound.getShipmentCodes());
        outboundOrder.setActualCartonQty(sum(cargoOrders, CargoOrderDO::getActualCartonQty));
        outboundOrder.setActualPalletQty(sum(cargoOrders, CargoOrderDO::getActualPalletQty));
        outboundOrder.setActualWeight(sum(cargoOrders, CargoOrderDO::getActualWeight));
        outboundOrder.setActualCbm(sum(cargoOrders, CargoOrderDO::getActualCbm));
        outboundOrder.setDeliveryMethod(bo.getDeliveryMethod());
        outboundOrder.setAppointmentStatus(StrUtil.isBlank(bo.getAppointmentStatus()) ? "NONE" : bo.getAppointmentStatus());
        outboundOrder.setTransferInWarehouseId(bo.getTransferInWarehouseId());
        outboundOrder.setTransferMethod(bo.getTransferMethod());
        outboundOrder.setTransferReason(bo.getTransferReason());
        outboundOrder.setPodStatus("PENDING");
        outboundOrder.setRemark(bo.getRemark());
        outboundOrderMapper.insert(outboundOrder);

        // create OutboundOrderItemDO per item, linking back to pre-outbound item for traceability
        for (int i = 0; i < items.size(); i++) {
            PreOutboundItemDO preItem = items.get(i);
            CargoOrderDO cargoOrder = cargoOrders.get(i);
            OutboundOrderItemDO orderItem = new OutboundOrderItemDO();
            orderItem.setOutboundOrderId(outboundOrder.getId());
            orderItem.setOutboundOrderNo(outboundOrder.getOutboundOrderNo());
            orderItem.setCargoOrderId(cargoOrder.getId());
            orderItem.setCargoOrderNo(cargoOrder.getCargoOrderNo());
            orderItem.setPreOutboundItemId(preItem.getId());
            orderItem.setActualCartonQty(cargoOrder.getActualCartonQty());
            orderItem.setActualPalletQty(cargoOrder.getActualPalletQty());
            orderItem.setActualWeight(cargoOrder.getActualWeight());
            orderItem.setActualCbm(cargoOrder.getActualCbm());
            outboundOrderItemMapper.insert(orderItem);
            createRelation(cargoOrder, "OUTBOUND_ORDER", outboundOrder.getId(),
                outboundOrder.getOutboundOrderNo(), "EXECUTION");
        }

        PreOutboundDO preUpdate = new PreOutboundDO();
        preUpdate.setId(preOutbound.getId());
        preUpdate.setPreOutboundStatus("CONVERTED");
        preUpdate.setConvertedTime(new Date());
        preUpdate.setOutboundOrderNo(outboundOrder.getOutboundOrderNo());
        preUpdate.setAppointmentNo(StrUtil.isBlank(bo.getAppointmentNo()) ? preOutbound.getAppointmentNo() : bo.getAppointmentNo());
        preUpdate.setAppointmentTime(bo.getAppointmentTime() == null ? preOutbound.getAppointmentTime() : bo.getAppointmentTime());
        preUpdate.setDeliveryTruck(StrUtil.isBlank(bo.getDeliveryTruck()) ? preOutbound.getDeliveryTruck() : bo.getDeliveryTruck());
        preUpdate.setLoadingType(StrUtil.isBlank(bo.getLoadingType()) ? preOutbound.getLoadingType() : bo.getLoadingType());
        preUpdate.setTransportType(StrUtil.isBlank(bo.getTransportType()) ? preOutbound.getTransportType() : bo.getTransportType());
        preUpdate.setDeliveryTag(StrUtil.isBlank(bo.getDeliveryTag()) ? preOutbound.getDeliveryTag() : bo.getDeliveryTag());
        preUpdate.setDestination(StrUtil.isBlank(bo.getDestination()) ? preOutbound.getDestination() : bo.getDestination());
        preUpdate.setDeliveryMethod(StrUtil.isBlank(bo.getDeliveryMethod()) ? preOutbound.getDeliveryMethod() : bo.getDeliveryMethod());
        preUpdate.setFollowRecord(StrUtil.isBlank(bo.getFollowRecord()) ? preOutbound.getFollowRecord() : bo.getFollowRecord());
        preUpdate.setRemark(StrUtil.isBlank(bo.getRemark()) ? preOutbound.getRemark() : bo.getRemark());
        baseMapper.updateById(preUpdate);

        Date now = new Date();
        for (CargoOrderDO cargoOrder : cargoOrders) {
            CargoOrderDO cargoUpdate = new CargoOrderDO();
            cargoUpdate.setId(cargoOrder.getId());
            cargoUpdate.setPreOutboundStatus("CONVERTED");
            cargoUpdate.setPreOutboundConvertTime(now);
            cargoUpdate.setOutboundBatchNo(outboundOrder.getOutboundOrderNo());
            cargoUpdate.setOutboundOrderStatus("CREATED");
            cargoUpdate.setOutboundOrderTime(now);
            cargoOrderMapper.updateById(cargoUpdate);
            lifecycleService.transitionCargo(cargoOrder.getId(), "OUTBOUND_ORDERED", "convertPreOutbound", "预出单转正式出库单", now);
        }
        containerPrePlanSummaryService.refreshByPreOutboundId(id);

        // 转单成功，预出单完成使命，逻辑删除（日志由 @Log + 出库单 preOutboundId/No 字段保留可追溯）
        itemMapper.delete(Wrappers.<PreOutboundItemDO>lambdaQuery().eq(PreOutboundItemDO::getPreOutboundId, id));
        bizRootRelationMapper.deactivateByTarget("PRE_OUTBOUND", id);
        baseMapper.deleteById(id);

        return BeanUtils.toBean(outboundOrderMapper.selectById(outboundOrder.getId()), OutboundOrderRespVO.class);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean updateByBo(Long id, PreOutboundUpdateReqVO bo) {
        PreOutboundDO preOutbound = baseMapper.selectById(id);
        if (preOutbound == null) {
            throw exception(OMS_BIZ_ERROR, "pre-outbound order not found");
        }
        if ("CONVERTED".equals(preOutbound.getPreOutboundStatus())) {
            throw exception(OMS_BIZ_ERROR, "converted pre-outbound order cannot be edited");
        }
        PreOutboundDO update = new PreOutboundDO();
        update.setId(id);
        if (StrUtil.isNotBlank(bo.getOutboundDirection())) {
            update.setOutboundDirection(bo.getOutboundDirection());
        }
        update.setAppointmentNo(bo.getAppointmentNo());
        update.setAppointmentTime(bo.getAppointmentTime());
        update.setDeliveryTruck(bo.getDeliveryTruck());
        update.setLoadingType(bo.getLoadingType());
        update.setTransportType(bo.getTransportType());
        update.setDeliveryTag(bo.getDeliveryTag());
        update.setFollowRecord(bo.getFollowRecord());
        update.setRemark(bo.getRemark());
        return baseMapper.updateById(update) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean manualAdjustStatus(Long id, OmsManualStatusReqVO bo) {
        OmsStatusTransitionGuard.requireManualReason(bo.getReason());
        PreOutboundDO preOutbound = baseMapper.selectById(id);
        if (preOutbound == null) {
            throw exception(OMS_BIZ_ERROR, "pre-outbound order not found");
        }
        if (StrUtil.equals(preOutbound.getPreOutboundStatus(), bo.getTargetStatus())) {
            return true;
        }
        PreOutboundDO update = new PreOutboundDO();
        update.setId(id);
        update.setPreOutboundStatus(bo.getTargetStatus());
        update.setRemark(appendStatusRemark(preOutbound.getRemark(), preOutbound.getPreOutboundStatus(), bo.getTargetStatus(), bo.getReason()));
        return baseMapper.updateById(update) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean deleteWithValid(Long id) {
        PreOutboundDO preOutbound = baseMapper.selectById(id);
        if (preOutbound == null) throw exception(OMS_BIZ_ERROR, "pre-outbound order not found");

        ensureLegacyItem(preOutbound);
        List<Long> cargoOrderIds = new ArrayList<>();
        for (PreOutboundItemDO item : listItems(id)) {
            CargoOrderDO cargoUpdate = new CargoOrderDO();
            cargoUpdate.setId(item.getCargoOrderId());
            cargoUpdate.setPreOutboundFlag(0);
            cargoUpdate.setPreOutboundNo(null);
            cargoUpdate.setPreOutboundStatus("NONE");
            cargoUpdate.setPreOutboundTime(null);
            cargoOrderMapper.updateById(cargoUpdate);
            cargoOrderIds.add(item.getCargoOrderId());
        }

        itemMapper.delete(Wrappers.<PreOutboundItemDO>lambdaQuery().eq(PreOutboundItemDO::getPreOutboundId, id));
        bizRootRelationMapper.deactivateByTarget("PRE_OUTBOUND", id);
        baseMapper.deleteById(id);

        cargoOrderIds.forEach(containerPrePlanSummaryService::refreshByCargoOrderId);
        return Boolean.TRUE;
    }

    public void createItem(PreOutboundDO preOutbound, CargoOrderDO order) {
        PreOutboundItemDO item = new PreOutboundItemDO();
        item.setPreOutboundId(preOutbound.getId());
        item.setPreOutboundNo(preOutbound.getPreOutboundNo());
        item.setCargoOrderId(order.getId());
        item.setCargoOrderNo(order.getCargoOrderNo());
        itemMapper.insert(item);
        createRelation(order, "PRE_OUTBOUND", preOutbound.getId(), preOutbound.getPreOutboundNo(), "AGGREGATED");
    }

    private PreOutboundDO requireEditablePreOutbound(Long id) {
        PreOutboundDO preOutbound = baseMapper.selectById(id);
        if (preOutbound == null) {
            throw exception(OMS_BIZ_ERROR, "pre-outbound order not found");
        }
        if (List.of("CONVERTED", "CANCELLED").contains(preOutbound.getPreOutboundStatus())) {
            throw exception(OMS_BIZ_ERROR, "pre-outbound order status cannot be edited");
        }
        return preOutbound;
    }

    private void ensureLegacyItem(PreOutboundDO preOutbound) {
        List<PreOutboundItemDO> items = listItems(preOutbound.getId());
        if (!items.isEmpty()) {
            return;
        }
        List<CargoOrderDO> orders = resolveLegacyCargoOrders(preOutbound);
        if (orders.isEmpty()) {
            return;
        }
        for (CargoOrderDO order : orders) {
            createOrRestoreItem(preOutbound, order);
            if (!Objects.equals(order.getPreOutboundFlag(), 1)
                || !Objects.equals(order.getPreOutboundNo(), preOutbound.getPreOutboundNo())) {
                markCargoPreOutbound(order, preOutbound);
            }
        }
        if (preOutbound.getCargoOrderCount() == null || preOutbound.getCargoOrderCount() <= 0) {
            refreshHeaderAggregate(preOutbound.getId());
        }
    }

    private CargoOrderDO loadCargoOrder(Long cargoOrderId) {
        if (cargoOrderId == null) {
            return null;
        }
        return cargoOrderMapper.selectById(cargoOrderId);
    }

    private void createOrRestoreItem(PreOutboundDO preOutbound, CargoOrderDO order) {
        Long exists = itemMapper.selectCount(Wrappers.<PreOutboundItemDO>lambdaQuery()
            .eq(PreOutboundItemDO::getPreOutboundId, preOutbound.getId())
            .eq(PreOutboundItemDO::getCargoOrderId, order.getId()));
        if (exists != null && exists > 0) {
            return;
        }
        try {
            createItem(preOutbound, order);
        } catch (DuplicateKeyException ex) {
            int restored = itemMapper.restoreDeletedItem(
                preOutbound.getId(), preOutbound.getPreOutboundNo(), order.getId(), order.getCargoOrderNo());
            if (restored <= 0) {
                throw ex;
            }
        }
    }

    /** 历史数据：头表有运单号/关联字段，但 oms_pre_outbound_item 为空时反查货物订单 */
    private List<CargoOrderDO> resolveLegacyCargoOrders(PreOutboundDO preOutbound) {
        LinkedHashMap<Long, CargoOrderDO> orderMap = new LinkedHashMap<>();
        if (preOutbound.getCargoOrderId() != null) {
            CargoOrderDO order = cargoOrderMapper.selectById(preOutbound.getCargoOrderId());
            if (order != null) {
                orderMap.put(order.getId(), order);
            }
        }
        if (StrUtil.isNotBlank(preOutbound.getCargoOrderNo())) {
            for (String no : preOutbound.getCargoOrderNo().split("[,;，、\\s]+")) {
                if (StrUtil.isBlank(no)) {
                    continue;
                }
                CargoOrderDO order = cargoOrderMapper.selectOne(Wrappers.<CargoOrderDO>lambdaQuery()
                    .eq(CargoOrderDO::getCargoOrderNo, no.trim())
                    .last("LIMIT 1"));
                if (order != null) {
                    orderMap.put(order.getId(), order);
                }
            }
        }
        if (orderMap.isEmpty() && StrUtil.isNotBlank(preOutbound.getPreOutboundNo())) {
            List<CargoOrderDO> linked = cargoOrderMapper.selectList(Wrappers.<CargoOrderDO>lambdaQuery()
                .eq(CargoOrderDO::getPreOutboundNo, preOutbound.getPreOutboundNo()));
            for (CargoOrderDO order : linked) {
                orderMap.put(order.getId(), order);
            }
        }
        return new ArrayList<>(orderMap.values());
    }

    private List<PreOutboundItemDO> listItems(Long preOutboundId) {
        return itemMapper.selectList(Wrappers.<PreOutboundItemDO>lambdaQuery()
            .eq(PreOutboundItemDO::getPreOutboundId, preOutboundId)
            .orderByAsc(PreOutboundItemDO::getCreateTime));
    }

    private void attachCargoOrder(PreOutboundDO preOutbound, Long cargoOrderId) {
        CargoOrderDO order = cargoOrderMapper.selectById(cargoOrderId);
        if (order == null) {
            throw exception(OMS_BIZ_ERROR, "cargo order not found");
        }
        validatePoolOrder(order);
        Long exists = itemMapper.selectCount(Wrappers.<PreOutboundItemDO>lambdaQuery()
            .eq(PreOutboundItemDO::getPreOutboundId, preOutbound.getId())
            .eq(PreOutboundItemDO::getCargoOrderId, cargoOrderId));
        if (exists != null && exists > 0) {
            throw exception(OMS_BIZ_ERROR, String.valueOf("cargo order already in pre-outbound: " + order.getCargoOrderNo()));
        }
        createItem(preOutbound, order);
        markCargoPreOutbound(order, preOutbound);
    }

    private void releaseCargoOrder(Long cargoOrderId) {
        CargoOrderDO update = new CargoOrderDO();
        update.setId(cargoOrderId);
        update.setPreOutboundFlag(0);
        update.setPreOutboundNo(null);
        update.setPreOutboundStatus("NONE");
        update.setPreOutboundTime(null);
        cargoOrderMapper.updateById(update);
    }

    private void markCargoPreOutbound(CargoOrderDO order, PreOutboundDO preOutbound) {
        CargoOrderDO update = new CargoOrderDO();
        update.setId(order.getId());
        update.setPreOutboundFlag(1);
        update.setPreOutboundNo(preOutbound.getPreOutboundNo());
        update.setPreOutboundStatus("PRE_CREATED");
        update.setPreOutboundTime(new Date());
        cargoOrderMapper.updateById(update);
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
    }

    private void refreshHeaderAggregate(Long preOutboundId) {
        PreOutboundDO preOutbound = baseMapper.selectById(preOutboundId);
        if (preOutbound == null) {
            return;
        }
        List<PreOutboundItemDO> items = listItems(preOutboundId);
        if (items.isEmpty()) {
            resetHeaderToEmpty(preOutbound);
            return;
        }
        List<CargoOrderDO> orders = new ArrayList<>();
        List<String> readinessList = new ArrayList<>();
        for (PreOutboundItemDO item : items) {
            CargoOrderDO order = loadCargoOrder(item.getCargoOrderId());
            if (order == null) {
                continue;
            }
            orders.add(order);
            readinessList.add(OutboundReadinessUtils.resolveReadiness(order));
        }
        if (orders.isEmpty()) {
            return;
        }
        PreOutboundDO update = new PreOutboundDO();
        update.setId(preOutboundId);
        update.setCargoOrderCount(orders.size());
        update.setBizRootId(null);
        update.setBizRootIds(joinBizRootIds(orders));
        update.setCargoOrderId(orders.get(0).getId());
        update.setCargoOrderNo(orders.stream().map(CargoOrderDO::getCargoOrderNo).collect(Collectors.joining(",")));
        update.setCustomerName(orders.get(0).getCustomerName());
        update.setContainerNo(orders.stream().map(CargoOrderDO::getContainerNo).filter(StrUtil::isNotBlank).distinct().collect(Collectors.joining(",")));
        update.setShipmentCodes(orders.stream().map(CargoOrderDO::getShipmentCodes).filter(StrUtil::isNotBlank).collect(Collectors.joining(",")));
        update.setDeclaredCartonQty(sum(orders, CargoOrderDO::getDeclaredCartonQty));
        update.setDeclaredPalletQty(sum(orders, CargoOrderDO::getDeclaredPalletQty));
        update.setDeclaredWeight(sum(orders, CargoOrderDO::getDeclaredWeight));
        update.setDeclaredCbm(sum(orders, CargoOrderDO::getDeclaredCbm));
        update.setActualCartonQty(sum(orders, CargoOrderDO::getActualCartonQty));
        update.setActualPalletQty(sum(orders, CargoOrderDO::getActualPalletQty));
        update.setActualWeight(sum(orders, CargoOrderDO::getActualWeight));
        update.setActualCbm(sum(orders, CargoOrderDO::getActualCbm));
        String status = OutboundReadinessUtils.resolveGroupPreOutboundStatus(readinessList);
        OmsStatusTransitionGuard.requireForward("pre-outbound order", OmsStatusTransitionGuard.PRE_OUTBOUND_FLOW,
            preOutbound.getPreOutboundStatus(), status);
        update.setPreOutboundStatus(status);
        update.setReadyTime("READY_TO_CONVERT".equals(status) ? new Date() : null);
        baseMapper.updateById(update);
    }

    private BigDecimal sum(List<CargoOrderDO> orders, java.util.function.Function<CargoOrderDO, BigDecimal> getter) {
        return orders.stream().map(getter).map(this::nvl).reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    private String joinCargoOrderNos(List<CargoOrderDO> orders) {
        return orders.stream()
            .map(CargoOrderDO::getCargoOrderNo)
            .filter(StrUtil::isNotBlank)
            .collect(Collectors.joining(","));
    }

    private String joinBizRootIds(List<CargoOrderDO> orders) {
        return orders.stream()
            .map(CargoOrderDO::getBizRootId)
            .filter(Objects::nonNull)
            .map(String::valueOf)
            .distinct()
            .collect(Collectors.joining(","));
    }

    private void createRelation(CargoOrderDO order, String targetType, Long targetId, String targetNo, String relationType) {
        if (order == null || order.getBizRootId() == null || targetId == null) {
            return;
        }
        Long exists = bizRootRelationMapper.selectCount(Wrappers.<BizRootRelationDO>lambdaQuery()
            .eq(BizRootRelationDO::getTargetType, targetType)
            .eq(BizRootRelationDO::getTargetId, targetId)
            .eq(BizRootRelationDO::getCargoOrderId, order.getId())
            .eq(BizRootRelationDO::getRelationStatus, "ACTIVE"));
        if (exists != null && exists > 0) {
            return;
        }
        BizRootRelationDO relation = new BizRootRelationDO();
        relation.setBizRootId(order.getBizRootId());
        relation.setCargoOrderId(order.getId());
        relation.setCargoOrderNo(order.getCargoOrderNo());
        relation.setTargetModule("OMS");
        relation.setTargetType(targetType);
        relation.setTargetId(targetId);
        relation.setTargetNo(targetNo);
        relation.setRelationType(relationType);
        relation.setRelationStatus("ACTIVE");
        bizRootRelationMapper.insert(relation);
    }

    private BigDecimal nvl(BigDecimal value) {
        return value == null ? BigDecimal.ZERO : value;
    }

    private String defaultDirection(String direction) {
        return StrUtil.isBlank(direction) ? "DELIVERY" : direction;
    }

    private String appendStatusRemark(String oldRemark, String from, String to, String reason) {
        String operator = StrUtil.blankToDefault(SecurityFrameworkUtils.getLoginUserNickname(),
            String.valueOf(SecurityFrameworkUtils.getLoginUserId()));
        String line = new Date() + " manual status " + from + " -> " + to
            + ", operator=" + operator + ", reason=" + reason;
        return StrUtil.isBlank(oldRemark) ? line : oldRemark + "\n" + line;
    }

    private void resetHeaderToEmpty(PreOutboundDO preOutbound) {
        PreOutboundDO update = new PreOutboundDO();
        update.setId(preOutbound.getId());
        update.setCargoOrderCount(0);
        update.setBizRootId(null);
        update.setBizRootIds(null);
        update.setCargoOrderId(null);
        update.setCargoOrderNo(null);
        update.setCustomerName(null);
        update.setContainerNo(null);
        update.setShipmentCodes(null);
        update.setDeclaredCartonQty(BigDecimal.ZERO);
        update.setDeclaredPalletQty(BigDecimal.ZERO);
        update.setDeclaredWeight(BigDecimal.ZERO);
        update.setDeclaredCbm(BigDecimal.ZERO);
        update.setActualCartonQty(BigDecimal.ZERO);
        update.setActualPalletQty(BigDecimal.ZERO);
        update.setActualWeight(BigDecimal.ZERO);
        update.setActualCbm(BigDecimal.ZERO);
        update.setEarliestDwTime(null);
        update.setDeliveryLfd(null);
        update.setPreOutboundStatus("PENDING_INBOUND");
        update.setReadyTime(null);
        baseMapper.updateById(update);
    }

    private PreOutboundItemRespVO toItemRespVO(PreOutboundItemDO item, CargoOrderDO order) {
        PreOutboundItemRespVO vo = new PreOutboundItemRespVO();
        vo.setId(item.getId());
        vo.setPreOutboundId(item.getPreOutboundId());
        vo.setPreOutboundNo(item.getPreOutboundNo());
        vo.setCargoOrderId(item.getCargoOrderId());
        vo.setCargoOrderNo(item.getCargoOrderNo());
        if (order != null) {
            vo.setContainerNo(order.getContainerNo());
            vo.setShipmentCodes(order.getShipmentCodes());
            vo.setPoNos(order.getPoNos());
            vo.setPlatformWarehouseCode(order.getPlatformWarehouseCode());
            vo.setFulfillmentStatus(order.getFulfillmentStatus());
            vo.setReadiness(OutboundReadinessUtils.resolveReadiness(order));
            vo.setDeclaredCartonQty(order.getDeclaredCartonQty());
            vo.setActualCartonQty(order.getActualCartonQty());
            vo.setDeclaredPalletQty(order.getDeclaredPalletQty());
            vo.setActualPalletQty(order.getActualPalletQty());
            vo.setActualWeight(order.getActualWeight());
            vo.setActualCbm(order.getActualCbm());
        }
        return vo;
    }

    private LambdaQueryWrapper<PreOutboundDO> buildQueryWrapper(PreOutboundPageReqVO bo) {
        LambdaQueryWrapper<PreOutboundDO> lqw = Wrappers.lambdaQuery();
        if (bo != null) {
            OmsLambdaQueryHelper.inStringCsv(lqw, PreOutboundDO::getPreOutboundStatus, bo.getPreOutboundStatus());
            OmsLambdaQueryHelper.inStringCsv(lqw, PreOutboundDO::getOutboundDirection, bo.getOutboundDirection());
            OmsLambdaQueryHelper.inLongCsv(lqw, PreOutboundDO::getOutboundWarehouseId, bo.getOutboundWarehouseId());
            lqw.like(StrUtil.isNotBlank(bo.getPreOutboundNo()), PreOutboundDO::getPreOutboundNo, bo.getPreOutboundNo());
            lqw.like(StrUtil.isNotBlank(bo.getCargoOrderNo()), PreOutboundDO::getCargoOrderNo, bo.getCargoOrderNo());
            lqw.like(StrUtil.isNotBlank(bo.getContainerNo()), PreOutboundDO::getContainerNo, bo.getContainerNo());
            lqw.like(StrUtil.isNotBlank(bo.getShipmentCodes()), PreOutboundDO::getShipmentCodes, bo.getShipmentCodes());
            lqw.like(StrUtil.isNotBlank(bo.getCustomerName()), PreOutboundDO::getCustomerName, bo.getCustomerName());
            lqw.like(StrUtil.isNotBlank(bo.getAppointmentNo()), PreOutboundDO::getAppointmentNo, bo.getAppointmentNo());
            lqw.like(StrUtil.isNotBlank(bo.getDeliveryTruck()), PreOutboundDO::getDeliveryTruck, bo.getDeliveryTruck());
            lqw.ge(bo.getBeginReadyTime() != null, PreOutboundDO::getReadyTime, bo.getBeginReadyTime());
            lqw.le(bo.getEndReadyTime() != null, PreOutboundDO::getReadyTime, bo.getEndReadyTime());
            lqw.ge(bo.getBeginCreateTime() != null, PreOutboundDO::getCreateTime, bo.getBeginCreateTime());
            lqw.le(bo.getEndCreateTime() != null, PreOutboundDO::getCreateTime, bo.getEndCreateTime());
            if (StrUtil.isNotBlank(bo.getKeyword())) {
                lqw.and(w -> w.like(PreOutboundDO::getPreOutboundNo, bo.getKeyword())
                    .or().like(PreOutboundDO::getCargoOrderNo, bo.getKeyword())
                    .or().like(PreOutboundDO::getContainerNo, bo.getKeyword())
                    .or().like(PreOutboundDO::getShipmentCodes, bo.getKeyword()));
            }
        }
        lqw.orderByDesc(PreOutboundDO::getCreateTime);
        return lqw;
    }
}
