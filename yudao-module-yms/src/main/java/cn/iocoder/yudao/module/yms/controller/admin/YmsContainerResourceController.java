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
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsContainerResourceRespVO;
import cn.iocoder.yudao.module.yms.service.YmsContainerResourceService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

@Validated

@RestController
@RequestMapping("/yms/container")
public class YmsContainerResourceController  {

    @Resource
    private YmsContainerResourceService containerResourceService;

    /** 分页列表 */
    @PreAuthorize("@ss.hasPermission('yms:containerResource:list')")
    @GetMapping("/list")
    public CommonResult<PageResult<YmsContainerResourceRespVO>> list(YmsContainerResourceQueryReqVO bo, PageParam pageParam) {
        return success(containerResourceService.queryPageList(bo, pageParam));
    }

    /** 详情 */
    @PreAuthorize("@ss.hasPermission('yms:containerResource:query')")
    @GetMapping("/{id}")
    public CommonResult<YmsContainerResourceRespVO> getInfo(@NotNull(message = "主键不能为空") @PathVariable Long id) {
        return success(containerResourceService.queryById(id));
    }

    /** 编辑 */
    @PreAuthorize("@ss.hasPermission('yms:containerResource:edit')")
    @PutMapping
    public CommonResult<Boolean> edit(@Validated @RequestBody YmsContainerResourceEditReqVO bo) {
        return success(containerResourceService.updateByBo(bo));
    }

    /** 删除 */
    @PreAuthorize("@ss.hasPermission('yms:containerResource:remove')")
    @DeleteMapping("/{ids}")
    public CommonResult<Boolean> remove(@NotEmpty(message = "主键不能为空") @PathVariable Long[] ids) {
        return success(containerResourceService.deleteWithValidByIds(List.of(ids), true));
    }

    /** 导出 */
    @PreAuthorize("@ss.hasPermission('yms:containerResource:export')")
    @PostMapping("/export")
    public void export(YmsContainerResourceQueryReqVO bo, HttpServletResponse response) throws IOException {
        List<YmsContainerResourceRespVO> list = containerResourceService.queryList(bo);
        ExcelUtils.write(response, "container-resource.xls", "海柜资源", YmsContainerResourceRespVO.class, list);
    }

    // =================== 业务动作 ===================

    /** 分配堆场位 */
    @PreAuthorize("@ss.hasPermission('yms:containerResource:assignPosition')")
    @PostMapping("/{id}/assign-position")
    public CommonResult<Boolean> assignPosition(@PathVariable Long id, @RequestParam Long positionId) {
        return success(containerResourceService.assignPosition(id, positionId));
    }

    /** 标记已到仓 */
    @PreAuthorize("@ss.hasPermission('yms:gate:checkIn')")
    @PostMapping("/{id}/arrived")
    public CommonResult<Boolean> markArrived(@PathVariable Long id,
                               @RequestParam(required = false) String plateNo,
                               @RequestParam(required = false) String driverName,
                               @RequestParam(required = false) String driverPhone) {
        return success(containerResourceService.markArrived(id, plateNo, driverName, driverPhone));
    }

    /** 叫号 */
    @PreAuthorize("@ss.hasPermission('yms:containerResource:call')")
    @PostMapping("/{id}/call")
    public CommonResult<Boolean> callToDock(@PathVariable Long id, @RequestParam Long dockId) {
        return success(containerResourceService.callToDock(id, dockId));
    }

    /** 上口完成 */
    @PreAuthorize("@ss.hasAnyPermissions('yms:yard:assignDock', 'yms:yard:assign', 'yms:dispatch:assignDock')")
    @PostMapping("/{id}/on-dock")
    public CommonResult<Boolean> markOnDock(@PathVariable Long id,
                               @RequestParam Long dockId,
                               @RequestParam String dockCode) {
        return success(containerResourceService.markOnDock(id, dockId, dockCode));
    }

    /** 拆柜完成（WMS 回调） */
    @PostMapping("/{id}/devanned")
    public CommonResult<Boolean> markDevanned(@PathVariable Long id) {
        return success(containerResourceService.markDevanned(id));
    }

    /** 空柜待还 */
    @PreAuthorize("@ss.hasPermission('yms:dispatch:devanning')")
    @PostMapping("/{id}/empty-wait-return")
    public CommonResult<Boolean> markEmptyWaitReturn(@PathVariable Long id) {
        return success(containerResourceService.markEmptyWaitReturn(id));
    }

    /** 离场 */
    @PreAuthorize("@ss.hasPermission('yms:gate:checkout')")
    @PostMapping("/{id}/left-yard")
    public CommonResult<Boolean> markLeftYard(@PathVariable Long id) {
        return success(containerResourceService.markLeftYard(id));
    }

    /** 标记异常 */
    @PreAuthorize("@ss.hasPermission('yms:exception:handle')")
    @PostMapping("/{id}/exception")
    public CommonResult<Boolean> markException(@PathVariable Long id, @RequestParam String reason) {
        return success(containerResourceService.markException(id, reason));
    }
}
