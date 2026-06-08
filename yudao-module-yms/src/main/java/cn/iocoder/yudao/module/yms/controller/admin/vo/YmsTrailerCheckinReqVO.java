package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * 装车司机 H5 预登记 BO（公开接口，无需登录）
 */
@Data
public class YmsTrailerCheckinReqVO {

    @NotBlank(message = "提货号不能为空")
    private String pickupNo;

    @NotBlank(message = "司机电话不能为空")
    private String driverPhone;

    @NotBlank(message = "司机驾照号码不能为空")
    private String driverLicenseNo;

    @NotBlank(message = "车厢号不能为空")
    private String trailerNo;
}
