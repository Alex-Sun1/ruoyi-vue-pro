package cn.iocoder.yudao.module.base.controller.admin.i18n.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

@Schema(description = "管理后台 - 实体翻译批量保存 Request VO")
@Data
public class EntityTranslationSaveBatchReqVO {

    @Schema(description = "实体类型", requiredMode = Schema.RequiredMode.REQUIRED, example = "country")
    @NotBlank(message = "entityType 不能为空")
    private String entityType;

    @Schema(description = "实体编号", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotNull(message = "entityId 不能为空")
    private Long entityId;

    @Schema(description = "翻译项")
    @NotEmpty(message = "items 不能为空")
    @Valid
    private List<Item> items;

    @Data
    public static class Item {

        @Schema(description = "语言代码", requiredMode = Schema.RequiredMode.REQUIRED)
        @NotBlank(message = "langCode 不能为空")
        private String langCode;

        @Schema(description = "字段名", requiredMode = Schema.RequiredMode.REQUIRED)
        @NotBlank(message = "fieldName 不能为空")
        private String fieldName;

        @Schema(description = "翻译值", requiredMode = Schema.RequiredMode.REQUIRED)
        @NotBlank(message = "value 不能为空")
        private String value;
    }

}
