package cn.iocoder.yudao.module.oms.controller.admin.outboundpool.vo;

import cn.iocoder.yudao.module.oms.controller.admin.outboundpool.vo.OutboundPoolStatsRespVO;

import lombok.Data;
import java.io.Serializable;

import java.math.BigDecimal;

@Data
public class OutboundPoolStatsRespVO implements Serializable {

    private long totalCount;
    private long notInboundedCount;
    private long devanningCount;
    private long inboundedCount;
    private long overdueDeliveryLfdCount;
    private long overdueDwCount;
    private BigDecimal inTransitCbm = BigDecimal.ZERO;
    private BigDecimal devanningCbm = BigDecimal.ZERO;
    private BigDecimal inboundedCbm = BigDecimal.ZERO;
    private BigDecimal totalCbm = BigDecimal.ZERO;
    private BigDecimal totalWeight = BigDecimal.ZERO;
    private BigDecimal totalPalletQty = BigDecimal.ZERO;
    private BigDecimal totalCartonQty = BigDecimal.ZERO;
}
