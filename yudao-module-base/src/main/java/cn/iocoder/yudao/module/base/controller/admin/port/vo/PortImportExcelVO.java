package cn.iocoder.yudao.module.base.controller.admin.port.vo;

import cn.idev.excel.annotation.ExcelProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class PortImportExcelVO {

    @ExcelProperty("港口代码(UN/LOCODE)")
    private String portCode;

    @ExcelProperty("英文名称")
    private String nameEn;

    @ExcelProperty("国家代码")
    private String countryCode;

    @ExcelProperty("州省代码")
    private String stateCode;

    @ExcelProperty("城市")
    private String city;

    @ExcelProperty("港口类型(1海港2空港3内陆港)")
    private Integer portType;

    @ExcelProperty("时区代码")
    private String timezone;

    @ExcelProperty("海柜查询链接")
    private String containerQueryUrl;

    @ExcelProperty("备注")
    private String remark;

}
