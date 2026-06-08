package cn.iocoder.yudao.module.oms.controller.admin.outboundorder;

import jakarta.validation.Valid;

import static cn.iocoder.yudao.framework.apilog.core.enums.OperateTypeEnum.*;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

import org.springframework.security.access.prepost.PreAuthorize;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.constraints.NotNull;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.excel.core.util.ExcelUtils;
import cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog;
import cn.iocoder.yudao.framework.apilog.core.enums.OperateTypeEnum;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.oms.dal.dataobject.outboundorder.OutboundOrderDO;
import cn.iocoder.yudao.module.oms.controller.admin.bizattachment.vo.BizAttachmentSaveReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo.OutboundOrderItemsReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo.OutboundOrderPageReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.bizattachment.vo.BizAttachmentRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo.OutboundOrderItemRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo.OutboundOrderRespVO;
import cn.iocoder.yudao.module.oms.service.outboundorder.OutboundOrderService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Validated
@RestController
@RequestMapping("/oms/outbound-order")
public class OutboundOrderController  {

    @Resource
    private OutboundOrderService outboundOrderService;

    @PreAuthorize("@ss.hasPermission('oms:outboundOrder:list')")
    @GetMapping({"/list", "/page"})
    public CommonResult<PageResult<OutboundOrderRespVO>> list(OutboundOrderPageReqVO bo, @Valid PageParam pageReqVO) {
        return success(outboundOrderService.queryPageList(bo, pageReqVO));
    }

    @PreAuthorize("@ss.hasPermission('oms:outboundOrder:list')")
    @GetMapping("/status/count")
    public CommonResult<Map<String, Long>> statusCount(OutboundOrderPageReqVO bo) {
        return success(outboundOrderService.queryStatusCount(bo));
    }

    @PreAuthorize("@ss.hasPermission('oms:outboundOrder:query')")
    @GetMapping("/{id}")
    public CommonResult<OutboundOrderRespVO> getInfo(@NotNull(message = "id is required") @PathVariable Long id) {
        return success(outboundOrderService.queryById(id));
    }

    @PreAuthorize("@ss.hasPermission('oms:outboundOrder:edit')")
    @ApiAccessLog(operateType = UPDATE)
        @PutMapping
    public CommonResult<Void> edit(@RequestBody OutboundOrderDO bo) {
        outboundOrderService.updateByBo(bo);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:outboundOrder:remove')")
    @ApiAccessLog(operateType = DELETE)
    @DeleteMapping("/{id}")
    public CommonResult<Void> delete(@PathVariable Long id) {
        outboundOrderService.deleteWithValid(id);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:outboundOrder:complete')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{id}/complete")
    public CommonResult<Void> complete(@PathVariable Long id, @RequestParam(required = false) String remark) {
        outboundOrderService.complete(id, remark);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:outboundOrder:confirmAppointment')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{id}/confirm-appointment")
    public CommonResult<Void> confirmAppointment(@PathVariable Long id) {
        outboundOrderService.confirmAppointment(id);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:outboundOrder:confirmSigned')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{id}/confirm-signed")
    public CommonResult<Void> confirmSigned(@PathVariable Long id) {
        outboundOrderService.confirmSigned(id);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:outboundOrder:confirmOutbounded')")
    @ApiAccessLog(operateType = UPDATE)
        @PostMapping("/{id}/confirm-outbounded")
    public CommonResult<Void> confirmOutbounded(@PathVariable Long id) {
        outboundOrderService.confirmOutbounded(id);
        return success(null);
    }

    @PreAuthorize("@ss.hasAnyPermissions('oms:outboundOrder:query','oms:outboundOrder:list')")
    @GetMapping("/{id}/items")
    public CommonResult<List<OutboundOrderItemRespVO>> getItems(@PathVariable Long id) {
        return success(outboundOrderService.queryItems(id));
    }

    @PreAuthorize("@ss.hasAnyPermissions('oms:outboundOrder:edit','oms:outboundOrder:list')")
    @ApiAccessLog(operateType = CREATE)
    @PostMapping("/{id}/items")
    public CommonResult<Void> addItems(@PathVariable Long id, @RequestBody OutboundOrderItemsReqVO bo) {
        outboundOrderService.addItems(id, bo);
        return success(null);
    }

    @PreAuthorize("@ss.hasAnyPermissions('oms:outboundOrder:edit','oms:outboundOrder:list')")
    @ApiAccessLog(operateType = DELETE)
    @DeleteMapping("/{id}/items/{itemId}")
    public CommonResult<Void> removeItem(@PathVariable Long id, @PathVariable Long itemId) {
        outboundOrderService.removeItem(id, itemId);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:outboundOrder:query')")
    @GetMapping("/{id}/attachments")
    public CommonResult<List<BizAttachmentRespVO>> getAttachments(@PathVariable Long id) {
        return success(outboundOrderService.queryAttachments(id));
    }

    @PreAuthorize("@ss.hasPermission('oms:outboundOrder:attachmentUpload')")
    @ApiAccessLog(operateType = CREATE)
        @PostMapping("/{id}/attachment/upload")
    public CommonResult<Void> uploadAttachment(@PathVariable Long id, @Validated @RequestBody BizAttachmentSaveReqVO bo) {
        outboundOrderService.uploadAttachment(id, bo);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:outboundOrder:attachmentRemove')")
    @ApiAccessLog(operateType = DELETE)
    @DeleteMapping("/attachment/{attachmentId}")
    public CommonResult<Void> removeAttachment(@PathVariable Long attachmentId) {
        outboundOrderService.removeAttachment(attachmentId);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:outboundOrder:export')")
    @ApiAccessLog(operateType = EXPORT)
    @PostMapping("/export")
    public void export(OutboundOrderPageReqVO bo, HttpServletResponse response) throws java.io.IOException {
        List<OutboundOrderRespVO> list = outboundOrderService.queryList(bo);
        ExcelUtils.write(response, "outbound-order.xls", "数据", OutboundOrderRespVO.class, list);
    }
}
