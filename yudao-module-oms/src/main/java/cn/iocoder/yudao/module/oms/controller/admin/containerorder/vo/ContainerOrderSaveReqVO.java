package cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo;

import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderSaveReqVO;

import cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerOrderSaveReqVO;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.module.oms.dal.dataobject.containerorder.ContainerOrderDO;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 海柜订单业务对象
 */
@Data
public class ContainerOrderSaveReqVO  {

    private Long id;

    private String containerOrderNo;

    @NotNull(message = "主体不能为空")
    private Long companyId;

    @NotNull(message = "客户不能为空")
    private Long customerId;

    @NotBlank(message = "客户名称不能为空")
    private String customerName;

    private Long channelId;
    private Long businessTypeId;
    private Long ownerUserId;
    private String ownerUserName;
    private Long customerServiceId;
    private String customerServiceName;

    @NotNull(message = "入库仓库不能为空")
    private Long warehouseId;
    private String inboundWarehouseName;

    private String orderSource;

    @NotBlank(message = "柜号不能为空")
    private String containerNo;

    @NotBlank(message = "柜型不能为空")
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
    private String devanningMethod;
    private Date expectedDevanningTime;
    private Date devanningAppointmentTime;
    private Date devanningStartTime;
    private Date devanningFinishTime;
    private String loadingType;
    private String sortingMethod;
    private String devanningRemark;
    private String emptyReturnLocation;
    private String emptyReturnAppointmentNo;
    private Date emptyReturnTime;
    private String emptyReturnRemark;
    private String containerStatus;
    private String internalRemark;
    private String status;

    @Valid
    private List<CargoOrderSaveReqVO> cargoOrders = new ArrayList<>();
}
