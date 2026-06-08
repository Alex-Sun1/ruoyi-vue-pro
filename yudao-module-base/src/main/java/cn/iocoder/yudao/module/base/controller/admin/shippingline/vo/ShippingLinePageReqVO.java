package cn.iocoder.yudao.module.base.controller.admin.shippingline.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Schema(description = "管理后台 - 船司分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class ShippingLinePageReqVO extends PageParam {

    @Schema(description = "关键字，模糊 code / name_en / name_abbr")
    private String keyword;

    @Schema(description = "注册国家代码")
    private String countryCode;

    @Schema(description = "状态：0正常 1停用")
    private Integer status;

}
