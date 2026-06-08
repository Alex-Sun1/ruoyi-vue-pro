-- =============================================================
-- Backfill cargo order shipment summary fields
-- Date: 2026-05-27
-- Fields:
--   oms_cargo_order.shipment_codes
--   oms_cargo_order.po_nos
--   oms_cargo_order.marks
-- 兼容 MySQL Workbench Safe Update Mode
-- =============================================================

SET @schema_name = DATABASE();

SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order_shipment' AND column_name = 'pallet_qty') = 0,
  'ALTER TABLE `oms_cargo_order_shipment` ADD COLUMN `pallet_qty` decimal(12,0) DEFAULT NULL COMMENT ''预报板数'' AFTER `carton_qty`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'declared_pallet_qty') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `declared_pallet_qty` decimal(10,2) DEFAULT NULL COMMENT ''预报板数'' AFTER `declared_carton_qty`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET SQL_SAFE_UPDATES = 0;

UPDATE `oms_cargo_order` co
INNER JOIN (
    SELECT `cargo_order_id`,
           GROUP_CONCAT(DISTINCT NULLIF(`shipment_no`, '') ORDER BY `shipment_no` SEPARATOR ', ') AS `shipment_codes`,
           GROUP_CONCAT(DISTINCT NULLIF(`po_no`, '') ORDER BY `po_no` SEPARATOR ', ') AS `po_nos`,
           GROUP_CONCAT(DISTINCT NULLIF(`shipping_mark`, '') ORDER BY `shipping_mark` SEPARATOR ', ') AS `marks`,
           SUM(COALESCE(`carton_qty`, 0)) AS `declared_carton_qty`,
           SUM(COALESCE(`pallet_qty`, 0)) AS `declared_pallet_qty`,
           SUM(COALESCE(`weight`, 0)) AS `declared_weight`,
           SUM(COALESCE(`cbm`, 0)) AS `declared_cbm`,
           MIN(`dw_time`) AS `earliest_dw_time`
    FROM `oms_cargo_order_shipment`
    WHERE `deleted` = 0
    GROUP BY `cargo_order_id`
) s ON s.`cargo_order_id` = co.`id`
SET co.`shipment_codes` = s.`shipment_codes`,
    co.`po_nos` = s.`po_nos`,
    co.`marks` = s.`marks`,
    co.`declared_carton_qty` = s.`declared_carton_qty`,
    co.`declared_pallet_qty` = s.`declared_pallet_qty`,
    co.`declared_weight` = s.`declared_weight`,
    co.`declared_cbm` = s.`declared_cbm`,
    co.`earliest_dw_time` = s.`earliest_dw_time`
WHERE co.`deleted` = 0
  AND co.`id` > 0;

SET SQL_SAFE_UPDATES = 1;
