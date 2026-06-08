-- cargo_order 转仓：平台地址（替换旧版 transfer_warehouse_*）
-- 兼容 MySQL 5.7 / 8.0（不使用 DROP COLUMN IF EXISTS，需 8.0.29+）
-- 前置：base_platform_address、oms-tables-v11-alter（is_transfer）
-- 检查：SHOW COLUMNS FROM cargo_order LIKE 'transfer_platform%';

SET NAMES utf8mb4;

DROP PROCEDURE IF EXISTS `oms_cargo_order_transfer_platform_migrate`;

DELIMITER //
CREATE PROCEDURE `oms_cargo_order_transfer_platform_migrate`()
BEGIN
    -- 删除旧版组织仓库字段（仅当列存在时）
    IF EXISTS (
        SELECT 1 FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE()
          AND TABLE_NAME = 'cargo_order'
          AND COLUMN_NAME = 'transfer_warehouse_address'
    ) THEN
        ALTER TABLE `cargo_order` DROP COLUMN `transfer_warehouse_address`;
    END IF;

    IF EXISTS (
        SELECT 1 FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE()
          AND TABLE_NAME = 'cargo_order'
          AND COLUMN_NAME = 'transfer_warehouse_name'
    ) THEN
        ALTER TABLE `cargo_order` DROP COLUMN `transfer_warehouse_name`;
    END IF;

    IF EXISTS (
        SELECT 1 FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE()
          AND TABLE_NAME = 'cargo_order'
          AND COLUMN_NAME = 'transfer_warehouse_code'
    ) THEN
        ALTER TABLE `cargo_order` DROP COLUMN `transfer_warehouse_code`;
    END IF;

    -- 新增平台地址字段（幂等）
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE()
          AND TABLE_NAME = 'cargo_order'
          AND COLUMN_NAME = 'transfer_platform_address_id'
    ) THEN
        ALTER TABLE `cargo_order`
            ADD COLUMN `transfer_platform_address_id` bigint DEFAULT NULL
                COMMENT '转仓平台地址 base_platform_address.id' AFTER `is_transfer`;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE()
          AND TABLE_NAME = 'cargo_order'
          AND COLUMN_NAME = 'transfer_platform_address_code'
    ) THEN
        ALTER TABLE `cargo_order`
            ADD COLUMN `transfer_platform_address_code` varchar(64) DEFAULT NULL
                COMMENT '转仓平台地址编码冗余' AFTER `transfer_platform_address_id`;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE()
          AND TABLE_NAME = 'cargo_order'
          AND COLUMN_NAME = 'transfer_platform_address_name'
    ) THEN
        ALTER TABLE `cargo_order`
            ADD COLUMN `transfer_platform_address_name` varchar(128) DEFAULT NULL
                COMMENT '转仓平台地址名称冗余（列表展示）' AFTER `transfer_platform_address_code`;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.STATISTICS
        WHERE TABLE_SCHEMA = DATABASE()
          AND TABLE_NAME = 'cargo_order'
          AND INDEX_NAME = 'idx_transfer_platform_address_id'
    ) THEN
        ALTER TABLE `cargo_order`
            ADD KEY `idx_transfer_platform_address_id` (`transfer_platform_address_id`);
    END IF;
END //
DELIMITER ;

CALL `oms_cargo_order_transfer_platform_migrate`();
DROP PROCEDURE IF EXISTS `oms_cargo_order_transfer_platform_migrate`;
