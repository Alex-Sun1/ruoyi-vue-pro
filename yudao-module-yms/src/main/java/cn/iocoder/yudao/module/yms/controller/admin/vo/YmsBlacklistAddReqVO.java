package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsBlacklistDO;

import java.util.Date;

@Data
public class YmsBlacklistAddReqVO {

    /** PLATE_NO / DRIVER_PHONE */
    @NotBlank(message = "拦截类型不能为空")
    private String targetType;

    @NotBlank(message = "拦截值不能为空")
    private String targetValue;

    @NotBlank(message = "加入原因不能为空")
    private String reason;

    private Date expireTime;
    private String remark;
}
