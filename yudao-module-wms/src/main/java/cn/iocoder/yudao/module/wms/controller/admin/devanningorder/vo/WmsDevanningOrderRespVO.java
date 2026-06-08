package cn.iocoder.yudao.module.wms.controller.admin.devanningorder.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

@Data
public class WmsDevanningOrderRespVO {

    private Long id;
    private Long companyId;
    private Long warehouseId;
    private Long bizRootId;
    private String devanningNo;
    private Long sourceOrderId;
    private String sourceOrderNo;
    private String sourceOrderType;
    private String containerNo;
    private Long customerId;
    private String customerName;
    private Long channelId;
    private String channelName;
    private Long customerServiceId;
    private String customerServiceName;
    private Date etaWarehouseTime;
    private Date pickupTime;
    private Date actualArrivalTime;
    private Date plannedDevanningTime;
    private Date devanningStartTime;
    private Date devanningFinishTime;
    private Long dockId;
    private String dockCode;
    private Date dockAssignTime;
    private String devanningMethod;
    private String devanningRemark;
    private Integer plannedTruckQty;
    private BigDecimal plannedCbm;
    private BigDecimal totalBoxQty;
    private BigDecimal totalWeight;
    private BigDecimal totalCbm;
    private BigDecimal inboundedBoxQty;
    private Integer exceptionFlag;
    private Integer exceptionCount;
    private String attachmentUrls;
    private String status;
    private Integer version;
    private String remark;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    private List<WmsDevanningOrderTraceRespVO> traces;

}
