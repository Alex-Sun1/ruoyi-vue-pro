package cn.iocoder.yudao.module.wms.controller.admin.inventory.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class WmsInventoryLockPageReqVO extends PageParam {

    private Long warehouseId;
    private Long shipmentId;
    private Long palletId;
    private String bizDocType;
    private String lockStatus;
    private String keyword;

}
