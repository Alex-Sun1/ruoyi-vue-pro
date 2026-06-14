package cn.iocoder.yudao.module.oms.service.cargoorder;

import com.baomidou.mybatisplus.core.metadata.IPage;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.oms.enums.ErrorCodeConstants.*;

import cn.hutool.core.util.IdUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils;
import cn.iocoder.yudao.module.oms.controller.admin.common.vo.OmsManualStatusReqVO;
import cn.iocoder.yudao.module.oms.dal.dataobject.biz.BizRootDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder.CargoOrderDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.biz.BizAttachmentDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder.CargoOrderHoldRecordDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder.CargoOrderNodeTraceDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder.CargoOrderShipmentDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder.CargoOrderSkuItemDO;
import cn.iocoder.yudao.module.oms.controller.admin.bizattachment.vo.BizAttachmentSaveReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderSaveReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderHoldReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderMergeBackReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderPageReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderReleaseReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderShipmentSaveReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderSplitReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderSkuItemSaveReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.bizattachment.vo.BizAttachmentRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderNodeTraceRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderShipmentRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderSkuItemRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderRespVO;
import cn.iocoder.yudao.module.oms.dal.mysql.cargoorder.CargoOrderMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.biz.BizAttachmentMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.cargoorder.CargoOrderHoldRecordMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.cargoorder.CargoOrderNodeTraceMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.cargoorder.CargoOrderShipmentMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.cargoorder.CargoOrderSkuItemMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.biz.BizRootMapper;
import cn.iocoder.yudao.module.oms.service.cargoorder.CargoOrderService;
import cn.iocoder.yudao.module.oms.service.omsbizlifecycle.OmsBizLifecycleService;
import cn.iocoder.yudao.module.org.framework.datapermission.annotation.OrgDataScope;
import cn.iocoder.yudao.module.oms.support.OmsStatusTransitionGuard;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
public class CargoOrderServiceImpl implements CargoOrderService {

    @Resource
    private CargoOrderMapper baseMapper;
    @Resource
    private CargoOrderShipmentMapper shipmentMapper;
    @Resource
    private CargoOrderSkuItemMapper skuItemMapper;
    @Resource
    private CargoOrderNodeTraceMapper nodeTraceMapper;
    @Resource
    private BizAttachmentMapper attachmentMapper;
    @Resource
    private CargoOrderHoldRecordMapper holdRecordMapper;
    @Resource
    private OmsBizLifecycleService lifecycleService;
    @Resource
    private BizRootMapper bizRootMapper;

    // ======================== 状态常量 ========================

    private static final String STATUS_PENDING_ACCEPT    = "PENDING_ACCEPT";
    private static final String STATUS_ACCEPTED          = "ACCEPTED";
    private static final String STATUS_IN_TRANSIT        = "IN_TRANSIT";
    private static final String STATUS_ARRIVED_PORT      = "ARRIVED_PORT";
    private static final String STATUS_PICKED_UP         = "PICKED_UP";
    private static final String STATUS_ARRIVED_WAREHOUSE = "ARRIVED_WAREHOUSE";
    private static final String STATUS_DEVANNING         = "DEVANNING";
    private static final String STATUS_DEVANNED          = "DEVANNED";
    private static final String STATUS_INBOUNDED         = "INBOUNDED";
    private static final String STATUS_OUTBOUND_ORDERED  = "OUTBOUND_ORDERED";
    private static final String STATUS_DELIVERY_APPOINTED= "DELIVERY_APPOINTED";
    private static final String STATUS_OUTBOUNDED        = "OUTBOUNDED";
    private static final String STATUS_DELIVERING        = "DELIVERING";
    private static final String STATUS_DELIVERED         = "DELIVERED";
    private static final String STATUS_POD_UPLOADED      = "POD_UPLOADED";
    private static final String STATUS_BILLED            = "BILLED";
    private static final String STATUS_COMPLETED         = "COMPLETED";
    private static final String STATUS_CANCELLED         = "CANCELLED";

    // ======================== 主单 CRUD ========================

    @Override
    @OrgDataScope(tableClass = CargoOrderDO.class, warehouseColumn = "inbound_warehouse_id")
    public PageResult<CargoOrderRespVO> queryPageList(CargoOrderPageReqVO bo, PageParam pageQuery) {
        bo.prepareMultiValueQuery();
        IPage<CargoOrderRespVO> pg = baseMapper.selectPageList(new Page<>(pageQuery.getPageNo(), pageQuery.getPageSize()), bo);
        return new PageResult<>(pg.getRecords(), pg.getTotal());
    }

    @Override
    @OrgDataScope(tableClass = CargoOrderDO.class, warehouseColumn = "inbound_warehouse_id")
    public List<CargoOrderRespVO> queryList(CargoOrderPageReqVO bo) {
        bo.prepareMultiValueQuery();
        return baseMapper.selectPageList(new Page<>(1, Integer.MAX_VALUE), bo).getRecords();
    }

    @Override
    public CargoOrderRespVO queryById(Long id) {
        CargoOrderRespVO vo = BeanUtils.toBean(baseMapper.selectById(id), CargoOrderRespVO.class);
        if (vo != null) {
            if (vo.getBizRootId() != null) {
                BizRootDO root = bizRootMapper.selectById(vo.getBizRootId());
                if (root != null) {
                    vo.setFulfillmentStatus(root.getCurrentNode());
                }
            }
            List<CargoOrderShipmentRespVO> shipments = shipmentMapper.selectByCargoOrderId(id);
            List<CargoOrderSkuItemRespVO> skuItems = skuItemMapper.selectByCargoOrderId(id);
            Map<Long, List<CargoOrderSkuItemRespVO>> skuMap = skuItems.stream()
                .filter(item -> item.getShipmentId() != null)
                .collect(Collectors.groupingBy(CargoOrderSkuItemRespVO::getShipmentId));
            shipments.forEach(shipment ->
                shipment.setSkuItems(new ArrayList<>(skuMap.getOrDefault(shipment.getId(), List.of()))));
            vo.setShipments(shipments);
            vo.setNodeTraces(nodeTraceMapper.selectByCargoOrderId(id));
        }
        return vo;
    }

