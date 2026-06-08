package cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo;

import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo.CargoGroupingRulePriorityReqVO;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class CargoGroupingRulePriorityReqVO {
    @NotNull(message = "规则ID不能为空")
    private Long id;
    @NotNull(message = "优先级不能为空")
    private Integer priority;
}
