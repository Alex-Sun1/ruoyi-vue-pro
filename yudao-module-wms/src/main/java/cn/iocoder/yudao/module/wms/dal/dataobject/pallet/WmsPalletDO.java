package cn.iocoder.yudao.module.wms.dal.dataobject.pallet;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;
import java.math.BigDecimal;
import java.util.Date;
import com.baomidou.mybatisplus.annotation.Version;

@TableName("wms_pallet")
@KeySequence("wms_pallet_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WmsPalletDO extends TenantBaseDO {
    @TableId
    private Long id;
    private Long companyId;
    private Long warehouseId;
    private String warehouseCode;
    private String warehouseName;
    private String palletNo;
    private String palletType;
    private String businessTypeName;
    private String containerNo;
    private String groupDestination;
    private Long cargoOrderId;
    private String cargoOrderNo;
    private Long shipmentId;
    private String shipmentCode;
    private Long zoneId;
    private String zoneCode;
    private String zoneName;
    private Long locationId;
    private String locationCode;
    private Integer totalBoxQty;
    private Integer availableBoxQty;
    private Integer lockedBoxQty;
    private Integer exceptionBoxQty;
    private BigDecimal weight;
    private BigDecimal cbm;
    private String palletStatus;
    private Date inboundTime;
    private String remark;
    @Version
    private Integer version;
}
