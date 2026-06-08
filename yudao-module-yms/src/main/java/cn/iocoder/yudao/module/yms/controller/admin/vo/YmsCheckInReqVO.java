package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class YmsCheckInReqVO {

    @NotNull(message = "仓库不能为空")
    private Long warehouseId;

    @NotBlank(message = "车牌号不能为空")
    private String plateNo;

    private String driverName;
    private String driverPhone;
    private String idCardNo;
    private String containerNo;
    private String trailerNo;
    /** 车辆来源：SUPPLIER_TRUCK/RENTED_TRAILER/OWN_TRAILER/TEMP_TRUCK */
    private String vehicleSource;
    /** 签到类型：CONTAINER/TRUCK_TRAILER（不传则按 taskType 推断） */
    private String checkInType;
    private String taskType;
    /** 关联预约单（可选） */
    private Long aptId;
    /** 备注（可选） */
    private String remark;
}
