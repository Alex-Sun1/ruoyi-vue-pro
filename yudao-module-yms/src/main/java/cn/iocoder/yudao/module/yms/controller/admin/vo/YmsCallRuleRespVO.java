package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Data
public class YmsCallRuleRespVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private Long id;
    private String ruleName;
    private Long warehouseId;
    private String warehouseName;
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
    private Date createTime;

    private List<YmsCallRuleConditionRespVO> conditions;
    private List<YmsCallRuleSortRespVO> sorts;
}
