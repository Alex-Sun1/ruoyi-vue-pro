package cn.iocoder.yudao.module.base.controller.admin.packaging.vo;

import cn.idev.excel.annotation.ExcelProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class PackagingImportExcelVO {

    @ExcelProperty("包装编码")
    private String pkgCode;

    @ExcelProperty("包装名称")
    private String pkgName;

    @ExcelProperty("包装类型(1-5)")
    private Integer pkgType;

    @ExcelProperty("来源类型(1-3)")
    private Integer sourceType;

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

    @ExcelProperty("备注")
    private String remark;

}
