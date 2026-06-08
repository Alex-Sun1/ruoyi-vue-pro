-- =============================================
-- 海外仓系统 - 基础资料表审计用户字段修复
-- 日期：2026-05-22
-- 说明：
--   BaseEntity.createBy / updateBy 类型为 Long。
--   历史基础资料脚本中部分表将 create_by / update_by 定义为 varchar，并写入 'admin'。
--   MyBatis 映射列表结果时会出现：
--   Cannot determine value type from string 'admin'
--
-- 用法：
--   在当前业务库执行本脚本一次即可。脚本可重复执行。
-- =============================================

DELIMITER $$

DROP PROCEDURE IF EXISTS normalize_base_audit_user_id $$
CREATE PROCEDURE normalize_base_audit_user_id(IN p_table_name VARCHAR(64))
BEGIN
  IF EXISTS (
    SELECT 1
      FROM information_schema.columns
     WHERE table_schema = DATABASE()
       AND table_name = p_table_name
       AND column_name = 'create_by'
  ) THEN
    SET @sql = CONCAT(
      'UPDATE `', p_table_name,
      '` SET `create_by` = ''1'' WHERE `create_by` IS NOT NULL AND `create_by` <> '''' AND `create_by` NOT REGEXP ''^[0-9]+$'''
    );
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = CONCAT('ALTER TABLE `', p_table_name, '` MODIFY COLUMN `create_by` bigint NULL COMMENT ''创建者''');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
  END IF;

  IF EXISTS (
    SELECT 1
      FROM information_schema.columns
     WHERE table_schema = DATABASE()
       AND table_name = p_table_name
       AND column_name = 'update_by'
  ) THEN
    SET @sql = CONCAT(
      'UPDATE `', p_table_name,
      '` SET `update_by` = ''1'' WHERE `update_by` IS NOT NULL AND `update_by` <> '''' AND `update_by` NOT REGEXP ''^[0-9]+$'''
    );
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @sql = CONCAT('ALTER TABLE `', p_table_name, '` MODIFY COLUMN `update_by` bigint NULL COMMENT ''更新者''');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
  END IF;
END $$

DELIMITER ;

CALL normalize_base_audit_user_id('platform');
CALL normalize_base_audit_user_id('platform_address');
CALL normalize_base_audit_user_id('mdm_fee_item');
CALL normalize_base_audit_user_id('mdm_company');
CALL normalize_base_audit_user_id('mdm_warehouse');
CALL normalize_base_audit_user_id('mdm_sku');
CALL normalize_base_audit_user_id('country');
CALL normalize_base_audit_user_id('state_province');
CALL normalize_base_audit_user_id('city');
CALL normalize_base_audit_user_id('timezone');
CALL normalize_base_audit_user_id('currency');
CALL normalize_base_audit_user_id('exchange_rate');
CALL normalize_base_audit_user_id('port');
CALL normalize_base_audit_user_id('shipping_line');
CALL normalize_base_audit_user_id('zip_code');

DROP PROCEDURE IF EXISTS normalize_base_audit_user_id;
