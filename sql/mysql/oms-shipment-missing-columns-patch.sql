-- 补全 shipment 建单/柜内货件字段（逐条执行；Duplicate column 则跳过）
-- 请在 application-*.yaml 指向的同一库执行
SET NAMES utf8mb4;

ALTER TABLE `shipment`
    ADD COLUMN `shipment_code` varchar(64) DEFAULT NULL COMMENT '货件编码' AFTER `shipment_no`;

ALTER TABLE `shipment`
    ADD COLUMN `po_no` varchar(64) DEFAULT NULL COMMENT 'PO号' AFTER `shipment_code`;

ALTER TABLE `shipment`
    ADD COLUMN `dw_date` date DEFAULT NULL COMMENT 'DW日期' AFTER `po_no`;

ALTER TABLE `shipment`
    ADD COLUMN `dw_start` varchar(16) DEFAULT NULL COMMENT 'DW开始' AFTER `dw_date`;

ALTER TABLE `shipment`
    ADD COLUMN `dw_end` varchar(16) DEFAULT NULL COMMENT 'DW结束' AFTER `dw_start`;

ALTER TABLE `shipment`
    ADD COLUMN `planned_ctns` int DEFAULT NULL COMMENT '计划箱数' AFTER `dw_end`;

ALTER TABLE `shipment`
    ADD COLUMN `gross_weight_lbs` decimal(18,3) DEFAULT NULL COMMENT '重量磅' AFTER `planned_ctns`;

ALTER TABLE `shipment`
    ADD COLUMN `cbm` decimal(18,3) DEFAULT NULL COMMENT '体积' AFTER `gross_weight_lbs`;

ALTER TABLE `shipment`
    ADD COLUMN `goods_name` varchar(255) DEFAULT NULL COMMENT '商品名称' AFTER `cbm`;
