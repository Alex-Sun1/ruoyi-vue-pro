package cn.iocoder.yudao.module.base.controller.admin.language.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Schema(description = "管理后台 - 启用语言精简 Response VO")
@Data
public class LanguageSimpleRespVO {

    @Schema(description = "语言代码")
    private String langCode;

    @Schema(description = "英文名称")
    private String nameEn;

    @Schema(description = "本地名称")
    private String nameNative;

}
