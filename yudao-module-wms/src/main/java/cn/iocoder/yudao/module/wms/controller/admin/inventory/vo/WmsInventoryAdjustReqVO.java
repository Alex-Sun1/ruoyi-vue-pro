package cn.iocoder.yudao.module.wms.controller.admin.inventory.vo;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class WmsInventoryAdjustReqVO {

    @NotNull(message = "库存记录不能为空")
    private Long inventoryId;
    private Integer deltaAvailableBoxQty;
    private Integer deltaLockedBoxQty;
    private Integer deltaExceptionBoxQty;
    private String remark;

}
