package cn.iocoder.yudao.module.oms.controller.admin.outboundpool.vo;

import cn.iocoder.yudao.module.oms.controller.admin.outboundpool.vo.OutboundPoolQueryReqVO;

import lombok.Data;

import java.util.Date;

@Data
public class OutboundPoolQueryReqVO {

    private String keyword;
    private String cargoOrderNo;
    private String customerName;
    private String containerNo;
    private String shipmentCodes;
    private String platformWarehouseCode;
    private String groupCode;
    private String channelName;
    private String businessTypeName;
    private String addressType;
    private String readiness;
    private String city;
    private String state;
    private String zipCode;
    private Integer transferFlag;
    private Boolean overdueDeliveryLfd;
    private Boolean overdueDw;
    private Date beginCreateTime;
    private Date endCreateTime;
    private Date beginDeliveryLfd;
    private Date endDeliveryLfd;
    private Date beginEarliestDwTime;
    private Date endEarliestDwTime;
}
