package cn.iocoder.yudao.module.base.controller.admin.warehouse;

import cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.excel.core.util.ExcelUtils;
import cn.iocoder.yudao.module.base.controller.admin.warehouse.vo.*;
import cn.iocoder.yudao.module.base.service.warehouse.WarehouseService;
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

@Tag(name = "管理后台 - 仓库")
@RestController
@RequestMapping("/base/warehouse")
@Validated
public class WarehouseController {

    @Resource
    private WarehouseService warehouseService;

    @PostMapping("/create")
    @Operation(summary = "创建仓库")
    @PreAuthorize("@ss.hasPermission('base:warehouse:create')")
    @ApiAccessLog(operateType = CREATE)
    public CommonResult<Long> create(@Valid @RequestBody WarehouseSaveReqVO createReqVO) {
        return success(warehouseService.createWarehouse(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新仓库")
    @PreAuthorize("@ss.hasPermission('base:warehouse:update')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> update(@Valid @RequestBody WarehouseSaveReqVO updateReqVO) {
        warehouseService.updateWarehouse(updateReqVO);
        return success(true);
    }

    @PutMapping("/update-status")
    @Operation(summary = "启用/停用仓库")
    @PreAuthorize("@ss.hasPermission('base:warehouse:update')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> updateStatus(@Valid @RequestBody WarehouseUpdateStatusReqVO reqVO) {
        warehouseService.updateWarehouseStatus(reqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除仓库")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('base:warehouse:delete')")
    @ApiAccessLog(operateType = DELETE)
    public CommonResult<Boolean> delete(@RequestParam("id") Long id) {
        warehouseService.deleteWarehouse(id);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得仓库详情")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('base:warehouse:query')")
    public CommonResult<WarehouseRespVO> get(@RequestParam("id") Long id) {
        return success(warehouseService.getWarehouse(id));
    }

    @GetMapping("/page")
    @Operation(summary = "获得仓库分页")
    @PreAuthorize("@ss.hasPermission('base:warehouse:query')")
    public CommonResult<PageResult<WarehouseRespVO>> getPage(@Valid WarehousePageReqVO pageReqVO) {
        return success(warehouseService.getWarehousePage(pageReqVO));
    }

    @GetMapping("/simple-list")
    @Operation(summary = "获得仓库精简列表", description = "默认 status=0；数据权限过滤待二期接入")
    public CommonResult<List<WarehouseRespVO>> getSimpleList(
            @RequestParam(value = "status", required = false) Integer status) {
        Integer queryStatus = status != null ? status : CommonStatusEnum.ENABLE.getStatus();
        return success(warehouseService.getWarehouseSimpleList(queryStatus));
    }

    @GetMapping("/export-excel")
    @Operation(summary = "导出仓库 Excel")
    @PreAuthorize("@ss.hasPermission('base:warehouse:export')")
    @ApiAccessLog(operateType = EXPORT)
    public void exportExcel(@Valid WarehousePageReqVO pageReqVO, HttpServletResponse response) throws IOException {
        List<WarehouseExportExcelVO> list = warehouseService.getWarehouseExportList(pageReqVO);
        ExcelUtils.write(response, "仓库列表.xls", "仓库", WarehouseExportExcelVO.class, list);
    }

}
