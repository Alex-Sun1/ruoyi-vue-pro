package cn.iocoder.yudao.module.org.dal.dataobject.permission;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;

@TableName("org_role_org_scope")
@KeySequence("org_role_org_scope_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrgRoleOrgScopeDO extends TenantBaseDO {

    @TableId
    private Long id;

    private Long roleId;

    private String orgScope;

}
