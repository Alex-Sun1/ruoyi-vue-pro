-- 货物订单出单关联字段（参考系统已有，部分环境未执行 init 段）
SET @schema_name := DATABASE();

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_cargo_order' AND COLUMN_NAME = 'outbound_direction') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `outbound_direction` varchar(32) DEFAULT NULL COMMENT ''出单方向 DELIVERY/TRANSFER'' AFTER `outbound_order_status`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_cargo_order' AND COLUMN_NAME = 'latest_pre_outbound_id') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `latest_pre_outbound_id` bigint DEFAULT NULL COMMENT ''最新预出单ID'' AFTER `pre_outbound_no`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_cargo_order' AND COLUMN_NAME = 'latest_outbound_order_id') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `latest_outbound_order_id` bigint DEFAULT NULL COMMENT ''最新出库单ID'' AFTER `latest_pre_outbound_id`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
