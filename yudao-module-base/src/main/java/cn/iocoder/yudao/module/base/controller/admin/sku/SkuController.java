package cn.iocoder.yudao.module.base.controller.admin.sku;

import cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.excel.core.util.ExcelUtils;
import cn.iocoder.yudao.module.base.controller.admin.sku.vo.*;
import cn.iocoder.yudao.module.base.service.sku.SkuService;
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

@Tag(name = "管理后台 - SKU")
@RestController
@RequestMapping("/base/sku")
@Validated
public class SkuController {

    @Resource
    private SkuService skuService;

    @PostMapping("/create")
    @Operation(summary = "创建 SKU")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    @ApiAccessLog(operateType = CREATE)
    public CommonResult<Long> create(@Valid @RequestBody SkuSaveReqVO createReqVO) {
        return success(skuService.createSku(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新 SKU")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> update(@Valid @RequestBody SkuSaveReqVO updateReqVO) {
        skuService.updateSku(updateReqVO);
        return success(true);
    }

    @PutMapping("/update-status")
    @Operation(summary = "启用/停用 SKU")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> updateStatus(@Valid @RequestBody SkuUpdateStatusReqVO reqVO) {
        skuService.updateSkuStatus(reqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除 SKU")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('base:data:delete')")
    @ApiAccessLog(operateType = DELETE)
    public CommonResult<Boolean> delete(@RequestParam("id") Long id) {
        skuService.deleteSku(id);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得 SKU 详情")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<SkuRespVO> get(@RequestParam("id") Long id) {
        return success(skuService.getSku(id));
    }

    @GetMapping("/page")
    @Operation(summary = "获得 SKU 分页")
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<PageResult<SkuRespVO>> getPage(@Valid SkuPageReqVO pageReqVO) {
        return success(skuService.getSkuPage(pageReqVO));
    }

    @GetMapping("/simple-list")
    @Operation(summary = "获得 SKU 精简列表", description = "默认 status=0；可按 clientId 过滤")
    public CommonResult<List<SkuRespVO>> getSimpleList(
            @RequestParam(value = "clientId", required = false) Long clientId,
            @RequestParam(value = "status", required = false) Integer status) {
        Integer queryStatus = status != null ? status : CommonStatusEnum.ENABLE.getStatus();
        return success(skuService.getSkuSimpleList(clientId, queryStatus));
    }

    @GetMapping("/get-import-template")
    @Operation(summary = "获得 SKU 导入模板")
    @PreAuthorize("@ss.hasPermission('base:data:import')")
    @ApiAccessLog(operateType = EXPORT)
    public void importTemplate(HttpServletResponse response) throws IOException {
        List<SkuImportExcelVO> list = Arrays.asList(
                SkuImportExcelVO.builder().clientId(1001L).skuCode("SKU-DEMO-001")
                        .skuName("示例商品").unit("pcs").build()
        );
        ExcelUtils.write(response, "SKU导入模板.xls", "SKU列表", SkuImportExcelVO.class, list);
    }

    @PostMapping("/import-excel")
    @Operation(summary = "导入 SKU")
    @Parameters({
            @Parameter(name = "file", description = "Excel 文件", required = true),
            @Parameter(name = "updateSupport", description = "是否支持更新", example = "true")
    })
    @PreAuthorize("@ss.hasPermission('base:data:import')")
    @ApiAccessLog(operateType = IMPORT)
    public CommonResult<SkuImportRespVO> importExcel(@RequestParam("file") MultipartFile file,
                                                     @RequestParam(value = "updateSupport", required = false, defaultValue = "false") Boolean updateSupport) throws Exception {
        List<SkuImportExcelVO> list = ExcelUtils.read(file, SkuImportExcelVO.class);
        return success(skuService.importSkuList(list, Boolean.TRUE.equals(updateSupport)));
    }

    @GetMapping("/export-excel")
    @Operation(summary = "导出 SKU Excel")
    @PreAuthorize("@ss.hasPermission('base:data:export')")
    @ApiAccessLog(operateType = EXPORT)
    public void exportExcel(@Valid SkuPageReqVO pageReqVO, HttpServletResponse response) throws IOException {
        List<SkuExportExcelVO> list = skuService.getSkuExportList(pageReqVO);
        ExcelUtils.write(response, "SKU列表.xls", "SKU", SkuExportExcelVO.class, list);
    }

}
