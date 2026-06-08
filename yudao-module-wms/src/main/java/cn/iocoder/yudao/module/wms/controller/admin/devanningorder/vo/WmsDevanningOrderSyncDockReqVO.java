package cn.iocoder.yudao.module.wms.controller.admin.devanningorder.vo;

import lombok.Data;

import java.util.Date;

@Data
public class WmsDevanningOrderSyncDockReqVO {

    private Long sourceOrderId;
    private String sourceOrderType;
    private Long dockId;
    private String dockCode;
    private Date dockAssignTime;

}
