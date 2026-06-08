package cn.iocoder.yudao.module.system.service.auth;

import cn.iocoder.yudao.module.system.controller.admin.auth.vo.AuthOrgPermissionVO;

/**
 * 登录权限信息中的组织数据权限扩展点。
 * <p>
 * 由 {@code yudao-module-org-permission} 实现；未引入该模块时不注入。
 */
public interface AuthPermissionOrgContributor {

    AuthOrgPermissionVO buildOrgPermission(Long userId);

}
