package cn.iocoder.yudao.module.base.dal.dataobject.currency;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;



@TableName("base_currency")
@KeySequence("base_currency_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CurrencyDO extends TenantBaseDO {

    @TableId
    private Long id;

    private String code;

    private String nameEn;

    private String symbol;

    private Integer decimalPlaces;

    private Integer isBase;

    private Integer status;

    private Integer sortOrder;

}
