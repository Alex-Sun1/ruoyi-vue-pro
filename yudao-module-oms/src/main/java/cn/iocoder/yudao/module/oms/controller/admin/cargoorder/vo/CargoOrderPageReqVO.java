package cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo;

import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderPageReqVO;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import lombok.EqualsAndHashCode;
import lombok.ToString;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.module.oms.support.OmsQueryCsvUtils;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;
import java.util.List;

@Data
public class CargoOrderPageReqVO  {

  /** 单号搜索类型：cargoOrderNo / mark / shipmentCode / poNo / externalOrderNo */
    private String keywordField;

    private String keyword;
    private String cargoOrderNo;
    private String externalOrderNo;
    private Long customerId;
    private String customerName;
    private String consigneeName;
    /** 支持逗号分隔多选 */
    private String businessTypeId;
    private String channelId;
    private String platformId;
    private String customerServiceId;
    private String inboundWarehouseId;

    @JsonIgnore
    private List<Long> businessTypeIdList;
    @JsonIgnore
    private List<Long> channelIdList;
    @JsonIgnore
    private List<Long> platformIdList;
    @JsonIgnore
    private List<Long> customerServiceIdList;
    @JsonIgnore
    private List<Long> inboundWarehouseIdList;
    @JsonIgnore
    private List<String> orderSourceList;
    @JsonIgnore
    private List<String> addressTypeList;
    @JsonIgnore
    private List<String> fulfillmentStatusList;
    @JsonIgnore
    private List<String> billingStatusList;
    @JsonIgnore
    private List<String> preOutboundStatusList;
    @JsonIgnore
    private List<String> outboundOrderStatusList;
    @JsonIgnore
    private List<String> podStatusList;
    @JsonIgnore
    private List<Integer> exceptionFlagList;
    @JsonIgnore
    private List<Integer> transferFlagList;
    private String orderSource;
    private String addressType;
    private String platformWarehouseCode;
    private String groupCode;
    private String city;
    private String state;
    private String zipCode;
    private String containerNo;
    private String fulfillmentStatus;
    private String billingStatus;
    private String preOutboundStatus;
    private String outboundOrderStatus;
    private String podStatus;
    /** 支持逗号分隔：0/1 */
    private String exceptionFlag;
    private String transferFlag;
    private String parcelCarrierName;
    private String parcelTrackingNo;
    private String outboundBatchNo;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date beginEarliestDwTime;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date endEarliestDwTime;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date beginEta;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date endEta;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date beginAta;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date endAta;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date beginActualArrivalTime;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date endActualArrivalTime;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date beginActualInboundTime;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date endActualInboundTime;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date beginDeliveryAppointmentTime;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date endDeliveryAppointmentTime;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date beginActualOutboundTime;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date endActualOutboundTime;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date beginSignedTime;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date endSignedTime;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date beginCreateTime;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date endCreateTime;

  /** 解析高级筛选逗号分隔多选 */
    public void prepareMultiValueQuery() {
        businessTypeIdList = OmsQueryCsvUtils.toLongList(businessTypeId);
        channelIdList = OmsQueryCsvUtils.toLongList(channelId);
        platformIdList = OmsQueryCsvUtils.toLongList(platformId);
        customerServiceIdList = OmsQueryCsvUtils.toLongList(customerServiceId);
        inboundWarehouseIdList = OmsQueryCsvUtils.toLongList(inboundWarehouseId);
        orderSourceList = OmsQueryCsvUtils.toStringList(orderSource);
        addressTypeList = OmsQueryCsvUtils.toStringList(addressType);
        fulfillmentStatusList = OmsQueryCsvUtils.toStringList(fulfillmentStatus);
        billingStatusList = OmsQueryCsvUtils.toStringList(billingStatus);
        preOutboundStatusList = OmsQueryCsvUtils.toStringList(preOutboundStatus);
        outboundOrderStatusList = OmsQueryCsvUtils.toStringList(outboundOrderStatus);
        podStatusList = OmsQueryCsvUtils.toStringList(podStatus);
        exceptionFlagList = toIntegerList(exceptionFlag);
        transferFlagList = toIntegerList(transferFlag);
    }

    private static List<Integer> toIntegerList(String csv) {
        List<String> parts = OmsQueryCsvUtils.toStringList(csv);
        if (parts == null) {
            return null;
        }
        return parts.stream().map(Integer::valueOf).toList();
    }
}
