package cn.iocoder.yudao.module.org.controller.admin.accessible.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Schema(description = "管理后台 - 当前用户可见仓库")
@Data
public class OrgWarehouseAccessibleRespVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "仓库编码")
    private String warehouseCode;

    @Schema(description = "仓库名称")
    private String warehouseName;

    @Schema(description = "主体编号")
    private Long companyId;

    @Schema(description = "主体名称")
    private String companyName;

    @Schema(description = "状态")
    private Integer status;

}
