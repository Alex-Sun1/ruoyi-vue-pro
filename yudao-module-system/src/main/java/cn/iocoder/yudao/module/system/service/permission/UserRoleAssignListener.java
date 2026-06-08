package cn.iocoder.yudao.module.system.service.permission;

/**
 * 用户角色分配变更回调（可选扩展点）。
 * <p>
 * 由 {@code yudao-module-org-permission} 等模块实现，用于失效组织数据权限缓存等。
 */
public interface UserRoleAssignListener {

    void onUserRoleChanged(Long userId);

}
