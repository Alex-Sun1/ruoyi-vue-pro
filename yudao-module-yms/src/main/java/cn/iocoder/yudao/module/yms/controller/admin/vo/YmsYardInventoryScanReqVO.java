package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class YmsYardInventoryScanReqVO {

    @NotNull(message = "盘点任务ID不能为空")
    private Long inventoryId;

    @NotBlank(message = "对象编号不能为空")
    private String objectNo;

    private String objectType;

    private Long actualPositionId;
    private String actualPositionCode;

    private String photoUrls;
    private String remark;
}
