package cn.iocoder.yudao.module.org.framework.datapermission.aop;

import cn.iocoder.yudao.framework.datapermission.core.annotation.DataPermission;
import cn.iocoder.yudao.module.org.framework.datapermission.rule.OrgWarehouseDataPermissionRule;

import java.lang.annotation.*;

/**
 * 仅启用海外仓仓库数据权限规则（排除部门规则）
 */
@DataPermission(includeRules = {OrgWarehouseDataPermissionRule.class})
@Target({ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface EnableOrgWarehouseDataPermission {
}
