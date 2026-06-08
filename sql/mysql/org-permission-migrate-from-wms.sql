-- 将已执行的 wms_* 组织权限表重命名为 org_*（仅当库内存在 wms_role_org_scope 且无 org_role_org_scope 时执行）
-- 执行前请备份数据库

SET NAMES utf8mb4;

-- 角色组织范围
SET @has_wms_scope := (
    SELECT COUNT(*) FROM information_schema.tables
    WHERE table_schema = DATABASE() AND table_name = 'wms_role_org_scope'
);
SET @has_org_scope := (
    SELECT COUNT(*) FROM information_schema.tables
    WHERE table_schema = DATABASE() AND table_name = 'org_role_org_scope'
);
-- 使用存储过程风格：MySQL 需手动确认后执行下列 RENAME（无 org 表且存在 wms 表时）

-- RENAME TABLE `wms_role_org_scope` TO `org_role_org_scope`;
-- RENAME TABLE `wms_role_company_scope` TO `org_role_company_scope`;
-- RENAME TABLE `wms_role_warehouse_scope` TO `org_role_warehouse_scope`;
-- RENAME TABLE `wms_permission_log` TO `org_permission_log`;
-- RENAME TABLE `wms_scope_pilot_record` TO `org_scope_pilot_record`;

-- Redis：旧 key wms:perm:{tenantId}:{userId} 需自然过期或手动删除；新 key 为 org:perm:{tenantId}:{userId}
