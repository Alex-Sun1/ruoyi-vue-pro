package cn.iocoder.yudao.module.base.dal.dataobject.businesstype;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;

@TableName("base_business_type")
@KeySequence("base_business_type_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BusinessTypeDO extends TenantBaseDO {

    @TableId
    private Long id;
    private String businessTypeCode;
    private String businessTypeName;
    private String businessCategory;
    private String operationFlowType;
    private Boolean receiveRequired;
    private Boolean inboundRequired;
    private Boolean putawayRequired;
    private Boolean storageRequired;
    private Boolean pickingRequired;
    private Boolean outboundRequired;
    private Boolean deliveryRequired;
    private Boolean appointmentRequired;
    private Boolean vasSupported;
    private String sortingStrategy;
    private String sortingField;
    private Integer sortOrder;
    private Integer status;
    private String remark;

}
