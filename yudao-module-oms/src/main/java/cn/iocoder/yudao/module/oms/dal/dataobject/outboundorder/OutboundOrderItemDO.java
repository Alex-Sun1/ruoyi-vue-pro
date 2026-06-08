package cn.iocoder.yudao.module.oms.dal.dataobject.outboundorder;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;

import java.math.BigDecimal;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("oms_outbound_order_item")
public class OutboundOrderItemDO extends TenantBaseDO {

    @TableId(type = IdType.ASSIGN_ID)
    private Long id;

    private Long outboundOrderId;
    private String outboundOrderNo;
    private Long cargoOrderId;
    private String cargoOrderNo;

    /** 来源预出单明细ID，从预出单转换时填充 */
    private Long preOutboundItemId;

    private BigDecimal actualCartonQty;
    private BigDecimal actualPalletQty;
    private BigDecimal actualWeight;
    private BigDecimal actualCbm;
}
