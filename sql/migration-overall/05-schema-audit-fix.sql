-- ============================================================
-- 05-schema-audit-fix.sql
-- 修复 WMS/YMS 迁移脚本与 Yudao BaseDO 字段不一致问题
-- 适用：已执行 01-wms-tables.sql / 02-yms-tables.sql 的旧库
-- 问题：create_by/update_by/create_dept vs creator/updater；tenant_id varchar vs bigint
-- 说明：MySQL Workbench 安全更新模式会拦截无 KEY 的 UPDATE，脚本内已处理
-- ============================================================

SET @OLD_SQL_SAFE_UPDATES = @@SESSION.sql_safe_updates;
SET SESSION sql_safe_updates = 0;

DELIMITER $$

DROP PROCEDURE IF EXISTS `migration_fix_audit_columns`$$
CREATE PROCEDURE `migration_fix_audit_columns`(IN p_table VARCHAR(128))
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;
    DECLARE v_has_create_by INT DEFAULT 0;
    DECLARE v_has_creator INT DEFAULT 0;
    DECLARE v_has_create_dept INT DEFAULT 0;
    DECLARE v_tenant_type VARCHAR(64);

    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.TABLES
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table;

    IF v_table_exists = 0 THEN
        -- 表不存在则跳过（后续 CREATE TABLE IF NOT EXISTS 会补建）
        BEGIN END;
    ELSE

    SELECT COUNT(*) INTO v_has_create_by
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table AND COLUMN_NAME = 'create_by';

    SELECT COUNT(*) INTO v_has_creator
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table AND COLUMN_NAME = 'creator';

    SELECT COUNT(*) INTO v_has_create_dept
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table AND COLUMN_NAME = 'create_dept';

    SELECT DATA_TYPE INTO v_tenant_type
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table AND COLUMN_NAME = 'tenant_id'
    LIMIT 1;

    IF v_has_create_by > 0 AND v_has_creator = 0 THEN
        SET @sql = CONCAT('ALTER TABLE `', p_table, '` CHANGE COLUMN `create_by` `creator` varchar(64) DEFAULT '''' COMMENT ''创建者''');
        PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
    END IF;

    SELECT COUNT(*) INTO v_has_creator
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table AND COLUMN_NAME = 'creator';

    IF v_has_creator = 0 THEN
        SET @sql = CONCAT('ALTER TABLE `', p_table, '` ADD COLUMN `creator` varchar(64) DEFAULT '''' COMMENT ''创建者''');
        PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
    END IF;

    IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table AND COLUMN_NAME = 'update_by') > 0
       AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table AND COLUMN_NAME = 'updater') = 0 THEN
        SET @sql = CONCAT('ALTER TABLE `', p_table, '` CHANGE COLUMN `update_by` `updater` varchar(64) DEFAULT '''' COMMENT ''更新者''');
        PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
    END IF;

    IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table AND COLUMN_NAME = 'updater') = 0 THEN
        SET @sql = CONCAT('ALTER TABLE `', p_table, '` ADD COLUMN `updater` varchar(64) DEFAULT '''' COMMENT ''更新者''');
        PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
    END IF;

    IF v_has_create_dept > 0 THEN
        SET @sql = CONCAT('ALTER TABLE `', p_table, '` DROP COLUMN `create_dept`');
        PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
    END IF;

    IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table AND COLUMN_NAME = 'create_time') = 0 THEN
        SET @sql = CONCAT('ALTER TABLE `', p_table, '` ADD COLUMN `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT ''创建时间''');
        PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
    END IF;

    IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table AND COLUMN_NAME = 'update_time') = 0 THEN
        SET @sql = CONCAT('ALTER TABLE `', p_table, '` ADD COLUMN `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT ''更新时间''');
        PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
    END IF;

    IF (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table AND COLUMN_NAME = 'deleted') = 0 THEN
        SET @sql = CONCAT('ALTER TABLE `', p_table, '` ADD COLUMN `deleted` bit(1) NOT NULL DEFAULT b''0'' COMMENT ''是否删除''');
        PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
    END IF;

    IF v_tenant_type = 'varchar' THEN
        SET @sql = CONCAT(
            'UPDATE `', p_table, '` SET `tenant_id` = CASE ',
            'WHEN `tenant_id` IN (''000000'', '''') OR `tenant_id` IS NULL THEN 0 ',
            'ELSE CAST(`tenant_id` AS UNSIGNED) END ',
            'WHERE `id` > 0'
        );
        PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
        SET @sql = CONCAT('ALTER TABLE `', p_table, '` MODIFY COLUMN `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT ''租户编号''');
        PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
    END IF;

    END IF;
