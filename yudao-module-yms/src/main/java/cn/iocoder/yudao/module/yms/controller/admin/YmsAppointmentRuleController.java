package cn.iocoder.yudao.module.yms.controller.admin;

import org.springframework.security.access.prepost.PreAuthorize;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentRuleAddReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentRuleEditReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentRuleQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentRuleRespVO;
import cn.iocoder.yudao.module.yms.service.YmsAppointmentRuleService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;

@Validated

@RestController
@RequestMapping("/yms/appointment-rule")
public class YmsAppointmentRuleController  {

    @Resource
    private YmsAppointmentRuleService appointmentRuleService;

    @PreAuthorize("@ss.hasPermission('yms:appointmentRule:list')")
    @GetMapping("/list")
    public CommonResult<PageResult<YmsAppointmentRuleRespVO>> list(YmsAppointmentRuleQueryReqVO bo, PageParam pageParam) {
        return success(appointmentRuleService.queryPageList(bo, pageParam));
    }

    @PreAuthorize("@ss.hasPermission('yms:appointmentRule:query')")
    @GetMapping("/{id}")
    public CommonResult<YmsAppointmentRuleRespVO> getInfo(@NotNull @PathVariable Long id) {
        return success(appointmentRuleService.queryById(id));
    }

    @PreAuthorize("@ss.hasPermission('yms:appointmentRule:add')")
    @PostMapping
    public CommonResult<Boolean> add(@Valid @RequestBody YmsAppointmentRuleAddReqVO bo) {
        return success(appointmentRuleService.insertByBo(bo));
    }

    @PreAuthorize("@ss.hasPermission('yms:appointmentRule:edit')")
    @PutMapping
    public CommonResult<Boolean> edit(@Valid @RequestBody YmsAppointmentRuleEditReqVO bo) {
        return success(appointmentRuleService.updateByBo(bo));
    }

    @PreAuthorize("@ss.hasPermission('yms:appointmentRule:remove')")
    @DeleteMapping("/{ids}")
    public CommonResult<Boolean> remove(@NotEmpty @PathVariable Long[] ids) {
        return success(appointmentRuleService.deleteByIds(Arrays.asList(ids)));
    }

    @PreAuthorize("@ss.hasPermission('yms:appointmentRule:edit')")
    @PutMapping("/{id}/toggle")
    public CommonResult<Boolean> toggle(@PathVariable Long id, @RequestParam Integer enabled) {
        return success(appointmentRuleService.toggleEnabled(id, enabled));
    }

    /** 匹配预约规则（供预约校验或调试） */
    @PreAuthorize("@ss.hasPermission('yms:appointmentRule:list')")
    @GetMapping("/match")
    public CommonResult<YmsAppointmentRuleRespVO> match(@RequestParam Long warehouseId,
                                         @RequestParam String businessType,
                                         @RequestParam(required = false) String vehicleSource) {
        return success(appointmentRuleService.matchRule(warehouseId, businessType, vehicleSource));
    }
}
