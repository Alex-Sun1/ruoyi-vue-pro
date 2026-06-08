package cn.iocoder.yudao.module.base.controller.admin.exchangerate.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Schema(description = "管理后台 - 汇率 Response VO")
@Data
public class ExchangeRateRespVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "源货币代码")
    private String fromCurrency;

    @Schema(description = "目标货币代码")
    private String toCurrency;

    @Schema(description = "汇率（6 位小数）")
    private BigDecimal rate;

    @Schema(description = "生效日期")
    private LocalDate effectiveDate;

    @Schema(description = "失效日期，NULL 表示当前有效")
    private LocalDate expiredDate;

    @Schema(description = "是否当前有效：1=是 0=否")
    private Integer isCurrent;

    @Schema(description = "备注")
    private String remark;

    @Schema(description = "创建人昵称")
    private String creatorName;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

}
