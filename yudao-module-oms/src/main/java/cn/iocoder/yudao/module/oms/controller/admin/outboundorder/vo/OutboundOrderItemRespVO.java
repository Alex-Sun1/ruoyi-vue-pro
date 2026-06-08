package cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo;

import cn.iocoder.yudao.module.oms.controller.admin.outboundorder.vo.OutboundOrderItemRespVO;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

@Data
public class OutboundOrderItemRespVO implements Serializable {

    private Long id;
    private Long outboundOrderId;
    private String outboundOrderNo;
    private Long cargoOrderId;
    private String cargoOrderNo;
    private Long preOutboundItemId;
    private BigDecimal actualCartonQty;
    private BigDecimal actualPalletQty;
    private BigDecimal actualWeight;
    private BigDecimal actualCbm;
}
