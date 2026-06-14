package cn.iocoder.yudao.module.wms.service.devanningorder;

import cn.hutool.core.util.IdUtil;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils;
import cn.iocoder.yudao.module.wms.dal.dataobject.devanningorder.WmsDevanningOrderDO;
import cn.iocoder.yudao.module.wms.dal.dataobject.devanningorder.WmsDevanningOrderTraceDO;
import cn.iocoder.yudao.module.wms.controller.admin.devanningorder.vo.*;
import cn.iocoder.yudao.module.wms.controller.admin.devanningorder.vo.WmsDevanningOrderTraceRespVO;
import cn.iocoder.yudao.module.wms.controller.admin.devanningorder.vo.WmsDevanningOrderRespVO;
import cn.iocoder.yudao.module.wms.dal.mysql.devanningorder.WmsDevanningOrderMapper;
import cn.iocoder.yudao.module.wms.dal.mysql.devanningorder.WmsDevanningOrderTraceMapper;
import cn.iocoder.yudao.module.wms.service.devanningorder.WmsDevanningOrderService;
import cn.iocoder.yudao.module.wms.service.no.WmsNoGenerateService;
import cn.iocoder.yudao.module.oms.api.devanning.OmsContainerDevanningSyncService;
import cn.iocoder.yudao.module.org.framework.datapermission.annotation.OrgDataScope;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.wms.enums.ErrorCodeConstants.*;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Set;

@Service
@Validated
public class WmsDevanningOrderServiceImpl implements WmsDevanningOrderService {

    private static final String SOURCE_CONTAINER = "CONTAINER_ORDER";
    private static final Set<String> TERMINAL = Set.of("DEVANNED", "CANCELLED");

    @Resource
    private WmsDevanningOrderMapper orderMapper;
    @Resource
    private WmsDevanningOrderTraceMapper traceMapper;
    @Resource
    private WmsNoGenerateService noGenerateService;
    @Resource
    private OmsContainerDevanningSyncService omsSyncService;

    @Override
    @OrgDataScope(tableClass = WmsDevanningOrderDO.class, warehouseColumn = "warehouse_id")
    public PageResult<WmsDevanningOrderRespVO> getDevanningOrderPage(WmsDevanningOrderPageReqVO pageReqVO) {
        PageResult<WmsDevanningOrderDO> page = orderMapper.selectPage(pageReqVO);
        return new PageResult<>(BeanUtils.toBean(page.getList(), WmsDevanningOrderRespVO.class), page.getTotal());
    }

    @Override
    @OrgDataScope(tableClass = WmsDevanningOrderDO.class, warehouseColumn = "warehouse_id")
    public List<WmsDevanningOrderRespVO> getDevanningOrderList(WmsDevanningOrderPageReqVO pageReqVO) {
        return BeanUtils.toBean(orderMapper.selectList(orderMapper.buildWrapper(pageReqVO)), WmsDevanningOrderRespVO.class);
    }

