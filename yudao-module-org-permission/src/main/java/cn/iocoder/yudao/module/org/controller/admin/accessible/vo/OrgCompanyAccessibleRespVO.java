package cn.iocoder.yudao.module.org.controller.admin.accessible.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Schema(description = "管理后台 - 当前用户可见主体")
@Data
public class OrgCompanyAccessibleRespVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "主体编码")
    private String companyCode;

    @Schema(description = "主体名称")
    private String companyName;

    @Schema(description = "英文名称")
    private String companyNameEn;

    @Schema(description = "状态")
    private Integer status;

}
