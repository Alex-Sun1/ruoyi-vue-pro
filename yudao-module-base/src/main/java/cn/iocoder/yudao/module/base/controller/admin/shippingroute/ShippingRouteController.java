package cn.iocoder.yudao.module.base.controller.admin.shippingroute;

import cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.excel.core.util.ExcelUtils;
import cn.iocoder.yudao.module.base.controller.admin.shippingroute.vo.*;
import cn.iocoder.yudao.module.base.service.shippingroute.ShippingRouteService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

import static cn.iocoder.yudao.framework.apilog.core.enums.OperateTypeEnum.*;
import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - 航线")
@RestController
@RequestMapping("/base/shipping-route")
@Validated
public class ShippingRouteController {

    @Resource
    private ShippingRouteService shippingRouteService;

    @PostMapping("/create")
    @Operation(summary = "创建航线")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    @ApiAccessLog(operateType = CREATE)
    public CommonResult<Long> create(@Valid @RequestBody ShippingRouteSaveReqVO createReqVO) {
        return success(shippingRouteService.createShippingRoute(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新航线")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> update(@Valid @RequestBody ShippingRouteSaveReqVO updateReqVO) {
        shippingRouteService.updateShippingRoute(updateReqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除航线")
    @Parameter(name = "id", required = true)
    @PreAuthorize("@ss.hasPermission('base:data:delete')")
    @ApiAccessLog(operateType = DELETE)
    public CommonResult<Boolean> delete(@RequestParam("id") Long id) {
        shippingRouteService.deleteShippingRoute(id);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得航线详情")
    @Parameter(name = "id", required = true)
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<ShippingRouteRespVO> get(@RequestParam("id") Long id) {
        return success(shippingRouteService.getShippingRoute(id));
    }

    @GetMapping("/page")
    @Operation(summary = "获得航线分页")
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<PageResult<ShippingRouteRespVO>> page(@Valid ShippingRoutePageReqVO pageReqVO) {
        return success(shippingRouteService.getShippingRoutePage(pageReqVO));
    }

    @GetMapping("/simple-list")
    @Operation(summary = "获得航线精简列表", description = "默认 status=0（正常），供下拉选择")
    public CommonResult<List<ShippingRouteRespVO>> getSimpleList(
            @RequestParam(value = "status", required = false) Integer status) {
        Integer queryStatus = status != null ? status : CommonStatusEnum.ENABLE.getStatus();
        return success(shippingRouteService.getShippingRouteSimpleList(queryStatus));
    }

    @GetMapping("/export")
    @Operation(summary = "导出航线")
    @PreAuthorize("@ss.hasPermission('base:data:export')")
    @ApiAccessLog(operateType = EXPORT)
    public void export(@Valid ShippingRoutePageReqVO pageReqVO, HttpServletResponse response) throws IOException {
        ExcelUtils.write(response, "shipping-route.xls", "航线", ShippingRouteRespVO.class,
                shippingRouteService.getShippingRouteExportList(pageReqVO));
    }

}
