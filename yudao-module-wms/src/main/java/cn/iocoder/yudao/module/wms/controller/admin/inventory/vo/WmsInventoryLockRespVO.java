package cn.iocoder.yudao.module.wms.controller.admin.inventory.vo;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.Date;

@Data
public class WmsInventoryLockRespVO {

    private Long id;
    private Long companyId;
    private Long warehouseId;
    private String bizDocType;
    private Long bizDocId;
    private Long bizDocLineId;
    private Long shipmentId;
    private String shipmentCode;
    private Long palletId;
    private String palletNo;
    private Long palletItemId;
    private Integer lockedBoxQty;
    private String lockStatus;
    private Date lockTime;
    private String remark;
    private LocalDateTime createTime;

}
