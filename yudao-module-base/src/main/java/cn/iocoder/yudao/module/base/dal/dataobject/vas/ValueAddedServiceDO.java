package cn.iocoder.yudao.module.base.dal.dataobject.vas;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;

@TableName("base_value_added_service")
@KeySequence("base_value_added_service_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ValueAddedServiceDO extends TenantBaseDO {

    @TableId
    private Long id;
    private String serviceCode;
    private String serviceName;
    private String serviceCategory;
    private String billingMode;
    private Boolean chargeableFlag;
    private Boolean operationRequired;
    private Boolean pdaOperationFlag;
    private Boolean photoRequired;
    private Boolean qcRequired;
    private Boolean supportBatchOperation;
    private Boolean defaultSelected;
    private Integer priority;
    private Integer sortOrder;
    private Integer status;
    private String remark;

}
