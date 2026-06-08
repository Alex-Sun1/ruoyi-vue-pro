package cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo;

import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo.CargoGroupingRuleTestRespVO;

import lombok.Data;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

@Data
public class CargoGroupingRuleTestRespVO implements Serializable {
    private Boolean matched;
    private Long ruleId;
    private String ruleName;
    private Integer priority;
    private Integer isDefault;
    private String groupKey;
    private String message;
    private List<ConditionDetail> conditionDetails = new ArrayList<>();

    @Data
    public static class ConditionDetail implements Serializable {
        private String field;
        private Object fieldValue;
        private String op;
        private Object expectedValue;
        private Boolean hit;
    }
}
