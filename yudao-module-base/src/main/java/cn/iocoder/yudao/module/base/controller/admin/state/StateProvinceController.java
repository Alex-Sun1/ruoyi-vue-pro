package cn.iocoder.yudao.module.base.controller.admin.state;

import cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.excel.core.util.ExcelUtils;
import cn.iocoder.yudao.module.base.controller.admin.state.vo.*;
import cn.iocoder.yudao.module.base.service.state.StateProvinceService;
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

@Tag(name = "管理后台 - 州/省")
@RestController
@RequestMapping("/base/state-province")
@Validated
public class StateProvinceController {

    @Resource
    private StateProvinceService stateProvinceService;

    @PostMapping("/create")
    @Operation(summary = "创建州/省")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    public CommonResult<Long> create(@Valid @RequestBody StateProvinceSaveReqVO createReqVO) {
        return success(stateProvinceService.createStateProvince(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新州/省")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    public CommonResult<Boolean> update(@Valid @RequestBody StateProvinceSaveReqVO updateReqVO) {
        stateProvinceService.updateStateProvince(updateReqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除州/省")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('base:data:delete')")
    public CommonResult<Boolean> delete(@RequestParam("id") Long id) {
        stateProvinceService.deleteStateProvince(id);
        return success(true);
    }

    @PutMapping("/update-status")
    @Operation(summary = "启用/停用州/省")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    public CommonResult<Boolean> updateStatus(@Valid @RequestBody StateProvinceUpdateStatusReqVO reqVO) {
        stateProvinceService.updateStateProvinceStatus(reqVO);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得州/省详情")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<StateProvinceRespVO> get(@RequestParam("id") Long id) {
        return success(stateProvinceService.getStateProvince(id));
    }

    @GetMapping("/page")
    @Operation(summary = "获得州/省分页")
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<PageResult<StateProvinceRespVO>> getPage(@Valid StateProvincePageReqVO pageReqVO) {
        return success(stateProvinceService.getStateProvincePage(pageReqVO));
    }

    @GetMapping("/simple-list")
    @Operation(summary = "获得州/省精简列表", description = "可按 countryCode、status 过滤；默认 status=0（正常）")
    public CommonResult<List<StateProvinceRespVO>> getSimpleList(
            @RequestParam(value = "countryCode", required = false) String countryCode,
            @RequestParam(value = "status", required = false) Integer status) {
        Integer queryStatus = status != null ? status : CommonStatusEnum.ENABLE.getStatus();
        return success(stateProvinceService.getStateProvinceSimpleList(countryCode, queryStatus));
    }

    @GetMapping("/get-import-template")
    @Operation(summary = "获得州/省导入模板")
    @PreAuthorize("@ss.hasPermission('base:data:import')")
    @ApiAccessLog(operateType = EXPORT)
    public void importTemplate(HttpServletResponse response) throws IOException {
        List<StateProvinceImportExcelVO> list = Arrays.asList(
                StateProvinceImportExcelVO.builder().countryCode("US").code("CA").nameEn("California").build(),
                StateProvinceImportExcelVO.builder().countryCode("US").code("NY").nameEn("New York").build()
        );
        ExcelUtils.write(response, "州省导入模板.xls", "州省列表", StateProvinceImportExcelVO.class, list);
    }

    @PostMapping("/import-excel")
    @Operation(summary = "导入州/省")
    @Parameters({
            @Parameter(name = "file", description = "Excel 文件", required = true),
            @Parameter(name = "updateSupport", description = "是否支持更新", example = "true")
    })
    @PreAuthorize("@ss.hasPermission('base:data:import')")
    public CommonResult<StateProvinceImportRespVO> importExcel(@RequestParam("file") MultipartFile file,
                                                               @RequestParam(value = "updateSupport", required = false, defaultValue = "false") Boolean updateSupport) throws Exception {
        List<StateProvinceImportExcelVO> list = ExcelUtils.read(file, StateProvinceImportExcelVO.class);
        return success(stateProvinceService.importStateProvinceList(list, Boolean.TRUE.equals(updateSupport)));
    }

}
