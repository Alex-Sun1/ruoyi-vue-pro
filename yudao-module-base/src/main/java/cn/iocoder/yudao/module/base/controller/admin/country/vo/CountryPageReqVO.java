package cn.iocoder.yudao.module.base.controller.admin.country.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Schema(description = "管理后台 - 国家分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class CountryPageReqVO extends PageParam {

    @Schema(description = "关键字，模糊匹配 code、name_en")
    private String keyword;

    @Schema(description = "是否开通：1=已开通 0=未开通")
    private Integer isActive;

}
