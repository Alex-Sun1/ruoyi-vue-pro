package cn.iocoder.yudao.module.wms.dal.dataobject.devanningorder;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;
import java.math.BigDecimal;
import java.util.Date;
import com.baomidou.mybatisplus.annotation.Version;

@TableName("wms_devanning_order")
@KeySequence("wms_devanning_order_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WmsDevanningOrderDO extends TenantBaseDO {
    @TableId
    private Long id;
    private Long companyId;
    private Long warehouseId;
    private Long bizRootId;
    private String devanningNo;
    private Long sourceOrderId;
    private String sourceOrderNo;
    private String sourceOrderType;
    private String containerNo;
    private Long customerId;
    private String customerName;
    private Long channelId;
    private String channelName;
    private Long customerServiceId;
    private String customerServiceName;
    private Date etaWarehouseTime;
    private Date pickupTime;
    private Date actualArrivalTime;
    private Date plannedDevanningTime;
    private Date devanningStartTime;
    private Date devanningFinishTime;
    private Long dockId;
    private String dockCode;
    private Date dockAssignTime;
    private String devanningMethod;
    private String devanningRemark;
    private Integer plannedTruckQty;
    private BigDecimal plannedCbm;
    private BigDecimal totalBoxQty;
    private BigDecimal totalWeight;
    private BigDecimal totalCbm;
    private BigDecimal inboundedBoxQty;
    private Integer exceptionFlag;
    private Integer exceptionCount;
    private String attachmentUrls;
    private String status;
    @Version
    private Integer version;
    private String remark;
}
