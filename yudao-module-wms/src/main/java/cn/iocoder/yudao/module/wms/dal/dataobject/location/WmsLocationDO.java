package cn.iocoder.yudao.module.wms.dal.dataobject.location;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;

@TableName("wms_location")
@KeySequence("wms_location_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WmsLocationDO extends TenantBaseDO {
    @TableId
    private Long id;
    private Long companyId;
    private Long warehouseId;
    private String warehouseCode;
    private String warehouseName;
    private Long zoneId;
    private String zoneName;
    private String locationCode;
    private String rowNo;
    private String columnNo;
    private Integer capacity;
    private Integer currentQty;
    private Integer remainingCapacity;
    private String status;
    private String remark;
}
