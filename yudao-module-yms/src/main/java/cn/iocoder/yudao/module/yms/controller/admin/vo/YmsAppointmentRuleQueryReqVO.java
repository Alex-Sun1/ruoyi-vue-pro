package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

@Data
public class YmsAppointmentRuleQueryReqVO {

    private String ruleName;
    private Long warehouseId;
    private String businessType;
    private String vehicleSource;
    private Integer enabled;
}
