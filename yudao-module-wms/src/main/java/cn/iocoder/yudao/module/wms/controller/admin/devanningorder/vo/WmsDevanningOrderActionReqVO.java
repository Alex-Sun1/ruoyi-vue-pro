package cn.iocoder.yudao.module.wms.controller.admin.devanningorder.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

@Data
public class WmsDevanningOrderActionReqVO {

    private Date pickupTime;
    private Date actualArrivalTime;
    private Date plannedDevanningTime;
    private Date devanningStartTime;
    private Date devanningFinishTime;
    private BigDecimal inboundedBoxQty;
    private String remark;

}
