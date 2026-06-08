package cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo;

import cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerCargoOrderImportExcelVO;

import cn.idev.excel.annotation.ExcelProperty;
import lombok.Data;

import java.math.BigDecimal;

/**
 * 海柜关联货物订单 Excel 导入（扁平：同一分组号多行 = 多货件）
 */
@Data
public class ContainerCargoOrderImportExcelVO {

    @ExcelProperty("导入分组号")
    private String groupNo;

    @ExcelProperty("参考号")
    private String externalOrderNo;

    @ExcelProperty("客户ID")
    private Long customerId;

    @ExcelProperty("客户名称")
    private String customerName;

    @ExcelProperty("业务类型ID")
    private Long businessTypeId;

    @ExcelProperty("渠道ID")
    private Long channelId;

    @ExcelProperty("平台ID")
    private Long platformId;

    @ExcelProperty("地址类型")
    private String addressType;

    @ExcelProperty("仓库代码")
    private String platformWarehouseCode;

    @ExcelProperty("收货方")
    private String consigneeName;

    @ExcelProperty("地址1")
    private String addressLine1;

    @ExcelProperty("地址2")
    private String addressLine2;

    @ExcelProperty("City")
    private String city;

    @ExcelProperty("State")
    private String state;

    @ExcelProperty("Zip")
    private String zipCode;

    @ExcelProperty("Country")
    private String country;

    @ExcelProperty("联系人")
    private String contactName;

    @ExcelProperty("电话")
    private String contactPhone;

    @ExcelProperty("邮箱")
    private String contactEmail;

    @ExcelProperty("计量单位")
    private String forecastQtyUnit;

    @ExcelProperty("是否转仓")
    private String transferFlagText;

    @ExcelProperty("转仓仓库代码")
    private String transferWarehouseCode;

    @ExcelProperty("货件编码")
    private String shipmentNo;

    @ExcelProperty("PO号")
    private String poNo;

    @ExcelProperty("唛头")
    private String shippingMark;

    @ExcelProperty("箱数")
    private BigDecimal cartonQty;

    @ExcelProperty("板数")
    private BigDecimal palletQty;

    @ExcelProperty("重量KG")
    private BigDecimal weight;

    @ExcelProperty("体积CBM")
    private BigDecimal cbm;

    @ExcelProperty("DW时间")
    private String dwTimeText;

    @ExcelProperty("客户备注")
    private String customerRemark;

    @ExcelProperty("内部备注")
    private String internalRemark;
}
