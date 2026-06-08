-- =====================================================================
-- 修复：为 02-yms-tables.sql 所有表的 id 列补 AUTO_INCREMENT
-- 原因：全局 id-type: NONE 在 MySQL 下适配为 AUTO，依赖 DB AUTO_INCREMENT 生成主键，
--       但 02-yms-tables.sql 建表时 id 均未加 AUTO_INCREMENT，导致所有 INSERT 报
--       "Field 'id' doesn't have a default value"
-- =====================================================================

-- 通用宏：仅当 id 列还没有 AUTO_INCREMENT 时才 ALTER
-- （避免重复执行报错）

SET @t = 'yms_container_resource';
SET @sql := IF((SELECT EXTRA FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=@t AND COLUMN_NAME='id') NOT LIKE '%auto_increment%',
  CONCAT('ALTER TABLE `', @t, '` MODIFY COLUMN `id` bigint NOT NULL AUTO_INCREMENT COMMENT ''主键'''), 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @t = 'yms_trailer_resource';
SET @sql := IF((SELECT EXTRA FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=@t AND COLUMN_NAME='id') NOT LIKE '%auto_increment%',
  CONCAT('ALTER TABLE `', @t, '` MODIFY COLUMN `id` bigint NOT NULL AUTO_INCREMENT COMMENT ''主键'''), 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @t = 'yms_yard_position';
SET @sql := IF((SELECT EXTRA FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=@t AND COLUMN_NAME='id') NOT LIKE '%auto_increment%',
  CONCAT('ALTER TABLE `', @t, '` MODIFY COLUMN `id` bigint NOT NULL AUTO_INCREMENT COMMENT ''主键'''), 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @t = 'yms_internal_task';
SET @sql := IF((SELECT EXTRA FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=@t AND COLUMN_NAME='id') NOT LIKE '%auto_increment%',
  CONCAT('ALTER TABLE `', @t, '` MODIFY COLUMN `id` bigint NOT NULL AUTO_INCREMENT COMMENT ''主键'''), 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @t = 'yms_appointment_rule';
SET @sql := IF((SELECT EXTRA FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=@t AND COLUMN_NAME='id') NOT LIKE '%auto_increment%',
  CONCAT('ALTER TABLE `', @t, '` MODIFY COLUMN `id` bigint NOT NULL AUTO_INCREMENT COMMENT ''主键'''), 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @t = 'yms_appointment_rule_slot';
SET @sql := IF((SELECT EXTRA FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=@t AND COLUMN_NAME='id') NOT LIKE '%auto_increment%',
  CONCAT('ALTER TABLE `', @t, '` MODIFY COLUMN `id` bigint NOT NULL AUTO_INCREMENT COMMENT ''主键'''), 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @t = 'yms_call_rule';
SET @sql := IF((SELECT EXTRA FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=@t AND COLUMN_NAME='id') NOT LIKE '%auto_increment%',
  CONCAT('ALTER TABLE `', @t, '` MODIFY COLUMN `id` bigint NOT NULL AUTO_INCREMENT COMMENT ''主键'''), 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @t = 'yms_call_rule_condition';
SET @sql := IF((SELECT EXTRA FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=@t AND COLUMN_NAME='id') NOT LIKE '%auto_increment%',
  CONCAT('ALTER TABLE `', @t, '` MODIFY COLUMN `id` bigint NOT NULL AUTO_INCREMENT COMMENT ''主键'''), 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @t = 'yms_call_rule_sort';
SET @sql := IF((SELECT EXTRA FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=@t AND COLUMN_NAME='id') NOT LIKE '%auto_increment%',
  CONCAT('ALTER TABLE `', @t, '` MODIFY COLUMN `id` bigint NOT NULL AUTO_INCREMENT COMMENT ''主键'''), 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @t = 'yms_call_record';
SET @sql := IF((SELECT EXTRA FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=@t AND COLUMN_NAME='id') NOT LIKE '%auto_increment%',
  CONCAT('ALTER TABLE `', @t, '` MODIFY COLUMN `id` bigint NOT NULL AUTO_INCREMENT COMMENT ''主键'''), 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @t = 'yms_yard_task';
SET @sql := IF((SELECT EXTRA FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=@t AND COLUMN_NAME='id') NOT LIKE '%auto_increment%',
  CONCAT('ALTER TABLE `', @t, '` MODIFY COLUMN `id` bigint NOT NULL AUTO_INCREMENT COMMENT ''主键'''), 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @t = 'yms_yard_task_log';
SET @sql := IF((SELECT EXTRA FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=@t AND COLUMN_NAME='id') NOT LIKE '%auto_increment%',
  CONCAT('ALTER TABLE `', @t, '` MODIFY COLUMN `id` bigint NOT NULL AUTO_INCREMENT COMMENT ''主键'''), 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @t = 'yms_appointment';
SET @sql := IF((SELECT EXTRA FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=@t AND COLUMN_NAME='id') NOT LIKE '%auto_increment%',
  CONCAT('ALTER TABLE `', @t, '` MODIFY COLUMN `id` bigint NOT NULL AUTO_INCREMENT COMMENT ''主键'''), 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @t = 'yms_check_in';
SET @sql := IF((SELECT EXTRA FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=@t AND COLUMN_NAME='id') NOT LIKE '%auto_increment%',
  CONCAT('ALTER TABLE `', @t, '` MODIFY COLUMN `id` bigint NOT NULL AUTO_INCREMENT COMMENT ''主键'''), 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @t = 'yms_yard_zone';
SET @sql := IF((SELECT EXTRA FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=@t AND COLUMN_NAME='id') NOT LIKE '%auto_increment%',
  CONCAT('ALTER TABLE `', @t, '` MODIFY COLUMN `id` bigint NOT NULL AUTO_INCREMENT COMMENT ''主键'''), 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @t = 'yms_slot_template';
SET @sql := IF((SELECT EXTRA FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=@t AND COLUMN_NAME='id') NOT LIKE '%auto_increment%',
  CONCAT('ALTER TABLE `', @t, '` MODIFY COLUMN `id` bigint NOT NULL AUTO_INCREMENT COMMENT ''主键'''), 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @t = 'yms_dock_queue';
SET @sql := IF((SELECT EXTRA FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=@t AND COLUMN_NAME='id') NOT LIKE '%auto_increment%',
  CONCAT('ALTER TABLE `', @t, '` MODIFY COLUMN `id` bigint NOT NULL AUTO_INCREMENT COMMENT ''主键'''), 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @t = 'yms_yard_inventory_task';
SET @sql := IF((SELECT EXTRA FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=@t AND COLUMN_NAME='id') NOT LIKE '%auto_increment%',
  CONCAT('ALTER TABLE `', @t, '` MODIFY COLUMN `id` bigint NOT NULL AUTO_INCREMENT COMMENT ''主键'''), 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @t = 'yms_yard_inventory_item';
SET @sql := IF((SELECT EXTRA FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=@t AND COLUMN_NAME='id') NOT LIKE '%auto_increment%',
  CONCAT('ALTER TABLE `', @t, '` MODIFY COLUMN `id` bigint NOT NULL AUTO_INCREMENT COMMENT ''主键'''), 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- yms_blacklist（02-yms-menu-batch2 等后续文件）
SET @t = 'yms_blacklist';
SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=@t AND COLUMN_NAME='id') > 0
  AND (SELECT EXTRA FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=@t AND COLUMN_NAME='id') NOT LIKE '%auto_increment%',
  CONCAT('ALTER TABLE `', @t, '` MODIFY COLUMN `id` bigint NOT NULL AUTO_INCREMENT COMMENT ''主键'''), 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @t = 'yms_yardgo_task';
SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=@t AND COLUMN_NAME='id') > 0
  AND (SELECT EXTRA FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME=@t AND COLUMN_NAME='id') NOT LIKE '%auto_increment%',
  CONCAT('ALTER TABLE `', @t, '` MODIFY COLUMN `id` bigint NOT NULL AUTO_INCREMENT COMMENT ''主键'''), 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
