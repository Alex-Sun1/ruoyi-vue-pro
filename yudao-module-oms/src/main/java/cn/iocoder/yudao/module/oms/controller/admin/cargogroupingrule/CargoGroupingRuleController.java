package cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule;

import jakarta.validation.Valid;

import static cn.iocoder.yudao.framework.apilog.core.enums.OperateTypeEnum.*;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

import org.springframework.security.access.prepost.PreAuthorize;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog;
import cn.iocoder.yudao.framework.apilog.core.enums.OperateTypeEnum;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo.CargoGroupingRuleSaveReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo.CargoGroupingRulePriorityReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo.CargoGroupingRulePageReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo.CargoGroupingRuleTestReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo.CargoGroupingRuleTestRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo.CargoGroupingRuleRespVO;
import cn.iocoder.yudao.module.oms.service.cargogroupingrule.CargoGroupingRuleService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Validated
@RestController
@RequestMapping("/oms/cargoGroupingRule")
public class CargoGroupingRuleController  {

    @Resource
    private CargoGroupingRuleService cargoGroupingRuleService;

    @PreAuthorize("@ss.hasPermission('oms:cargoGroupingRule:list')")
    @GetMapping({"/list", "/page"})
    public CommonResult<PageResult<CargoGroupingRuleRespVO>> list(CargoGroupingRulePageReqVO bo, @Valid PageParam pageReqVO) {
        return success(cargoGroupingRuleService.queryPageList(bo, pageReqVO));
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoGroupingRule:priority')")
    @ApiAccessLog(operateType = UPDATE)
        @PutMapping("/priority/batch")
    public CommonResult<Void> updatePriority(@RequestBody List<CargoGroupingRulePriorityReqVO> list) {
        cargoGroupingRuleService.updatePriority(list);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoGroupingRule:test')")
    @PostMapping("/test")
    public CommonResult<CargoGroupingRuleTestRespVO> test(@Validated @RequestBody CargoGroupingRuleTestReqVO bo) {
        return success(cargoGroupingRuleService.test(bo));
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoGroupingRule:query')")
    @GetMapping("/{id}")
    public CommonResult<CargoGroupingRuleRespVO> getInfo(@NotNull(message = "id is required") @PathVariable Long id) {
        return success(cargoGroupingRuleService.queryById(id));
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoGroupingRule:add')")
    @ApiAccessLog(operateType = CREATE)
        @PostMapping
    public CommonResult<Void> add(@Valid @RequestBody CargoGroupingRuleSaveReqVO bo) {
        cargoGroupingRuleService.insertByBo(bo);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoGroupingRule:edit')")
    @ApiAccessLog(operateType = UPDATE)
        @PutMapping
    public CommonResult<Void> edit(@Valid @RequestBody CargoGroupingRuleSaveReqVO bo) {
        cargoGroupingRuleService.updateByBo(bo);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoGroupingRule:remove')")
    @ApiAccessLog(operateType = DELETE)
    @DeleteMapping("/{ids}")
    public CommonResult<Void> remove(@NotEmpty(message = "id is required") @PathVariable Long[] ids) {
        cargoGroupingRuleService.deleteWithValidByIds(List.of(ids), true);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoGroupingRule:enable')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{id}/enable")
    public CommonResult<Void> enable(@PathVariable Long id) {
        cargoGroupingRuleService.enable(id);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoGroupingRule:disable')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{id}/disable")
    public CommonResult<Void> disable(@PathVariable Long id) {
        cargoGroupingRuleService.disable(id);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoGroupingRule:copy')")
    @ApiAccessLog(operateType = CREATE)
    @PostMapping("/{id}/copy")
    public CommonResult<Long> copy(@PathVariable Long id) {
        return success(cargoGroupingRuleService.copy(id));
    }
}
