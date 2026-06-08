package cn.iocoder.yudao.module.base.controller.admin.currency.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Schema(description = "管理后台 - 币种分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class CurrencyPageReqVO extends PageParam {

    @Schema(description = "关键字，模糊匹配 code、name_en")
    private String keyword;

    @Schema(description = "状态：0=正常 1=停用")
    private Integer status;

}
