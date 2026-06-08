-- ============================================================
-- Vessel master data
-- Date: 2026-05-24
-- ============================================================

CREATE TABLE IF NOT EXISTS `base_vessel` (
  `id` bigint NOT NULL COMMENT 'Primary key',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT 'Tenant ID',
  `vessel_code` varchar(64) NOT NULL COMMENT 'Vessel code',
  `vessel_name` varchar(128) NOT NULL COMMENT 'Vessel name',
  `vessel_name_en` varchar(128) DEFAULT NULL COMMENT 'English vessel name',
  `imo_no` varchar(64) DEFAULT NULL COMMENT 'IMO number',
  `mmsi` varchar(64) DEFAULT NULL COMMENT 'MMSI',
  `call_sign` varchar(64) DEFAULT NULL COMMENT 'Call sign',
  `shipping_line_id` bigint NOT NULL COMMENT 'Shipping line ID',
  `shipping_line_code` varchar(64) DEFAULT NULL COMMENT 'Shipping line code',
  `shipping_line_name` varchar(128) DEFAULT NULL COMMENT 'Shipping line name',
  `vessel_type` varchar(32) DEFAULT 'CONTAINER' COMMENT 'CONTAINER/BULK/REEFER/RORO/OTHER',
  `capacity_teu` int DEFAULT NULL COMMENT 'TEU capacity',
  `length_m` decimal(10,2) DEFAULT NULL COMMENT 'Length in meters',
  `width_m` decimal(10,2) DEFAULT NULL COMMENT 'Width in meters',
  `build_year` int DEFAULT NULL COMMENT 'Build year',
  `flag_country` varchar(64) DEFAULT NULL COMMENT 'Flag country',
  `status` varchar(32) NOT NULL DEFAULT '0' COMMENT '0 enabled / 1 disabled',
  `remark` varchar(500) DEFAULT NULL COMMENT 'Remark',
  `create_dept` bigint DEFAULT NULL COMMENT 'Create department',
  `create_by` bigint DEFAULT NULL COMMENT 'Create user',
  `create_time` datetime DEFAULT NULL COMMENT 'Create time',
  `update_by` bigint DEFAULT NULL COMMENT 'Update user',
  `update_time` datetime DEFAULT NULL COMMENT 'Update time',
  `del_flag` bigint NOT NULL DEFAULT 0 COMMENT 'Delete flag',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_vessel_code_tenant` (`vessel_code`, `tenant_id`),
  KEY `idx_vessel_line` (`tenant_id`, `shipping_line_id`),
  KEY `idx_vessel_imo` (`tenant_id`, `imo_no`),
  KEY `idx_vessel_name` (`tenant_id`, `vessel_name`),
  KEY `idx_vessel_status` (`tenant_id`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Vessel master';

INSERT IGNORE INTO sys_dict_type (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `create_by`, `create_time`, `remark`)
VALUES (9004100, '000000', CONVERT(0xE888B9E888B6E7B1BBE59E8B USING utf8mb4), 'base_vessel_type', 1, NOW(), 'Vessel type dictionary');

INSERT IGNORE INTO sys_dict_data (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_by`, `create_time`, `remark`)
VALUES
(9004200, '000000', 1, CONVERT(0xE99B86E8A385E7AEB1E888B9 USING utf8mb4), 'CONTAINER', 'base_vessel_type', '', 'success', 'Y', 1, NOW(), 'Container vessel'),
(9004201, '000000', 2, CONVERT(0xE695A3E8B4A7E888B9 USING utf8mb4), 'BULK', 'base_vessel_type', '', 'info', 'N', 1, NOW(), 'Bulk vessel'),
(9004202, '000000', 3, CONVERT(0xE586B7E8978FE888B9 USING utf8mb4), 'REEFER', 'base_vessel_type', '', 'warning', 'N', 1, NOW(), 'Reefer vessel'),
(9004203, '000000', 4, CONVERT(0xE6BB9AE8A385E888B9 USING utf8mb4), 'RORO', 'base_vessel_type', '', 'default', 'N', 1, NOW(), 'Ro-Ro vessel'),
(9004204, '000000', 5, CONVERT(0xE585B6E4BB96 USING utf8mb4), 'OTHER', 'base_vessel_type', '', 'default', 'N', 1, NOW(), 'Other vessel');

-- Menu: basic data -> logistics basic data -> vessel
INSERT IGNORE INTO sys_menu VALUES(2306, CONVERT(0xE888B9E888B6E7AEA1E79086 USING utf8mb4), 2009, 5, 'vessel', 'base/vessel/index', '', 1, 0, 'C', '0', '0', 'base:vessel:list', 'directions-boat', 103, 1, NOW(), NULL, NULL, 'Vessel menu');
INSERT IGNORE INTO sys_menu VALUES(2360, CONVERT(0xE888B9E888B6E69FA5E8AFA2 USING utf8mb4), 2306, 1, '#', '', '', 1, 0, 'F', '0', '0', 'base:vessel:query', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2361, CONVERT(0xE888B9E888B6E696B0E5A29E USING utf8mb4), 2306, 2, '#', '', '', 1, 0, 'F', '0', '0', 'base:vessel:add', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2362, CONVERT(0xE888B9E888B6E4BFAEE694B9 USING utf8mb4), 2306, 3, '#', '', '', 1, 0, 'F', '0', '0', 'base:vessel:edit', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2363, CONVERT(0xE888B9E888B6E588A0E999A4 USING utf8mb4), 2306, 4, '#', '', '', 1, 0, 'F', '0', '0', 'base:vessel:remove', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2364, CONVERT(0xE888B9E888B6E5AFBCE587BA USING utf8mb4), 2306, 5, '#', '', '', 1, 0, 'F', '0', '0', 'base:vessel:export', '#', 103, 1, NOW(), NULL, NULL, '');

