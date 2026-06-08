package cn.iocoder.yudao.module.base.controller.admin.country;

import cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.excel.core.util.ExcelUtils;
import cn.iocoder.yudao.module.base.controller.admin.country.vo.*;
import cn.iocoder.yudao.module.base.service.country.CountryService;
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

@Tag(name = "管理后台 - 国家")
@RestController
@RequestMapping("/base/country")
@Validated
public class CountryController {

    @Resource
    private CountryService countryService;

    @PostMapping("/create")
    @Operation(summary = "创建国家")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    public CommonResult<Long> create(@Valid @RequestBody CountrySaveReqVO createReqVO) {
        return success(countryService.createCountry(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新国家")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    public CommonResult<Boolean> update(@Valid @RequestBody CountrySaveReqVO updateReqVO) {
        countryService.updateCountry(updateReqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除国家")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('base:data:delete')")
    public CommonResult<Boolean> delete(@RequestParam("id") Long id) {
        countryService.deleteCountry(id);
        return success(true);
    }

    @PutMapping("/update-active")
    @Operation(summary = "开通/停用国家")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    public CommonResult<Boolean> updateActive(@Valid @RequestBody CountryUpdateActiveReqVO reqVO) {
        countryService.updateCountryActive(reqVO);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得国家详情")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<CountryRespVO> get(@RequestParam("id") Long id) {
        return success(countryService.getCountry(id));
    }

    @GetMapping("/page")
    @Operation(summary = "获得国家分页")
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<PageResult<CountryRespVO>> getPage(@Valid CountryPageReqVO pageReqVO) {
        return success(countryService.getCountryPage(pageReqVO));
    }

    @GetMapping("/simple-list")
    @Operation(summary = "获得国家精简列表", description = "默认 isActive=1，可传 ?isActive=0 查未开通")
    public CommonResult<List<CountryRespVO>> getSimpleList(
            @RequestParam(value = "isActive", required = false) Integer isActive) {
        Integer queryActive = isActive != null ? isActive : 1;
        return success(countryService.getCountrySimpleList(queryActive));
    }

    @GetMapping("/get-import-template")
    @Operation(summary = "获得国家导入模板")
    @PreAuthorize("@ss.hasPermission('base:data:import')")
    @ApiAccessLog(operateType = EXPORT)
    public void importTemplate(HttpServletResponse response) throws IOException {
        List<CountryImportExcelVO> list = Arrays.asList(
                CountryImportExcelVO.builder().code("US").nameEn("United States").phoneCode("+1")
                        .currencyCode("USD").timezoneDefault("America/New_York").isActive(1).build(),
                CountryImportExcelVO.builder().code("CN").nameEn("China").phoneCode("+86")
                        .currencyCode("CNY").timezoneDefault("Asia/Shanghai").isActive(1).build()
        );
        ExcelUtils.write(response, "国家导入模板.xls", "国家列表", CountryImportExcelVO.class, list);
    }

    @PostMapping("/import-excel")
    @Operation(summary = "导入国家")
    @Parameters({
            @Parameter(name = "file", description = "Excel 文件", required = true),
            @Parameter(name = "updateSupport", description = "是否支持更新", example = "true")
    })
    @PreAuthorize("@ss.hasPermission('base:data:import')")
    public CommonResult<CountryImportRespVO> importExcel(@RequestParam("file") MultipartFile file,
                                                         @RequestParam(value = "updateSupport", required = false, defaultValue = "false") Boolean updateSupport) throws Exception {
        List<CountryImportExcelVO> list = ExcelUtils.read(file, CountryImportExcelVO.class);
        return success(countryService.importCountryList(list, Boolean.TRUE.equals(updateSupport)));
    }

}
