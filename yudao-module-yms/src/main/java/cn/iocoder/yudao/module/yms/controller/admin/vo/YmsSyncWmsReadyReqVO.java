package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.Date;

@Data
public class YmsSyncWmsReadyReqVO {

    @NotNull(message = "任务ID不能为空")
    private Long yardTaskId;

    /** PENDING / READY / NOT_REQUIRED */
    @NotBlank(message = "备货状态不能为空")
    private String wmsReadyStatus;

    private Date wmsReadyTime;
}