INSERT IGNORE INTO `base_vessel` (`id`, `tenant_id`, `vessel_code`, `vessel_name`, `vessel_name_en`, `imo_no`, `mmsi`, `call_sign`, `shipping_line_id`, `shipping_line_code`, `shipping_line_name`, `vessel_type`, `capacity_teu`, `length_m`, `width_m`, `build_year`, `flag_country`, `status`, `remark`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`)
SELECT 3011001, '000000', 'VSL000001', 'COSCO SHIPPING AQUARIUS', 'COSCO SHIPPING AQUARIUS', '9789347', '477123456', 'VRAB8', sl.id, sl.code, sl.name_abbr, 'CONTAINER', 20908, 400.00, 58.60, 2017, 'Hong Kong', '0', 'Demo vessel', 1, NOW(), 1, NOW(), 0 FROM shipping_line sl WHERE sl.code='COSU' LIMIT 1;
INSERT IGNORE INTO `base_vessel` (`id`, `tenant_id`, `vessel_code`, `vessel_name`, `vessel_name_en`, `imo_no`, `mmsi`, `call_sign`, `shipping_line_id`, `shipping_line_code`, `shipping_line_name`, `vessel_type`, `capacity_teu`, `length_m`, `width_m`, `build_year`, `flag_country`, `status`, `remark`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`)
SELECT 3011002, '000000', 'VSL000002', 'EVER LOGIC', 'EVER LOGIC', '9851234', '563123456', '9VLOG', sl.id, sl.code, sl.name_abbr, 'CONTAINER', 14200, 366.00, 51.00, 2020, 'Singapore', '0', 'Demo vessel', 1, NOW(), 1, NOW(), 0 FROM shipping_line sl WHERE sl.code='EGLV' LIMIT 1;
INSERT IGNORE INTO `base_vessel` (`id`, `tenant_id`, `vessel_code`, `vessel_name`, `vessel_name_en`, `imo_no`, `mmsi`, `call_sign`, `shipping_line_id`, `shipping_line_code`, `shipping_line_name`, `vessel_type`, `capacity_teu`, `length_m`, `width_m`, `build_year`, `flag_country`, `status`, `remark`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`)
SELECT 3011003, '000000', 'VSL000003', 'MSC GULSUN', 'MSC GULSUN', '9831111', '636123456', 'D5GS8', sl.id, sl.code, sl.name_abbr, 'CONTAINER', 23756, 399.90, 61.50, 2019, 'Panama', '0', 'Demo vessel', 1, NOW(), 1, NOW(), 0 FROM shipping_line sl WHERE sl.code='MSCU' LIMIT 1;
INSERT IGNORE INTO `base_vessel` (`id`, `tenant_id`, `vessel_code`, `vessel_name`, `vessel_name_en`, `imo_no`, `mmsi`, `call_sign`, `shipping_line_id`, `shipping_line_code`, `shipping_line_name`, `vessel_type`, `capacity_teu`, `length_m`, `width_m`, `build_year`, `flag_country`, `status`, `remark`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`)
SELECT 3011004, '000000', 'VSL000004', 'MAERSK SEATTLE', 'MAERSK SEATTLE', '9899999', '219123456', 'OXST2', sl.id, sl.code, sl.name_abbr, 'CONTAINER', 15500, 353.00, 53.50, 2018, 'Denmark', '0', 'Demo vessel', 1, NOW(), 1, NOW(), 0 FROM shipping_line sl WHERE sl.code='MAEU' LIMIT 1;
INSERT IGNORE INTO `base_vessel` (`id`, `tenant_id`, `vessel_code`, `vessel_name`, `vessel_name_en`, `imo_no`, `mmsi`, `call_sign`, `shipping_line_id`, `shipping_line_code`, `shipping_line_name`, `vessel_type`, `capacity_teu`, `length_m`, `width_m`, `build_year`, `flag_country`, `status`, `remark`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`)
SELECT 3011005, '000000', 'VSL000005', 'ZIM ASHDOD', 'ZIM ASHDOD', '9701111', '428123456', '4XZA8', sl.id, sl.code, sl.name_abbr, 'CONTAINER', 10000, 300.00, 48.20, 2016, 'Israel', '0', 'Demo vessel', 1, NOW(), 1, NOW(), 0 FROM shipping_line sl WHERE sl.code='ZIMU' LIMIT 1;
