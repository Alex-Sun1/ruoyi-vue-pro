package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsSlotTemplateDO;

@Data
public class YmsSlotTemplateAddReqVO {

    @NotNull(message = "仓库不能为空")
    private Long warehouseId;

    @NotBlank(message = "适用星期不能为空")
    private String weekdays;

    @NotBlank(message = "时段开始不能为空")
    private String slotStart;

    @NotBlank(message = "时段结束不能为空")
    private String slotEnd;

    @NotNull(message = "容量不能为空")
    private Integer capacity;

    private String taskType;
    private Integer enabled;
    private String remark;
}
