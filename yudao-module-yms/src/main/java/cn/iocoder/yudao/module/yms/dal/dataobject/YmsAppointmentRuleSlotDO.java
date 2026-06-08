package cn.iocoder.yudao.module.yms.dal.dataobject;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;

@Data
@EqualsAndHashCode(callSuper = false)
@TableName("yms_appointment_rule_slot")
public class YmsAppointmentRuleSlotDO implements Serializable {

        @TableId(value = "id")
    private Long id;

    private String tenantId;
    private Long ruleId;
    /** 星期 1=周一 ... 7=周日 */
    private Integer weekday;
    private String startTime;
    private String endTime;
    private Integer slotMinutes;
    private Integer capacity;
    private Integer enabled;
}
