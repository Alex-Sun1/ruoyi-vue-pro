-- =============================================
-- YMS Gate Check-out 字段补丁
-- 日期：2026-05-29
-- 说明：yms_check_in 增加离场时间与在场时长
-- =============================================

DROP PROCEDURE IF EXISTS yms_add_column_if_missing;
DELIMITER //
CREATE PROCEDURE yms_add_column_if_missing(
    IN p_table VARCHAR(64),
    IN p_column VARCHAR(64),
    IN p_definition TEXT
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE()
          AND TABLE_NAME = p_table
          AND COLUMN_NAME = p_column
    ) THEN
        SET @sql = CONCAT('ALTER TABLE `', p_table, '` ADD COLUMN `', p_column, '` ', p_definition);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END //
DELIMITER ;

CALL yms_add_column_if_missing('yms_check_in', 'check_out_time',
    'DATETIME DEFAULT NULL COMMENT ''离场时间'' AFTER `check_in_time`');
CALL yms_add_column_if_missing('yms_check_in', 'stay_minutes',
    'INT DEFAULT NULL COMMENT ''在场时长（分钟）'' AFTER `check_out_time`');

DROP PROCEDURE IF EXISTS yms_add_column_if_missing;
