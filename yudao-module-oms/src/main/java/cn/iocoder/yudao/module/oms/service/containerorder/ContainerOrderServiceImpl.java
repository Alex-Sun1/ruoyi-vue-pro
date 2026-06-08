package cn.iocoder.yudao.module.oms.service.containerorder;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.oms.enums.ErrorCodeConstants.*;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.IdUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.module.base.dal.dataobject.company.CompanyDO;
import cn.iocoder.yudao.module.base.dal.dataobject.warehouse.WarehouseDO;
import cn.iocoder.yudao.module.base.dal.dataobject.businesstype.BusinessTypeDO;
import cn.iocoder.yudao.module.base.dal.dataobject.channel.ChannelDO;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.dal.mysql.businesstype.BusinessTypeMapper;
import cn.iocoder.yudao.module.base.dal.mysql.channel.ChannelMapper;
import cn.iocoder.yudao.module.base.dal.mysql.company.CompanyMapper;
import cn.iocoder.yudao.module.base.dal.mysql.warehouse.BaseWarehouseMapper;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.module.org.framework.datapermission.annotation.OrgDataScope;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils;
import cn.iocoder.yudao.module.oms.dal.dataobject.containerorder.ContainerCargoOrderRelDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.containerorder.ContainerOrderTraceDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder.CargoOrderShipmentDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.containerorder.ContainerOrderDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.biz.BizAttachmentDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder.CargoOrderDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.biz.BizRootDO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderSaveReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderShipmentSaveReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.bizattachment.vo.BizAttachmentSaveReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerOrderSaveReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerOrderPageReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerOrderStatusReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderShipmentRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.bizattachment.vo.BizAttachmentRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerOrderTraceRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerCargoOrderImportExcelVO;
import cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerOrderRespVO;
import cn.iocoder.yudao.module.oms.dal.mysql.containerorder.ContainerCargoOrderRelMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.containerorder.ContainerOrderTraceMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.cargoorder.CargoOrderShipmentMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.containerorder.ContainerOrderMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.biz.BizAttachmentMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.cargoorder.CargoOrderMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.biz.BizRootMapper;
import cn.iocoder.yudao.module.oms.api.devanning.dto.OmsDevanningPushDTO;
import cn.iocoder.yudao.module.oms.api.devanning.WmsDevanningOrderBridge;
import cn.iocoder.yudao.module.oms.integration.OmsYmsDispatchIntegration;
import cn.iocoder.yudao.module.oms.service.containerorder.ContainerOrderService;
import cn.iocoder.yudao.module.oms.support.ContainerPrePlanSummaryService;
import org.springframework.beans.factory.ObjectProvider;
import cn.iocoder.yudao.module.oms.support.OmsLambdaQueryHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

// ── 状态顺序（用于「只向前推进」校验） ────────────────────────────────────────

/**
 * 海柜订单服务实现
 */
@Service
public class ContainerOrderServiceImpl implements ContainerOrderService {

    private static final String STATUS_DRAFT = "DRAFT";
    private static final String STATUS_PENDING = "PENDING_ACCEPT";
    private static final String REL_ACTIVE = "ACTIVE";
    private static final String REL_MANUAL_CREATE = "MANUAL_CREATE";

    private static final List<String> STATUS_ORDER = List.of(
        "DRAFT", "PENDING_ACCEPT", "IN_TRANSIT", "ARRIVED_PORT",
        "AVAILABLE_FOR_PICKUP", "PICKUP_APPOINTED", "PICKED_UP",
        "ARRIVED_WAREHOUSE", "DEVANNING", "DEVANNED", "EMPTY_RETURNED", "COMPLETED"
    );
    private static final Map<String, Integer> STATUS_RANK;
    static {
        Map<String, Integer> m = new HashMap<>();
        for (int i = 0; i < STATUS_ORDER.size(); i++) m.put(STATUS_ORDER.get(i), i);
        m.put("HOLDING", 3);    // 与 ARRIVED_PORT 同级，HOLD 解除后继续向前
        m.put("EXAMINING", 3);  // 同上
        STATUS_RANK = Collections.unmodifiableMap(m);
    }

    @Resource
    private ContainerOrderMapper baseMapper;
    @Resource
    private CargoOrderMapper cargoOrderMapper;
    @Resource
    private CargoOrderShipmentMapper shipmentMapper;
    @Resource
    private ContainerCargoOrderRelMapper relationMapper;
    @Resource
    private ContainerOrderTraceMapper traceMapper;
    @Resource
    private BizRootMapper bizRootMapper;
    @Resource
    private CompanyMapper companyMapper;
    @Resource
    private BaseWarehouseMapper warehouseMapper;
    @Resource
    private ChannelMapper channelMapper;
    @Resource
    private BusinessTypeMapper businessTypeMapper;
    @Resource
    private BizAttachmentMapper attachmentMapper;
    @Resource
    private ContainerPrePlanSummaryService containerPrePlanSummaryService;
    @Resource
    private OmsYmsDispatchIntegration omsYmsDispatchIntegration;
    @Resource
    private ObjectProvider<WmsDevanningOrderBridge> wmsDevanningOrderBridgeProvider;

    @Override
    @OrgDataScope(tableClass = ContainerOrderDO.class, tableAlias = "oms_container_order", warehouseColumn = "warehouse_id")
    public PageResult<ContainerOrderRespVO> queryPageList(ContainerOrderPageReqVO bo, PageParam pageQuery) {
        PageResult<ContainerOrderDO> page = baseMapper.selectPage(pageQuery, buildQueryWrapper(bo));
        List<ContainerOrderRespVO> records = BeanUtils.toBean(page.getList(), ContainerOrderRespVO.class);
        fillNames(records);
        return new PageResult<>(records, page.getTotal());
    }

    @Override
    @OrgDataScope(tableClass = ContainerOrderDO.class, tableAlias = "oms_container_order", warehouseColumn = "warehouse_id")
    public List<ContainerOrderRespVO> queryList(ContainerOrderPageReqVO bo) {
        List<ContainerOrderRespVO> list = BeanUtils.toBean(baseMapper.selectList(buildQueryWrapper(bo)), ContainerOrderRespVO.class);
        fillNames(list);
        return list;
    }

    @Override
    @OrgDataScope(tableClass = ContainerOrderDO.class, tableAlias = "oms_container_order", warehouseColumn = "warehouse_id")
    public Map<String, Long> queryStatusCount(ContainerOrderPageReqVO bo) {
        String currentStatus = bo.getContainerStatus();
        bo.setContainerStatus(null);
        List<ContainerOrderDO> list = baseMapper.selectList(buildQueryWrapper(bo));
        bo.setContainerStatus(currentStatus);
        Map<String, Long> result = list.stream()
            .filter(item -> StrUtil.isNotBlank(item.getContainerStatus()))
            .collect(Collectors.groupingBy(ContainerOrderDO::getContainerStatus, Collectors.counting()));
        result.put("", (long) list.size());
        return result;
    }

