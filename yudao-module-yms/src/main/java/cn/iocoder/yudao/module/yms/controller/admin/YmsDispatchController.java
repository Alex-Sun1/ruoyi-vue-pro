package cn.iocoder.yudao.module.yms.controller.admin;

import org.springframework.security.access.prepost.PreAuthorize;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.controller.admin.vo.*;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsDockBoardRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsDispatchStatsRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardTaskLogRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardTaskRespVO;
import cn.iocoder.yudao.module.yms.service.YmsDispatchService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Validated

@RestController
@RequestMapping("/yms/dispatch")
public class YmsDispatchController  {

    @Resource
    private YmsDispatchService dispatchService;

    /** 园区任务分页列表 */
    @PreAuthorize("@ss.hasPermission('yms:yard:view')")
    @GetMapping("/list")
    public CommonResult<PageResult<YmsYardTaskRespVO>> list(YmsYardTaskQueryReqVO bo, PageParam pageParam) {
        return success(dispatchService.queryPageList(bo, pageParam));
    }

    /** 任务详情 */
    @PreAuthorize("@ss.hasPermission('yms:yard:view')")
    @GetMapping("/{id}")
    public CommonResult<YmsYardTaskRespVO> getInfo(@NotNull @PathVariable Long id) {
        return success(dispatchService.queryById(id));
    }

    /** Dock看板 */
    @PreAuthorize("@ss.hasPermission('yms:yard:view')")
    @GetMapping("/dock-board")
    public CommonResult<List<YmsDockBoardRespVO>> dockBoard(
            @RequestParam(required = false) Long warehouseId,
            @RequestParam(required = false) String taskGroup) {
        return success(dispatchService.queryDockBoard(warehouseId, taskGroup));
    }

    /** 顶部统计 */
    @PreAuthorize("@ss.hasPermission('yms:yard:view')")
    @GetMapping("/stats")
    public CommonResult<YmsDispatchStatsRespVO> stats(
            @RequestParam(required = false) Long warehouseId,
            @RequestParam(required = false) String taskGroup) {
        return success(dispatchService.queryStats(warehouseId, taskGroup));
    }

    /** OMS/TMS推送任务（幂等） */
    @PreAuthorize("@ss.hasPermission('yms:yard:push')")
    @PostMapping("/push")
    public CommonResult<YmsYardTaskRespVO> push(@Valid @RequestBody YmsPushTaskReqVO bo) {
        return success(dispatchService.pushTask(bo));
    }

    /** 手动新建任务 */
    @PreAuthorize("@ss.hasPermission('yms:yard:create')")
    @PostMapping
    public CommonResult<YmsYardTaskRespVO> create(@Valid @RequestBody YmsYardTaskCreateReqVO bo) {
        return success(dispatchService.createTask(bo));
    }

    /** 签到 */
    @PreAuthorize("@ss.hasPermission('yms:yard:checkin')")
    @PostMapping("/{id}/check-in")
    public CommonResult<Boolean> checkIn(@NotNull @PathVariable Long id) {
        return success(dispatchService.checkIn(id));
    }

    /** 分配/取消Dock */
    @PreAuthorize("@ss.hasPermission('yms:yard:assignDock')")
    @PostMapping("/assign-dock")
    public CommonResult<Boolean> assignDock(@Valid @RequestBody YmsAssignDockReqVO bo) {
        return success(dispatchService.assignDock(bo));
    }

    /** 开始作业 */
    @PreAuthorize("@ss.hasPermission('yms:yard:start')")
    @PostMapping("/{id}/start")
    public CommonResult<Boolean> start(@NotNull @PathVariable Long id) {
        return success(dispatchService.startDockWork(id));
    }

    /** 暂停作业 */
    @PreAuthorize("@ss.hasPermission('yms:yard:start')")
    @PostMapping("/{id}/pause")
    public CommonResult<Boolean> pause(@NotNull @PathVariable Long id) {
        return success(dispatchService.pauseWork(id));
    }

    /** 恢复作业 */
    @PreAuthorize("@ss.hasPermission('yms:yard:start')")
    @PostMapping("/{id}/resume")
    public CommonResult<Boolean> resume(@NotNull @PathVariable Long id) {
        return success(dispatchService.resumeWork(id));
    }

    /** 完成作业（可附带下口目标位置，触发生成下口内场任务） */
    @PreAuthorize("@ss.hasPermission('yms:yard:finish')")
    @PostMapping("/{id}/finish")
    public CommonResult<Boolean> finish(@NotNull @PathVariable Long id,
                          @RequestBody(required = false) YmsFinishWorkReqVO bo) {
        return success(dispatchService.finishDockWork(id, bo));
    }

    /** 调整优先级 */
    @PreAuthorize("@ss.hasPermission('yms:yard:priority')")
    @PostMapping("/priority")
    public CommonResult<Boolean> updatePriority(@Valid @RequestBody YmsUpdatePriorityReqVO bo) {
        return success(dispatchService.updatePriority(bo));
    }

    /** WMS备货状态回写 */
    @PreAuthorize("@ss.hasPermission('yms:yard:wmsSync')")
    @PostMapping("/wms-ready")
    public CommonResult<Boolean> syncWmsReady(@Valid @RequestBody YmsSyncWmsReadyReqVO bo) {
        return success(dispatchService.syncWmsReady(bo));
    }

    /** 放行 */
    @PreAuthorize("@ss.hasPermission('yms:yard:release')")
    @PostMapping("/{id}/release")
    public CommonResult<Boolean> release(@NotNull @PathVariable Long id) {
        return success(dispatchService.release(id));
    }

    /** 离园 */
    @PreAuthorize("@ss.hasPermission('yms:yard:release')")
    @PostMapping("/{id}/leave")
    public CommonResult<Boolean> leave(@NotNull @PathVariable Long id) {
        return success(dispatchService.leaveYard(id));
    }

    /** 标记异常 */
    @PreAuthorize("@ss.hasPermission('yms:yard:exception')")
    @PostMapping("/{id}/exception")
    public CommonResult<Boolean> markException(@NotNull @PathVariable Long id,
                                  @RequestParam String reason) {
        return success(dispatchService.markException(id, reason));
    }

    /** 解除异常 */
    @PreAuthorize("@ss.hasPermission('yms:yard:exception')")
    @PostMapping("/{id}/clear-exception")
    public CommonResult<Boolean> clearException(@NotNull @PathVariable Long id) {
        return success(dispatchService.clearException(id));
    }

    /** 取消任务 */
    @PreAuthorize("@ss.hasPermission('yms:yard:create')")
    @PostMapping("/{id}/cancel")
    public CommonResult<Boolean> cancel(@NotNull @PathVariable Long id,
                           @RequestParam(required = false) String reason) {
        return success(dispatchService.cancelTask(id, reason));
    }

    /** 操作日志 */
    @PreAuthorize("@ss.hasPermission('yms:yard:view')")
    @GetMapping("/{id}/logs")
    public CommonResult<List<YmsYardTaskLogRespVO>> logs(@NotNull @PathVariable Long id) {
        return success(dispatchService.queryLogs(id));
    }
}
