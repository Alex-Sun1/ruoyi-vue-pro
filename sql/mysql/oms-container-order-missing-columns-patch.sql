-- 海柜订单表缺列补丁（列表 500 常见原因：Unknown column）
-- 可重复执行
SET NAMES utf8mb4;

SET @schema_name = DATABASE();

-- inbound_warehouse_name
SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS
   WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_container_order'
     AND COLUMN_NAME = 'inbound_warehouse_name') = 0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `inbound_warehouse_name` varchar(128) DEFAULT NULL COMMENT ''入库仓库名称'' AFTER `warehouse_id`',
  'SELECT ''skip inbound_warehouse_name'' AS msg'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- available_time
SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS
   WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_container_order'
     AND COLUMN_NAME = 'available_time') = 0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `available_time` datetime DEFAULT NULL COMMENT ''可提时间'' AFTER `empty_return_lfd`',
  'SELECT ''skip available_time'' AS msg'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- required_arrival_time
SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS
   WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_container_order'
     AND COLUMN_NAME = 'required_arrival_time') = 0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `required_arrival_time` datetime DEFAULT NULL COMMENT ''要求到仓时间'' AFTER `expected_arrival_time`',
  'SELECT ''skip required_arrival_time'' AS msg'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- attachment_count
SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS
   WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_container_order'
     AND COLUMN_NAME = 'attachment_count') = 0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `attachment_count` int NOT NULL DEFAULT 0 COMMENT ''海柜附件总数'' AFTER `downstream_exception_count`',
  'SELECT ''skip attachment_count'' AS msg'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- do_attachment_count
SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS
   WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_container_order'
     AND COLUMN_NAME = 'do_attachment_count') = 0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `do_attachment_count` int NOT NULL DEFAULT 0 COMMENT ''DO附件数量'' AFTER `attachment_count`',
  'SELECT ''skip do_attachment_count'' AS msg'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- latest_attachment_time
SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS
   WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_container_order'
     AND COLUMN_NAME = 'latest_attachment_time') = 0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `latest_attachment_time` datetime DEFAULT NULL COMMENT ''最近附件上传时间'' AFTER `do_attachment_count`',
  'SELECT ''skip latest_attachment_time'' AS msg'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- latest_do_upload_time
SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS
   WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_container_order'
     AND COLUMN_NAME = 'latest_do_upload_time') = 0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `latest_do_upload_time` datetime DEFAULT NULL COMMENT ''最近DO上传时间'' AFTER `latest_attachment_time`',
  'SELECT ''skip latest_do_upload_time'' AS msg'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- devanning_order_no
SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS
   WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_container_order'
     AND COLUMN_NAME = 'devanning_order_no') = 0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `devanning_order_no` varchar(64) DEFAULT NULL COMMENT ''拆柜单号'' AFTER `devanning_no`',
  'SELECT ''skip devanning_order_no'' AS msg'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- devanning_warehouse_id
SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS
   WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_container_order'
     AND COLUMN_NAME = 'devanning_warehouse_id') = 0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `devanning_warehouse_id` bigint DEFAULT NULL COMMENT ''拆柜仓库ID'' AFTER `devanning_order_no`',
  'SELECT ''skip devanning_warehouse_id'' AS msg'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
