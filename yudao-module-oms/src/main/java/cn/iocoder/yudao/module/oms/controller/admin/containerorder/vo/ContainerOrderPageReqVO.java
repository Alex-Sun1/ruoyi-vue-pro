package cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo;

import cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerOrderPageReqVO;

import lombok.Data;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import lombok.EqualsAndHashCode;
import lombok.ToString;
import lombok.EqualsAndHashCode;
import java.util.Date;

/**
 * 海柜订单查询对象
 */
@Data
public class ContainerOrderPageReqVO  {

    private String containerOrderNo;
    private String containerNo;
    private Long companyId;
    private Long customerId;
    private String customerName;
    /** 支持逗号分隔多选 */
    private String channelId;
    private String businessTypeId;
    private String warehouseId;
    private String shippingLineId;
    private String orderSource;
    private String companyName;
    private String channelName;
    private String ownerUserName;
    private String customerServiceName;
    private String shippingLineName;
    private String containerType;
    private String sealNo;
    private String vesselName;
    private String voyageNo;
    private String routeCode;
    private String mblNo;
    private String hblNo;
    private String dischargePortName;
    private String terminalName;
    private String containerStatus;
    private String terminalReleaseStatus;
    /** 支持逗号分隔：0/1 */
    private String holdFlag;
    private String holdTypes;
    private String holdRemark;
    private String examFlag;
    private String examType;
    private String examRemark;
    private String drayageVendorName;
    private String pickupAppointmentNo;
    private String pickupRemark;
    private String containerLocation;
    private String arrivalRemark;
    private String devanningNo;
    private String devanningMethod;
    private String loadingType;
    private String sortingMethod;
    private String devanningRemark;
    private String emptyReturnLocation;
    private String emptyReturnRemark;
    private String containerExceptionFlag;
    private String containerExceptionType;
    private String downstreamExceptionFlag;
    private String keyword;
    private Date beginEta;
    private Date endEta;
    private Date beginPickupLfd;
    private Date endPickupLfd;
    private Date beginEmptyReturnLfd;
    private Date endEmptyReturnLfd;
    private Date beginAta;
    private Date endAta;
    private Date beginActualPickupTime;
    private Date endActualPickupTime;
    private Date beginExpectedArrivalTime;
    private Date endExpectedArrivalTime;
    private Date beginActualArrivalTime;
    private Date endActualArrivalTime;
    private Date beginExpectedDevanningTime;
    private Date endExpectedDevanningTime;
    private Date beginDevanningStartTime;
    private Date endDevanningStartTime;
    private Date beginDevanningFinishTime;
    private Date endDevanningFinishTime;
    private Date beginEmptyReturnTime;
    private Date endEmptyReturnTime;
}