    @Override
    public ContainerOrderRespVO queryById(Long id) {
        ContainerOrderRespVO vo = BeanUtils.toBean(baseMapper.selectById(id), ContainerOrderRespVO.class);
        if (vo == null) {
            return null;
        }
        fillNames(List.of(vo));
        List<CargoOrderRespVO> cargoOrders = BeanUtils.toBean(cargoOrderMapper.selectList(new LambdaQueryWrapper<CargoOrderDO>()
            .in(CargoOrderDO::getId, listCargoOrderIdsByContainer(id))
            .orderByAsc(CargoOrderDO::getCreateTime)), CargoOrderRespVO.class);
        if (CollUtil.isNotEmpty(cargoOrders)) {
            List<Long> cargoIds = cargoOrders.stream().map(CargoOrderRespVO::getId).toList();
            Map<Long, List<CargoOrderShipmentRespVO>> shipmentMap = BeanUtils.toBean(shipmentMapper.selectList(new LambdaQueryWrapper<CargoOrderShipmentDO>()
                    .in(CargoOrderShipmentDO::getCargoOrderId, cargoIds)
                    .orderByAsc(CargoOrderShipmentDO::getCreateTime)), CargoOrderShipmentRespVO.class)
                .stream().collect(Collectors.groupingBy(CargoOrderShipmentRespVO::getCargoOrderId));
            cargoOrders.forEach(item -> item.setShipments(shipmentMap.getOrDefault(item.getId(), new ArrayList<>())));
        }
        vo.setCargoOrders(cargoOrders);
        vo.setTraces(BeanUtils.toBean(traceMapper.selectList(new LambdaQueryWrapper<ContainerOrderTraceDO>()
            .eq(ContainerOrderTraceDO::getContainerOrderId, id)
            .orderByDesc(ContainerOrderTraceDO::getCreateTime)), ContainerOrderTraceRespVO.class));
        return vo;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean insertByBo(ContainerOrderSaveReqVO bo, boolean draft) {
        validateCargoOrders(bo, draft);
        ContainerOrderDO add = BeanUtils.toBean(bo, ContainerOrderDO.class);
        if (StrUtil.isBlank(add.getContainerOrderNo())) {
            add.setContainerOrderNo(generateNo("SO"));
        }
        add.setOrderSource(StrUtil.blankToDefault(add.getOrderSource(), "MANUAL"));
        add.setContainerStatus(draft ? STATUS_DRAFT : StrUtil.blankToDefault(bo.getContainerStatus(), STATUS_PENDING));
        add.setStatus("0");
        initSummary(add);
        boolean inserted = baseMapper.insert(add) > 0;
        saveCargoOrders(add, bo.getCargoOrders());
        saveTrace(add, null, add.getContainerStatus(), draft ? "saveDraft" : "create", draft ? "保存草稿" : "创建海柜订单");
        return inserted;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean updateByBo(ContainerOrderSaveReqVO bo) {
        ContainerOrderDO existing = baseMapper.selectById(bo.getId());
        if (existing == null) {
            throw exception(OMS_BIZ_ERROR, "海柜订单不存在");
        }
        validateCargoOrders(bo, false);
        ContainerOrderDO update = BeanUtils.toBean(bo, ContainerOrderDO.class);
        update.setContainerOrderNo(null);
        update.setContainerStatus(null);
        update.setDeleted(null);
        boolean updated = baseMapper.updateById(update) > 0;
        ContainerOrderDO reloaded = baseMapper.selectById(bo.getId());
        upsertCargoOrders(reloaded, bo.getCargoOrders());
        recalcSummary(bo.getId());
        saveTrace(reloaded, existing.getContainerStatus(), existing.getContainerStatus(), "edit", "编辑海柜基础信息");
        if (updated) {
            if (shouldPushAfterDevanningAppointment(existing, reloaded)) {
                omsYmsDispatchIntegration.pushContainerDevanningTask(reloaded.getId());
            }
            applyFieldDrivenStatusAdvance(existing, reloaded);
        }
        return updated;
    }

    private boolean shouldPushAfterDevanningAppointment(ContainerOrderDO before, ContainerOrderDO after) {
        // 草稿和已取消不推
        if (Set.of("DRAFT", "CANCELLED").contains(after.getContainerStatus())) {
            return false;
        }
        if (after.getDevanningAppointmentTime() == null || after.getWarehouseId() == null) {
            return false;
        }
        // 预约时间没有变化则跳过（幂等保护）
        if (before.getDevanningAppointmentTime() != null
            && before.getDevanningAppointmentTime().equals(after.getDevanningAppointmentTime())) {
            return false;
        }
        return true;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean updateStatus(Long id, ContainerOrderStatusReqVO bo) {
        // 受理动作直接进入「在途」，ACCEPTED 不单独停留
        if ("ACCEPTED".equals(bo.getTargetStatus())) {
            bo.setTargetStatus("IN_TRANSIT");
        }
        ContainerOrderDO existing = baseMapper.selectById(id);
        if (existing == null) {
            throw exception(OMS_BIZ_ERROR, "海柜订单不存在");
        }
        if (StrUtil.equals(existing.getContainerStatus(), bo.getTargetStatus())) {
            return true;
        }
        ContainerOrderDO update = new ContainerOrderDO();
        update.setId(id);
        update.setContainerStatus(bo.getTargetStatus());
        if (bo.getActualArrivalTime() != null)   update.setActualArrivalTime(bo.getActualArrivalTime());
        if (bo.getDevanningStartTime() != null)  update.setDevanningStartTime(bo.getDevanningStartTime());
        if (bo.getDevanningFinishTime() != null) update.setDevanningFinishTime(bo.getDevanningFinishTime());
        if (bo.getContainerLocation() != null)   update.setContainerLocation(bo.getContainerLocation());
        boolean updated = baseMapper.updateById(update) > 0;
        saveTrace(existing, existing.getContainerStatus(), bo.getTargetStatus(), "updateStatus", bo.getRemark());
        // 提柜 → 提前推 YMS，让调度员看到海柜即将到仓
        if (updated && "PICKED_UP".equals(bo.getTargetStatus())) {
            omsYmsDispatchIntegration.pushContainerDevanningTask(id);
        }
        // OMS 手动到仓 → 同步 YMS gateInTime 并推进任务到 ARRIVED
        // syncContainerArrival 内部不回调 OMS，不会形成循环
        if (updated && "ARRIVED_WAREHOUSE".equals(bo.getTargetStatus())) {
            omsYmsDispatchIntegration.syncContainerArrival(id, bo.getActualArrivalTime());
        }
        if (updated && "IN_TRANSIT".equals(bo.getTargetStatus())) {
            ContainerOrderDO reloaded = baseMapper.selectById(id);
            pushWmsDevanningOrder(reloaded);
        }
        if (updated && "PICKED_UP".equals(bo.getTargetStatus())) {
            ContainerOrderDO reloaded = baseMapper.selectById(id);
            Date pickupTime = reloaded != null && reloaded.getActualPickupTime() != null
                ? reloaded.getActualPickupTime() : new Date();
            WmsDevanningOrderBridge bridge = wmsDevanningOrderBridgeProvider.getIfAvailable();
            if (bridge != null) {
                bridge.syncPickupFromOms(id, pickupTime);
            }
        }
        return updated;
    }

    private void pushWmsDevanningOrder(ContainerOrderDO order) {
        if (order == null || order.getWarehouseId() == null) {
            return;
        }
        try {
            WmsDevanningOrderBridge bridge = wmsDevanningOrderBridgeProvider.getIfAvailable();
            if (bridge != null) {
                bridge.pushFromOms(buildOmsDevanningPushDTO(order));
            }
        } catch (Exception ex) {
            // WMS 未部署或推单失败不阻断 OMS 主流程
        }
    }

    private OmsDevanningPushDTO buildOmsDevanningPushDTO(ContainerOrderDO order) {
        OmsDevanningPushDTO bo = new OmsDevanningPushDTO();
        bo.setSourceOrderId(order.getId());
        bo.setSourceOrderNo(order.getContainerOrderNo());
        bo.setSourceOrderType("CONTAINER_ORDER");
        bo.setCompanyId(order.getCompanyId());
        bo.setContainerNo(order.getContainerNo());
        bo.setCustomerId(order.getCustomerId());
        bo.setCustomerName(order.getCustomerName());
        bo.setChannelId(order.getChannelId());
        bo.setCustomerServiceId(order.getCustomerServiceId());
        bo.setCustomerServiceName(order.getCustomerServiceName());
        bo.setWarehouseId(order.getWarehouseId());
        bo.setEtaWarehouseTime(order.getExpectedArrivalTime() != null ? order.getExpectedArrivalTime() : order.getEta());
        bo.setPickupTime(order.getActualPickupTime());
        bo.setTotalBoxQty(order.getTotalCartonQty());
        bo.setTotalWeight(order.getTotalWeight());
        bo.setTotalCbm(order.getTotalCbm());
        if (order.getChannelId() != null && StrUtil.isBlank(bo.getChannelName())) {
            ChannelDO channel = channelMapper.selectById(order.getChannelId());
            if (channel != null) {
                bo.setChannelName(channel.getChannelName());
            }
        }
        return bo;
    }

    @Override
    public List<BizAttachmentRespVO> queryAttachments(Long id) {
        return BeanUtils.toBean(attachmentMapper.selectList(new LambdaQueryWrapper<BizAttachmentDO>()
            .eq(BizAttachmentDO::getTargetType, "CONTAINER_ORDER")
            .eq(BizAttachmentDO::getTargetId, id)
            .orderByDesc(BizAttachmentDO::getUploadTime)), BizAttachmentRespVO.class);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean uploadAttachment(Long id, BizAttachmentSaveReqVO bo, boolean doFile) {
        ContainerOrderDO order = baseMapper.selectById(id);
        if (order == null) {
            throw exception(OMS_BIZ_ERROR, "海柜订单不存在");
        }
        BizAttachmentDO attachment = BeanUtils.toBean(bo, BizAttachmentDO.class);
        attachment.setTargetType("CONTAINER_ORDER");
        attachment.setTargetId(order.getId());
        attachment.setTargetNo(order.getContainerOrderNo());
        attachment.setBizRootId(null);
        attachment.setAttachmentType(doFile ? "DO" : StrUtil.blankToDefault(bo.getAttachmentType(), "OTHER"));
        attachment.setCustomerVisibleFlag(Optional.ofNullable(attachment.getCustomerVisibleFlag()).orElse(0));
        attachment.setInternalVisibleFlag(Optional.ofNullable(attachment.getInternalVisibleFlag()).orElse(1));
        attachment.setUploadUserId(SecurityFrameworkUtils.getLoginUserId());
        attachment.setUploadUserName(SecurityFrameworkUtils.getLoginUserNickname());
        attachment.setUploadTime(new Date());
        attachmentMapper.insert(attachment);
        recalcContainerAttachmentSummary(id);
        saveTrace(order, order.getContainerStatus(), order.getContainerStatus(),
            doFile ? "CONTAINER_DO_UPLOADED" : "CONTAINER_ATTACHMENT_UPLOADED", attachment.getFileName());
        return Boolean.TRUE;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean removeAttachment(Long attachmentId) {
        BizAttachmentDO attachment = attachmentMapper.selectById(attachmentId);
        if (attachment == null || !"CONTAINER_ORDER".equals(attachment.getTargetType())) {
            throw exception(OMS_BIZ_ERROR, "海柜附件不存在");
        }
        attachmentMapper.deleteById(attachmentId);
        recalcContainerAttachmentSummary(attachment.getTargetId());
        return Boolean.TRUE;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean deleteWithValidByIds(List<Long> ids) {
        if (CollUtil.isEmpty(ids)) {
            return false;
        }
        ids.forEach(this::deleteChildren);
        return baseMapper.deleteByIds(ids) > 0;
    }

    private LambdaQueryWrapper<ContainerOrderDO> buildQueryWrapper(ContainerOrderPageReqVO bo) {
        LambdaQueryWrapper<ContainerOrderDO> lqw = new LambdaQueryWrapper<>();
        lqw.like(StrUtil.isNotBlank(bo.getContainerOrderNo()), ContainerOrderDO::getContainerOrderNo, bo.getContainerOrderNo());
        lqw.like(StrUtil.isNotBlank(bo.getContainerNo()), ContainerOrderDO::getContainerNo, bo.getContainerNo());
        lqw.eq(bo.getCompanyId() != null, ContainerOrderDO::getCompanyId, bo.getCompanyId());
        lqw.eq(bo.getCustomerId() != null, ContainerOrderDO::getCustomerId, bo.getCustomerId());
        lqw.like(StrUtil.isNotBlank(bo.getCustomerName()), ContainerOrderDO::getCustomerName, bo.getCustomerName());
        OmsLambdaQueryHelper.inLongCsv(lqw, ContainerOrderDO::getChannelId, bo.getChannelId());
        OmsLambdaQueryHelper.inLongCsv(lqw, ContainerOrderDO::getBusinessTypeId, bo.getBusinessTypeId());
        OmsLambdaQueryHelper.inLongCsv(lqw, ContainerOrderDO::getWarehouseId, bo.getWarehouseId());
        OmsLambdaQueryHelper.inLongCsv(lqw, ContainerOrderDO::getShippingLineId, bo.getShippingLineId());
        OmsLambdaQueryHelper.inStringCsv(lqw, ContainerOrderDO::getOrderSource, bo.getOrderSource());
        lqw.like(StrUtil.isNotBlank(bo.getOwnerUserName()), ContainerOrderDO::getOwnerUserName, bo.getOwnerUserName());
        lqw.like(StrUtil.isNotBlank(bo.getCustomerServiceName()), ContainerOrderDO::getCustomerServiceName, bo.getCustomerServiceName());
        lqw.like(StrUtil.isNotBlank(bo.getShippingLineName()), ContainerOrderDO::getShippingLineName, bo.getShippingLineName());
        OmsLambdaQueryHelper.inStringCsv(lqw, ContainerOrderDO::getContainerType, bo.getContainerType());
        lqw.like(StrUtil.isNotBlank(bo.getSealNo()), ContainerOrderDO::getSealNo, bo.getSealNo());
        lqw.like(StrUtil.isNotBlank(bo.getVesselName()), ContainerOrderDO::getVesselName, bo.getVesselName());
        lqw.like(StrUtil.isNotBlank(bo.getVoyageNo()), ContainerOrderDO::getVoyageNo, bo.getVoyageNo());
        lqw.like(StrUtil.isNotBlank(bo.getRouteCode()), ContainerOrderDO::getRouteCode, bo.getRouteCode());
        lqw.like(StrUtil.isNotBlank(bo.getMblNo()), ContainerOrderDO::getMblNo, bo.getMblNo());
        lqw.like(StrUtil.isNotBlank(bo.getHblNo()), ContainerOrderDO::getHblNo, bo.getHblNo());
        lqw.like(StrUtil.isNotBlank(bo.getDischargePortName()), ContainerOrderDO::getDischargePortName, bo.getDischargePortName());
        lqw.like(StrUtil.isNotBlank(bo.getTerminalName()), ContainerOrderDO::getTerminalName, bo.getTerminalName());
        OmsLambdaQueryHelper.inStringCsv(lqw, ContainerOrderDO::getContainerStatus, bo.getContainerStatus());
        OmsLambdaQueryHelper.inStringCsv(lqw, ContainerOrderDO::getTerminalReleaseStatus, bo.getTerminalReleaseStatus());
        OmsLambdaQueryHelper.inIntegerCsv(lqw, ContainerOrderDO::getHoldFlag, bo.getHoldFlag());
        OmsLambdaQueryHelper.likeAnyStringCsv(lqw, ContainerOrderDO::getHoldTypes, bo.getHoldTypes());
        lqw.like(StrUtil.isNotBlank(bo.getHoldRemark()), ContainerOrderDO::getHoldRemark, bo.getHoldRemark());
        OmsLambdaQueryHelper.inIntegerCsv(lqw, ContainerOrderDO::getExamFlag, bo.getExamFlag());
        OmsLambdaQueryHelper.likeAnyStringCsv(lqw, ContainerOrderDO::getExamType, bo.getExamType());
        lqw.like(StrUtil.isNotBlank(bo.getExamRemark()), ContainerOrderDO::getExamRemark, bo.getExamRemark());
        lqw.like(StrUtil.isNotBlank(bo.getDrayageVendorName()), ContainerOrderDO::getDrayageVendorName, bo.getDrayageVendorName());
        lqw.like(StrUtil.isNotBlank(bo.getPickupAppointmentNo()), ContainerOrderDO::getPickupAppointmentNo, bo.getPickupAppointmentNo());
        lqw.like(StrUtil.isNotBlank(bo.getPickupRemark()), ContainerOrderDO::getPickupRemark, bo.getPickupRemark());
        lqw.like(StrUtil.isNotBlank(bo.getContainerLocation()), ContainerOrderDO::getContainerLocation, bo.getContainerLocation());
        lqw.like(StrUtil.isNotBlank(bo.getArrivalRemark()), ContainerOrderDO::getArrivalRemark, bo.getArrivalRemark());
        lqw.like(StrUtil.isNotBlank(bo.getDevanningNo()), ContainerOrderDO::getDevanningNo, bo.getDevanningNo());
        OmsLambdaQueryHelper.inStringCsv(lqw, ContainerOrderDO::getDevanningMethod, bo.getDevanningMethod());
        OmsLambdaQueryHelper.inStringCsv(lqw, ContainerOrderDO::getLoadingType, bo.getLoadingType());
        OmsLambdaQueryHelper.inStringCsv(lqw, ContainerOrderDO::getSortingMethod, bo.getSortingMethod());
        lqw.like(StrUtil.isNotBlank(bo.getDevanningRemark()), ContainerOrderDO::getDevanningRemark, bo.getDevanningRemark());
        lqw.like(StrUtil.isNotBlank(bo.getEmptyReturnLocation()), ContainerOrderDO::getEmptyReturnLocation, bo.getEmptyReturnLocation());
        lqw.like(StrUtil.isNotBlank(bo.getEmptyReturnRemark()), ContainerOrderDO::getEmptyReturnRemark, bo.getEmptyReturnRemark());
        lqw.eq(bo.getContainerExceptionFlag() != null, ContainerOrderDO::getContainerExceptionFlag, bo.getContainerExceptionFlag());
        lqw.like(StrUtil.isNotBlank(bo.getContainerExceptionType()), ContainerOrderDO::getContainerExceptionType, bo.getContainerExceptionType());
        OmsLambdaQueryHelper.inIntegerCsv(lqw, ContainerOrderDO::getDownstreamExceptionFlag, bo.getDownstreamExceptionFlag());
        if (StrUtil.isNotBlank(bo.getKeyword())) {
            lqw.and(wrapper -> wrapper
                .like(ContainerOrderDO::getContainerOrderNo, bo.getKeyword())
                .or().like(ContainerOrderDO::getContainerNo, bo.getKeyword())
                .or().like(ContainerOrderDO::getCustomerName, bo.getKeyword())
                .or().like(ContainerOrderDO::getShippingLineName, bo.getKeyword())
                .or().like(ContainerOrderDO::getVesselName, bo.getKeyword())
                .or().like(ContainerOrderDO::getVoyageNo, bo.getKeyword())
                .or().like(ContainerOrderDO::getRouteCode, bo.getKeyword())
                .or().like(ContainerOrderDO::getMblNo, bo.getKeyword())
                .or().like(ContainerOrderDO::getHblNo, bo.getKeyword())
                .or().like(ContainerOrderDO::getTerminalName, bo.getKeyword())
                .or().like(ContainerOrderDO::getDischargePortName, bo.getKeyword())
                .or().like(ContainerOrderDO::getWarehouseId, bo.getKeyword())
                .or().like(ContainerOrderDO::getContainerLocation, bo.getKeyword())
                .or().like(ContainerOrderDO::getDevanningNo, bo.getKeyword()));
        }
        lqw.ge(bo.getBeginEta() != null, ContainerOrderDO::getEta, bo.getBeginEta());
        lqw.le(bo.getEndEta() != null, ContainerOrderDO::getEta, bo.getEndEta());
        lqw.ge(bo.getBeginPickupLfd() != null, ContainerOrderDO::getPickupLfd, bo.getBeginPickupLfd());
        lqw.le(bo.getEndPickupLfd() != null, ContainerOrderDO::getPickupLfd, bo.getEndPickupLfd());
        lqw.ge(bo.getBeginEmptyReturnLfd() != null, ContainerOrderDO::getEmptyReturnLfd, bo.getBeginEmptyReturnLfd());
        lqw.le(bo.getEndEmptyReturnLfd() != null, ContainerOrderDO::getEmptyReturnLfd, bo.getEndEmptyReturnLfd());
        lqw.ge(bo.getBeginAta() != null, ContainerOrderDO::getAta, bo.getBeginAta());
        lqw.le(bo.getEndAta() != null, ContainerOrderDO::getAta, bo.getEndAta());
        lqw.ge(bo.getBeginActualPickupTime() != null, ContainerOrderDO::getActualPickupTime, bo.getBeginActualPickupTime());
        lqw.le(bo.getEndActualPickupTime() != null, ContainerOrderDO::getActualPickupTime, bo.getEndActualPickupTime());
        lqw.ge(bo.getBeginExpectedArrivalTime() != null, ContainerOrderDO::getExpectedArrivalTime, bo.getBeginExpectedArrivalTime());
        lqw.le(bo.getEndExpectedArrivalTime() != null, ContainerOrderDO::getExpectedArrivalTime, bo.getEndExpectedArrivalTime());
        lqw.ge(bo.getBeginActualArrivalTime() != null, ContainerOrderDO::getActualArrivalTime, bo.getBeginActualArrivalTime());
        lqw.le(bo.getEndActualArrivalTime() != null, ContainerOrderDO::getActualArrivalTime, bo.getEndActualArrivalTime());
        lqw.ge(bo.getBeginExpectedDevanningTime() != null, ContainerOrderDO::getExpectedDevanningTime, bo.getBeginExpectedDevanningTime());
        lqw.le(bo.getEndExpectedDevanningTime() != null, ContainerOrderDO::getExpectedDevanningTime, bo.getEndExpectedDevanningTime());
        lqw.ge(bo.getBeginDevanningStartTime() != null, ContainerOrderDO::getDevanningStartTime, bo.getBeginDevanningStartTime());
        lqw.le(bo.getEndDevanningStartTime() != null, ContainerOrderDO::getDevanningStartTime, bo.getEndDevanningStartTime());
        lqw.ge(bo.getBeginDevanningFinishTime() != null, ContainerOrderDO::getDevanningFinishTime, bo.getBeginDevanningFinishTime());
        lqw.le(bo.getEndDevanningFinishTime() != null, ContainerOrderDO::getDevanningFinishTime, bo.getEndDevanningFinishTime());
        lqw.ge(bo.getBeginEmptyReturnTime() != null, ContainerOrderDO::getEmptyReturnTime, bo.getBeginEmptyReturnTime());
        lqw.le(bo.getEndEmptyReturnTime() != null, ContainerOrderDO::getEmptyReturnTime, bo.getEndEmptyReturnTime());
        lqw.orderByDesc(ContainerOrderDO::getCreateTime);
        return lqw;
    }

    private void validateCargoOrders(ContainerOrderSaveReqVO bo, boolean draft) {
        if (draft || CollUtil.isEmpty(bo.getCargoOrders())) {
            return;
        }
        for (CargoOrderSaveReqVO cargoOrder : bo.getCargoOrders()) {
            boolean hasAny = StrUtil.isNotBlank(cargoOrder.getCargoOrderNo())
                || cargoOrder.getCustomerId() != null
                || StrUtil.isNotBlank(cargoOrder.getCustomerName())
                || CollUtil.isNotEmpty(cargoOrder.getShipments());
            if (!hasAny) {
                continue;
            }
            if (cargoOrder.getCustomerId() == null || StrUtil.isBlank(cargoOrder.getCustomerName())) {
                throw exception(OMS_BIZ_ERROR, "货物订单客户不能为空");
            }
            if (CollUtil.isEmpty(cargoOrder.getShipments())) {
                throw exception(OMS_BIZ_ERROR, "货物订单[" + StrUtil.blankToDefault(cargoOrder.getCargoOrderNo(), "未生成编号") + "]至少需要一条货件");
            }
            Set<String> shipmentCodes = new HashSet<>();
            for (CargoOrderShipmentSaveReqVO shipment : cargoOrder.getShipments()) {
                if (StrUtil.isBlank(shipment.getShipmentNo())) {
                    throw exception(OMS_BIZ_ERROR, "货件编码不能为空");
                }
                if (!shipmentCodes.add(shipment.getShipmentNo())) {
                    throw exception(OMS_BIZ_ERROR, String.valueOf("同一货物订单下货件编码不能重复：" + shipment.getShipmentNo()));
                }
            }
        }
    }

    /**
     * 编辑时 upsert 货物订单：有 id 的 UPDATE，没有 id 的 INSERT，旧的没在提交列表里的 DELETE。
     * 取代原来的全删全建，避免 biz_root 唯一键冲突。
     */
    private void upsertCargoOrders(ContainerOrderDO containerOrder, List<CargoOrderSaveReqVO> incoming) {
        // 当前 DB 里的货物订单
        List<CargoOrderDO> existing = cargoOrderMapper.selectList(new LambdaQueryWrapper<CargoOrderDO>()
            .eq(CargoOrderDO::getContainerOrderId, containerOrder.getId()));
        Map<Long, CargoOrderDO> existingById = existing.stream()
            .collect(Collectors.toMap(CargoOrderDO::getId, c -> c));

        Set<Long> incomingIds = Optional.ofNullable(incoming).orElseGet(List::of).stream()
            .map(CargoOrderSaveReqVO::getId).filter(Objects::nonNull).collect(Collectors.toSet());

        // 1. 删除不再存在的货物订单（逻辑删）
        List<Long> toDelete = existing.stream()
            .map(CargoOrderDO::getId)
            .filter(id -> !incomingIds.contains(id))
            .toList();
        if (CollUtil.isNotEmpty(toDelete)) {
            shipmentMapper.delete(new LambdaQueryWrapper<CargoOrderShipmentDO>()
                .in(CargoOrderShipmentDO::getCargoOrderId, toDelete));
            List<Long> bizRootIds = existing.stream()
                .filter(c -> toDelete.contains(c.getId()) && c.getBizRootId() != null)
                .map(CargoOrderDO::getBizRootId).toList();
            if (CollUtil.isNotEmpty(bizRootIds)) bizRootMapper.deleteByIds(bizRootIds);
            relationMapper.delete(new LambdaQueryWrapper<ContainerCargoOrderRelDO>()
                .in(ContainerCargoOrderRelDO::getCargoOrderId, toDelete));
            cargoOrderMapper.deleteByIds(toDelete);
        }

        if (CollUtil.isEmpty(incoming)) return;

        for (CargoOrderSaveReqVO item : incoming) {
            if (isEmptyCargoOrder(item)) continue;
            List<CargoOrderShipmentSaveReqVO> validShipments = Optional.ofNullable(item.getShipments())
                .orElseGet(ArrayList::new)
                .stream().filter(s -> StrUtil.isNotBlank(s.getShipmentNo())).toList();
            if (CollUtil.isEmpty(validShipments)) continue;

            if (item.getId() != null && existingById.containsKey(item.getId())) {
                // 2. UPDATE 已有货物订单
                CargoOrderDO patch = BeanUtils.toBean(item, CargoOrderDO.class);
                patch.setCargoOrderNo(null);           // 不允许改编号
                patch.setBizRootId(null);              // 不动 BizRootDO
                patch.setContainerOrderId(null);
                patch.setFulfillmentStatus(null);      // 不覆盖履约状态
                patch.setBillingStatus(null);
                patch.setPreOutboundStatus(null);
                patch.setContainerNo(containerOrder.getContainerNo());
                summarizeCargoOrder(patch, validShipments);
                cargoOrderMapper.updateById(patch);
                // 货件：upsert（有 id 则 UPDATE，无则 INSERT，消失的 DELETE）
                upsertShipments(item.getId(), validShipments);
            } else {
                // 3. INSERT 新货物订单
                Long bizRootId = IdUtil.getSnowflakeNextId();
                CargoOrderDO add = BeanUtils.toBean(item, CargoOrderDO.class);
                add.setId(null);
                add.setBizRootId(bizRootId);
                add.setCompanyId(containerOrder.getCompanyId());
                add.setInboundWarehouseId(containerOrder.getWarehouseId());
                add.setContainerOrderId(containerOrder.getId());
                add.setContainerNo(containerOrder.getContainerNo());
                add.setCargoOrderNo(StrUtil.blankToDefault(item.getCargoOrderNo(), generateNo("CGO")));
                add.setCustomerId(Optional.ofNullable(item.getCustomerId()).orElse(containerOrder.getCustomerId()));
                add.setCustomerName(StrUtil.blankToDefault(item.getCustomerName(), containerOrder.getCustomerName()));
                add.setChannelId(Optional.ofNullable(item.getChannelId()).orElse(containerOrder.getChannelId()));
                add.setBusinessTypeId(Optional.ofNullable(item.getBusinessTypeId()).orElse(containerOrder.getBusinessTypeId()));
                add.setCustomerServiceId(Optional.ofNullable(item.getCustomerServiceId()).orElse(containerOrder.getCustomerServiceId()));
                add.setCustomerServiceName(StrUtil.blankToDefault(item.getCustomerServiceName(), containerOrder.getCustomerServiceName()));
                add.setForecastQtyUnit(StrUtil.blankToDefault(item.getForecastQtyUnit(), "BY_CARTON"));
                add.setFulfillmentStatus("PENDING_ACCEPT");
                add.setBillingStatus("UNBILLED");
                add.setPreOutboundStatus("none");
                summarizeCargoOrder(add, validShipments);
                cargoOrderMapper.insert(add);
                saveBizRoot(add);
                saveRelation(containerOrder, add);
                saveShipments(add, validShipments);
            }
        }
    }

    private void saveCargoOrders(ContainerOrderDO containerOrder, List<CargoOrderSaveReqVO> cargoOrders) {
        if (CollUtil.isEmpty(cargoOrders)) {
            return;
        }
        for (CargoOrderSaveReqVO item : cargoOrders) {
            if (isEmptyCargoOrder(item)) {
                continue;
            }
            List<CargoOrderShipmentSaveReqVO> validShipments = Optional.ofNullable(item.getShipments()).orElseGet(ArrayList::new)
                .stream().filter(shipment -> StrUtil.isNotBlank(shipment.getShipmentNo())).toList();
            if (CollUtil.isEmpty(validShipments)) {
                continue;
            }
            Long bizRootId = IdUtil.getSnowflakeNextId();
            CargoOrderDO cargoOrder = BeanUtils.toBean(item, CargoOrderDO.class);
            cargoOrder.setId(null);
            cargoOrder.setBizRootId(bizRootId);
            cargoOrder.setCompanyId(containerOrder.getCompanyId());
            cargoOrder.setInboundWarehouseId(containerOrder.getWarehouseId());
            cargoOrder.setContainerOrderId(containerOrder.getId());
            cargoOrder.setContainerNo(containerOrder.getContainerNo());
            cargoOrder.setCargoOrderNo(StrUtil.blankToDefault(item.getCargoOrderNo(), generateNo("CGO")));
            cargoOrder.setCustomerId(Optional.ofNullable(item.getCustomerId()).orElse(containerOrder.getCustomerId()));
            cargoOrder.setCustomerName(StrUtil.blankToDefault(item.getCustomerName(), containerOrder.getCustomerName()));
            cargoOrder.setChannelId(Optional.ofNullable(item.getChannelId()).orElse(containerOrder.getChannelId()));
            cargoOrder.setBusinessTypeId(Optional.ofNullable(item.getBusinessTypeId()).orElse(containerOrder.getBusinessTypeId()));
            cargoOrder.setCustomerServiceId(Optional.ofNullable(item.getCustomerServiceId()).orElse(containerOrder.getCustomerServiceId()));
            cargoOrder.setCustomerServiceName(StrUtil.blankToDefault(item.getCustomerServiceName(), containerOrder.getCustomerServiceName()));
            cargoOrder.setForecastQtyUnit(StrUtil.blankToDefault(item.getForecastQtyUnit(), "BY_CARTON"));
            cargoOrder.setFulfillmentStatus("PENDING_ACCEPT");
            cargoOrder.setBillingStatus("UNBILLED");
            cargoOrder.setPreOutboundStatus("none");
            summarizeCargoOrder(cargoOrder, validShipments);
            cargoOrderMapper.insert(cargoOrder);
            saveBizRoot(cargoOrder);
            saveRelation(containerOrder, cargoOrder);
            saveShipments(cargoOrder, validShipments);
        }
        recalcSummary(containerOrder.getId());
    }

    private void saveBizRoot(CargoOrderDO cargoOrder) {
        BizRootDO bizRoot = new BizRootDO();
        bizRoot.setId(cargoOrder.getBizRootId());
        bizRoot.setCompanyId(cargoOrder.getCompanyId());
        bizRoot.setWarehouseId(cargoOrder.getInboundWarehouseId());
        bizRoot.setRootNo(cargoOrder.getCargoOrderNo());
        bizRoot.setRootType("CARGO_ORDER");
        bizRoot.setSourceModule("OMS");
        bizRoot.setSourceOrderId(cargoOrder.getId());
        bizRoot.setSourceOrderNo(cargoOrder.getCargoOrderNo());
        bizRoot.setCustomerId(cargoOrder.getCustomerId());
        bizRoot.setCustomerName(cargoOrder.getCustomerName());
        bizRoot.setChannelId(cargoOrder.getChannelId());
        bizRoot.setBusinessTypeId(cargoOrder.getBusinessTypeId());
        bizRoot.setCurrentModule("OMS");
        bizRoot.setCurrentNode("PENDING_ACCEPT");
        bizRoot.setCurrentNodeName("待受理");
        bizRoot.setCurrentNodeTime(new Date());
        bizRoot.setRootStatus("RUNNING");
        bizRoot.setExceptionFlag(0);
        bizRoot.setExceptionCount(0);
        bizRoot.setStartTime(new Date());
        bizRoot.setRemark("由海柜订单新增货物订单时创建");
        bizRootMapper.insert(bizRoot);
    }

    /** 海柜关联的货物订单：直接字段 + 关系表并集 */
    private List<Long> listCargoOrderIdsByContainer(Long containerOrderId) {
        if (containerOrderId == null) {
            return List.of();
        }
        LinkedHashSet<Long> ids = new LinkedHashSet<>();
        cargoOrderMapper.selectList(new LambdaQueryWrapper<CargoOrderDO>()
                .eq(CargoOrderDO::getContainerOrderId, containerOrderId)
                .select(CargoOrderDO::getId))
            .forEach(item -> ids.add(item.getId()));
        relationMapper.selectList(new LambdaQueryWrapper<ContainerCargoOrderRelDO>()
                .eq(ContainerCargoOrderRelDO::getContainerOrderId, containerOrderId)
                .select(ContainerCargoOrderRelDO::getCargoOrderId))
            .forEach(rel -> ids.add(rel.getCargoOrderId()));
        return new ArrayList<>(ids);
    }

    private void saveRelation(ContainerOrderDO containerOrder, CargoOrderDO cargoOrder) {
        ContainerCargoOrderRelDO rel = new ContainerCargoOrderRelDO();
        rel.setContainerOrderId(containerOrder.getId());
        rel.setContainerOrderNo(containerOrder.getContainerOrderNo());
        rel.setContainerNo(containerOrder.getContainerNo());
        rel.setCargoOrderId(cargoOrder.getId());
        rel.setCargoOrderNo(cargoOrder.getCargoOrderNo());
        rel.setRelationType(REL_MANUAL_CREATE);
        rel.setRelationStatus(REL_ACTIVE);
        relationMapper.insert(rel);
    }

    private void upsertShipments(Long cargoOrderId, List<CargoOrderShipmentSaveReqVO> incoming) {
        List<CargoOrderShipmentDO> existing = shipmentMapper.selectList(
            new LambdaQueryWrapper<CargoOrderShipmentDO>()
                .eq(CargoOrderShipmentDO::getCargoOrderId, cargoOrderId));
        Set<Long> existingIds = existing.stream().map(CargoOrderShipmentDO::getId).collect(Collectors.toSet());
        Set<Long> incomingIds = incoming.stream().map(CargoOrderShipmentSaveReqVO::getId)
            .filter(Objects::nonNull).collect(Collectors.toSet());

        // DELETE 消失的货件
        List<Long> toDelete = existingIds.stream().filter(id -> !incomingIds.contains(id)).toList();
        if (CollUtil.isNotEmpty(toDelete)) shipmentMapper.deleteByIds(toDelete);

        for (CargoOrderShipmentSaveReqVO item : incoming) {
            CargoOrderShipmentDO s = BeanUtils.toBean(item, CargoOrderShipmentDO.class);
            if (item.getId() != null && existingIds.contains(item.getId())) {
                // UPDATE 已有货件
                shipmentMapper.updateById(s);
            } else {
                // INSERT 新货件
                s.setId(null);
                s.setCargoOrderId(cargoOrderId);
                shipmentMapper.insert(s);
            }
        }
    }

    private void saveShipments(CargoOrderDO cargoOrder, List<CargoOrderShipmentSaveReqVO> shipments) {
        if (CollUtil.isEmpty(shipments)) {
            return;
        }
        for (CargoOrderShipmentSaveReqVO item : shipments) {
            CargoOrderShipmentDO shipment = BeanUtils.toBean(item, CargoOrderShipmentDO.class);
            shipment.setId(null);
            shipment.setCargoOrderId(cargoOrder.getId());
            shipment.setBizRootId(cargoOrder.getBizRootId());
            shipmentMapper.insert(shipment);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean addCargoOrders(Long containerOrderId, List<CargoOrderSaveReqVO> cargoOrders) {
        ContainerOrderDO containerOrder = baseMapper.selectById(containerOrderId);
        if (containerOrder == null) {
            throw exception(OMS_BIZ_ERROR, "海柜订单不存在");
        }
        if (CollUtil.isEmpty(cargoOrders)) {
            throw exception(OMS_BIZ_ERROR, "货物订单不能为空");
        }
        ContainerOrderSaveReqVO validateBo = new ContainerOrderSaveReqVO();
        validateBo.setCargoOrders(cargoOrders);
        validateCargoOrders(validateBo, false);
        saveCargoOrders(containerOrder, cargoOrders);
        return true;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public String importCargoOrders(Long containerOrderId, List<ContainerCargoOrderImportExcelVO> rows) {
        ContainerOrderDO containerOrder = baseMapper.selectById(containerOrderId);
        if (containerOrder == null) {
            throw exception(OMS_BIZ_ERROR, "海柜订单不存在");
        }
        List<CargoOrderSaveReqVO> cargoOrders = buildCargoOrdersFromImportRows(rows, containerOrder);
        ContainerOrderSaveReqVO validateBo = new ContainerOrderSaveReqVO();
        validateBo.setCargoOrders(cargoOrders);
        validateCargoOrders(validateBo, false);
        saveCargoOrders(containerOrder, cargoOrders);
        return "成功导入 " + cargoOrders.size() + " 条货物订单";
    }

    @Override
    public List<CargoOrderSaveReqVO> parseImportCargoOrders(List<ContainerCargoOrderImportExcelVO> rows) {
        return buildCargoOrdersFromImportRows(rows, null);
    }

    private List<CargoOrderSaveReqVO> buildCargoOrdersFromImportRows(List<ContainerCargoOrderImportExcelVO> rows, ContainerOrderDO containerOrder) {
        if (CollUtil.isEmpty(rows)) {
            throw exception(OMS_BIZ_ERROR, "导入数据为空");
        }
        Map<String, List<ContainerCargoOrderImportExcelVO>> grouped = rows.stream()
            .filter(row -> StrUtil.isNotBlank(row.getShipmentNo()))
            .collect(Collectors.groupingBy(row -> {
                if (StrUtil.isNotBlank(row.getGroupNo())) {
                    return row.getGroupNo().trim();
                }
                if (StrUtil.isNotBlank(row.getExternalOrderNo())) {
                    return row.getExternalOrderNo().trim();
                }
                return "ROW_" + row.getShipmentNo().trim();
            }));
        if (grouped.isEmpty()) {
            throw exception(OMS_BIZ_ERROR, "导入数据中没有有效货件编码");
        }
        List<CargoOrderSaveReqVO> cargoOrders = grouped.values().stream()
            .map(group -> convertImportGroup(containerOrder, group))
            .toList();
        ContainerOrderSaveReqVO validateBo = new ContainerOrderSaveReqVO();
        validateBo.setCargoOrders(cargoOrders);
        validateCargoOrders(validateBo, false);
        return cargoOrders;
    }

    private CargoOrderSaveReqVO convertImportGroup(ContainerOrderDO containerOrder, List<ContainerCargoOrderImportExcelVO> group) {
        ContainerCargoOrderImportExcelVO head = group.get(0);
        CargoOrderSaveReqVO bo = new CargoOrderSaveReqVO();
        bo.setOrderSource("IMPORT");
        bo.setExternalOrderNo(head.getExternalOrderNo());
        if (containerOrder != null) {
            bo.setCustomerId(Optional.ofNullable(head.getCustomerId()).orElse(containerOrder.getCustomerId()));
            bo.setCustomerName(StrUtil.blankToDefault(head.getCustomerName(), containerOrder.getCustomerName()));
            bo.setBusinessTypeId(Optional.ofNullable(head.getBusinessTypeId()).orElse(containerOrder.getBusinessTypeId()));
            bo.setChannelId(Optional.ofNullable(head.getChannelId()).orElse(containerOrder.getChannelId()));
            bo.setCustomerServiceId(Optional.ofNullable(containerOrder.getCustomerServiceId()).orElse(containerOrder.getOwnerUserId()));
            bo.setCustomerServiceName(StrUtil.blankToDefault(containerOrder.getCustomerServiceName(), containerOrder.getOwnerUserName()));
            bo.setInboundWarehouseId(containerOrder.getWarehouseId());
            bo.setInboundWarehouseName(containerOrder.getInboundWarehouseName());
        } else {
            bo.setCustomerId(head.getCustomerId());
            bo.setCustomerName(head.getCustomerName());
            bo.setBusinessTypeId(head.getBusinessTypeId());
            bo.setChannelId(head.getChannelId());
        }
        bo.setPlatformId(head.getPlatformId());
        bo.setAddressType(StrUtil.blankToDefault(head.getAddressType(), "PLATFORM_WH"));
        bo.setPlatformWarehouseCode(head.getPlatformWarehouseCode());
        bo.setConsigneeName(head.getConsigneeName());
        bo.setAddressLine1(head.getAddressLine1());
        bo.setAddressLine2(head.getAddressLine2());
        bo.setCity(head.getCity());
        bo.setState(head.getState());
        bo.setZipCode(head.getZipCode());
        bo.setCountry(head.getCountry());
        bo.setContactName(head.getContactName());
        bo.setContactPhone(head.getContactPhone());
        bo.setContactEmail(head.getContactEmail());
        bo.setForecastQtyUnit(StrUtil.blankToDefault(head.getForecastQtyUnit(), "BY_CARTON").toUpperCase());
        bo.setTransferFlag(parseTransferFlag(head.getTransferFlagText()) ? 1 : 0);
        bo.setTransferWarehouseCode(head.getTransferWarehouseCode());
        bo.setCustomerRemark(head.getCustomerRemark());
        bo.setInternalRemark(head.getInternalRemark());
        bo.setShipments(group.stream().map(this::convertImportShipment).toList());
        summarizeCargoOrderSaveReqVO(bo);
        return bo;
    }

    private void summarizeCargoOrderSaveReqVO(CargoOrderSaveReqVO bo) {
        List<CargoOrderShipmentSaveReqVO> shipments = Optional.ofNullable(bo.getShipments()).orElseGet(List::of);
        if (CollUtil.isEmpty(shipments)) {
            return;
        }
        String qtyUnit = StrUtil.blankToDefault(bo.getForecastQtyUnit(), "BY_CARTON");
        bo.setForecastQtyUnit(qtyUnit);
        if ("BY_PALLET".equalsIgnoreCase(qtyUnit)) {
            bo.setDeclaredPalletQty(sum(shipments.stream().map(CargoOrderShipmentSaveReqVO::getPalletQty).toList()));
            bo.setDeclaredCartonQty(null);
        } else {
            bo.setDeclaredCartonQty(sum(shipments.stream().map(CargoOrderShipmentSaveReqVO::getCartonQty).toList()));
            bo.setDeclaredPalletQty(null);
        }
        bo.setDeclaredWeight(sum(shipments.stream().map(CargoOrderShipmentSaveReqVO::getWeight).toList()));
        bo.setDeclaredCbm(sum(shipments.stream().map(CargoOrderShipmentSaveReqVO::getCbm).toList()));
    }

    private CargoOrderShipmentSaveReqVO convertImportShipment(ContainerCargoOrderImportExcelVO row) {
        CargoOrderShipmentSaveReqVO shipment = new CargoOrderShipmentSaveReqVO();
        shipment.setShipmentNo(StrUtil.trim(row.getShipmentNo()));
        shipment.setPoNo(row.getPoNo());
        shipment.setShippingMark(row.getShippingMark());
        shipment.setCartonQty(row.getCartonQty());
        shipment.setPalletQty(row.getPalletQty());
        shipment.setWeight(row.getWeight());
        shipment.setCbm(row.getCbm());
        if (StrUtil.isNotBlank(row.getDwTimeText())) {
            shipment.setDwTime(DateUtil.parse(row.getDwTimeText()));
        }
        return shipment;
    }

    private boolean parseTransferFlag(String text) {
        if (StrUtil.isBlank(text)) {
            return false;
        }
        String val = text.trim();
        return "1".equals(val) || "是".equals(val) || "Y".equalsIgnoreCase(val) || "YES".equalsIgnoreCase(val)
            || "true".equalsIgnoreCase(val);
    }

    private void summarizeCargoOrder(CargoOrderDO cargoOrder, List<CargoOrderShipmentSaveReqVO> shipments) {
        if (CollUtil.isEmpty(shipments)) {
            return;
        }
        String qtyUnit = StrUtil.blankToDefault(cargoOrder.getForecastQtyUnit(), "BY_CARTON");
        cargoOrder.setForecastQtyUnit(qtyUnit);
        if ("BY_PALLET".equalsIgnoreCase(qtyUnit)) {
            cargoOrder.setDeclaredPalletQty(sum(shipments.stream().map(CargoOrderShipmentSaveReqVO::getPalletQty).toList()));
            cargoOrder.setDeclaredCartonQty(null);
        } else {
            cargoOrder.setDeclaredCartonQty(sum(shipments.stream().map(CargoOrderShipmentSaveReqVO::getCartonQty).toList()));
            cargoOrder.setDeclaredPalletQty(null);
        }
        cargoOrder.setDeclaredWeight(sum(shipments.stream().map(CargoOrderShipmentSaveReqVO::getWeight).toList()));
        cargoOrder.setDeclaredCbm(sum(shipments.stream().map(CargoOrderShipmentSaveReqVO::getCbm).toList()));
        cargoOrder.setEarliestDwTime(shipments.stream().map(CargoOrderShipmentSaveReqVO::getDwTime).filter(Objects::nonNull).min(Date::compareTo).orElse(null));
        cargoOrder.setShipmentCodes(joinDistinct(shipments.stream().map(CargoOrderShipmentSaveReqVO::getShipmentNo).toList()));
        cargoOrder.setPoNos(joinDistinct(shipments.stream().map(CargoOrderShipmentSaveReqVO::getPoNo).filter(StrUtil::isNotBlank).toList()));
        cargoOrder.setMarks(joinDistinct(shipments.stream().map(CargoOrderShipmentSaveReqVO::getShippingMark).filter(StrUtil::isNotBlank).toList()));
    }

    private String joinDistinct(List<String> values) {
        if (CollUtil.isEmpty(values)) {
            return null;
        }
        return values.stream().filter(StrUtil::isNotBlank).distinct().collect(Collectors.joining(","));
    }

    private void initSummary(ContainerOrderDO order) {
        order.setPrePlanTruckQty(BigDecimal.ZERO);
        order.setPrePlanPalletQty(BigDecimal.ZERO);
        order.setPrePlanCbm(BigDecimal.ZERO);
        order.setTotalCartonQty(BigDecimal.ZERO);
        order.setTotalPalletQty(BigDecimal.ZERO);
        order.setTotalWeight(BigDecimal.ZERO);
        order.setTotalCbm(BigDecimal.ZERO);
        order.setContainerExceptionFlag(0);
        order.setContainerExceptionCount(0);
        order.setDownstreamExceptionFlag(0);
        order.setDownstreamExceptionCount(0);
        order.setHoldFlag(Optional.ofNullable(order.getHoldFlag()).orElse(0));
        order.setExamFlag(Optional.ofNullable(order.getExamFlag()).orElse(0));
        order.setTerminalReleaseStatus(StrUtil.blankToDefault(order.getTerminalReleaseStatus(), "UNKNOWN"));
        order.setAttachmentCount(0);
        order.setDoAttachmentCount(0);
    }

    private void recalcSummary(Long containerOrderId) {
        List<CargoOrderDO> cargoOrders = cargoOrderMapper.selectList(new LambdaQueryWrapper<CargoOrderDO>()
            .eq(CargoOrderDO::getContainerOrderId, containerOrderId));
        ContainerOrderDO update = new ContainerOrderDO();
        update.setId(containerOrderId);
        containerPrePlanSummaryService.refreshByContainerOrderId(containerOrderId);
        update.setTotalCartonQty(sum(cargoOrders.stream().map(CargoOrderDO::getDeclaredCartonQty).toList()));
        update.setTotalPalletQty(sum(cargoOrders.stream().map(CargoOrderDO::getDeclaredPalletQty).toList()));
        update.setTotalWeight(sum(cargoOrders.stream().map(CargoOrderDO::getDeclaredWeight).toList()));
        update.setTotalCbm(sum(cargoOrders.stream().map(CargoOrderDO::getDeclaredCbm).toList()));
        baseMapper.updateById(update);
    }

    private void recalcContainerAttachmentSummary(Long containerOrderId) {
        List<BizAttachmentDO> attachments = attachmentMapper.selectList(new LambdaQueryWrapper<BizAttachmentDO>()
            .eq(BizAttachmentDO::getTargetType, "CONTAINER_ORDER")
            .eq(BizAttachmentDO::getTargetId, containerOrderId));
        ContainerOrderDO update = new ContainerOrderDO();
        update.setId(containerOrderId);
        update.setAttachmentCount(attachments.size());
        update.setDoAttachmentCount((int) attachments.stream().filter(item -> "DO".equals(item.getAttachmentType())).count());
        update.setLatestAttachmentTime(attachments.stream()
            .map(BizAttachmentDO::getUploadTime)
            .filter(Objects::nonNull)
            .max(Date::compareTo)
            .orElse(null));
        update.setLatestDoUploadTime(attachments.stream()
            .filter(item -> "DO".equals(item.getAttachmentType()))
            .map(BizAttachmentDO::getUploadTime)
            .filter(Objects::nonNull)
            .max(Date::compareTo)
            .orElse(null));
        baseMapper.updateById(update);
    }

    private void deleteChildren(Long containerOrderId) {
        List<CargoOrderDO> cargoOrders = cargoOrderMapper.selectList(new LambdaQueryWrapper<CargoOrderDO>()
            .eq(CargoOrderDO::getContainerOrderId, containerOrderId));
        if (CollUtil.isNotEmpty(cargoOrders)) {
            shipmentMapper.delete(new LambdaQueryWrapper<CargoOrderShipmentDO>()
                .in(CargoOrderShipmentDO::getCargoOrderId, cargoOrders.stream().map(CargoOrderDO::getId).toList()));
            List<Long> bizRootIds = cargoOrders.stream().map(CargoOrderDO::getBizRootId).filter(Objects::nonNull).toList();
            if (CollUtil.isNotEmpty(bizRootIds)) {
                bizRootMapper.deleteByIds(bizRootIds);
            }
            cargoOrderMapper.deleteByIds(cargoOrders.stream().map(CargoOrderDO::getId).toList());
        }
        relationMapper.delete(new LambdaQueryWrapper<ContainerCargoOrderRelDO>()
            .eq(ContainerCargoOrderRelDO::getContainerOrderId, containerOrderId));
    }

    private void fillNames(List<ContainerOrderRespVO> list) {
        if (CollUtil.isEmpty(list)) {
            return;
        }
        Set<Long> companyIds = list.stream().map(ContainerOrderRespVO::getCompanyId).filter(Objects::nonNull).collect(Collectors.toSet());
        Set<Long> warehouseIds = list.stream().map(ContainerOrderRespVO::getWarehouseId).filter(Objects::nonNull).collect(Collectors.toSet());
        Set<Long> channelIds = list.stream().map(ContainerOrderRespVO::getChannelId).filter(Objects::nonNull).collect(Collectors.toSet());
        Set<Long> businessTypeIds = list.stream().map(ContainerOrderRespVO::getBusinessTypeId).filter(Objects::nonNull).collect(Collectors.toSet());
        Map<Long, String> companyMap = buildNameMap(
            CollUtil.isEmpty(companyIds) ? List.of() : companyMapper.selectListByIds(companyIds),
            CompanyDO::getId, CompanyDO::getCompanyName);
        Map<Long, String> warehouseMap = buildNameMap(
            CollUtil.isEmpty(warehouseIds) ? List.of() : warehouseMapper.selectListByIds(warehouseIds),
            WarehouseDO::getId, WarehouseDO::getWarehouseName);
        Map<Long, String> channelMap = buildNameMap(
            CollUtil.isEmpty(channelIds) ? List.of()
                : channelMapper.selectList(new LambdaQueryWrapperX<ChannelDO>().in(ChannelDO::getId, channelIds)),
            ChannelDO::getId, ChannelDO::getChannelName);
        Map<Long, String> businessTypeMap = buildNameMap(
            CollUtil.isEmpty(businessTypeIds) ? List.of()
                : businessTypeMapper.selectList(new LambdaQueryWrapperX<BusinessTypeDO>().in(BusinessTypeDO::getId, businessTypeIds)),
            BusinessTypeDO::getId, BusinessTypeDO::getBusinessTypeName);
        list.forEach(item -> {
            item.setCompanyName(getName(companyMap, item.getCompanyId()));
            item.setWarehouseName(getName(warehouseMap, item.getWarehouseId()));
            item.setChannelName(getName(channelMap, item.getChannelId()));
            item.setBusinessTypeName(getName(businessTypeMap, item.getBusinessTypeId()));
            if (StrUtil.isBlank(item.getInboundWarehouseName())) {
                item.setInboundWarehouseName(item.getWarehouseName());
            }
        });
    }

    private String getName(Map<Long, String> nameMap, Long id) {
        return id == null ? null : nameMap.get(id);
    }

    private <T> Map<Long, String> buildNameMap(List<T> records, Function<T, Long> idGetter, Function<T, String> nameGetter) {
        if (CollUtil.isEmpty(records)) {
            return Map.of();
        }
        return records.stream()
            .filter(Objects::nonNull)
            .filter(record -> idGetter.apply(record) != null)
            .collect(Collectors.toMap(idGetter, record -> StrUtil.nullToEmpty(nameGetter.apply(record)), (left, right) -> left));
    }

    private void saveTrace(ContainerOrderDO order, String from, String to, String action, String remark) {
        ContainerOrderTraceDO trace = new ContainerOrderTraceDO();
        trace.setContainerOrderId(order.getId());
        trace.setContainerOrderNo(order.getContainerOrderNo());
        trace.setContainerNo(order.getContainerNo());
        trace.setStatusFrom(from);
        trace.setStatusTo(to);
        trace.setAction(action);
        trace.setActionDesc(remark);
        trace.setOperatorId(SecurityFrameworkUtils.getLoginUserId());
        trace.setOperatorName(SecurityFrameworkUtils.getLoginUserNickname());
        trace.setRemark(remark);
        traceMapper.insert(trace);
    }

    private boolean isEmptyCargoOrder(CargoOrderSaveReqVO item) {
        return StrUtil.isBlank(item.getCargoOrderNo())
            && item.getCustomerId() == null
            && StrUtil.isBlank(item.getCustomerName())
            && CollUtil.isEmpty(item.getShipments());
    }

    private String generateNo(String prefix) {
        String snowflake = IdUtil.getSnowflakeNextIdStr();
        return prefix + DateUtil.format(new Date(), "yyyyMMdd") + snowflake.substring(Math.max(0, snowflake.length() - 6));
    }

    private String joinDistinct(List<CargoOrderShipmentSaveReqVO> shipments, Function<CargoOrderShipmentSaveReqVO, String> mapper) {
        return shipments.stream().map(mapper).filter(StrUtil::isNotBlank).distinct().collect(Collectors.joining(", "));
    }

    private BigDecimal sum(List<BigDecimal> values) {
        return values.stream().filter(Objects::nonNull).reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    // ─── 字段驱动状态自动推进 ──────────────────────────────────────────────────

    private void applyFieldDrivenStatusAdvance(ContainerOrderDO before, ContainerOrderDO after) {
        String current = after.getContainerStatus();
        if (current == null || "CANCELLED".equals(current) || "COMPLETED".equals(current)) return;

        String target = resolveTargetStatusFromFields(before, after);
        if (target == null) return;

        int currentRank = STATUS_RANK.getOrDefault(current, -1);
        int targetRank  = STATUS_RANK.getOrDefault(target, -1);
        if (targetRank <= currentRank) return;  // 只向前，不回退

        ContainerOrderStatusReqVO statusBo = new ContainerOrderStatusReqVO();
        statusBo.setTargetStatus(target);
        statusBo.setRemark("字段更新自动推进");
        if ("ARRIVED_WAREHOUSE".equals(target)) {
            statusBo.setActualArrivalTime(after.getActualArrivalTime());
        }
        updateStatus(after.getId(), statusBo);
    }

    /** 根据新填写的时间字段决定目标状态（按优先级从高到低） */
    private String resolveTargetStatusFromFields(ContainerOrderDO before, ContainerOrderDO after) {
        if (isNewlySet(before.getEmptyReturnTime(),       after.getEmptyReturnTime()))       return "EMPTY_RETURNED";
        if (isNewlySet(before.getActualArrivalTime(),     after.getActualArrivalTime()))     return "ARRIVED_WAREHOUSE";
        if (isNewlySet(before.getActualPickupTime(),      after.getActualPickupTime()))      return "PICKED_UP";
        if (isNewlySet(before.getAvailableTime(),         after.getAvailableTime())) {
            return after.getPickupAppointmentTime() != null ? "PICKUP_APPOINTED" : "AVAILABLE_FOR_PICKUP";
        }
        if (isNewlySet(before.getPickupAppointmentTime(), after.getPickupAppointmentTime())
                && after.getAvailableTime() != null) {
            return "PICKUP_APPOINTED";
        }
        if (isNewlySet(before.getAta(), after.getAta())) return "ARRIVED_PORT";
        return null;
    }

    private boolean isNewlySet(Date before, Date after) {
        return before == null && after != null;
    }
}
