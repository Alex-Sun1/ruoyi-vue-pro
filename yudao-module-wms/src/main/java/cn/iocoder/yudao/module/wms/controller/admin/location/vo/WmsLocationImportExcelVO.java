package cn.iocoder.yudao.module.wms.controller.admin.location.vo;

import cn.idev.excel.annotation.ExcelProperty;
import lombok.Data;

@Data
public class WmsLocationImportExcelVO {

    @ExcelProperty("所属库区")
    private String zoneName;
    @ExcelProperty("库位编码")
    private String locationCode;
    @ExcelProperty("行")
    private String rowNo;
    @ExcelProperty("列")
    private String columnNo;
    @ExcelProperty("库位容量")
    private Integer capacity;
    @ExcelProperty("状态")
    private String status;

}
