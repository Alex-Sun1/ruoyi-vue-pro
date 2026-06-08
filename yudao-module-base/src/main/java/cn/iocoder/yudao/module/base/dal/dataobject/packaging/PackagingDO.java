package cn.iocoder.yudao.module.base.dal.dataobject.packaging;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;

import java.math.BigDecimal;

@TableName("mdm_packaging")
@KeySequence("mdm_packaging_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PackagingDO extends TenantBaseDO {

    @TableId
    private Long id;

    private String pkgCode;

    private String pkgName;

    private Integer pkgType;

    private Integer sourceType;

    private Long clientId;

    /** JSON 数组字符串，如 [9001,9002] */
    private String warehouseIds;

    private BigDecimal pkgLength;

    private BigDecimal pkgWidth;

    private BigDecimal pkgHeight;

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

}
