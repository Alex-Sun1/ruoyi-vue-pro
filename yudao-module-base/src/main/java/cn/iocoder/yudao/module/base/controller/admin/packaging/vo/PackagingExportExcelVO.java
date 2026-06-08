package cn.iocoder.yudao.module.base.controller.admin.packaging.vo;

import cn.idev.excel.annotation.ExcelProperty;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class PackagingExportExcelVO {

    @ExcelProperty("包装编码")
    private String pkgCode;

    @ExcelProperty("包装名称")
    private String pkgName;

    @ExcelProperty("包装类型")
    private Integer pkgType;

    @ExcelProperty("来源类型")
    private Integer sourceType;

    @ExcelProperty("客户名称")
    private String clientName;

    @ExcelProperty("适用仓库")
    private String warehouseNames;

    @ExcelProperty("长")
    private BigDecimal length;

    @ExcelProperty("宽")
    private BigDecimal width;

    @ExcelProperty("高")
    private BigDecimal height;

    @ExcelProperty("尺寸单位")
    private String dimensionUnit;

    @ExcelProperty("皮重")
    private BigDecimal tareWeight;

    @ExcelProperty("重量单位")
    private String weightUnit;

    @ExcelProperty("状态")
    private Integer status;

    @ExcelProperty("备注")
    private String remark;

}
