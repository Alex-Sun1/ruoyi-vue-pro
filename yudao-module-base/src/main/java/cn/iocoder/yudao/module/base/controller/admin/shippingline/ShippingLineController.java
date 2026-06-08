package cn.iocoder.yudao.module.base.controller.admin.shippingline;

import cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.controller.admin.shippingline.vo.*;
import cn.iocoder.yudao.module.base.service.shippingline.ShippingLineService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static cn.iocoder.yudao.framework.apilog.core.enums.OperateTypeEnum.*;
import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - 船司")
@RestController
@RequestMapping("/base/shipping-line")
@Validated
public class ShippingLineController {

    @Resource
    private ShippingLineService shippingLineService;

    @PostMapping("/create")
    @Operation(summary = "创建船司")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    @ApiAccessLog(operateType = CREATE)
    public CommonResult<Long> create(@Valid @RequestBody ShippingLineSaveReqVO createReqVO) {
        return success(shippingLineService.createShippingLine(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新船司")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> update(@Valid @RequestBody ShippingLineSaveReqVO updateReqVO) {
        shippingLineService.updateShippingLine(updateReqVO);
        return success(true);
    }

    @PutMapping("/update-status")
    @Operation(summary = "启用/停用船司")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> updateStatus(@Valid @RequestBody ShippingLineUpdateStatusReqVO reqVO) {
        shippingLineService.updateShippingLineStatus(reqVO);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得船司详情")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<ShippingLineRespVO> get(@RequestParam("id") Long id) {
        return success(shippingLineService.getShippingLine(id));
    }

    @GetMapping("/page")
    @Operation(summary = "获得船司分页")
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<PageResult<ShippingLineRespVO>> getPage(@Valid ShippingLinePageReqVO pageReqVO) {
        return success(shippingLineService.getShippingLinePage(pageReqVO));
    }

    @GetMapping("/simple-list")
    @Operation(summary = "获得船司精简列表", description = "默认 status=0（正常）")
    public CommonResult<List<ShippingLineRespVO>> getSimpleList(
            @RequestParam(value = "status", required = false) Integer status) {
        Integer queryStatus = status != null ? status : CommonStatusEnum.ENABLE.getStatus();
        return success(shippingLineService.getShippingLineSimpleList(queryStatus));
    }

}
