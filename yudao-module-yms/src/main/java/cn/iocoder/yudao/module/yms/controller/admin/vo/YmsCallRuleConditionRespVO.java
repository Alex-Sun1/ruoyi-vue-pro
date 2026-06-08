package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

@Data
public class YmsCallRuleConditionRespVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long ruleId;
    private String conditionField;
    private String operator;
    private String conditionValue;
    private Integer sortOrder;
}
