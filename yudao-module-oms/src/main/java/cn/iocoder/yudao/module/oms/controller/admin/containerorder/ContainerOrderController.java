package cn.iocoder.yudao.module.oms.controller.admin.containerorder;

import static cn.iocoder.yudao.framework.apilog.core.enums.OperateTypeEnum.*;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

import org.springframework.security.access.prepost.PreAuthorize;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderSaveReqVO;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
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
import cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerCargoOrderBatchReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerOrderSaveReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerOrderPageReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerOrderStatusReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.bizattachment.vo.BizAttachmentRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerCargoOrderImportExcelVO;
import cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerOrderRespVO;
import cn.iocoder.yudao.module.oms.service.containerorder.ContainerOrderService;
import org.springframework.http.MediaType;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 海柜订单控制器
 */
@Validated
@RestController
@RequestMapping("/oms/container-order")
public class ContainerOrderController  {

    @Resource
    private ContainerOrderService containerOrderService;

    @PreAuthorize("@ss.hasPermission('oms:containerOrder:list')")
    @GetMapping({"/list", "/page"})
    public CommonResult<PageResult<ContainerOrderRespVO>> list(ContainerOrderPageReqVO bo, @Valid PageParam pageReqVO) {
        return success(containerOrderService.queryPageList(bo, pageReqVO));
    }

    @PreAuthorize("@ss.hasPermission('oms:containerOrder:list')")
    @GetMapping("/status-count")
    public CommonResult<Map<String, Long>> statusCount(ContainerOrderPageReqVO bo) {
        return success(containerOrderService.queryStatusCount(bo));
    }

    @PreAuthorize("@ss.hasPermission('oms:containerOrder:query')")
    @GetMapping("/{id}")
    public CommonResult<ContainerOrderRespVO> getInfo(@NotNull(message = "主键不能为空") @PathVariable Long id) {
        return success(containerOrderService.queryById(id));
    }

    @PreAuthorize("@ss.hasPermission('oms:containerOrder:add')")
    @ApiAccessLog(operateType = CREATE)
        @PostMapping
    public CommonResult<Void> add(@Valid @RequestBody ContainerOrderSaveReqVO bo) {
        containerOrderService.insertByBo(bo, false);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:containerOrder:add')")
    @ApiAccessLog(operateType = CREATE)
        @PostMapping("/draft")
    public CommonResult<Void> addDraft(@Valid @RequestBody ContainerOrderSaveReqVO bo) {
        containerOrderService.insertByBo(bo, true);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:containerOrder:edit')")
    @ApiAccessLog(operateType = UPDATE)
        @PutMapping
    public CommonResult<Void> edit(@Valid @RequestBody ContainerOrderSaveReqVO bo) {
        containerOrderService.updateByBo(bo);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:containerOrder:edit')")
    @ApiAccessLog(operateType = CREATE)
        @PostMapping("/{id}/cargo-orders")
    public CommonResult<Void> addCargoOrders(@NotNull(message = "主键不能为空") @PathVariable Long id,
                                  @Validated @RequestBody ContainerCargoOrderBatchReqVO bo) {
        containerOrderService.addCargoOrders(id, bo.getCargoOrders());
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:containerOrder:importCargo')")
    @ApiAccessLog(operateType = IMPORT)
    @PostMapping(value = "/{id}/cargo-orders/import", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public CommonResult<String> importCargoOrders(@NotNull(message = "主键不能为空") @PathVariable Long id,
                                       @RequestPart("file") MultipartFile file) throws Exception {
        List<ContainerCargoOrderImportExcelVO> excelResult = ExcelUtils.read(file, ContainerCargoOrderImportExcelVO.class);
        String analysis = containerOrderService.importCargoOrders(id, excelResult);
        return success(analysis);
    }

    @PreAuthorize("@ss.hasAnyPermissions('oms:containerOrder:add','oms:containerOrder:importCargo')")
    @PostMapping(value = "/cargo-orders/parse-import", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public CommonResult<List<CargoOrderSaveReqVO>> parseImportCargoOrders(@RequestPart("file") MultipartFile file) throws Exception {
        List<ContainerCargoOrderImportExcelVO> excelResult = ExcelUtils.read(file, ContainerCargoOrderImportExcelVO.class);
        return success(containerOrderService.parseImportCargoOrders(excelResult));
    }

    @PreAuthorize("@ss.hasAnyPermissions('oms:containerOrder:add','oms:containerOrder:importCargo')")
    @PostMapping("/cargo-orders/importTemplate")
    public void importTemplate(HttpServletResponse response) throws java.io.IOException {
        ExcelUtils.write(response, "海柜关联货物订单导入模板.xls", "数据", ContainerCargoOrderImportExcelVO.class, new ArrayList<ContainerCargoOrderImportExcelVO>());
    }

    @PreAuthorize("@ss.hasPermission('oms:containerOrder:updateStatus')")
    @ApiAccessLog(operateType = UPDATE)
        @PutMapping("/{id}/status")
    public CommonResult<Void> updateStatus(@NotNull(message = "主键不能为空") @PathVariable Long id,
                                @Valid @RequestBody ContainerOrderStatusReqVO bo) {
        containerOrderService.updateStatus(id, bo);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:containerOrder:query')")
    @GetMapping("/{id}/attachments")
    public CommonResult<List<BizAttachmentRespVO>> attachments(@NotNull(message = "主键不能为空") @PathVariable Long id) {
        return success(containerOrderService.queryAttachments(id));
    }

    @PreAuthorize("@ss.hasPermission('oms:containerOrder:attachmentUpload')")
    @ApiAccessLog(operateType = CREATE)
        @PostMapping("/{id}/attachment/upload")
    public CommonResult<Void> uploadAttachment(@NotNull(message = "主键不能为空") @PathVariable Long id,
                                    @Validated @RequestBody BizAttachmentSaveReqVO bo) {
        containerOrderService.uploadAttachment(id, bo, false);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:containerOrder:uploadDo')")
    @ApiAccessLog(operateType = CREATE)
        @PostMapping("/{id}/do/upload")
    public CommonResult<Void> uploadDo(@NotNull(message = "主键不能为空") @PathVariable Long id,
                            @Validated @RequestBody BizAttachmentSaveReqVO bo) {
        containerOrderService.uploadAttachment(id, bo, true);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:containerOrder:attachmentRemove')")
    @ApiAccessLog(operateType = DELETE)
    @DeleteMapping("/attachment/{attachmentId}")
    public CommonResult<Void> removeAttachment(@PathVariable Long attachmentId) {
        containerOrderService.removeAttachment(attachmentId);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:containerOrder:remove')")
    @ApiAccessLog(operateType = DELETE)
    @DeleteMapping("/{ids}")
    public CommonResult<Void> remove(@NotEmpty(message = "主键不能为空") @PathVariable Long[] ids) {
        containerOrderService.deleteWithValidByIds(List.of(ids));
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:containerOrder:export')")
    @ApiAccessLog(operateType = EXPORT)
    @PostMapping("/export")
    public void export(ContainerOrderPageReqVO bo, HttpServletResponse response) throws java.io.IOException {
        List<ContainerOrderRespVO> list = containerOrderService.queryList(bo);
        ExcelUtils.write(response, "海柜订单.xls", "数据", ContainerOrderRespVO.class, list);
    }
}
