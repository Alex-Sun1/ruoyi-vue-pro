package cn.iocoder.yudao.module.base.controller.admin.platformaddress.vo;

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
public class PlatformAddressImportExcelVO {

    @ExcelProperty("平台代码")
    private String platformCode;

    @ExcelProperty("地址编码")
    private String addressCode;

    @ExcelProperty("地址类型")
    private Integer addressType;

    @ExcelProperty("英文名称")
    private String nameEn;

    @ExcelProperty("国家代码")
    private String countryCode;

    @ExcelProperty("州省代码")
    private String stateCode;

    @ExcelProperty("城市")
    private String city;

    @ExcelProperty("地址行1")
    private String addressLine1;

    @ExcelProperty("邮编")
    private String zipCode;

    @ExcelProperty("仓库属性")
    private String whProperty;

    @ExcelProperty("单托CBM")
    private BigDecimal palletCbm;

    @ExcelProperty("是否过磅站")
    private Integer isWeighStation;

    @ExcelProperty("最高重量(吨)")
    private BigDecimal maxWeightTon;

    @ExcelProperty("联系人")
    private String contactName;

    @ExcelProperty("联系电话")
    private String contactPhone;

    @ExcelProperty("备注")
    private String remark;

}
