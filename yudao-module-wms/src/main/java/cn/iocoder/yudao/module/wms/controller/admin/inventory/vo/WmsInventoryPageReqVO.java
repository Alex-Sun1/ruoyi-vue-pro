package cn.iocoder.yudao.module.wms.controller.admin.inventory.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class WmsInventoryPageReqVO extends PageParam {

    private Long warehouseId;
    private Long customerId;
    private Long cargoOrderId;
    private Long shipmentId;
    private String keyword;
    private String inventoryStatus;
    /** 是否包含已清空/零库存行，默认 false */
    private Boolean includeDepleted;

}
