package cn.iocoder.yudao.module.org.dal.dataobject.pilot;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;

@TableName("org_scope_pilot_record")
@KeySequence("org_scope_pilot_record_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrgScopePilotRecordDO extends TenantBaseDO {

    @TableId
    private Long id;

    private String bizCode;

    private Long warehouseId;

    private String remark;

}
