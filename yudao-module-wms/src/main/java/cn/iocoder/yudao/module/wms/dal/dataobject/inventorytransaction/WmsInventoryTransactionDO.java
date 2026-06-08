package cn.iocoder.yudao.module.wms.dal.dataobject.inventorytransaction;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;
import java.util.Date;

@TableName("wms_inventory_transaction")
@KeySequence("wms_inventory_transaction_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WmsInventoryTransactionDO extends TenantBaseDO {
    @TableId
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
    private Long operatorId;
    private String operatorName;
    private Date operateTime;
    private String remark;
}
