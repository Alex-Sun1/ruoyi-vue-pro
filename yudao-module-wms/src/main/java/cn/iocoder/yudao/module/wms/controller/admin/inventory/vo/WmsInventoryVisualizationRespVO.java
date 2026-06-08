package cn.iocoder.yudao.module.wms.controller.admin.inventory.vo;

import lombok.Data;

import java.util.List;

@Data
public class WmsInventoryVisualizationRespVO {

    private Long warehouseId;
    private String warehouseCode;
    private String warehouseName;
    private Integer usedPalletCount;
    private Integer totalCapacity;
    private Integer locationCount;
    private Integer occupancyPercent;
    private List<WmsZoneVisualizationRespVO> zones;

}
