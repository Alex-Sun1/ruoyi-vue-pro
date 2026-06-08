package cn.iocoder.yudao.module.wms.dal.dataobject.zone;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;

@TableName("wms_zone")
@KeySequence("wms_zone_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WmsZoneDO extends TenantBaseDO {
    @TableId
    private Long id;
    private Long companyId;
    private Long warehouseId;
    private String warehouseCode;
    private String warehouseName;
    private String zoneName;
    private String storageMethod;
    private String zoneType;
    private Integer allowMixedStorage;
    private Integer maxMixedQty;
    private String status;
    private String remark;
}
