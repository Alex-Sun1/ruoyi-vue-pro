package cn.iocoder.yudao.module.base.dal.dataobject.saleschannel;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;

@TableName("base_sales_channel")
@KeySequence("base_sales_channel_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BaseSalesChannelDO extends TenantBaseDO {

    @TableId
    private Long id;
    private String channelCode;
    private String channelName;
    private Integer status;

}
