package cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo;

import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderSkuItemRespVO;

import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderShipmentRespVO;

import cn.idev.excel.annotation.ExcelIgnoreUnannotated;
import lombok.Data;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder.CargoOrderShipmentDO;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Data
@ExcelIgnoreUnannotated
public class CargoOrderShipmentRespVO implements Serializable {

    private Long id;
    private Long cargoOrderId;
    private Long bizRootId;
    private String shipmentNo;
    private String poNo;
    private String shippingMark;
    private BigDecimal cartonQty;
    private BigDecimal palletQty;
    private BigDecimal weight;
    private BigDecimal cbm;
    private Date dwTime;
    private String groupCode;
    private String remark;
    private Date createTime;

    private List<CargoOrderSkuItemRespVO> skuItems = new ArrayList<>();
}
