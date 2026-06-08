package cn.iocoder.yudao.module.yms.dal.dataobject;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("yms_call_rule_condition")
public class YmsCallRuleConditionDO extends TenantBaseDO {

        @TableId(value = "id")
    private Long id;

    private Long ruleId;
    private String conditionField;
    private String operator;
    private String conditionValue;
    private Integer sortOrder;
}
