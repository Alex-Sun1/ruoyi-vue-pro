package cn.iocoder.yudao.module.oms.controller.admin.cargoorder;

import jakarta.validation.Valid;

import static cn.iocoder.yudao.framework.apilog.core.enums.OperateTypeEnum.*;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

import org.springframework.security.access.prepost.PreAuthorize;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.excel.core.util.ExcelUtils;
import cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog;
import cn.iocoder.yudao.framework.apilog.core.enums.OperateTypeEnum;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.oms.controller.admin.bizattachment.vo.BizAttachmentSaveReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.common.vo.OmsManualStatusReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderSaveReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderHoldReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderMergeBackReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderPageReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderReleaseReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderShipmentSaveReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderSplitReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderSkuItemSaveReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderTransferReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.bizattachment.vo.BizAttachmentRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderNodeTraceRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderShipmentRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderSkuItemRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderRespVO;
import cn.iocoder.yudao.module.oms.service.cargoorder.CargoOrderService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Validated
@RestController
@RequestMapping("/oms/cargo-order")
public class CargoOrderController  {

    @Resource
    private CargoOrderService cargoOrderService;

    // =================== 主单 CRUD ===================

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:list')")
    @GetMapping({"/list", "/page"})
    public CommonResult<PageResult<CargoOrderRespVO>> list(CargoOrderPageReqVO bo, @Valid PageParam pageReqVO) {
        return success(cargoOrderService.queryPageList(bo, pageReqVO));
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:list')")
    @GetMapping("/status-count")
    public CommonResult<Map<String, Long>> statusCount(CargoOrderPageReqVO bo) {
        return success(cargoOrderService.queryStatusCount(bo));
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:query')")
    @GetMapping("/{id}")
    public CommonResult<CargoOrderRespVO> getInfo(@NotNull(message = "主键不能为空") @PathVariable Long id) {
        return success(cargoOrderService.queryById(id));
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:add')")
    @ApiAccessLog(operateType = CREATE)
        @PostMapping
    public CommonResult<Void> add(@Valid @RequestBody CargoOrderSaveReqVO bo) {
        cargoOrderService.insertByBo(bo);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:edit')")
    @ApiAccessLog(operateType = UPDATE)
        @PutMapping
    public CommonResult<Void> edit(@Valid @RequestBody CargoOrderSaveReqVO bo) {
        cargoOrderService.updateByBo(bo);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:remove')")
    @ApiAccessLog(operateType = DELETE)
    @DeleteMapping("/{ids}")
    public CommonResult<Void> remove(@NotEmpty(message = "主键不能为空") @PathVariable Long[] ids) {
        cargoOrderService.deleteByIds(List.of(ids));
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:export')")
    @ApiAccessLog(operateType = EXPORT)
    @PostMapping("/export")
    public void export(CargoOrderPageReqVO bo, HttpServletResponse response) throws java.io.IOException {
        List<CargoOrderRespVO> list = cargoOrderService.queryList(bo);
        ExcelUtils.write(response, "货物订单.xls", "数据", CargoOrderRespVO.class, list);
    }

    // =================== 货件 ===================

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:query')")
    @GetMapping("/{id}/shipments")
    public CommonResult<List<CargoOrderShipmentRespVO>> shipmentList(@PathVariable Long id) {
        return success(cargoOrderService.queryShipmentList(id));
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:edit')")
    @ApiAccessLog(operateType = CREATE)
        @PostMapping("/{id}/shipments")
    public CommonResult<Void> saveShipment(@PathVariable Long id, @Validated @RequestBody CargoOrderShipmentSaveReqVO bo) {
        cargoOrderService.saveShipment(id, bo);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:edit')")
    @ApiAccessLog(operateType = DELETE)
    @DeleteMapping("/shipments/{shipmentId}")
    public CommonResult<Void> deleteShipment(@PathVariable Long shipmentId) {
        cargoOrderService.deleteShipment(shipmentId);
        return success(null);
    }

    // =================== SKU 明细 ===================

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:query')")
    @GetMapping("/{id}/sku-items")
    public CommonResult<List<CargoOrderSkuItemRespVO>> skuItemList(@PathVariable Long id) {
        return success(cargoOrderService.querySkuItemList(id));
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:edit')")
    @ApiAccessLog(operateType = CREATE)
        @PostMapping("/{id}/sku-items")
    public CommonResult<Void> saveSkuItem(@PathVariable Long id, @Validated @RequestBody CargoOrderSkuItemSaveReqVO bo) {
        cargoOrderService.saveSkuItem(id, bo);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:edit')")
    @ApiAccessLog(operateType = DELETE)
    @DeleteMapping("/sku-items/{skuItemId}")
    public CommonResult<Void> deleteSkuItem(@PathVariable Long skuItemId) {
        cargoOrderService.deleteSkuItem(skuItemId);
        return success(null);
    }

    // =================== 节点轨迹 ===================

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:query')")
    @GetMapping("/{id}/node-traces")
    public CommonResult<List<CargoOrderNodeTraceRespVO>> nodeTraceList(@PathVariable Long id) {
        return success(cargoOrderService.queryNodeTraceList(id));
    }

    // =================== 业务动作 ===================

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:accept')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{id}/accept")
    public CommonResult<Void> accept(@PathVariable Long id, @RequestParam(required = false) String remark) {
        cargoOrderService.accept(id, remark);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:markInTransit')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{id}/in-transit")
    public CommonResult<Void> markInTransit(@PathVariable Long id, @RequestParam(required = false) String remark) {
        cargoOrderService.markInTransit(id, remark);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:confirmArrivedPort')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{id}/arrived-port")
    public CommonResult<Void> confirmArrivedPort(@PathVariable Long id, @RequestParam(required = false) String remark) {
        cargoOrderService.confirmArrivedPort(id, remark);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:confirmPickedUp')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{id}/picked-up")
    public CommonResult<Void> confirmPickedUp(@PathVariable Long id, @RequestParam(required = false) String remark) {
        cargoOrderService.confirmPickedUp(id, remark);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:confirmArrivedWarehouse')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{id}/arrived-warehouse")
    public CommonResult<Void> confirmArrivedWarehouse(@PathVariable Long id, @RequestParam(required = false) String remark) {
        cargoOrderService.confirmArrivedWarehouse(id, remark);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:startDevanning')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{id}/start-devanning")
    public CommonResult<Void> startDevanning(@PathVariable Long id, @RequestParam(required = false) String remark) {
        cargoOrderService.startDevanning(id, remark);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:finishDevanning')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{id}/finish-devanning")
    public CommonResult<Void> finishDevanning(@PathVariable Long id, @RequestParam(required = false) String remark) {
        cargoOrderService.finishDevanning(id, remark);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:confirmInbounded')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{id}/inbounded")
    public CommonResult<Void> confirmInbounded(@PathVariable Long id, @RequestParam(required = false) String remark) {
        cargoOrderService.confirmInbounded(id, remark);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:createOutboundOrder')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{id}/outbound-order")
    public CommonResult<Void> createOutboundOrder(@PathVariable Long id,
                                        @RequestParam(required = false) String outboundBatchNo,
                                        @RequestParam(required = false) String remark) {
        cargoOrderService.createOutboundOrder(id, outboundBatchNo, remark);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:appointDelivery')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{id}/appoint-delivery")
    public CommonResult<Void> appointDelivery(@PathVariable Long id, @RequestParam(required = false) String remark) {
        cargoOrderService.appointDelivery(id, remark);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:confirmOutbounded')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{id}/outbounded")
    public CommonResult<Void> confirmOutbounded(@PathVariable Long id, @RequestParam(required = false) String remark) {
        cargoOrderService.confirmOutbounded(id, remark);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:markDelivering')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{id}/delivering")
    public CommonResult<Void> markDelivering(@PathVariable Long id, @RequestParam(required = false) String remark) {
        cargoOrderService.markDelivering(id, remark);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:confirmDelivered')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{id}/delivered")
    public CommonResult<Void> confirmDelivered(@PathVariable Long id, @RequestParam(required = false) String remark) {
        cargoOrderService.confirmDelivered(id, remark);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:uploadPod')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{id}/pod-uploaded")
    public CommonResult<Void> uploadPod(@PathVariable Long id, @RequestParam(required = false) String remark) {
        cargoOrderService.uploadPod(id, remark);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:confirmBilled')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{id}/billed")
    public CommonResult<Void> confirmBilled(@PathVariable Long id, @RequestParam(required = false) String remark) {
        cargoOrderService.confirmBilled(id, remark);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:complete')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{id}/complete")
    public CommonResult<Void> complete(@PathVariable Long id, @RequestParam(required = false) String remark) {
        cargoOrderService.complete(id, remark);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:cancel')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{id}/cancel")
    public CommonResult<Void> cancel(@PathVariable Long id, @RequestParam(required = false) String remark) {
        cargoOrderService.cancel(id, remark);
        return success(null);
    }

    // =================== 预出单 ===================

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:manualStatus')")
    @ApiAccessLog(operateType = UPDATE)
    @PutMapping("/{id}/manual-status")
    public CommonResult<Void> manualStatus(@PathVariable Long id, @Valid @RequestBody OmsManualStatusReqVO bo) {
        cargoOrderService.manualAdjustStatus(id, bo);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:createPreOutbound')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{id}/pre-outbound")
    public CommonResult<Void> createPreOutbound(@PathVariable Long id,
                                      @RequestParam(required = false) String preOutboundNo,
                                      @RequestParam(required = false) String remark) {
        cargoOrderService.createPreOutbound(id, preOutboundNo, remark);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:convertPreOutbound')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{id}/convert-pre-outbound")
    public CommonResult<Void> convertPreOutbound(@PathVariable Long id,
                                       @RequestParam(required = false) String outboundBatchNo,
                                       @RequestParam(required = false) String remark) {
        cargoOrderService.convertPreOutbound(id, outboundBatchNo, remark);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:cancelPreOutbound')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{id}/cancel-pre-outbound")
    public CommonResult<Void> cancelPreOutbound(@PathVariable Long id, @RequestParam(required = false) String remark) {
        cargoOrderService.cancelPreOutbound(id, remark);
        return success(null);
    }

    // =================== 特殊操作 ===================

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:changeInboundWarehouse')")
    @ApiAccessLog(operateType = UPDATE)
        @PutMapping("/{id}/inbound-warehouse")
    public CommonResult<Void> changeInboundWarehouse(@PathVariable Long id,
                                           @RequestParam Long warehouseId,
                                           @RequestParam String warehouseName,
                                           @RequestParam(required = false) String remark) {
        cargoOrderService.changeInboundWarehouse(id, warehouseId, warehouseName, remark);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:cancelTransfer')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{id}/cancel-transfer")
    public CommonResult<Void> cancelTransfer(@PathVariable Long id, @RequestParam(required = false) String remark) {
        cargoOrderService.cancelTransfer(id, remark);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:modifyTransfer')")
    @ApiAccessLog(operateType = UPDATE)
        @PutMapping("/{id}/transfer")
    public CommonResult<Void> modifyTransfer(@PathVariable Long id, @Validated @RequestBody CargoOrderTransferReqVO bo) {
        cargoOrderService.modifyTransfer(id, bo.getTransferWarehouseCode(), bo.getRemark());
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:query')")
    @GetMapping("/{id}/attachments")
    public CommonResult<List<BizAttachmentRespVO>> attachments(@PathVariable Long id,
                                                @RequestParam(defaultValue = "true") boolean includeContainerAttachments) {
        return success(cargoOrderService.queryAttachments(id, includeContainerAttachments));
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:attachmentUpload')")
    @ApiAccessLog(operateType = CREATE)
        @PostMapping("/{id}/attachment/upload")
    public CommonResult<Void> uploadAttachment(@PathVariable Long id, @Validated @RequestBody BizAttachmentSaveReqVO bo) {
        cargoOrderService.uploadAttachment(id, bo);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:attachmentRemove')")
    @ApiAccessLog(operateType = DELETE)
    @DeleteMapping("/attachment/{attachmentId}")
    public CommonResult<Void> removeAttachment(@PathVariable Long attachmentId) {
        cargoOrderService.removeAttachment(attachmentId);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:hold')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{id}/hold")
    public CommonResult<Void> hold(@PathVariable Long id, @Validated @RequestBody CargoOrderHoldReqVO bo) {
        cargoOrderService.hold(id, bo);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:releaseHold')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{id}/release-hold")
    public CommonResult<Void> releaseHold(@PathVariable Long id, @Validated @RequestBody CargoOrderReleaseReqVO bo) {
        cargoOrderService.releaseHold(id, bo);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:split')")
    @ApiAccessLog(operateType = CREATE)
        @PostMapping("/{id}/split")
    public CommonResult<Void> split(@PathVariable Long id, @Validated @RequestBody CargoOrderSplitReqVO bo) {
        cargoOrderService.split(id, bo);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:cargoOrder:mergeBack')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/merge-back")
    public CommonResult<Void> mergeBack(@Validated @RequestBody CargoOrderMergeBackReqVO bo) {
        cargoOrderService.mergeBack(bo);
        return success(null);
    }
}
