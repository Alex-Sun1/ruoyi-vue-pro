package cn.iocoder.yudao.module.oms.controller.admin.preoutbound.vo;

import cn.iocoder.yudao.module.oms.controller.admin.preoutbound.vo.PreOutboundUpdateReqVO;

import lombok.Data;

import java.util.Date;

@Data
public class PreOutboundUpdateReqVO {
    private String outboundDirection;
    private String appointmentNo;
    private Date appointmentTime;
    private String deliveryTruck;
    private String loadingType;
    private String transportType;
    private String deliveryTag;
    private String followRecord;
    private String remark;
}
