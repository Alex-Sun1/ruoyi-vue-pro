package cn.iocoder.yudao.module.base.controller.admin.zipcode;

import cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.excel.core.util.ExcelUtils;
import cn.iocoder.yudao.module.base.controller.admin.zipcode.vo.*;
import cn.iocoder.yudao.module.base.service.zipcode.ZipCodeService;
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

import static cn.iocoder.yudao.framework.apilog.core.enums.OperateTypeEnum.EXPORT;
import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - 邮编")
@RestController
@RequestMapping("/base/zip-code")
@Validated
public class ZipCodeController {

    @Resource
    private ZipCodeService zipCodeService;

    @PostMapping("/create")
    @Operation(summary = "创建邮编")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    public CommonResult<Long> create(@Valid @RequestBody ZipCodeSaveReqVO createReqVO) {
        return success(zipCodeService.createZipCode(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新邮编")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    public CommonResult<Boolean> update(@Valid @RequestBody ZipCodeSaveReqVO updateReqVO) {
        zipCodeService.updateZipCode(updateReqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除邮编")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('base:data:delete')")
    public CommonResult<Boolean> delete(@RequestParam("id") Long id) {
        zipCodeService.deleteZipCode(id);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得邮编详情")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<ZipCodeRespVO> get(@RequestParam("id") Long id) {
        return success(zipCodeService.getZipCode(id));
    }

    @GetMapping("/page")
    @Operation(summary = "获得邮编分页")
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<PageResult<ZipCodeRespVO>> getPage(@Valid ZipCodePageReqVO pageReqVO) {
        return success(zipCodeService.getZipCodePage(pageReqVO));
    }

    @GetMapping("/simple-list")
    @Operation(summary = "获得邮编精简列表", description = "可按 countryCode、zip 过滤")
    public CommonResult<List<ZipCodeRespVO>> getSimpleList(
            @RequestParam(value = "countryCode", required = false) String countryCode,
            @RequestParam(value = "zip", required = false) String zip) {
        return success(zipCodeService.getZipCodeSimpleList(countryCode, zip));
    }

    @GetMapping("/lookup")
    @Operation(summary = "邮编自动补全", description = "无匹配时返回空对象，HTTP 200")
    public CommonResult<ZipCodeLookupRespVO> lookup(@RequestParam("countryCode") String countryCode,
                                                    @RequestParam("zip") String zip) {
        return success(zipCodeService.lookupZipCode(countryCode, zip));
    }

    @GetMapping("/get-import-template")
    @Operation(summary = "获得邮编导入模板")
    @PreAuthorize("@ss.hasPermission('base:data:import')")
    @ApiAccessLog(operateType = EXPORT)
    public void importTemplate(HttpServletResponse response) throws IOException {
        List<ZipCodeImportExcelVO> list = Arrays.asList(
                ZipCodeImportExcelVO.builder().countryCode("US").stateCode("CA")
                        .cityName("Los Angeles").zip("90001").build(),
                ZipCodeImportExcelVO.builder().countryCode("US").stateCode("NY")
                        .cityName("New York").zip("10001").build()
        );
        ExcelUtils.write(response, "邮编导入模板.xls", "邮编列表", ZipCodeImportExcelVO.class, list);
    }

    @PostMapping("/import-excel")
    @Operation(summary = "导入邮编")
    @Parameters({
            @Parameter(name = "file", description = "Excel 文件", required = true),
            @Parameter(name = "updateSupport", description = "是否支持更新", example = "true")
    })
    @PreAuthorize("@ss.hasPermission('base:data:import')")
    public CommonResult<ZipCodeImportRespVO> importExcel(@RequestParam("file") MultipartFile file,
                                                         @RequestParam(value = "updateSupport", required = false, defaultValue = "false") Boolean updateSupport) throws Exception {
        List<ZipCodeImportExcelVO> list = ExcelUtils.read(file, ZipCodeImportExcelVO.class);
        return success(zipCodeService.importZipCodeList(list, Boolean.TRUE.equals(updateSupport)));
    }

}
