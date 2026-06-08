-- =============================================
-- 海外仓系统 - 基础资料表审计字段修复
-- 日期：2026-05-22
-- 说明：
--   RuoYi-Vue-Plus 的 TenantEntity 继承 BaseEntity，BaseEntity 包含 create_dept。
--   基础资料实体继承 TenantEntity 时，MyBatis-Plus 会默认查询 create_dept。
--   若历史建表脚本未创建该字段，列表接口会报：
--   Unknown column 'create_dept' in 'field list'
--
-- 用法：
--   在当前业务库执行本脚本一次即可。脚本可重复执行。
-- =============================================

DELIMITER $$

DROP PROCEDURE IF EXISTS add_base_create_dept_if_missing $$
CREATE PROCEDURE add_base_create_dept_if_missing(IN p_table_name VARCHAR(64))
BEGIN
  IF EXISTS (
    SELECT 1
      FROM information_schema.tables
     WHERE table_schema = DATABASE()
       AND table_name = p_table_name
  )
  AND NOT EXISTS (
    SELECT 1
      FROM information_schema.columns
     WHERE table_schema = DATABASE()
       AND table_name = p_table_name
       AND column_name = 'create_dept'
  ) THEN
    SET @ddl = CONCAT(
      'ALTER TABLE `', p_table_name,
      '` ADD COLUMN `create_dept` bigint NULL COMMENT ''创建部门'''
    );
    PREPARE stmt FROM @ddl;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
  END IF;
END $$

DELIMITER ;

CALL add_base_create_dept_if_missing('platform');
CALL add_base_create_dept_if_missing('platform_address');
CALL add_base_create_dept_if_missing('mdm_fee_item');
CALL add_base_create_dept_if_missing('mdm_company');
CALL add_base_create_dept_if_missing('mdm_warehouse');
CALL add_base_create_dept_if_missing('mdm_sku');
CALL add_base_create_dept_if_missing('country');
CALL add_base_create_dept_if_missing('state_province');
CALL add_base_create_dept_if_missing('city');
CALL add_base_create_dept_if_missing('timezone');
CALL add_base_create_dept_if_missing('currency');
CALL add_base_create_dept_if_missing('exchange_rate');
CALL add_base_create_dept_if_missing('port');
CALL add_base_create_dept_if_missing('shipping_line');
CALL add_base_create_dept_if_missing('zip_code');

DROP PROCEDURE IF EXISTS add_base_create_dept_if_missing;
