package cn.iocoder.yudao.module.wms.controller.admin.inventory.vo;

import lombok.Data;

import java.util.List;

@Data
public class WmsZoneVisualizationRespVO {

    private Long zoneId;
    private String zoneName;
    private String zoneType;
    private String storageMethod;
    private String status;
    private Integer usedPalletCount;
    private Integer totalCapacity;
    private Integer locationCount;
    private Integer occupancyPercent;
    private List<WmsLocationVisualizationRespVO> locations;

}
