package cn.iocoder.yudao.module.org.service.permission;

import cn.iocoder.yudao.module.system.service.permission.UserRoleAssignListener;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Component;

/**
 * 用户角色变更时失效组织数据权限 Redis 缓存（org:perm:*）
 */
@Component
public class OrgUserRoleAssignListener implements UserRoleAssignListener {

    @Resource
    private OrgPermissionService orgPermissionService;

    @Override
    public void onUserRoleChanged(Long userId) {
        orgPermissionService.evictUserCache(userId);
    }

}
