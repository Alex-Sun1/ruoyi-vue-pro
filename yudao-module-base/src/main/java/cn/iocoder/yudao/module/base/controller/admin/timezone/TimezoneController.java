package cn.iocoder.yudao.module.base.controller.admin.timezone;

import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.controller.admin.timezone.vo.*;
import cn.iocoder.yudao.module.base.service.timezone.TimezoneService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - 时区")
@RestController
@RequestMapping("/base/timezone")
@Validated
public class TimezoneController {

    @Resource
    private TimezoneService timezoneService;

    @PostMapping("/create")
    @Operation(summary = "创建时区")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    public CommonResult<Long> create(@Valid @RequestBody TimezoneSaveReqVO createReqVO) {
        return success(timezoneService.createTimezone(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新时区")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    public CommonResult<Boolean> update(@Valid @RequestBody TimezoneSaveReqVO updateReqVO) {
        timezoneService.updateTimezone(updateReqVO);
        return success(true);
    }

    @PutMapping("/update-status")
    @Operation(summary = "启用/停用时区")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    public CommonResult<Boolean> updateStatus(@Valid @RequestBody TimezoneUpdateStatusReqVO reqVO) {
        timezoneService.updateTimezoneStatus(reqVO);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得时区详情")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<TimezoneRespVO> get(@RequestParam("id") Long id) {
        return success(timezoneService.getTimezone(id));
    }

    @GetMapping("/page")
    @Operation(summary = "获得时区分页")
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<PageResult<TimezoneRespVO>> getPage(@Valid TimezonePageReqVO pageReqVO) {
        return success(timezoneService.getTimezonePage(pageReqVO));
    }

    @GetMapping("/simple-list")
    @Operation(summary = "获得时区精简列表", description = "默认 status=0（正常）")
    public CommonResult<List<TimezoneRespVO>> getSimpleList(
            @RequestParam(value = "status", required = false) Integer status) {
        Integer queryStatus = status != null ? status : CommonStatusEnum.ENABLE.getStatus();
        return success(timezoneService.getTimezoneSimpleList(queryStatus));
    }

}
