package cn.iocoder.yudao.module.wms.controller.admin.inventory.vo;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class WmsPalletMoveReqVO {

    @NotNull(message = "卡板不能为空")
    private Long palletId;
    @NotNull(message = "目标库位不能为空")
    private Long locationId;
    private String remark;

}
