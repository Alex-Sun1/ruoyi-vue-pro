package cn.iocoder.yudao.module.wms.controller.admin.location.vo;

import cn.idev.excel.annotation.ExcelIgnoreUnannotated;
import cn.idev.excel.annotation.ExcelProperty;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@ExcelIgnoreUnannotated
public class WmsLocationRespVO {

    private Long id;
    private Long companyId;
    private Long warehouseId;
    private String warehouseCode;
    @ExcelProperty("仓库")
    private String warehouseName;
    private Long zoneId;
    @ExcelProperty("库区")
    private String zoneName;
    @ExcelProperty("库位编码")
    private String locationCode;
    @ExcelProperty("行")
    private String rowNo;
    @ExcelProperty("列")
    private String columnNo;
    @ExcelProperty("库位容量")
    private Integer capacity;
    @ExcelProperty("现有库存")
    private Integer currentQty;
    @ExcelProperty("剩余容量")
    private Integer remainingCapacity;
    @ExcelProperty("状态")
    private String status;
    private String remark;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;

}
