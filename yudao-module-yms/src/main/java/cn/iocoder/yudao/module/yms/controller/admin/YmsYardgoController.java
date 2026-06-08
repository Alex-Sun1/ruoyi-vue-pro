package cn.iocoder.yudao.module.yms.controller.admin;

import org.springframework.security.access.prepost.PreAuthorize;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsRobotCallbackReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardgoTaskQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardgoTaskRespVO;
import cn.iocoder.yudao.module.yms.service.YmsYardgoService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@Validated

@RestController
@RequestMapping("/yms/yardgo")
public class YmsYardgoController  {

    @Resource
    private YmsYardgoService yardgoService;

    @PreAuthorize("@ss.hasPermission('yms:yardgo:list')")
    @GetMapping("/list")
    public CommonResult<PageResult<YmsYardgoTaskRespVO>> list(YmsYardgoTaskQueryReqVO bo, PageParam pageParam) {
        return success(yardgoService.queryPageList(bo, pageParam));
    }

    @PreAuthorize("@ss.hasPermission('yms:yardgo:query')")
    @GetMapping("/{id}")
    public CommonResult<YmsYardgoTaskRespVO> getInfo(@NotNull @PathVariable Long id) {
        return success(yardgoService.queryById(id));
    }

    /** 从园区任务创建 YardGo 机器人任务 */
    @PreAuthorize("@ss.hasPermission('yms:yardgo:create')")
    @PostMapping("/from-yard-task/{yardTaskId}")
    public CommonResult<YmsYardgoTaskRespVO> createFromYardTask(@NotNull @PathVariable Long yardTaskId) {
        return success(yardgoService.createFromYardTask(yardTaskId));
    }

    /** 机器人状态回调（供机器人系统回调，无需权限控制） */
    @PostMapping("/robot-callback")
    public CommonResult<Boolean> robotCallback(@Valid @RequestBody YmsRobotCallbackReqVO bo) {
        return success(yardgoService.robotCallback(bo));
    }

    /** 取消机器人任务 */
    @PreAuthorize("@ss.hasPermission('yms:yardgo:create')")
    @PostMapping("/{id}/cancel")
    public CommonResult<Boolean> cancel(@NotNull @PathVariable Long id) {
        return success(yardgoService.cancelRobotTask(id));
    }
}
