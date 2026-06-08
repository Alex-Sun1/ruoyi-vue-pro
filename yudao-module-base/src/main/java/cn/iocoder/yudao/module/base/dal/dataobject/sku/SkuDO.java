package cn.iocoder.yudao.module.base.dal.dataobject.sku;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;

import java.math.BigDecimal;

@TableName("mdm_sku")
@KeySequence("mdm_sku_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SkuDO extends TenantBaseDO {

    @TableId
    private Long id;

    private Long clientId;

    private String skuCode;

    private String skuName;

    private String skuNameEn;

    private String barcode;

    private String unit;

    private BigDecimal lengthCm;

    private BigDecimal widthCm;

    private BigDecimal heightCm;

    private BigDecimal weightKg;

    private BigDecimal volumeCbm;

    private BigDecimal packageLengthCm;

    private BigDecimal packageWidthCm;

    private BigDecimal packageHeightCm;

    private BigDecimal packageWeightKg;

    private Integer isFragile;

    private Integer isLiquid;

    private Integer isBattery;

    private Integer isMagnetic;

    private Integer isDangerous;

    private Integer isOversize;

    private Long defaultPkgId;

    private String declaredNameCn;

    private String declaredNameEn;

    private String hsCode;

    private BigDecimal declaredValue;

    private String declaredCurrency;

    private String originCountryCode;

    private String imageUrl;

    private String brand;

    private String model;

    private String color;

    private String sizeSpec;

    private Integer status;

    private String remark;

}
