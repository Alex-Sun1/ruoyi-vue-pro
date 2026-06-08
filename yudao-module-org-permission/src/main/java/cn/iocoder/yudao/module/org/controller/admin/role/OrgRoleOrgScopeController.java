package cn.iocoder.yudao.module.org.controller.admin.role;

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.module.org.controller.admin.role.vo.OrgRoleOrgScopeRespVO;
import cn.iocoder.yudao.module.org.controller.admin.role.vo.OrgRoleOrgScopeSaveReqVO;
import cn.iocoder.yudao.module.org.service.permission.OrgRoleOrgScopeService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - 角色组织数据权限")
@RestController
@RequestMapping("/org/role/org-scope")
@Validated
public class OrgRoleOrgScopeController {

    @Resource
    private OrgRoleOrgScopeService orgRoleOrgScopeService;

    @GetMapping
    @Operation(summary = "查询角色组织权限")
    @Parameter(name = "roleId", description = "角色编号", required = true)
    @PreAuthorize("@ss.hasPermission('system:role:query') or @ss.hasPermission('system:role:update')")
    public CommonResult<OrgRoleOrgScopeRespVO> getRoleOrgScope(@RequestParam("roleId") Long roleId) {
        return success(orgRoleOrgScopeService.getRoleOrgScope(roleId));
    }

    @PostMapping
    @Operation(summary = "保存角色组织权限")
    @PreAuthorize("@ss.hasPermission('system:role:update')")
    public CommonResult<Boolean> saveRoleOrgScope(@Valid @RequestBody OrgRoleOrgScopeSaveReqVO reqVO) {
        orgRoleOrgScopeService.saveRoleOrgScope(reqVO);
        return success(true);
    }

    @DeleteMapping
    @Operation(summary = "删除角色组织权限")
    @Parameter(name = "roleId", description = "角色编号", required = true)
    @PreAuthorize("@ss.hasPermission('system:role:update')")
    public CommonResult<Boolean> deleteRoleOrgScope(@RequestParam("roleId") Long roleId) {
        orgRoleOrgScopeService.deleteRoleOrgScope(roleId);
        return success(true);
    }

}
