package cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo;

import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

@Data
public class OutboundOrderPageReqVO {
    private String keyword;
    private String keywordField;
    private String outboundOrderNo;
    private String preOutboundNo;
    private String cargoOrderNo;
    private String containerNo;
    private String shipmentCodes;
    private String outboundStatus;
    private String outboundDirection;
    /** 支持逗号分隔多选 */
    private String outboundWarehouseId;
    private String outboundWarehouseName;
    private String customerName;
    private String appointmentStatus;
    private String podStatus;

    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date beginActualOutboundTime;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date endActualOutboundTime;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date beginCompletedTime;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date endCompletedTime;
}
