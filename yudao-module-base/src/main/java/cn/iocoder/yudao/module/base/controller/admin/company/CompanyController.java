package cn.iocoder.yudao.module.base.controller.admin.company;

import cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.excel.core.util.ExcelUtils;
import cn.iocoder.yudao.module.base.controller.admin.company.vo.*;
import cn.iocoder.yudao.module.base.service.company.CompanyService;
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

@Tag(name = "管理后台 - 主体")
@RestController
@RequestMapping("/base/company")
@Validated
public class CompanyController {

    @Resource
    private CompanyService companyService;

    @PostMapping("/create")
    @Operation(summary = "创建主体")
    @PreAuthorize("@ss.hasPermission('base:company:create')")
    @ApiAccessLog(operateType = CREATE)
    public CommonResult<Long> create(@Valid @RequestBody CompanySaveReqVO createReqVO) {
        return success(companyService.createCompany(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新主体")
    @PreAuthorize("@ss.hasPermission('base:company:update')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> update(@Valid @RequestBody CompanySaveReqVO updateReqVO) {
        companyService.updateCompany(updateReqVO);
        return success(true);
    }

    @PutMapping("/update-status")
    @Operation(summary = "启用/停用主体")
    @PreAuthorize("@ss.hasPermission('base:company:update')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> updateStatus(@Valid @RequestBody CompanyUpdateStatusReqVO reqVO) {
        companyService.updateCompanyStatus(reqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除主体")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('base:company:delete')")
    @ApiAccessLog(operateType = DELETE)
    public CommonResult<Boolean> delete(@RequestParam("id") Long id) {
        companyService.deleteCompany(id);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得主体详情")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('base:company:query')")
    public CommonResult<CompanyRespVO> get(@RequestParam("id") Long id) {
        return success(companyService.getCompany(id));
    }

    @GetMapping("/page")
    @Operation(summary = "获得主体分页")
    @PreAuthorize("@ss.hasPermission('base:company:query')")
    public CommonResult<PageResult<CompanyRespVO>> getPage(@Valid CompanyPageReqVO pageReqVO) {
        return success(companyService.getCompanyPage(pageReqVO));
    }

    @GetMapping("/simple-list")
    @Operation(summary = "获得主体精简列表", description = "默认 status=0（正常）")
    public CommonResult<List<CompanyRespVO>> getSimpleList(
            @RequestParam(value = "status", required = false) Integer status) {
        Integer queryStatus = status != null ? status : CommonStatusEnum.ENABLE.getStatus();
        return success(companyService.getCompanySimpleList(queryStatus));
    }

    @GetMapping("/export-excel")
    @Operation(summary = "导出主体 Excel")
    @PreAuthorize("@ss.hasPermission('base:company:export')")
    @ApiAccessLog(operateType = EXPORT)
    public void exportExcel(@Valid CompanyPageReqVO pageReqVO, HttpServletResponse response) throws IOException {
        List<CompanyExportExcelVO> list = companyService.getCompanyExportList(pageReqVO);
        ExcelUtils.write(response, "主体列表.xls", "主体", CompanyExportExcelVO.class, list);
    }

}
