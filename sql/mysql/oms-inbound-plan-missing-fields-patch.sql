-- OMS inbound-plan fields migrated from overallSystem.
-- Safe to execute repeatedly in MySQL.

SET @schema_name := DATABASE();

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'shipment' AND COLUMN_NAME = 'shipping_mark') = 0,
  'ALTER TABLE `shipment` ADD COLUMN `shipping_mark` varchar(128) DEFAULT NULL COMMENT ''唛头'' AFTER `po_no`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'shipment' AND COLUMN_NAME = 'pallet_qty') = 0,
  'ALTER TABLE `shipment` ADD COLUMN `pallet_qty` decimal(12,2) DEFAULT NULL COMMENT ''预报板数'' AFTER `planned_ctns`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_container_order' AND COLUMN_NAME = 'total_weight') = 0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `total_weight` decimal(12,3) DEFAULT NULL COMMENT ''总重量kg''',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_container_order' AND COLUMN_NAME = 'total_carton_qty') = 0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `total_carton_qty` decimal(12,2) DEFAULT NULL COMMENT ''总箱数''',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_container_order' AND COLUMN_NAME = 'total_cbm') = 0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `total_cbm` decimal(12,3) DEFAULT NULL COMMENT ''总体积CBM''',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'wms_inbound_plan' AND INDEX_NAME = 'uk_container_order') = 0,
  'ALTER TABLE `wms_inbound_plan` ADD UNIQUE KEY `uk_container_order` (`container_order_id`, `tenant_id`, `deleted`)',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'wms_inbound_plan' AND INDEX_NAME = 'idx_tenant_warehouse') = 0,
  'ALTER TABLE `wms_inbound_plan` ADD KEY `idx_tenant_warehouse` (`tenant_id`, `warehouse_id`)',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'wms_inbound_plan_item' AND INDEX_NAME = 'uk_plan_shipment') = 0,
  'ALTER TABLE `wms_inbound_plan_item` ADD UNIQUE KEY `uk_plan_shipment` (`plan_id`, `shipment_id`, `deleted`)',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'wms_inbound_plan_item' AND INDEX_NAME = 'idx_group_code') = 0,
  'ALTER TABLE `wms_inbound_plan_item` ADD KEY `idx_group_code` (`group_code`)',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'wms_inbound_plan_change_log' AND INDEX_NAME = 'idx_plan_item_id') = 0,
  'ALTER TABLE `wms_inbound_plan_change_log` ADD KEY `idx_plan_item_id` (`plan_item_id`)',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'wms_inbound_plan_change_log' AND INDEX_NAME = 'idx_shipment_id') = 0,
  'ALTER TABLE `wms_inbound_plan_change_log` ADD KEY `idx_shipment_id` (`shipment_id`)',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`,
                           `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`,
                           `create_time`, `updater`, `update_time`, `deleted`)
VALUES
    (6965, '编辑入库计划', 'wms:inboundPlan:edit', 3, 5, 6950, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6966, '取消入库计划', 'wms:inboundPlan:cancel', 3, 6, 6950, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `permission` = VALUES(`permission`),
    `parent_id` = VALUES(`parent_id`),
    `updater` = 'admin',
    `update_time` = NOW(),
    `deleted` = b'0';