    @Override
    @OrgDataScope(tableClass = WmsDevanningOrderDO.class, warehouseColumn = "warehouse_id")
    public WmsDevanningOrderRespVO getDevanningOrder(Long id) {
        WmsDevanningOrderDO row = orderMapper.selectById(id);
        if (row == null) {
            return null;
        }
        WmsDevanningOrderRespVO vo = BeanUtils.toBean(row, WmsDevanningOrderRespVO.class);
        List<WmsDevanningOrderTraceDO> traceRows = traceMapper.selectList(
            Wrappers.<WmsDevanningOrderTraceDO>lambdaQuery()
                .eq(WmsDevanningOrderTraceDO::getDevanningOrderId, id)
                .orderByDesc(WmsDevanningOrderTraceDO::getActionTime));
        vo.setTraces(BeanUtils.toBean(traceRows, WmsDevanningOrderTraceRespVO.class));
        return vo;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createDevanningOrder(WmsDevanningOrderSaveReqVO createReqVO) {
        WmsDevanningOrderDO entity = BeanUtils.toBean(createReqVO, WmsDevanningOrderDO.class);
                validateManualCreate(entity);
        entity.setDevanningNo(nextDevanningNo());
        entity.setSourceOrderType(StrUtil.blankToDefault(entity.getSourceOrderType(), "MANUAL"));
        entity.setStatus("UNPICKEDUP");
        entity.setDevanningMethod(StrUtil.blankToDefault(entity.getDevanningMethod(), "MANUAL"));
        entity.setExceptionFlag(0);
        entity.setExceptionCount(0);
        entity.setInboundedBoxQty(BigDecimal.ZERO);
        orderMapper.insert(entity);
        saveTrace(entity.getId(), null, entity.getStatus(), "create", "手动创建拆柜订单");
        return entity.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    @OrgDataScope(tableClass = WmsDevanningOrderDO.class, warehouseColumn = "warehouse_id")
    public void updateDevanningOrder(WmsDevanningOrderSaveReqVO updateReqVO) {
        WmsDevanningOrderDO existing = requireOrder(updateReqVO.getId());
        assertNotTerminal(existing);
        WmsDevanningOrderDO entity = BeanUtils.toBean(updateReqVO, WmsDevanningOrderDO.class);
                entity.setDevanningNo(existing.getDevanningNo());
        entity.setStatus(existing.getStatus());
        entity.setSourceOrderId(existing.getSourceOrderId());
        entity.setSourceOrderNo(existing.getSourceOrderNo());
        entity.setSourceOrderType(existing.getSourceOrderType());
        boolean ok = orderMapper.updateById(entity) > 0;
        if (ok) {
            saveTrace(existing.getId(), existing.getStatus(), existing.getStatus(), "edit", "编辑拆柜订单");
            syncPlannedTimeToOms(existing, entity.getPlannedDevanningTime());
        }
        }

    @Override
    @Transactional(rollbackFor = Exception.class)
    @OrgDataScope(tableClass = WmsDevanningOrderDO.class, warehouseColumn = "warehouse_id")
    public void deleteDevanningOrderList(List<Long> ids) {
        for (Long id : ids) {
            WmsDevanningOrderDO order = requireOrder(id);
            if (!"UNPICKEDUP".equals(order.getStatus()) && !"CANCELLED".equals(order.getStatus())) {
                throw exception(WMS_BIZ_ERROR, "仅未提柜或已取消的拆柜订单可删除");
            }
        }
        orderMapper.deleteByIds(ids);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long pushFromOms(WmsDevanningOrderPushReqVO bo) {
        if (bo == null || bo.getSourceOrderId() == null) {
            throw exception(WMS_BIZ_ERROR, "来源单ID不能为空");
        }
        String sourceType = StrUtil.blankToDefault(bo.getSourceOrderType(), SOURCE_CONTAINER);
        WmsDevanningOrderDO existing = findBySource(bo.getSourceOrderId(), sourceType);
        if (existing != null) {
            patchFromPush(existing, bo);
            orderMapper.updateById(existing);
            saveTrace(existing.getId(), existing.getStatus(), existing.getStatus(), "omsPush", "OMS推单更新");
            omsSyncService.assignDevanningOrderNo(bo.getSourceOrderId(), existing.getDevanningNo());
            return existing.getId();
        }
        WmsDevanningOrderDO entity = new WmsDevanningOrderDO();
        applyPushFields(entity, bo);
        entity.setSourceOrderType(sourceType);
        entity.setDevanningNo(nextDevanningNo());
        entity.setStatus(resolveInitialStatus(bo));
        entity.setDevanningMethod("MANUAL");
        entity.setExceptionFlag(0);
        entity.setExceptionCount(0);
        entity.setInboundedBoxQty(BigDecimal.ZERO);
        orderMapper.insert(entity);
        saveTrace(entity.getId(), null, entity.getStatus(), "omsPush", "OMS推单创建");
        omsSyncService.assignDevanningOrderNo(bo.getSourceOrderId(), entity.getDevanningNo());
        return entity.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void syncPickupFromOms(Long containerOrderId, Date pickupTime) {
        WmsDevanningOrderDO order = findBySource(containerOrderId, SOURCE_CONTAINER);
        if (order == null) {
            return;
        }
        if (TERMINAL.contains(order.getStatus()) || "CANCELLED".equals(order.getStatus())) {
            return;
        }
        String before = order.getStatus();
        order.setPickupTime(pickupTime != null ? pickupTime : new Date());
        if ("UNPICKEDUP".equals(order.getStatus())) {
            order.setStatus("PICKEDUP");
        }
        orderMapper.updateById(order);
        if (!StrUtil.equals(before, order.getStatus())) {
            saveTrace(order.getId(), before, order.getStatus(), "omsPickup", "OMS提柜同步");
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void syncDock(WmsDevanningOrderSyncDockReqVO bo) {
        if (bo == null || bo.getSourceOrderId() == null) {
            throw exception(WMS_BIZ_ERROR, "来源单ID不能为空");
        }
        String sourceType = StrUtil.blankToDefault(bo.getSourceOrderType(), SOURCE_CONTAINER);
        WmsDevanningOrderDO order = findBySource(bo.getSourceOrderId(), sourceType);
        if (order == null) {
            return;
        }
        order.setDockId(bo.getDockId());
        order.setDockCode(bo.getDockCode());
        order.setDockAssignTime(bo.getDockAssignTime() != null ? bo.getDockAssignTime() : new Date());
        orderMapper.updateById(order);
        saveTrace(order.getId(), order.getStatus(), order.getStatus(), "syncDock", "Dock分配同步");
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void confirmPickup(Long id, WmsDevanningOrderActionReqVO bo) {
        WmsDevanningOrderDO order = requireOrder(id);
        transition(order, "UNPICKEDUP", "PICKEDUP");
        order.setPickupTime(bo != null && bo.getPickupTime() != null ? bo.getPickupTime() : new Date());
        persistTransition(order, "confirmPickup", bo != null ? bo.getRemark() : null);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void confirmArrival(Long id, WmsDevanningOrderActionReqVO bo) {
        WmsDevanningOrderDO order = requireOrder(id);
        transition(order, "PICKEDUP", "ARRIVED");
        order.setActualArrivalTime(bo != null && bo.getActualArrivalTime() != null ? bo.getActualArrivalTime() : new Date());
        persistTransition(order, "confirmArrival", bo != null ? bo.getRemark() : null);
        if (SOURCE_CONTAINER.equals(order.getSourceOrderType())) {
            omsSyncService.syncArrival(order.getSourceOrderId(), order.getActualArrivalTime());
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void startDevanning(Long id, WmsDevanningOrderActionReqVO bo) {
        WmsDevanningOrderDO order = requireOrder(id);
        transition(order, "ARRIVED", "DEVANNING");
        order.setDevanningStartTime(bo != null && bo.getDevanningStartTime() != null ? bo.getDevanningStartTime() : new Date());
        if (bo != null && bo.getPlannedDevanningTime() != null) {
            order.setPlannedDevanningTime(bo.getPlannedDevanningTime());
        }
        persistTransition(order, "startDevanning", bo != null ? bo.getRemark() : null);
        if (SOURCE_CONTAINER.equals(order.getSourceOrderType())) {
            omsSyncService.syncDevanningStart(order.getSourceOrderId(), order.getDevanningStartTime());
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void completeDevanning(Long id, WmsDevanningOrderActionReqVO bo) {
        WmsDevanningOrderDO order = requireOrder(id);
        transition(order, "DEVANNING", "DEVANNED");
        order.setDevanningFinishTime(bo != null && bo.getDevanningFinishTime() != null ? bo.getDevanningFinishTime() : new Date());
        if (bo != null && bo.getInboundedBoxQty() != null) {
            order.setInboundedBoxQty(bo.getInboundedBoxQty());
        }
        persistTransition(order, "completeDevanning", bo != null ? bo.getRemark() : null);
        if (SOURCE_CONTAINER.equals(order.getSourceOrderType())) {
            omsSyncService.syncDevanningFinish(order.getSourceOrderId(), order.getDevanningFinishTime(), order.getInboundedBoxQty());
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void markException(Long id, WmsDevanningOrderActionReqVO bo) {
        WmsDevanningOrderDO order = requireOrder(id);
        if (TERMINAL.contains(order.getStatus())) {
            throw exception(WMS_BIZ_ERROR, "终态订单不可标记异常");
        }
        String before = order.getStatus();
        order.setStatus("EXCEPTION");
        order.setExceptionFlag(1);
        order.setExceptionCount((order.getExceptionCount() == null ? 0 : order.getExceptionCount()) + 1);
        if (bo != null && StrUtil.isNotBlank(bo.getRemark())) {
            order.setRemark(bo.getRemark());
        }
        orderMapper.updateById(order);
        saveTrace(order.getId(), before, order.getStatus(), "markException", "标记异常");
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void clearException(Long id, WmsDevanningOrderActionReqVO bo) {
        WmsDevanningOrderDO order = requireOrder(id);
        if (!"EXCEPTION".equals(order.getStatus())) {
            throw exception(WMS_BIZ_ERROR, "当前订单非异常状态");
        }
        String restored = resolveStatusAfterException(order);
        order.setStatus(restored);
        order.setExceptionFlag(0);
        orderMapper.updateById(order);
        saveTrace(order.getId(), "EXCEPTION", restored, "clearException", "解除异常");
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void cancel(Long id, WmsDevanningOrderActionReqVO bo) {
        WmsDevanningOrderDO order = requireOrder(id);
        if ("DEVANNED".equals(order.getStatus())) {
            throw exception(WMS_BIZ_ERROR, "拆柜已完成，不可取消");
        }
        String before = order.getStatus();
        order.setStatus("CANCELLED");
        orderMapper.updateById(order);
        saveTrace(order.getId(), before, order.getStatus(), "cancel", bo != null ? bo.getRemark() : "取消拆柜");
        if (SOURCE_CONTAINER.equals(order.getSourceOrderType())) {
            omsSyncService.syncCancel(order.getSourceOrderId(), bo != null ? bo.getRemark() : null);
        }
    }

    private void persistTransition(WmsDevanningOrderDO order, String action, String remark) {
        orderMapper.updateById(order);
        saveTrace(order.getId(), inferBeforeStatus(order, action), order.getStatus(), action, remark);
    }

    private String inferBeforeStatus(WmsDevanningOrderDO order, String action) {
        return switch (action) {
            case "confirmPickup" -> "UNPICKEDUP";
            case "confirmArrival" -> "PICKEDUP";
            case "startDevanning" -> "ARRIVED";
            case "completeDevanning" -> "DEVANNING";
            default -> order.getStatus();
        };
    }

    private void transition(WmsDevanningOrderDO order, String expected, String target) {
        if ("EXCEPTION".equals(order.getStatus())) {
            throw exception(WMS_BIZ_ERROR, "请先解除异常再操作");
        }
        if (!expected.equals(order.getStatus())) {
            throw exception(WMS_DEVANNING_STATUS_INVALID, "当前状态不允许此操作，期望：" + expected);
        }
        order.setStatus(target);
    }

    private void assertNotTerminal(WmsDevanningOrderDO order) {
        if (TERMINAL.contains(order.getStatus())) {
            throw exception(WMS_BIZ_ERROR, "终态订单不可编辑");
        }
    }

    private WmsDevanningOrderDO requireOrder(Long id) {
        WmsDevanningOrderDO order = orderMapper.selectById(id);
        if (order == null) {
            throw exception(WMS_DEVANNING_NOT_EXISTS);
        }
        return order;
    }

    private WmsDevanningOrderDO findBySource(Long sourceOrderId, String sourceOrderType) {
        return orderMapper.selectOne(Wrappers.<WmsDevanningOrderDO>lambdaQuery()
            .eq(WmsDevanningOrderDO::getSourceOrderId, sourceOrderId)
            .eq(WmsDevanningOrderDO::getSourceOrderType, sourceOrderType)
            .last("LIMIT 1"));
    }

    private void validateManualCreate(WmsDevanningOrderDO entity) {
        if (entity.getWarehouseId() == null || StrUtil.isBlank(entity.getContainerNo())) {
            throw exception(WMS_BIZ_ERROR, "仓库与柜号不能为空");
        }
    }

    private String nextDevanningNo() {
        return noGenerateService.generateDevanningNo();
    }

    private String resolveInitialStatus(WmsDevanningOrderPushReqVO bo) {
        if (StrUtil.isNotBlank(bo.getInitialStatus())) {
            return bo.getInitialStatus();
        }
        if (bo.getPickupTime() != null) {
            return "PICKEDUP";
        }
        return "UNPICKEDUP";
    }

    private void applyPushFields(WmsDevanningOrderDO entity, WmsDevanningOrderPushReqVO bo) {
        entity.setCompanyId(bo.getCompanyId());
        entity.setWarehouseId(bo.getWarehouseId());
        entity.setBizRootId(bo.getBizRootId());
        entity.setSourceOrderId(bo.getSourceOrderId());
        entity.setSourceOrderNo(bo.getSourceOrderNo());
        entity.setContainerNo(bo.getContainerNo());
        entity.setCustomerId(bo.getCustomerId());
        entity.setCustomerName(bo.getCustomerName());
        entity.setChannelId(bo.getChannelId());
        entity.setChannelName(bo.getChannelName());
        entity.setCustomerServiceId(bo.getCustomerServiceId());
        entity.setCustomerServiceName(bo.getCustomerServiceName());
        entity.setEtaWarehouseTime(bo.getEtaWarehouseTime());
        entity.setPickupTime(bo.getPickupTime());
        entity.setTotalBoxQty(bo.getTotalBoxQty());
        entity.setTotalWeight(bo.getTotalWeight());
        entity.setTotalCbm(bo.getTotalCbm());
    }

    private void patchFromPush(WmsDevanningOrderDO entity, WmsDevanningOrderPushReqVO bo) {
        if (bo.getWarehouseId() != null) entity.setWarehouseId(bo.getWarehouseId());
        if (StrUtil.isNotBlank(bo.getContainerNo())) entity.setContainerNo(bo.getContainerNo());
        if (bo.getEtaWarehouseTime() != null) entity.setEtaWarehouseTime(bo.getEtaWarehouseTime());
        if (bo.getPickupTime() != null) {
            entity.setPickupTime(bo.getPickupTime());
            if ("UNPICKEDUP".equals(entity.getStatus())) {
                entity.setStatus("PICKEDUP");
            }
        }
        if (bo.getTotalBoxQty() != null) entity.setTotalBoxQty(bo.getTotalBoxQty());
        if (bo.getTotalWeight() != null) entity.setTotalWeight(bo.getTotalWeight());
        if (bo.getTotalCbm() != null) entity.setTotalCbm(bo.getTotalCbm());
        if (StrUtil.isNotBlank(bo.getSourceOrderNo())) entity.setSourceOrderNo(bo.getSourceOrderNo());
    }

    private void syncPlannedTimeToOms(WmsDevanningOrderDO existing, Date planned) {
        if (existing == null || planned == null || !SOURCE_CONTAINER.equals(existing.getSourceOrderType())) {
            return;
        }
        omsSyncService.syncPlannedDevanningTime(existing.getSourceOrderId(), planned);
    }

    private String resolveStatusAfterException(WmsDevanningOrderDO order) {
        if (order.getDevanningStartTime() != null) {
            return "DEVANNING";
        }
        if (order.getActualArrivalTime() != null) {
            return "ARRIVED";
        }
        if (order.getPickupTime() != null) {
            return "PICKEDUP";
        }
        return "UNPICKEDUP";
    }

    private void saveTrace(Long orderId, String before, String after, String actionType, String content) {
        WmsDevanningOrderTraceDO trace = new WmsDevanningOrderTraceDO();
        trace.setDevanningOrderId(orderId);
        trace.setActionType(actionType);
        trace.setBeforeStatus(before);
        trace.setAfterStatus(after);
        trace.setActionContent(content);
        trace.setActionTime(new Date());
        try {
            trace.setOperatorId(SecurityFrameworkUtils.getLoginUserId());
            trace.setOperatorName(SecurityFrameworkUtils.getLoginUserNickname());
        } catch (Exception ignored) {
            // 系统回调无登录态
        }
        traceMapper.insert(trace);
    }

}
