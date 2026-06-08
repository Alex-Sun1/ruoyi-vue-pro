package cn.iocoder.yudao.module.yms.controller.admin;

import org.springframework.security.access.prepost.PreAuthorize;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsInternalTaskAssignReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsInternalTaskCompleteReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsInternalTaskCreateReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsInternalTaskQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsInternalTaskBoardRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsInternalTaskRespVO;
import cn.iocoder.yudao.module.yms.service.YmsInternalTaskService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Validated

@RestController
@RequestMapping("/yms/internal-task")
public class YmsInternalTaskController  {

    @Resource
    private YmsInternalTaskService internalTaskService;

    @PreAuthorize("@ss.hasPermission('yms:internalTask:list')")
    @GetMapping("/list")
    public CommonResult<PageResult<YmsInternalTaskRespVO>> list(YmsInternalTaskQueryReqVO bo, PageParam pageParam) {
        return success(internalTaskService.queryPageList(bo, pageParam));
    }

    @PreAuthorize("@ss.hasPermission('yms:internalTask:list')")
    @GetMapping("/board")
    public CommonResult<List<YmsInternalTaskBoardRespVO>> board(
            @RequestParam(required = false) Long warehouseId,
            @RequestParam(required = false) String internalTaskType) {
        return success(internalTaskService.queryBoard(warehouseId, internalTaskType));
    }

    @PreAuthorize("@ss.hasPermission('yms:internalTask:query')")
    @GetMapping("/{id}")
    public CommonResult<YmsInternalTaskRespVO> getInfo(@NotNull @PathVariable Long id) {
        return success(internalTaskService.queryById(id));
    }

    @PreAuthorize("@ss.hasPermission('yms:internalTask:add')")
    @PostMapping
    public CommonResult<YmsInternalTaskRespVO> create(@Valid @RequestBody YmsInternalTaskCreateReqVO bo) {
        return success(internalTaskService.createByBo(bo));
    }

    @PreAuthorize("@ss.hasPermission('yms:internalTask:assign')")
    @PostMapping("/assign")
    public CommonResult<Boolean> assign(@Valid @RequestBody YmsInternalTaskAssignReqVO bo) {
        return success(internalTaskService.assign(bo));
    }

    @PreAuthorize("@ss.hasPermission('yms:internalTask:operate')")
    @PostMapping("/{id}/accept")
    public CommonResult<Boolean> accept(@PathVariable Long id) {
        return success(internalTaskService.accept(id));
    }

    @PreAuthorize("@ss.hasPermission('yms:internalTask:operate')")
    @PostMapping("/{id}/start")
    public CommonResult<Boolean> start(@PathVariable Long id) {
        return success(internalTaskService.start(id));
    }

    @PreAuthorize("@ss.hasPermission('yms:internalTask:complete')")
    @PostMapping("/{id}/complete")
    public CommonResult<Boolean> complete(@PathVariable Long id,
                            @RequestBody(required = false) YmsInternalTaskCompleteReqVO bo) {
        return success(internalTaskService.complete(id, bo));
    }

    @PreAuthorize("@ss.hasPermission('yms:internalTask:operate')")
    @PostMapping("/{id}/fail")
    public CommonResult<Boolean> fail(@PathVariable Long id, @RequestParam String reason) {
        return success(internalTaskService.fail(id, reason));
    }

    @PreAuthorize("@ss.hasPermission('yms:internalTask:cancel')")
    @PostMapping("/{id}/cancel")
    public CommonResult<Boolean> cancel(@PathVariable Long id,
                          @RequestParam(required = false) String reason) {
        return success(internalTaskService.cancel(id, reason));
    }
}
