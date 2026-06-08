package cn.iocoder.yudao.module.wms.dal.dataobject.palletitem;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;
import java.math.BigDecimal;

@TableName("wms_pallet_item")
@KeySequence("wms_pallet_item_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WmsPalletItemDO extends TenantBaseDO {
    @TableId
    private Long id;
    private Long companyId;
    private Long warehouseId;
    private Long palletId;
    private String palletNo;
    private Long cargoOrderId;
    private String cargoOrderNo;
    private String businessTypeName;
    private String containerNo;
    private String groupDestination;
    private String platformName;
    private String platformWarehouseCode;
    private String addressType;
    private Integer holdFlag;
    private Long shipmentId;
    private String shipmentCode;
    private String poNo;
    private String shippingMark;
    private Integer boxQty;
    private Integer availableBoxQty;
    private Integer lockedBoxQty;
    private Integer exceptionBoxQty;
    private BigDecimal weight;
    private BigDecimal cbm;
    private String remark;
}
