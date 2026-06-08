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
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardZoneAddReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardZoneEditReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardZoneQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardZoneRespVO;
import cn.iocoder.yudao.module.yms.service.YmsYardZoneService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;

@Validated

@RestController
@RequestMapping("/yms/yard-zone")
public class YmsYardZoneController  {

    @Resource
    private YmsYardZoneService yardZoneService;

    @PreAuthorize("@ss.hasPermission('yms:yardZone:list')")
    @GetMapping("/list")
    public CommonResult<PageResult<YmsYardZoneRespVO>> list(YmsYardZoneQueryReqVO bo) {
        return success(yardZoneService.queryPageList(bo));
    }

    @PreAuthorize("@ss.hasPermission('yms:yardZone:list')")
    @GetMapping("/warehouse/{warehouseId}")
    public CommonResult<List<YmsYardZoneRespVO>> listByWarehouse(@PathVariable Long warehouseId) {
        return success(yardZoneService.queryListByWarehouse(warehouseId));
    }

    @PreAuthorize("@ss.hasPermission('yms:yardZone:query')")
    @GetMapping("/{id}")
    public CommonResult<YmsYardZoneRespVO> getInfo(@NotNull @PathVariable Long id) {
        return success(yardZoneService.queryById(id));
    }

    @PreAuthorize("@ss.hasPermission('yms:yardZone:add')")
    @PostMapping
    public CommonResult<Boolean> add(@Valid @RequestBody YmsYardZoneAddReqVO bo) {
        return success(yardZoneService.insertByBo(bo));
    }

    @PreAuthorize("@ss.hasPermission('yms:yardZone:edit')")
    @PutMapping
    public CommonResult<Boolean> edit(@Valid @RequestBody YmsYardZoneEditReqVO bo) {
        return success(yardZoneService.updateByBo(bo));
    }

    @PreAuthorize("@ss.hasPermission('yms:yardZone:remove')")
    @DeleteMapping("/{ids}")
    public CommonResult<Boolean> remove(@NotEmpty @PathVariable Long[] ids) {
        return success(yardZoneService.deleteByIds(Arrays.asList(ids)));
    }
}
