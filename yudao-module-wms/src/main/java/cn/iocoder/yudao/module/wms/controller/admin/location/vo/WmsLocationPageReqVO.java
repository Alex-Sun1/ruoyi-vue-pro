package cn.iocoder.yudao.module.wms.controller.admin.location.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class WmsLocationPageReqVO extends PageParam {

    private Long warehouseId;
    private Long zoneId;
    private String zoneName;
    private String locationCode;
    private String status;

}
