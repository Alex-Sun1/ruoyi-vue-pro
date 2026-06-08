package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.util.Date;

@Data
public class YmsAppointmentRespVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private Long id;
    private String aptNo;
    private Long warehouseId;
    private String warehouseName;
    private Long slotTemplateId;
    private String aptDate;
    private String aptSlot;
    private String taskType;
    private String plateNo;
    private String driverName;
    private String driverPhone;
    private String containerNo;
    private String sourceOrderNo;
    private String status;
    private Long yardTaskId;
    private String cancelReason;
    private String remark;
    private Date createTime;
}
