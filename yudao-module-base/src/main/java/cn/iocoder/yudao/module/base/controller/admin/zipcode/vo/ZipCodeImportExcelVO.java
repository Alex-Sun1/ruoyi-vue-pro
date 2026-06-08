package cn.iocoder.yudao.module.base.controller.admin.zipcode.vo;

import cn.idev.excel.annotation.ExcelProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ZipCodeImportExcelVO {

    @ExcelProperty("国家代码")
    private String countryCode;

    @ExcelProperty("州省代码")
    private String stateCode;

    @ExcelProperty("城市名称")
    private String cityName;

    @ExcelProperty("邮编")
    private String zip;

}
