package cn.iocoder.yudao.module.base.dal.dataobject.state;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;



@TableName("base_state_province")
@KeySequence("base_state_province_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StateProvinceDO extends TenantBaseDO {

    @TableId
    private Long id;

    private String countryCode;

    private String code;

    private String nameEn;

    private Integer sortOrder;

    private Integer status;

}
