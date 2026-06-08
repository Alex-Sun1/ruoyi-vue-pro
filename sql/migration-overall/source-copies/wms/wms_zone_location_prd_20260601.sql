-- 库区与库位 PRD v1.0 结构迁移（在 wms_inventory_base_20260601.sql 之后执行）
-- 可重复执行：列/索引已存在则自动跳过
-- UPDATE/DELETE 带主键条件，兼容 MySQL Workbench 安全更新模式

-- ========== wms_zone：新增列 ==========
SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_zone' AND COLUMN_NAME = 'storage_method') = 0,
  'ALTER TABLE `wms_zone` ADD COLUMN `storage_method` varchar(32) DEFAULT NULL COMMENT ''存放方式 FLOOR/RACK'' AFTER `zone_name`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_zone' AND COLUMN_NAME = 'allow_mixed_storage') = 0,
  'ALTER TABLE `wms_zone` ADD COLUMN `allow_mixed_storage` tinyint(1) NOT NULL DEFAULT 0 COMMENT ''库位混合存储'' AFTER `zone_type`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_zone' AND COLUMN_NAME = 'max_mixed_qty') = 0,
  'ALTER TABLE `wms_zone` ADD COLUMN `max_mixed_qty` int DEFAULT NULL COMMENT ''最大混合数量'' AFTER `allow_mixed_storage`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

UPDATE `wms_zone` SET `storage_method` = 'FLOOR' WHERE `id` > 0 AND `storage_method` IS NULL;
UPDATE `wms_zone` SET `zone_type` = 'EXPRESS' WHERE `id` > 0 AND `zone_type` = 'CROSS_DOCK';
UPDATE `wms_zone` SET `zone_type` = 'TEMP' WHERE `id` > 0 AND `zone_type` IN ('STORAGE', 'STAGING');

-- 删除旧列/索引（存在才删）
SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_zone' AND INDEX_NAME = 'uk_wms_zone_code') > 0,
  'ALTER TABLE `wms_zone` DROP INDEX `uk_wms_zone_code`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_zone' AND COLUMN_NAME = 'zone_code') > 0,
  'ALTER TABLE `wms_zone` DROP COLUMN `zone_code`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_zone' AND COLUMN_NAME = 'allow_putaway') > 0,
  'ALTER TABLE `wms_zone` DROP COLUMN `allow_putaway`, DROP COLUMN `allow_pick`, DROP COLUMN `allow_count`, DROP COLUMN `allow_direct_outbound`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_zone' AND COLUMN_NAME = 'storage_method' AND IS_NULLABLE = 'YES') > 0,
  'ALTER TABLE `wms_zone` MODIFY COLUMN `storage_method` varchar(32) NOT NULL COMMENT ''存放方式 FLOOR/RACK''',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_zone' AND INDEX_NAME = 'uk_wms_zone_name') = 0,
  'ALTER TABLE `wms_zone` ADD UNIQUE KEY `uk_wms_zone_name` (`tenant_id`, `warehouse_id`, `zone_name`, `deleted`)',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ========== wms_location：新增列 ==========
SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_location' AND COLUMN_NAME = 'row_no') = 0,
  'ALTER TABLE `wms_location` ADD COLUMN `row_no` varchar(32) DEFAULT NULL COMMENT ''行'' AFTER `location_code`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_location' AND COLUMN_NAME = 'column_no') = 0,
  'ALTER TABLE `wms_location` ADD COLUMN `column_no` varchar(32) DEFAULT NULL COMMENT ''列'' AFTER `row_no`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_location' AND COLUMN_NAME = 'capacity') = 0,
  'ALTER TABLE `wms_location` ADD COLUMN `capacity` int DEFAULT NULL COMMENT ''库位容量'' AFTER `column_no`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_location' AND COLUMN_NAME = 'current_qty') = 0,
  'ALTER TABLE `wms_location` ADD COLUMN `current_qty` int NOT NULL DEFAULT 0 COMMENT ''现有库存(展示)'' AFTER `capacity`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_location' AND COLUMN_NAME = 'remaining_capacity') = 0,
  'ALTER TABLE `wms_location` ADD COLUMN `remaining_capacity` int DEFAULT NULL COMMENT ''剩余容量(展示)'' AFTER `current_qty`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

UPDATE `wms_location` SET `status` = 'NORMAL' WHERE `id` > 0 AND `status` IN ('FREE', 'OCCUPIED', 'FULL');

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_location' AND COLUMN_NAME = 'occupied_pallet_qty') > 0,
  'UPDATE `wms_location` SET `current_qty` = IFNULL(`occupied_pallet_qty`, 0) WHERE `id` > 0',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_location' AND COLUMN_NAME = 'zone_code') > 0,
  'ALTER TABLE `wms_location` DROP COLUMN `zone_code`, DROP COLUMN `location_type`, DROP COLUMN `capacity_pallet_qty`, DROP COLUMN `capacity_weight`, DROP COLUMN `capacity_cbm`, DROP COLUMN `occupied_pallet_qty`, DROP COLUMN `occupied_weight`, DROP COLUMN `occupied_cbm`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ========== 字典 ==========
