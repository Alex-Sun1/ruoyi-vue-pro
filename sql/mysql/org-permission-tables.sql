-- 海外仓组织数据权限（Org Permission，全平台 OMS/WMS/TMS 等）
-- 非侵入：不改 system_role / DataPermission；与 mdm_company、mdm_warehouse 配套使用
-- 依赖：sql/mysql/base-tables.sql 中 mdm_company、mdm_warehouse 已存在
-- 若库内已有 wms_* 表，请执行 org-permission-migrate-from-wms.sql

SET NAMES utf8mb4;

-- ========== 1. 角色组织范围类型（每角色最多一行）==========
DROP TABLE IF EXISTS `org_role_warehouse_scope`;
DROP TABLE IF EXISTS `org_role_company_scope`;
DROP TABLE IF EXISTS `org_role_org_scope`;

CREATE TABLE `org_role_org_scope` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `role_id` bigint NOT NULL COMMENT '角色编号，对应 system_role.id',
  `org_scope` varchar(20) NOT NULL DEFAULT 'ALL' COMMENT '组织范围：ALL / COMPANY / WAREHOUSE',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_role` (`tenant_id`, `role_id`),
  KEY `idx_role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色组织数据权限-范围类型';

-- ========== 2. 角色 ↔ 主体（org_scope=COMPANY）==========
CREATE TABLE `org_role_company_scope` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `role_id` bigint NOT NULL COMMENT '角色编号',
  `company_id` bigint NOT NULL COMMENT '主体编号，mdm_company.id',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_role_company` (`tenant_id`, `role_id`, `company_id`),
  KEY `idx_role_id` (`role_id`),
  KEY `idx_company_id` (`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色组织数据权限-主体明细';

-- ========== 3. 角色 ↔ 仓库（org_scope=WAREHOUSE）==========
CREATE TABLE `org_role_warehouse_scope` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `role_id` bigint NOT NULL COMMENT '角色编号',
  `warehouse_id` bigint NOT NULL COMMENT '仓库编号，mdm_warehouse.id',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_role_warehouse` (`tenant_id`, `role_id`, `warehouse_id`),
  KEY `idx_role_id` (`role_id`),
  KEY `idx_warehouse_id` (`warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色组织数据权限-仓库明细';

-- ========== 4. 权限配置审计日志 ==========
DROP TABLE IF EXISTS `org_permission_log`;
CREATE TABLE `org_permission_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `role_id` bigint DEFAULT NULL COMMENT '角色编号',
  `action` varchar(64) NOT NULL COMMENT 'org_ROLE_ORG_SCOPE_UPDATE / org_ROLE_ORG_SCOPE_DELETE',
  `before_value` text COMMENT '变更前 JSON',
  `after_value` text COMMENT '变更后 JSON',
  `operator_user_id` bigint DEFAULT NULL COMMENT '操作人用户编号',
  `operator_name` varchar(64) DEFAULT NULL COMMENT '操作人昵称',
  `remark` varchar(512) DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  KEY `idx_tenant_role` (`tenant_id`, `role_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='海外仓组织权限变更日志';

-- ========== P0-f 试点业务表（@OrgDataScope 联调）==========
DROP TABLE IF EXISTS `org_scope_pilot_record`;
CREATE TABLE `org_scope_pilot_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `biz_code` varchar(64) NOT NULL COMMENT '业务单号',
  `warehouse_id` bigint NOT NULL COMMENT '仓库编号',
  `remark` varchar(512) DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  KEY `idx_warehouse_id` (`warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='组织数据权限试点单据';
