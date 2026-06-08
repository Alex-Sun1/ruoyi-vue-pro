-- 海柜建单（含柜内订单）增量 DDL
SET NAMES utf8mb4;

-- 销售渠道（建单 channelId 下拉）
CREATE TABLE IF NOT EXISTS `base_sales_channel` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `channel_code` varchar(64) NOT NULL COMMENT '渠道编码',
  `channel_name` varchar(128) NOT NULL COMMENT '渠道名称',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0启用 1停用',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_channel_code` (`tenant_id`, `channel_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='销售渠道';

ALTER TABLE `oms_container_order`
    ADD COLUMN `create_source` varchar(30) DEFAULT 'MANUAL' COMMENT '建单来源' AFTER `channel_id`,
    ADD COLUMN `remark` varchar(500) DEFAULT NULL COMMENT '备注' AFTER `internal_remark`;

-- goods_name 已由 oms-tables-v11-alter.sql 加在 cargo_order 上，此处不再重复
ALTER TABLE `cargo_order`
    ADD COLUMN `delivery_method` varchar(30) DEFAULT NULL COMMENT '派送方式' AFTER `biz_type`,
    ADD COLUMN `consignee_name` varchar(128) DEFAULT NULL COMMENT '联系人' AFTER `delivery_method`,
    ADD COLUMN `consignee_phone` varchar(64) DEFAULT NULL COMMENT '电话' AFTER `consignee_name`,
    ADD COLUMN `consignee_email` varchar(100) DEFAULT NULL COMMENT '邮箱' AFTER `consignee_phone`,
    ADD COLUMN `delivery_address` varchar(512) DEFAULT NULL COMMENT '地址' AFTER `consignee_email`,
    ADD COLUMN `delivery_city` varchar(64) DEFAULT NULL COMMENT '城市' AFTER `delivery_address`,
    ADD COLUMN `delivery_state` varchar(32) DEFAULT NULL COMMENT '州省' AFTER `delivery_city`,
    ADD COLUMN `delivery_zip` varchar(20) DEFAULT NULL COMMENT '邮编' AFTER `delivery_state`,
    ADD COLUMN `appointment_no` varchar(64) DEFAULT NULL COMMENT '预约号' AFTER `delivery_zip`,
    ADD COLUMN `on_hold` bit(1) NOT NULL DEFAULT b'0' COMMENT '订单级HOLD' AFTER `appointment_no`;

ALTER TABLE `shipment`
    ADD COLUMN `shipment_code` varchar(64) DEFAULT NULL COMMENT '货件编码' AFTER `shipment_no`,
    ADD COLUMN `po_no` varchar(64) DEFAULT NULL COMMENT 'PO号' AFTER `shipment_code`,
    ADD COLUMN `dw_date` date DEFAULT NULL COMMENT 'DW日期' AFTER `po_no`,
    ADD COLUMN `dw_start` varchar(16) DEFAULT NULL COMMENT 'DW开始' AFTER `dw_date`,
    ADD COLUMN `dw_end` varchar(16) DEFAULT NULL COMMENT 'DW结束' AFTER `dw_start`,
    ADD COLUMN `planned_ctns` int DEFAULT NULL COMMENT '计划箱数' AFTER `dw_end`,
    ADD COLUMN `gross_weight_lbs` decimal(18,3) DEFAULT NULL COMMENT '重量磅' AFTER `planned_ctns`,
    ADD COLUMN `cbm` decimal(18,3) DEFAULT NULL COMMENT '体积' AFTER `gross_weight_lbs`,
    ADD COLUMN `goods_name` varchar(255) DEFAULT NULL COMMENT '商品名称' AFTER `cbm`;

ALTER TABLE `cargo_order_item`
    ADD COLUMN `shipment_id` bigint DEFAULT NULL COMMENT '货件ID' AFTER `cargo_order_id`,
    ADD COLUMN `sku_name` varchar(255) DEFAULT NULL COMMENT 'SKU名称' AFTER `sku_code`,
    ADD COLUMN `planned_qty` int DEFAULT NULL COMMENT '计划数量' AFTER `qty`;

INSERT INTO `base_sales_channel` (`id`, `channel_code`, `channel_name`, `status`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`)
VALUES (12, 'AMAZON', 'Amazon 官方', 0, 'admin', NOW(), 'admin', NOW(), b'0', 1)
ON DUPLICATE KEY UPDATE channel_name = VALUES(channel_name), status = VALUES(status), update_time = NOW();
