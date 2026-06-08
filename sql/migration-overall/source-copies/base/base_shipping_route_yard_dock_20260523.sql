-- ============================================================
-- Shipping route + yard dock master data
-- Date: 2026-05-23
-- Notes:
--   1. sys_menu Chinese names are written with UTF-8 hex literals to avoid
--      client encoding issues in PowerShell/MySQL Workbench.
--   2. Demo rows depend on existing port, shipping_line and mdm_warehouse data.
-- ============================================================

CREATE TABLE IF NOT EXISTS `base_shipping_route` (
  `id` bigint NOT NULL COMMENT 'Primary key',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT 'Tenant ID',
  `route_code` varchar(64) NOT NULL COMMENT 'Route code',
  `route_name` varchar(128) NOT NULL COMMENT 'Route name',
  `route_name_en` varchar(128) DEFAULT NULL COMMENT 'English route name',
  `shipping_line_id` bigint DEFAULT NULL COMMENT 'Shipping line ID',
  `shipping_line_code` varchar(64) DEFAULT NULL COMMENT 'Shipping line code',
  `shipping_line_name` varchar(128) DEFAULT NULL COMMENT 'Shipping line name',
  `origin_port_id` bigint DEFAULT NULL COMMENT 'Origin port ID',
  `origin_port_code` varchar(64) DEFAULT NULL COMMENT 'Origin port code',
  `origin_port_name` varchar(128) DEFAULT NULL COMMENT 'Origin port name',
  `destination_port_id` bigint DEFAULT NULL COMMENT 'Destination port ID',
  `destination_port_code` varchar(64) DEFAULT NULL COMMENT 'Destination port code',
  `destination_port_name` varchar(128) DEFAULT NULL COMMENT 'Destination port name',
  `default_transit_days` int DEFAULT NULL COMMENT 'Default transit days',
  `route_type` varchar(32) DEFAULT NULL COMMENT 'DIRECT/TRANSSHIP',
  `reference_min_days` int DEFAULT NULL COMMENT 'Reference minimum days',
  `reference_avg_days` int DEFAULT NULL COMMENT 'Reference average days',
  `reference_max_days` int DEFAULT NULL COMMENT 'Reference maximum days',
  `reference_freight` decimal(10,2) DEFAULT NULL COMMENT 'Reference freight',
  `status` varchar(32) NOT NULL DEFAULT '0' COMMENT '0 enabled / 1 disabled',
  `remark` varchar(500) DEFAULT NULL COMMENT 'Remark',
  `create_dept` bigint DEFAULT NULL COMMENT 'Create department',
  `create_by` bigint DEFAULT NULL COMMENT 'Create user',
  `create_time` datetime DEFAULT NULL COMMENT 'Create time',
  `update_by` bigint DEFAULT NULL COMMENT 'Update user',
  `update_time` datetime DEFAULT NULL COMMENT 'Update time',
  `del_flag` bigint NOT NULL DEFAULT 0 COMMENT 'Delete flag',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_route_code_tenant` (`route_code`, `tenant_id`),
  KEY `idx_route_line` (`tenant_id`, `shipping_line_id`),
  KEY `idx_route_ports` (`origin_port_id`, `destination_port_id`),
  KEY `idx_route_status` (`tenant_id`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Shipping route master';

CREATE TABLE IF NOT EXISTS `yard_dock` (
  `id` bigint NOT NULL COMMENT 'Primary key',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT 'Tenant ID',
  `dock_code` varchar(64) NOT NULL COMMENT 'Dock code',
  `dock_name` varchar(128) NOT NULL COMMENT 'Dock name',
  `warehouse_id` bigint NOT NULL COMMENT 'Warehouse ID',
  `warehouse_code` varchar(64) DEFAULT NULL COMMENT 'Warehouse code',
  `warehouse_name` varchar(128) DEFAULT NULL COMMENT 'Warehouse name',
  `dock_type` varchar(32) NOT NULL COMMENT 'LOADING/UNLOADING/MIXED',
  `dock_location` varchar(64) DEFAULT NULL COMMENT 'Dock location',
  `applicable_operation_types` varchar(255) DEFAULT NULL COMMENT 'Applicable operation types',
  `allowed_vehicle_types` varchar(255) DEFAULT NULL COMMENT 'Allowed vehicle types',
  `appointment_supported` tinyint NOT NULL DEFAULT 1 COMMENT 'Appointment supported',
  `max_load_tons` decimal(10,2) DEFAULT NULL COMMENT 'Max load tons',
  `hourly_capacity` int DEFAULT NULL COMMENT 'Hourly capacity',
  `max_concurrent` int NOT NULL DEFAULT 1 COMMENT 'Max concurrent',
  `dock_status` varchar(32) NOT NULL DEFAULT 'IDLE' COMMENT 'IDLE/OCCUPIED/MAINTENANCE/DISABLED',
  `enabled_flag` tinyint NOT NULL DEFAULT 1 COMMENT 'Enabled flag',
  `sort_order` int DEFAULT 0 COMMENT 'Sort order',
  `remark` varchar(500) DEFAULT NULL COMMENT 'Remark',
  `create_dept` bigint DEFAULT NULL COMMENT 'Create department',
  `create_by` bigint DEFAULT NULL COMMENT 'Create user',
  `create_time` datetime DEFAULT NULL COMMENT 'Create time',
  `update_by` bigint DEFAULT NULL COMMENT 'Update user',
  `update_time` datetime DEFAULT NULL COMMENT 'Update time',
  `del_flag` bigint NOT NULL DEFAULT 0 COMMENT 'Delete flag',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_dock_code_tenant` (`dock_code`, `tenant_id`),
  KEY `idx_dock_warehouse` (`tenant_id`, `warehouse_id`),
  KEY `idx_dock_status` (`dock_status`, `enabled_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Yard dock master';

-- Menu: basic data -> logistics basic data -> shipping route
INSERT IGNORE INTO sys_menu VALUES(2305, CONVERT(0xE888AAE7BABFE7AEA1E79086 USING utf8mb4), 2009, 4, 'shipping-route', 'base/shipping-route/index', '', 1, 0, 'C', '0', '0', 'base:shippingRoute:list', 'branches', 103, 1, NOW(), NULL, NULL, 'Shipping route menu');
INSERT IGNORE INTO sys_menu VALUES(2350, CONVERT(0xE888AAE7BABFE69FA5E8AFA2 USING utf8mb4), 2305, 1, '#', '', '', 1, 0, 'F', '0', '0', 'base:shippingRoute:query', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2351, CONVERT(0xE888AAE7BABFE696B0E5A29E USING utf8mb4), 2305, 2, '#', '', '', 1, 0, 'F', '0', '0', 'base:shippingRoute:add', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2352, CONVERT(0xE888AAE7BABFE4BFAEE694B9 USING utf8mb4), 2305, 3, '#', '', '', 1, 0, 'F', '0', '0', 'base:shippingRoute:edit', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2353, CONVERT(0xE888AAE7BABFE588A0E999A4 USING utf8mb4), 2305, 4, '#', '', '', 1, 0, 'F', '0', '0', 'base:shippingRoute:remove', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2354, CONVERT(0xE888AAE7BABFE5AFBCE587BA USING utf8mb4), 2305, 5, '#', '', '', 1, 0, 'F', '0', '0', 'base:shippingRoute:export', '#', 103, 1, NOW(), NULL, NULL, '');

-- Menu: basic data -> yard management -> dock
INSERT IGNORE INTO sys_menu VALUES(2600, CONVERT(0xE59BADE58CBAE7AEA1E79086 USING utf8mb4), 2000, 7, 'yard', NULL, '', 1, 0, 'M', '0', '0', '', 'warehouse', 103, 1, NOW(), NULL, NULL, 'Yard management menu');
INSERT IGNORE INTO sys_menu VALUES(2601, CONVERT(0xE69C88E58FB0E8AEBEE7BDAE USING utf8mb4), 2600, 1, 'dock', 'yard/dock/index', '', 1, 0, 'C', '0', '0', 'yard:dock:list', 'home', 103, 1, NOW(), NULL, NULL, 'Dock setup menu');
INSERT IGNORE INTO sys_menu VALUES(2610, CONVERT(0xE69C88E58FB0E69FA5E8AFA2 USING utf8mb4), 2601, 1, '#', '', '', 1, 0, 'F', '0', '0', 'yard:dock:query', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2611, CONVERT(0xE69C88E58FB0E696B0E5A29E USING utf8mb4), 2601, 2, '#', '', '', 1, 0, 'F', '0', '0', 'yard:dock:add', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2612, CONVERT(0xE69C88E58FB0E4BFAEE694B9 USING utf8mb4), 2601, 3, '#', '', '', 1, 0, 'F', '0', '0', 'yard:dock:edit', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2613, CONVERT(0xE69C88E58FB0E588A0E999A4 USING utf8mb4), 2601, 4, '#', '', '', 1, 0, 'F', '0', '0', 'yard:dock:remove', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2614, CONVERT(0xE69C88E58FB0E5AFBCE587BA USING utf8mb4), 2601, 5, '#', '', '', 1, 0, 'F', '0', '0', 'yard:dock:export', '#', 103, 1, NOW(), NULL, NULL, '');

-- Demo data: shipping route
INSERT IGNORE INTO `base_shipping_route` (`id`, `tenant_id`, `route_code`, `route_name`, `shipping_line_id`, `shipping_line_code`, `shipping_line_name`, `origin_port_id`, `origin_port_code`, `origin_port_name`, `destination_port_id`, `destination_port_code`, `destination_port_name`, `default_transit_days`, `route_type`, `reference_min_days`, `reference_avg_days`, `reference_max_days`, `reference_freight`, `status`, `remark`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`)
SELECT 3009001, '000000', 'AAS2', 'US West Express AAS2', sl.id, sl.code, sl.name_abbr, op.id, op.port_code, op.name_en, dp.id, dp.port_code, dp.name_en, 12, 'DIRECT', 11, 14, 17, 1850.00, '0', 'Main US West route', 1, NOW(), 1, NOW(), 0
FROM shipping_line sl JOIN port op ON op.port_code='CNSZX' JOIN port dp ON dp.port_code='USLAX' WHERE sl.code='COSU' LIMIT 1;
INSERT IGNORE INTO `base_shipping_route` (`id`, `tenant_id`, `route_code`, `route_name`, `shipping_line_id`, `shipping_line_code`, `shipping_line_name`, `origin_port_id`, `origin_port_code`, `origin_port_name`, `destination_port_id`, `destination_port_code`, `destination_port_name`, `default_transit_days`, `route_type`, `reference_min_days`, `reference_avg_days`, `reference_max_days`, `reference_freight`, `status`, `remark`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`)
SELECT 3009002, '000000', 'SEA', 'Southeast Asia Express SEA', sl.id, sl.code, sl.name_abbr, op.id, op.port_code, op.name_en, dp.id, dp.port_code, dp.name_en, 12, 'DIRECT', 11, 14, 17, 1700.00, '0', 'Tokyo transit reference', 1, NOW(), 1, NOW(), 0
FROM shipping_line sl JOIN port op ON op.port_code='CNNBO' JOIN port dp ON dp.port_code='USLAX' WHERE sl.code='EGLV' LIMIT 1;
INSERT IGNORE INTO `base_shipping_route` (`id`, `tenant_id`, `route_code`, `route_name`, `shipping_line_id`, `shipping_line_code`, `shipping_line_name`, `origin_port_id`, `origin_port_code`, `origin_port_name`, `destination_port_id`, `destination_port_code`, `destination_port_name`, `default_transit_days`, `route_type`, `reference_min_days`, `reference_avg_days`, `reference_max_days`, `reference_freight`, `status`, `remark`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`)
SELECT 3009003, '000000', 'TP1', 'Trans-Pacific TP1', sl.id, sl.code, sl.name_abbr, op.id, op.port_code, op.name_en, dp.id, dp.port_code, dp.name_en, 15, 'DIRECT', 14, 18, 21, 2100.00, '0', 'Peak season capacity tight', 1, NOW(), 1, NOW(), 0
FROM shipping_line sl JOIN port op ON op.port_code='CNSHA' JOIN port dp ON dp.port_code='USLAX' WHERE sl.code='MSCU' LIMIT 1;

-- Demo data: yard dock
INSERT IGNORE INTO `yard_dock` (`id`, `tenant_id`, `dock_code`, `dock_name`, `warehouse_id`, `warehouse_code`, `warehouse_name`, `dock_type`, `dock_location`, `applicable_operation_types`, `allowed_vehicle_types`, `appointment_supported`, `max_load_tons`, `hourly_capacity`, `max_concurrent`, `dock_status`, `enabled_flag`, `sort_order`, `remark`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`)
SELECT 3010001, '000000', 'DOC-LA-001', 'LA Dock 1', w.id, w.warehouse_code, w.warehouse_name, 'LOADING', 'A-01', 'Inbound,Outbound', '53FT,40HQ', 1, 20.00, 45, 1, 'IDLE', 1, 1, 'Standard dock', 1, NOW(), 1, NOW(), 0 FROM mdm_warehouse w WHERE w.warehouse_code='LA01' LIMIT 1;
INSERT IGNORE INTO `yard_dock` (`id`, `tenant_id`, `dock_code`, `dock_name`, `warehouse_id`, `warehouse_code`, `warehouse_name`, `dock_type`, `dock_location`, `applicable_operation_types`, `allowed_vehicle_types`, `appointment_supported`, `max_load_tons`, `hourly_capacity`, `max_concurrent`, `dock_status`, `enabled_flag`, `sort_order`, `remark`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`)
SELECT 3010002, '000000', 'DOC-LA-002', 'LA Dock 2', w.id, w.warehouse_code, w.warehouse_name, 'UNLOADING', 'A-02', 'Inbound', '53FT,40HQ', 1, 20.00, 50, 1, 'OCCUPIED', 1, 2, 'Hydraulic plate', 1, NOW(), 1, NOW(), 0 FROM mdm_warehouse w WHERE w.warehouse_code='LA01' LIMIT 1;
INSERT IGNORE INTO `yard_dock` (`id`, `tenant_id`, `dock_code`, `dock_name`, `warehouse_id`, `warehouse_code`, `warehouse_name`, `dock_type`, `dock_location`, `applicable_operation_types`, `allowed_vehicle_types`, `appointment_supported`, `max_load_tons`, `hourly_capacity`, `max_concurrent`, `dock_status`, `enabled_flag`, `sort_order`, `remark`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`)
SELECT 3010003, '000000', 'DOC-NJ-001', 'NJ Dock 1', w.id, w.warehouse_code, w.warehouse_name, 'MIXED', 'B-01', 'Inbound,Outbound', '53FT,40HQ', 1, 20.00, 45, 1, 'MAINTENANCE', 1, 3, 'Under maintenance', 1, NOW(), 1, NOW(), 0 FROM mdm_warehouse w WHERE w.warehouse_code='NJ01' LIMIT 1;
