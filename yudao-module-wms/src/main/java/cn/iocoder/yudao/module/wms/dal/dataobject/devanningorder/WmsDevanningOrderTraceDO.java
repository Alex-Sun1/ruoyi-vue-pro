package cn.iocoder.yudao.module.wms.dal.dataobject.devanningorder;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;
import java.util.Date;

@TableName("wms_devanning_order_trace")
@KeySequence("wms_devanning_order_trace_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WmsDevanningOrderTraceDO extends TenantBaseDO {
    @TableId
    private Long id;
    private Long devanningOrderId;
    private String actionType;
    private String beforeStatus;
    private String afterStatus;
    private String actionContent;
    private Long operatorId;
    private String operatorName;
    private Date actionTime;
}
