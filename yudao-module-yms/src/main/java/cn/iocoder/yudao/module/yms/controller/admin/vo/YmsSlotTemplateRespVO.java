package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

@Data
public class YmsSlotTemplateRespVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long warehouseId;
    private String warehouseName;
    private String weekdays;
    private String slotStart;
    private String slotEnd;
    private Integer capacity;
    private String taskType;
    private Integer enabled;
    private String remark;
}
