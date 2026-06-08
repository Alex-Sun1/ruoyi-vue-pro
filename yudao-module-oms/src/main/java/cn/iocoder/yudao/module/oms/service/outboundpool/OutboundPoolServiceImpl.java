package cn.iocoder.yudao.module.oms.service.outboundpool;

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
import cn.iocoder.yudao.module.oms.dal.dataobject.biz.BizRootRelationDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder.CargoOrderDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.outboundorder.OutboundOrderDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.preoutbound.PreOutboundDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.preoutbound.PreOutboundItemDO;
import cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo.OutboundCreateReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.outboundpool.vo.OutboundPoolQueryReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo.OutboundOrderRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.outboundpool.vo.OutboundPoolStatsRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.preoutbound.vo.PreOutboundRespVO;
import cn.iocoder.yudao.module.oms.dal.dataobject.outboundorder.OutboundOrderItemDO;
import cn.iocoder.yudao.module.oms.dal.mysql.biz.BizRootRelationMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.cargoorder.CargoOrderMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.outboundorder.OutboundOrderItemMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.outboundorder.OutboundOrderMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.preoutbound.PreOutboundItemMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.preoutbound.PreOutboundMapper;
import cn.iocoder.yudao.module.oms.service.cargoorder.CargoOrderService;
import cn.iocoder.yudao.module.oms.service.outboundpool.OutboundPoolService;
import cn.iocoder.yudao.module.oms.service.omsbizlifecycle.OmsBizLifecycleService;
import cn.iocoder.yudao.module.oms.support.ContainerPrePlanSummaryService;
import cn.iocoder.yudao.module.oms.support.OmsLambdaQueryHelper;
import cn.iocoder.yudao.module.oms.support.OutboundReadinessUtils;
import cn.iocoder.yudao.module.org.framework.datapermission.annotation.OrgDataScope;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Objects;

@Service
public class OutboundPoolServiceImpl implements OutboundPoolService {

    private static final List<String> POOL_STATUSES = List.of(
        "PENDING_ACCEPT", "ACCEPTED", "IN_TRANSIT", "ARRIVED_PORT", "PICKED_UP",
        "ARRIVED_WAREHOUSE", "DEVANNING", "DEVANNED", "INBOUNDED"
    );

    private static final String READY_NOT_INBOUNDED = "NOT_INBOUNDED";
    private static final String READY_DEVANNING = "DEVANNING";
    private static final String READY_INBOUNDED = "INBOUNDED";

    @Resource
    private CargoOrderMapper cargoOrderMapper;
    @Resource
    private PreOutboundMapper preOutboundMapper;
    @Resource
    private PreOutboundItemMapper preOutboundItemMapper;
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
    @Resource
    private CargoOrderService cargoOrderService;

    @Override
    @OrgDataScope(tableClass = CargoOrderDO.class, warehouseColumn = "inbound_warehouse_id")
    public PageResult<CargoOrderRespVO> queryPageList(OutboundPoolQueryReqVO bo, PageParam pageQuery) {
        PageResult<CargoOrderDO> page = cargoOrderMapper.selectPage(pageQuery, buildPoolWrapper(bo));
        return new PageResult<>(BeanUtils.toBean(page.getList(), CargoOrderRespVO.class), page.getTotal());
    }

