package cn.iocoder.yudao.module.base.controller.admin.sku.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Schema(description = "管理后台 - SKU Response VO")
@Data
public class SkuRespVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "客户 ID")
    private Long clientId;

    @Schema(description = "客户名称")
    private String clientName;

    @Schema(description = "SKU 编码")
    private String skuCode;

    @Schema(description = "SKU 名称")
    private String skuName;

    @Schema(description = "英文名称")
    private String skuNameEn;

    @Schema(description = "条码")
    private String barcode;

    @Schema(description = "单位")
    private String unit;

    @Schema(description = "长(cm)")
    private BigDecimal lengthCm;

    @Schema(description = "宽(cm)")
    private BigDecimal widthCm;

    @Schema(description = "高(cm)")
    private BigDecimal heightCm;

    @Schema(description = "重量(kg)")
    private BigDecimal weightKg;

    @Schema(description = "体积(CBM)")
    private BigDecimal volumeCbm;

    @Schema(description = "包装长(cm)")
    private BigDecimal packageLengthCm;

    @Schema(description = "包装宽(cm)")
    private BigDecimal packageWidthCm;

    @Schema(description = "包装高(cm)")
    private BigDecimal packageHeightCm;

    @Schema(description = "包装重量(kg)")
    private BigDecimal packageWeightKg;

    @Schema(description = "易碎")
    private Integer isFragile;

    @Schema(description = "液体")
    private Integer isLiquid;

    @Schema(description = "带电")
    private Integer isBattery;

    @Schema(description = "带磁")
    private Integer isMagnetic;

    @Schema(description = "危险品")
    private Integer isDangerous;

    @Schema(description = "超大件")
    private Integer isOversize;

    @Schema(description = "默认包装 ID")
    private Long defaultPkgId;

    @Schema(description = "默认包装名称")
    private String defaultPkgName;

    @Schema(description = "默认费项代码")
    private List<String> defaultFeeCodes;

    @Schema(description = "申报名称(中)")
    private String declaredNameCn;

    @Schema(description = "申报名称(英)")
    private String declaredNameEn;

    @Schema(description = "HS 编码")
    private String hsCode;

    @Schema(description = "申报价值")
    private BigDecimal declaredValue;

    @Schema(description = "申报币种")
    private String declaredCurrency;

    @Schema(description = "原产国")
    private String originCountryCode;

    @Schema(description = "图片 URL")
    private String imageUrl;

    @Schema(description = "品牌")
    private String brand;

    @Schema(description = "型号")
    private String model;

    @Schema(description = "颜色")
    private String color;

    @Schema(description = "尺码规格")
    private String sizeSpec;

    @Schema(description = "状态")
    private Integer status;

    @Schema(description = "备注")
    private String remark;

    @Schema(description = "是否有库存")
    private Boolean hasStock;

    @Schema(description = "SKU 编码是否可编辑")
    private Boolean skuCodeEditable;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

}
