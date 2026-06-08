package cn.iocoder.yudao.module.wms.controller.admin.inventory;

import cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.wms.controller.admin.inventory.vo.*;
import cn.iocoder.yudao.module.wms.service.inventory.WmsInventoryService;
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

@Tag(name = "管理后台 - WMS 库存")
@RestController
@RequestMapping("/wms/inventory")
@Validated
public class WmsInventoryController {

    @Resource
    private WmsInventoryService inventoryService;

    @GetMapping("/page")
    @Operation(summary = "库存分页")
    @PreAuthorize("@ss.hasPermission('wms:inventory:list')")
    public CommonResult<PageResult<WmsInventoryRespVO>> getInventoryPage(@Valid WmsInventoryPageReqVO pageReqVO) {
        return success(inventoryService.getInventoryPage(pageReqVO));
    }

    @GetMapping("/stats")
    @Operation(summary = "库存统计")
    @PreAuthorize("@ss.hasPermission('wms:inventory:list')")
    public CommonResult<WmsInventoryStatsRespVO> getStats(@Valid WmsInventoryPageReqVO pageReqVO) {
        return success(inventoryService.getInventoryStats(pageReqVO));
    }

    @GetMapping("/visualization")
    @Operation(summary = "库存可视化")
    @PreAuthorize("@ss.hasPermission('wms:inventory:visualization')")
    public CommonResult<WmsInventoryVisualizationRespVO> getVisualization(@Valid WmsInventoryVisualizationReqVO reqVO) {
        return success(inventoryService.getVisualization(reqVO));
    }

    @GetMapping("/get")
    @Operation(summary = "库存详情")
    @Parameter(name = "id", required = true)
    @PreAuthorize("@ss.hasPermission('wms:inventory:query')")
    public CommonResult<WmsInventoryRespVO> get(@RequestParam("id") Long id) {
        return success(inventoryService.getInventory(id));
    }

    @GetMapping("/pallets/page")
    @Operation(summary = "卡板分页")
    @PreAuthorize("@ss.hasPermission('wms:pallet:list')")
    public CommonResult<PageResult<WmsPalletRespVO>> getPalletPage(@Valid WmsPalletPageReqVO pageReqVO) {
        return success(inventoryService.getPalletPage(pageReqVO));
    }

    @GetMapping("/pallets/items")
    @Operation(summary = "卡板明细")
    @PreAuthorize("@ss.hasPermission('wms:pallet:query')")
    public CommonResult<List<WmsPalletItemRespVO>> getPalletItems(@RequestParam("palletId") Long palletId) {
        return success(inventoryService.getPalletItems(palletId));
    }

    @PutMapping("/pallets/move-location")
    @Operation(summary = "卡板移动库位")
    @PreAuthorize("@ss.hasPermission('wms:pallet:moveLocation')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> movePalletLocation(@Valid @RequestBody WmsPalletMoveReqVO reqVO) {
        inventoryService.movePalletLocation(reqVO);
        return success(true);
    }

    @PutMapping("/pallets/outbound")
    @Operation(summary = "卡板出库")
    @PreAuthorize("@ss.hasPermission('wms:pallet:outbound')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> outboundPallet(@Valid @RequestBody WmsPalletOutboundReqVO reqVO) {
        inventoryService.outboundPallet(reqVO);
        return success(true);
    }

    @GetMapping("/locks/page")
    @Operation(summary = "库存锁定分页")
    @PreAuthorize("@ss.hasPermission('wms:inventoryLock:list')")
    public CommonResult<PageResult<WmsInventoryLockRespVO>> getLockPage(@Valid WmsInventoryLockPageReqVO pageReqVO) {
        return success(inventoryService.getLockPage(pageReqVO));
    }

    @GetMapping("/transactions/page")
    @Operation(summary = "库存流水分页")
    @PreAuthorize("@ss.hasPermission('wms:inventoryTransaction:list')")
    public CommonResult<PageResult<WmsInventoryTransactionRespVO>> getTransactionPage(
            @Valid WmsInventoryTransactionPageReqVO pageReqVO) {
        return success(inventoryService.getTransactionPage(pageReqVO));
    }

    @PostMapping("/receive")
    @Operation(summary = "收货入账")
    @PreAuthorize("@ss.hasPermission('wms:inventory:receive')")
    @ApiAccessLog(operateType = CREATE)
    public CommonResult<Boolean> receive(@Valid @RequestBody WmsInventoryReceiveReqVO reqVO) {
        inventoryService.receive(reqVO);
        return success(true);
    }

    @PostMapping("/lock")
    @Operation(summary = "库存锁定")
    @PreAuthorize("@ss.hasPermission('wms:inventory:lock')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> lock(@Valid @RequestBody WmsInventoryLockReqVO reqVO) {
        inventoryService.lock(reqVO);
        return success(true);
    }

    @PostMapping("/adjust")
    @Operation(summary = "库存调整")
    @PreAuthorize("@ss.hasPermission('wms:inventory:adjust')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> adjust(@Valid @RequestBody WmsInventoryAdjustReqVO reqVO) {
        inventoryService.adjust(reqVO);
        return success(true);
    }

}
