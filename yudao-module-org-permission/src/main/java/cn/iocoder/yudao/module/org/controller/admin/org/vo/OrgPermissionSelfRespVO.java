package cn.iocoder.yudao.module.org.controller.admin.org.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.util.Set;

@Schema(description = "管理后台 - 当前用户海外仓组织权限")
@Data
public class OrgPermissionSelfRespVO {

    @Schema(description = "可见主体 ID")
    private Set<Long> visibleCompanyIds;

    @Schema(description = "可见仓库 ID")
    private Set<Long> visibleWarehouseIds;

    @Schema(description = "组织范围摘要")
    private String orgScopeSummary;

}
