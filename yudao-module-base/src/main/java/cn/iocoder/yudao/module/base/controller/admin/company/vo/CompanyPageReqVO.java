package cn.iocoder.yudao.module.base.controller.admin.company.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Schema(description = "管理后台 - 主体分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class CompanyPageReqVO extends PageParam {

    @Schema(description = "关键字，模糊 company_code / company_name")
    private String keyword;

    @Schema(description = "状态")
    private Integer status;

    @Schema(description = "国家代码")
    private String countryCode;

    @Schema(description = "结算货币代码")
    private String currencyCode;

    @Schema(description = "时区（IANA标准）")
    private String timezone;

}
