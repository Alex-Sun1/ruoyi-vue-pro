package cn.iocoder.yudao.module.wms.controller.admin.devanningorder.vo;

import lombok.Data;

import java.util.Date;

@Data
public class WmsDevanningOrderTraceRespVO {

    private Long id;
    private Long devanningOrderId;
    private String actionType;
    private String beforeStatus;
    private String afterStatus;
    private String actionContent;
    private Long operatorId;
    private String operatorName;
    private Date actionTime;

}
