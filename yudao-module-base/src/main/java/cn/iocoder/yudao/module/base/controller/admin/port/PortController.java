package cn.iocoder.yudao.module.base.controller.admin.port;

import cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.excel.core.util.ExcelUtils;
import cn.iocoder.yudao.module.base.controller.admin.port.vo.*;
import cn.iocoder.yudao.module.base.service.port.PortService;
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

@Tag(name = "管理后台 - 港口")
@RestController
@RequestMapping("/base/port")
@Validated
public class PortController {

    @Resource
    private PortService portService;

    @PostMapping("/create")
    @Operation(summary = "创建港口")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    @ApiAccessLog(operateType = CREATE)
    public CommonResult<Long> create(@Valid @RequestBody PortSaveReqVO createReqVO) {
        return success(portService.createPort(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新港口")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> update(@Valid @RequestBody PortSaveReqVO updateReqVO) {
        portService.updatePort(updateReqVO);
        return success(true);
    }

    @PutMapping("/update-status")
    @Operation(summary = "启用/停用港口")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> updateStatus(@Valid @RequestBody PortUpdateStatusReqVO reqVO) {
        portService.updatePortStatus(reqVO);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得港口详情")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<PortRespVO> get(@RequestParam("id") Long id) {
        return success(portService.getPort(id));
    }

    @GetMapping("/page")
    @Operation(summary = "获得港口分页")
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<PageResult<PortRespVO>> getPage(@Valid PortPageReqVO pageReqVO) {
        return success(portService.getPortPage(pageReqVO));
    }

    @GetMapping("/simple-list")
    @Operation(summary = "获得港口精简列表", description = "默认 status=0（正常）")
    public CommonResult<List<PortRespVO>> getSimpleList(
            @RequestParam(value = "status", required = false) Integer status) {
        Integer queryStatus = status != null ? status : CommonStatusEnum.ENABLE.getStatus();
        return success(portService.getPortSimpleList(queryStatus));
    }

    @GetMapping("/get-import-template")
    @Operation(summary = "获得港口导入模板")
    @PreAuthorize("@ss.hasPermission('base:data:import')")
    @ApiAccessLog(operateType = EXPORT)
    public void importTemplate(HttpServletResponse response) throws IOException {
        List<PortImportExcelVO> list = Arrays.asList(
                PortImportExcelVO.builder()
                        .portCode("USLAX").nameEn("Los Angeles").countryCode("US").stateCode("CA")
                        .city("Los Angeles").portType(1).timezone("America/Los_Angeles")
                        .containerQueryUrl("https://example.com/cntr?no={container_no}")
                        .build(),
                PortImportExcelVO.builder()
                        .portCode("CNSHA").nameEn("Shanghai").countryCode("CN").stateCode("SH")
                        .city("Shanghai").portType(1).timezone("Asia/Shanghai")
                        .build()
        );
        ExcelUtils.write(response, "港口导入模板.xls", "港口列表", PortImportExcelVO.class, list);
    }

    @PostMapping("/import-excel")
    @Operation(summary = "导入港口")
    @Parameters({
            @Parameter(name = "file", description = "Excel 文件", required = true),
            @Parameter(name = "updateSupport", description = "是否支持更新", example = "true")
    })
    @PreAuthorize("@ss.hasPermission('base:data:import')")
    @ApiAccessLog(operateType = IMPORT)
    public CommonResult<PortImportRespVO> importExcel(@RequestParam("file") MultipartFile file,
                                                      @RequestParam(value = "updateSupport", required = false, defaultValue = "false") Boolean updateSupport) throws Exception {
        List<PortImportExcelVO> list = ExcelUtils.read(file, PortImportExcelVO.class);
        return success(portService.importPortList(list, Boolean.TRUE.equals(updateSupport)));
    }

}
