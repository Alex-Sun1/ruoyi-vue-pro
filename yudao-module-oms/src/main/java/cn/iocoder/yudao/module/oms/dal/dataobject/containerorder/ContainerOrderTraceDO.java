package cn.iocoder.yudao.module.oms.dal.dataobject.containerorder;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;

/**
 * 海柜订单节点轨迹
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("oms_container_order_trace")
public class ContainerOrderTraceDO extends TenantBaseDO {

    @TableId
    private Long id;

    private Long containerOrderId;
    private String containerOrderNo;
    private String containerNo;
    private String statusFrom;
    private String statusTo;
    private String action;
    private String actionDesc;
    private Long operatorId;
    private String operatorName;
    private String remark;
}
