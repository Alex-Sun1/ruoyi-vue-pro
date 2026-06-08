package cn.iocoder.yudao.module.base.dal.dataobject.sku;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;

@TableName("mdm_sku_default_fee")
@KeySequence("mdm_sku_default_fee_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SkuDefaultFeeDO extends TenantBaseDO {

    @TableId
    private Long id;

    private Long skuId;

    private String feeCode;

}
