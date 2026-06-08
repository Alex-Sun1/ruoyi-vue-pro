package cn.iocoder.yudao.module.base.controller.admin.vessel.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Schema(description = "管理后台 - 船舶状态更新 Request VO")
@Data
public class VesselUpdateStatusReqVO {

    @NotNull(message = "编号不能为空")
    private Long id;

    @NotNull(message = "状态不能为空")
    private Integer status;

}
