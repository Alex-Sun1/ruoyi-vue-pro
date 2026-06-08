-- 组织数据权限试点数据（P0-f 联调，需已执行 org-permission-tables.sql 与 base-mock-data.sql）
SET NAMES utf8mb4;

SET @tenant_id := 1;
SET @creator := 'admin';
SET @now := NOW();

INSERT INTO `org_scope_pilot_record` (`id`, `biz_code`, `warehouse_id`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`) VALUES
(1, 'PILOT-9001-001', 9001, 'LA 仓试点', @creator, @now, @creator, @now, b'0', @tenant_id),
(2, 'PILOT-9001-002', 9001, 'LA 仓试点2', @creator, @now, @creator, @now, b'0', @tenant_id),
(3, 'PILOT-9002-001', 9002, 'NJ 仓试点', @creator, @now, @creator, @now, b'0', @tenant_id),
(4, 'PILOT-9003-001', 9003, 'SZ 仓试点', @creator, @now, @creator, @now, b'0', @tenant_id);
