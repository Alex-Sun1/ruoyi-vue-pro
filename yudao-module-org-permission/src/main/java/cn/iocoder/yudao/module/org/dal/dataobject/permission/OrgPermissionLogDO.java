package cn.iocoder.yudao.module.org.dal.dataobject.permission;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;

@TableName("org_permission_log")
@KeySequence("org_permission_log_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrgPermissionLogDO extends TenantBaseDO {

    @TableId
    private Long id;

    private Long roleId;

    private String action;

    private String beforeValue;

    private String afterValue;

    private Long operatorUserId;

    private String operatorName;

    private String remark;

}
