package cn.iocoder.yudao.module.system.controller.admin.auth.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.util.Set;

@Schema(description = "管理后台 - 登录用户海外仓组织数据权限（可选扩展）")
@Data
public class AuthOrgPermissionVO {

    @Schema(description = "可见主体 ID 集合")
    private Set<Long> visibleCompanyIds;

    @Schema(description = "可见仓库 ID 集合")
    private Set<Long> visibleWarehouseIds;

    @Schema(description = "组织范围摘要：ALL / COMPANY / WAREHOUSE")
    private String orgScopeSummary;

}
