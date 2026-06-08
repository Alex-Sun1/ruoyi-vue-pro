package cn.iocoder.yudao.module.wms.controller.admin.inventory.vo;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.Date;

@Data
public class WmsInventoryTransactionRespVO {

    private Long id;
    private Long companyId;
    private Long warehouseId;
    private String transactionNo;
    private String transactionType;
    private Long customerId;
    private String customerName;
    private Long cargoOrderId;
    private String cargoOrderNo;
    private Long shipmentId;
    private String shipmentCode;
    private Long palletId;
    private String palletNo;
    private Long palletItemId;
    private Long fromLocationId;
    private String fromLocationCode;
    private Long toLocationId;
    private String toLocationCode;
    private Integer changeTotal;
    private Integer changeAvailable;
    private Integer changeLocked;
    private Integer changeException;
    private String bizDocType;
    private Long bizDocId;
    private Long bizDocLineId;
    private Date operateTime;
    private String remark;
    private LocalDateTime createTime;

}
