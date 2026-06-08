package cn.iocoder.yudao.module.oms.controller.admin.preoutbound.vo;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

@Data
public class PreOutboundItemRespVO implements Serializable {

    private Long id;
    private Long preOutboundId;
    private String preOutboundNo;
    private Long cargoOrderId;
    private String cargoOrderNo;
    private String containerNo;
    private String shipmentCodes;
    private String poNos;
    private String platformWarehouseCode;
    /** NOT_INBOUNDED / DEVANNING / INBOUNDED */
    private String readiness;
    private String fulfillmentStatus;
    private BigDecimal declaredCartonQty;
    private BigDecimal actualCartonQty;
    private BigDecimal declaredPalletQty;
    private BigDecimal actualPalletQty;
    private BigDecimal actualWeight;
    private BigDecimal actualCbm;
}
