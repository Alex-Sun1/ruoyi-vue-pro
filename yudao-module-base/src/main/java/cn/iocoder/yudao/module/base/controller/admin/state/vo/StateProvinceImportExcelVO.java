package cn.iocoder.yudao.module.base.controller.admin.state.vo;

import cn.idev.excel.annotation.ExcelProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class StateProvinceImportExcelVO {

    @ExcelProperty("国家代码")
    private String countryCode;

    @ExcelProperty("州省代码")
    private String code;

    @ExcelProperty("英文名称")
    private String nameEn;

}
