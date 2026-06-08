-- 卡板/明细增加柜号展示字段（从 OMS 订单同步）

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_pallet' AND COLUMN_NAME = 'container_no') = 0,
  'ALTER TABLE `wms_pallet` ADD COLUMN `container_no` varchar(64) DEFAULT NULL COMMENT ''柜号(展示)'' AFTER `business_type_name`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_pallet_item' AND COLUMN_NAME = 'container_no') = 0,
  'ALTER TABLE `wms_pallet_item` ADD COLUMN `container_no` varchar(64) DEFAULT NULL COMMENT ''柜号'' AFTER `business_type_name`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

UPDATE wms_pallet_item pi
INNER JOIN oms_cargo_order co ON co.id = pi.cargo_order_id AND co.deleted = 0
SET pi.container_no = co.container_no
WHERE pi.id > 0 AND co.container_no IS NOT NULL AND co.container_no != '';

UPDATE wms_pallet p
INNER JOIN (
  SELECT pallet_id,
    GROUP_CONCAT(DISTINCT container_no ORDER BY container_no SEPARATOR '、') AS container_no
  FROM wms_pallet_item WHERE deleted = 0 AND container_no IS NOT NULL AND container_no != ''
  GROUP BY pallet_id
) agg ON agg.pallet_id = p.id
SET p.container_no = agg.container_no
WHERE p.id > 0;
