package cn.iocoder.yudao.module.base.controller.admin.exchangerate.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;

import static cn.iocoder.yudao.framework.common.util.date.DateUtils.FORMAT_YEAR_MONTH_DAY;

@Schema(description = "管理后台 - 汇率分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class ExchangeRatePageReqVO extends PageParam {

    @Schema(description = "源货币代码")
    private String fromCurrency;

    @Schema(description = "目标货币代码")
    private String toCurrency;

    @Schema(description = "生效日期起")
    @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY)
    private LocalDate effectiveDateStart;

    @Schema(description = "生效日期止")
    @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY)
    private LocalDate effectiveDateEnd;

    @Schema(description = "是否当前有效：1=是 0=历史")
    private Integer isCurrent;

}
