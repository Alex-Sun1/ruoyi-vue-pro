package cn.iocoder.yudao.module.base.controller.admin.zipcode.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

@Schema(description = "管理后台 - 邮编 Response VO")
@Data
public class ZipCodeRespVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "邮编")
    private String zip;

    @Schema(description = "所属国家代码")
    private String countryCode;

    @Schema(description = "国家展示名")
    private String countryName;

    @Schema(description = "所属州省代码")
    private String stateCode;

    @Schema(description = "州省展示名")
    private String stateName;

    @Schema(description = "城市名称")
    private String cityName;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

}
