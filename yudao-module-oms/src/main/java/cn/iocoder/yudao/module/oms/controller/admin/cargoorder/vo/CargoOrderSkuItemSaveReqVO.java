package cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo;

import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderSkuItemSaveReqVO;

import lombok.Data;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder.CargoOrderSkuItemDO;

import java.math.BigDecimal;

@Data
public class CargoOrderSkuItemSaveReqVO {

    private Long id;
    private Long shipmentId;
    private String shipmentNo;
    private String poNo;
    private String shippingMark;
    private String sku;
    private String fnsku;
    private String productName;
    private BigDecimal qty;
    private BigDecimal cartonQty;
    private BigDecimal weight;
    private BigDecimal cbm;
    private String remark;
}
