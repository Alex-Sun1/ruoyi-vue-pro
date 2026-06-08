package cn.iocoder.yudao.module.oms.service.inboundplan;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.oms.enums.ErrorCodeConstants.*;

import cn.hutool.core.util.IdUtil;
import cn.hutool.core.collection.CollUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder.CargoOrderShipmentDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.inboundplan.InboundPlanDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.inboundplan.InboundPlanChangeLogDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.inboundplan.InboundPlanItemDO;
import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanApplyRuleReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanSaveReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanItemUpdateReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanPageReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanSaveGroupReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanGroupRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanItemPreviewRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanItemRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanRespVO;
import cn.iocoder.yudao.module.oms.dal.dataobject.containerorder.ContainerOrderDO;
import cn.iocoder.yudao.module.base.dal.dataobject.channel.ChannelDO;
import cn.iocoder.yudao.module.base.dal.mysql.channel.ChannelMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.cargoorder.CargoOrderShipmentMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.containerorder.ContainerOrderMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.inboundplan.InboundPlanChangeLogMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.inboundplan.InboundPlanItemMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.inboundplan.InboundPlanMapper;
import cn.iocoder.yudao.module.oms.service.inboundplan.InboundPlanService;
import cn.iocoder.yudao.module.oms.support.grouping.GroupingRuleEngine;
import cn.iocoder.yudao.module.org.framework.datapermission.annotation.OrgDataScope;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 入库计划 ServiceImpl
 */
@Slf4j
@Service
public class InboundPlanServiceImpl implements InboundPlanService {

    @Resource
    private InboundPlanMapper baseMapper;
    @Resource
    private InboundPlanItemMapper itemMapper;
    @Resource
    private InboundPlanChangeLogMapper changeLogMapper;
    @Resource
    private CargoOrderShipmentMapper shipmentMapper;
    @Resource
    private ContainerOrderMapper containerOrderMapper;
    @Resource
    private ChannelMapper channelMapper;
    @Resource
    private GroupingRuleEngine groupingRuleEngine;

