package cn.iocoder.yudao.module.oms.controller.admin.inboundplan;

import jakarta.validation.Valid;

import static cn.iocoder.yudao.framework.apilog.core.enums.OperateTypeEnum.*;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

import org.springframework.security.access.prepost.PreAuthorize;
import jakarta.validation.constraints.NotNull;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog;
import cn.iocoder.yudao.framework.apilog.core.enums.OperateTypeEnum;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanApplyRuleReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanItemUpdateReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanPageReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanSaveGroupReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanItemPreviewRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanRespVO;

import java.util.List;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo.CargoGroupingRulePageReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo.CargoGroupingRuleRespVO;
import cn.iocoder.yudao.module.oms.service.cargogroupingrule.CargoGroupingRuleService;
import cn.iocoder.yudao.module.oms.service.inboundplan.InboundPlanService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

/**
 * 入库计划控制器
 */
@Validated
@RestController
@RequestMapping("/wms/inbound-plan")
public class InboundPlanController  {

    @Resource
    private InboundPlanService inboundPlanService;
    @Resource
    private CargoGroupingRuleService cargoGroupingRuleService;

    /** 快速配置：当前仓库已启用的分组规则 */
    @PreAuthorize("@ss.hasPermission('wms:inboundPlan:applyRule')")
    @GetMapping("/rules/enabled")
    public CommonResult<List<CargoGroupingRuleRespVO>> groupingRules(
            @NotNull(message = "仓库ID不能为空") @RequestParam Long warehouseId) {
        CargoGroupingRulePageReqVO bo = new CargoGroupingRulePageReqVO();
        bo.setWarehouseIds(String.valueOf(warehouseId));
        bo.setStatus("enabled");
        return success(cargoGroupingRuleService.queryList(bo));
    }

    /** 分页列表 */
    @PreAuthorize("@ss.hasPermission('wms:inboundPlan:list')")
    @GetMapping({"/list", "/page"})
    public CommonResult<PageResult<InboundPlanRespVO>> list(InboundPlanPageReqVO bo, @Valid PageParam pageReqVO) {
        return success(inboundPlanService.queryPageList(bo, pageReqVO));
    }

    /**
     * 获取或创建入库计划（海柜订单入口）
     * 首次进入自动创建草稿，再次进入返回已有计划
     */
    @PreAuthorize("@ss.hasPermission('wms:inboundPlan:list')")
    @GetMapping("/get-or-create")
    public CommonResult<InboundPlanRespVO> getOrCreate(@NotNull(message = "海柜订单ID不能为空") @RequestParam Long containerOrderId,
                                         @NotNull(message = "仓库ID不能为空") @RequestParam Long warehouseId) {
        return success(inboundPlanService.getOrCreate(containerOrderId, warehouseId));
    }

    /** 计划详情（含分组 + 明细） */
    @PreAuthorize("@ss.hasPermission('wms:inboundPlan:list')")
    @GetMapping("/{planId:\\d+}")
    public CommonResult<InboundPlanRespVO> detail(@PathVariable Long planId) {
        return success(inboundPlanService.queryDetail(planId));
    }

    // ====================== 预览（不写库）======================

    /** 预览自动分组结果，不写库 */
    @PreAuthorize("@ss.hasPermission('wms:inboundPlan:autoGroup')")
    @PostMapping("/{planId:\\d+}/preview-auto-group")
    public CommonResult<List<InboundPlanItemPreviewRespVO>> previewAutoGroup(@PathVariable Long planId) {
        return success(inboundPlanService.previewAutoGroup(planId));
    }

    /** 预览快速配置规则结果，不写库 */
    @PreAuthorize("@ss.hasPermission('wms:inboundPlan:applyRule')")
    @PostMapping("/{planId:\\d+}/preview-apply-rule")
    public CommonResult<List<InboundPlanItemPreviewRespVO>> previewApplyRule(@PathVariable Long planId,
                                                               @RequestParam Long ruleId) {
        return success(inboundPlanService.previewApplyRule(planId, ruleId));
    }

    /** 确认保存分组（前端审核后提交） */
    @PreAuthorize("@ss.hasPermission('wms:inboundPlan:autoGroup')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{planId:\\d+}/save-group")
    public CommonResult<Void> saveGroupChanges(@PathVariable Long planId,
                                     @Validated @RequestBody List<InboundPlanSaveGroupReqVO> changes) {
        inboundPlanService.saveGroupChanges(planId, changes);
        return success(null);
    }

    // ====================== 业务动作 ======================

    /** 自动分组：对所有货件跑规则引擎 */
    @PreAuthorize("@ss.hasPermission('wms:inboundPlan:autoGroup')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{planId:\\d+}/auto-group")
    public CommonResult<Void> autoGroup(@PathVariable Long planId) {
        inboundPlanService.autoGroup(planId);
        return success(null);
    }

    /** 快速配置：应用指定分组规则（覆盖写入） */
    @PreAuthorize("@ss.hasPermission('wms:inboundPlan:applyRule')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{planId:\\d+}/apply-rule")
    public CommonResult<Void> applyRule(@PathVariable Long planId,
                              @Validated @RequestBody InboundPlanApplyRuleReqVO bo) {
        inboundPlanService.applyRule(planId, bo);
        return success(null);
    }

    /** 手动编辑单行分组/预库位 */
    @PreAuthorize("@ss.hasPermission('wms:inboundPlan:edit')")
    @ApiAccessLog(operateType = UPDATE)
    @PutMapping("/item")
    public CommonResult<Void> updateItem(@Validated @RequestBody InboundPlanItemUpdateReqVO bo) {
        inboundPlanService.updateItem(bo);
        return success(null);
    }

    /** 开始作业：draft → in_progress */
    @PreAuthorize("@ss.hasPermission('wms:inboundPlan:startWork')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{planId:\\d+}/start-work")
    public CommonResult<Void> startWork(@PathVariable Long planId) {
        inboundPlanService.startWork(planId);
        return success(null);
    }

    /** 完结计划：in_progress → completed */
    @PreAuthorize("@ss.hasPermission('wms:inboundPlan:complete')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{planId:\\d+}/complete")
    public CommonResult<Void> complete(@PathVariable Long planId) {
        inboundPlanService.complete(planId);
        return success(null);
    }

    /** 取消计划 */
    @PreAuthorize("@ss.hasPermission('wms:inboundPlan:cancel')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{planId:\\d+}/cancel")
    public CommonResult<Void> cancel(@PathVariable Long planId) {
        inboundPlanService.cancel(planId);
        return success(null);
    }
}
