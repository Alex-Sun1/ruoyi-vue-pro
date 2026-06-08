package cn.iocoder.yudao.module.yms.controller.admin;

import org.springframework.security.access.prepost.PreAuthorize;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardInventoryScanReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardInventoryTaskCreateReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardInventoryTaskQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardInventoryItemRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardInventoryTaskRespVO;
import cn.iocoder.yudao.module.yms.service.YmsYardInventoryService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@Validated

@RestController
@RequestMapping("/yms/yard-inventory")
public class YmsYardInventoryController  {

    @Resource
    private YmsYardInventoryService yardInventoryService;

    @PreAuthorize("@ss.hasPermission('yms:inventory:list')")
    @GetMapping("/list")
    public CommonResult<PageResult<YmsYardInventoryTaskRespVO>> list(YmsYardInventoryTaskQueryReqVO bo, PageParam pageParam) {
        return success(yardInventoryService.queryPageList(bo, pageParam));
    }

    @PreAuthorize("@ss.hasPermission('yms:inventory:query')")
    @GetMapping("/{id}")
    public CommonResult<YmsYardInventoryTaskRespVO> getInfo(@NotNull @PathVariable Long id) {
        return success(yardInventoryService.queryById(id));
    }

    @PreAuthorize("@ss.hasPermission('yms:inventory:add')")
    @PostMapping
    public CommonResult<YmsYardInventoryTaskRespVO> create(@Valid @RequestBody YmsYardInventoryTaskCreateReqVO bo) {
        return success(yardInventoryService.create(bo));
    }

    @PreAuthorize("@ss.hasPermission('yms:inventory:execute')")
    @PostMapping("/{id}/start")
    public CommonResult<Boolean> start(@PathVariable Long id) {
        return success(yardInventoryService.start(id));
    }

    @PreAuthorize("@ss.hasPermission('yms:inventory:execute')")
    @PostMapping("/scan")
    public CommonResult<YmsYardInventoryItemRespVO> scan(@Valid @RequestBody YmsYardInventoryScanReqVO bo) {
        return success(yardInventoryService.scan(bo));
    }

    @PreAuthorize("@ss.hasPermission('yms:inventory:execute')")
    @PostMapping("/{id}/complete")
    public CommonResult<YmsYardInventoryTaskRespVO> complete(@PathVariable Long id) {
        return success(yardInventoryService.complete(id));
    }

    @PreAuthorize("@ss.hasPermission('yms:inventory:execute')")
    @PostMapping("/{id}/confirm-diff")
    public CommonResult<Boolean> confirmDiff(@PathVariable Long id) {
        return success(yardInventoryService.confirmDiff(id));
    }
}
