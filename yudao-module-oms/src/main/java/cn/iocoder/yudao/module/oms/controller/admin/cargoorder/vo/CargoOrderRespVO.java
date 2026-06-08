package cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo;

import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderRespVO;

import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderShipmentRespVO;

import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderNodeTraceRespVO;

import cn.idev.excel.annotation.ExcelIgnoreUnannotated;
import cn.idev.excel.annotation.ExcelProperty;
import lombok.Data;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder.CargoOrderDO;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Data
@ExcelIgnoreUnannotated
public class CargoOrderRespVO implements Serializable {

    private Long id;
    private Long bizRootId;
    private Long companyId;

    private String shipmentCodes;
    private String poNos;
    private String marks;

    @ExcelProperty("货物订单号")
    private String cargoOrderNo;

    private String externalOrderNo;
    private String orderSource;

    private Long customerId;
    @ExcelProperty("客户")
    private String customerName;

    private Long businessTypeId;
    @ExcelProperty("业务类型")
    private String businessTypeName;

    private Long channelId;
    @ExcelProperty("渠道")
    private String channelName;

    private Long platformId;
    @ExcelProperty("平台")
    private String platformName;

    private Long customerServiceId;
    @ExcelProperty("客服")
    private String customerServiceName;

    private Long containerOrderId;
    @ExcelProperty("柜号")
    private String containerNo;

    private Long inboundWarehouseId;
    @ExcelProperty("入库仓")
    private String inboundWarehouseName;

    @ExcelProperty("地址类型")
    private String addressType;

    @ExcelProperty("仓库代码")
    private String platformWarehouseCode;

    @ExcelProperty("目的仓/分组")
    private String groupCode;

    @ExcelProperty("收货方")
    private String consigneeName;

    private String addressLine1;
    private String addressLine2;

    @ExcelProperty("City")
    private String city;

    @ExcelProperty("State")
    private String state;

    @ExcelProperty("Zip Code")
    private String zipCode;

    @ExcelProperty("Country")
    private String country;

    private String contactName;
    private String contactPhone;
    private String contactEmail;

    private String parcelCarrierName;
    private String parcelTrackingNo;

    private Integer transferFlag;
    private String transferWarehouseCode;
    private String forecastQtyUnit;

    @ExcelProperty("预报箱数")
    private BigDecimal declaredCartonQty;

    private BigDecimal declaredPalletQty;

    private BigDecimal declaredPieceQty;

    @ExcelProperty("预报重量")
    private BigDecimal declaredWeight;

    @ExcelProperty("预报体积")
    private BigDecimal declaredCbm;

    @ExcelProperty("实际箱数")
    private BigDecimal actualCartonQty;

    @ExcelProperty("实际板数")
    private BigDecimal actualPalletQty;

    private BigDecimal actualPieceQty;

    @ExcelProperty("实际重量")
    private BigDecimal actualWeight;

    @ExcelProperty("实际体积")
    private BigDecimal actualCbm;

    private String weightUnit;
    private String volumeUnit;

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

    private String orderStatus;

    @ExcelProperty("主履约状态")
    private String fulfillmentStatus;

    private String appointmentStatus;
    private String podStatus;

    @ExcelProperty("账单状态")
    private String billingStatus;

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

    private Integer exceptionFlag;
    private Integer exceptionCount;
    private Integer holdFlag;
    private String holdStatus;
    private String holdType;
    private String holdReason;
    private Date holdTime;
    private String holdUserName;
    private Date releaseTime;
    private String holdRemark;

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
    private String splitSource;
    private Integer customerVisibleFlag;
    private String customerSplitReason;
    private String internalSplitReason;
    private String splitRequestedBy;
    private Date splitTime;
    private Integer attachmentCount;
    private Integer podAttachmentCount;
    private Integer exceptionAttachmentCount;
    private Date latestAttachmentTime;

    private String customerRemark;
    private String internalRemark;
    private String operationRemark;
    private String followUpRemark;

    private Date createTime;

    private List<CargoOrderShipmentRespVO> shipments = new ArrayList<>();
    private List<CargoOrderNodeTraceRespVO> nodeTraces = new ArrayList<>();
}
