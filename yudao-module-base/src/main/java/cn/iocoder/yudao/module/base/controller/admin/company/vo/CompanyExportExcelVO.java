package cn.iocoder.yudao.module.base.controller.admin.company.vo;

import cn.idev.excel.annotation.ExcelProperty;
import lombok.Data;

@Data
public class CompanyExportExcelVO {

    @ExcelProperty("主体编码")
    private String companyCode;

    @ExcelProperty("主体名称")
    private String companyName;

    @ExcelProperty("英文名称")
    private String companyNameEn;

    @ExcelProperty("税号")
    private String taxNo;

    @ExcelProperty("状态")
    private Integer status;

    @ExcelProperty("排序")
    private Integer sort;

    @ExcelProperty("备注")
    private String remark;

    @ExcelProperty("国家代码")
    private String countryCode;

    @ExcelProperty("注册地址")
    private String registeredAddr;

    @ExcelProperty("是否VAT注册")
    private Integer vatRegistered;

    @ExcelProperty("开票抬头")
    private String invoiceTitle;

    @ExcelProperty("开票税号")
    private String invoiceTaxNo;

    @ExcelProperty("银行名称")
    private String bankName;

    @ExcelProperty("SWIFT/BIC代码")
    private String swiftCode;

    @ExcelProperty("收款人")
    private String beneficiary;

    @ExcelProperty("结算货币代码")
    private String currencyCode;

    @ExcelProperty("时区")
    private String timezone;

}
