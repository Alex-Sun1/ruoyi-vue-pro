package cn.iocoder.yudao.module.oms.controller.admin.outboundpool;

import jakarta.validation.Valid;

import static cn.iocoder.yudao.framework.apilog.core.enums.OperateTypeEnum.*;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

import org.springframework.security.access.prepost.PreAuthorize;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog;
import cn.iocoder.yudao.framework.apilog.core.enums.OperateTypeEnum;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo.OutboundCreateReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.outboundpool.vo.OutboundPoolQueryReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo.OutboundOrderRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.outboundpool.vo.OutboundPoolStatsRespVO;
import cn.iocoder.yudao.module.oms.controller.admin.preoutbound.vo.PreOutboundRespVO;
import cn.iocoder.yudao.module.oms.service.outboundpool.OutboundPoolService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@Validated
@RestController
@RequestMapping("/oms/outbound-pool")
public class OutboundPoolController  {

    @Resource
    private OutboundPoolService outboundPoolService;

    @PreAuthorize("@ss.hasPermission('oms:outboundPool:list')")
    @GetMapping({"/list", "/page"})
    public CommonResult<PageResult<CargoOrderRespVO>> list(OutboundPoolQueryReqVO bo, @Valid PageParam pageReqVO) {
        return success(outboundPoolService.queryPageList(bo, pageReqVO));
    }

    @PreAuthorize("@ss.hasPermission('oms:outboundPool:list')")
    @GetMapping("/stats")
    public CommonResult<OutboundPoolStatsRespVO> stats(OutboundPoolQueryReqVO bo) {
        return success(outboundPoolService.queryStats(bo));
    }

    @PreAuthorize("@ss.hasPermission('oms:outboundPool:list')")
    @GetMapping("/cargo-order/{id}")
    public CommonResult<CargoOrderRespVO> getCargoOrderDetail(@PathVariable Long id) {
        return success(outboundPoolService.queryCargoOrderDetail(id));
    }

    @PreAuthorize("@ss.hasPermission('oms:outboundPool:createPreOutbound')")
    @ApiAccessLog(operateType = CREATE)
    @PostMapping("/create-pre-outbound")
    public CommonResult<PreOutboundRespVO> createPreOutbound(@RequestBody OutboundCreateReqVO bo) {
        return success(outboundPoolService.createPreOutbound(bo));
    }

    @PreAuthorize("@ss.hasPermission('oms:outboundPool:createOutboundOrder')")
    @ApiAccessLog(operateType = CREATE)
    @PostMapping("/create-outbound-order")
    public CommonResult<OutboundOrderRespVO> createOutboundOrder(@RequestBody OutboundCreateReqVO bo) {
        return success(outboundPoolService.createOutboundOrder(bo));
    }

    @PreAuthorize("@ss.hasPermission('oms:outboundPool:batchCreatePreOutbound')")
    @ApiAccessLog(operateType = CREATE)
        @PostMapping("/batch-create-pre-outbound")
    public CommonResult<Void> batchCreatePreOutbound(@RequestBody OutboundCreateReqVO bo) {
        outboundPoolService.batchCreatePreOutbound(bo);
        return success(null);
    }

    @PreAuthorize("@ss.hasPermission('oms:outboundPool:batchCreateOutboundOrder')")
    @ApiAccessLog(operateType = CREATE)
        @PostMapping("/batch-create-outbound-order")
    public CommonResult<Void> batchCreateOutboundOrder(@RequestBody OutboundCreateReqVO bo) {
        outboundPoolService.batchCreateOutboundOrder(bo);
        return success(null);
    }
}
