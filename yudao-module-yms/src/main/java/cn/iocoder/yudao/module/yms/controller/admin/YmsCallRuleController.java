package cn.iocoder.yudao.module.yms.controller.admin;

import org.springframework.security.access.prepost.PreAuthorize;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCallRuleAddReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCallRuleEditReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCallRuleQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCallRuleRespVO;
import cn.iocoder.yudao.module.yms.service.YmsCallRuleService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;

@Validated

@RestController
@RequestMapping("/yms/call-rule")
public class YmsCallRuleController  {

    @Resource
    private YmsCallRuleService callRuleService;

    @PreAuthorize("@ss.hasPermission('yms:callRule:list')")
    @GetMapping("/list")
    public CommonResult<PageResult<YmsCallRuleRespVO>> list(YmsCallRuleQueryReqVO bo, PageParam pageParam) {
        return success(callRuleService.queryPageList(bo, pageParam));
    }

    @PreAuthorize("@ss.hasPermission('yms:callRule:query')")
    @GetMapping("/{id}")
    public CommonResult<YmsCallRuleRespVO> getInfo(@NotNull @PathVariable Long id) {
        return success(callRuleService.queryById(id));
    }

    @PreAuthorize("@ss.hasPermission('yms:callRule:add')")
    @PostMapping
    public CommonResult<Boolean> add(@Valid @RequestBody YmsCallRuleAddReqVO bo) {
        return success(callRuleService.insertByBo(bo));
    }

    @PreAuthorize("@ss.hasPermission('yms:callRule:edit')")
    @PutMapping
    public CommonResult<Boolean> edit(@Valid @RequestBody YmsCallRuleEditReqVO bo) {
        return success(callRuleService.updateByBo(bo));
    }

    @PreAuthorize("@ss.hasPermission('yms:callRule:remove')")
    @DeleteMapping("/{ids}")
    public CommonResult<Boolean> remove(@NotEmpty @PathVariable Long[] ids) {
        return success(callRuleService.deleteByIds(Arrays.asList(ids)));
    }

    @PreAuthorize("@ss.hasPermission('yms:callRule:toggle')")
    @PostMapping("/{id}/toggle")
    public CommonResult<Boolean> toggle(@NotNull @PathVariable Long id) {
        return success(callRuleService.toggle(id));
    }
}
