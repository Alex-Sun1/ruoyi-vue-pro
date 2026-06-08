package cn.iocoder.yudao.module.base.controller.admin.feeitem;

import cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.controller.admin.feeitem.vo.*;
import cn.iocoder.yudao.module.base.service.feeitem.FeeItemService;
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

@Tag(name = "管理后台 - 费项")
@RestController
@RequestMapping("/base/fee-item")
@Validated
public class FeeItemController {

    @Resource
    private FeeItemService feeItemService;

    @PostMapping("/create")
    @Operation(summary = "创建费项")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    @ApiAccessLog(operateType = CREATE)
    public CommonResult<Long> create(@Valid @RequestBody FeeItemSaveReqVO createReqVO) {
        return success(feeItemService.createFeeItem(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新费项")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> update(@Valid @RequestBody FeeItemSaveReqVO updateReqVO) {
        feeItemService.updateFeeItem(updateReqVO);
        return success(true);
    }

    @PutMapping("/update-status")
    @Operation(summary = "启用/停用费项")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> updateStatus(@Valid @RequestBody FeeItemUpdateStatusReqVO reqVO) {
        feeItemService.updateFeeItemStatus(reqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除费项", description = "系统内置费项不可删除")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('base:data:delete')")
    @ApiAccessLog(operateType = DELETE)
    public CommonResult<Boolean> delete(@RequestParam("id") Long id) {
        feeItemService.deleteFeeItem(id);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得费项详情")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<FeeItemRespVO> get(@RequestParam("id") Long id) {
        return success(feeItemService.getFeeItem(id));
    }

    @GetMapping("/page")
    @Operation(summary = "获得费项分页")
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<PageResult<FeeItemRespVO>> getPage(@Valid FeeItemPageReqVO pageReqVO) {
        return success(feeItemService.getFeeItemPage(pageReqVO));
    }

    @GetMapping("/simple-list")
    @Operation(summary = "获得费项精简列表", description = "默认 status=0（正常），按 sort_order 排序")
    public CommonResult<List<FeeItemRespVO>> getSimpleList(
            @RequestParam(value = "status", required = false) Integer status,
            @RequestParam(value = "feeCategory", required = false) String feeCategory) {
        Integer queryStatus = status != null ? status : CommonStatusEnum.ENABLE.getStatus();
        return success(feeItemService.getFeeItemSimpleList(queryStatus, feeCategory));
    }

}