    @Override
    @OrgDataScope(tableClass = CargoOrderDO.class, warehouseColumn = "inbound_warehouse_id")
    public Map<String, Long> queryStatusCount(CargoOrderPageReqVO bo) {
        String currentStatus = bo.getFulfillmentStatus();
        bo.setFulfillmentStatus(null);
        bo.prepareMultiValueQuery();
        List<CargoOrderRespVO> rows = baseMapper.selectPageList(new Page<>(1, Integer.MAX_VALUE), bo).getRecords();
        bo.setFulfillmentStatus(currentStatus);
        Map<String, Long> result = rows.stream()
            .map(CargoOrderRespVO::getFulfillmentStatus)
            .filter(StrUtil::isNotBlank)
            .collect(Collectors.groupingBy(Function.identity(), Collectors.counting()));
        result.put("", result.values().stream().mapToLong(Long::longValue).sum());
        return result;
    }

    private String resolveStatusCountKey(Map<String, Object> row) {
        Object key = row.get("status_key");
        if (key == null) {
            key = row.get("STATUS_KEY");
        }
        if (key == null) {
            key = row.get("key");
        }
        if (key == null) {
            key = row.get("KEY");
        }
        return String.valueOf(key);
    }

    private long resolveStatusCountValue(Map<String, Object> row) {
        Object count = row.get("status_count");
        if (count == null) {
            count = row.get("STATUS_COUNT");
        }
        if (count == null) {
            count = row.get("count");
        }
        if (count == null) {
            count = row.get("COUNT");
        }
        return count == null ? 0L : ((Number) count).longValue();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean insertByBo(CargoOrderSaveReqVO bo) {
        CargoOrderDO order = BeanUtils.toBean(bo, CargoOrderDO.class);
        order.setFulfillmentStatus(STATUS_PENDING_ACCEPT);
        order.setOrderStatus("NORMAL");
        order.setPreOutboundStatus("NONE");
        order.setOutboundOrderStatus("NONE");
        order.setAppointmentStatus("NONE");
        order.setPodStatus("PENDING");
        order.setBillingStatus("UNBILLED");
        order.setExceptionFlag(0);
        order.setExceptionCount(0);
        order.setHoldFlag(0);
        order.setHoldStatus("NORMAL");
        order.setSplitFlag(0);
        order.setSplitRole("NORMAL");
        order.setSplitStatus("NONE");
        order.setCustomerVisibleFlag(1);
        order.setAttachmentCount(0);
        order.setPodAttachmentCount(0);
        order.setExceptionAttachmentCount(0);
        order.setTransferFlag(order.getTransferFlag() == null ? 0 : order.getTransferFlag());
        order.setPreOutboundFlag(0);

        if (StrUtil.isBlank(bo.getCargoOrderNo())) {
            order.setCargoOrderNo("CO" + IdUtil.getSnowflakeNextIdStr());
        }
        if (order.getBizRootId() == null) {
            order.setBizRootId(IdUtil.getSnowflakeNextId());
        }

        baseMapper.insert(order);
        saveBizRoot(order);

        if (bo.getShipments() != null && !bo.getShipments().isEmpty()) {
            saveShipmentsForOrder(order.getId(), bo.getShipments());
        }

        return Boolean.TRUE;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean updateByBo(CargoOrderSaveReqVO bo) {
        CargoOrderDO order = BeanUtils.toBean(bo, CargoOrderDO.class);
        order.setFulfillmentStatus(null);
        order.setOrderStatus(null);
        order.setPreOutboundStatus(null);
        order.setOutboundOrderStatus(null);
        order.setAppointmentStatus(null);
        order.setPodStatus(null);
        order.setBillingStatus(null);
        order.setHoldStatus(null);
        order.setSplitStatus(null);
        baseMapper.updateById(order);
        return Boolean.TRUE;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean deleteByIds(List<Long> ids) {
        baseMapper.deleteByIds(ids);
        return Boolean.TRUE;
    }

    // ======================== 货件 ========================

    @Override
    public List<CargoOrderShipmentRespVO> queryShipmentList(Long cargoOrderId) {
        return shipmentMapper.selectByCargoOrderId(cargoOrderId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean saveShipment(Long cargoOrderId, CargoOrderShipmentSaveReqVO bo) {
        CargoOrderShipmentDO shipment = BeanUtils.toBean(bo, CargoOrderShipmentDO.class);
        shipment.setCargoOrderId(cargoOrderId);

        if (bo.getId() == null) {
            shipmentMapper.insert(shipment);
        } else {
            shipmentMapper.updateById(shipment);
        }

        if (bo.getSkuItems() != null && !bo.getSkuItems().isEmpty()) {
            for (CargoOrderSkuItemSaveReqVO skuBo : bo.getSkuItems()) {
                CargoOrderSkuItemDO sku = BeanUtils.toBean(skuBo, CargoOrderSkuItemDO.class);
                sku.setCargoOrderId(cargoOrderId);
                sku.setShipmentId(shipment.getId());
                sku.setShipmentNo(shipment.getShipmentNo());
                if (sku.getId() == null) {
                    skuItemMapper.insert(sku);
                } else {
                    skuItemMapper.updateById(sku);
                }
            }
        }

        recalcShipmentSummary(cargoOrderId);
        return Boolean.TRUE;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean deleteShipment(Long shipmentId) {
        CargoOrderShipmentDO shipment = shipmentMapper.selectById(shipmentId);
        if (shipment == null) return Boolean.FALSE;
        shipmentMapper.deleteById(shipmentId);
        skuItemMapper.delete(new LambdaQueryWrapper<CargoOrderSkuItemDO>()
            .eq(CargoOrderSkuItemDO::getShipmentId, shipmentId));
        recalcShipmentSummary(shipment.getCargoOrderId());
        return Boolean.TRUE;
    }

    // ======================== SKU ========================

    @Override
    public List<CargoOrderSkuItemRespVO> querySkuItemList(Long cargoOrderId) {
        return skuItemMapper.selectByCargoOrderId(cargoOrderId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean saveSkuItem(Long cargoOrderId, CargoOrderSkuItemSaveReqVO bo) {
        CargoOrderSkuItemDO sku = BeanUtils.toBean(bo, CargoOrderSkuItemDO.class);
        sku.setCargoOrderId(cargoOrderId);
        if (sku.getId() == null) {
            skuItemMapper.insert(sku);
        } else {
            skuItemMapper.updateById(sku);
        }
        return Boolean.TRUE;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean deleteSkuItem(Long skuItemId) {
        skuItemMapper.deleteById(skuItemId);
        return Boolean.TRUE;
    }

    // ======================== 轨迹 ========================

    @Override
    public List<CargoOrderNodeTraceRespVO> queryNodeTraceList(Long cargoOrderId) {
        return nodeTraceMapper.selectByCargoOrderId(cargoOrderId);
    }

    // ======================== 业务动作 ========================

    @Override
    public Boolean accept(Long id, String remark) {
        return doStatusTransition(id, STATUS_PENDING_ACCEPT, STATUS_ACCEPTED, "accept", remark);
    }

    @Override
    public Boolean markInTransit(Long id, String remark) {
        return doStatusTransition(id, STATUS_ACCEPTED, STATUS_IN_TRANSIT, "markInTransit", remark);
    }

    @Override
    public Boolean confirmArrivedPort(Long id, String remark) {
        return doStatusTransition(id, STATUS_IN_TRANSIT, STATUS_ARRIVED_PORT, "confirmArrivedPort", remark);
    }

    @Override
    public Boolean confirmPickedUp(Long id, String remark) {
        return doStatusTransition(id, STATUS_ARRIVED_PORT, STATUS_PICKED_UP, "confirmPickedUp", remark);
    }

    @Override
    public Boolean confirmArrivedWarehouse(Long id, String remark) {
        CargoOrderDO order = requireOrder(id);
        validateStatus(order, STATUS_PICKED_UP);
        return lifecycleService.transitionCargo(id, STATUS_ARRIVED_WAREHOUSE, "confirmArrivedWarehouse", remark);
    }

    @Override
    public Boolean startDevanning(Long id, String remark) {
        return doStatusTransition(id, STATUS_ARRIVED_WAREHOUSE, STATUS_DEVANNING, "startDevanning", remark);
    }

    @Override
    public Boolean finishDevanning(Long id, String remark) {
        CargoOrderDO order = requireOrder(id);
        validateStatus(order, STATUS_DEVANNING);
        return lifecycleService.transitionCargo(id, STATUS_DEVANNED, "finishDevanning", remark);
    }

    @Override
    public Boolean confirmInbounded(Long id, String remark) {
        CargoOrderDO order = requireOrder(id);
        validateStatus(order, STATUS_DEVANNED);
        return lifecycleService.transitionCargo(id, STATUS_INBOUNDED, "confirmInbounded", remark);
    }

    @Override
    public Boolean createOutboundOrder(Long id, String outboundBatchNo, String remark) {
        CargoOrderDO order = requireOrder(id);
        ensureNotHolding(order);
        String currentNode = currentLifecycleNode(order);
        if (!STATUS_INBOUNDED.equals(currentNode)
            && !STATUS_OUTBOUND_ORDERED.equals(currentNode)) {
            throw exception(OMS_BIZ_ERROR, "当前状态不允许出单，需先完成入库");
        }
        CargoOrderDO update = new CargoOrderDO();
        update.setId(id);
        update.setOutboundBatchNo(outboundBatchNo);
        update.setOutboundOrderStatus("ORDERED");
        update.setOutboundOrderTime(new Date());
        baseMapper.updateById(update);
        return lifecycleService.transitionCargo(id, STATUS_OUTBOUND_ORDERED, "createOutboundOrder", remark);
    }

    @Override
    public Boolean appointDelivery(Long id, String remark) {
        CargoOrderDO order = requireOrder(id);
        validateStatus(order, STATUS_OUTBOUND_ORDERED);
        return lifecycleService.transitionCargo(id, STATUS_DELIVERY_APPOINTED, "appointDelivery", remark);
    }

    @Override
    public Boolean confirmOutbounded(Long id, String remark) {
        CargoOrderDO order = requireOrder(id);
        ensureNotHolding(order);
        String currentNode = currentLifecycleNode(order);
        if (!STATUS_DELIVERY_APPOINTED.equals(currentNode)
            && !STATUS_OUTBOUND_ORDERED.equals(currentNode)) {
            throw exception(OMS_BIZ_ERROR, "当前状态不允许出库");
        }
        return lifecycleService.transitionCargo(id, STATUS_OUTBOUNDED, "confirmOutbounded", remark);
    }

    @Override
    public Boolean markDelivering(Long id, String remark) {
        return doStatusTransition(id, STATUS_OUTBOUNDED, STATUS_DELIVERING, "markDelivering", remark);
    }

    @Override
    public Boolean confirmDelivered(Long id, String remark) {
        CargoOrderDO order = requireOrder(id);
        validateStatus(order, STATUS_DELIVERING);
        return lifecycleService.transitionCargo(id, STATUS_DELIVERED, "confirmDelivered", remark);
    }

    @Override
    public Boolean uploadPod(Long id, String remark) {
        CargoOrderDO order = requireOrder(id);
        validateStatus(order, STATUS_DELIVERED);
        return lifecycleService.transitionCargo(id, STATUS_POD_UPLOADED, "uploadPod", remark);
    }

    @Override
    public Boolean confirmBilled(Long id, String remark) {
        CargoOrderDO order = requireOrder(id);
        validateStatus(order, STATUS_POD_UPLOADED);
        return lifecycleService.transitionCargo(id, STATUS_BILLED, "confirmBilled", remark);
    }

    @Override
    public Boolean complete(Long id, String remark) {
        CargoOrderDO order = requireOrder(id);
        validateStatus(order, STATUS_BILLED);
        return lifecycleService.transitionCargo(id, STATUS_COMPLETED, "complete", remark);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean cancel(Long id, String remark) {
        CargoOrderDO order = requireOrder(id);
        String currentNode = currentLifecycleNode(order);
        if (STATUS_COMPLETED.equals(currentNode)
            || STATUS_CANCELLED.equals(currentNode)) {
            throw exception(OMS_BIZ_ERROR, "已完成或已取消的订单不能取消");
        }
        return lifecycleService.transitionCargo(id, STATUS_CANCELLED, "cancel", remark);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean manualAdjustStatus(Long id, OmsManualStatusReqVO bo) {
        OmsStatusTransitionGuard.requireManualReason(bo.getReason());
        CargoOrderDO order = requireOrder(id);
        String fromStatus = currentLifecycleNode(order);
        if (StrUtil.equals(fromStatus, bo.getTargetStatus())) {
            return true;
        }
        return lifecycleService.transitionCargo(id, bo.getTargetStatus(), "manualAdjustStatus", bo.getReason());
    }

    // ======================== 预出单 ========================

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean createPreOutbound(Long id, String preOutboundNo, String remark) {
        CargoOrderDO order = requireOrder(id);
        ensureNotHolding(order);
        String currentNode = currentLifecycleNode(order);
        if (STATUS_CANCELLED.equals(currentNode)
            || STATUS_COMPLETED.equals(currentNode)) {
            throw exception(OMS_BIZ_ERROR, "已取消或已完成的订单不能创建预出单");
        }
        if ("PRE_CREATED".equals(order.getPreOutboundStatus())
            || "CONVERTED".equals(order.getPreOutboundStatus())) {
            throw exception(OMS_BIZ_ERROR, "已存在预出单，请勿重复创建");
        }
        CargoOrderDO update = new CargoOrderDO();
        update.setId(id);
        update.setPreOutboundFlag(1);
        update.setPreOutboundNo(StrUtil.isBlank(preOutboundNo)
            ? "PRE" + IdUtil.getSnowflakeNextIdStr() : preOutboundNo);
        update.setPreOutboundStatus("PRE_CREATED");
        update.setPreOutboundTime(new Date());
        baseMapper.updateById(update);
        saveTrace(id, order.getFulfillmentStatus(), order.getFulfillmentStatus(),
            "createPreOutbound", "创建预出单: " + update.getPreOutboundNo() + " " + remark);
        return Boolean.TRUE;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean convertPreOutbound(Long id, String outboundBatchNo, String remark) {
        CargoOrderDO order = requireOrder(id);
        ensureNotHolding(order);
        if (!"PRE_CREATED".equals(order.getPreOutboundStatus())) {
            throw exception(OMS_BIZ_ERROR, "当前预出单状态不允许转正式出单");
        }
        String batchNo = StrUtil.isBlank(outboundBatchNo) ? order.getPreOutboundNo() : outboundBatchNo;
        CargoOrderDO update = new CargoOrderDO();
        update.setId(id);
        update.setPreOutboundStatus("CONVERTED");
        update.setPreOutboundConvertTime(new Date());
        update.setOutboundBatchNo(batchNo);
        update.setOutboundOrderStatus("ORDERED");
        update.setOutboundOrderTime(new Date());
        baseMapper.updateById(update);
        saveTrace(id, order.getFulfillmentStatus(), order.getFulfillmentStatus(),
            "convertPreOutbound", "转正式出单: " + batchNo + " " + remark);
        return Boolean.TRUE;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean cancelPreOutbound(Long id, String remark) {
        CargoOrderDO order = requireOrder(id);
        if (!"PRE_CREATED".equals(order.getPreOutboundStatus())) {
            throw exception(OMS_BIZ_ERROR, "当前预出单状态不允许取消");
        }
        CargoOrderDO update = new CargoOrderDO();
        update.setId(id);
        update.setPreOutboundStatus("CANCELLED");
        baseMapper.updateById(update);
        saveTrace(id, order.getFulfillmentStatus(), order.getFulfillmentStatus(),
            "cancelPreOutbound", remark);
        return Boolean.TRUE;
    }

    // ======================== 入库仓修改 ========================

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean cancelTransfer(Long id, String remark) {
        CargoOrderDO order = requireOrder(id);
        if (!Integer.valueOf(1).equals(order.getTransferFlag())) {
            throw exception(OMS_BIZ_ERROR, "当前订单未设置转仓，无需取消");
        }
        CargoOrderDO update = new CargoOrderDO();
        update.setId(id);
        update.setTransferFlag(0);
        update.setTransferWarehouseCode(null);
        baseMapper.updateById(update);
        saveTrace(id, order.getFulfillmentStatus(), order.getFulfillmentStatus(),
            "cancelTransfer", "取消转仓 " + StrUtil.blankToDefault(remark, ""));
        return Boolean.TRUE;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean modifyTransfer(Long id, String transferWarehouseCode, String remark) {
        CargoOrderDO order = requireOrder(id);
        if (StrUtil.isBlank(transferWarehouseCode)) {
            throw exception(OMS_BIZ_ERROR, "转仓仓库代码不能为空");
        }
        if (STATUS_OUTBOUNDED.equals(order.getFulfillmentStatus())
            || STATUS_DELIVERING.equals(order.getFulfillmentStatus())
            || STATUS_DELIVERED.equals(order.getFulfillmentStatus())
            || STATUS_POD_UPLOADED.equals(order.getFulfillmentStatus())
            || STATUS_BILLED.equals(order.getFulfillmentStatus())
            || STATUS_COMPLETED.equals(order.getFulfillmentStatus())) {
            throw exception(OMS_BIZ_ERROR, "已出库后不允许修改转仓");
        }
        CargoOrderDO update = new CargoOrderDO();
        update.setId(id);
        update.setTransferFlag(1);
        update.setTransferWarehouseCode(transferWarehouseCode.trim());
        baseMapper.updateById(update);
        saveTrace(id, order.getFulfillmentStatus(), order.getFulfillmentStatus(),
            "modifyTransfer", "修改转仓: " + transferWarehouseCode + " " + StrUtil.blankToDefault(remark, ""));
        return Boolean.TRUE;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean changeInboundWarehouse(Long id, Long warehouseId, String warehouseName, String remark) {
        CargoOrderDO order = requireOrder(id);
        if (STATUS_OUTBOUNDED.equals(order.getFulfillmentStatus())
            || STATUS_DELIVERING.equals(order.getFulfillmentStatus())
            || STATUS_DELIVERED.equals(order.getFulfillmentStatus())
            || STATUS_POD_UPLOADED.equals(order.getFulfillmentStatus())
            || STATUS_BILLED.equals(order.getFulfillmentStatus())
            || STATUS_COMPLETED.equals(order.getFulfillmentStatus())) {
            throw exception(OMS_BIZ_ERROR, "已出库后不允许修改入库仓");
        }
        CargoOrderDO update = new CargoOrderDO();
        update.setId(id);
        update.setInboundWarehouseId(warehouseId);
        update.setInboundWarehouseName(warehouseName);
        baseMapper.updateById(update);
        saveTrace(id, order.getFulfillmentStatus(), order.getFulfillmentStatus(),
            "changeInboundWarehouse", "修改入库仓: " + warehouseName + " " + remark);
        return Boolean.TRUE;
    }

    @Override
    public List<BizAttachmentRespVO> queryAttachments(Long id, boolean includeContainerAttachments) {
        CargoOrderDO order = requireOrder(id);
        List<BizAttachmentRespVO> result = new ArrayList<>(BeanUtils.toBean(attachmentMapper.selectList(new LambdaQueryWrapper<BizAttachmentDO>()
            .eq(BizAttachmentDO::getTargetType, "CARGO_ORDER")
            .eq(BizAttachmentDO::getTargetId, id)
            .orderByDesc(BizAttachmentDO::getUploadTime)), BizAttachmentRespVO.class));
        if (includeContainerAttachments && order.getContainerOrderId() != null) {
            result.addAll(BeanUtils.toBean(attachmentMapper.selectList(new LambdaQueryWrapper<BizAttachmentDO>()
                .eq(BizAttachmentDO::getTargetType, "CONTAINER_ORDER")
                .eq(BizAttachmentDO::getTargetId, order.getContainerOrderId())
                .orderByDesc(BizAttachmentDO::getUploadTime)), BizAttachmentRespVO.class));
        }
        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean uploadAttachment(Long id, BizAttachmentSaveReqVO bo) {
        CargoOrderDO order = requireOrder(id);
        BizAttachmentDO attachment = BeanUtils.toBean(bo, BizAttachmentDO.class);
        attachment.setTargetType("CARGO_ORDER");
        attachment.setTargetId(order.getId());
        attachment.setTargetNo(order.getCargoOrderNo());
        attachment.setBizRootId(order.getBizRootId());
        attachment.setAttachmentType(StrUtil.blankToDefault(bo.getAttachmentType(), "OTHER"));
        attachment.setCustomerVisibleFlag(Optional.ofNullable(attachment.getCustomerVisibleFlag()).orElse(0));
        attachment.setInternalVisibleFlag(Optional.ofNullable(attachment.getInternalVisibleFlag()).orElse(1));
        attachment.setUploadUserId(SecurityFrameworkUtils.getLoginUserId());
        attachment.setUploadUserName(SecurityFrameworkUtils.getLoginUserNickname());
        attachment.setUploadTime(new Date());
        attachmentMapper.insert(attachment);
        recalcCargoAttachmentSummary(id);
        saveTrace(id, order.getFulfillmentStatus(), order.getFulfillmentStatus(), "CARGO_ATTACHMENT_UPLOADED", attachment.getFileName());
        return Boolean.TRUE;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean removeAttachment(Long attachmentId) {
        BizAttachmentDO attachment = attachmentMapper.selectById(attachmentId);
        if (attachment == null || !"CARGO_ORDER".equals(attachment.getTargetType())) {
            throw exception(OMS_BIZ_ERROR, "货物订单附件不存在");
        }
        attachmentMapper.deleteById(attachmentId);
        recalcCargoAttachmentSummary(attachment.getTargetId());
        return Boolean.TRUE;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean hold(Long id, CargoOrderHoldReqVO bo) {
        CargoOrderDO order = requireOrder(id);
        if (STATUS_COMPLETED.equals(order.getFulfillmentStatus()) || STATUS_CANCELLED.equals(order.getFulfillmentStatus())) {
            throw exception(OMS_BIZ_ERROR, "已完成或已取消的订单不能暂扣");
        }
        if (Integer.valueOf(1).equals(order.getHoldFlag())) {
            throw exception(OMS_BIZ_ERROR, "该货物订单已处于HOLD中");
        }
        Date now = new Date();
        CargoOrderDO update = new CargoOrderDO();
        update.setId(id);
        update.setHoldFlag(1);
        update.setHoldStatus("HOLDING");
        update.setHoldType(bo.getHoldType());
        update.setHoldReason(bo.getHoldReason());
        update.setHoldRemark(bo.getHoldReason());
        update.setHoldTime(now);
        update.setHoldUserId(SecurityFrameworkUtils.getLoginUserId());
        update.setHoldUserName(SecurityFrameworkUtils.getLoginUserNickname());
        baseMapper.updateById(update);

        CargoOrderHoldRecordDO record = new CargoOrderHoldRecordDO();
        record.setCargoOrderId(id);
        record.setCargoOrderNo(order.getCargoOrderNo());
        record.setBizRootId(order.getBizRootId());
        record.setHoldType(bo.getHoldType());
        record.setHoldReason(bo.getHoldReason());
        record.setHoldStatus("HOLDING");
        record.setHoldTime(now);
        record.setHoldUserId(SecurityFrameworkUtils.getLoginUserId());
        record.setHoldUserName(SecurityFrameworkUtils.getLoginUserNickname());
        record.setRemark(bo.getRemark());
        holdRecordMapper.insert(record);
        saveTrace(id, order.getFulfillmentStatus(), order.getFulfillmentStatus(), "CARGO_ORDER_HOLD", bo.getHoldReason());
        return Boolean.TRUE;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean releaseHold(Long id, CargoOrderReleaseReqVO bo) {
        CargoOrderDO order = requireOrder(id);
        if (!Integer.valueOf(1).equals(order.getHoldFlag())) {
            throw exception(OMS_BIZ_ERROR, "该货物订单未HOLD，无需放行");
        }
        Date now = new Date();
        CargoOrderDO update = new CargoOrderDO();
        update.setId(id);
        update.setHoldFlag(0);
        update.setHoldStatus("RELEASED");
        update.setHoldRemark(null);
        update.setReleaseTime(now);
        baseMapper.updateById(update);

        CargoOrderHoldRecordDO record = holdRecordMapper.selectOne(new LambdaQueryWrapper<CargoOrderHoldRecordDO>()
            .eq(CargoOrderHoldRecordDO::getCargoOrderId, id)
            .eq(CargoOrderHoldRecordDO::getHoldStatus, "HOLDING")
            .orderByDesc(CargoOrderHoldRecordDO::getHoldTime)
            .last("limit 1"));
        if (record != null) {
            record.setHoldStatus("RELEASED");
            record.setReleaseReason(bo.getReleaseReason());
            record.setReleaseTime(now);
            record.setReleaseUserId(SecurityFrameworkUtils.getLoginUserId());
            record.setReleaseUserName(SecurityFrameworkUtils.getLoginUserNickname());
            holdRecordMapper.updateById(record);
        }
        saveTrace(id, order.getFulfillmentStatus(), order.getFulfillmentStatus(), "CARGO_ORDER_RELEASED", bo.getReleaseReason());
        return Boolean.TRUE;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean split(Long id, CargoOrderSplitReqVO bo) {
        CargoOrderDO parent = requireOrder(id);
        if (STATUS_COMPLETED.equals(parent.getFulfillmentStatus()) || STATUS_CANCELLED.equals(parent.getFulfillmentStatus())) {
            throw exception(OMS_BIZ_ERROR, "已完成或已取消的订单不能拆单");
        }
        String splitSource = StrUtil.blankToDefault(bo.getSplitSource(), "INTERNAL");
        String splitGroupNo = "SPLIT" + IdUtil.getSnowflakeNextIdStr();
        int index = 1;
        for (CargoOrderSplitReqVO.Child child : bo.getChildren()) {
            if (child.getShipmentIds() == null || child.getShipmentIds().isEmpty()) {
                throw exception(OMS_BIZ_ERROR, "请选择要拆出的货件");
            }
            List<CargoOrderShipmentDO> selectedShipments = shipmentMapper.selectList(new LambdaQueryWrapper<CargoOrderShipmentDO>()
                .eq(CargoOrderShipmentDO::getCargoOrderId, parent.getId())
                .in(CargoOrderShipmentDO::getId, child.getShipmentIds()));
            if (selectedShipments.size() != child.getShipmentIds().size()) {
                throw exception(OMS_BIZ_ERROR, "存在不属于当前货物订单的货件，不能拆单");
            }
            CargoOrderDO sub = new CargoOrderDO();
            sub.setBizRootId(parent.getBizRootId());
            sub.setCompanyId(parent.getCompanyId());
            sub.setCargoOrderNo(parent.getCargoOrderNo() + StrUtil.blankToDefault(child.getCargoOrderNoSuffix(), "-" + index));
            sub.setExternalOrderNo(parent.getExternalOrderNo());
            sub.setOrderSource(parent.getOrderSource());
            sub.setCustomerId(parent.getCustomerId());
            sub.setCustomerName(parent.getCustomerName());
            sub.setBusinessTypeId(parent.getBusinessTypeId());
            sub.setBusinessTypeName(parent.getBusinessTypeName());
            sub.setChannelId(parent.getChannelId());
            sub.setChannelName(parent.getChannelName());
            sub.setContainerOrderId(parent.getContainerOrderId());
            sub.setContainerNo(parent.getContainerNo());
            sub.setInboundWarehouseId(parent.getInboundWarehouseId());
            sub.setInboundWarehouseName(parent.getInboundWarehouseName());
            sub.setFulfillmentStatus(parent.getFulfillmentStatus());
            sub.setOrderStatus("NORMAL");
            sub.setPreOutboundStatus("NONE");
            sub.setOutboundOrderStatus("NONE");
            sub.setAppointmentStatus("NONE");
            sub.setPodStatus("PENDING");
            sub.setBillingStatus("UNBILLED");
            sub.setParentOrderId(parent.getId());
            sub.setParentOrderNo(parent.getCargoOrderNo());
            sub.setRootOrderId(Optional.ofNullable(parent.getRootOrderId()).orElse(parent.getId()));
            sub.setRootOrderNo(StrUtil.blankToDefault(parent.getRootOrderNo(), parent.getCargoOrderNo()));
            sub.setSplitFlag(1);
            sub.setSplitRole("SPLIT_CHILD");
            sub.setSplitStatus("SPLIT_ACTIVE");
            sub.setSplitGroupNo(splitGroupNo);
            sub.setSplitSource(splitSource);
            sub.setCustomerVisibleFlag(Optional.ofNullable(child.getCustomerVisibleFlag()).orElse("CUSTOMER".equals(splitSource) ? 1 : 0));
            sub.setCustomerSplitReason(bo.getCustomerSplitReason());
            sub.setInternalSplitReason(bo.getInternalSplitReason());
            sub.setSplitRequestedBy(bo.getSplitRequestedBy());
            sub.setSplitRequestedUserId(SecurityFrameworkUtils.getLoginUserId());
            sub.setSplitRequestedUserName(SecurityFrameworkUtils.getLoginUserNickname());
            sub.setSplitTime(new Date());
            sub.setDeclaredCartonQty(child.getCartonQty());
            sub.setDeclaredWeight(child.getWeight());
            sub.setDeclaredCbm(child.getCbm());
            sub.setHoldFlag(Optional.ofNullable(child.getHoldFlag()).orElse(Optional.ofNullable(parent.getHoldFlag()).orElse(0)));
            sub.setHoldStatus(Integer.valueOf(1).equals(sub.getHoldFlag()) ? "HOLDING" : "NORMAL");
            sub.setHoldReason(child.getHoldReason());
            sub.setHoldRemark(child.getHoldReason());
            sub.setOperationRemark(child.getRemark());
            sub.setExceptionFlag(0);
            sub.setExceptionCount(0);
            baseMapper.insert(sub);
            for (CargoOrderShipmentDO shipment : selectedShipments) {
                CargoOrderShipmentDO updateShipment = new CargoOrderShipmentDO();
                updateShipment.setId(shipment.getId());
                updateShipment.setCargoOrderId(sub.getId());
                shipmentMapper.updateById(updateShipment);
            }
            List<CargoOrderSkuItemDO> skuItems = skuItemMapper.selectList(new LambdaQueryWrapper<CargoOrderSkuItemDO>()
                .in(CargoOrderSkuItemDO::getShipmentId, child.getShipmentIds()));
            for (CargoOrderSkuItemDO skuItem : skuItems) {
                CargoOrderSkuItemDO updateSku = new CargoOrderSkuItemDO();
                updateSku.setId(skuItem.getId());
                updateSku.setCargoOrderId(sub.getId());
                skuItemMapper.updateById(updateSku);
            }
            recalcShipmentSummary(sub.getId());
            saveTrace(sub.getId(), parent.getFulfillmentStatus(), parent.getFulfillmentStatus(),
                "CUSTOMER".equals(splitSource) ? "CARGO_ORDER_CUSTOMER_SPLIT" : "CARGO_ORDER_INTERNAL_SPLIT", bo.getRemark());
            index++;
        }
        CargoOrderDO update = new CargoOrderDO();
        update.setId(parent.getId());
        update.setSplitFlag(1);
        update.setSplitRole("SPLIT_PARENT");
        update.setSplitStatus("SPLIT_ACTIVE");
        update.setSplitGroupNo(splitGroupNo);
        update.setChildOrderCount(bo.getChildren().size());
        update.setSplitSource(splitSource);
        update.setCustomerSplitReason(bo.getCustomerSplitReason());
        update.setInternalSplitReason(bo.getInternalSplitReason());
        update.setSplitTime(new Date());
        baseMapper.updateById(update);
        recalcShipmentSummary(parent.getId());
        saveTrace(id, parent.getFulfillmentStatus(), parent.getFulfillmentStatus(),
            "CUSTOMER".equals(splitSource) ? "CARGO_ORDER_CUSTOMER_SPLIT" : "CARGO_ORDER_INTERNAL_SPLIT", bo.getRemark());
        return Boolean.TRUE;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean mergeBack(CargoOrderMergeBackReqVO bo) {
        CargoOrderDO root = requireOrder(bo.getRootCargoOrderId());
        for (Long childId : bo.getChildCargoOrderIds()) {
            CargoOrderDO child = requireOrder(childId);
            if (!root.getId().equals(child.getParentOrderId()) && !root.getId().equals(child.getRootOrderId())) {
                throw exception(OMS_BIZ_ERROR, "只能回并同一原单拆出的子单");
            }
            if (STATUS_OUTBOUNDED.equals(child.getFulfillmentStatus())
                || STATUS_DELIVERED.equals(child.getFulfillmentStatus())
                || STATUS_POD_UPLOADED.equals(child.getFulfillmentStatus())
                || STATUS_BILLED.equals(child.getFulfillmentStatus())
                || STATUS_COMPLETED.equals(child.getFulfillmentStatus())) {
                throw exception(OMS_BIZ_ERROR, String.valueOf("子单[" + child.getCargoOrderNo()) + "]已进入出库/签收/账单链路，不能回并");
            }
            if (!Optional.ofNullable(root.getHoldFlag()).orElse(0).equals(Optional.ofNullable(child.getHoldFlag()).orElse(0))) {
                throw exception(OMS_BIZ_ERROR, String.valueOf("子单[" + child.getCargoOrderNo()) + "]HOLD状态与原单不一致，请先处理");
            }
            CargoOrderDO updateChild = new CargoOrderDO();
            updateChild.setId(childId);
            updateChild.setSplitStatus("MERGED_BACK");
            updateChild.setOrderStatus("MERGED_BACK");
            updateChild.setMergedBackTime(new Date());
            updateChild.setMergedBackBy(SecurityFrameworkUtils.getLoginUserId());
            baseMapper.updateById(updateChild);
            saveTrace(childId, child.getFulfillmentStatus(), child.getFulfillmentStatus(),
                StrUtil.blankToDefault(bo.getMergeBackType(), "INTERNAL_SPLIT_MERGE_BACK"), bo.getMergeBackReason());
        }
        CargoOrderDO updateRoot = new CargoOrderDO();
        updateRoot.setId(root.getId());
        updateRoot.setSplitStatus("MERGED_BACK");
        updateRoot.setMergedBackTime(new Date());
        updateRoot.setMergedBackBy(SecurityFrameworkUtils.getLoginUserId());
        baseMapper.updateById(updateRoot);
        saveTrace(root.getId(), root.getFulfillmentStatus(), root.getFulfillmentStatus(),
            StrUtil.blankToDefault(bo.getMergeBackType(), "INTERNAL_SPLIT_MERGE_BACK"), bo.getMergeBackReason());
        return Boolean.TRUE;
    }

    // ======================== 私有辅助方法 ========================

    private CargoOrderDO requireOrder(Long id) {
        CargoOrderDO order = baseMapper.selectById(id);
        if (order == null) throw exception(OMS_BIZ_ERROR, "货物订单不存在");
        return order;
    }

    private void saveBizRoot(CargoOrderDO order) {
        BizRootDO root = new BizRootDO();
        root.setId(order.getBizRootId());
        root.setCompanyId(order.getCompanyId());
        root.setWarehouseId(order.getInboundWarehouseId());
        root.setRootNo(order.getCargoOrderNo());
        root.setRootType("CARGO_ORDER");
        root.setSourceModule("OMS");
        root.setSourceOrderId(order.getId());
        root.setSourceOrderNo(order.getCargoOrderNo());
        root.setCustomerId(order.getCustomerId());
        root.setCustomerName(order.getCustomerName());
        root.setChannelId(order.getChannelId());
        root.setBusinessTypeId(order.getBusinessTypeId());
        root.setCurrentModule("OMS");
        root.setCurrentNode(STATUS_PENDING_ACCEPT);
        root.setCurrentNodeName("待受理");
        root.setCurrentNodeTime(new Date());
        root.setRootStatus("RUNNING");
        root.setExceptionFlag(0);
        root.setExceptionCount(0);
        root.setStartTime(new Date());
        root.setRemark("由货物订单创建");
        bizRootMapper.insert(root);
    }

    private void validateStatus(CargoOrderDO order, String required) {
        String currentNode = currentLifecycleNode(order);
        if (!required.equals(currentNode)) {
            throw exception(OMS_BIZ_ERROR, String.valueOf("当前状态[" + currentNode + "]不允许此操作，需要状态: " + required));
        }
    }

    private String currentLifecycleNode(CargoOrderDO order) {
        if (order.getBizRootId() != null) {
            BizRootDO root = bizRootMapper.selectById(order.getBizRootId());
            if (root != null && StrUtil.isNotBlank(root.getCurrentNode())) {
                return root.getCurrentNode();
            }
        }
        return order.getFulfillmentStatus();
    }

    private void ensureNotHolding(CargoOrderDO order) {
        if (Integer.valueOf(1).equals(order.getHoldFlag())) {
            throw exception(OMS_BIZ_ERROR, "货物订单HOLD中，不允许继续出单/出库动作");
        }
    }

    @Transactional(rollbackFor = Exception.class)
    protected Boolean doStatusTransition(Long id, String fromStatus, String toStatus, String action, String remark) {
        CargoOrderDO order = requireOrder(id);
        validateStatus(order, fromStatus);
        OmsStatusTransitionGuard.requireAllowed("cargo order", OmsStatusTransitionGuard.CARGO_ALLOWED, fromStatus, toStatus);
        return lifecycleService.transitionCargo(id, toStatus, action, remark);
    }

    private void saveTrace(Long cargoOrderId, String fromStatus, String toStatus, String action, String remark) {
        CargoOrderNodeTraceDO trace = new CargoOrderNodeTraceDO();
        trace.setCargoOrderId(cargoOrderId);
        trace.setNodeCode(toStatus);
        trace.setNodeStatus("DONE");
        trace.setStatusFrom(fromStatus);
        trace.setStatusTo(toStatus);
        trace.setAction(action);
        trace.setActualTime(new Date());
        trace.setSourceType("OMS");
        trace.setOperatorId(SecurityFrameworkUtils.getLoginUserId());
        trace.setOperatorName(SecurityFrameworkUtils.getLoginUserNickname());
        trace.setRemark(remark);
        trace.setCreateTime(new Date());
        nodeTraceMapper.insert(trace);
    }

    private void recalcEarliestDwTime(Long cargoOrderId) {
        Date earliest = shipmentMapper.selectMinDwTime(cargoOrderId);
        CargoOrderDO update = new CargoOrderDO();
        update.setId(cargoOrderId);
        update.setEarliestDwTime(earliest);
        baseMapper.updateById(update);
    }

    private void recalcShipmentSummary(Long cargoOrderId) {
        List<CargoOrderShipmentDO> shipments = shipmentMapper.selectList(new LambdaQueryWrapper<CargoOrderShipmentDO>()
            .eq(CargoOrderShipmentDO::getCargoOrderId, cargoOrderId));
        CargoOrderDO update = new CargoOrderDO();
        update.setId(cargoOrderId);
        update.setShipmentCodes(joinDistinct(shipments.stream().map(CargoOrderShipmentDO::getShipmentNo).toList()));
        update.setPoNos(joinDistinct(shipments.stream().map(CargoOrderShipmentDO::getPoNo).toList()));
        update.setMarks(joinDistinct(shipments.stream().map(CargoOrderShipmentDO::getShippingMark).toList()));
        update.setDeclaredCartonQty(sum(shipments.stream().map(CargoOrderShipmentDO::getCartonQty).toList()));
        update.setDeclaredWeight(sum(shipments.stream().map(CargoOrderShipmentDO::getWeight).toList()));
        update.setDeclaredCbm(sum(shipments.stream().map(CargoOrderShipmentDO::getCbm).toList()));
        update.setEarliestDwTime(shipments.stream()
            .map(CargoOrderShipmentDO::getDwTime)
            .filter(Objects::nonNull)
            .min(Date::compareTo)
            .orElse(null));
        baseMapper.updateById(update);
    }

    private BigDecimal sum(List<BigDecimal> values) {
        return values.stream()
            .filter(Objects::nonNull)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    private String joinDistinct(List<String> values) {
        return values.stream()
            .filter(StrUtil::isNotBlank)
            .distinct()
            .collect(Collectors.joining(", "));
    }

    private void recalcCargoAttachmentSummary(Long cargoOrderId) {
        List<BizAttachmentDO> attachments = attachmentMapper.selectList(new LambdaQueryWrapper<BizAttachmentDO>()
            .eq(BizAttachmentDO::getTargetType, "CARGO_ORDER")
            .eq(BizAttachmentDO::getTargetId, cargoOrderId));
        CargoOrderDO update = new CargoOrderDO();
        update.setId(cargoOrderId);
        update.setAttachmentCount(attachments.size());
        update.setPodAttachmentCount((int) attachments.stream().filter(item -> "POD".equals(item.getAttachmentType())).count());
        update.setExceptionAttachmentCount((int) attachments.stream().filter(item -> "EXCEPTION_IMAGE".equals(item.getAttachmentType())).count());
        update.setLatestAttachmentTime(attachments.stream()
            .map(BizAttachmentDO::getUploadTime)
            .filter(Objects::nonNull)
            .max(Date::compareTo)
            .orElse(null));
        baseMapper.updateById(update);
    }

    private void saveShipmentsForOrder(Long cargoOrderId, List<CargoOrderShipmentSaveReqVO> shipmentBos) {
        for (CargoOrderShipmentSaveReqVO bo : shipmentBos) {
            saveShipment(cargoOrderId, bo);
        }
    }
}
