package cn.iocoder.yudao.module.wms.controller.admin.location;

import cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.excel.core.util.ExcelUtils;
import cn.iocoder.yudao.module.wms.controller.admin.location.vo.WmsLocationBatchStatusReqVO;
import cn.iocoder.yudao.module.wms.controller.admin.location.vo.WmsLocationImportExcelVO;
import cn.iocoder.yudao.module.wms.controller.admin.location.vo.WmsLocationPageReqVO;
import cn.iocoder.yudao.module.wms.controller.admin.location.vo.WmsLocationRespVO;
import cn.iocoder.yudao.module.wms.controller.admin.location.vo.WmsLocationSaveReqVO;
import cn.iocoder.yudao.module.wms.service.location.WmsLocationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import static cn.iocoder.yudao.framework.apilog.core.enums.OperateTypeEnum.*;
import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - WMS 库位")
@RestController
@RequestMapping("/wms/location")
@Validated
public class WmsLocationController {

    @Resource
    private WmsLocationService locationService;

    @GetMapping("/page")
    @Operation(summary = "库位分页")
    @PreAuthorize("@ss.hasPermission('wms:location:list')")
    public CommonResult<PageResult<WmsLocationRespVO>> getPage(@Valid WmsLocationPageReqVO pageReqVO) {
        return success(locationService.getLocationPage(pageReqVO));
    }

    @GetMapping("/options")
    @Operation(summary = "库位下拉")
    @PreAuthorize("@ss.hasPermission('wms:location:list')")
    public CommonResult<List<WmsLocationRespVO>> getOptions(WmsLocationPageReqVO pageReqVO) {
        pageReqVO.setPageSize(PageParam.PAGE_SIZE_NONE);
        return success(locationService.getLocationList(pageReqVO));
    }

    @GetMapping("/get")
    @Operation(summary = "库位详情")
    @Parameter(name = "id", required = true)
    @PreAuthorize("@ss.hasPermission('wms:location:query')")
    public CommonResult<WmsLocationRespVO> get(@RequestParam("id") Long id) {
        return success(locationService.getLocation(id));
    }

    @PostMapping("/create")
    @Operation(summary = "创建库位")
    @PreAuthorize("@ss.hasPermission('wms:location:add')")
    @ApiAccessLog(operateType = CREATE)
    public CommonResult<Long> create(@Valid @RequestBody WmsLocationSaveReqVO createReqVO) {
        return success(locationService.createLocation(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新库位")
    @PreAuthorize("@ss.hasPermission('wms:location:edit')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> update(@Valid @RequestBody WmsLocationSaveReqVO updateReqVO) {
        locationService.updateLocation(updateReqVO);
        return success(true);
    }

    @PutMapping("/change-status")
    @Operation(summary = "库位批量改状态")
    @PreAuthorize("@ss.hasPermission('wms:location:changeStatus')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> changeStatus(@Valid @RequestBody WmsLocationBatchStatusReqVO reqVO) {
        locationService.changeLocationStatus(reqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除库位")
    @PreAuthorize("@ss.hasPermission('wms:location:remove')")
    @ApiAccessLog(operateType = DELETE)
    public CommonResult<Boolean> delete(@RequestParam("ids") List<Long> ids) {
        locationService.deleteLocationList(ids);
        return success(true);
    }

    @GetMapping("/export")
    @Operation(summary = "导出库位")
    @PreAuthorize("@ss.hasPermission('wms:location:export')")
    @ApiAccessLog(operateType = EXPORT)
    public void export(@Valid WmsLocationPageReqVO pageReqVO, HttpServletResponse response) throws IOException {
        pageReqVO.setPageSize(PageParam.PAGE_SIZE_NONE);
        List<WmsLocationRespVO> list = locationService.getLocationList(pageReqVO);
        ExcelUtils.write(response, "WMS库位.xls", "数据", WmsLocationRespVO.class, list);
    }

    @GetMapping("/import-template")
    @Operation(summary = "库位导入模板")
    @PreAuthorize("@ss.hasPermission('wms:location:import')")
    public void importTemplate(HttpServletResponse response) throws IOException {
        ExcelUtils.write(response, "库位导入模板.xls", "库位", WmsLocationImportExcelVO.class, new ArrayList<>());
    }

    @PostMapping("/import")
    @Operation(summary = "导入库位")
    @PreAuthorize("@ss.hasPermission('wms:location:import')")
    @ApiAccessLog(operateType = IMPORT)
    public CommonResult<String> importData(@RequestParam("file") MultipartFile file,
                                           @RequestParam Long warehouseId,
                                           @RequestParam(required = false) Long companyId) throws IOException {
        List<WmsLocationImportExcelVO> list = ExcelUtils.read(file, WmsLocationImportExcelVO.class);
        return success(locationService.importLocationData(list, warehouseId, companyId));
    }

}
