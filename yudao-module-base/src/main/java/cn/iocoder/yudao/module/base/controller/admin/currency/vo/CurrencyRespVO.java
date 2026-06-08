package cn.iocoder.yudao.module.base.controller.admin.currency.vo;

import cn.iocoder.yudao.module.base.controller.admin.common.vo.BaseTranslationItemVO;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Schema(description = "管理后台 - 币种 Response VO")
@Data
public class CurrencyRespVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "币种代码")
    private String code;

    @Schema(description = "英文名称")
    private String nameEn;

    @Schema(description = "当前语言名称")
    private String nameDisplay;

    @Schema(description = "货币符号")
    private String symbol;

    @Schema(description = "小数位数 0-4")
    private Integer decimalPlaces;

    @Schema(description = "是否基准货币：1=是 0=否")
    private Integer isBase;

    @Schema(description = "状态：0=正常 1=停用")
    private Integer status;

    @Schema(description = "排序")
    private Integer sortOrder;

    @Schema(description = "多语言名称（详情）")
    private List<BaseTranslationItemVO> translations;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

}
