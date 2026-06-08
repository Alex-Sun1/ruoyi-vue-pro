package cn.iocoder.yudao.module.base.controller.admin.country.vo;

import cn.idev.excel.annotation.ExcelProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class CountryImportExcelVO {

    @ExcelProperty("国家代码")
    private String code;

    @ExcelProperty("英文名称")
    private String nameEn;

    @ExcelProperty("电话区号")
    private String phoneCode;

    @ExcelProperty("默认货币代码")
    private String currencyCode;

    @ExcelProperty("默认时区代码")
    private String timezoneDefault;

    @ExcelProperty("是否开通(1/0)")
    private Integer isActive;

}
