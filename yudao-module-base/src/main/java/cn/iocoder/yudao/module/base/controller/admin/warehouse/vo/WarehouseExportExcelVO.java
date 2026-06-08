package cn.iocoder.yudao.module.base.controller.admin.warehouse.vo;

import cn.idev.excel.annotation.ExcelProperty;
import lombok.Data;

@Data
public class WarehouseExportExcelVO {

    @ExcelProperty("仓库编码")
    private String warehouseCode;

    @ExcelProperty("仓库名称")
    private String warehouseName;

    @ExcelProperty("归属主体")
    private String companyName;

    @ExcelProperty("作业时区")
    private String timezoneCode;

    @ExcelProperty("国家代码")
    private String countryCode;

    @ExcelProperty("地址")
    private String address;

    @ExcelProperty("状态")
    private Integer status;

    @ExcelProperty("排序")
    private Integer sort;

    @ExcelProperty("备注")
    private String remark;

    @ExcelProperty("仓库类型")
    private String warehouseType;

    @ExcelProperty("州/省代码")
    private String stateCode;

    @ExcelProperty("城市")
    private String city;

    @ExcelProperty("邮编")
    private String zipCode;

    @ExcelProperty("货币代码")
    private String currencyCode;

    @ExcelProperty("联系人")
    private String contactName;

    @ExcelProperty("联系电话")
    private String contactPhone;

    @ExcelProperty("是否保税仓")
    private Integer isBonded;

    @ExcelProperty("支持卸货")
    private Integer supportUnloading;

    @ExcelProperty("支持一件代发")
    private Integer supportDropship;

    @ExcelProperty("支持中转")
    private Integer supportTransit;

    @ExcelProperty("支持转仓")
    private Integer supportTransfer;

    @ExcelProperty("支持FBA")
    private Integer supportFba;

    @ExcelProperty("支持自提")
    private Integer supportSelfPickup;

    @ExcelProperty("支持预约")
    private Integer supportAppointment;

    @ExcelProperty("PDA启用")
    private Integer pdaEnabled;

    @ExcelProperty("API启用")
    private Integer apiEnabled;

}
