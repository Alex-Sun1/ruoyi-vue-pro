package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsAppointmentDO;

@Data
public class YmsAppointmentAddReqVO {

    @NotNull(message = "仓库不能为空")
    private Long warehouseId;

    @NotBlank(message = "预约日期不能为空")
    private String aptDate;

    @NotBlank(message = "预约时段不能为空")
    private String aptSlot;

    private Long slotTemplateId;

    @NotBlank(message = "任务类型不能为空")
    private String taskType;

    /** 业务类型（未填时取 taskType） */
    private String businessType;
    /** 车辆来源 */
    private String vehicleSource;

    @NotBlank(message = "车牌号不能为空")
    private String plateNo;

    private String driverName;
    private String driverPhone;
    private String containerNo;
    private String sourceOrderNo;
    private String remark;
}
