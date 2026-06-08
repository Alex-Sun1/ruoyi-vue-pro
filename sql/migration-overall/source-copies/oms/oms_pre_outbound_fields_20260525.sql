-- OMS pre-outbound supplemental delivery fields

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_pre_outbound' AND COLUMN_NAME = 'appointment_no') = 0,
  'ALTER TABLE `oms_pre_outbound` ADD COLUMN `appointment_no` varchar(64) DEFAULT NULL COMMENT ''预约号'' AFTER `outbound_order_no`',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_pre_outbound' AND COLUMN_NAME = 'appointment_time') = 0,
  'ALTER TABLE `oms_pre_outbound` ADD COLUMN `appointment_time` datetime DEFAULT NULL COMMENT ''预约日期'' AFTER `appointment_no`',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_pre_outbound' AND COLUMN_NAME = 'delivery_truck') = 0,
  'ALTER TABLE `oms_pre_outbound` ADD COLUMN `delivery_truck` varchar(128) DEFAULT NULL COMMENT ''派送卡车'' AFTER `appointment_time`',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_pre_outbound' AND COLUMN_NAME = 'loading_type') = 0,
  'ALTER TABLE `oms_pre_outbound` ADD COLUMN `loading_type` varchar(32) DEFAULT NULL COMMENT ''装车类型 PALLET/FLOOR'' AFTER `delivery_truck`',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_pre_outbound' AND COLUMN_NAME = 'transport_type') = 0,
  'ALTER TABLE `oms_pre_outbound` ADD COLUMN `transport_type` varchar(32) DEFAULT NULL COMMENT ''运输类型 FTL/LTL'' AFTER `loading_type`',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_pre_outbound' AND COLUMN_NAME = 'delivery_tag') = 0,
  'ALTER TABLE `oms_pre_outbound` ADD COLUMN `delivery_tag` varchar(128) DEFAULT NULL COMMENT ''派送标签'' AFTER `transport_type`',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_pre_outbound' AND COLUMN_NAME = 'destination') = 0,
  'ALTER TABLE `oms_pre_outbound` ADD COLUMN `destination` varchar(255) DEFAULT NULL COMMENT ''目的地'' AFTER `delivery_tag`',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_pre_outbound' AND COLUMN_NAME = 'delivery_method') = 0,
  'ALTER TABLE `oms_pre_outbound` ADD COLUMN `delivery_method` varchar(64) DEFAULT NULL COMMENT ''派送方式/业务类型'' AFTER `destination`',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_pre_outbound' AND COLUMN_NAME = 'follow_record') = 0,
  'ALTER TABLE `oms_pre_outbound` ADD COLUMN `follow_record` varchar(1000) DEFAULT NULL COMMENT ''跟进记录'' AFTER `delivery_method`',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_pre_outbound' AND INDEX_NAME = 'idx_appointment_time') = 0,
  'ALTER TABLE `oms_pre_outbound` ADD KEY `idx_appointment_time` (`appointment_time`)',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
