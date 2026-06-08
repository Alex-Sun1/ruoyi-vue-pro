package cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo;

import cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo.OutboundCreateReqVO;

import lombok.Data;

import java.util.Date;
import java.util.List;

@Data
public class OutboundCreateReqVO {
    private Long cargoOrderId;
    private List<Long> cargoOrderIds;
    private String outboundDirection;
    private Long outboundWarehouseId;
    private String outboundWarehouseName;
    private Long transferInWarehouseId;
    private String deliveryMethod;
    private String appointmentStatus;
    private String appointmentNo;
    private Date appointmentTime;
    private String deliveryTruck;
    private String loadingType;
    private String transportType;
    private String deliveryTag;
    private String destination;
    private String followRecord;
    private String transferReason;
    private String transferMethod;
    /** 是否转仓：1=是 */
    private Integer transferFlag;
    /** 转仓平台仓库代码（如亚马逊 FBA 仓代码） */
    private String transferWarehouseCode;
    private String remark;
}
