package cn.iocoder.yudao.module.base.controller.admin.platformaddress.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

@Schema(description = "管理后台 - 平台地址变更记录 Response VO")
@Data
public class PlatformAddressChangeLogRespVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "平台地址 ID")
    private Long platformAddressId;

    @Schema(description = "变更类型")
    private String changeType;

    @Schema(description = "变更前")
    private String beforeValue;

    @Schema(description = "变更后")
    private String afterValue;

    @Schema(description = "变更原因")
    private String changeReason;

    @Schema(description = "操作人")
    private String operatorName;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

}
