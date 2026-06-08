package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.util.Date;

@Data
public class YmsBlacklistRespVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private Long id;
    /** PLATE_NO / DRIVER_PHONE */
    private String targetType;
    /** 车牌号或司机电话 */
    private String targetValue;
    private String reason;
    private Date blacklistTime;
    private Date expireTime;
    /** ACTIVE / EXPIRED / REMOVED */
    private String status;
    private Long operatorId;
    private String operatorName;
    private String remark;
    private Date createTime;
}
