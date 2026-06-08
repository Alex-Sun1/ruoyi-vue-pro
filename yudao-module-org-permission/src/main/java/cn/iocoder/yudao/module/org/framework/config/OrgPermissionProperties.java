package cn.iocoder.yudao.module.org.framework.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import java.util.Arrays;
import java.util.List;

@Data
@Component
@ConfigurationProperties(prefix = "yudao.org.permission")
public class OrgPermissionProperties {

    /**
     * 视为「租户内全部仓库」的角色 code（平台/租户超管）
     */
    private List<String> platformAdminRoleCodes = Arrays.asList(
            "super_admin", "tenant_admin", "ROLE_PLATFORM_ADMIN");

    /**
     * 权限缓存 TTL（分钟）
     */
    private int cacheTtlMinutes = 30;

}
