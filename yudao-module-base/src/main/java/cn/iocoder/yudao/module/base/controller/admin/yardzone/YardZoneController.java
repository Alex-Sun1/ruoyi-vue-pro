package cn.iocoder.yudao.module.base.controller.admin.yardzone;

import cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.controller.admin.yardzone.vo.*;
import cn.iocoder.yudao.module.base.service.yardzone.YardZoneService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static cn.iocoder.yudao.framework.apilog.core.enums.OperateTypeEnum.*;
import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - 堆场分区")
@RestController
@RequestMapping("/yard/zone")
@Validated
public class YardZoneController {

    @Resource
    private YardZoneService yardZoneService;

    @PostMapping("/create")
    @Operation(summary = "创建堆场分区")
    @PreAuthorize("@ss.hasPermission('yard:zone:add')")
    @ApiAccessLog(operateType = CREATE)
    public CommonResult<Long> create(@Valid @RequestBody YardZoneSaveReqVO createReqVO) {
        return success(yardZoneService.createYardZone(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新堆场分区")
    @PreAuthorize("@ss.hasPermission('yard:zone:edit')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> update(@Valid @RequestBody YardZoneSaveReqVO updateReqVO) {
        yardZoneService.updateYardZone(updateReqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除堆场分区")
    @Parameter(name = "id", required = true)
    @PreAuthorize("@ss.hasPermission('yard:zone:remove')")
    @ApiAccessLog(operateType = DELETE)
    public CommonResult<Boolean> delete(@RequestParam("id") Long id) {
        yardZoneService.deleteYardZone(id);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得堆场分区详情")
    @Parameter(name = "id", required = true)
    @PreAuthorize("@ss.hasPermission('yard:zone:list')")
    public CommonResult<YardZoneRespVO> get(@RequestParam("id") Long id) {
        return success(yardZoneService.getYardZone(id));
    }

    @GetMapping("/page")
    @Operation(summary = "获得堆场分区分页")
    @PreAuthorize("@ss.hasPermission('yard:zone:list')")
    public CommonResult<PageResult<YardZoneRespVO>> page(@Valid YardZonePageReqVO pageReqVO) {
        return success(yardZoneService.getYardZonePage(pageReqVO));
    }

    @GetMapping("/list-by-warehouse")
    @Operation(summary = "按仓库获得堆场分区列表")
    @Parameter(name = "warehouseId", required = true)
    @PreAuthorize("@ss.hasPermission('yard:zone:list')")
    public CommonResult<List<YardZoneRespVO>> listByWarehouse(@RequestParam("warehouseId") Long warehouseId) {
        return success(yardZoneService.getYardZoneListByWarehouse(warehouseId));
    }

}
