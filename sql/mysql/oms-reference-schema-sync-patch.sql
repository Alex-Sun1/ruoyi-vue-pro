-- Sync current OMS database schema with overallSystem/docs/prd/all.sql.
-- Safe to execute repeatedly in MySQL.

SET @schema_name := DATABASE();

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_cargo_order' AND COLUMN_NAME = 'group_code') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `group_code` varchar(100) DEFAULT NULL COMMENT ''入库分组（从货件汇总，多分组时存MULTI）''',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_cargo_order_shipment' AND COLUMN_NAME = 'group_code') = 0,
  'ALTER TABLE `oms_cargo_order_shipment` ADD COLUMN `group_code` varchar(100) DEFAULT NULL COMMENT ''入库分组（由入库计划写入）''',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_cargo_grouping_rule' AND COLUMN_NAME = 'warehouse_ids') = 0,
  'ALTER TABLE `oms_cargo_grouping_rule` ADD COLUMN `warehouse_ids` text COMMENT ''仓库ID列表，JSON字符串数组，如["1","2","3"]'' AFTER `warehouse_name`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_cargo_grouping_rule' AND COLUMN_NAME = 'warehouse_id') > 0,
  'UPDATE `oms_cargo_grouping_rule` SET `warehouse_ids` = JSON_ARRAY(CAST(`warehouse_id` AS CHAR)) WHERE (`warehouse_ids` IS NULL OR `warehouse_ids` = '''') AND `warehouse_id` IS NOT NULL',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'wms_inbound_plan' AND COLUMN_NAME = 'create_dept') = 0,
  'ALTER TABLE `wms_inbound_plan` ADD COLUMN `create_dept` bigint DEFAULT NULL COMMENT ''创建部门''',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'wms_inbound_plan' AND COLUMN_NAME = 'create_by') = 0,
  'ALTER TABLE `wms_inbound_plan` ADD COLUMN `create_by` bigint DEFAULT NULL COMMENT ''创建人''',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'wms_inbound_plan' AND COLUMN_NAME = 'update_by') = 0,
  'ALTER TABLE `wms_inbound_plan` ADD COLUMN `update_by` bigint DEFAULT NULL COMMENT ''更新人''',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'wms_inbound_plan_item' AND COLUMN_NAME = 'create_dept') = 0,
  'ALTER TABLE `wms_inbound_plan_item` ADD COLUMN `create_dept` bigint DEFAULT NULL COMMENT ''创建部门''',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'wms_inbound_plan_item' AND COLUMN_NAME = 'create_by') = 0,
  'ALTER TABLE `wms_inbound_plan_item` ADD COLUMN `create_by` bigint DEFAULT NULL COMMENT ''创建人''',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'wms_inbound_plan_item' AND COLUMN_NAME = 'update_by') = 0,
  'ALTER TABLE `wms_inbound_plan_item` ADD COLUMN `update_by` bigint DEFAULT NULL COMMENT ''更新人''',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

UPDATE `oms_cargo_order_shipment` s
JOIN `wms_inbound_plan_item` i ON i.shipment_id = s.id AND i.deleted = 0
SET s.group_code = i.group_code
WHERE (s.group_code IS NULL OR s.group_code = '') AND i.group_code IS NOT NULL;

UPDATE `oms_cargo_order` o
LEFT JOIN (
  SELECT cargo_order_id,
         CASE
           WHEN COUNT(DISTINCT NULLIF(group_code, '')) = 0 THEN NULL
           WHEN COUNT(DISTINCT NULLIF(group_code, '')) = 1 THEN MAX(NULLIF(group_code, ''))
           ELSE 'MULTI'
         END AS group_code
  FROM `oms_cargo_order_shipment`
  WHERE deleted = 0
  GROUP BY cargo_order_id
) g ON g.cargo_order_id = o.id
SET o.group_code = g.group_code
WHERE (o.group_code IS NULL OR o.group_code = '') AND g.group_code IS NOT NULL;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_cargo_order' AND INDEX_NAME = 'idx_group_code') = 0,
  'ALTER TABLE `oms_cargo_order` ADD KEY `idx_group_code` (`group_code`)',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_cargo_order_shipment' AND INDEX_NAME = 'idx_group_code') = 0,
  'ALTER TABLE `oms_cargo_order_shipment` ADD KEY `idx_group_code` (`group_code`)',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'wms_inbound_plan' AND INDEX_NAME = 'uk_plan_no_tenant') = 0,
  'ALTER TABLE `wms_inbound_plan` ADD UNIQUE KEY `uk_plan_no_tenant` (`tenant_id`, `plan_no`)',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
