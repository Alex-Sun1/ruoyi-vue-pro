package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class YmsAppointmentRuleSlotReqVO {

    private Long id;

    @NotNull(message = "星期不能为空")
    private Integer weekday;

    @NotBlank(message = "时段开始时间不能为空")
    private String startTime;

    @NotBlank(message = "时段结束时间不能为空")
    private String endTime;

    @NotNull(message = "时段粒度不能为空")
    @Min(value = 1, message = "时段粒度至少1分钟")
    private Integer slotMinutes;

    @NotNull(message = "容量不能为空")
    @Min(value = 1, message = "容量至少为1")
    private Integer capacity;

    private Integer enabled;
}
