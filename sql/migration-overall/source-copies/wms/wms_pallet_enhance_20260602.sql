-- 卡板库存字段增强 + 状态/类型字典 + 业务动作权限

-- ========== wms_pallet ==========
SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_pallet' AND COLUMN_NAME = 'pallet_type') = 0,
  'ALTER TABLE `wms_pallet` ADD COLUMN `pallet_type` varchar(32) NOT NULL DEFAULT ''NORMAL'' COMMENT ''卡板类型 NORMAL/RETURN'' AFTER `pallet_no`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_pallet' AND COLUMN_NAME = 'business_type_name') = 0,
  'ALTER TABLE `wms_pallet` ADD COLUMN `business_type_name` varchar(128) DEFAULT NULL COMMENT ''业务类型(展示)'' AFTER `pallet_type`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_pallet' AND COLUMN_NAME = 'group_destination') = 0,
  'ALTER TABLE `wms_pallet` ADD COLUMN `group_destination` varchar(256) DEFAULT NULL COMMENT ''分组/目的地(展示)'' AFTER `business_type_name`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 状态迁移：在库 / 已出单 / 出库
UPDATE `wms_pallet` SET `pallet_status` = 'IN_STOCK' WHERE `id` > 0 AND `pallet_status` IN ('CREATED', 'PUTAWAY', 'PARTIAL_LOCKED', 'LOCKED');
UPDATE `wms_pallet` SET `pallet_status` = 'OUTBOUND' WHERE `id` > 0 AND `pallet_status` = 'SHIPPED';

-- ========== wms_pallet_item ==========
SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_pallet_item' AND COLUMN_NAME = 'business_type_name') = 0,
  'ALTER TABLE `wms_pallet_item` ADD COLUMN `business_type_name` varchar(128) DEFAULT NULL COMMENT ''业务类型'' AFTER `cargo_order_no`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_pallet_item' AND COLUMN_NAME = 'group_destination') = 0,
  'ALTER TABLE `wms_pallet_item` ADD COLUMN `group_destination` varchar(128) DEFAULT NULL COMMENT ''分组/目的地'' AFTER `business_type_name`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_pallet_item' AND COLUMN_NAME = 'platform_name') = 0,
  'ALTER TABLE `wms_pallet_item` ADD COLUMN `platform_name` varchar(128) DEFAULT NULL COMMENT ''平台'' AFTER `group_destination`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_pallet_item' AND COLUMN_NAME = 'platform_warehouse_code') = 0,
  'ALTER TABLE `wms_pallet_item` ADD COLUMN `platform_warehouse_code` varchar(64) DEFAULT NULL COMMENT ''平台代码'' AFTER `platform_name`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_pallet_item' AND COLUMN_NAME = 'address_type') = 0,
  'ALTER TABLE `wms_pallet_item` ADD COLUMN `address_type` varchar(32) DEFAULT NULL COMMENT ''地址类型'' AFTER `platform_warehouse_code`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_pallet_item' AND COLUMN_NAME = 'po_no') = 0,
  'ALTER TABLE `wms_pallet_item` ADD COLUMN `po_no` varchar(64) DEFAULT NULL COMMENT ''PO号'' AFTER `shipment_code`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_pallet_item' AND COLUMN_NAME = 'shipping_mark') = 0,
  'ALTER TABLE `wms_pallet_item` ADD COLUMN `shipping_mark` varchar(128) DEFAULT NULL COMMENT ''唛头'' AFTER `po_no`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 从 OMS 回填展示字段（表存在时）
UPDATE wms_pallet_item pi
INNER JOIN oms_cargo_order co ON co.id = pi.cargo_order_id AND co.deleted = 0
SET
  pi.business_type_name = co.business_type_name,
  pi.container_no = co.container_no,
  pi.group_destination = co.group_code,
  pi.platform_name = co.platform_name,
  pi.platform_warehouse_code = co.platform_warehouse_code,
  pi.address_type = co.address_type
WHERE pi.id > 0;

UPDATE wms_pallet_item pi
INNER JOIN oms_cargo_order_shipment cs ON cs.id = pi.shipment_id AND cs.deleted = 0
SET
  pi.po_no = cs.po_no,
  pi.shipping_mark = cs.shipping_mark,
  pi.group_destination = COALESCE(pi.group_destination, cs.group_code)
WHERE pi.id > 0;

UPDATE wms_pallet p
INNER JOIN (
  SELECT pallet_id,
    GROUP_CONCAT(DISTINCT business_type_name ORDER BY business_type_name SEPARATOR '、') AS business_type_name,
    GROUP_CONCAT(DISTINCT container_no ORDER BY container_no SEPARATOR '、') AS container_no,
    GROUP_CONCAT(DISTINCT group_destination ORDER BY group_destination SEPARATOR '、') AS group_destination
  FROM wms_pallet_item WHERE deleted = 0
  GROUP BY pallet_id
) agg ON agg.pallet_id = p.id
SET p.business_type_name = agg.business_type_name, p.container_no = agg.container_no, p.group_destination = agg.group_destination
WHERE p.id > 0;

-- ========== 字典 ==========
INSERT IGNORE INTO sys_dict_type(dict_id, tenant_id, dict_name, dict_type, create_time, remark)
VALUES (910109, '000000', 'WMS卡板类型', 'wms_pallet_type', NOW(), '常规/退货');

INSERT IGNORE INTO sys_dict_data(dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, list_class, is_default, create_time, remark)
VALUES
(9101091,'000000',1,'常规','NORMAL','wms_pallet_type','info','Y',NOW(),''),
(9101092,'000000',2,'退货','RETURN','wms_pallet_type','warning','N',NOW(),'');

DELETE FROM sys_dict_data WHERE dict_code > 0 AND dict_type = 'wms_pallet_status' AND dict_value IN ('CREATED', 'PUTAWAY', 'PARTIAL_LOCKED', 'LOCKED', 'SHIPPED');
INSERT IGNORE INTO sys_dict_data(dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, list_class, is_default, create_time, remark)
VALUES
(9101056,'000000',1,'在库','IN_STOCK','wms_pallet_status','success','Y',NOW(),''),
(9101057,'000000',2,'已出单','PRE_OUTBOUND','wms_pallet_status','info','N',NOW(),''),
(9101058,'000000',3,'出库','OUTBOUND','wms_pallet_status','default','N',NOW(),''),
(9101059,'000000',4,'HOLD','HOLD','wms_pallet_status','warning','N',NOW(),'订单拦截');

-- ========== 菜单权限 ==========
INSERT IGNORE INTO sys_menu VALUES(6047, '卡板移库位', 6003, 1, '#', '', '', 1, 0, 'F', '0', '0', 'wms:pallet:moveLocation', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6048, '卡板出库', 6003, 2, '#', '', '', 1, 0, 'F', '0', '0', 'wms:pallet:outbound', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_role_menu(role_id, menu_id)
SELECT 1, menu_id FROM sys_menu WHERE menu_id IN (6047, 6048);
