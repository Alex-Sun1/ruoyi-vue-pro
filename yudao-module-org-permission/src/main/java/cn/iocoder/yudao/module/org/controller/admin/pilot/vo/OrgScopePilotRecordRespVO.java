package cn.iocoder.yudao.module.org.controller.admin.pilot.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

@Schema(description = "管理后台 - 组织权限试点单据 Response VO")
@Data
public class OrgScopePilotRecordRespVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "业务单号")
    private String bizCode;

    @Schema(description = "仓库编号")
    private Long warehouseId;

    @Schema(description = "备注")
    private String remark;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

}
