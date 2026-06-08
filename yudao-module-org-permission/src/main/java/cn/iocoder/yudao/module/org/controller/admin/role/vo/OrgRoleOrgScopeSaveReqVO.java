package cn.iocoder.yudao.module.org.controller.admin.role.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

@Schema(description = "管理后台 - 角色组织权限保存 Request VO")
@Data
public class OrgRoleOrgScopeSaveReqVO {

    @Schema(description = "角色编号", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotNull(message = "角色编号不能为空")
    private Long roleId;

    @Schema(description = "组织范围 ALL/COMPANY/WAREHOUSE", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotBlank(message = "组织范围不能为空")
    private String orgScope;

    @Schema(description = "主体编号列表")
    private List<Long> companyIds;

    @Schema(description = "仓库编号列表")
    private List<Long> warehouseIds;

}
