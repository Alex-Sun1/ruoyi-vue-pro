package cn.iocoder.yudao.module.base.controller.admin.country.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

@Schema(description = "管理后台 - 国家新增/修改 Request VO")
@Data
public class CountrySaveReqVO {

    @Schema(description = "编号", example = "1")
    private Long id;

    @Schema(description = "国家代码 ISO 3166-1 alpha-2")
    @NotBlank(message = "国家代码不能为空")
    private String code;

    @Schema(description = "英文名称")
    @NotBlank(message = "英文名称不能为空")
    private String nameEn;

    @Schema(description = "电话区号")
    private String phoneCode;

    @Schema(description = "默认货币代码")
    private String currencyCode;

    @Schema(description = "默认时区代码")
    private String timezoneDefault;

    @Schema(description = "是否开通：1=已开通 0=未开通")
    @NotNull(message = "是否开通不能为空")
    private Integer isActive;

    @Schema(description = "排序")
    @NotNull(message = "排序不能为空")
    private Integer sortOrder;

    @Schema(description = "多语言名称，fieldName 固定 name")
    private List<CountryTranslationItemVO> translations;

}
