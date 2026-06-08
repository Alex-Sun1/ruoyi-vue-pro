package cn.iocoder.yudao.module.base.dal.dataobject.yardzone;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;

@TableName("yard_zone")
@KeySequence("yard_zone_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class YardZoneDO extends TenantBaseDO {

    @TableId
    private Long id;
    private Long warehouseId;
    private String zoneCode;
    private String zoneName;
    private String zoneType;
    private Integer sortOrder;
    private String remark;

}
