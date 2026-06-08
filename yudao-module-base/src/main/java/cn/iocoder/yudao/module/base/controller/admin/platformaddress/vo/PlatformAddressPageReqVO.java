package cn.iocoder.yudao.module.base.controller.admin.platformaddress.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Schema(description = "管理后台 - 平台地址分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class PlatformAddressPageReqVO extends PageParam {

    @Schema(description = "关键字，模糊 address_code、name_en")
    private String keyword;

    @Schema(description = "平台 ID")
    private Long platformId;

    @Schema(description = "地址类型：1 FBA / 2 门店 / 3 配送中心 / 4 其他")
    private Integer addressType;

    @Schema(description = "国家代码")
    private String countryCode;

    @Schema(description = "州省代码")
    private String stateCode;

    @Schema(description = "状态：0=正常 1=停用")
    private Integer status;

}
