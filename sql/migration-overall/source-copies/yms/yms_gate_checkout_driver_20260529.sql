-- =============================================
-- YMS Check-out 离场司机信息字段
-- 日期：2026-05-29
-- 说明：离场可与入场非同车/同司机（如空柜提走），单独快照留存
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

CALL yms_add_column_if_missing('yms_check_in', 'check_out_plate_no',
    'VARCHAR(32) DEFAULT NULL COMMENT ''离场车牌（快照）'' AFTER `stay_minutes`');
CALL yms_add_column_if_missing('yms_check_in', 'check_out_driver_name',
    'VARCHAR(50) DEFAULT NULL COMMENT ''离场司机姓名'' AFTER `check_out_plate_no`');
CALL yms_add_column_if_missing('yms_check_in', 'check_out_driver_phone',
    'VARCHAR(20) DEFAULT NULL COMMENT ''离场司机电话'' AFTER `check_out_driver_name`');
CALL yms_add_column_if_missing('yms_check_in', 'check_out_id_card_no',
    'VARCHAR(32) DEFAULT NULL COMMENT ''离场司机证件号'' AFTER `check_out_driver_phone`');
CALL yms_add_column_if_missing('yms_check_in', 'check_out_photo_urls',
    'TEXT DEFAULT NULL COMMENT ''离场现场照片URL（JSON数组）'' AFTER `check_out_id_card_no`');

DROP PROCEDURE IF EXISTS yms_add_column_if_missing;
