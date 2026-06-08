package cn.iocoder.yudao.module.base.controller.admin.currency;

import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.controller.admin.currency.vo.*;
import cn.iocoder.yudao.module.base.service.currency.CurrencyService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - 币种")
@RestController
@RequestMapping("/base/currency")
@Validated
public class CurrencyController {

    @Resource
    private CurrencyService currencyService;

    @PostMapping("/create")
    @Operation(summary = "创建币种")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    public CommonResult<Long> create(@Valid @RequestBody CurrencySaveReqVO createReqVO) {
        return success(currencyService.createCurrency(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新币种")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    public CommonResult<Boolean> update(@Valid @RequestBody CurrencySaveReqVO updateReqVO) {
        currencyService.updateCurrency(updateReqVO);
        return success(true);
    }

    @PutMapping("/update-status")
    @Operation(summary = "启用/停用币种")
    @PreAuthorize("@ss.hasPermission('base:data:edit')")
    public CommonResult<Boolean> updateStatus(@Valid @RequestBody CurrencyUpdateStatusReqVO reqVO) {
        currencyService.updateCurrencyStatus(reqVO);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得币种详情")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<CurrencyRespVO> get(@RequestParam("id") Long id) {
        return success(currencyService.getCurrency(id));
    }

    @GetMapping("/page")
    @Operation(summary = "获得币种分页")
    @PreAuthorize("@ss.hasPermission('base:data:view')")
    public CommonResult<PageResult<CurrencyRespVO>> getPage(@Valid CurrencyPageReqVO pageReqVO) {
        return success(currencyService.getCurrencyPage(pageReqVO));
    }

    @GetMapping("/simple-list")
    @Operation(summary = "获得币种精简列表", description = "默认 status=0（正常）")
    public CommonResult<List<CurrencyRespVO>> getSimpleList(
            @RequestParam(value = "status", required = false) Integer status) {
        Integer queryStatus = status != null ? status : CommonStatusEnum.ENABLE.getStatus();
        return success(currencyService.getCurrencySimpleList(queryStatus));
    }

}
