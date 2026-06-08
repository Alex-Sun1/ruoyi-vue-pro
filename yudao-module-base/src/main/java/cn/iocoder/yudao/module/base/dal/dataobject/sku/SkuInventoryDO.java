package cn.iocoder.yudao.module.base.dal.dataobject.sku;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;

import java.math.BigDecimal;

@TableName("mdm_sku_inventory")
@KeySequence("mdm_sku_inventory_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SkuInventoryDO extends TenantBaseDO {

    @TableId
    private Long id;

    private Long skuId;

    private BigDecimal qtyOnHand;

}
