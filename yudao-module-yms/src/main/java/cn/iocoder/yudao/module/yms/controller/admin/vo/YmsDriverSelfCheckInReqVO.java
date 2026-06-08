package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 司机自助 Check-in BO（H5 公开页面，无需登录）
 * 司机扫仓库二维码后在手机上填写并提交。
 */
@Data
public class YmsDriverSelfCheckInReqVO {

    /** 租户ID，由 QR 码链接携带，用于公开接口的租户上下文切换 */
    @NotBlank(message = "租户ID不能为空")
    private String tenantId;

    @NotNull(message = "仓库不能为空")
    private Long warehouseId;

    /** 海柜号或车厢号，用于匹配关联任务 */
    @NotBlank(message = "柜号/车厢号不能为空")
    private String objectNo;

    /** 堆场位编码（司机自报停在哪里，必填） */
    @NotBlank(message = "堆场位不能为空")
    private String positionCode;

    /** 司机手机号（必填，用于身份核验） */
    @NotBlank(message = "司机手机号不能为空")
    private String driverPhone;

    /** 司机姓名（可选） */
    private String driverName;

    /** 现场照片 URL（JSON 数组，司机自拍上传） */
    private String photoUrls;
}
