package cn.iocoder.yudao.module.base.controller.admin.platformaddress.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Schema(description = "管理后台 - 平台地址启用/停用 Request VO")
@Data
public class PlatformAddressUpdateStatusReqVO {

    @NotNull(message = "id 不能为空")
    private Long id;

    @NotNull(message = "status 不能为空")
    private Integer status;

    @Schema(description = "变更原因")
    private String changeReason;

}
