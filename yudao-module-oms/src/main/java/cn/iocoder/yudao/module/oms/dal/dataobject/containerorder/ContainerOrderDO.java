package cn.iocoder.yudao.module.oms.dal.dataobject.containerorder;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerOrderRespVO;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 海柜订单主表
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("oms_container_order")
public class ContainerOrderDO extends TenantBaseDO {

    @TableId
    private Long id;

    private Long companyId;
    private Long customerId;
    private String customerName;
    private Long channelId;
    private Long businessTypeId;
    private Long ownerUserId;
    private String ownerUserName;
    private Long customerServiceId;
    private String customerServiceName;
    private Long warehouseId;
    private String inboundWarehouseName;

    private String containerOrderNo;
    private String orderSource;
    private String containerNo;
    private String containerType;
    private String sealNo;
    private Long shippingLineId;
    private String shippingLineName;
    private String vesselName;
    private String voyageNo;
    private String routeCode;
    private String mblNo;
    private String hblNo;

    private Long dischargePortId;
    private String dischargePortName;
    private Long terminalId;
    private String terminalName;
    private Date eta;
    private Date ata;
    private Date pickupLfd;
    private Date emptyReturnLfd;
    private Date availableTime;

    private String terminalReleaseStatus;
    private Integer holdFlag;
    private String holdTypes;
    private String holdRemark;
    private Integer examFlag;
    private String examTypes;
    private String examType;
    private String examRemark;

    private Long drayageVendorId;
    private String drayageVendorName;
    private String pickupAppointmentNo;
    private Date pickupAppointmentTime;
    private Date actualPickupTime;
    private String pickupRemark;

    private Date expectedArrivalTime;
    private Date requiredArrivalTime;
    private Date actualArrivalTime;
    private String containerLocation;
    private String arrivalRemark;

    private String devanningNo;
    private String devanningOrderNo;
    private Long devanningWarehouseId;
    private Date expectedDevanningTime;
    private Date devanningAppointmentTime;
    private String devanningMethod;
    private String loadingType;
    private String sortingMethod;
    private Date devanningStartTime;
    private Date devanningFinishTime;
    private String devanningRemark;

    @TableField(exist = false)
    private Long assignedDockId;
    @TableField(exist = false)
    private String assignedDockName;

    private String emptyReturnLocation;
    private String emptyReturnAppointmentNo;
    private Date emptyReturnTime;
    private String emptyReturnStatus;
    private String emptyReturnRemark;

    private BigDecimal prePlanTruckQty;
    private BigDecimal prePlanPalletQty;
    private BigDecimal prePlanCbm;
    private BigDecimal totalCartonQty;
    private BigDecimal totalPalletQty;
    private BigDecimal totalWeight;
    private BigDecimal totalCbm;

    private Integer containerExceptionFlag;
    private String containerExceptionType;
    private Integer containerExceptionCount;
    private Integer downstreamExceptionFlag;
    private Integer downstreamExceptionCount;

    private Integer attachmentCount;
    private Integer doAttachmentCount;
    private Date latestAttachmentTime;
    private Date latestDoUploadTime;

    private String containerStatus;
    private String internalRemark;
    private String status;}
