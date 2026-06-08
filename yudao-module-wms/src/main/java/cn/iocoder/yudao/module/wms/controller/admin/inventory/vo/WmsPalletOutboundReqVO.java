package cn.iocoder.yudao.module.wms.controller.admin.inventory.vo;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class WmsPalletOutboundReqVO {

    @NotNull(message = "卡板不能为空")
    private Long palletId;
    private String remark;

}
