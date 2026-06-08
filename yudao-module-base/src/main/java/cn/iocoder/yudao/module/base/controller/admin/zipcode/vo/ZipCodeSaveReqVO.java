package cn.iocoder.yudao.module.base.controller.admin.zipcode.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Schema(description = "管理后台 - 邮编新增/修改 Request VO")
@Data
public class ZipCodeSaveReqVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "所属国家代码")
    @NotBlank(message = "国家代码不能为空")
    private String countryCode;

    @Schema(description = "所属州省代码")
    private String stateCode;

    @Schema(description = "城市名称")
    @NotBlank(message = "城市名称不能为空")
    private String cityName;

    @Schema(description = "邮编")
    @NotBlank(message = "邮编不能为空")
    private String zip;

}
