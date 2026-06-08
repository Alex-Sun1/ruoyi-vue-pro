package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class YmsInternalTaskAssignReqVO {

    @NotNull(message = "任务ID不能为空")
    private Long id;

    @NotNull(message = "执行者类型不能为空")
    private String executorType;

    private Long executorId;
    private String executorName;
}
