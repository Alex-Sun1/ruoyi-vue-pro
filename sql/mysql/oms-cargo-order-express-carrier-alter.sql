-- cargo_order 快递承运商（delivery_method=EXPRESS 时使用）
-- 检查：SHOW COLUMNS FROM cargo_order LIKE 'express_carrier';

SET NAMES utf8mb4;

DROP PROCEDURE IF EXISTS `oms_cargo_order_express_carrier_migrate`;

DELIMITER //
CREATE PROCEDURE `oms_cargo_order_express_carrier_migrate`()
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE()
          AND TABLE_NAME = 'cargo_order'
          AND COLUMN_NAME = 'express_carrier'
    ) THEN
        ALTER TABLE `cargo_order`
            ADD COLUMN `express_carrier` varchar(32) DEFAULT NULL
                COMMENT '快递承运商（字典 oms_express_carrier）' AFTER `delivery_method`;
    END IF;
END //
DELIMITER ;

CALL `oms_cargo_order_express_carrier_migrate`();
DROP PROCEDURE IF EXISTS `oms_cargo_order_express_carrier_migrate`;
