package cn.iocoder.yudao.module.yms.controller.admin;

import org.springframework.security.access.prepost.PreAuthorize;
import cn.iocoder.yudao.framework.excel.core.util.ExcelUtils;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.controller.admin.vo.*;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsTrailerResourceRespVO;
import cn.iocoder.yudao.module.yms.service.YmsTrailerResourceService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

@Validated

@RestController
@RequestMapping("/yms/trailer")
public class YmsTrailerResourceController  {

    @Resource
    private YmsTrailerResourceService trailerResourceService;

    @PreAuthorize("@ss.hasPermission('yms:trailerResource:list')")
    @GetMapping("/list")
    public CommonResult<PageResult<YmsTrailerResourceRespVO>> list(YmsTrailerResourceQueryReqVO bo, PageParam pageParam) {
        return success(trailerResourceService.queryPageList(bo, pageParam));
    }

    @PreAuthorize("@ss.hasPermission('yms:trailerResource:query')")
    @GetMapping("/{id}")
    public CommonResult<YmsTrailerResourceRespVO> getInfo(@NotNull(message = "主键不能为空") @PathVariable Long id) {
        return success(trailerResourceService.queryById(id));
    }

    @PreAuthorize("@ss.hasPermission('yms:trailerResource:edit')")
    @PutMapping
    public CommonResult<Boolean> edit(@Validated @RequestBody YmsTrailerResourceEditReqVO bo) {
        return success(trailerResourceService.updateByBo(bo));
    }

    @PreAuthorize("@ss.hasPermission('yms:trailerResource:remove')")
    @DeleteMapping("/{ids}")
    public CommonResult<Boolean> remove(@NotEmpty(message = "主键不能为空") @PathVariable Long[] ids) {
        return success(trailerResourceService.deleteWithValidByIds(List.of(ids), true));
    }

    @PreAuthorize("@ss.hasPermission('yms:trailerResource:export')")
    @PostMapping("/export")
    public void export(YmsTrailerResourceQueryReqVO bo, HttpServletResponse response) throws IOException {
        List<YmsTrailerResourceRespVO> list = trailerResourceService.queryList(bo);
        ExcelUtils.write(response, "trailer-resource.xls", "车厢资源", YmsTrailerResourceRespVO.class, list);
    }

    @PreAuthorize("@ss.hasPermission('yms:trailerResource:assignPosition')")
    @PostMapping("/{id}/assign-position")
    public CommonResult<Boolean> assignPosition(@PathVariable Long id, @RequestParam Long positionId) {
        return success(trailerResourceService.assignPosition(id, positionId));
    }

    @PreAuthorize("@ss.hasPermission('yms:gate:checkIn')")
    @PostMapping("/{id}/arrived")
    public CommonResult<Boolean> markArrived(@PathVariable Long id) {
        return success(trailerResourceService.markArrived(id));
    }

    @PreAuthorize("@ss.hasPermission('yms:trailerResource:edit')")
    @PostMapping("/{id}/wms-ready")
    public CommonResult<Boolean> markWmsReady(@PathVariable Long id) {
        return success(trailerResourceService.markWmsReady(id));
    }

    @PreAuthorize("@ss.hasPermission('yms:trailerResource:call')")
    @PostMapping("/{id}/call")
    public CommonResult<Boolean> callToDock(@PathVariable Long id, @RequestParam Long dockId) {
        return success(trailerResourceService.callToDock(id, dockId));
    }

    @PreAuthorize("@ss.hasPermission('yms:dispatch:assignDock')")
    @PostMapping("/{id}/on-dock")
    public CommonResult<Boolean> markOnDock(@PathVariable Long id,
                              @RequestParam Long dockId,
                              @RequestParam String dockCode) {
        return success(trailerResourceService.markOnDock(id, dockId, dockCode));
    }
    @PostMapping("/{id}/loaded")
    public CommonResult<Boolean> markLoaded(@PathVariable Long id) {
        return success(trailerResourceService.markLoaded(id));
    }

    @PreAuthorize("@ss.hasPermission('yms:gate:checkout')")
    @PostMapping("/{id}/left-yard")
    public CommonResult<Boolean> markLeftYard(@PathVariable Long id) {
        return success(trailerResourceService.markLeftYard(id));
    }

    @PreAuthorize("@ss.hasPermission('yms:exception:handle')")
    @PostMapping("/{id}/exception")
    public CommonResult<Boolean> markException(@PathVariable Long id, @RequestParam String reason) {
        return success(trailerResourceService.markException(id, reason));
    }
}
