package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class YmsCallRuleConditionReqVO {

    private Long id;

    @NotBlank(message = "条件字段不能为空")
    private String conditionField;

    @NotBlank(message = "运算符不能为空")
    private String operator;

    @NotBlank(message = "条件值不能为空")
    private String conditionValue;

    private Integer sortOrder;
}
