package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class YmsCheckOutReqVO {

    @NotNull(message = "仓库不能为空")
    private Long warehouseId;

    @NotBlank(message = "请输入车牌/柜号/车厢号")
    private String keyword;

    /** WARN 时是否确认强制离场 */
    private Boolean confirmed;

    /** 离场车牌（未填则沿用入场/资源车牌） */
    private String plateNo;
    private String driverName;
    private String driverPhone;
    private String idCardNo;
    /** 离场现场照片 URL（JSON 数组） */
    private String photoUrls;

    private String remark;
}
