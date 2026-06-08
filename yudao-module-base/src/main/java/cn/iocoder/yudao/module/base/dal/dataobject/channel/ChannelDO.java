package cn.iocoder.yudao.module.base.dal.dataobject.channel;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;

@TableName("base_channel")
@KeySequence("base_channel_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChannelDO extends TenantBaseDO {

    @TableId
    private Long id;
    private String channelCode;
    private String channelName;
    private String channelType;
    private String containerMode;
    private Integer priority;
    private Integer sortOrder;
    private Integer status;
    private String remark;

}
