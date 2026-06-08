package cn.iocoder.yudao.module.base.controller.admin.zipcode.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Schema(description = "管理后台 - 邮编分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class ZipCodePageReqVO extends PageParam {

    @Schema(description = "zip")
    private String zip;

    @Schema(description = "countryCode")
    private String countryCode;

    @Schema(description = "stateCode")
    private String stateCode;

}
