package cn.iocoder.yudao.module.base.controller.admin.city.vo;

import cn.idev.excel.annotation.ExcelProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class CityImportExcelVO {

    @ExcelProperty("国家代码")
    private String countryCode;

    @ExcelProperty("州省代码")
    private String stateCode;

    @ExcelProperty("城市英文名称")
    private String nameEn;

}
