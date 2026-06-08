package cn.iocoder.yudao.module.wms.controller.admin.devanningorder.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

@Data
public class WmsDevanningOrderPushReqVO {

    private Long sourceOrderId;
    private String sourceOrderNo;
    private String sourceOrderType;
    private Long bizRootId;
    private Long companyId;
    private String containerNo;
    private Long customerId;
    private String customerName;
    private Long channelId;
    private String channelName;
    private Long customerServiceId;
    private String customerServiceName;
    private Long warehouseId;
    private Date etaWarehouseTime;
    private Date pickupTime;
    private String initialStatus;
    private BigDecimal totalBoxQty;
    private BigDecimal totalWeight;
    private BigDecimal totalCbm;

}
