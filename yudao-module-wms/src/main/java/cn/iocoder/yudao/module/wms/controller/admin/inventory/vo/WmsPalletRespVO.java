package cn.iocoder.yudao.module.wms.controller.admin.inventory.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Date;

@Data
public class WmsPalletRespVO {

    private Long id;
    private Long companyId;
    private Long warehouseId;
    private String warehouseCode;
    private String warehouseName;
    private String palletNo;
    private String palletType;
    private String businessTypeName;
    private String containerNo;
    private String groupDestination;
    private Long cargoOrderId;
    private String cargoOrderNo;
    private Long shipmentId;
    private String shipmentCode;
    private Long zoneId;
    private String zoneCode;
    private String zoneName;
    private Long locationId;
    private String locationCode;
    private Integer totalBoxQty;
    private Integer availableBoxQty;
    private Integer lockedBoxQty;
    private Integer exceptionBoxQty;
    private BigDecimal weight;
    private BigDecimal cbm;
    private String palletStatus;
    private Date inboundTime;
    private Integer orderCount;
    private Integer shipmentCount;
    private String remark;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;

}
