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
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsBlacklistAddReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsBlacklistEditReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsBlacklistQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsBlacklistRespVO;
import cn.iocoder.yudao.module.yms.service.YmsBlacklistService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;

@Validated

@RestController
@RequestMapping("/yms/blacklist")
public class YmsBlacklistController  {

    @Resource
    private YmsBlacklistService blacklistService;

    @PreAuthorize("@ss.hasPermission('yms:blacklist:list')")
    @GetMapping("/list")
    public CommonResult<PageResult<YmsBlacklistRespVO>> list(YmsBlacklistQueryReqVO bo, PageParam pageParam) {
        return success(blacklistService.queryPageList(bo, pageParam));
    }

    @PreAuthorize("@ss.hasPermission('yms:blacklist:query')")
    @GetMapping("/{id}")
    public CommonResult<YmsBlacklistRespVO> getInfo(@NotNull @PathVariable Long id) {
        return success(blacklistService.queryById(id));
    }

    @PreAuthorize("@ss.hasPermission('yms:blacklist:add')")
    @PostMapping
    public CommonResult<Boolean> add(@Valid @RequestBody YmsBlacklistAddReqVO bo) {
        return success(blacklistService.insertByBo(bo));
    }

    @PreAuthorize("@ss.hasPermission('yms:blacklist:edit')")
    @PutMapping
    public CommonResult<Boolean> edit(@Valid @RequestBody YmsBlacklistEditReqVO bo) {
        return success(blacklistService.updateByBo(bo));
    }

    @PreAuthorize("@ss.hasPermission('yms:blacklist:remove')")
    @DeleteMapping("/{ids}")
    public CommonResult<Boolean> remove(@NotEmpty @PathVariable Long[] ids) {
        return success(blacklistService.removeByIds(Arrays.asList(ids)));
    }

    /** 检查车牌或手机号是否在黑名单中 */
    @PreAuthorize("@ss.hasPermission('yms:blacklist:list')")
    @GetMapping("/check")
    public CommonResult<Boolean> check(@RequestParam String targetType, @RequestParam String targetValue) {
        return success(blacklistService.isBlacklisted(targetType, targetValue));
    }
}
