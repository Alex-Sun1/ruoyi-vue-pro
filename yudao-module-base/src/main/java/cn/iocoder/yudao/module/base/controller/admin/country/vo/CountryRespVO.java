package cn.iocoder.yudao.module.base.controller.admin.country.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Schema(description = "管理后台 - 国家 Response VO")
@Data
public class CountryRespVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "国家代码")
    private String code;

    @Schema(description = "英文名称")
    private String nameEn;

    @Schema(description = "当前语言展示名")
    private String nameDisplay;

    @Schema(description = "电话区号")
    private String phoneCode;

    @Schema(description = "默认货币代码")
    private String currencyCode;

    @Schema(description = "默认时区代码")
    private String timezoneDefault;

    @Schema(description = "是否开通：1=已开通 0=未开通")
    private Integer isActive;

    @Schema(description = "排序")
    private Integer sortOrder;

    @Schema(description = "州/省数量")
    private Long stateProvinceCount;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

    @Schema(description = "多语言（详情可选）")
    private List<CountryTranslationItemVO> translations;

}