    @Override
    @OrgDataScope(tableClass = InboundPlanDO.class, warehouseColumn = "warehouse_id")
    public PageResult<InboundPlanRespVO> queryPageList(InboundPlanPageReqVO bo, PageParam pageQuery) {
        Page<InboundPlanRespVO> result = baseMapper.selectPageList(new Page<>(pageQuery.getPageNo(), pageQuery.getPageSize()), bo);
        return new PageResult<>(result.getRecords(), result.getTotal());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public InboundPlanRespVO getOrCreate(Long containerOrderId, Long warehouseId) {
        // 查是否已有未取消的计划
        InboundPlanDO existing = baseMapper.selectOne(
            new LambdaQueryWrapper<InboundPlanDO>()
                .eq(InboundPlanDO::getContainerOrderId, containerOrderId)
                .ne(InboundPlanDO::getStatus, "cancelled")
                .eq(InboundPlanDO::getDeleted, 0)
                .last("LIMIT 1")
        );
        if (existing != null) {
            syncMissingShipments(existing);
            ensurePlanHasItems(existing);
            return queryDetail(existing.getId());
        }

        // 创建新计划
        ContainerOrderDO containerOrder = containerOrderMapper.selectById(containerOrderId);
        InboundPlanDO plan = new InboundPlanDO();
        plan.setContainerOrderId(containerOrderId);
        plan.setContainerOrderNo(containerOrder != null ? containerOrder.getContainerOrderNo() : null);
        plan.setWarehouseId(warehouseId);
        plan.setPlanNo(generatePlanNo());
        plan.setStatus("draft");
        baseMapper.insert(plan);

        // 加载该海柜下所有货件，创建明细行
        loadShipmentsIntoPlan(plan);

        return queryDetail(plan.getId());
    }

    @Override
    public InboundPlanRespVO queryDetail(Long planId) {
        InboundPlanDO plan = baseMapper.selectById(planId);
        if (plan == null) throw exception(OMS_BIZ_ERROR, "入库计划不存在");

        InboundPlanRespVO vo = BeanUtils.toBean(plan, InboundPlanRespVO.class);
        fillContainerOrderHeader(vo, plan.getContainerOrderId());

        // 查分组汇总
        List<InboundPlanGroupRespVO> groups = itemMapper.selectGroupSummaryByPlanId(planId);

        // 查所有明细
        List<InboundPlanItemRespVO> allItems = itemMapper.selectItemsByPlanId(planId);
        Map<String, List<InboundPlanItemRespVO>> itemMap = allItems.stream()
            .collect(Collectors.groupingBy(
                item -> item.getGroupCode() != null ? item.getGroupCode() : "__UNGROUPED__"
            ));

        // 计算预计打板数并挂载明细
        // selectGroupSummaryByPlanId 的 GROUP BY group_code 已将 NULL 汇总为一行，无需再单独处理未分组
        groups.forEach(group -> {
            String key = group.getGroupCode() != null ? group.getGroupCode() : "__UNGROUPED__";
            group.setItems(itemMap.getOrDefault(key, Collections.emptyList()));
            group.setExpectedPalletQty(
                groupingRuleEngine.calcExpectedPalletQty(group.getGroupCode(), group.getTotalCbm())
            );
        });

        vo.setGroups(groups);
        return vo;
    }

    // ====================== 预览（不写库）======================

    @Override
    public List<InboundPlanItemPreviewRespVO> previewAutoGroup(Long planId) {
        InboundPlanDO plan = checkPlanEditable(planId);
        List<InboundPlanItemRespVO> items = itemMapper.selectItemsByPlanId(planId);
        return items.stream().map(item -> {
            String proposed = groupingRuleEngine.computeGroupCode(
                plan.getWarehouseId(), item.getCargoOrderId(), item.getShipmentId());
            InboundPlanItemPreviewRespVO vo = new InboundPlanItemPreviewRespVO();
            vo.setItemId(item.getId());
            vo.setCargoOrderNo(item.getCargoOrderNo());
            vo.setShipmentNo(item.getShipmentNo());
            vo.setCurrentGroupCode(item.getGroupCode());
            vo.setProposedGroupCode(proposed);
            vo.setChanged(!Objects.equals(item.getGroupCode(), proposed));
            return vo;
        }).collect(Collectors.toList());
    }

    @Override
    public List<InboundPlanItemPreviewRespVO> previewApplyRule(Long planId, Long ruleId) {
        checkPlanEditable(planId);
        List<InboundPlanItemRespVO> items = itemMapper.selectItemsByPlanId(planId);
        return items.stream().map(item -> {
            String proposed = groupingRuleEngine.computeGroupCodeByRule(
                ruleId, item.getCargoOrderId(), item.getShipmentId());
            InboundPlanItemPreviewRespVO vo = new InboundPlanItemPreviewRespVO();
            vo.setItemId(item.getId());
            vo.setCargoOrderNo(item.getCargoOrderNo());
            vo.setShipmentNo(item.getShipmentNo());
            vo.setCurrentGroupCode(item.getGroupCode());
            vo.setProposedGroupCode(proposed);
            vo.setChanged(proposed != null && !Objects.equals(item.getGroupCode(), proposed));
            return vo;
        }).collect(Collectors.toList());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void saveGroupChanges(Long planId, List<InboundPlanSaveGroupReqVO> changes) {
        checkPlanEditable(planId);
        for (InboundPlanSaveGroupReqVO change : changes) {
            InboundPlanItemDO item = itemMapper.selectById(change.getItemId());
            if (item == null || !planId.equals(item.getPlanId())) continue;
            writeGroupCode(planId, item.getId(), item.getShipmentId(), item.getCargoOrderId(),
                item.getGroupCode(), change.getGroupCode(), "auto_group");
        }
    }

    // ====================== 业务动作 ======================

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void autoGroup(Long planId) {
        InboundPlanDO plan = checkPlanEditable(planId);
        List<InboundPlanItemRespVO> items = itemMapper.selectItemsByPlanId(planId);

        items.forEach(item -> {
            String newGroupCode = groupingRuleEngine.computeGroupCode(
                plan.getWarehouseId(), item.getCargoOrderId(), item.getShipmentId()
            );
            writeGroupCode(planId, item.getId(), item.getShipmentId(), item.getCargoOrderId(),
                item.getGroupCode(), newGroupCode, "auto_group");
        });
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void applyRule(Long planId, InboundPlanApplyRuleReqVO bo) {
        checkPlanEditable(planId);
        List<InboundPlanItemRespVO> items = itemMapper.selectItemsByPlanId(planId);

        items.forEach(item -> {
            String newGroupCode = groupingRuleEngine.computeGroupCodeByRule(
                bo.getRuleId(), item.getCargoOrderId(), item.getShipmentId()
            );
            // null 表示该规则条件未命中，跳过
            if (newGroupCode != null) {
                writeGroupCode(planId, item.getId(), item.getShipmentId(), item.getCargoOrderId(),
                    item.getGroupCode(), newGroupCode, "quick_config");
            }
        });
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateItem(InboundPlanItemUpdateReqVO bo) {
        InboundPlanItemDO item = itemMapper.selectById(bo.getId());
        if (item == null) throw exception(OMS_BIZ_ERROR, "明细不存在");

        String oldGroupCode = item.getGroupCode();

        InboundPlanItemDO update = new InboundPlanItemDO();
        update.setId(bo.getId());
        if (bo.getGroupCode() != null) {
            update.setGroupCode(bo.getGroupCode());
        }
        if (bo.getPreLocation() != null) {
            update.setPreLocation(bo.getPreLocation());
        }
        itemMapper.updateById(update);

        // group_code 有变更时记录日志并回写
        if (bo.getGroupCode() != null && !Objects.equals(oldGroupCode, bo.getGroupCode())) {
            writeGroupCode(item.getPlanId(), item.getId(), item.getShipmentId(), item.getCargoOrderId(),
                oldGroupCode, bo.getGroupCode(), "manual");
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void startWork(Long planId) {
        InboundPlanDO plan = baseMapper.selectById(planId);
        if (plan == null) throw exception(OMS_BIZ_ERROR, "入库计划不存在");
        if (!"draft".equals(plan.getStatus())) throw exception(OMS_BIZ_ERROR, "当前状态不允许开始作业");

        InboundPlanDO update = new InboundPlanDO();
        update.setId(planId);
        update.setStatus("in_progress");
        baseMapper.updateById(update);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void complete(Long planId) {
        InboundPlanDO plan = baseMapper.selectById(planId);
        if (plan == null) throw exception(OMS_BIZ_ERROR, "入库计划不存在");
        if (!"in_progress".equals(plan.getStatus())) throw exception(OMS_BIZ_ERROR, "当前状态不允许完结");

        InboundPlanDO update = new InboundPlanDO();
        update.setId(planId);
        update.setStatus("completed");
        baseMapper.updateById(update);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void cancel(Long planId) {
        InboundPlanDO plan = baseMapper.selectById(planId);
        if (plan == null) throw exception(OMS_BIZ_ERROR, "入库计划不存在");
        if ("completed".equals(plan.getStatus())) throw exception(OMS_BIZ_ERROR, "已完结计划不能取消");

        InboundPlanDO update = new InboundPlanDO();
        update.setId(planId);
        update.setStatus("cancelled");
        baseMapper.updateById(update);
    }

    // ====================== 私有方法 ======================

    /** 加载海柜下所有货件，生成计划明细行 */
    private void loadShipmentsIntoPlan(InboundPlanDO plan) {
        insertMissingPlanItems(plan, shipmentMapper.selectShipmentsByContainerOrderId(plan.getContainerOrderId()));
    }

    /** 计划无明细但海柜下仍有货件时，重新装载明细 */
    private void ensurePlanHasItems(InboundPlanDO plan) {
        if (plan == null || plan.getId() == null) {
            return;
        }
        Long itemCount = itemMapper.selectCount(
            new LambdaQueryWrapper<InboundPlanItemDO>()
                .eq(InboundPlanItemDO::getPlanId, plan.getId())
                .eq(InboundPlanItemDO::getDeleted, 0)
        );
        if (itemCount != null && itemCount > 0) {
            return;
        }
        loadShipmentsIntoPlan(plan);
    }

    /** 已有计划时，清理失效明细并补同步后续新增的货件 */
    private void syncMissingShipments(InboundPlanDO plan) {
        if (plan == null || plan.getId() == null) {
            return;
        }
        List<CargoOrderShipmentDO> shipments = shipmentMapper.selectShipmentsByContainerOrderId(plan.getContainerOrderId());
        Set<Long> validShipmentIds = shipments.stream()
            .map(CargoOrderShipmentDO::getId)
            .filter(Objects::nonNull)
            .collect(Collectors.toSet());

        List<InboundPlanItemDO> existingItems = itemMapper.selectList(
            new LambdaQueryWrapper<InboundPlanItemDO>()
                .eq(InboundPlanItemDO::getPlanId, plan.getId())
                .eq(InboundPlanItemDO::getDeleted, 0)
        );
        existingItems.stream()
            .filter(item -> item.getShipmentId() == null || !validShipmentIds.contains(item.getShipmentId()))
            .map(InboundPlanItemDO::getId)
            .forEach(itemMapper::deleteById);

        Set<Long> existingShipmentIds = existingItems.stream()
            .map(InboundPlanItemDO::getShipmentId)
            .filter(id -> id != null && validShipmentIds.contains(id))
            .collect(Collectors.toSet());
        List<CargoOrderShipmentDO> missingShipments = shipments.stream()
            .filter(shipment -> shipment.getId() != null && !existingShipmentIds.contains(shipment.getId()))
            .toList();
        insertMissingPlanItems(plan, missingShipments);
    }

    private void insertMissingPlanItems(InboundPlanDO plan, List<CargoOrderShipmentDO> shipments) {
        if (CollUtil.isEmpty(shipments)) {
            return;
        }
        List<InboundPlanItemDO> items = shipments.stream().map(s -> {
            InboundPlanItemDO item = new InboundPlanItemDO();
            item.setTenantId(plan.getTenantId());
            item.setPlanId(plan.getId());
            item.setCargoOrderId(s.getCargoOrderId());
            item.setShipmentId(s.getId());
            return item;
        }).collect(Collectors.toList());
        itemMapper.insertBatch(items);
    }

    private void fillContainerOrderHeader(InboundPlanRespVO vo, Long containerOrderId) {
        if (containerOrderId == null) {
            return;
        }
        ContainerOrderDO containerOrder = containerOrderMapper.selectById(containerOrderId);
        if (containerOrder == null) {
            return;
        }
        vo.setCustomerName(containerOrder.getCustomerName());
        vo.setEta(containerOrder.getEta());
        vo.setTotalCbm(containerOrder.getTotalCbm());
        vo.setTotalCartonQty(containerOrder.getTotalCartonQty());
        vo.setTotalWeight(containerOrder.getTotalWeight());
        if (containerOrder.getChannelId() != null) {
            ChannelDO channel = channelMapper.selectById(containerOrder.getChannelId());
            if (channel != null) {
                vo.setChannelName(channel.getChannelName());
            }
        }
    }

    /** 写入 group_code 并同步回写货件表、记录日志 */
    private void writeGroupCode(Long planId, Long itemId, Long shipmentId, Long cargoOrderId,
                                 String oldGroupCode, String newGroupCode, String changeType) {
        // 更新计划明细
        InboundPlanItemDO update = new InboundPlanItemDO();
        update.setId(itemId);
        update.setGroupCode(newGroupCode);
        itemMapper.updateById(update);

        // 回写货件表
        CargoOrderShipmentDO shipmentUpdate = new CargoOrderShipmentDO();
        shipmentUpdate.setId(shipmentId);
        shipmentUpdate.setGroupCode(newGroupCode);
        shipmentMapper.updateById(shipmentUpdate);

        // 回写货物订单表（聚合逻辑由独立方法处理）
        groupingRuleEngine.syncCargoOrderGroupCode(cargoOrderId);

        // 记录变更日志
        InboundPlanChangeLogDO log = new InboundPlanChangeLogDO();
        log.setPlanId(planId);
        log.setPlanItemId(itemId);
        log.setShipmentId(shipmentId);
        log.setOldGroupCode(oldGroupCode);
        log.setNewGroupCode(newGroupCode);
        log.setChangeType(changeType);
        log.setChangeBy(SecurityFrameworkUtils.getLoginUserId());
        log.setChangeTime(new Date());
        changeLogMapper.insert(log);
    }

    /** 检查计划是否可编辑（草稿或作业中） */
    private InboundPlanDO checkPlanEditable(Long planId) {
        InboundPlanDO plan = baseMapper.selectById(planId);
        if (plan == null) throw exception(OMS_BIZ_ERROR, "入库计划不存在");
        if ("completed".equals(plan.getStatus()) || "cancelled".equals(plan.getStatus())) {
            throw exception(OMS_BIZ_ERROR, "当前状态不允许修改分组");
        }
        return plan;
    }

    private String generatePlanNo() {
        return "IP-" + cn.hutool.core.date.DateUtil.format(new Date(), "yyyyMMdd")
            + "-" + IdUtil.getSnowflakeNextIdStr().substring(10);
    }
}
