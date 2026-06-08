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
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardPositionAddReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardPositionEditReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardPositionQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardPositionRespVO;
import cn.iocoder.yudao.module.yms.service.YmsYardPositionService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;

@Validated

@RestController
@RequestMapping("/yms/yard-position")
public class YmsYardPositionController  {

    @Resource
    private YmsYardPositionService yardPositionService;

    @PreAuthorize("@ss.hasPermission('yms:yardPosition:list')")
    @GetMapping("/list")
    public CommonResult<PageResult<YmsYardPositionRespVO>> list(YmsYardPositionQueryReqVO bo, PageParam pageParam) {
        return success(yardPositionService.queryPageList(bo, pageParam));
    }

    @PreAuthorize("@ss.hasPermission('yms:yardPosition:list')")
    @GetMapping("/zone/{zoneId}")
    public CommonResult<List<YmsYardPositionRespVO>> listByZone(@PathVariable Long zoneId) {
        return success(yardPositionService.queryListByZone(zoneId));
    }

    @PreAuthorize("@ss.hasPermission('yms:yardPosition:list')")
    @GetMapping("/free")
    public CommonResult<List<YmsYardPositionRespVO>> freeList(@RequestParam Long warehouseId,
                                               @RequestParam(required = false) String positionType) {
        return success(yardPositionService.queryFreeList(warehouseId, positionType));
    }

    @PreAuthorize("@ss.hasPermission('yms:yardPosition:query')")
    @GetMapping("/{id}")
    public CommonResult<YmsYardPositionRespVO> getInfo(@NotNull @PathVariable Long id) {
        return success(yardPositionService.queryById(id));
    }

    @PreAuthorize("@ss.hasPermission('yms:yardPosition:add')")
    @PostMapping
    public CommonResult<Boolean> add(@Valid @RequestBody YmsYardPositionAddReqVO bo) {
        return success(yardPositionService.insertByBo(bo));
    }

    @PreAuthorize("@ss.hasPermission('yms:yardPosition:edit')")
    @PutMapping
    public CommonResult<Boolean> edit(@Valid @RequestBody YmsYardPositionEditReqVO bo) {
        return success(yardPositionService.updateByBo(bo));
    }

    @PreAuthorize("@ss.hasPermission('yms:yardPosition:remove')")
    @DeleteMapping("/{ids}")
    public CommonResult<Boolean> remove(@NotEmpty @PathVariable Long[] ids) {
        return success(yardPositionService.deleteByIds(Arrays.asList(ids)));
    }

    @PreAuthorize("@ss.hasPermission('yms:yardPosition:edit')")
    @PostMapping("/{id}/release")
    public CommonResult<Boolean> release(@PathVariable Long id) {
        return success(yardPositionService.release(id));
    }

    @PreAuthorize("@ss.hasPermission('yms:yardPosition:edit')")
    @PostMapping("/{id}/disable")
    public CommonResult<Boolean> disable(@PathVariable Long id) {
        return success(yardPositionService.disable(id));
    }

    @PreAuthorize("@ss.hasPermission('yms:yardPosition:edit')")
    @PostMapping("/{id}/enable")
    public CommonResult<Boolean> enable(@PathVariable Long id) {
        return success(yardPositionService.enable(id));
    }
}
