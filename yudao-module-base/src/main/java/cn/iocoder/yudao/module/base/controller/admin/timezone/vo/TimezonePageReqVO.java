package cn.iocoder.yudao.module.base.controller.admin.timezone.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Schema(description = "管理后台 - 时区分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class TimezonePageReqVO extends PageParam {

    @Schema(description = "关键字，模糊匹配 tz_code、name_en")
    private String keyword;

    @Schema(description = "所属国家代码")
    private String countryCode;

    @Schema(description = "状态：0=正常 1=停用")
    private Integer status;

}
