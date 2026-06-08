package cn.iocoder.yudao.module.oms.dal.dataobject.preoutbound;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("oms_pre_outbound_item")
public class PreOutboundItemDO extends TenantBaseDO {

    @TableId(type = IdType.ASSIGN_ID)
    private Long id;

    private Long preOutboundId;
    private String preOutboundNo;
    private Long cargoOrderId;
    private String cargoOrderNo;
}
