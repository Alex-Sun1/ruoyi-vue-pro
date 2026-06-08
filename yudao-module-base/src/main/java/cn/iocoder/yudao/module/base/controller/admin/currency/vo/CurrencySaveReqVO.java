package cn.iocoder.yudao.module.base.controller.admin.currency.vo;

import cn.iocoder.yudao.module.base.controller.admin.common.vo.BaseTranslationItemVO;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

import java.util.List;

@Schema(description = "管理后台 - 币种新增/修改 Request VO")
@Data
public class CurrencySaveReqVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "币种代码（ISO 4217）")
    @NotBlank(message = "币种代码不能为空")
    @Pattern(regexp = "^[A-Z]{3}$", message = "币种代码须为 3 位大写字母")
    private String code;

    @Schema(description = "英文名称")
    @NotBlank(message = "英文名称不能为空")
    private String nameEn;

    @Schema(description = "货币符号")
    @NotBlank(message = "货币符号不能为空")
    private String symbol;

    @Schema(description = "小数位数 0-4")
    @NotNull(message = "小数位数不能为空")
    @Min(value = 0, message = "小数位数须在 0-4 之间")
    @Max(value = 4, message = "小数位数须在 0-4 之间")
    private Integer decimalPlaces;

    @Schema(description = "是否基准货币：1=是 0=否")
    @NotNull(message = "是否基准货币不能为空")
    private Integer isBase;

    @Schema(description = "状态：0=正常 1=停用（仅新增时可传）")
    private Integer status;

    @Schema(description = "排序")
    private Integer sortOrder;

    @Schema(description = "多语言名称")
    private List<BaseTranslationItemVO> translations;

}
