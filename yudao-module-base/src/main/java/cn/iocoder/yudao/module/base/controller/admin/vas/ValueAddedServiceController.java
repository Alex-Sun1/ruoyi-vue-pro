package cn.iocoder.yudao.module.base.controller.admin.vas;

import cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.excel.core.util.ExcelUtils;
import cn.iocoder.yudao.module.base.controller.admin.vas.vo.*;
import cn.iocoder.yudao.module.base.service.vas.ValueAddedServiceService;
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

@Tag(name = "Admin - Value Added Service")
@RestController
@RequestMapping("/base/vas")
@Validated
public class ValueAddedServiceController {

    @Resource
    private ValueAddedServiceService valueAddedServiceService;

    @PostMapping("/create")
    @PreAuthorize("@ss.hasPermission('base:vas:add')")
    @ApiAccessLog(operateType = CREATE)
    public CommonResult<Long> create(@Valid @RequestBody ValueAddedServiceSaveReqVO createReqVO) {
        return success(valueAddedServiceService.createValueAddedService(createReqVO));
    }

    @PutMapping("/update")
    @PreAuthorize("@ss.hasPermission('base:vas:edit')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> update(@Valid @RequestBody ValueAddedServiceSaveReqVO updateReqVO) {
        valueAddedServiceService.updateValueAddedService(updateReqVO);
        return success(true);
    }

    @PutMapping("/update-status")
    @PreAuthorize("@ss.hasPermission('base:vas:edit')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> updateStatus(@Valid @RequestBody ValueAddedServiceUpdateStatusReqVO reqVO) {
        valueAddedServiceService.updateValueAddedServiceStatus(reqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Parameter(name = "id", required = true)
    @PreAuthorize("@ss.hasPermission('base:vas:remove')")
    @ApiAccessLog(operateType = DELETE)
    public CommonResult<Boolean> delete(@RequestParam("id") Long id) {
        valueAddedServiceService.deleteValueAddedService(id);
        return success(true);
    }

    @GetMapping("/get")
    @Parameter(name = "id", required = true)
    @PreAuthorize("@ss.hasPermission('base:vas:list')")
    public CommonResult<ValueAddedServiceRespVO> get(@RequestParam("id") Long id) {
        return success(valueAddedServiceService.getValueAddedService(id));
    }

    @GetMapping("/page")
    @PreAuthorize("@ss.hasPermission('base:vas:list')")
    public CommonResult<PageResult<ValueAddedServiceRespVO>> page(@Valid ValueAddedServicePageReqVO pageReqVO) {
        return success(valueAddedServiceService.getValueAddedServicePage(pageReqVO));
    }

    @GetMapping("/simple-list")
    public CommonResult<List<ValueAddedServiceRespVO>> simpleList(
            @RequestParam(value = "status", required = false) Integer status,
            @RequestParam(value = "serviceCategory", required = false) String serviceCategory) {
        Integer queryStatus = status != null ? status : CommonStatusEnum.ENABLE.getStatus();
        return success(valueAddedServiceService.getValueAddedServiceSimpleList(queryStatus, serviceCategory));
    }

    @GetMapping("/export")
    @Operation(summary = "Export value added service")
    @PreAuthorize("@ss.hasPermission('base:vas:export')")
    @ApiAccessLog(operateType = EXPORT)
    public void export(@Valid ValueAddedServicePageReqVO pageReqVO, HttpServletResponse response) throws IOException {
        ExcelUtils.write(response, "vas-list.xls", "vas", ValueAddedServiceRespVO.class,
                valueAddedServiceService.getValueAddedServiceExportList(pageReqVO));
    }

}
