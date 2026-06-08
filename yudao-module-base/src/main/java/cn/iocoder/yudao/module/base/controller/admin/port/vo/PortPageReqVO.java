package cn.iocoder.yudao.module.base.controller.admin.port.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Schema(description = "管理后台 - 港口分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class PortPageReqVO extends PageParam {

    @Schema(description = "关键字，模糊 port_code / name_en")
    private String keyword;

    @Schema(description = "国家代码")
    private String countryCode;

    @Schema(description = "港口类型：1海港 2空港 3内陆港")
    private Integer portType;

    @Schema(description = "状态：0正常 1停用")
    private Integer status;

}
