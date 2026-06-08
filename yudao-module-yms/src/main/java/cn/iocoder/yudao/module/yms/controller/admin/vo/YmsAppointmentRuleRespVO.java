package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Data
public class YmsAppointmentRuleRespVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private Long id;
    private String ruleName;
    private Long warehouseId;
    private String warehouseName;

    private String businessType;
    private String vehicleSource;
    private String dockType;
    private String customerLevel;

    private Integer advanceDaysMin;
    private Integer advanceDaysMax;
    private Integer cancelDeadlineMinutes;
    private Integer lateGraceMinutes;
    private Integer noShowMinutes;
    private Integer autoConfirm;
    private Integer holidayFlag;

    private Integer enabled;
    private Integer sortOrder;
    private String remark;
    private Date createTime;

    private List<YmsAppointmentRuleSlotRespVO> slots;
}
