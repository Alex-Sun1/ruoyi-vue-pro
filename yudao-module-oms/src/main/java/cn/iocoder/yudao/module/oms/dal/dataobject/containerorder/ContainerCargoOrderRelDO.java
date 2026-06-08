package cn.iocoder.yudao.module.oms.dal.dataobject.containerorder;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;

/**
 * 海柜-货物订单关系
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("oms_container_cargo_order_rel")
public class ContainerCargoOrderRelDO extends TenantBaseDO {

    @TableId
    private Long id;

    private Long containerOrderId;
    private String containerOrderNo;
    private String containerNo;
    private Long cargoOrderId;
    private String cargoOrderNo;
    private String relationType;
    private String relationStatus;
}
