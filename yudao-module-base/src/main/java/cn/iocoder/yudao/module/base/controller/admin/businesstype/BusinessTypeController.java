package cn.iocoder.yudao.module.base.controller.admin.businesstype;

import cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.excel.core.util.ExcelUtils;
import cn.iocoder.yudao.module.base.controller.admin.businesstype.vo.*;
import cn.iocoder.yudao.module.base.service.businesstype.BusinessTypeService;
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

@Tag(name = "Admin - Business Type")
@RestController
@RequestMapping("/base/business-type")
@Validated
public class BusinessTypeController {

    @Resource
    private BusinessTypeService businessTypeService;

    @PostMapping("/create")
    @PreAuthorize("@ss.hasPermission('base:business-type:add')")
    @ApiAccessLog(operateType = CREATE)
    public CommonResult<Long> create(@Valid @RequestBody BusinessTypeSaveReqVO createReqVO) {
        return success(businessTypeService.createBusinessType(createReqVO));
    }

    @PutMapping("/update")
    @PreAuthorize("@ss.hasPermission('base:business-type:edit')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> update(@Valid @RequestBody BusinessTypeSaveReqVO updateReqVO) {
        businessTypeService.updateBusinessType(updateReqVO);
        return success(true);
    }

    @PutMapping("/update-status")
    @PreAuthorize("@ss.hasPermission('base:business-type:edit')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> updateStatus(@Valid @RequestBody BusinessTypeUpdateStatusReqVO reqVO) {
        businessTypeService.updateBusinessTypeStatus(reqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Parameter(name = "id", required = true)
    @PreAuthorize("@ss.hasPermission('base:business-type:remove')")
    @ApiAccessLog(operateType = DELETE)
    public CommonResult<Boolean> delete(@RequestParam("id") Long id) {
        businessTypeService.deleteBusinessType(id);
        return success(true);
    }

    @GetMapping("/get")
    @Parameter(name = "id", required = true)
    @PreAuthorize("@ss.hasPermission('base:business-type:list')")
    public CommonResult<BusinessTypeRespVO> get(@RequestParam("id") Long id) {
        return success(businessTypeService.getBusinessType(id));
    }

    @GetMapping("/page")
    @PreAuthorize("@ss.hasPermission('base:business-type:list')")
    public CommonResult<PageResult<BusinessTypeRespVO>> page(@Valid BusinessTypePageReqVO pageReqVO) {
        return success(businessTypeService.getBusinessTypePage(pageReqVO));
    }

    @GetMapping("/simple-list")
    public CommonResult<List<BusinessTypeRespVO>> simpleList(
            @RequestParam(value = "status", required = false) Integer status,
            @RequestParam(value = "businessCategory", required = false) String businessCategory,
            @RequestParam(value = "operationFlowType", required = false) String operationFlowType) {
        Integer queryStatus = status != null ? status : CommonStatusEnum.ENABLE.getStatus();
        return success(businessTypeService.getBusinessTypeSimpleList(queryStatus, businessCategory, operationFlowType));
    }

    @GetMapping("/export")
    @Operation(summary = "Export business type")
    @PreAuthorize("@ss.hasPermission('base:business-type:export')")
    @ApiAccessLog(operateType = EXPORT)
    public void export(@Valid BusinessTypePageReqVO pageReqVO, HttpServletResponse response) throws IOException {
        ExcelUtils.write(response, "business-type-list.xls", "business-type", BusinessTypeRespVO.class,
                businessTypeService.getBusinessTypeExportList(pageReqVO));
    }

}
