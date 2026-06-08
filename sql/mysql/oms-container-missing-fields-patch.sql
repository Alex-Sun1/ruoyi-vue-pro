-- OMS sea-container missing fields migrated from overallSystem.
-- Safe to execute repeatedly in MySQL.

SET @schema_name := DATABASE();

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_container_terminal_info' AND COLUMN_NAME = 'hold_type') = 0,
  'ALTER TABLE `oms_container_terminal_info` ADD COLUMN `hold_type` varchar(64) DEFAULT NULL COMMENT ''Hold类型'' AFTER `chassis_free_until`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_container_terminal_info' AND COLUMN_NAME = 'hold_since') = 0,
  'ALTER TABLE `oms_container_terminal_info` ADD COLUMN `hold_since` datetime DEFAULT NULL COMMENT ''Hold开始时间'' AFTER `hold_type`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_container_terminal_info' AND COLUMN_NAME = 'hold_resolved_at') = 0,
  'ALTER TABLE `oms_container_terminal_info` ADD COLUMN `hold_resolved_at` datetime DEFAULT NULL COMMENT ''Hold解除时间'' AFTER `hold_since`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_container_terminal_info' AND COLUMN_NAME = 'exam_type') = 0,
  'ALTER TABLE `oms_container_terminal_info` ADD COLUMN `exam_type` varchar(64) DEFAULT NULL COMMENT ''查验类型'' AFTER `hold_resolved_at`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_container_terminal_info' AND COLUMN_NAME = 'exam_tags') = 0,
  'ALTER TABLE `oms_container_terminal_info` ADD COLUMN `exam_tags` json DEFAULT NULL COMMENT ''查验标签'' AFTER `exam_type`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_container_transport_info' AND COLUMN_NAME = 'trucker_id') = 0,
  'ALTER TABLE `oms_container_transport_info` ADD COLUMN `trucker_id` bigint DEFAULT NULL COMMENT ''拖车公司ID'' AFTER `voyage_no`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_container_transport_info' AND COLUMN_NAME = 'trucker_name') = 0,
  'ALTER TABLE `oms_container_transport_info` ADD COLUMN `trucker_name` varchar(128) DEFAULT NULL COMMENT ''拖车公司'' AFTER `trucker_id`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_container_transport_info' AND COLUMN_NAME = 'tms_drayage_order_id') = 0,
  'ALTER TABLE `oms_container_transport_info` ADD COLUMN `tms_drayage_order_id` varchar(64) DEFAULT NULL COMMENT ''TMS拖车单ID'' AFTER `trucker_name`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_container_transport_info' AND COLUMN_NAME = 'dock_id') = 0,
  'ALTER TABLE `oms_container_transport_info` ADD COLUMN `dock_id` bigint DEFAULT NULL COMMENT ''月台ID'' AFTER `arrived_at`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
