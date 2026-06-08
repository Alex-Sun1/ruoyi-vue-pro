package cn.iocoder.yudao.module.oms.controller.admin.preoutbound.vo;

import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

@Data
public class PreOutboundPageReqVO {
    private String keyword;
    private String preOutboundNo;
    private String cargoOrderNo;
    private String containerNo;
    private String shipmentCodes;
    private String preOutboundStatus;
    private String outboundDirection;
    /** 支持逗号分隔多选 */
    private String outboundWarehouseId;
    private String customerName;
    private String appointmentNo;
    private String deliveryTruck;

    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date beginReadyTime;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date endReadyTime;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date beginCreateTime;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date endCreateTime;
}
