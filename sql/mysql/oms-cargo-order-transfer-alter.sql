-- 【已废弃】请改用 oms-cargo-order-transfer-platform-alter.sql（平台地址库）
-- cargo_order 转仓字段（PRD 03 海柜全量，组织仓库版）
-- 检查：SHOW COLUMNS FROM cargo_order LIKE 'transfer_%';

SET NAMES utf8mb4;

ALTER TABLE `cargo_order`
    ADD COLUMN `transfer_warehouse_code` varchar(32) DEFAULT NULL COMMENT '转仓目标仓代码' AFTER `is_transfer`,
    ADD COLUMN `transfer_warehouse_name` varchar(128) DEFAULT NULL COMMENT '转仓目标仓名称（冗余展示）' AFTER `transfer_warehouse_code`,
    ADD COLUMN `transfer_warehouse_address` varchar(512) DEFAULT NULL COMMENT '转仓目标仓地址（冗余展示）' AFTER `transfer_warehouse_name`,
    ADD KEY `idx_transfer_warehouse_code` (`transfer_warehouse_code`);
