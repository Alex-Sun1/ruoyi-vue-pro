package cn.iocoder.yudao.module.wms.controller.admin.inventory.vo;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class WmsInventoryReceiveReqVO {

    private Long companyId;
    @NotNull(message = "仓库不能为空")
    private Long warehouseId;
    private String warehouseCode;
    private String warehouseName;
    private Long customerId;
    private String customerName;
    @NotNull(message = "货物订单不能为空")
    private Long cargoOrderId;
    @NotBlank(message = "货物订单号不能为空")
    private String cargoOrderNo;
    @NotNull(message = "货件不能为空")
    private Long shipmentId;
    @NotBlank(message = "货件编码不能为空")
    private String shipmentCode;
    @NotBlank(message = "卡板号不能为空")
    private String palletNo;
    private Long zoneId;
    private String zoneCode;
    private String zoneName;
    private Long locationId;
    private String locationCode;
    @NotNull(message = "箱数不能为空")
    @Min(value = 1, message = "箱数必须大于0")
    private Integer boxQty;
    private BigDecimal weight;
    private BigDecimal cbm;
    private String bizDocType;
    private Long bizDocId;
    private Long bizDocLineId;
    private String remark;

}
