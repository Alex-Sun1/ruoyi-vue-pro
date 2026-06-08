package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.common.pojo.PageParam;

@Data
@EqualsAndHashCode(callSuper = true)
public class YmsYardPositionQueryReqVO extends PageParam {

    private Long warehouseId;
    private Long zoneId;
    private String positionCode;
    private String positionType;
    private String positionStatus;
    private String occupiedObjectNo;
}
