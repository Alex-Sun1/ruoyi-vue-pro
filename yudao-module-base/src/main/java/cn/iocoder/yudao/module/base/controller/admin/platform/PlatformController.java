package cn.iocoder.yudao.module.base.controller.admin.platform;

import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.controller.admin.platform.vo.*;
import cn.iocoder.yudao.module.base.service.platform.PlatformService;
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

@Tag(name = "管理后台 - 平台")
@RestController
@RequestMapping("/base/platform")
@Validated
public class PlatformController {

    @Resource
    private PlatformService platformService;

    @PostMapping("/create")
    @Operation(summary = "创建平台")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    public CommonResult<Long> create(@Valid @RequestBody PlatformSaveReqVO createReqVO) {
        return success(platformService.createPlatform(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新平台")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    public CommonResult<Boolean> update(@Valid @RequestBody PlatformSaveReqVO updateReqVO) {
        platformService.updatePlatform(updateReqVO);
        return success(true);
    }

    @PutMapping("/update-status")
    @Operation(summary = "启用/停用平台")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    public CommonResult<Boolean> updateStatus(@Valid @RequestBody PlatformUpdateStatusReqVO reqVO) {
        platformService.updatePlatformStatus(reqVO);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得平台详情")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<PlatformRespVO> get(@RequestParam("id") Long id) {
        return success(platformService.getPlatform(id));
    }

    @GetMapping("/page")
    @Operation(summary = "获得平台分页")
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<PageResult<PlatformRespVO>> getPage(@Valid PlatformPageReqVO pageReqVO) {
        return success(platformService.getPlatformPage(pageReqVO));
    }

    @GetMapping("/simple-list")
    @Operation(summary = "获得平台精简列表", description = "默认 status=0（正常）")
    public CommonResult<List<PlatformRespVO>> getSimpleList(
            @RequestParam(value = "status", required = false) Integer status) {
        Integer queryStatus = status != null ? status : CommonStatusEnum.ENABLE.getStatus();
        return success(platformService.getPlatformSimpleList(queryStatus));
    }

}
