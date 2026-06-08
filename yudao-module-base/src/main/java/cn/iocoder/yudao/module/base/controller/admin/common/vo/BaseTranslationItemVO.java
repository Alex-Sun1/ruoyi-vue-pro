package cn.iocoder.yudao.module.base.controller.admin.common.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Schema(description = "多语言翻译项")
@Data
public class BaseTranslationItemVO {

    @Schema(description = "语言代码")
    private String langCode;

    @Schema(description = "翻译内容")
    private String value;

}
