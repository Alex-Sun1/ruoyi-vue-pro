package cn.iocoder.yudao.module.base.controller.admin.vessel;

import cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.excel.core.util.ExcelUtils;
import cn.iocoder.yudao.module.base.controller.admin.vessel.vo.*;
import cn.iocoder.yudao.module.base.service.vessel.VesselService;
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

@Tag(name = "管理后台 - 船舶")
@RestController
@RequestMapping("/base/vessel")
@Validated
public class VesselController {

    @Resource
    private VesselService vesselService;

    @PostMapping("/create")
    @Operation(summary = "创建船舶")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    @ApiAccessLog(operateType = CREATE)
    public CommonResult<Long> create(@Valid @RequestBody VesselSaveReqVO createReqVO) {
        return success(vesselService.createVessel(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新船舶")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> update(@Valid @RequestBody VesselSaveReqVO updateReqVO) {
        vesselService.updateVessel(updateReqVO);
        return success(true);
    }

    @PutMapping("/update-status")
    @Operation(summary = "启用/停用船舶")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> updateStatus(@Valid @RequestBody VesselUpdateStatusReqVO reqVO) {
        vesselService.updateVesselStatus(reqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除船舶")
    @Parameter(name = "id", required = true)
    @PreAuthorize("@ss.hasPermission('base:data:delete')")
    @ApiAccessLog(operateType = DELETE)
    public CommonResult<Boolean> delete(@RequestParam("id") Long id) {
        vesselService.deleteVessel(id);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得船舶详情")
    @Parameter(name = "id", required = true)
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<VesselRespVO> get(@RequestParam("id") Long id) {
        return success(vesselService.getVessel(id));
    }

    @GetMapping("/page")
    @Operation(summary = "获得船舶分页")
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<PageResult<VesselRespVO>> page(@Valid VesselPageReqVO pageReqVO) {
        return success(vesselService.getVesselPage(pageReqVO));
    }

    @GetMapping("/options")
    @Operation(summary = "获得船舶选项列表", description = "默认仅返回启用状态")
    public CommonResult<List<VesselRespVO>> options(@Valid VesselPageReqVO reqVO) {
        return success(vesselService.getVesselOptions(reqVO));
    }

    @GetMapping("/export")
    @Operation(summary = "导出船舶")
    @PreAuthorize("@ss.hasPermission('base:data:export')")
    @ApiAccessLog(operateType = EXPORT)
    public void export(@Valid VesselPageReqVO pageReqVO, HttpServletResponse response) throws IOException {
        ExcelUtils.write(response, "vessel.xls", "船舶", VesselRespVO.class,
                vesselService.getVesselExportList(pageReqVO));
    }

}
