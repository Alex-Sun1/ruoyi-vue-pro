package cn.iocoder.yudao.module.base.controller.admin.yarddock;

import cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.excel.core.util.ExcelUtils;
import cn.iocoder.yudao.module.base.controller.admin.yarddock.vo.*;
import cn.iocoder.yudao.module.base.service.yarddock.YardDockService;
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

@Tag(name = "管理后台 - 月台")
@RestController
@RequestMapping("/yard/dock")
@Validated
public class YardDockController {

    @Resource
    private YardDockService yardDockService;

    @PostMapping("/create")
    @Operation(summary = "创建月台")
    @PreAuthorize("@ss.hasPermission('yard:dock:add')")
    @ApiAccessLog(operateType = CREATE)
    public CommonResult<Long> create(@Valid @RequestBody YardDockSaveReqVO createReqVO) {
        return success(yardDockService.createYardDock(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新月台")
    @PreAuthorize("@ss.hasPermission('yard:dock:edit')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> update(@Valid @RequestBody YardDockSaveReqVO updateReqVO) {
        yardDockService.updateYardDock(updateReqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除月台")
    @Parameter(name = "id", required = true)
    @PreAuthorize("@ss.hasPermission('yard:dock:remove')")
    @ApiAccessLog(operateType = DELETE)
    public CommonResult<Boolean> delete(@RequestParam("id") Long id) {
        yardDockService.deleteYardDock(id);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得月台详情")
    @Parameter(name = "id", required = true)
    @PreAuthorize("@ss.hasPermission('yard:dock:list')")
    public CommonResult<YardDockRespVO> get(@RequestParam("id") Long id) {
        return success(yardDockService.getYardDock(id));
    }

    @GetMapping("/page")
    @Operation(summary = "获得月台分页")
    @PreAuthorize("@ss.hasPermission('yard:dock:list')")
    public CommonResult<PageResult<YardDockRespVO>> page(@Valid YardDockPageReqVO pageReqVO) {
        return success(yardDockService.getYardDockPage(pageReqVO));
    }

    @GetMapping({"/free-list", "/free"})
    @Operation(summary = "获得仓库空闲道口列表")
    @Parameter(name = "warehouseId", required = true)
    @PreAuthorize("@ss.hasPermission('yard:dock:list')")
    public CommonResult<List<YardDockRespVO>> freeList(@RequestParam("warehouseId") Long warehouseId) {
        return success(yardDockService.getYardDockFreeList(warehouseId));
    }

    @GetMapping("/export")
    @Operation(summary = "导出月台")
    @PreAuthorize("@ss.hasPermission('yard:dock:export')")
    @ApiAccessLog(operateType = EXPORT)
    public void export(@Valid YardDockPageReqVO pageReqVO, HttpServletResponse response) throws IOException {
        ExcelUtils.write(response, "yard-dock.xls", "月台", YardDockRespVO.class,
                yardDockService.getYardDockExportList(pageReqVO));
    }

}
