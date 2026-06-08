-- =============================================================
-- OMS cargo lifecycle migration
-- Date: 2026-05-27
-- Goal:
--   1. Use biz_root.current_node as the source of truth for cargo lifecycle.
--   2. Backfill biz_root from existing oms_cargo_order.fulfillment_status.
--   3. Remove redundant oms_cargo_order.current_node/current_node_time.
-- 兼容 MySQL Workbench Safe Update Mode
-- =============================================================

SET SQL_SAFE_UPDATES = 0;

UPDATE `oms_cargo_order` co
LEFT JOIN `biz_root` br ON br.`id` = co.`biz_root_id`
SET co.`biz_root_id` = co.`id` + 900000000000000000
WHERE co.`deleted` = 0
  AND co.`biz_root_id` IS NULL
  AND br.`id` IS NULL;

INSERT IGNORE INTO `biz_root` (
    `id`, `tenant_id`, `company_id`, `warehouse_id`, `root_no`, `root_type`,
    `source_module`, `source_order_id`, `source_order_no`,
    `customer_id`, `customer_name`, `channel_id`, `business_type_id`,
    `current_module`, `current_node`, `current_node_name`, `current_node_time`,
    `root_status`, `exception_flag`, `exception_count`, `start_time`,
    `complete_time`, `cancel_time`, `remark`,
    `create_by`, `create_time`, `update_by`, `update_time`, `deleted`
)
SELECT co.`biz_root_id`,
       co.`tenant_id`,
       co.`company_id`,
       co.`inbound_warehouse_id`,
       co.`cargo_order_no`,
       'CARGO_ORDER',
       'OMS',
       co.`id`,
       co.`cargo_order_no`,
       co.`customer_id`,
       co.`customer_name`,
       co.`channel_id`,
       co.`business_type_id`,
       'OMS',
       COALESCE(NULLIF(co.`fulfillment_status`, ''), 'PENDING_ACCEPT'),
       CASE COALESCE(NULLIF(co.`fulfillment_status`, ''), 'PENDING_ACCEPT')
           WHEN 'PENDING_ACCEPT' THEN '待受理'
           WHEN 'ACCEPTED' THEN '已受理'
           WHEN 'IN_TRANSIT' THEN '在途'
           WHEN 'ARRIVED_PORT' THEN '已到港'
           WHEN 'PICKED_UP' THEN '已提柜'
           WHEN 'ARRIVED_WAREHOUSE' THEN '已到仓'
           WHEN 'DEVANNING' THEN '拆柜中'
           WHEN 'DEVANNED' THEN '拆柜完成'
           WHEN 'INBOUNDED' THEN '已入库'
           WHEN 'OUTBOUND_ORDERED' THEN '已出单'
           WHEN 'DELIVERY_APPOINTED' THEN '已预约派送'
           WHEN 'OUTBOUNDED' THEN '已出库'
           WHEN 'DELIVERING' THEN '派送中'
           WHEN 'DELIVERED' THEN '已签收'
           WHEN 'POD_UPLOADED' THEN 'POD已上传'
           WHEN 'BILLED' THEN '已出账'
           WHEN 'COMPLETED' THEN '已完成'
           WHEN 'CANCELLED' THEN '已取消'
           ELSE '待受理'
       END,
       COALESCE(co.`update_time`, co.`create_time`, NOW()),
       CASE COALESCE(NULLIF(co.`fulfillment_status`, ''), 'PENDING_ACCEPT')
           WHEN 'COMPLETED' THEN 'DONE'
           WHEN 'CANCELLED' THEN 'CANCELLED'
           ELSE 'RUNNING'
       END,
       0,
       0,
       COALESCE(co.`create_time`, NOW()),
       CASE WHEN co.`fulfillment_status` = 'COMPLETED' THEN COALESCE(co.`completed_time`, co.`update_time`) ELSE NULL END,
       CASE WHEN co.`fulfillment_status` = 'CANCELLED' THEN co.`update_time` ELSE NULL END,
       '历史货物订单补建业务主线',
       co.`create_by`,
       COALESCE(co.`create_time`, NOW()),
       co.`update_by`,
       co.`update_time`,
       0
