package cn.iocoder.yudao.module.base.controller.admin.packaging.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Schema(description = "管理后台 - 包装 Response VO")
@Data
public class PackagingRespVO {

    private Long id;
    private String pkgCode;
    private String pkgName;
    private Integer pkgType;
    private Integer sourceType;
    private Long clientId;

    @Schema(description = "关联客户名称")
    private String clientName;

    @Schema(description = "适用仓库 ID")
    private List<Long> warehouseIds;

    @Schema(description = "适用仓库名称")
    private List<String> warehouseNames;

    private BigDecimal length;
    private BigDecimal width;
    private BigDecimal height;
    private String dimensionUnit;
    private BigDecimal tareWeight;
    private String weightUnit;
    private BigDecimal maxLoadWeight;
    private String material;
    private String materialSku;
    private BigDecimal unitCost;
    private String costCurrency;
    private Integer isCustom;
    private Integer isDefault;
    private Integer scanRequired;
    private Integer status;
    private Integer sortOrder;
    private String remark;
    private LocalDateTime createTime;

}
