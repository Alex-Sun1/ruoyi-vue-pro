package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.common.pojo.PageParam;

@Data
@EqualsAndHashCode(callSuper = true)
public class YmsAppointmentQueryReqVO extends PageParam {
    private Long warehouseId;
    private String aptDate;
    private String status;
    private String plateNo;
    private String driverName;
    private String containerNo;
    private String taskType;
}
