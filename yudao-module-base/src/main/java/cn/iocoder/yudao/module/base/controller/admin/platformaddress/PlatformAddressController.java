package cn.iocoder.yudao.module.base.controller.admin.platformaddress;

import cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.excel.core.util.ExcelUtils;
import cn.iocoder.yudao.module.base.controller.admin.platformaddress.vo.*;
import cn.iocoder.yudao.module.base.service.platformaddress.PlatformAddressService;
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

@Tag(name = "管理后台 - 平台地址")
@RestController
@RequestMapping("/base/platform-address")
@Validated
public class PlatformAddressController {

    @Resource
    private PlatformAddressService platformAddressService;

    @PostMapping("/create")
    @Operation(summary = "创建平台地址")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    @ApiAccessLog(operateType = CREATE)
    public CommonResult<Long> create(@Valid @RequestBody PlatformAddressSaveReqVO createReqVO) {
        return success(platformAddressService.createPlatformAddress(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新平台地址")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> update(@Valid @RequestBody PlatformAddressSaveReqVO updateReqVO) {
        platformAddressService.updatePlatformAddress(updateReqVO);
        return success(true);
    }

    @PutMapping("/update-status")
    @Operation(summary = "启用/停用平台地址")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> updateStatus(@Valid @RequestBody PlatformAddressUpdateStatusReqVO reqVO) {
        platformAddressService.updatePlatformAddressStatus(reqVO);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得平台地址详情")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<PlatformAddressRespVO> get(@RequestParam("id") Long id) {
        return success(platformAddressService.getPlatformAddress(id));
    }

    @GetMapping("/page")
    @Operation(summary = "获得平台地址分页")
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<PageResult<PlatformAddressRespVO>> getPage(@Valid PlatformAddressPageReqVO pageReqVO) {
        if (pageReqVO.getStatus() == null) {
            pageReqVO.setStatus(CommonStatusEnum.ENABLE.getStatus());
        }
        return success(platformAddressService.getPlatformAddressPage(pageReqVO));
    }

    @GetMapping("/simple-list")
    @Operation(summary = "Get platform address simple list")
    public CommonResult<List<PlatformAddressRespVO>> getSimpleList(
            @RequestParam(value = "platformId", required = false) Long platformId,
            @RequestParam(value = "platformCode", required = false) String platformCode,
            @RequestParam(value = "status", required = false) Integer status) {
        Integer queryStatus = status != null ? status : CommonStatusEnum.ENABLE.getStatus();
        return success(platformAddressService.getPlatformAddressSimpleList(platformId, platformCode, queryStatus));
    }

    @GetMapping("/change-log")
    @Operation(summary = "获得平台地址变更记录")
    @Parameter(name = "platformAddressId", description = "平台地址编号", required = true)
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<List<PlatformAddressChangeLogRespVO>> getChangeLog(
            @RequestParam("platformAddressId") Long platformAddressId) {
        return success(platformAddressService.getPlatformAddressChangeLog(platformAddressId));
    }

    @GetMapping("/get-import-template")
    @Operation(summary = "获得平台地址导入模板")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    @ApiAccessLog(operateType = EXPORT)
    public void importTemplate(HttpServletResponse response) throws IOException {
        List<PlatformAddressImportExcelVO> list = Arrays.asList(
                PlatformAddressImportExcelVO.builder()
                        .platformCode("AMAZON").addressCode("ONT8").addressType(1)
                        .nameEn("Amazon ONT8").countryCode("US").stateCode("CA").city("Ontario")
                        .addressLine1("1910 E Central Ave").zipCode("91761")
                        .whProperty("LARGE").palletCbm(new java.math.BigDecimal("1.8"))
                        .isWeighStation(1).maxWeightTon(new java.math.BigDecimal("20.5"))
                        .build()
        );
        ExcelUtils.write(response, "平台地址导入模板.xls", "平台地址", PlatformAddressImportExcelVO.class, list);
    }

    @PostMapping("/import-excel")
    @Operation(summary = "导入平台地址")
    @Parameters({
            @Parameter(name = "file", description = "Excel 文件", required = true),
            @Parameter(name = "updateSupport", description = "是否支持更新", example = "true")
    })
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    @ApiAccessLog(operateType = IMPORT)
    public CommonResult<PlatformAddressImportRespVO> importExcel(@RequestParam("file") MultipartFile file,
                                                                 @RequestParam(value = "updateSupport", required = false, defaultValue = "false") Boolean updateSupport) throws Exception {
        List<PlatformAddressImportExcelVO> list = ExcelUtils.read(file, PlatformAddressImportExcelVO.class);
        return success(platformAddressService.importPlatformAddressList(list, Boolean.TRUE.equals(updateSupport)));
    }

}
