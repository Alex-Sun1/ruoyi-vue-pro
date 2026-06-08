package cn.iocoder.yudao.module.wms.controller.admin.inventory.vo;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class WmsInventoryLockReqVO {

    @NotNull(message = "仓库不能为空")
    private Long warehouseId;
    @NotNull(message = "货件不能为空")
    private Long shipmentId;
    @NotNull(message = "锁定箱数不能为空")
    @Min(value = 1, message = "锁定箱数必须大于0")
    private Integer boxQty;
    @NotBlank(message = "业务单据类型不能为空")
    private String bizDocType;
    private Long bizDocId;
    private Long bizDocLineId;
    private String remark;

}
