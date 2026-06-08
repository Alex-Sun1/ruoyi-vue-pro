package cn.iocoder.yudao.module.base.dal.dataobject.client;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;

@TableName("mdm_client")
@KeySequence("mdm_client_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ClientDO extends TenantBaseDO {

    @TableId
    private Long id;

    private String clientCode;

    private String clientName;

    private Integer status;

    private String remark;

}
