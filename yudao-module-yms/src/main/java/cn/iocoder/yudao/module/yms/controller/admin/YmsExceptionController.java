package cn.iocoder.yudao.module.yms.controller.admin;

import org.springframework.security.access.prepost.PreAuthorize;
import jakarta.validation.constraints.NotNull;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsExceptionQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsExceptionRespVO;
import cn.iocoder.yudao.module.yms.service.YmsExceptionService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@Validated

@RestController
@RequestMapping("/yms/exception")
public class YmsExceptionController  {

    @Resource
    private YmsExceptionService exceptionService;

    /** 异常分页列表 */
    @PreAuthorize("@ss.hasPermission('yms:exception:list')")
    @GetMapping("/list")
    public CommonResult<PageResult<YmsExceptionRespVO>> list(YmsExceptionQueryReqVO bo, PageParam pageParam) {
        return success(exceptionService.queryPageList(bo, pageParam));
    }

    /** 处理/解除异常 */
    @PreAuthorize("@ss.hasPermission('yms:exception:handle')")
    @PostMapping("/{sourceType}/{refId}/resolve")
    public CommonResult<Boolean> resolve(@NotNull @PathVariable String sourceType,
                           @NotNull @PathVariable Long refId,
                           @RequestParam(required = false) String remark) {
        return success(exceptionService.resolve(sourceType, refId, remark));
    }
}
