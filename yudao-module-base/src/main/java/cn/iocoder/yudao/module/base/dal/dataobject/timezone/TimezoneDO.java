package cn.iocoder.yudao.module.base.dal.dataobject.timezone;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;



@TableName("base_timezone")
@KeySequence("base_timezone_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TimezoneDO extends TenantBaseDO {

    @TableId
    private Long id;

    private String tzCode;

    private String nameEn;

    private String utcOffset;

    private String countryCode;

    private Integer isDst;

    private Integer status;

    private Integer sortOrder;

}
