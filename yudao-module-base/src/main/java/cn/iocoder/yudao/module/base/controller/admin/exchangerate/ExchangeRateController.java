package cn.iocoder.yudao.module.base.controller.admin.exchangerate;

import cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.controller.admin.exchangerate.vo.ExchangeRatePageReqVO;
import cn.iocoder.yudao.module.base.controller.admin.exchangerate.vo.ExchangeRateRespVO;
import cn.iocoder.yudao.module.base.controller.admin.exchangerate.vo.ExchangeRateSaveReqVO;
import cn.iocoder.yudao.module.base.service.exchangerate.ExchangeRateService;
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

@Tag(name = "管理后台 - 汇率")
@RestController
@RequestMapping("/base/exchange-rate")
@Validated
public class ExchangeRateController {

    private static final int IS_CURRENT_DEFAULT = 1;

    @Resource
    private ExchangeRateService exchangeRateService;

    @PostMapping("/create")
    @Operation(summary = "创建汇率", description = "若存在当前有效汇率则自动失效并写入新记录")
    @PreAuthorize("@ss.hasPermission('base:exchange-rate:manage')")
    @ApiAccessLog(operateType = CREATE)
    public CommonResult<Long> create(@Valid @RequestBody ExchangeRateSaveReqVO createReqVO) {
        return success(exchangeRateService.createExchangeRate(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新当前有效汇率")
    @PreAuthorize("@ss.hasPermission('base:exchange-rate:manage')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> update(@Valid @RequestBody ExchangeRateSaveReqVO updateReqVO) {
        exchangeRateService.updateExchangeRate(updateReqVO);
        return success(true);
    }

    @PutMapping("/invalidate")
    @Operation(summary = "作废当前有效汇率")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('base:exchange-rate:manage')")
    @ApiAccessLog(operateType = UPDATE)
    public CommonResult<Boolean> invalidate(@RequestParam("id") Long id) {
        exchangeRateService.invalidateExchangeRate(id);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得汇率详情")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('base:exchange-rate:manage')")
    public CommonResult<ExchangeRateRespVO> get(@RequestParam("id") Long id) {
        return success(exchangeRateService.getExchangeRate(id));
    }

    @GetMapping("/page")
    @Operation(summary = "获得汇率分页", description = "默认 isCurrent=1（当前有效）")
    @PreAuthorize("@ss.hasPermission('base:exchange-rate:manage')")
    public CommonResult<PageResult<ExchangeRateRespVO>> getPage(@Valid ExchangeRatePageReqVO pageReqVO) {
        if (pageReqVO.getIsCurrent() == null) {
            pageReqVO.setIsCurrent(IS_CURRENT_DEFAULT);
        }
        return success(exchangeRateService.getExchangeRatePage(pageReqVO));
    }

    @GetMapping("/history")
    @Operation(summary = "获得货币对汇率历史", description = "按生效日期倒序，只读")
    @PreAuthorize("@ss.hasPermission('base:exchange-rate:manage')")
    public CommonResult<List<ExchangeRateRespVO>> getHistory(
            @RequestParam("fromCurrency") String fromCurrency,
            @RequestParam("toCurrency") String toCurrency) {
        return success(exchangeRateService.getExchangeRateHistory(fromCurrency, toCurrency));
    }

}
