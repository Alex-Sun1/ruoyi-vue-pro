package cn.iocoder.yudao.module.base.controller.admin.zipcode.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Schema(description = "管理后台 - 邮编补全 Response VO")
@Data
public class ZipCodeLookupRespVO {

    @Schema(description = "州省代码")
    private String stateCode;

    @Schema(description = "州省名称（英文）")
    private String stateName;

    @Schema(description = "城市名称")
    private String cityName;

}
