-- 补全 cargo_order_item SKU 关联货件字段（逐条执行；Duplicate column 则跳过）
SET NAMES utf8mb4;

ALTER TABLE `cargo_order_item`
    ADD COLUMN `shipment_id` bigint DEFAULT NULL COMMENT '货件ID' AFTER `cargo_order_id`;

ALTER TABLE `cargo_order_item`
    ADD COLUMN `sku_name` varchar(255) DEFAULT NULL COMMENT 'SKU名称' AFTER `sku_code`;

ALTER TABLE `cargo_order_item`
    ADD COLUMN `planned_qty` int DEFAULT NULL COMMENT '计划数量' AFTER `qty`;
