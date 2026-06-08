package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsCallRuleDO;

import java.util.List;

@Data
public class YmsCallRuleAddReqVO {

    @NotBlank(message = "规则名称不能为空")
    private String ruleName;

    @NotNull(message = "仓库不能为空")
    private Long warehouseId;

    @NotBlank(message = "任务类型不能为空")
    private String taskType;

    private String dockType;

    private Integer wmsReadyRequired;
    private Integer appointmentRequired;
    private Integer allowManualInsert;
    private Integer autoCallEnabled;
    private Integer requireDispatchConfirm;
    private Integer maxCallCount;
    private Integer callTimeoutMinutes;

    private Integer enabled;
    private Integer sortOrder;
    private String remark;

    @Valid
    private List<YmsCallRuleConditionReqVO> conditions;

    @Valid
    private List<YmsCallRuleSortReqVO> sorts;
}
