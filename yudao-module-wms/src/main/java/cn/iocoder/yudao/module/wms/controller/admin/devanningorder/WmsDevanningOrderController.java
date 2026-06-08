package cn.iocoder.yudao.module.wms.controller.admin.devanningorder;

import cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.wms.controller.admin.devanningorder.vo.*;
import cn.iocoder.yudao.module.wms.service.devanningorder.WmsDevanningOrderService;
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

@Tag(name = "管理后台 - WMS 拆柜订单")
@RestController
@RequestMapping("/wms/devanning-order")
@Validated
public class WmsDevanningOrderController {

    @Resource
    private WmsDevanningOrderService devanningOrderService;

    @GetMapping("/page")
    @Operation(summary = "拆柜订单分页")
    @PreAuthorize("@ss.hasPermission('wms:devanningOrder:list')")
    public CommonResult<PageResult<WmsDevanningOrderRespVO>> getPage(@Valid WmsDevanningOrderPageReqVO pageReqVO) {
        return success(devanningOrderService.getDevanningOrderPage(pageReqVO));
    }

    @GetMapping("/get")
    @Operation(summary = "拆柜订单详情")
    @Parameter(name = "id", required = true)
    @PreAuthorize("@ss.hasPermission('wms:devanningOrder:query')")
    public CommonResult<WmsDevanningOrderRespVO> get(@RequestParam("id") Long id) {
        return success(devanningOrderService.getDevanningOrder(id));
    }

    @PostMapping("/create")
    @Operation(summary = "创建拆柜订单")
    @PreAuthorize("@ss.hasPermission('wms:devanningOrder:add')")
    @ApiAccessLog(operateType = CREATE)
    public CommonResult<Long> create(@Valid @RequestBody WmsDevanningOrderSaveReqVO createReqVO) {
        return success(devanningOrderService.createDevanningOrder(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新拆柜订单")
    @PreAuthorize("@ss.hasPermission('wms:devanningOrder:edit')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> update(@Valid @RequestBody WmsDevanningOrderSaveReqVO updateReqVO) {
        devanningOrderService.updateDevanningOrder(updateReqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除拆柜订单")
    @PreAuthorize("@ss.hasPermission('wms:devanningOrder:remove')")
    @ApiAccessLog(operateType = DELETE)
    public CommonResult<Boolean> delete(@RequestParam("ids") List<Long> ids) {
        devanningOrderService.deleteDevanningOrderList(ids);
        return success(true);
    }

    @PostMapping("/push")
    @Operation(summary = "OMS 推单")
    @PreAuthorize("@ss.hasPermission('wms:devanningOrder:push')")
    @ApiAccessLog(operateType = CREATE)
    public CommonResult<Long> push(@RequestBody WmsDevanningOrderPushReqVO reqVO) {
        return success(devanningOrderService.pushFromOms(reqVO));
    }

    @PostMapping("/sync-dock")
    @Operation(summary = "Dock 分配同步")
    @PreAuthorize("@ss.hasPermission('wms:devanningOrder:syncDock')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> syncDock(@RequestBody WmsDevanningOrderSyncDockReqVO reqVO) {
        devanningOrderService.syncDock(reqVO);
        return success(true);
    }

    @PutMapping("/confirm-pickup")
    @Operation(summary = "确认提柜")
    @PreAuthorize("@ss.hasPermission('wms:devanningOrder:confirmPickup')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> confirmPickup(@RequestParam("id") Long id,
                                               @RequestBody(required = false) WmsDevanningOrderActionReqVO reqVO) {
        devanningOrderService.confirmPickup(id, reqVO);
        return success(true);
    }

    @PutMapping("/confirm-arrival")
    @Operation(summary = "确认到仓")
    @PreAuthorize("@ss.hasPermission('wms:devanningOrder:confirmArrival')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> confirmArrival(@RequestParam("id") Long id,
                                                @RequestBody(required = false) WmsDevanningOrderActionReqVO reqVO) {
        devanningOrderService.confirmArrival(id, reqVO);
        return success(true);
    }

    @PutMapping("/start-devanning")
    @Operation(summary = "开始拆柜")
    @PreAuthorize("@ss.hasPermission('wms:devanningOrder:startDevanning')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> startDevanning(@RequestParam("id") Long id,
                                                @RequestBody(required = false) WmsDevanningOrderActionReqVO reqVO) {
        devanningOrderService.startDevanning(id, reqVO);
        return success(true);
    }

    @PutMapping("/complete-devanning")
    @Operation(summary = "完成拆柜")
    @PreAuthorize("@ss.hasPermission('wms:devanningOrder:completeDevanning')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> completeDevanning(@RequestParam("id") Long id,
                                                   @RequestBody(required = false) WmsDevanningOrderActionReqVO reqVO) {
        devanningOrderService.completeDevanning(id, reqVO);
        return success(true);
    }

    @PutMapping("/mark-exception")
    @Operation(summary = "标记异常")
    @PreAuthorize("@ss.hasPermission('wms:devanningOrder:markException')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> markException(@RequestParam("id") Long id,
                                               @RequestBody(required = false) WmsDevanningOrderActionReqVO reqVO) {
        devanningOrderService.markException(id, reqVO);
        return success(true);
    }

    @PutMapping("/clear-exception")
    @Operation(summary = "解除异常")
    @PreAuthorize("@ss.hasPermission('wms:devanningOrder:clearException')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> clearException(@RequestParam("id") Long id,
                                                @RequestBody(required = false) WmsDevanningOrderActionReqVO reqVO) {
        devanningOrderService.clearException(id, reqVO);
        return success(true);
    }

    @PutMapping("/cancel")
    @Operation(summary = "取消拆柜")
    @PreAuthorize("@ss.hasPermission('wms:devanningOrder:cancel')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> cancel(@RequestParam("id") Long id,
                                      @RequestBody(required = false) WmsDevanningOrderActionReqVO reqVO) {
        devanningOrderService.cancel(id, reqVO);
        return success(true);
    }

    @GetMapping("/export")
    @Operation(summary = "导出拆柜订单")
    @PreAuthorize("@ss.hasPermission('wms:devanningOrder:export')")
    public CommonResult<List<WmsDevanningOrderRespVO>> export(WmsDevanningOrderPageReqVO pageReqVO) {
        pageReqVO.setPageSize(PageParam.PAGE_SIZE_NONE);
        return success(devanningOrderService.getDevanningOrderList(pageReqVO));
    }

}
