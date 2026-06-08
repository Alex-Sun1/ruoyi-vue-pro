package cn.iocoder.yudao.module.wms.dal.dataobject.inventorylock;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;
import java.util.Date;

@TableName("wms_inventory_lock")
@KeySequence("wms_inventory_lock_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WmsInventoryLockDO extends TenantBaseDO {
    @TableId
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
    private Date releaseTime;
    private String remark;
}
