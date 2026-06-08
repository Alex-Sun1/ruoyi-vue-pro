package cn.iocoder.yudao.module.base.dal.dataobject.exchangerate;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;

@TableName("base_exchange_rate")
@KeySequence("base_exchange_rate_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ExchangeRateDO extends TenantBaseDO {

    @TableId
    private Long id;

    private String fromCurrency;

    private String toCurrency;

    private BigDecimal rate;

    private LocalDate effectiveDate;

    private LocalDate expiredDate;

    private Integer isCurrent;

    private String remark;

}
