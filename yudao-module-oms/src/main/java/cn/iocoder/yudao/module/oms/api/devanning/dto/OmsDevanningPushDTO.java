package cn.iocoder.yudao.module.oms.api.devanning.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

@Data
public class OmsDevanningPushDTO {
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
    private BigDecimal totalBoxQty;
    private BigDecimal totalWeight;
    private BigDecimal totalCbm;
}
