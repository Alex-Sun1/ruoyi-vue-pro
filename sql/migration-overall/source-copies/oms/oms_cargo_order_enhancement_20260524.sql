-- =====================================================
-- 海柜/货物订单增强 DDL + 权限  2026-05-24
-- 内容：按板按箱计量、转仓动作权限、导入权限
-- =====================================================

SET @schema_name = DATABASE();

-- 货物订单：预报计量单位 + 预报板数
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'forecast_qty_unit') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `forecast_qty_unit` varchar(32) NOT NULL DEFAULT ''BY_CARTON'' COMMENT ''预报计量单位 BY_CARTON/BY_PALLET'' AFTER `transfer_warehouse_code`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'declared_pallet_qty') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `declared_pallet_qty` decimal(10,2) DEFAULT NULL COMMENT ''预报板数'' AFTER `declared_carton_qty`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 货件层：预报板数
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order_shipment' AND column_name = 'pallet_qty') = 0,
  'ALTER TABLE `oms_cargo_order_shipment` ADD COLUMN `pallet_qty` decimal(12,0) DEFAULT NULL COMMENT ''预报板数'' AFTER `carton_qty`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 字典：预报计量单位
INSERT IGNORE INTO sys_dict_type VALUES(5000300, '000000', '货物预报计量单位', 'oms_cargo_forecast_qty_unit', 103, 1, NOW(), NULL, NULL, 'BY_CARTON/BY_PALLET');
INSERT IGNORE INTO sys_dict_data VALUES(5000301, '000000', 1, '按箱', 'BY_CARTON', 'oms_cargo_forecast_qty_unit', '', 'default', 'N', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_dict_data VALUES(5000302, '000000', 2, '按板', 'BY_PALLET', 'oms_cargo_forecast_qty_unit', '', 'default', 'N', 103, 1, NOW(), NULL, NULL, '');

-- 菜单权限
INSERT IGNORE INTO sys_menu VALUES(3052, '取消转仓', 3002, 47, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:cancelTransfer', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3053, '修改转仓', 3002, 48, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:modifyTransfer', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3054, '导入货物订单', 3002, 49, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:import', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3055, '海柜导入货物订单', 3001, 11, '#', '', '', 1, 0, 'F', '0', '0', 'oms:containerOrder:importCargo', '#', 103, 1, NOW(), NULL, NULL, '');
