package cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo;

import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanApplyRuleReqVO;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 快速配置 应用分组规则Bo
 */
@Data
public class InboundPlanApplyRuleReqVO {

    @NotNull(message = "规则ID不能为空")
    private Long ruleId;
}
