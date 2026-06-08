package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.common.pojo.PageParam;

@Data
@EqualsAndHashCode(callSuper = true)
public class YmsCheckInQueryReqVO extends PageParam {
    private Long warehouseId;
    private String checkInType;
    private String plateNo;
    private String driverName;
    private String checkResult;
    private String beginTime;
    private String endTime;
}
