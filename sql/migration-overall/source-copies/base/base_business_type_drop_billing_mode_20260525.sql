-- ============================================================
-- 业务类型：移除计费模式字段
-- Date: 2026-05-25
-- 说明：可重复执行；执行前请备份 base_business_type 表
-- ============================================================

-- 1. 删除字段（列不存在则自动跳过）
SET @need_drop := (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'base_business_type'
    AND COLUMN_NAME = 'billing_mode'
);

SET @drop_sql := IF(
  @need_drop > 0,
  'ALTER TABLE `base_business_type` DROP COLUMN `billing_mode`',
  'SELECT ''billing_mode 列不存在，跳过'' AS msg'
);

PREPARE stmt FROM @drop_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2. 清理业务类型计费模式字典（billing_mode_vas 保留，供增值服务使用）
-- 使用主键删除，兼容 MySQL Safe Update Mode
DELETE FROM `sys_dict_data` WHERE `dict_code` IN (5000241, 5000242, 5000243, 5000244);
DELETE FROM `sys_dict_type` WHERE `dict_id` = 5000105;
