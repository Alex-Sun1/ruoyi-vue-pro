package cn.iocoder.yudao.module.base.controller.admin.timezone.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

@Schema(description = "管理后台 - 时区新增/修改 Request VO")
@Data
public class TimezoneSaveReqVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "时区代码，如 America/Los_Angeles")
    @NotBlank(message = "时区代码不能为空")
    private String tzCode;

    @Schema(description = "英文名称")
    @NotBlank(message = "英文名称不能为空")
    private String nameEn;

    @Schema(description = "UTC 偏移，如 UTC-8、UTC+5:30")
    @NotBlank(message = "UTC 偏移不能为空")
    @Pattern(regexp = "^UTC[+-]\\d{1,2}(:\\d{2})?$", message = "UTC 偏移格式不正确")
    private String utcOffset;

    @Schema(description = "所属国家代码，可空")
    private String countryCode;

    @Schema(description = "是否有夏令时：1=有 0=无")
    @NotNull(message = "是否夏令时不能为空")
    private Integer isDst;

    @Schema(description = "状态：0=正常 1=停用（仅新增时可传，编辑请用 update-status）")
    private Integer status;

    @Schema(description = "排序")
    private Integer sortOrder;

}
