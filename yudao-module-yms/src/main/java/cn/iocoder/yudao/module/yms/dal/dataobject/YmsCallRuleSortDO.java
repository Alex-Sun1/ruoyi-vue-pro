package cn.iocoder.yudao.module.yms.dal.dataobject;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("yms_call_rule_sort")
public class YmsCallRuleSortDO extends TenantBaseDO {

        @TableId(value = "id")
    private Long id;

    private Long ruleId;
    private String sortField;
    private String sortDirection;
    private Integer priorityOrder;
}
