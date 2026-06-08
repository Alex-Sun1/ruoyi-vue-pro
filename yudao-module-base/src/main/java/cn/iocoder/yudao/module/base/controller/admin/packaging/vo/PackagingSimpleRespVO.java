package cn.iocoder.yudao.module.base.controller.admin.packaging.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;

@Schema(description = "管理后台 - 包装精简 Response VO")
@Data
public class PackagingSimpleRespVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "包装编码")
    private String pkgCode;

    @Schema(description = "包装名称")
    private String pkgName;

    @Schema(description = "包装类型")
    private Integer pkgType;

    @Schema(description = "长")
    private BigDecimal length;

    @Schema(description = "宽")
    private BigDecimal width;

    @Schema(description = "高")
    private BigDecimal height;

    @Schema(description = "尺寸单位")
    private String dimensionUnit;

}
