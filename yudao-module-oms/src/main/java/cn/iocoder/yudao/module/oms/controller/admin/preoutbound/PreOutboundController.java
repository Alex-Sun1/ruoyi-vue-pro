package cn.iocoder.yudao.module.oms.controller.admin.preoutbound;

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
import cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo.OutboundCreateReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.preoutbound.vo.PreOutboundItemsReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.preoutbound.vo.PreOutboundPageReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.preoutbound.vo.PreOutboundUpdateReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo.OutboundOrderRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.preoutbound.vo.PreOutboundItemRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.preoutbound.vo.PreOutboundRespVO;
import cn.iocoder.yudao.module.oms.service.preoutbound.PreOutboundService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Validated
@RestController
@RequestMapping("/oms/pre-outbound")
public class PreOutboundController  {

    @Resource
    private PreOutboundService preOutboundService;

    @PreAuthorize("@ss.hasAnyPermissions('oms:preOutbound:edit','oms:preOutbound:list')")
    @ApiAccessLog(operateType = CREATE)
    @PostMapping
    public CommonResult<PreOutboundRespVO> createEmpty(@RequestBody OutboundCreateReqVO bo) {
        return success(preOutboundService.createEmpty(bo));
    }

    @PreAuthorize("@ss.hasPermission('oms:preOutbound:list')")
    @GetMapping({"/list", "/page"})
    public CommonResult<PageResult<PreOutboundRespVO>> list(PreOutboundPageReqVO bo, @Valid PageParam pageReqVO) {
        return success(preOutboundService.queryPageList(bo, pageReqVO));
    }

    @PreAuthorize("@ss.hasPermission('oms:preOutbound:list')")
    @GetMapping("/status/count")
    public CommonResult<Map<String, Long>> statusCount(PreOutboundPageReqVO bo) {
        return success(preOutboundService.queryStatusCount(bo));
    }

    @PreAuthorize("@ss.hasAnyPermissions('oms:preOutbound:query','oms:preOutbound:list')")
    @GetMapping("/{id}")
    public CommonResult<PreOutboundRespVO> getInfo(@NotNull(message = "id is required") @PathVariable Long id) {
        return success(preOutboundService.queryById(id));
    }

    @PreAuthorize("@ss.hasAnyPermissions('oms:preOutbound:query','oms:preOutbound:list')")
    @GetMapping("/{id}/items")
    public CommonResult<List<PreOutboundItemRespVO>> listItems(@NotNull(message = "id is required") @PathVariable Long id) {
        return success(preOutboundService.queryItems(id));
    }

    @PreAuthorize("@ss.hasAnyPermissions('oms:preOutbound:edit','oms:preOutbound:list')")
    @ApiAccessLog(operateType = CREATE)
        @PostMapping("/{id}/items")
    public CommonResult<Void> addItems(@PathVariable Long id, @RequestBody PreOutboundItemsReqVO bo) {
        preOutboundService.addItems(id, bo);
        return success(null);
    }

    @PreAuthorize("@ss.hasAnyPermissions('oms:preOutbound:edit','oms:preOutbound:list')")
    @ApiAccessLog(operateType = DELETE)
        @DeleteMapping("/{id}/items/{itemId}")
    public CommonResult<Void> removeItem(@PathVariable Long id, @PathVariable Long itemId) {
        preOutboundService.removeItem(id, itemId);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:preOutbound:convert')")
    @ApiAccessLog(operateType = UPDATE)
    @PostMapping("/{id}/convert")
    public CommonResult<OutboundOrderRespVO> convert(@PathVariable Long id, @RequestBody OutboundCreateReqVO bo) {
        return success(preOutboundService.convert(id, bo));
    }

    @PreAuthorize("@ss.hasPermission('oms:preOutbound:edit')")
    @ApiAccessLog(operateType = UPDATE)
        @PutMapping("/{id}")
    public CommonResult<Void> update(@PathVariable Long id, @RequestBody PreOutboundUpdateReqVO bo) {
        preOutboundService.updateByBo(id, bo);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:preOutbound:remove')")
    @ApiAccessLog(operateType = DELETE)
    @DeleteMapping("/{id}")
    public CommonResult<Void> delete(@PathVariable Long id) {
        preOutboundService.deleteWithValid(id);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:preOutbound:export')")
    @ApiAccessLog(operateType = EXPORT)
    @PostMapping("/export")
    public void export(PreOutboundPageReqVO bo, HttpServletResponse response) throws java.io.IOException {
        List<PreOutboundRespVO> list = preOutboundService.queryList(bo);
        ExcelUtils.write(response, "pre-outbound.xls", "数据", PreOutboundRespVO.class, list);
    }
}
