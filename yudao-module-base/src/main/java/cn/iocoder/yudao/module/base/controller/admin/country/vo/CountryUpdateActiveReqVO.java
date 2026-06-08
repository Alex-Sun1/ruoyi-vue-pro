package cn.iocoder.yudao.module.base.controller.admin.country.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Schema(description = "管理后台 - 国家开通/停用 Request VO")
@Data
public class CountryUpdateActiveReqVO {

    @Schema(description = "编号", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotNull(message = "id 不能为空")
    private Long id;

    @Schema(description = "是否开通：1=已开通 0=未开通", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotNull(message = "isActive 不能为空")
    private Integer isActive;

}
