package cn.iocoder.yudao.module.base.controller.admin.country.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Schema(description = "国家多语言项")
@Data
public class CountryTranslationItemVO {

    @Schema(description = "语言代码", example = "zh")
    private String langCode;

    @Schema(description = "国家名称翻译")
    private String value;

}
