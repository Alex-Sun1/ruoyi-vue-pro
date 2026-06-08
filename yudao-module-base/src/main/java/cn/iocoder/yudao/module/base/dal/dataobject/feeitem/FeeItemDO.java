package cn.iocoder.yudao.module.base.dal.dataobject.feeitem;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;



@TableName("mdm_fee_item")
@KeySequence("mdm_fee_item_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FeeItemDO extends TenantBaseDO {

    @TableId
    private Long id;

    private String feeCode;

    private String feeName;

    private String feeCategory;

    private String businessStage;

    private String businessType;

    private Integer isSystem;

    private Integer isBillable;

    private String description;

    private Integer status;

    private Integer sortOrder;

    private String remark;

}
