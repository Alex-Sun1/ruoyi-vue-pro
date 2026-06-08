package cn.iocoder.yudao.module.base.controller.admin.exchangerate.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;

@Schema(description = "管理后台 - 汇率新增/修改 Request VO")
@Data
public class ExchangeRateSaveReqVO {

    @Schema(description = "编号（编辑时）")
    private Long id;

    @Schema(description = "源货币代码")
    @NotBlank(message = "源货币不能为空")
    private String fromCurrency;

    @Schema(description = "目标货币代码")
    @NotBlank(message = "目标货币不能为空")
    private String toCurrency;

    @Schema(description = "汇率")
    @NotNull(message = "汇率不能为空")
    @DecimalMin(value = "0", inclusive = false, message = "汇率须大于 0")
    private BigDecimal rate;

    @Schema(description = "生效日期")
    @NotNull(message = "生效日期不能为空")
    private LocalDate effectiveDate;

    @Schema(description = "备注")
    private String remark;

}
