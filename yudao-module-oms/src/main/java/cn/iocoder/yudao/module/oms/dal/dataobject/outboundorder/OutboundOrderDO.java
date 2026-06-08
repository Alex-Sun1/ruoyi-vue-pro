package cn.iocoder.yudao.module.oms.dal.dataobject.outboundorder;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo.OutboundOrderRespVO;

import java.math.BigDecimal;
import java.util.Date;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("oms_outbound_order")
public class OutboundOrderDO extends TenantBaseDO {

    @TableId(type = IdType.ASSIGN_ID)
    private Long id;
    private Long bizRootId;
    private String bizRootIds;
    private Long cargoOrderId;
    private String cargoOrderNo;
    private Long preOutboundId;
    private String preOutboundNo;
    /** 关联货物订单数（1:N明细由 oms_outbound_order_item 管理） */
    private Integer cargoOrderCount;
    private String outboundOrderNo;
    private String outboundStatus;
    private String outboundDirection;
    private Long outboundWarehouseId;
    private String outboundWarehouseName;
    private String customerName;
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
    private Long transferOutWarehouseId;
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
}
