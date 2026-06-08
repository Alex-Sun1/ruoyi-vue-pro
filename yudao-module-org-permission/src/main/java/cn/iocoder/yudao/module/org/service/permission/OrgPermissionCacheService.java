package cn.iocoder.yudao.module.org.service.permission;

import cn.iocoder.yudao.module.org.service.permission.dto.OrgUserOrgPermissionDTO;

import java.util.Collection;

public interface OrgPermissionCacheService {

    OrgUserOrgPermissionDTO get(Long tenantId, Long userId);

    void set(Long tenantId, Long userId, OrgUserOrgPermissionDTO permission);

    void evict(Long tenantId, Long userId);

    void evictUsers(Long tenantId, Collection<Long> userIds);

}
