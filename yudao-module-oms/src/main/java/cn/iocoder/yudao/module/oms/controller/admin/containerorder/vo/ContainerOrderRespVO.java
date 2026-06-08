package cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo;

import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderRespVO;

import cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerOrderRespVO;

import cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerOrderTraceRespVO;

import cn.idev.excel.annotation.ExcelIgnoreUnannotated;
import cn.idev.excel.annotation.ExcelProperty;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import cn.iocoder.yudao.module.oms.dal.dataobject.containerorder.ContainerOrderDO;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 海柜订单视图
 */
@Data
@ExcelIgnoreUnannotated
public class ContainerOrderRespVO implements Serializable {

    private Long id;
    private Long companyId;
    private String companyName;
    private Long customerId;
    @ExcelProperty("客户")
    private String customerName;
    private Long channelId;
    private String channelName;
    private Long businessTypeId;
    private String businessTypeName;
    private Long ownerUserId;
    private String ownerUserName;
    private Long customerServiceId;
    private String customerServiceName;
    private Long warehouseId;
    @ExcelProperty("入库仓库")
    private String warehouseName;
    private String inboundWarehouseName;

    @ExcelProperty("海柜订单号")
    private String containerOrderNo;
    private String orderSource;
    @ExcelProperty("柜号")
    private String containerNo;
    @ExcelProperty("柜型")
    private String containerType;
    private String sealNo;
    private Long shippingLineId;
    @ExcelProperty("船公司")
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
    @ExcelProperty("ETA")
    private Date eta;
    @ExcelProperty("ATA")
    private Date ata;
    @ExcelProperty("提柜LFD")
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date pickupLfd;
    @ExcelProperty("还柜LFD")
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date emptyReturnLfd;
    @ExcelProperty("可提时间")
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
    @ExcelProperty("海柜状态")
    private String containerStatus;
    private String internalRemark;
    private String status;
    private String remark;
    private Date createTime;
    private Date updateTime;
    private List<CargoOrderRespVO> cargoOrders = new ArrayList<>();
    private List<ContainerOrderTraceRespVO> traces = new ArrayList<>();
}
