package cn.iocoder.yudao.module.base.controller.admin.packaging.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Schema(description = "管理后台 - 包装新增/修改 Request VO")
@Data
public class PackagingSaveReqVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "包装编码")
    @NotBlank(message = "包装编码不能为空")
    private String pkgCode;

    @Schema(description = "包装名称")
    @NotBlank(message = "包装名称不能为空")
    private String pkgName;

    @Schema(description = "包装类型 1-5")
    @NotNull(message = "包装类型不能为空")
    private Integer pkgType;

    @Schema(description = "来源类型 1-3")
    @NotNull(message = "来源类型不能为空")
    private Integer sourceType;

    @Schema(description = "关联客户 ID")
    private Long clientId;

    @Schema(description = "适用仓库 ID 列表，空=全部")
    private List<Long> warehouseIds;

    @Schema(description = "长")
    private BigDecimal length;

    @Schema(description = "宽")
    private BigDecimal width;

    @Schema(description = "高")
    private BigDecimal height;

    @Schema(description = "尺寸单位 CM/IN")
    private String dimensionUnit;

    @Schema(description = "皮重")
    private BigDecimal tareWeight;

    @Schema(description = "重量单位 KG/LB")
    private String weightUnit;

    @Schema(description = "最大承重")
    private BigDecimal maxLoadWeight;

    @Schema(description = "材质")
    private String material;

    @Schema(description = "包材 SKU")
    private String materialSku;

    @Schema(description = "单位成本")
    private BigDecimal unitCost;

    @Schema(description = "成本币种")
    private String costCurrency;

    @Schema(description = "是否定制 0/1")
    private Integer isCustom;

    @Schema(description = "是否默认 0/1")
    private Integer isDefault;

    @Schema(description = "是否需扫码 0/1")
    private Integer scanRequired;

    @Schema(description = "状态（仅新增时可传）")
    private Integer status;

    @Schema(description = "排序")
    private Integer sortOrder;

    @Schema(description = "备注")
    private String remark;

}
