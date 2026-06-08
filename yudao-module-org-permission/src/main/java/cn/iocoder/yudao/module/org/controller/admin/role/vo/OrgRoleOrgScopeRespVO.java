package cn.iocoder.yudao.module.org.controller.admin.role.vo;

import cn.iocoder.yudao.module.org.controller.admin.accessible.vo.OrgCompanyAccessibleRespVO;
import cn.iocoder.yudao.module.org.controller.admin.accessible.vo.OrgWarehouseAccessibleRespVO;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.util.List;

@Schema(description = "管理后台 - 角色组织权限 Response VO")
@Data
public class OrgRoleOrgScopeRespVO {

    @Schema(description = "角色编号")
    private Long roleId;

    @Schema(description = "角色名称")
    private String roleName;

    @Schema(description = "组织范围")
    private String orgScope;

    @Schema(description = "主体 ID 列表")
    private List<Long> companyIds;

    @Schema(description = "仓库 ID 列表")
    private List<Long> warehouseIds;

    @Schema(description = "主体明细")
    private List<OrgCompanyAccessibleRespVO> companies;

    @Schema(description = "仓库明细")
    private List<OrgWarehouseAccessibleRespVO> warehouses;

}
