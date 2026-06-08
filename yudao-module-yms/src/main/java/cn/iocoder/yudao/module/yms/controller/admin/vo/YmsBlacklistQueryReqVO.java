package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.common.pojo.PageParam;

@Data
@EqualsAndHashCode(callSuper = true)
public class YmsBlacklistQueryReqVO extends PageParam {
    /** PLATE_NO / DRIVER_PHONE */
    private String targetType;
    /** 车牌号或司机电话 */
    private String targetValue;
    /** ACTIVE / EXPIRED / REMOVED */
    private String status;
}
