package cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo;

import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderSkuItemRespVO;

import cn.idev.excel.annotation.ExcelIgnoreUnannotated;
import cn.idev.excel.annotation.ExcelProperty;
import lombok.Data;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder.CargoOrderSkuItemDO;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

@Data
@ExcelIgnoreUnannotated
public class CargoOrderSkuItemRespVO implements Serializable {

    private Long id;
    private Long cargoOrderId;
    private Long shipmentId;

    @ExcelProperty("货件编码")
    private String shipmentNo;

    @ExcelProperty("PO号")
    private String poNo;

    @ExcelProperty("唛头")
    private String shippingMark;

    @ExcelProperty("SKU")
    private String sku;

    @ExcelProperty("FNSKU")
    private String fnsku;

    @ExcelProperty("商品名称")
    private String productName;

    @ExcelProperty("数量")
    private BigDecimal qty;

    @ExcelProperty("箱数")
    private BigDecimal cartonQty;

    @ExcelProperty("重量(kg)")
    private BigDecimal weight;

    @ExcelProperty("体积(m³)")
    private BigDecimal cbm;

    private String remark;
    private Date createTime;
}
