-- ============================================================
-- 码头管理：表结构、菜单权限、演示数据
-- 日期：2026-05-23
-- ============================================================

CREATE TABLE IF NOT EXISTS `base_terminal` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `terminal_code` varchar(64) NOT NULL COMMENT '码头代码',
  `terminal_name` varchar(128) NOT NULL COMMENT '码头名称',
  `terminal_name_en` varchar(128) DEFAULT NULL COMMENT '英文名称',
  `port_id` bigint NOT NULL COMMENT '所属港口ID',
  `port_code` varchar(64) DEFAULT NULL COMMENT '所属港口代码',
  `port_name` varchar(128) DEFAULT NULL COMMENT '所属港口名称',
  `country_code` varchar(32) DEFAULT NULL COMMENT '国家代码',
  `state_code` varchar(32) DEFAULT NULL COMMENT '州/省代码',
  `city` varchar(128) DEFAULT NULL COMMENT '城市',
  `address` varchar(255) DEFAULT NULL COMMENT '地址',
  `contact_phone` varchar(64) DEFAULT NULL COMMENT '联系电话',
  `contact_email` varchar(128) DEFAULT NULL COMMENT '联系邮箱',
  `website` varchar(255) DEFAULT NULL COMMENT '官网',
  `appointment_supported` tinyint NOT NULL DEFAULT 0 COMMENT '是否支持预约',
  `default_appointment_method` varchar(32) DEFAULT NULL COMMENT '默认预约方式：EMAIL/PLATFORM/PHONE/API',
  `default_release_method` varchar(32) DEFAULT NULL COMMENT '默认放行方式：DO/EDO/PIN/EMAIL_RELEASE/PAPER',
  `timezone` varchar(64) DEFAULT NULL COMMENT '时区',
  `status` varchar(32) NOT NULL DEFAULT '0' COMMENT '状态（0启用/1停用）',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` bigint NOT NULL DEFAULT 0 COMMENT '删除标志',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_terminal_code_tenant` (`terminal_code`, `tenant_id`),
  KEY `idx_terminal_port` (`tenant_id`, `port_id`),
  KEY `idx_terminal_status` (`tenant_id`, `status`),
  KEY `idx_terminal_release_method` (`default_release_method`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='码头管理';

-- 物流基础资料目录：按产品口径统一名称
UPDATE sys_menu
SET menu_name = '物流基础资料', update_time = NOW()
WHERE menu_id = 2009;

-- 菜单顺序：港口、码头、船司
UPDATE sys_menu
SET order_num = 3, update_time = NOW()
WHERE menu_id = 2302;

INSERT IGNORE INTO sys_menu VALUES(2304, '码头管理', 2009, 2, 'terminal', 'base/terminal/index', '', 1, 0, 'C', '0', '0', 'base:terminal:list', 'map', 103, 1, NOW(), NULL, NULL, '码头管理菜单');
INSERT IGNORE INTO sys_menu VALUES(2340, '码头查询', 2304, 1, '#', '', '', 1, 0, 'F', '0', '0', 'base:terminal:query', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2341, '码头新增', 2304, 2, '#', '', '', 1, 0, 'F', '0', '0', 'base:terminal:add', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2342, '码头修改', 2304, 3, '#', '', '', 1, 0, 'F', '0', '0', 'base:terminal:edit', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2343, '码头删除', 2304, 4, '#', '', '', 1, 0, 'F', '0', '0', 'base:terminal:remove', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2344, '码头导出', 2304, 5, '#', '', '', 1, 0, 'F', '0', '0', 'base:terminal:export', '#', 103, 1, NOW(), NULL, NULL, '');

-- 演示数据：港口不存在时不插入，避免脏关联
INSERT IGNORE INTO `base_terminal` (
  `id`, `tenant_id`, `terminal_code`, `terminal_name`, `terminal_name_en`,
  `port_id`, `port_code`, `port_name`, `country_code`, `state_code`, `city`,
  `address`, `contact_phone`, `contact_email`, `website`,
  `appointment_supported`, `default_appointment_method`, `default_release_method`,
  `timezone`, `status`, `remark`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`
)
SELECT 3008001, '000000', 'APM', 'APM Terminals', 'APM Terminals Los Angeles',
       p.id, p.port_code, p.name_en, p.country_code, p.state_code, p.city,
       '100 E 9th St, Wilmington, CA 90744', '+1 310-123-4567', NULL, 'https://www.apmterminals.com',
       1, 'EMAIL', 'EMAIL_RELEASE', p.timezone, '0', '洛杉矶港 APM 码头', 1, NOW(), 1, NOW(), 0
FROM port p WHERE p.port_code = 'USLAX' LIMIT 1;

INSERT IGNORE INTO `base_terminal` (
  `id`, `tenant_id`, `terminal_code`, `terminal_name`, `terminal_name_en`,
  `port_id`, `port_code`, `port_name`, `country_code`, `state_code`, `city`,
  `address`, `contact_phone`, `contact_email`, `website`,
  `appointment_supported`, `default_appointment_method`, `default_release_method`,
  `timezone`, `status`, `remark`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`
)
SELECT 3008002, '000000', 'TRAPAC', 'TraPac Container Terminal', 'TraPac Container Terminal',
       p.id, p.port_code, p.name_en, p.country_code, p.state_code, p.city,
       '727 N Harbor Blvd, Wilmington, CA 90744', '+1 310-234-5678', NULL, 'https://www.trapac.com',
       1, 'PLATFORM', 'EDO', p.timezone, '0', '洛杉矶港 TraPac 码头', 1, NOW(), 1, NOW(), 0
FROM port p WHERE p.port_code = 'USLAX' LIMIT 1;

INSERT IGNORE INTO `base_terminal` (
  `id`, `tenant_id`, `terminal_code`, `terminal_name`, `terminal_name_en`,
  `port_id`, `port_code`, `port_name`, `country_code`, `state_code`, `city`,
  `address`, `contact_phone`, `contact_email`, `website`,
  `appointment_supported`, `default_appointment_method`, `default_release_method`,
  `timezone`, `status`, `remark`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`
)
SELECT 3008003, '000000', 'LBCT', 'Long Beach Container Terminal', 'Long Beach Container Terminal',
       p.id, p.port_code, p.name_en, p.country_code, p.state_code, p.city,
       '2360 Pier G Ave, Long Beach, CA 90802', '+1 562-345-6789', NULL, 'https://www.lbct.com',
       1, 'PLATFORM', 'PIN', p.timezone, '0', '长滩港 LBCT 码头', 1, NOW(), 1, NOW(), 0
FROM port p WHERE p.port_code = 'USLGB' LIMIT 1;

INSERT IGNORE INTO `base_terminal` (
  `id`, `tenant_id`, `terminal_code`, `terminal_name`, `terminal_name_en`,
  `port_id`, `port_code`, `port_name`, `country_code`, `state_code`, `city`,
  `address`, `contact_phone`, `contact_email`, `website`,
  `appointment_supported`, `default_appointment_method`, `default_release_method`,
  `timezone`, `status`, `remark`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`
)
SELECT 3008004, '000000', 'PIERA', 'Pier A Terminal', 'Pier A Terminal',
       p.id, p.port_code, p.name_en, p.country_code, p.state_code, p.city,
       '100 Aquarium Way, Long Beach, CA 90802', '+1 562-456-7890', NULL, NULL,
       1, 'EMAIL', 'EMAIL_RELEASE', p.timezone, '0', '长滩港 Pier A 码头', 1, NOW(), 1, NOW(), 0
FROM port p WHERE p.port_code = 'USLGB' LIMIT 1;

INSERT IGNORE INTO `base_terminal` (
  `id`, `tenant_id`, `terminal_code`, `terminal_name`, `terminal_name_en`,
  `port_id`, `port_code`, `port_name`, `country_code`, `state_code`, `city`,
  `address`, `contact_phone`, `contact_email`, `website`,
  `appointment_supported`, `default_appointment_method`, `default_release_method`,
  `timezone`, `status`, `remark`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`
)
SELECT 3008005, '000000', 'HOUSTONCT', 'Bayport Container Terminal', 'Bayport Container Terminal',
       p.id, p.port_code, p.name_en, p.country_code, p.state_code, p.city,
       '4020 McKinney St, Pasadena, TX 77507', '+1 713-678-9012', NULL, NULL,
       1, 'PHONE', 'PIN', p.timezone, '1', '休斯顿 Bayport 码头演示停用数据', 1, NOW(), 1, NOW(), 0
FROM port p WHERE p.port_code = 'USHOU' LIMIT 1;
