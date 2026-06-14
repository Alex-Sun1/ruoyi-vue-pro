-- Core baseline guard for the active BASE/OMS/WMS/YMS schema.
-- This script is intentionally idempotent. It targets the active tables used by
-- the current Java code and avoids the legacy cargo_order/cargo_order_item set.

SET NAMES utf8mb4;

-- Keep new project tables on one portable collation. Avoid utf8mb4_0900_ai_ci so
-- the baseline can still run on MySQL 5.7 compatible environments.
ALTER TABLE `oms_container_order` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `oms_cargo_order` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `oms_cargo_order_shipment` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `oms_cargo_order_sku_item` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `oms_pre_outbound` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `oms_pre_outbound_item` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `oms_outbound_order` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `oms_outbound_order_item` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `oms_biz_root_relation` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `wms_inbound_plan` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `wms_inbound_plan_item` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `wms_devanning_order` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `wms_inventory` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `wms_pallet` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `wms_pallet_item` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `yms_container_resource` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `yms_trailer_resource` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `yms_yard_task` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `yms_check_in` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `yard_dock` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `yard_zone` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Active relation table: one active binding per source business object. Use a
-- generated key so historical/cancelled rows do not collide with the active row.
SET @col_exists := (
  SELECT COUNT(1)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'oms_biz_root_relation'
    AND COLUMN_NAME = 'active_biz_key'
);
SET @sql := IF(@col_exists = 0,
  'ALTER TABLE `oms_biz_root_relation` ADD COLUMN `active_biz_key` varchar(220) GENERATED ALWAYS AS (CASE WHEN `deleted` = b''0'' AND `relation_status` = ''ACTIVE'' THEN CONCAT(`cargo_order_id`, ''#'', `target_type`, ''#'', `target_id`) ELSE NULL END) STORED COMMENT ''active relation unique key'' AFTER `relation_status`',
  'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @idx_exists := (
  SELECT COUNT(1)
  FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'oms_biz_root_relation'
    AND INDEX_NAME = 'uk_oms_biz_root_relation_biz_active'
);
SET @sql := IF(@idx_exists = 0,
  'ALTER TABLE `oms_biz_root_relation` ADD UNIQUE KEY `uk_oms_biz_root_relation_biz_active` (`active_biz_key`)',
  'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Integration event log: durable handoff record for OMS -> WMS/YMS and YMS -> OMS.
CREATE TABLE IF NOT EXISTS `oms_integration_event_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `tenant_id` bigint DEFAULT NULL COMMENT 'tenant id',
  `company_id` bigint DEFAULT NULL COMMENT 'company id',
  `warehouse_id` bigint DEFAULT NULL COMMENT 'warehouse id',
  `source_module` varchar(32) NOT NULL COMMENT 'source module',
  `target_module` varchar(32) NOT NULL COMMENT 'target module',
  `biz_type` varchar(64) NOT NULL COMMENT 'business type',
  `biz_id` bigint NOT NULL COMMENT 'business id',
  `biz_no` varchar(64) DEFAULT NULL COMMENT 'business no',
  `event_type` varchar(64) NOT NULL COMMENT 'event type',
  `event_key` varchar(128) NOT NULL COMMENT 'idempotent event key',
  `event_status` varchar(32) NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING/SUCCESS/FAILED/IGNORED',
  `request_payload` text DEFAULT NULL COMMENT 'request payload json',
  `response_payload` text DEFAULT NULL COMMENT 'response payload json',
  `error_message` varchar(1000) DEFAULT NULL COMMENT 'last error',
  `retry_count` int NOT NULL DEFAULT 0 COMMENT 'retry count',
  `next_retry_time` datetime DEFAULT NULL COMMENT 'next retry time',
  `last_execute_time` datetime DEFAULT NULL COMMENT 'last execute time',
  `creator` varchar(64) DEFAULT '' COMMENT 'creator',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'create time',
  `updater` varchar(64) DEFAULT '' COMMENT 'updater',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'update time',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT 'deleted',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_oms_integration_event_key` (`event_key`, `deleted`),
  KEY `idx_oms_integration_event_biz` (`biz_type`, `biz_id`),
  KEY `idx_oms_integration_event_status` (`event_status`, `next_retry_time`),
  KEY `idx_oms_integration_event_org` (`tenant_id`, `company_id`, `warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='OMS integration event log';
