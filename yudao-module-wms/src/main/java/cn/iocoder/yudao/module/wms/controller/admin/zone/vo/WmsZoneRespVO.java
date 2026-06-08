package cn.iocoder.yudao.module.wms.controller.admin.zone.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class WmsZoneRespVO {

    private Long id;
    private Long companyId;
    private Long warehouseId;
    private String warehouseCode;
    private String warehouseName;
    private String zoneName;
    private String storageMethod;
    private String zoneType;
    private Integer allowMixedStorage;
    private Integer maxMixedQty;
    private String status;
    private String remark;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;

}
