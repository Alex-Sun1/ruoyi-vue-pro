-- =============================================
-- YMS Phase 1 ALTER 补丁（单独执行）
-- 日期：2026-05-29
-- 用途：修复 ADD COLUMN IF NOT EXISTS 在 MySQL 下不兼容的问题
-- 说明：可重复执行；列已存在则自动跳过
-- =============================================

DROP PROCEDURE IF EXISTS yms_add_column_if_missing;
DELIMITER //
CREATE PROCEDURE yms_add_column_if_missing(
    IN p_table   VARCHAR(64),
    IN p_column  VARCHAR(64),
    IN p_def     TEXT
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE()
          AND TABLE_NAME   = p_table
          AND COLUMN_NAME  = p_column
    ) THEN
        SET @sql = CONCAT('ALTER TABLE `', p_table, '` ADD COLUMN `', p_column, '` ', p_def);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END //
DELIMITER ;

-- yms_yard_task
CALL yms_add_column_if_missing('yms_yard_task', 'container_resource_id',
    'BIGINT DEFAULT NULL COMMENT ''海柜资源ID（DEVANNING任务）'' AFTER `container_no`');
CALL yms_add_column_if_missing('yms_yard_task', 'trailer_resource_id',
    'BIGINT DEFAULT NULL COMMENT ''车厢资源ID（LOADING任务）'' AFTER `container_resource_id`');
CALL yms_add_column_if_missing('yms_yard_task', 'wms_ready_status',
    'VARCHAR(30) NOT NULL DEFAULT ''NOT_REQUIRED'' COMMENT ''WMS备货状态：NOT_REQUIRED/PENDING/READY'' AFTER `trailer_resource_id`');
CALL yms_add_column_if_missing('yms_yard_task', 'wms_ready_time',
    'DATETIME DEFAULT NULL COMMENT ''WMS备货完成时间'' AFTER `wms_ready_status`');
CALL yms_add_column_if_missing('yms_yard_task', 'appointment_id',
    'BIGINT DEFAULT NULL COMMENT ''预约ID'' AFTER `wms_ready_time`');
CALL yms_add_column_if_missing('yms_yard_task', 'dock_assign_time',
    'DATETIME DEFAULT NULL COMMENT ''Dock分配时间'' AFTER `appointment_id`');
CALL yms_add_column_if_missing('yms_yard_task', 'call_time',
    'DATETIME DEFAULT NULL COMMENT ''叫号时间'' AFTER `dock_assign_time`');
CALL yms_add_column_if_missing('yms_yard_task', 'priority',
    'INT NOT NULL DEFAULT 5 COMMENT ''优先级（1-10，越小越高）'' AFTER `call_time`');

-- yms_appointment
CALL yms_add_column_if_missing('yms_appointment', 'appointment_rule_id',
    'BIGINT DEFAULT NULL COMMENT ''预约规则ID'' AFTER `slot_template_id`');
CALL yms_add_column_if_missing('yms_appointment', 'business_type',
    'VARCHAR(30) DEFAULT NULL COMMENT ''业务类型'' AFTER `task_type`');
CALL yms_add_column_if_missing('yms_appointment', 'vehicle_source',
    'VARCHAR(30) DEFAULT NULL COMMENT ''车辆来源'' AFTER `business_type`');
CALL yms_add_column_if_missing('yms_appointment', 'trailer_no',
    'VARCHAR(64) DEFAULT NULL COMMENT ''车厢号'' AFTER `container_no`');
CALL yms_add_column_if_missing('yms_appointment', 'slot_start_time',
    'TIME DEFAULT NULL COMMENT ''预约时段开始时间'' AFTER `apt_slot`');
CALL yms_add_column_if_missing('yms_appointment', 'slot_end_time',
    'TIME DEFAULT NULL COMMENT ''预约时段结束时间'' AFTER `slot_start_time`');

-- yms_check_in
CALL yms_add_column_if_missing('yms_check_in', 'check_in_type',
    'VARCHAR(20) DEFAULT ''TRUCK_TRAILER'' COMMENT ''签到类型：CONTAINER/TRUCK_TRAILER'' AFTER `warehouse_id`');
CALL yms_add_column_if_missing('yms_check_in', 'trailer_no',
    'VARCHAR(64) DEFAULT NULL COMMENT ''车厢号'' AFTER `container_no`');
CALL yms_add_column_if_missing('yms_check_in', 'vehicle_source',
    'VARCHAR(30) DEFAULT NULL COMMENT ''车辆来源'' AFTER `trailer_no`');
CALL yms_add_column_if_missing('yms_check_in', 'container_resource_id',
    'BIGINT DEFAULT NULL COMMENT ''生成/关联的海柜资源ID'' AFTER `yard_task_id`');
CALL yms_add_column_if_missing('yms_check_in', 'trailer_resource_id',
    'BIGINT DEFAULT NULL COMMENT ''生成/关联的车厢资源ID'' AFTER `container_resource_id`');

DROP PROCEDURE IF EXISTS yms_add_column_if_missing;
