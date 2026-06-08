package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 海柜 Check-in 操作台入参
 * - keyword 支持：车牌号/柜号/预约号（APTxxx）
 */
@Data
public class YmsContainerCheckInReqVO {

    @NotNull(message = "仓库不能为空")
    private Long warehouseId;

    @NotBlank(message = "请输入车牌/柜号/预约号")
    private String keyword;

    private String plateNo;
    private String containerNo;
    private String aptNo;

    private String driverName;
    private String driverPhone;
    private String idCardNo;

    /** 备注（可选） */
    private String remark;
    /** 现场照片 URL（JSON 数组字符串） */
    private String photoUrls;
}

