package cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderRespVO;

import java.math.BigDecimal;
import java.util.Date;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("oms_cargo_order")
public class CargoOrderDO extends TenantBaseDO {

    @TableId
    private Long id;

    private Long bizRootId;
    private Long companyId;

    // 货件汇总聚合（服务层回写）
    private String shipmentCodes;
    private String poNos;
    private String marks;

    // 订单基础
    private String cargoOrderNo;
    private String externalOrderNo;
    private String orderSource;

    // 客户与业务
    private Long customerId;
    private String customerName;
    private Long businessTypeId;
    private String businessTypeName;
    private Long channelId;
    private String channelName;
    private Long platformId;
    private String platformName;
    private Long customerServiceId;
    private String customerServiceName;

    // 海柜与入库仓
    private Long containerOrderId;
    private String containerNo;
    private Long inboundWarehouseId;
    private String inboundWarehouseName;

    // 地址
    private String addressType;
    private String platformWarehouseCode;
    private String consigneeName;
    private String addressLine1;
    private String addressLine2;
    private String city;
    private String state;
    private String zipCode;
    private String country;
    private String contactName;
    private String contactPhone;
    private String contactEmail;

    // 快递
    private String parcelCarrierName;
    private String parcelTrackingNo;

    // 转仓
    private Integer transferFlag;
    private String transferWarehouseCode;

    /** 预报计量单位 BY_CARTON / BY_PALLET */
    private String forecastQtyUnit;

    // 预报货量
    private BigDecimal declaredCartonQty;
    private BigDecimal declaredPalletQty;
    private BigDecimal declaredPieceQty;
    private BigDecimal declaredWeight;
    private BigDecimal declaredCbm;

    // 实际货量
    private BigDecimal actualCartonQty;
    private BigDecimal actualPalletQty;
    private BigDecimal actualPieceQty;
    private BigDecimal actualWeight;
    private BigDecimal actualCbm;
    private String groupCode;

    private String weightUnit;
    private String volumeUnit;

    // 预出单与出单
    private Integer preOutboundFlag;
    private String preOutboundNo;
    private String preOutboundStatus;
    private Date preOutboundTime;
    private Date preOutboundConvertTime;
    private String outboundBatchNo;
    private String outboundOrderStatus;
    private Date outboundOrderTime;
    private String outboundDirection;
    private Long latestPreOutboundId;
    private Long latestOutboundOrderId;

    // 主状态
    private String orderStatus;
    private String fulfillmentStatus;

    // 并行状态
    private String appointmentStatus;
    private String podStatus;
    private String billingStatus;

    // 关键时间
    private Date earliestDwTime;
    private Date eta;
    private Date ata;
    private Date actualPickupTime;
    private Date actualArrivalTime;
    private Date devanningFinishTime;
    private Date actualInboundTime;
    private Date deliveryLfd;
    private Date deliveryAppointmentTime;
    private Date actualOutboundTime;
    private Date signedTime;
    private Date podUploadTime;
    private Date billingTime;
    private Date completedTime;

    // 异常摘要
    private Integer exceptionFlag;
    private Integer exceptionCount;

    // HOLD 标志
    private Integer holdFlag;
    private String holdStatus;
    private String holdType;
    private String holdReason;
    private Date holdTime;
    private Long holdUserId;
    private String holdUserName;
    private Date releaseTime;
    private String holdRemark;

    // 拆单
    private Long parentOrderId;
    private String parentOrderNo;
    private Long rootOrderId;
    private String rootOrderNo;
    private Integer splitFlag;
    private String splitRole;
    private String splitStatus;
    private String splitGroupNo;
    private Integer childOrderCount;
    private Date mergedBackTime;
    private Long mergedBackBy;
    private String splitSource;
    private Integer customerVisibleFlag;
    private String customerSplitReason;
    private String internalSplitReason;
    private String splitRequestedBy;
    private Long splitRequestedUserId;
    private String splitRequestedUserName;
    private Date splitTime;
    private Integer splitFeeFlag;
    private BigDecimal splitFeeAmount;
    private String splitFeeRemark;

    private Integer attachmentCount;
    private Integer podAttachmentCount;
    private Integer exceptionAttachmentCount;
    private Date latestAttachmentTime;

    // 备注
    private String customerRemark;
    private String internalRemark;
    private String operationRemark;
    private String followUpRemark;}
