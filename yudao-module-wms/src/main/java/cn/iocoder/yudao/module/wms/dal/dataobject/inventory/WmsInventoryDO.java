package cn.iocoder.yudao.module.wms.dal.dataobject.inventory;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;
import java.math.BigDecimal;
import com.baomidou.mybatisplus.annotation.Version;

@TableName("wms_inventory")
@KeySequence("wms_inventory_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WmsInventoryDO extends TenantBaseDO {
    @TableId
    private Long id;
    private Long companyId;
    private Long warehouseId;
    private String warehouseCode;
    private String warehouseName;
    private Long customerId;
    private String customerName;
    private Long cargoOrderId;
    private String cargoOrderNo;
    private Long shipmentId;
    private String shipmentCode;
    private Integer totalBoxQty;
    private Integer availableBoxQty;
    private Integer lockedBoxQty;
    private Integer exceptionBoxQty;
    private BigDecimal totalWeight;
    private BigDecimal totalCbm;
    private String inventoryStatus;
    private String remark;
    @Version
    private Integer version;
}
