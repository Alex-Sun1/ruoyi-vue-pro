package cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo;

import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanItemRespVO;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 入库计划明细 Vo（货件维度，全部 JOIN 原表实时展示）
 */
@Data
public class InboundPlanItemRespVO implements Serializable {

    // ---- 计划自身字段 ----
    private Long id;
    private Long planId;
    private Long cargoOrderId;
    private Long shipmentId;
    private String groupCode;
    private String preLocation;

    // ---- JOIN oms_cargo_order ----
    private String cargoOrderNo;
    private String businessTypeName;
    private String platformName;
    private String addressType;
    private String orderStatus;

    // ---- JOIN oms_cargo_order_shipment ----
    private String shipmentNo;
    private String poNo;
    /** 唛头 */
    private String shippingMark;
    /** 仓库代码（平台仓库代码） */
    private String platformWarehouseCode;
    private BigDecimal cartonQty;
    private BigDecimal weight;
    private BigDecimal cbm;
    /** 预报板数（来自货件） */
    private BigDecimal palletQty;
}
