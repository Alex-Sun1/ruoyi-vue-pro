package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsAppointmentRuleDO;

import java.util.List;

@Data
public class YmsAppointmentRuleAddReqVO {

    @NotBlank(message = "规则名称不能为空")
    private String ruleName;

    @NotNull(message = "仓库不能为空")
    private Long warehouseId;

    private String businessType;
    private String vehicleSource;
    private String dockType;
    private String customerLevel;

    @NotNull(message = "最少提前预约天数不能为空")
    private Integer advanceDaysMin;

    @NotNull(message = "最多提前预约天数不能为空")
    private Integer advanceDaysMax;

    private Integer cancelDeadlineMinutes;
    private Integer lateGraceMinutes;
    private Integer noShowMinutes;
    private Integer autoConfirm;
    private Integer holidayFlag;

    private Integer enabled;
    private Integer sortOrder;
    private String remark;

    @Valid
    private List<YmsAppointmentRuleSlotReqVO> slots;
}
