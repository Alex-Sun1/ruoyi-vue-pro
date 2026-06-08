-- =============================================
-- YMS 缺失字段补丁（一次性执行）
-- 日期：2026-05-31
-- 说明：可重复执行，列已存在则自动跳过
-- =============================================

DROP PROCEDURE IF EXISTS _add_col;
DELIMITER //
CREATE PROCEDURE _add_col(IN t VARCHAR(64), IN c VARCHAR(64), IN def TEXT)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = t AND COLUMN_NAME = c
    ) THEN
        SET @s = CONCAT('ALTER TABLE `', t, '` ADD COLUMN `', c, '` ', def);
        PREPARE st FROM @s; EXECUTE st; DEALLOCATE PREPARE st;
    END IF;
END //
DELIMITER ;

-- =============================================
-- yms_check_in 缺失字段
-- =============================================

-- 签到类型
CALL _add_col('yms_check_in', 'check_in_type',
    "VARCHAR(20) DEFAULT 'TRUCK_TRAILER' COMMENT '签到类型：CONTAINER/TRUCK_TRAILER' AFTER `warehouse_id`");

-- 资源ID
CALL _add_col('yms_check_in', 'container_resource_id',
    "BIGINT DEFAULT NULL COMMENT '海柜资源ID' AFTER `yard_task_no`");
CALL _add_col('yms_check_in', 'trailer_resource_id',
    "BIGINT DEFAULT NULL COMMENT '车厢资源ID' AFTER `container_resource_id`");

-- 车厢号与车辆来源
CALL _add_col('yms_check_in', 'trailer_no',
    "VARCHAR(64) DEFAULT NULL COMMENT '车厢号' AFTER `container_no`");
CALL _add_col('yms_check_in', 'vehicle_source',
    "VARCHAR(30) DEFAULT NULL COMMENT '车辆来源' AFTER `trailer_no`");

-- 离场时间与在场时长
CALL _add_col('yms_check_in', 'check_out_time',
    "DATETIME DEFAULT NULL COMMENT '离场时间' AFTER `check_in_time`");
CALL _add_col('yms_check_in', 'stay_minutes',
    "INT DEFAULT NULL COMMENT '在场时长（分钟）' AFTER `check_out_time`");

-- 离场司机信息快照
CALL _add_col('yms_check_in', 'check_out_plate_no',
    "VARCHAR(32) DEFAULT NULL COMMENT '离场车牌' AFTER `stay_minutes`");
CALL _add_col('yms_check_in', 'check_out_driver_name',
    "VARCHAR(50) DEFAULT NULL COMMENT '离场司机姓名' AFTER `check_out_plate_no`");
CALL _add_col('yms_check_in', 'check_out_driver_phone',
    "VARCHAR(20) DEFAULT NULL COMMENT '离场司机电话' AFTER `check_out_driver_name`");
CALL _add_col('yms_check_in', 'check_out_id_card_no',
    "VARCHAR(32) DEFAULT NULL COMMENT '离场司机证件号' AFTER `check_out_driver_phone`");
CALL _add_col('yms_check_in', 'check_out_photo_urls',
    "TEXT DEFAULT NULL COMMENT '离场照片URL（JSON数组）' AFTER `check_out_id_card_no`");

-- 入场照片与小票号
CALL _add_col('yms_check_in', 'photo_urls',
    "TEXT DEFAULT NULL COMMENT '入场照片URL（JSON数组）' AFTER `remark`");
CALL _add_col('yms_check_in', 'receipt_no',
    "VARCHAR(32) DEFAULT NULL COMMENT '入场小票号' AFTER `photo_urls`");

-- 来源与停车位（Phase 1 新增）
CALL _add_col('yms_check_in', 'checkin_source',
    "VARCHAR(20) NOT NULL DEFAULT 'GATE' COMMENT '登记来源 GATE/DRIVER_SELF' AFTER `check_in_type`");
CALL _add_col('yms_check_in', 'position_id',
    "BIGINT DEFAULT NULL COMMENT '停车位ID'");
CALL _add_col('yms_check_in', 'position_code',
    "VARCHAR(50) DEFAULT NULL COMMENT '停车位编码'");

-- OMS 数据比对
CALL _add_col('yms_check_in', 'oms_mismatch_flag',
    "TINYINT(1) NOT NULL DEFAULT 0 COMMENT '与OMS数据不符标记'");
CALL _add_col('yms_check_in', 'oms_mismatch_fields',
    "VARCHAR(500) DEFAULT NULL COMMENT '不符字段列表（JSON数组）'");

-- =============================================
-- yms_yard_task 缺失字段
-- =============================================

CALL _add_col('yms_yard_task', 'container_resource_id',
    "BIGINT DEFAULT NULL COMMENT '海柜资源ID' AFTER `container_no`");
CALL _add_col('yms_yard_task', 'trailer_resource_id',
    "BIGINT DEFAULT NULL COMMENT '车厢资源ID' AFTER `container_resource_id`");
CALL _add_col('yms_yard_task', 'wms_ready_status',
    "VARCHAR(30) NOT NULL DEFAULT 'NOT_REQUIRED' COMMENT 'WMS备货状态：NOT_REQUIRED/PENDING/READY' AFTER `trailer_resource_id`");
CALL _add_col('yms_yard_task', 'wms_ready_time',
    "DATETIME DEFAULT NULL COMMENT 'WMS备货完成时间' AFTER `wms_ready_status`");
CALL _add_col('yms_yard_task', 'appointment_id',
    "BIGINT DEFAULT NULL COMMENT '预约ID' AFTER `wms_ready_time`");
CALL _add_col('yms_yard_task', 'dock_assign_time',
    "DATETIME DEFAULT NULL COMMENT 'Dock分配时间' AFTER `appointment_id`");
CALL _add_col('yms_yard_task', 'call_time',
    "DATETIME DEFAULT NULL COMMENT '叫号时间' AFTER `dock_assign_time`");
CALL _add_col('yms_yard_task', 'priority',
    "INT NOT NULL DEFAULT 5 COMMENT '优先级（1-10，越小越高）' AFTER `call_time`");
CALL _add_col('yms_yard_task', 'driver_license_no',
    "VARCHAR(50) DEFAULT NULL COMMENT '司机驾照号码（装车司机H5预登记时补录）' AFTER `driver_phone`");

-- =============================================
-- yard_dock 缺失字段（YMS 调度类型）
-- =============================================

CALL _add_col('yard_dock', 'dock_type',
    "VARCHAR(30) DEFAULT NULL COMMENT 'Dock类型：DEVANNING卸柜/LOADING装车/MIXED_DOCK混用' AFTER `dispatch_priority`");
CALL _add_col('yard_dock', 'enable_queue',
    "TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否允许排队(0否1是)' AFTER `dock_type`");
CALL _add_col('yard_dock', 'max_queue_count',
    "INT DEFAULT NULL COMMENT '最大排队数量' AFTER `enable_queue`");

DROP PROCEDURE IF EXISTS _add_col;