END$$

DROP PROCEDURE IF EXISTS `migration_add_column_if_missing`$$
CREATE PROCEDURE `migration_add_column_if_missing`(
    IN p_table VARCHAR(128), IN p_column VARCHAR(128), IN p_ddl TEXT)
BEGIN
    IF (SELECT COUNT(*) FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table) > 0
       AND (SELECT COUNT(*) FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table AND COLUMN_NAME = p_column) = 0 THEN
        SET @sql = CONCAT('ALTER TABLE `', p_table, '` ADD COLUMN ', p_ddl);
        PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
    END IF;
END$$

DELIMITER ;

-- ========== WMS 主表 ==========
CALL migration_fix_audit_columns('wms_zone');
CALL migration_fix_audit_columns('wms_location');
CALL migration_fix_audit_columns('wms_inventory');
CALL migration_fix_audit_columns('wms_pallet');
CALL migration_fix_audit_columns('wms_pallet_item');
CALL migration_fix_audit_columns('wms_inventory_lock');
CALL migration_fix_audit_columns('wms_inventory_transaction');
CALL migration_fix_audit_columns('wms_devanning_order');
CALL migration_fix_audit_columns('wms_devanning_order_trace');

-- ========== YMS 主表 ==========
CALL migration_fix_audit_columns('yms_container_resource');
CALL migration_fix_audit_columns('yms_trailer_resource');
CALL migration_fix_audit_columns('yms_yard_position');
CALL migration_fix_audit_columns('yms_internal_task');
CALL migration_fix_audit_columns('yms_appointment_rule');
CALL migration_fix_audit_columns('yms_call_rule');
CALL migration_fix_audit_columns('yms_yard_task');
CALL migration_fix_audit_columns('yms_appointment');
CALL migration_fix_audit_columns('yms_check_in');
CALL migration_fix_audit_columns('yms_yard_zone');
CALL migration_fix_audit_columns('yms_blacklist');
CALL migration_fix_audit_columns('yms_slot_template');
CALL migration_fix_audit_columns('yms_yardgo_task');
CALL migration_fix_audit_columns('yms_call_rule_condition');
CALL migration_fix_audit_columns('yms_call_rule_sort');

