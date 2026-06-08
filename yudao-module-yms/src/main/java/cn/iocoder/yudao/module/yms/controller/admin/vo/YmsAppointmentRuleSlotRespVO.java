package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

@Data
public class YmsAppointmentRuleSlotRespVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long ruleId;
    private Integer weekday;
    private String startTime;
    private String endTime;
    private Integer slotMinutes;
    private Integer capacity;
    private Integer enabled;
}
