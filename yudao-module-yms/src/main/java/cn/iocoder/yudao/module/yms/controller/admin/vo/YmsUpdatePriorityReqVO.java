package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class YmsUpdatePriorityReqVO {

    @NotNull(message = "任务ID不能为空")
    private Long yardTaskId;

    @NotNull(message = "优先级不能为空")
    @Min(1)
    @Max(10)
    private Integer priority;
}
