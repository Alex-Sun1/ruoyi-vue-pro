package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 装车 Check-in 操作台入参
 */
@Data
public class YmsLoadingCheckInReqVO {

    @NotNull(message = "仓库不能为空")
    private Long warehouseId;

    @NotBlank(message = "请输入车牌号")
    private String plateNo;

    /** 车辆来源：SUPPLIER_TRUCK/RENTED_TRAILER/OWN_TRAILER/TEMP_TRUCK */
    @NotBlank(message = "车辆来源不能为空")
    private String vehicleSource;

    /** 车厢号（租赁/自有车厢时建议填写；供应商车辆可不填） */
    private String trailerNo;

    private String driverName;
    private String driverPhone;
    private String idCardNo;

    /** 备注（可选） */
    private String remark;
    /** 现场照片 URL（JSON 数组字符串） */
    private String photoUrls;
}

