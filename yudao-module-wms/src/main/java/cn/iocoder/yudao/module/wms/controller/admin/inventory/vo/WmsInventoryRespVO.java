package cn.iocoder.yudao.module.wms.controller.admin.inventory.vo;

import cn.idev.excel.annotation.ExcelIgnoreUnannotated;
import cn.idev.excel.annotation.ExcelProperty;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@ExcelIgnoreUnannotated
public class WmsInventoryRespVO {

    private Long id;
    private Long companyId;
    private Long warehouseId;
    private String warehouseCode;
    @ExcelProperty("仓库")
    private String warehouseName;
    private Long customerId;
    @ExcelProperty("客户")
    private String customerName;
    private Long cargoOrderId;
    @ExcelProperty("货物订单")
    private String cargoOrderNo;
    private Long shipmentId;
    @ExcelProperty("货件编码")
    private String shipmentCode;
    @ExcelProperty("总箱数")
    private Integer totalBoxQty;
    @ExcelProperty("可用箱数")
    private Integer availableBoxQty;
    @ExcelProperty("锁定箱数")
    private Integer lockedBoxQty;
    @ExcelProperty("异常箱数")
    private Integer exceptionBoxQty;
    @ExcelProperty("总重量")
    private BigDecimal totalWeight;
    @ExcelProperty("总体积")
    private BigDecimal totalCbm;
    @ExcelProperty("状态")
    private String inventoryStatus;
    private Integer version;
    private String remark;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;

}
