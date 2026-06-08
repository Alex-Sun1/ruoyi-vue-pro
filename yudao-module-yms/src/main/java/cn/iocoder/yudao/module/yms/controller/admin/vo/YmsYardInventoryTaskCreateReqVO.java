package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

@Data
public class YmsYardInventoryTaskCreateReqVO {

    @NotNull(message = "仓库不能为空")
    private Long warehouseId;

    @NotBlank(message = "盘点类型不能为空")
    private String inventoryType;

    private Long zoneId;

    /** CONTAINER_LIST 类型时指定柜号/车厢号列表 */
    private List<String> objectNos;

    private String remark;
}
