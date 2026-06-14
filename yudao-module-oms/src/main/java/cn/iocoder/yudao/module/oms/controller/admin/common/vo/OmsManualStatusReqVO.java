package cn.iocoder.yudao.module.oms.controller.admin.common.vo;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class OmsManualStatusReqVO {

    @NotBlank(message = "targetStatus is required")
    private String targetStatus;

    @NotBlank(message = "reason is required")
    private String reason;
}
