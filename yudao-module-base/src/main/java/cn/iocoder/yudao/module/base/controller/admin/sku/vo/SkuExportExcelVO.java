package cn.iocoder.yudao.module.base.controller.admin.sku.vo;

import cn.idev.excel.annotation.ExcelProperty;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class SkuExportExcelVO {

    @ExcelProperty("客户名称")
    private String clientName;

    @ExcelProperty("SKU编码")
    private String skuCode;

    @ExcelProperty("SKU名称")
    private String skuName;

    @ExcelProperty("英文名称")
    private String skuNameEn;

    @ExcelProperty("条码")
    private String barcode;

    @ExcelProperty("单位")
    private String unit;

    @ExcelProperty("长(cm)")
    private BigDecimal lengthCm;

    @ExcelProperty("宽(cm)")
    private BigDecimal widthCm;

    @ExcelProperty("高(cm)")
    private BigDecimal heightCm;

    @ExcelProperty("重量(kg)")
    private BigDecimal weightKg;

    @ExcelProperty("体积(CBM)")
    private BigDecimal volumeCbm;

    @ExcelProperty("状态")
    private Integer status;

    @ExcelProperty("备注")
    private String remark;

}