DELETE FROM sys_dict_data WHERE dict_code > 0 AND dict_type = 'wms_zone_type' AND dict_value IN ('CROSS_DOCK', 'STORAGE', 'VAS', 'STAGING');
INSERT IGNORE INTO sys_dict_data(dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, list_class, is_default, create_time, remark)
VALUES
(9101006,'000000',1,'快递区','EXPRESS','wms_zone_type','info','N',NOW(),''),
(9101007,'000000',2,'暂存区','TEMP','wms_zone_type','success','Y',NOW(),''),
(9101008,'000000',3,'私仓库区','PRIVATE','wms_zone_type','warning','N',NOW(),''),
(9101009,'000000',4,'异常区','EXCEPTION','wms_zone_type','error','N',NOW(),'');

INSERT IGNORE INTO sys_dict_type(dict_id, tenant_id, dict_name, dict_type, create_time, remark)
VALUES (910108, '000000', 'WMS存放方式', 'wms_storage_method', NOW(), '库区存放方式');

INSERT IGNORE INTO sys_dict_data(dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, list_class, is_default, create_time, remark)
VALUES
(9101081,'000000',1,'地堆','FLOOR','wms_storage_method','info','Y',NOW(),''),
(9101082,'000000',2,'货架','RACK','wms_storage_method','success','N',NOW(),'');

DELETE FROM sys_dict_data WHERE dict_code > 0 AND dict_type = 'wms_location_type';
DELETE FROM sys_dict_type WHERE dict_id > 0 AND dict_type = 'wms_location_type';

DELETE FROM sys_dict_data WHERE dict_code > 0 AND dict_type = 'wms_location_status' AND dict_value IN ('FREE', 'OCCUPIED', 'FULL');
INSERT IGNORE INTO sys_dict_data(dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, list_class, is_default, create_time, remark)
VALUES
(9101035,'000000',1,'正常','NORMAL','wms_location_status','success','Y',NOW(),''),
(9101036,'000000',2,'停用','DISABLED','wms_location_status','default','N',NOW(),''),
(9101037,'000000',3,'锁定','LOCKED','wms_location_status','warning','N',NOW(),'');

INSERT IGNORE INTO sys_menu VALUES(6045, '库位导入', 6012, 5, '#', '', '', 1, 0, 'F', '0', '0', 'wms:location:import', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6046, '库位改状态', 6012, 6, '#', '', '', 1, 0, 'F', '0', '0', 'wms:location:changeStatus', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6035, '库区停用', 6011, 5, '#', '', '', 1, 0, 'F', '0', '0', 'wms:zone:changeStatus', '#', 103, 1, NOW(), NULL, NULL, '');

INSERT IGNORE INTO sys_role_menu(role_id, menu_id)
SELECT 1, menu_id FROM sys_menu WHERE menu_id IN (6035, 6045, 6046);

-- 演示数据对齐 PRD（可按需注释）
UPDATE `wms_zone` SET
  `zone_name` = 'FedEx区',
  `storage_method` = 'FLOOR',
  `zone_type` = 'EXPRESS',
  `allow_mixed_storage` = 0,
  `max_mixed_qty` = NULL
WHERE `id` = 6100001;

UPDATE `wms_zone` SET
  `zone_name` = 'A区',
  `storage_method` = 'RACK',
  `zone_type` = 'TEMP',
  `allow_mixed_storage` = 1,
  `max_mixed_qty` = 3
WHERE `id` = 6100002;

UPDATE `wms_zone` SET
  `zone_name` = '异常区',
  `storage_method` = 'FLOOR',
  `zone_type` = 'EXCEPTION',
  `allow_mixed_storage` = 0
WHERE `id` = 6100003;

UPDATE `wms_location` SET
  `location_code` = 'CD-A-01',
  `row_no` = '1',
  `column_no` = 'E08',
  `capacity` = 20,
  `status` = 'NORMAL'
WHERE `id` = 6101001;

UPDATE `wms_location` SET
  `location_code` = 'A-01-01',
  `row_no` = '10',
  `column_no` = 'F04',
  `capacity` = 1,
  `status` = 'NORMAL'
WHERE `id` = 6101002;

UPDATE `wms_location` SET
  `location_code` = 'A-01-02',
  `capacity` = 1,
  `status` = 'NORMAL'
WHERE `id` = 6101003;
