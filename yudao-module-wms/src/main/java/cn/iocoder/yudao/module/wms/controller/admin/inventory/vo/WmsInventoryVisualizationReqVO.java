package cn.iocoder.yudao.module.wms.controller.admin.inventory.vo;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class WmsInventoryVisualizationReqVO {

    @NotNull(message = "仓库不能为空")
    private Long warehouseId;
    private Long zoneId;
    private String zoneKeyword;

}
