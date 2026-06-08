-- 卡板 HOLD：明细 hold_flag 来自 OMS 订单；任一订单 HOLD 则卡板状态 HOLD

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_pallet_item' AND COLUMN_NAME = 'hold_flag') = 0,
  'ALTER TABLE `wms_pallet_item` ADD COLUMN `hold_flag` tinyint NOT NULL DEFAULT 0 COMMENT ''订单HOLD(1=是)'' AFTER `address_type`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

UPDATE wms_pallet_item pi
INNER JOIN oms_cargo_order co ON co.id = pi.cargo_order_id AND co.deleted = 0
SET pi.hold_flag = IF(co.hold_flag = 1, 1, 0)
WHERE pi.id > 0;

UPDATE wms_pallet p
INNER JOIN (
  SELECT pallet_id, MAX(hold_flag) AS max_hold
  FROM wms_pallet_item WHERE deleted = 0
  GROUP BY pallet_id
) agg ON agg.pallet_id = p.id
SET p.pallet_status = 'HOLD'
WHERE p.id > 0
  AND p.pallet_status NOT IN ('OUTBOUND')
  AND agg.max_hold = 1;

INSERT IGNORE INTO sys_dict_data(dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, list_class, is_default, create_time, remark)
VALUES (9101059, '000000', 4, 'HOLD', 'HOLD', 'wms_pallet_status', 'warning', 'N', NOW(), '订单拦截');
