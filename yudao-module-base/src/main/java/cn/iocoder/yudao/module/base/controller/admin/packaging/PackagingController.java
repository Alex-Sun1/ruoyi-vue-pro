package cn.iocoder.yudao.module.base.controller.admin.packaging;

import cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.excel.core.util.ExcelUtils;
import cn.iocoder.yudao.module.base.controller.admin.packaging.vo.*;
import cn.iocoder.yudao.module.base.service.packaging.PackagingService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.Parameters;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import static cn.iocoder.yudao.framework.apilog.core.enums.OperateTypeEnum.*;
import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - 包装规格")
@RestController
@RequestMapping("/base/packaging")
@Validated
public class PackagingController {

    @Resource
    private PackagingService packagingService;

    @PostMapping("/create")
    @Operation(summary = "创建包装")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    @ApiAccessLog(operateType = CREATE)
    public CommonResult<Long> create(@Valid @RequestBody PackagingSaveReqVO createReqVO) {
        return success(packagingService.createPackaging(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新包装")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> update(@Valid @RequestBody PackagingSaveReqVO updateReqVO) {
        packagingService.updatePackaging(updateReqVO);
        return success(true);
    }

    @PutMapping("/update-status")
    @Operation(summary = "启用/停用包装")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> updateStatus(@Valid @RequestBody PackagingUpdateStatusReqVO reqVO) {
        packagingService.updatePackagingStatus(reqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除包装")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('base:data:delete')")
    @ApiAccessLog(operateType = DELETE)
    public CommonResult<Boolean> delete(@RequestParam("id") Long id) {
        packagingService.deletePackaging(id);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得包装详情")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<PackagingRespVO> get(@RequestParam("id") Long id) {
        return success(packagingService.getPackaging(id));
    }

    @GetMapping("/page")
    @Operation(summary = "获得包装分页")
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<PageResult<PackagingRespVO>> getPage(@Valid PackagingPageReqVO pageReqVO) {
        return success(packagingService.getPackagingPage(pageReqVO));
    }

    @GetMapping("/simple-list")
    @Operation(summary = "获得包装精简列表", description = "默认 status=0（正常）")
    public CommonResult<List<PackagingRespVO>> getSimpleList(
            @RequestParam(value = "status", required = false) Integer status) {
        Integer queryStatus = status != null ? status : CommonStatusEnum.ENABLE.getStatus();
        return success(packagingService.getPackagingSimpleList(queryStatus));
    }

    @GetMapping("/get-import-template")
    @Operation(summary = "获得包装导入模板")
    @PreAuthorize("@ss.hasPermission('base:data:import')")
    @ApiAccessLog(operateType = EXPORT)
    public void importTemplate(HttpServletResponse response) throws IOException {
        List<PackagingImportExcelVO> list = Arrays.asList(
                PackagingImportExcelVO.builder().pkgCode("BOX-S").pkgName("小纸箱")
                        .pkgType(1).sourceType(1).length(new java.math.BigDecimal("30"))
                        .width(new java.math.BigDecimal("20")).height(new java.math.BigDecimal("15"))
                        .dimensionUnit("CM").tareWeight(new java.math.BigDecimal("0.2")).weightUnit("KG").build()
        );
        ExcelUtils.write(response, "包装导入模板.xls", "包装列表", PackagingImportExcelVO.class, list);
    }

    @PostMapping("/import-excel")
    @Operation(summary = "导入包装")
    @Parameters({
            @Parameter(name = "file", description = "Excel 文件", required = true),
            @Parameter(name = "updateSupport", description = "是否支持更新", example = "true")
    })
    @PreAuthorize("@ss.hasPermission('base:data:import')")
    @ApiAccessLog(operateType = IMPORT)
    public CommonResult<PackagingImportRespVO> importExcel(@RequestParam("file") MultipartFile file,
                                                           @RequestParam(value = "updateSupport", required = false, defaultValue = "false") Boolean updateSupport) throws Exception {
        List<PackagingImportExcelVO> list = ExcelUtils.read(file, PackagingImportExcelVO.class);
        return success(packagingService.importPackagingList(list, Boolean.TRUE.equals(updateSupport)));
    }

    @GetMapping("/export-excel")
    @Operation(summary = "导出包装 Excel")
    @PreAuthorize("@ss.hasPermission('base:data:export')")
    @ApiAccessLog(operateType = EXPORT)
    public void exportExcel(@Valid PackagingPageReqVO pageReqVO, HttpServletResponse response) throws IOException {
        List<PackagingExportExcelVO> list = packagingService.getPackagingExportList(pageReqVO);
        ExcelUtils.write(response, "包装列表.xls", "包装", PackagingExportExcelVO.class, list);
    }

}
