package cn.iocoder.yudao.module.wms.controller.admin.inventory.vo;

import lombok.Data;

import java.util.List;

@Data
public class WmsLocationVisualizationRespVO {

    private Long id;
    private Long zoneId;
    private String zoneName;
    private String locationCode;
    private String rowNo;
    private String columnNo;
    private Integer capacity;
    private Integer currentQty;
    private Integer remainingCapacity;
    private String status;
    private Integer occupancyPercent;
    private String occupancyLevel;
    private List<WmsLocationDestinationStatRespVO> destinationStats;

}