    @Override
    @OrgDataScope(tableClass = CargoOrderDO.class, warehouseColumn = "inbound_warehouse_id")
    public OutboundPoolStatsRespVO queryStats(OutboundPoolQueryReqVO bo) {
        List<CargoOrderDO> list = cargoOrderMapper.selectList(buildPoolWrapper(bo));
        OutboundPoolStatsRespVO stats = new OutboundPoolStatsRespVO();
        Date now = new Date();
        for (CargoOrderDO order : list) {
            String readiness = OutboundReadinessUtils.resolveReadiness(order);
            BigDecimal cbm = READY_INBOUNDED.equals(readiness) ? nvl(order.getActualCbm()) : nvl(order.getDeclaredCbm());
            BigDecimal weight = READY_INBOUNDED.equals(readiness) ? nvl(order.getActualWeight()) : nvl(order.getDeclaredWeight());
            BigDecimal palletQty = READY_INBOUNDED.equals(readiness) ? nvl(order.getActualPalletQty()) : nvl(order.getDeclaredPalletQty());
            BigDecimal cartonQty = READY_INBOUNDED.equals(readiness) ? nvl(order.getActualCartonQty()) : nvl(order.getDeclaredCartonQty());
            stats.setTotalCount(stats.getTotalCount() + 1);
            stats.setTotalCbm(stats.getTotalCbm().add(cbm));
            stats.setTotalWeight(stats.getTotalWeight().add(weight));
            stats.setTotalPalletQty(stats.getTotalPalletQty().add(palletQty));
            stats.setTotalCartonQty(stats.getTotalCartonQty().add(cartonQty));
            if (READY_NOT_INBOUNDED.equals(readiness)) {
                stats.setNotInboundedCount(stats.getNotInboundedCount() + 1);
                stats.setInTransitCbm(stats.getInTransitCbm().add(cbm));
            } else if (READY_DEVANNING.equals(readiness)) {
                stats.setDevanningCount(stats.getDevanningCount() + 1);
                stats.setDevanningCbm(stats.getDevanningCbm().add(cbm));
            } else {
                stats.setInboundedCount(stats.getInboundedCount() + 1);
                stats.setInboundedCbm(stats.getInboundedCbm().add(cbm));
            }
            if (order.getDeliveryLfd() != null && order.getDeliveryLfd().before(now)) {
                stats.setOverdueDeliveryLfdCount(stats.getOverdueDeliveryLfdCount() + 1);
            }
            if (order.getEarliestDwTime() != null && order.getEarliestDwTime().before(now)) {
                stats.setOverdueDwCount(stats.getOverdueDwCount() + 1);
            }
        }
        return stats;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public PreOutboundRespVO createPreOutbound(OutboundCreateReqVO bo) {
        CargoOrderDO order = requireCargoOrder(bo.getCargoOrderId());
        validatePoolOrder(order, false);
        PreOutboundDO preOutbound = buildPreOutbound(order, bo);
        preOutboundMapper.insert(preOutbound);

        PreOutboundItemDO item = new PreOutboundItemDO();
        item.setPreOutboundId(preOutbound.getId());
        item.setPreOutboundNo(preOutbound.getPreOutboundNo());
        item.setCargoOrderId(order.getId());
        item.setCargoOrderNo(order.getCargoOrderNo());
        preOutboundItemMapper.insert(item);
        createRelation(order, "PRE_OUTBOUND", preOutbound.getId(), preOutbound.getPreOutboundNo(), "AGGREGATED");

        CargoOrderDO update = new CargoOrderDO();
        update.setId(order.getId());
        update.setPreOutboundFlag(1);
        update.setPreOutboundNo(preOutbound.getPreOutboundNo());
        update.setPreOutboundStatus("PRE_CREATED");
        update.setPreOutboundTime(new Date());
        cargoOrderMapper.updateById(update);
        applyTransferIfNeeded(order.getId(), bo);
        containerPrePlanSummaryService.refreshByCargoOrderId(order.getId());
        return BeanUtils.toBean(preOutboundMapper.selectById(preOutbound.getId()), PreOutboundRespVO.class);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public OutboundOrderRespVO createOutboundOrder(OutboundCreateReqVO bo) {
        CargoOrderDO order = requireCargoOrder(bo.getCargoOrderId());
        validatePoolOrder(order, true);
        applyTransferIfNeeded(order.getId(), bo);
        OutboundOrderDO outboundOrder = buildOutboundOrder(List.of(order), null, bo);
        outboundOrderMapper.insert(outboundOrder);
        createOutboundOrderItem(outboundOrder, order, null);
        createRelation(order, "OUTBOUND_ORDER", outboundOrder.getId(), outboundOrder.getOutboundOrderNo(), "EXECUTION");
        markCargoOutbound(order, outboundOrder.getOutboundOrderNo());
        containerPrePlanSummaryService.refreshByCargoOrderId(order.getId());
        return BeanUtils.toBean(outboundOrderMapper.selectById(outboundOrder.getId()), OutboundOrderRespVO.class);
    }

    /**
     * 批量创建预出单：N 个货物订单合并为 1 个预出单（含 N 条 item）
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean batchCreatePreOutbound(OutboundCreateReqVO bo) {
        List<Long> cargoOrderIds = bo.getCargoOrderIds();
        if (cargoOrderIds == null || cargoOrderIds.isEmpty()) {
            throw exception(OMS_BIZ_ERROR, "cargoOrderIds is required");
        }
        List<CargoOrderDO> orders = new ArrayList<>();
        for (Long id : cargoOrderIds) {
            CargoOrderDO order = requireCargoOrder(id);
            validatePoolOrder(order, false);
            orders.add(order);
        }

        PreOutboundDO preOutbound = buildPreOutboundForBatch(orders, bo);
        preOutboundMapper.insert(preOutbound);

        List<String> readinessList = new ArrayList<>();
        BigDecimal sumDeclaredCarton = BigDecimal.ZERO, sumDeclaredPallet = BigDecimal.ZERO;
        BigDecimal sumDeclaredWeight = BigDecimal.ZERO, sumDeclaredCbm = BigDecimal.ZERO;
        BigDecimal sumActualCarton = BigDecimal.ZERO, sumActualPallet = BigDecimal.ZERO;
        BigDecimal sumActualWeight = BigDecimal.ZERO, sumActualCbm = BigDecimal.ZERO;

        for (CargoOrderDO order : orders) {
            PreOutboundItemDO item = new PreOutboundItemDO();
            item.setPreOutboundId(preOutbound.getId());
            item.setPreOutboundNo(preOutbound.getPreOutboundNo());
            item.setCargoOrderId(order.getId());
            item.setCargoOrderNo(order.getCargoOrderNo());
            preOutboundItemMapper.insert(item);
            createRelation(order, "PRE_OUTBOUND", preOutbound.getId(), preOutbound.getPreOutboundNo(), "AGGREGATED");

            CargoOrderDO update = new CargoOrderDO();
            update.setId(order.getId());
            update.setPreOutboundFlag(1);
            update.setPreOutboundNo(preOutbound.getPreOutboundNo());
            update.setPreOutboundStatus("PRE_CREATED");
            update.setPreOutboundTime(new Date());
            cargoOrderMapper.updateById(update);
            applyTransferIfNeeded(order.getId(), bo);

            readinessList.add(OutboundReadinessUtils.resolveReadiness(order));
            sumDeclaredCarton = sumDeclaredCarton.add(nvl(order.getDeclaredCartonQty()));
            sumDeclaredPallet = sumDeclaredPallet.add(nvl(order.getDeclaredPalletQty()));
            sumDeclaredWeight = sumDeclaredWeight.add(nvl(order.getDeclaredWeight()));
            sumDeclaredCbm    = sumDeclaredCbm.add(nvl(order.getDeclaredCbm()));
            sumActualCarton   = sumActualCarton.add(nvl(order.getActualCartonQty()));
            sumActualPallet   = sumActualPallet.add(nvl(order.getActualPalletQty()));
            sumActualWeight   = sumActualWeight.add(nvl(order.getActualWeight()));
            sumActualCbm      = sumActualCbm.add(nvl(order.getActualCbm()));
        }

        String aggregatedStatus = OutboundReadinessUtils.resolveGroupPreOutboundStatus(readinessList);
        PreOutboundDO header = new PreOutboundDO();
        header.setId(preOutbound.getId());
        header.setPreOutboundStatus(aggregatedStatus);
        header.setReadyTime("READY_TO_CONVERT".equals(aggregatedStatus) ? new Date() : null);
        header.setCargoOrderCount(orders.size());
        header.setContainerNo(orders.stream().map(CargoOrderDO::getContainerNo)
            .filter(StrUtil::isNotBlank).distinct().collect(java.util.stream.Collectors.joining(",")));
        header.setShipmentCodes(orders.stream().map(CargoOrderDO::getShipmentCodes)
            .filter(StrUtil::isNotBlank).collect(java.util.stream.Collectors.joining(",")));
        header.setDeclaredCartonQty(sumDeclaredCarton);
        header.setDeclaredPalletQty(sumDeclaredPallet);
        header.setDeclaredWeight(sumDeclaredWeight);
        header.setDeclaredCbm(sumDeclaredCbm);
        header.setActualCartonQty(sumActualCarton);
        header.setActualPalletQty(sumActualPallet);
        header.setActualWeight(sumActualWeight);
        header.setActualCbm(sumActualCbm);
        header.setEarliestDwTime(orders.stream().map(CargoOrderDO::getEarliestDwTime)
            .filter(Objects::nonNull).min(Date::compareTo).orElse(null));
        preOutboundMapper.updateById(header);

        containerPrePlanSummaryService.refreshByPreOutboundId(preOutbound.getId());
        return Boolean.TRUE;
    }

    /**
     * 批量创建出库单：N 个货物订单（全部已入库）合并为 1 个出库单（含 N 条 item）
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean batchCreateOutboundOrder(OutboundCreateReqVO bo) {
        List<Long> cargoOrderIds = bo.getCargoOrderIds();
        if (cargoOrderIds == null || cargoOrderIds.isEmpty()) {
            throw exception(OMS_BIZ_ERROR, "cargoOrderIds is required");
        }
        List<CargoOrderDO> orders = new ArrayList<>();
        for (Long id : cargoOrderIds) {
            CargoOrderDO order = requireCargoOrder(id);
            validatePoolOrder(order, true);
            orders.add(order);
        }

        OutboundOrderDO outboundOrder = buildOutboundOrder(orders, null, bo);
        outboundOrderMapper.insert(outboundOrder);

        for (CargoOrderDO order : orders) {
            applyTransferIfNeeded(order.getId(), bo);
            createOutboundOrderItem(outboundOrder, order, null);
            createRelation(order, "OUTBOUND_ORDER", outboundOrder.getId(), outboundOrder.getOutboundOrderNo(), "EXECUTION");
            markCargoOutbound(order, outboundOrder.getOutboundOrderNo());
            containerPrePlanSummaryService.refreshByCargoOrderId(order.getId());
        }
        return Boolean.TRUE;
    }

    @Override
    public CargoOrderRespVO queryCargoOrderDetail(Long cargoOrderId) {
        CargoOrderDO order = requireCargoOrder(cargoOrderId);
        validatePoolOrder(order, false);
        return cargoOrderService.queryById(cargoOrderId);
    }

    private LambdaQueryWrapper<CargoOrderDO> buildPoolWrapper(OutboundPoolQueryReqVO bo) {
        LambdaQueryWrapper<CargoOrderDO> lqw = Wrappers.lambdaQuery();
        lqw.in(CargoOrderDO::getFulfillmentStatus, POOL_STATUSES);
        lqw.and(w -> w.isNull(CargoOrderDO::getPreOutboundStatus).or().eq(CargoOrderDO::getPreOutboundStatus, "NONE"));
        lqw.and(w -> w.isNull(CargoOrderDO::getOutboundOrderStatus).or().eq(CargoOrderDO::getOutboundOrderStatus, "NONE"));
        lqw.and(w -> w.isNull(CargoOrderDO::getHoldFlag).or().eq(CargoOrderDO::getHoldFlag, 0));
        if (bo != null) {
            lqw.like(StrUtil.isNotBlank(bo.getCargoOrderNo()), CargoOrderDO::getCargoOrderNo, bo.getCargoOrderNo());
            lqw.like(StrUtil.isNotBlank(bo.getCustomerName()), CargoOrderDO::getCustomerName, bo.getCustomerName());
            lqw.like(StrUtil.isNotBlank(bo.getContainerNo()), CargoOrderDO::getContainerNo, bo.getContainerNo());
            lqw.like(StrUtil.isNotBlank(bo.getShipmentCodes()), CargoOrderDO::getShipmentCodes, bo.getShipmentCodes());
            lqw.like(StrUtil.isNotBlank(bo.getPlatformWarehouseCode()), CargoOrderDO::getPlatformWarehouseCode, bo.getPlatformWarehouseCode());
            lqw.like(StrUtil.isNotBlank(bo.getGroupCode()), CargoOrderDO::getGroupCode, bo.getGroupCode());
            lqw.like(StrUtil.isNotBlank(bo.getChannelName()), CargoOrderDO::getChannelName, bo.getChannelName());
            lqw.like(StrUtil.isNotBlank(bo.getBusinessTypeName()), CargoOrderDO::getBusinessTypeName, bo.getBusinessTypeName());
            OmsLambdaQueryHelper.inStringCsv(lqw, CargoOrderDO::getAddressType, bo.getAddressType());
            lqw.like(StrUtil.isNotBlank(bo.getCity()), CargoOrderDO::getCity, bo.getCity());
            lqw.like(StrUtil.isNotBlank(bo.getState()), CargoOrderDO::getState, bo.getState());
            lqw.like(StrUtil.isNotBlank(bo.getZipCode()), CargoOrderDO::getZipCode, bo.getZipCode());
            lqw.eq(bo.getTransferFlag() != null, CargoOrderDO::getTransferFlag, bo.getTransferFlag());
            lqw.ge(bo.getBeginCreateTime() != null, CargoOrderDO::getCreateTime, bo.getBeginCreateTime());
            lqw.le(bo.getEndCreateTime() != null, CargoOrderDO::getCreateTime, bo.getEndCreateTime());
            lqw.ge(bo.getBeginDeliveryLfd() != null, CargoOrderDO::getDeliveryLfd, bo.getBeginDeliveryLfd());
            lqw.le(bo.getEndDeliveryLfd() != null, CargoOrderDO::getDeliveryLfd, bo.getEndDeliveryLfd());
            lqw.ge(bo.getBeginEarliestDwTime() != null, CargoOrderDO::getEarliestDwTime, bo.getBeginEarliestDwTime());
            lqw.le(bo.getEndEarliestDwTime() != null, CargoOrderDO::getEarliestDwTime, bo.getEndEarliestDwTime());
            if (StrUtil.isNotBlank(bo.getKeyword())) {
                lqw.and(w -> w.like(CargoOrderDO::getCargoOrderNo, bo.getKeyword())
                    .or().like(CargoOrderDO::getShipmentCodes, bo.getKeyword())
                    .or().like(CargoOrderDO::getContainerNo, bo.getKeyword())
                    .or().like(CargoOrderDO::getExternalOrderNo, bo.getKeyword()));
            }
            if (Boolean.TRUE.equals(bo.getOverdueDeliveryLfd())) {
                lqw.lt(CargoOrderDO::getDeliveryLfd, new Date());
            }
            if (Boolean.TRUE.equals(bo.getOverdueDw())) {
                lqw.lt(CargoOrderDO::getEarliestDwTime, new Date());
            }
            applyReadinessFilter(lqw, bo.getReadiness());
        }
        lqw.orderByAsc(CargoOrderDO::getDeliveryLfd).orderByDesc(CargoOrderDO::getCreateTime);
        return lqw;
    }

    private void applyReadinessFilter(LambdaQueryWrapper<CargoOrderDO> lqw, String readiness) {
        if (READY_INBOUNDED.equals(readiness)) {
            lqw.eq(CargoOrderDO::getFulfillmentStatus, "INBOUNDED");
        } else if (READY_DEVANNING.equals(readiness)) {
            lqw.in(CargoOrderDO::getFulfillmentStatus, List.of("DEVANNING", "DEVANNED"));
        } else if (READY_NOT_INBOUNDED.equals(readiness)) {
            lqw.notIn(CargoOrderDO::getFulfillmentStatus, List.of("DEVANNING", "DEVANNED", "INBOUNDED"));
        }
    }

    private CargoOrderDO requireCargoOrder(Long cargoOrderId) {
        if (cargoOrderId == null) throw exception(OMS_BIZ_ERROR, "cargoOrderId is required");
        CargoOrderDO order = cargoOrderMapper.selectById(cargoOrderId);
        if (order == null) throw exception(OMS_BIZ_ERROR, "cargo order not found");
        return order;
    }

    private void validatePoolOrder(CargoOrderDO order, boolean requireInbounded) {
        if (Objects.equals(order.getHoldFlag(), 1)) throw exception(OMS_BIZ_ERROR, "cargo order is holding");
        if (StrUtil.isNotBlank(order.getPreOutboundStatus()) && !"NONE".equals(order.getPreOutboundStatus())) {
            throw exception(OMS_BIZ_ERROR, "cargo order already has pre-outbound order");
        }
        if (StrUtil.isNotBlank(order.getOutboundOrderStatus()) && !"NONE".equals(order.getOutboundOrderStatus())) {
            throw exception(OMS_BIZ_ERROR, "cargo order already has outbound order");
        }
        if (!POOL_STATUSES.contains(order.getFulfillmentStatus())) {
            throw exception(OMS_BIZ_ERROR, "cargo order is not in outbound pool");
        }
        if (requireInbounded && !OutboundReadinessUtils.INBOUNDED.equals(OutboundReadinessUtils.resolveReadiness(order))) {
            throw exception(OMS_BIZ_ERROR, "cargo order is not fully inbounded");
        }
    }

    /** 单货物订单创建预出单时使用（行级操作入口） */
    private PreOutboundDO buildPreOutbound(CargoOrderDO order, OutboundCreateReqVO bo) {
        PreOutboundDO preOutbound = new PreOutboundDO();
        preOutbound.setBizRootIds(order.getBizRootId() == null ? null : String.valueOf(order.getBizRootId()));
        preOutbound.setPreOutboundNo("POB" + IdUtil.getSnowflakeNextIdStr());
        preOutbound.setPreOutboundStatus(OutboundReadinessUtils.resolvePreOutboundStatus(order));
        preOutbound.setCargoOrderCount(1);
        preOutbound.setOutboundDirection(defaultDirection(bo.getOutboundDirection()));
        preOutbound.setOutboundWarehouseId(bo.getOutboundWarehouseId() == null ? order.getInboundWarehouseId() : bo.getOutboundWarehouseId());
        preOutbound.setOutboundWarehouseName(StrUtil.isBlank(bo.getOutboundWarehouseName()) ? order.getInboundWarehouseName() : bo.getOutboundWarehouseName());
        preOutbound.setCustomerName(order.getCustomerName());
        preOutbound.setContainerNo(order.getContainerNo());
        preOutbound.setShipmentCodes(order.getShipmentCodes());
        preOutbound.setDeclaredCartonQty(order.getDeclaredCartonQty());
        preOutbound.setDeclaredPalletQty(order.getDeclaredPalletQty());
        preOutbound.setDeclaredWeight(order.getDeclaredWeight());
        preOutbound.setDeclaredCbm(order.getDeclaredCbm());
        preOutbound.setActualCartonQty(order.getActualCartonQty());
        preOutbound.setActualPalletQty(order.getActualPalletQty());
        preOutbound.setActualWeight(order.getActualWeight());
        preOutbound.setActualCbm(order.getActualCbm());
        preOutbound.setEarliestDwTime(order.getEarliestDwTime());
        preOutbound.setDeliveryLfd(order.getDeliveryLfd());
        preOutbound.setReadyTime("READY_TO_CONVERT".equals(preOutbound.getPreOutboundStatus()) ? new Date() : null);
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
        return preOutbound;
    }

    /** 批量创建预出单时初始化头部（货量/状态由调用方在插入 item 后再 update） */
    private PreOutboundDO buildPreOutboundForBatch(List<CargoOrderDO> orders, OutboundCreateReqVO bo) {
        CargoOrderDO first = orders.get(0);
        PreOutboundDO preOutbound = new PreOutboundDO();
        preOutbound.setBizRootIds(joinBizRootIds(orders));
        preOutbound.setPreOutboundNo("POB" + IdUtil.getSnowflakeNextIdStr());
        preOutbound.setPreOutboundStatus("PENDING_INBOUND");
        preOutbound.setCargoOrderCount(0);
        preOutbound.setOutboundDirection(defaultDirection(bo.getOutboundDirection()));
        preOutbound.setOutboundWarehouseId(bo.getOutboundWarehouseId() == null ? first.getInboundWarehouseId() : bo.getOutboundWarehouseId());
        preOutbound.setOutboundWarehouseName(StrUtil.isBlank(bo.getOutboundWarehouseName()) ? first.getInboundWarehouseName() : bo.getOutboundWarehouseName());
        preOutbound.setCustomerName(first.getCustomerName());
        preOutbound.setDeliveryLfd(orders.stream().map(CargoOrderDO::getDeliveryLfd)
            .filter(Objects::nonNull).min(Date::compareTo).orElse(null));
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
        return preOutbound;
    }

    /** 支持多货物订单合并（1:N） */
    private OutboundOrderDO buildOutboundOrder(List<CargoOrderDO> orders, PreOutboundDO preOutbound, OutboundCreateReqVO bo) {
        CargoOrderDO first = orders.get(0);
        OutboundOrderDO outboundOrder = new OutboundOrderDO();
        outboundOrder.setBizRootIds(joinBizRootIds(orders));
        outboundOrder.setPreOutboundId(preOutbound == null ? null : preOutbound.getId());
        outboundOrder.setPreOutboundNo(preOutbound == null ? null : preOutbound.getPreOutboundNo());
        outboundOrder.setOutboundOrderNo("OB" + IdUtil.getSnowflakeNextIdStr());
        outboundOrder.setOutboundStatus("CREATED");
        outboundOrder.setCargoOrderCount(orders.size());
        outboundOrder.setCargoOrderId(first.getId());
        outboundOrder.setCargoOrderNo(orders.stream().map(CargoOrderDO::getCargoOrderNo)
            .filter(StrUtil::isNotBlank).collect(java.util.stream.Collectors.joining(",")));
        outboundOrder.setOutboundDirection(defaultDirection(bo.getOutboundDirection()));
        outboundOrder.setOutboundWarehouseId(bo.getOutboundWarehouseId() == null ? first.getInboundWarehouseId() : bo.getOutboundWarehouseId());
        outboundOrder.setOutboundWarehouseName(StrUtil.isBlank(bo.getOutboundWarehouseName()) ? first.getInboundWarehouseName() : bo.getOutboundWarehouseName());
        outboundOrder.setCustomerName(first.getCustomerName());
        outboundOrder.setContainerNo(orders.stream().map(CargoOrderDO::getContainerNo)
            .filter(StrUtil::isNotBlank).distinct().collect(java.util.stream.Collectors.joining(",")));
        outboundOrder.setShipmentCodes(orders.stream().map(CargoOrderDO::getShipmentCodes)
            .filter(StrUtil::isNotBlank).collect(java.util.stream.Collectors.joining(",")));
        outboundOrder.setActualCartonQty(orders.stream().map(CargoOrderDO::getActualCartonQty).map(this::nvl).reduce(BigDecimal.ZERO, BigDecimal::add));
        outboundOrder.setActualPalletQty(orders.stream().map(CargoOrderDO::getActualPalletQty).map(this::nvl).reduce(BigDecimal.ZERO, BigDecimal::add));
        outboundOrder.setActualWeight(orders.stream().map(CargoOrderDO::getActualWeight).map(this::nvl).reduce(BigDecimal.ZERO, BigDecimal::add));
        outboundOrder.setActualCbm(orders.stream().map(CargoOrderDO::getActualCbm).map(this::nvl).reduce(BigDecimal.ZERO, BigDecimal::add));
        outboundOrder.setDeliveryMethod(bo.getDeliveryMethod());
        outboundOrder.setAppointmentStatus(StrUtil.isBlank(bo.getAppointmentStatus()) ? "NONE" : bo.getAppointmentStatus());
        outboundOrder.setTransferInWarehouseId(bo.getTransferInWarehouseId());
        outboundOrder.setTransferMethod(bo.getTransferMethod());
        outboundOrder.setTransferReason(bo.getTransferReason());
        outboundOrder.setPodStatus("PENDING");
        outboundOrder.setRemark(bo.getRemark());
        return outboundOrder;
    }

    private String joinBizRootIds(List<CargoOrderDO> orders) {
        return orders.stream()
            .map(CargoOrderDO::getBizRootId)
            .filter(Objects::nonNull)
            .map(String::valueOf)
            .distinct()
            .collect(java.util.stream.Collectors.joining(","));
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

    private void createOutboundOrderItem(OutboundOrderDO outboundOrder, CargoOrderDO order, Long preOutboundItemId) {
        OutboundOrderItemDO item = new OutboundOrderItemDO();
        item.setOutboundOrderId(outboundOrder.getId());
        item.setOutboundOrderNo(outboundOrder.getOutboundOrderNo());
        item.setCargoOrderId(order.getId());
        item.setCargoOrderNo(order.getCargoOrderNo());
        item.setPreOutboundItemId(preOutboundItemId);
        item.setActualCartonQty(order.getActualCartonQty());
        item.setActualPalletQty(order.getActualPalletQty());
        item.setActualWeight(order.getActualWeight());
        item.setActualCbm(order.getActualCbm());
        outboundOrderItemMapper.insert(item);
    }

    private void applyTransferIfNeeded(Long cargoOrderId, OutboundCreateReqVO bo) {
        if (bo.getTransferFlag() == null || bo.getTransferFlag() != 1) {
            return;
        }
        if (StrUtil.isBlank(bo.getTransferWarehouseCode())) {
            throw exception(OMS_BIZ_ERROR, "转仓地址不能为空");
        }
        CargoOrderDO update = new CargoOrderDO();
        update.setId(cargoOrderId);
        update.setTransferFlag(1);
        update.setTransferWarehouseCode(bo.getTransferWarehouseCode().trim());
        cargoOrderMapper.updateById(update);
    }

    private void markCargoOutbound(CargoOrderDO order, String outboundOrderNo) {
        Date now = new Date();
        CargoOrderDO update = new CargoOrderDO();
        update.setId(order.getId());
        update.setOutboundBatchNo(outboundOrderNo);
        update.setOutboundOrderStatus("CREATED");
        update.setOutboundOrderTime(now);
        cargoOrderMapper.updateById(update);
        lifecycleService.transitionCargo(order.getId(), "OUTBOUND_ORDERED", "createOutboundOrder", "创建出库单", now);
    }

    private String resolvePreOutboundStatus(CargoOrderDO order) {
        String readiness = resolveReadiness(order);
        if (READY_INBOUNDED.equals(readiness)) return "READY_TO_CONVERT";
        if (READY_DEVANNING.equals(readiness)) return "DEVANNING";
        return "PENDING_INBOUND";
    }

    private String resolveReadiness(CargoOrderDO order) {
        if ("INBOUNDED".equals(order.getFulfillmentStatus())
            && nvl(order.getActualCartonQty()).compareTo(nvl(order.getDeclaredCartonQty())) >= 0) {
            return READY_INBOUNDED;
        }
        if (List.of("DEVANNING", "DEVANNED").contains(order.getFulfillmentStatus())) {
            return READY_DEVANNING;
        }
        return READY_NOT_INBOUNDED;
    }

    private String defaultDirection(String direction) {
        return StrUtil.isBlank(direction) ? "DELIVERY" : direction;
    }

    private BigDecimal nvl(BigDecimal value) {
        return value == null ? BigDecimal.ZERO : value;
    }
}
