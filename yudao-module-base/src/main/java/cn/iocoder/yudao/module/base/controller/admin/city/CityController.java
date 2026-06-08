package cn.iocoder.yudao.module.base.controller.admin.city;

import cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.excel.core.util.ExcelUtils;
import cn.iocoder.yudao.module.base.controller.admin.city.vo.*;
import cn.iocoder.yudao.module.base.service.city.CityService;
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

@Tag(name = "管理后台 - 城市")
@RestController
@RequestMapping("/base/city")
@Validated
public class CityController {

    @Resource
    private CityService cityService;

    @PostMapping("/create")
    @Operation(summary = "创建城市")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    public CommonResult<Long> create(@Valid @RequestBody CitySaveReqVO createReqVO) {
        return success(cityService.createCity(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新城市")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    public CommonResult<Boolean> update(@Valid @RequestBody CitySaveReqVO updateReqVO) {
        cityService.updateCity(updateReqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除城市")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('base:data:delete')")
    public CommonResult<Boolean> delete(@RequestParam("id") Long id) {
        cityService.deleteCity(id);
        return success(true);
    }

    @PutMapping("/update-status")
    @Operation(summary = "启用/停用城市")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    public CommonResult<Boolean> updateStatus(@Valid @RequestBody CityUpdateStatusReqVO reqVO) {
        cityService.updateCityStatus(reqVO);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得城市详情")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<CityRespVO> get(@RequestParam("id") Long id) {
        return success(cityService.getCity(id));
    }

    @GetMapping("/page")
    @Operation(summary = "获得城市分页")
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<PageResult<CityRespVO>> getPage(@Valid CityPageReqVO pageReqVO) {
        return success(cityService.getCityPage(pageReqVO));
    }

    @GetMapping("/simple-list")
    @Operation(summary = "获得城市精简列表", description = "可按 countryCode、stateCode、status 过滤；默认 status=0（正常）")
    public CommonResult<List<CityRespVO>> getSimpleList(
            @RequestParam(value = "countryCode", required = false) String countryCode,
            @RequestParam(value = "stateCode", required = false) String stateCode,
            @RequestParam(value = "status", required = false) Integer status) {
        Integer queryStatus = status != null ? status : CommonStatusEnum.ENABLE.getStatus();
        return success(cityService.getCitySimpleList(countryCode, stateCode, queryStatus));
    }

    @GetMapping("/get-import-template")
    @Operation(summary = "获得城市导入模板")
    @PreAuthorize("@ss.hasPermission('base:data:import')")
    @ApiAccessLog(operateType = EXPORT)
    public void importTemplate(HttpServletResponse response) throws IOException {
        List<CityImportExcelVO> list = Arrays.asList(
                CityImportExcelVO.builder().countryCode("US").stateCode("CA").nameEn("Los Angeles").build(),
                CityImportExcelVO.builder().countryCode("US").stateCode("NY").nameEn("New York").build()
        );
        ExcelUtils.write(response, "城市导入模板.xls", "城市列表", CityImportExcelVO.class, list);
    }

    @PostMapping("/import-excel")
    @Operation(summary = "导入城市")
    @Parameters({
            @Parameter(name = "file", description = "Excel 文件", required = true),
            @Parameter(name = "updateSupport", description = "是否支持更新", example = "true")
    })
    @PreAuthorize("@ss.hasPermission('base:data:import')")
    public CommonResult<CityImportRespVO> importExcel(@RequestParam("file") MultipartFile file,
                                                      @RequestParam(value = "updateSupport", required = false, defaultValue = "false") Boolean updateSupport) throws Exception {
        List<CityImportExcelVO> list = ExcelUtils.read(file, CityImportExcelVO.class);
        return success(cityService.importCityList(list, Boolean.TRUE.equals(updateSupport)));
    }

}
