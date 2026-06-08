-- ============================================================
-- 月台设置字段调整
-- Date: 2026-05-24
-- 说明：执行前请备份 yard_dock 表；若列已存在请跳过对应 ALTER
-- ============================================================

-- 1. 新增字段
ALTER TABLE `yard_dock`
  ADD COLUMN `location_type` varchar(32) NOT NULL DEFAULT 'DOCK' COMMENT '位置类型：DOCK道口/PARKING停车位' AFTER `dock_name`,
  ADD COLUMN `business_type_id` bigint DEFAULT NULL COMMENT '适合业务类型ID' AFTER `warehouse_name`,
  ADD COLUMN `business_type_code` varchar(64) DEFAULT NULL COMMENT '适合业务类型编码' AFTER `business_type_id`,
  ADD COLUMN `business_type_name` varchar(128) DEFAULT NULL COMMENT '适合业务类型名称' AFTER `business_type_code`,
  ADD COLUMN `grid_row` int DEFAULT NULL COMMENT '行' AFTER `dock_location`,
  ADD COLUMN `grid_col` int DEFAULT NULL COMMENT '列' AFTER `grid_row`,
  ADD COLUMN `dispatch_priority` int NOT NULL DEFAULT 1 COMMENT '调度优先级' AFTER `sort_order`;

-- 2. 删除废弃字段（月台类型/适用作业类型/最大承重/作业数量）
ALTER TABLE `yard_dock`
  DROP COLUMN `dock_type`,
  DROP COLUMN `applicable_operation_types`,
  DROP COLUMN `max_load_tons`,
  DROP COLUMN `hourly_capacity`;

-- 3. 字典：位置类型（道口/停车位）
INSERT IGNORE INTO sys_dict_type (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `create_by`, `create_time`, `remark`)
VALUES (9005100, '000000', CONVERT(0xE69C88E58FB0E4BD8DE7BDAEE7B1BBE59E8B USING utf8mb4), 'yard_location_type', 1, NOW(), 'Dock location type');

INSERT IGNORE INTO sys_dict_data (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_by`, `create_time`, `remark`)
VALUES
(9005200, '000000', 1, CONVERT(0xE98193E58FA3 USING utf8mb4), 'DOCK', 'yard_location_type', '', 'info', 'Y', 1, NOW(), 'Dock'),
(9005201, '000000', 2, CONVERT(0xE59C9EE8BDA6E4BD8D USING utf8mb4), 'PARKING', 'yard_location_type', '', 'default', 'N', 1, NOW(), 'Parking space');

-- 4. 字典：月台位置
INSERT IGNORE INTO sys_dict_type (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `create_by`, `create_time`, `remark`)
VALUES (9005101, '000000', CONVERT(0xE69C88E58FB0E4BD8D USING utf8mb4), 'yard_dock_location', 1, NOW(), 'Dock yard position');

INSERT IGNORE INTO sys_dict_data (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_by`, `create_time`, `remark`)
VALUES
(9005210, '000000', 1, CONVERT(0xE5898DE99DA2E98193E58FA3 USING utf8mb4), 'FRONT_YARD_DOCK', 'yard_dock_location', '', 'success', 'N', 1, NOW(), 'Front yard dock'),
(9005211, '000000', 2, CONVERT(0xE5908EE99DA2E98193E58FA3 USING utf8mb4), 'BACK_YARD_DOCK', 'yard_dock_location', '', 'info', 'Y', 1, NOW(), 'Back yard dock'),
(9005212, '000000', 3, CONVERT(0xE5898DE99DA2E59C9EE8BDA6E4BD8D USING utf8mb4), 'FRONT_YARD_PARKING', 'yard_dock_location', '', 'warning', 'N', 1, NOW(), 'Front yard parking'),
(9005213, '000000', 4, CONVERT(0xE5908EE99DA2E59C9EE8BDA6E4BD8D USING utf8mb4), 'BACK_YARD_PARKING', 'yard_dock_location', '', 'default', 'N', 1, NOW(), 'Back yard parking');
