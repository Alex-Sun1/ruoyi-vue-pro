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
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsSlotTemplateAddReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsSlotTemplateEditReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsSlotTemplateQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsSlotTemplateRespVO;
import cn.iocoder.yudao.module.yms.service.YmsSlotTemplateService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;

@Validated

@RestController
@RequestMapping("/yms/slot-template")
public class YmsSlotTemplateController  {

    @Resource
    private YmsSlotTemplateService slotTemplateService;

    @PreAuthorize("@ss.hasPermission('yms:slotTemplate:list')")
    @GetMapping("/list")
    public CommonResult<PageResult<YmsSlotTemplateRespVO>> list(YmsSlotTemplateQueryReqVO bo, PageParam pageParam) {
        return success(slotTemplateService.queryPageList(bo, pageParam));
    }

    @PreAuthorize("@ss.hasPermission('yms:slotTemplate:list')")
    @GetMapping("/enabled")
    public CommonResult<List<YmsSlotTemplateRespVO>> enabled(@RequestParam Long warehouseId,
                                               @RequestParam(required = false) String taskType) {
        return success(slotTemplateService.queryEnabledByWarehouse(warehouseId, taskType));
    }

    @PreAuthorize("@ss.hasPermission('yms:slotTemplate:query')")
    @GetMapping("/{id}")
    public CommonResult<YmsSlotTemplateRespVO> getInfo(@NotNull @PathVariable Long id) {
        return success(slotTemplateService.queryById(id));
    }

    @PreAuthorize("@ss.hasPermission('yms:slotTemplate:add')")
    @PostMapping
    public CommonResult<Boolean> add(@Valid @RequestBody YmsSlotTemplateAddReqVO bo) {
        return success(slotTemplateService.insertByBo(bo));
    }

    @PreAuthorize("@ss.hasPermission('yms:slotTemplate:edit')")
    @PutMapping
    public CommonResult<Boolean> edit(@Valid @RequestBody YmsSlotTemplateEditReqVO bo) {
        return success(slotTemplateService.updateByBo(bo));
    }

    @PreAuthorize("@ss.hasPermission('yms:slotTemplate:remove')")
    @DeleteMapping("/{ids}")
    public CommonResult<Boolean> remove(@NotEmpty @PathVariable Long[] ids) {
        return success(slotTemplateService.deleteByIds(Arrays.asList(ids)));
    }
}
