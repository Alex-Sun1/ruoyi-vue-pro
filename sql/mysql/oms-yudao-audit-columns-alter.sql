-- OMS 审计字段对齐芋道 BaseDO：creator / updater（varchar）
-- 适用：由 oms-init-from-reference.sql 等旧脚本建库、仍使用 create_by / update_by 的环境
-- 可重复执行；已有 creator 列的表会自动跳过
-- 执行后请重启应用验证海柜列表等接口
-- 说明：脚本在存储过程内临时 SET SQL_SAFE_UPDATES=0，兼容 MySQL Workbench 安全更新模式
SET NAMES utf8mb4;

DROP PROCEDURE IF EXISTS `oms_migrate_audit_columns_to_yudao`;

DELIMITER //
CREATE PROCEDURE `oms_migrate_audit_columns_to_yudao`(IN p_table_name VARCHAR(64))
BEGIN
    DECLARE v_has_creator INT DEFAULT 0;
    DECLARE v_has_create_by INT DEFAULT 0;
    DECLARE v_has_update_time INT DEFAULT 0;
    DECLARE v_old_safe_updates INT DEFAULT 0;

    SET v_old_safe_updates = @@SQL_SAFE_UPDATES;
    SET SQL_SAFE_UPDATES = 0;

    SELECT COUNT(*) INTO v_has_creator
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = p_table_name
      AND COLUMN_NAME = 'creator';

    SELECT COUNT(*) INTO v_has_create_by
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = p_table_name
      AND COLUMN_NAME = 'create_by';

    SELECT COUNT(*) INTO v_has_update_time
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = p_table_name
      AND COLUMN_NAME = 'update_time';

    IF v_has_creator = 0 AND v_has_create_by > 0 AND v_has_update_time > 0 THEN
        SET @ddl = CONCAT(
            'ALTER TABLE `', p_table_name, '` ',
            'ADD COLUMN `creator` varchar(64) DEFAULT '''' COMMENT ''创建者'' AFTER `update_time`, ',
            'ADD COLUMN `updater` varchar(64) DEFAULT '''' COMMENT ''更新者'' AFTER `creator`'
        );
        PREPARE stmt FROM @ddl;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

        SELECT COUNT(*) INTO v_has_creator
        FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE()
          AND TABLE_NAME = p_table_name
          AND COLUMN_NAME = 'creator';
    END IF;

    -- 回填（含上次仅加列、UPDATE 被 safe mode 中断的情况）
    IF v_has_create_by > 0 AND v_has_creator > 0 THEN
        SET @migrate_creator = CONCAT(
            'UPDATE `', p_table_name, '` SET `creator` = CAST(`create_by` AS CHAR) ',
            'WHERE `id` > 0 AND `create_by` IS NOT NULL AND (`creator` IS NULL OR `creator` = '''')'
        );
        PREPARE stmt FROM @migrate_creator;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

        SET @migrate_updater = CONCAT(
            'UPDATE `', p_table_name, '` SET `updater` = CAST(`update_by` AS CHAR) ',
            'WHERE `id` > 0 AND `update_by` IS NOT NULL AND (`updater` IS NULL OR `updater` = '''')'
        );
        PREPARE stmt FROM @migrate_updater;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;

    SET SQL_SAFE_UPDATES = v_old_safe_updates;
END //
DELIMITER ;

-- 海柜 / 委托 / 出库 / 附件 / 分组 / 入库计划（与 yudao-module-oms DO @TableName 一致）
CALL `oms_migrate_audit_columns_to_yudao`('oms_container_order');
CALL `oms_migrate_audit_columns_to_yudao`('oms_container_cargo_order_rel');
CALL `oms_migrate_audit_columns_to_yudao`('oms_container_order_trace');
CALL `oms_migrate_audit_columns_to_yudao`('biz_root');
CALL `oms_migrate_audit_columns_to_yudao`('biz_attachment');
CALL `oms_migrate_audit_columns_to_yudao`('oms_cargo_order');
CALL `oms_migrate_audit_columns_to_yudao`('oms_cargo_order_shipment');
CALL `oms_migrate_audit_columns_to_yudao`('oms_cargo_order_sku_item');
CALL `oms_migrate_audit_columns_to_yudao`('oms_cargo_order_hold_record');
CALL `oms_migrate_audit_columns_to_yudao`('oms_cargo_order_node_trace');
CALL `oms_migrate_audit_columns_to_yudao`('oms_pre_outbound');
CALL `oms_migrate_audit_columns_to_yudao`('oms_pre_outbound_item');
CALL `oms_migrate_audit_columns_to_yudao`('oms_outbound_order');
CALL `oms_migrate_audit_columns_to_yudao`('oms_outbound_order_item');
CALL `oms_migrate_audit_columns_to_yudao`('oms_cargo_grouping_rule');
CALL `oms_migrate_audit_columns_to_yudao`('oms_cargo_grouping_field_meta');
CALL `oms_migrate_audit_columns_to_yudao`('wms_inbound_plan');
CALL `oms_migrate_audit_columns_to_yudao`('wms_inbound_plan_item');
CALL `oms_migrate_audit_columns_to_yudao`('wms_inbound_plan_change_log');

DROP PROCEDURE IF EXISTS `oms_migrate_audit_columns_to_yudao`;

-- 部分旧表无逻辑删除列，补齐以匹配 BaseDO.deleted
DROP PROCEDURE IF EXISTS `oms_add_deleted_column_if_missing`;

DELIMITER //
CREATE PROCEDURE `oms_add_deleted_column_if_missing`(IN p_table_name VARCHAR(64))
BEGIN
    DECLARE v_has_deleted INT DEFAULT 0;
    DECLARE v_has_updater INT DEFAULT 0;

    SELECT COUNT(*) INTO v_has_deleted
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = p_table_name
      AND COLUMN_NAME = 'deleted';

    SELECT COUNT(*) INTO v_has_updater
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = p_table_name
      AND COLUMN_NAME = 'updater';

    IF v_has_deleted = 0 THEN
        IF v_has_updater > 0 THEN
            SET @ddl = CONCAT(
                'ALTER TABLE `', p_table_name, '` ',
                'ADD COLUMN `deleted` bit(1) NOT NULL DEFAULT b''0'' COMMENT ''是否删除'' AFTER `updater`'
            );
        ELSE
            SET @ddl = CONCAT(
                'ALTER TABLE `', p_table_name, '` ',
                'ADD COLUMN `deleted` bit(1) NOT NULL DEFAULT b''0'' COMMENT ''是否删除'' AFTER `update_time`'
            );
        END IF;
        PREPARE stmt FROM @ddl;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END //
DELIMITER ;

CALL `oms_add_deleted_column_if_missing`('oms_container_cargo_order_rel');
CALL `oms_add_deleted_column_if_missing`('oms_container_order_trace');
CALL `oms_add_deleted_column_if_missing`('oms_cargo_order_hold_record');
CALL `oms_add_deleted_column_if_missing`('oms_cargo_grouping_field_meta');
CALL `oms_add_deleted_column_if_missing`('oms_cargo_grouping_rule');

DROP PROCEDURE IF EXISTS `oms_add_deleted_column_if_missing`;

-- 自检（应看到 creator、updater）
-- SELECT COLUMN_NAME FROM information_schema.COLUMNS
-- WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_container_order'
--   AND COLUMN_NAME IN ('create_by', 'creator', 'update_by', 'updater');
