package cn.iocoder.yudao.module.base.controller.admin.i18n.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Schema(description = "管理后台 - 实体翻译项")
@Data
public class EntityTranslationRespVO {

    @Schema(description = "语言代码")
    private String langCode;

    @Schema(description = "字段名")
    private String fieldName;

    @Schema(description = "翻译值")
    private String value;

}
