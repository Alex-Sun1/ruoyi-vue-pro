package cn.iocoder.yudao.module.org.service.permission;

import cn.iocoder.yudao.module.org.controller.admin.role.vo.OrgRoleOrgScopeRespVO;
import cn.iocoder.yudao.module.org.controller.admin.role.vo.OrgRoleOrgScopeSaveReqVO;

public interface OrgRoleOrgScopeService {

    OrgRoleOrgScopeRespVO getRoleOrgScope(Long roleId);

    void saveRoleOrgScope(OrgRoleOrgScopeSaveReqVO reqVO);

    void deleteRoleOrgScope(Long roleId);

}
