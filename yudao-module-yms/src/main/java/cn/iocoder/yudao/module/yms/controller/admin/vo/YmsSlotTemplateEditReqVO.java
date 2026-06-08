package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsSlotTemplateDO;

@Data
public class YmsSlotTemplateEditReqVO {

    @NotNull(message = "ID不能为空")
    private Long id;

    private Long warehouseId;
    private String weekdays;
    private String slotStart;
    private String slotEnd;
    private Integer capacity;
    private String taskType;
    private Integer enabled;
    private String remark;
}
