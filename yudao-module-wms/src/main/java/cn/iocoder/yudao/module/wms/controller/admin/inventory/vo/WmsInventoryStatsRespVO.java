package cn.iocoder.yudao.module.wms.controller.admin.inventory.vo;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class WmsInventoryStatsRespVO {

    private Long inventoryCount;
    private Long palletCount;
    private Long totalBoxQty;
    private Long availableBoxQty;
    private Long lockedBoxQty;
    private Long exceptionBoxQty;
    private BigDecimal totalWeight;
    private BigDecimal totalCbm;

}
