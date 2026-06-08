package cn.iocoder.yudao.module.wms.controller.admin.zone;

import cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.wms.controller.admin.zone.vo.WmsZonePageReqVO;
import cn.iocoder.yudao.module.wms.controller.admin.zone.vo.WmsZoneRespVO;
import cn.iocoder.yudao.module.wms.controller.admin.zone.vo.WmsZoneSaveReqVO;
import cn.iocoder.yudao.module.wms.service.zone.WmsZoneService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

import static cn.iocoder.yudao.framework.apilog.core.enums.OperateTypeEnum.*;
import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - WMS 库区")
@RestController
@RequestMapping("/wms/zone")
@Validated
public class WmsZoneController {

    @Resource
    private WmsZoneService zoneService;

    @GetMapping("/page")
    @Operation(summary = "库区分页")
    @PreAuthorize("@ss.hasPermission('wms:zone:list')")
    public CommonResult<PageResult<WmsZoneRespVO>> getPage(@Valid WmsZonePageReqVO pageReqVO) {
        return success(zoneService.getZonePage(pageReqVO));
    }

    @GetMapping("/options")
    @Operation(summary = "库区下拉")
    @PreAuthorize("@ss.hasPermission('wms:zone:list')")
    public CommonResult<List<WmsZoneRespVO>> getOptions(WmsZonePageReqVO pageReqVO) {
        pageReqVO.setPageSize(PageParam.PAGE_SIZE_NONE);
        return success(zoneService.getZoneList(pageReqVO));
    }

    @GetMapping("/get")
    @Operation(summary = "库区详情")
    @Parameter(name = "id", required = true)
    @PreAuthorize("@ss.hasPermission('wms:zone:query')")
    public CommonResult<WmsZoneRespVO> get(@RequestParam("id") Long id) {
        return success(zoneService.getZone(id));
    }

    @PostMapping("/create")
    @Operation(summary = "创建库区")
    @PreAuthorize("@ss.hasPermission('wms:zone:add')")
    @ApiAccessLog(operateType = CREATE)
    public CommonResult<Long> create(@Valid @RequestBody WmsZoneSaveReqVO createReqVO) {
        return success(zoneService.createZone(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新库区")
    @PreAuthorize("@ss.hasPermission('wms:zone:edit')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> update(@Valid @RequestBody WmsZoneSaveReqVO updateReqVO) {
        zoneService.updateZone(updateReqVO);
        return success(true);
    }

    @PutMapping("/change-status")
    @Operation(summary = "库区启停")
    @PreAuthorize("@ss.hasPermission('wms:zone:changeStatus')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> changeStatus(@RequestBody Map<String, Object> body) {
        Long id = body.get("id") == null ? null : Long.valueOf(body.get("id").toString());
        String status = body.get("status") == null ? null : body.get("status").toString();
        zoneService.changeZoneStatus(id, status);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除库区")
    @PreAuthorize("@ss.hasPermission('wms:zone:remove')")
    @ApiAccessLog(operateType = DELETE)
    public CommonResult<Boolean> delete(@RequestParam("ids") List<Long> ids) {
        zoneService.deleteZoneList(ids);
        return success(true);
    }

}
