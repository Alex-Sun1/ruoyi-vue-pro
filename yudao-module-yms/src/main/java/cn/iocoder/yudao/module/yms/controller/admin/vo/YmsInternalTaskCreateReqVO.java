package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class YmsInternalTaskCreateReqVO {

    @NotNull(message = "仓库不能为空")
    private Long warehouseId;

    @NotBlank(message = "任务类型不能为空")
    private String internalTaskType;

    @NotBlank(message = "对象类型不能为空")
    private String objectType;

    private Long objectId;
    private String objectNo;

    private Long parentYardTaskId;
    private String parentYardTaskNo;

    private Long fromPositionId;
    private String fromPositionCode;
    private Long toPositionId;
    private String toPositionCode;
    private Long toDockId;
    private String toDockCode;

    private Integer priority;
    private String remark;
}
