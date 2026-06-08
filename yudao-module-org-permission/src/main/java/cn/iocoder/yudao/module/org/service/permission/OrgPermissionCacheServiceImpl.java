package cn.iocoder.yudao.module.org.service.permission;

import cn.hutool.core.collection.CollUtil;
import cn.iocoder.yudao.framework.common.util.json.JsonUtils;
import cn.iocoder.yudao.module.org.framework.config.OrgPermissionProperties;
import cn.iocoder.yudao.module.org.service.permission.dto.OrgUserOrgPermissionDTO;
import jakarta.annotation.Resource;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.concurrent.TimeUnit;

@Service
public class OrgPermissionCacheServiceImpl implements OrgPermissionCacheService {

    private static final String KEY_PATTERN = "org:perm:%d:%d";

    @Resource
    private StringRedisTemplate stringRedisTemplate;
    @Resource
    private OrgPermissionProperties orgPermissionProperties;

    @Override
    public OrgUserOrgPermissionDTO get(Long tenantId, Long userId) {
        String json = stringRedisTemplate.opsForValue().get(formatKey(tenantId, userId));
        if (json == null) {
            return null;
        }
        return JsonUtils.parseObject(json, OrgUserOrgPermissionDTO.class);
    }

    @Override
    public void set(Long tenantId, Long userId, OrgUserOrgPermissionDTO permission) {
        stringRedisTemplate.opsForValue().set(formatKey(tenantId, userId),
                JsonUtils.toJsonString(permission),
                orgPermissionProperties.getCacheTtlMinutes(), TimeUnit.MINUTES);
    }

    @Override
    public void evict(Long tenantId, Long userId) {
        stringRedisTemplate.delete(formatKey(tenantId, userId));
    }

    @Override
    public void evictUsers(Long tenantId, Collection<Long> userIds) {
        if (CollUtil.isEmpty(userIds)) {
            return;
        }
        userIds.forEach(userId -> evict(tenantId, userId));
    }

    private static String formatKey(Long tenantId, Long userId) {
        return String.format(KEY_PATTERN, tenantId, userId);
    }

}
