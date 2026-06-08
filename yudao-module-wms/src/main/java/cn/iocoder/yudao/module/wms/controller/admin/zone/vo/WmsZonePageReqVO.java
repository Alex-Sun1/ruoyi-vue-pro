package cn.iocoder.yudao.module.wms.controller.admin.zone.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class WmsZonePageReqVO extends PageParam {

    private Long warehouseId;
    private String zoneName;
    private String zoneType;
    private String storageMethod;
    private String status;

}
