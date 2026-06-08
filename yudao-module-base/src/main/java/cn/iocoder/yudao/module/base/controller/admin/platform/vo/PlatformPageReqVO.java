package cn.iocoder.yudao.module.base.controller.admin.platform.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Schema(description = "管理后台 - 平台分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class PlatformPageReqVO extends PageParam {

    @Schema(description = "关键字，模糊匹配 code、name_en")
    private String keyword;

    @Schema(description = "平台类型，字典 PLATFORM_TYPE")
    private String typeCode;

    @Schema(description = "状态：0=正常 1=停用")
    private Integer status;

}
