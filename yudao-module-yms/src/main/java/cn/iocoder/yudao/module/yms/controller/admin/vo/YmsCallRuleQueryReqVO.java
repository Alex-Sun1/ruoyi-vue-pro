package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

@Data
public class YmsCallRuleQueryReqVO {

    private Long warehouseId;
    private String taskType;
    private String dockType;
    private Integer enabled;
    private String ruleName;
}
