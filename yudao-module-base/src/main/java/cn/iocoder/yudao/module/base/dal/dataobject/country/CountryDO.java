package cn.iocoder.yudao.module.base.dal.dataobject.country;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;



@TableName("base_country")
@KeySequence("base_country_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CountryDO extends TenantBaseDO {

    @TableId
    private Long id;

    private String code;

    private String nameEn;

    private String phoneCode;

    private String currencyCode;

    private String timezoneDefault;

    private Integer isActive;

    private Integer sortOrder;

}
