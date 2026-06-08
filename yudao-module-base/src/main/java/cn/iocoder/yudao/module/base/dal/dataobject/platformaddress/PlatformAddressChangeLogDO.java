package cn.iocoder.yudao.module.base.dal.dataobject.platformaddress;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;

@TableName("base_platform_address_change_log")
@KeySequence("base_platform_address_change_log_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PlatformAddressChangeLogDO extends TenantBaseDO {

    @TableId
    private Long id;

    private Long platformAddressId;

    private String changeType;

    private String beforeValue;

    private String afterValue;

    private String changeReason;

    private String operatorName;

}