FROM `oms_cargo_order` co
LEFT JOIN `biz_root` br ON br.`id` = co.`biz_root_id`
WHERE co.`deleted` = 0
  AND co.`biz_root_id` IS NOT NULL
  AND br.`id` IS NULL;

UPDATE `biz_root` br
INNER JOIN `oms_cargo_order` co ON co.`biz_root_id` = br.`id`
SET br.`current_module` = 'OMS',
    br.`current_node` = COALESCE(NULLIF(co.`fulfillment_status`, ''), br.`current_node`, 'PENDING_ACCEPT'),
    br.`current_node_name` = CASE COALESCE(NULLIF(co.`fulfillment_status`, ''), br.`current_node`, 'PENDING_ACCEPT')
        WHEN 'PENDING_ACCEPT' THEN '待受理'
        WHEN 'ACCEPTED' THEN '已受理'
        WHEN 'IN_TRANSIT' THEN '在途'
        WHEN 'ARRIVED_PORT' THEN '已到港'
        WHEN 'PICKED_UP' THEN '已提柜'
        WHEN 'ARRIVED_WAREHOUSE' THEN '已到仓'
        WHEN 'DEVANNING' THEN '拆柜中'
        WHEN 'DEVANNED' THEN '拆柜完成'
        WHEN 'INBOUNDED' THEN '已入库'
        WHEN 'OUTBOUND_ORDERED' THEN '已出单'
        WHEN 'DELIVERY_APPOINTED' THEN '已预约派送'
        WHEN 'OUTBOUNDED' THEN '已出库'
        WHEN 'DELIVERING' THEN '派送中'
        WHEN 'DELIVERED' THEN '已签收'
        WHEN 'POD_UPLOADED' THEN 'POD已上传'
        WHEN 'BILLED' THEN '已出账'
        WHEN 'COMPLETED' THEN '已完成'
        WHEN 'CANCELLED' THEN '已取消'
        WHEN 'CARGO_CREATED' THEN '待受理'
        ELSE COALESCE(br.`current_node_name`, '待受理')
    END,
    br.`current_node_time` = COALESCE(br.`current_node_time`, co.`update_time`, co.`create_time`, NOW()),
    br.`root_status` = CASE COALESCE(NULLIF(co.`fulfillment_status`, ''), br.`current_node`, 'PENDING_ACCEPT')
        WHEN 'COMPLETED' THEN 'DONE'
        WHEN 'CANCELLED' THEN 'CANCELLED'
        ELSE 'RUNNING'
    END,
    br.`complete_time` = CASE
        WHEN COALESCE(NULLIF(co.`fulfillment_status`, ''), br.`current_node`) = 'COMPLETED'
            THEN COALESCE(co.`completed_time`, br.`complete_time`, co.`update_time`)
        ELSE br.`complete_time`
    END,
    br.`cancel_time` = CASE
        WHEN COALESCE(NULLIF(co.`fulfillment_status`, ''), br.`current_node`) = 'CANCELLED'
            THEN COALESCE(br.`cancel_time`, co.`update_time`)
        ELSE br.`cancel_time`
    END
WHERE co.`deleted` = 0;

UPDATE `biz_root`
SET `current_node` = 'PENDING_ACCEPT',
    `current_node_name` = '待受理'
WHERE `root_type` IN ('CARGO', 'CARGO_ORDER')
  AND `current_node` = 'CARGO_CREATED';

SET SQL_SAFE_UPDATES = 1;

SET @idx_exists := (
    SELECT COUNT(1)
    FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'biz_root'
      AND INDEX_NAME = 'idx_biz_root_current_node'
);
SET @sql := IF(@idx_exists = 0,
    'ALTER TABLE `biz_root` ADD INDEX `idx_biz_root_current_node` (`current_node`)',
    'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @col_exists := (
    SELECT COUNT(1)
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'oms_cargo_order'
      AND COLUMN_NAME = 'current_node'
);
SET @sql := IF(@col_exists > 0,
    'ALTER TABLE `oms_cargo_order` DROP COLUMN `current_node`',
    'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @col_exists := (
    SELECT COUNT(1)
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'oms_cargo_order'
      AND COLUMN_NAME = 'current_node_time'
);
SET @sql := IF(@col_exists > 0,
    'ALTER TABLE `oms_cargo_order` DROP COLUMN `current_node_time`',
    'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
