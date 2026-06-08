package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsAppointmentDO;

@Data
public class YmsAppointmentEditReqVO {

    @NotNull(message = "ID不能为空")
    private Long id;

    private Long warehouseId;
    private String aptDate;
    private String aptSlot;
    private Long slotTemplateId;
    private String taskType;
    private String plateNo;
    private String driverName;
    private String driverPhone;
    private String containerNo;
    private String sourceOrderNo;
    private String remark;
}
