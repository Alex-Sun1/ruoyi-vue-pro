package cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo;

import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderSkuItemSaveReqVO;

import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderShipmentSaveReqVO;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder.CargoOrderShipmentDO;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Data
public class CargoOrderShipmentSaveReqVO {

    private Long id;

    @NotBlank(message = "货件编码不能为空")
    private String shipmentNo;

    private String poNo;
    private String shippingMark;
    private BigDecimal cartonQty;
    private BigDecimal palletQty;
    private BigDecimal weight;
    private BigDecimal cbm;
    private Date dwTime;
    private String remark;

    private List<CargoOrderSkuItemSaveReqVO> skuItems = new ArrayList<>();
}
