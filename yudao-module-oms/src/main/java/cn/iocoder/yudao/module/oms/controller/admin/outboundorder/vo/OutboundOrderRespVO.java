package cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo;

import cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo.OutboundOrderRespVO;

import cn.idev.excel.annotation.ExcelIgnoreUnannotated;
import cn.idev.excel.annotation.ExcelProperty;
import lombok.Data;
import cn.iocoder.yudao.module.oms.dal.dataobject.outboundorder.OutboundOrderDO;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

@Data
@ExcelIgnoreUnannotated
public class OutboundOrderRespVO implements Serializable {
    private Long id;
    private Long bizRootId;
    private String bizRootIds;
    private Long cargoOrderId;
    private Integer cargoOrderCount;
    private Long preOutboundId;
    private String preOutboundNo;
    @ExcelProperty("出库订单号")
    private String outboundOrderNo;
    @ExcelProperty("货物订单号")
    private String cargoOrderNo;
    @ExcelProperty("状态")
    private String outboundStatus;
    @ExcelProperty("方向")
    private String outboundDirection;
    private Long outboundWarehouseId;
    @ExcelProperty("出库仓")
    private String outboundWarehouseName;
    @ExcelProperty("客户")
    private String customerName;
    @ExcelProperty("柜号")
    private String containerNo;
    private String shipmentCodes;
    private BigDecimal actualCartonQty;
    private BigDecimal actualPalletQty;
    private BigDecimal actualWeight;
    private BigDecimal actualCbm;
    private String deliveryMethod;
    private String appointmentStatus;
    private Date appointmentTime;
    private Date deliveryLfd;
    private String contactName;
    private String contactPhone;
    private String contactEmail;
    private String addressLine1;
    private String addressLine2;
    private String city;
    private String state;
    private String zipCode;
    private String country;
    private Long transferInWarehouseId;
    private String transferReason;
    private String transferMethod;
    private Date estimatedTransferTime;
    private Date estimatedArrivalTime;
    private String carrier;
    private String trackingNo;
    private Date actualOutboundTime;
    private Date actualSignedTime;
    private Date actualArrivalTime;
    private String podStatus;
    private Date podUploadTime;
    private Date completedTime;
    private String dispatchRemark;
    private String operationRemark;
    private String remark;
    private Date createTime;
}