-- ========== 缺失表（先建表，再修正审计字段） ==========
CREATE TABLE IF NOT EXISTS `yms_dock_queue` (
    `id` bigint NOT NULL COMMENT '主键',
    `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户',
    `dock_id` bigint NOT NULL COMMENT 'Dock ID',
    `yard_task_id` bigint NOT NULL COMMENT '园区任务ID',
    `container_no` varchar(64) DEFAULT NULL COMMENT '柜号/来源单号（快照）',
    `queue_no` int NOT NULL COMMENT '排队序号',
    `queue_status` varchar(30) NOT NULL DEFAULT 'WAITING' COMMENT 'WAITING/ENTERED/CANCELLED',
    `queued_time` datetime DEFAULT NULL COMMENT '加入排队时间',
    `enter_dock_time` datetime DEFAULT NULL COMMENT '进入Dock时间',
    `cancel_time` datetime DEFAULT NULL COMMENT '取消时间',
    `create_time` datetime DEFAULT NULL,
    `update_time` datetime DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_dock_status` (`dock_id`,`queue_status`),
    KEY `idx_yard_task` (`yard_task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Dock排队表';

CREATE TABLE IF NOT EXISTS `yms_yard_inventory_task` (
    `id` bigint NOT NULL COMMENT '主键',
    `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
    `warehouse_id` bigint NOT NULL COMMENT '仓库ID',
    `inventory_no` varchar(64) NOT NULL COMMENT '盘点任务号',
    `inventory_type` varchar(30) NOT NULL COMMENT 'ZONE/FULL/CONTAINER_LIST',
    `zone_id` bigint DEFAULT NULL COMMENT '盘点区域ID',
    `zone_code` varchar(50) DEFAULT NULL COMMENT '区域编码快照',
    `expected_count` int NOT NULL DEFAULT 0 COMMENT '应盘数量',
    `actual_count` int NOT NULL DEFAULT 0 COMMENT '实盘数量',
    `diff_count` int NOT NULL DEFAULT 0 COMMENT '差异数量',
    `status` varchar(20) NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING/IN_PROGRESS/COMPLETED/DIFF_FOUND',
    `start_time` datetime DEFAULT NULL,
    `finish_time` datetime DEFAULT NULL,
    `operator_id` bigint DEFAULT NULL,
    `operator_name` varchar(50) DEFAULT NULL,
    `remark` varchar(500) DEFAULT NULL,
    `creator` varchar(64) DEFAULT '' COMMENT '创建者',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater` varchar(64) DEFAULT '' COMMENT '更新者',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_inventory_no` (`inventory_no`),
    KEY `idx_warehouse_status` (`warehouse_id`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='YMS园区盘点任务';

CREATE TABLE IF NOT EXISTS `yms_yard_inventory_item` (
    `id` bigint NOT NULL COMMENT '主键',
    `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
    `inventory_id` bigint NOT NULL COMMENT '盘点任务ID',
    `object_type` varchar(20) NOT NULL COMMENT 'CONTAINER/TRAILER',
    `object_no` varchar(64) NOT NULL COMMENT '柜号/车厢号',
    `system_position_id` bigint DEFAULT NULL COMMENT '系统位置ID',
    `system_position_code` varchar(50) DEFAULT NULL COMMENT '系统位置编码',
    `actual_position_id` bigint DEFAULT NULL COMMENT '实盘位置ID',
    `actual_position_code` varchar(50) DEFAULT NULL COMMENT '实盘位置编码',
    `scan_status` varchar(20) NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING/SCANNED/MISSING/EXTRA',
    `diff_type` varchar(30) DEFAULT NULL COMMENT 'MISSING/EXTRA/POSITION_MISMATCH/STATUS_MISMATCH',
    `photo_urls` text COMMENT '照片JSON',
    `remark` varchar(500) DEFAULT NULL,
    `scan_time` datetime DEFAULT NULL,
    `creator` varchar(64) DEFAULT '' COMMENT '创建者',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater` varchar(64) DEFAULT '' COMMENT '更新者',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
    PRIMARY KEY (`id`),
    KEY `idx_inventory_id` (`inventory_id`),
    KEY `idx_object_no` (`object_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='YMS园区盘点明细';

CALL migration_fix_audit_columns('yms_yard_inventory_task');
CALL migration_fix_audit_columns('yms_yard_inventory_item');

-- ========== OMS 变更日志表 ==========
CALL migration_fix_audit_columns('wms_inbound_plan_change_log');

-- ========== yms_yard_task 业务字段补全 ==========
CALL migration_add_column_if_missing('yms_yard_task', 'container_resource_id',
    '`container_resource_id` bigint DEFAULT NULL COMMENT ''海柜资源ID'' AFTER `container_no`');
CALL migration_add_column_if_missing('yms_yard_task', 'trailer_resource_id',
    '`trailer_resource_id` bigint DEFAULT NULL COMMENT ''车厢资源ID'' AFTER `container_resource_id`');
CALL migration_add_column_if_missing('yms_yard_task', 'wms_ready_status',
    '`wms_ready_status` varchar(30) NOT NULL DEFAULT ''NOT_REQUIRED'' COMMENT ''WMS备货状态'' AFTER `trailer_resource_id`');
CALL migration_add_column_if_missing('yms_yard_task', 'wms_ready_time',
    '`wms_ready_time` datetime DEFAULT NULL COMMENT ''WMS备货完成时间'' AFTER `wms_ready_status`');
CALL migration_add_column_if_missing('yms_yard_task', 'appointment_id',
    '`appointment_id` bigint DEFAULT NULL COMMENT ''预约ID'' AFTER `wms_ready_time`');
CALL migration_add_column_if_missing('yms_yard_task', 'dock_assign_time',
    '`dock_assign_time` datetime DEFAULT NULL COMMENT ''Dock分配时间'' AFTER `appointment_id`');
CALL migration_add_column_if_missing('yms_yard_task', 'call_time',
    '`call_time` datetime DEFAULT NULL COMMENT ''叫号时间'' AFTER `dock_assign_time`');
CALL migration_add_column_if_missing('yms_yard_task', 'priority',
    '`priority` int NOT NULL DEFAULT 5 COMMENT ''优先级'' AFTER `call_time`');
CALL migration_add_column_if_missing('yms_yard_task', 'driver_license_no',
    '`driver_license_no` varchar(50) DEFAULT NULL COMMENT ''司机驾照号码'' AFTER `driver_phone`');

DROP PROCEDURE IF EXISTS `migration_fix_audit_columns`;
DROP PROCEDURE IF EXISTS `migration_add_column_if_missing`;

SET SESSION sql_safe_updates = @OLD_SQL_SAFE_UPDATES;
