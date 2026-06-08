-- =============================================
-- YMS Phase 2 批量补丁
-- 日期：2026-05-29
-- 说明：Check-in 照片/小票、园区盘点、新菜单
-- =============================================

DELIMITER //
DROP PROCEDURE IF EXISTS yms_add_column_if_missing//
CREATE PROCEDURE yms_add_column_if_missing(IN tbl VARCHAR(64), IN col VARCHAR(64), IN ddl TEXT)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = tbl AND COLUMN_NAME = col
    ) THEN
        SET @s = CONCAT('ALTER TABLE `', tbl, '` ADD COLUMN ', ddl);
        PREPARE stmt FROM @s;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END//
DELIMITER ;

-- Check-in 照片与小票号
CALL yms_add_column_if_missing('yms_check_in', 'photo_urls',
    '`photo_urls` TEXT DEFAULT NULL COMMENT ''现场照片URL（JSON数组）'' AFTER `remark`');
CALL yms_add_column_if_missing('yms_check_in', 'receipt_no',
    '`receipt_no` VARCHAR(32) DEFAULT NULL COMMENT ''入场小票号'' AFTER `photo_urls`');

-- =============================================
-- 园区盘点任务
-- =============================================
CREATE TABLE IF NOT EXISTS `yms_yard_inventory_task` (
    `id`                BIGINT          NOT NULL                    COMMENT '主键',
    `tenant_id`         VARCHAR(20)     NOT NULL DEFAULT '000000'   COMMENT '租户ID',
    `warehouse_id`      BIGINT          NOT NULL                    COMMENT '仓库ID',
    `inventory_no`      VARCHAR(64)     NOT NULL                    COMMENT '盘点任务号',
    `inventory_type`    VARCHAR(30)     NOT NULL                    COMMENT 'ZONE/FULL/CONTAINER_LIST',
    `zone_id`           BIGINT          DEFAULT NULL                COMMENT '盘点区域ID',
    `zone_code`         VARCHAR(50)     DEFAULT NULL                COMMENT '区域编码快照',
    `expected_count`    INT             NOT NULL DEFAULT 0          COMMENT '应盘数量',
    `actual_count`      INT             NOT NULL DEFAULT 0          COMMENT '实盘数量',
    `diff_count`        INT             NOT NULL DEFAULT 0          COMMENT '差异数量',
    `status`            VARCHAR(20)     NOT NULL DEFAULT 'PENDING'  COMMENT 'PENDING/IN_PROGRESS/COMPLETED/DIFF_FOUND',
    `start_time`        DATETIME        DEFAULT NULL,
    `finish_time`       DATETIME        DEFAULT NULL,
    `operator_id`       BIGINT          DEFAULT NULL,
    `operator_name`     VARCHAR(50)     DEFAULT NULL,
    `remark`            VARCHAR(500)    DEFAULT NULL,
    `create_dept`       BIGINT          DEFAULT NULL,
    `create_by`         BIGINT          DEFAULT NULL,
    `create_time`       DATETIME        DEFAULT NULL,
    `update_by`         BIGINT          DEFAULT NULL,
    `update_time`       DATETIME        DEFAULT NULL,
    `deleted`           TINYINT(1)      NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_inventory_no` (`inventory_no`),
    KEY `idx_warehouse_status` (`warehouse_id`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='YMS园区盘点任务';

CREATE TABLE IF NOT EXISTS `yms_yard_inventory_item` (
    `id`                BIGINT          NOT NULL                    COMMENT '主键',
    `tenant_id`         VARCHAR(20)     NOT NULL DEFAULT '000000'   COMMENT '租户ID',
    `inventory_id`      BIGINT          NOT NULL                    COMMENT '盘点任务ID',
    `object_type`       VARCHAR(20)     NOT NULL                    COMMENT 'CONTAINER/TRAILER',
    `object_no`         VARCHAR(64)     NOT NULL                    COMMENT '柜号/车厢号',
    `system_position_id` BIGINT         DEFAULT NULL                COMMENT '系统位置ID',
    `system_position_code` VARCHAR(50)  DEFAULT NULL                COMMENT '系统位置编码',
    `actual_position_id` BIGINT         DEFAULT NULL                COMMENT '实盘位置ID',
    `actual_position_code` VARCHAR(50)  DEFAULT NULL                COMMENT '实盘位置编码',
    `scan_status`       VARCHAR(20)     NOT NULL DEFAULT 'PENDING'  COMMENT 'PENDING/SCANNED/MISSING/EXTRA',
    `diff_type`         VARCHAR(30)     DEFAULT NULL                COMMENT 'MISSING/EXTRA/POSITION_MISMATCH/STATUS_MISMATCH',
    `photo_urls`        TEXT            DEFAULT NULL                COMMENT '照片JSON',
    `remark`            VARCHAR(500)    DEFAULT NULL,
    `scan_time`         DATETIME        DEFAULT NULL,
    `create_time`       DATETIME        DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_inventory_id` (`inventory_id`),
    KEY `idx_object_no` (`object_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='YMS园区盘点明细';

-- =============================================
-- 菜单（父菜单 5000）
-- =============================================
INSERT IGNORE INTO sys_menu VALUES(5090, '预约规则', 5000, 11, 'appointment-rule', 'yms/appointment-rule/index', '', 1, 0, 'C', '0', '0', 'yms:appointmentRule:list', 'setting', 103, 1, NOW(), NULL, NULL, 'YMS预约规则配置');
INSERT IGNORE INTO sys_menu VALUES(5091, '预约规则查询', 5090, 1, '#', '', '', 1, 0, 'F', '0', '0', 'yms:appointmentRule:query', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5092, '预约规则新增', 5090, 2, '#', '', '', 1, 0, 'F', '0', '0', 'yms:appointmentRule:add', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5093, '预约规则编辑', 5090, 3, '#', '', '', 1, 0, 'F', '0', '0', 'yms:appointmentRule:edit', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5094, '预约规则删除', 5090, 4, '#', '', '', 1, 0, 'F', '0', '0', 'yms:appointmentRule:remove', '#', 103, 1, NOW(), NULL, NULL, '');

INSERT IGNORE INTO sys_menu VALUES(5100, '预约看板', 5000, 12, 'appointment-board', 'yms/appointment-board/index', '', 1, 0, 'C', '0', '0', 'yms:appointment:list', 'calendar', 103, 1, NOW(), NULL, NULL, '预约日历时段看板');

INSERT IGNORE INTO sys_menu VALUES(5110, '叫号规则', 5000, 62, 'call-rule', 'yms/call-rule/index', '', 1, 0, 'C', '0', '0', 'yms:callRule:list', 'phone', 103, 1, NOW(), NULL, NULL, 'YMS叫号规则配置');
INSERT IGNORE INTO sys_menu VALUES(5111, '叫号规则查询', 5110, 1, '#', '', '', 1, 0, 'F', '0', '0', 'yms:callRule:query', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5112, '叫号规则新增', 5110, 2, '#', '', '', 1, 0, 'F', '0', '0', 'yms:callRule:add', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5113, '叫号规则编辑', 5110, 3, '#', '', '', 1, 0, 'F', '0', '0', 'yms:callRule:edit', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5114, '叫号规则删除', 5110, 4, '#', '', '', 1, 0, 'F', '0', '0', 'yms:callRule:remove', '#', 103, 1, NOW(), NULL, NULL, '');

INSERT IGNORE INTO sys_menu VALUES(5120, '等待池', 5000, 63, 'waiting-pool', 'yms/waiting-pool/index', '', 1, 0, 'C', '0', '0', 'yms:waitingPool:view', 'hourglass', 103, 1, NOW(), NULL, NULL, '园区等待池');
INSERT IGNORE INTO sys_menu VALUES(5121, '等待池查看', 5120, 1, '#', '', '', 1, 0, 'F', '0', '0', 'yms:waitingPool:view', '#', 103, 1, NOW(), NULL, NULL, '');

INSERT IGNORE INTO sys_menu VALUES(5130, '异常中心', 5000, 64, 'exception-center', 'yms/exception-center/index', '', 1, 0, 'C', '0', '0', 'yms:exception:list', 'warning', 103, 1, NOW(), NULL, NULL, '园区异常中心');
INSERT IGNORE INTO sys_menu VALUES(5131, '异常查询', 5130, 1, '#', '', '', 1, 0, 'F', '0', '0', 'yms:exception:list', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5132, '异常处理', 5130, 2, '#', '', '', 1, 0, 'F', '0', '0', 'yms:exception:handle', '#', 103, 1, NOW(), NULL, NULL, '');

INSERT IGNORE INTO sys_menu VALUES(5140, '园区盘点', 5000, 74, 'yard-inventory', 'yms/yard-inventory/index', '', 1, 0, 'C', '0', '0', 'yms:inventory:list', 'audit', 103, 1, NOW(), NULL, NULL, 'YMS园区盘点');
INSERT IGNORE INTO sys_menu VALUES(5141, '盘点查询', 5140, 1, '#', '', '', 1, 0, 'F', '0', '0', 'yms:inventory:query', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5142, '盘点创建', 5140, 2, '#', '', '', 1, 0, 'F', '0', '0', 'yms:inventory:add', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5143, '盘点执行', 5140, 3, '#', '', '', 1, 0, 'F', '0', '0', 'yms:inventory:execute', '#', 103, 1, NOW(), NULL, NULL, '');

INSERT IGNORE INTO sys_menu VALUES(5150, '堆场地图', 5000, 75, 'yard-map', 'yms/yard-map/index', '', 1, 0, 'C', '0', '0', 'yms:yardMap:view', 'map', 103, 1, NOW(), NULL, NULL, 'YMS堆场地图');
INSERT IGNORE INTO sys_menu VALUES(5151, '堆场地图查看', 5150, 1, '#', '', '', 1, 0, 'F', '0', '0', 'yms:yardMap:view', '#', 103, 1, NOW(), NULL, NULL, '');

-- =============================================
-- 园区盘点字典
-- =============================================
INSERT IGNORE INTO sys_dict_type (tenant_id, dict_name, dict_type, create_dept, create_by, create_time, remark) VALUES
('000000', '园区盘点类型', 'yms_inventory_type', 103, 1, NOW(), 'YMS园区盘点类型');

INSERT IGNORE INTO sys_dict_data (tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_dept, create_by, create_time, remark) VALUES
('000000', 1, '分区盘点', 'ZONE',           'yms_inventory_type', '', 'info',    'N', 103, 1, NOW(), ''),
('000000', 2, '全库盘点', 'FULL',           'yms_inventory_type', '', 'primary', 'N', 103, 1, NOW(), ''),
('000000', 3, '指定列表', 'CONTAINER_LIST', 'yms_inventory_type', '', 'default', 'N', 103, 1, NOW(), '');

INSERT IGNORE INTO sys_dict_type (tenant_id, dict_name, dict_type, create_dept, create_by, create_time, remark) VALUES
('000000', '园区盘点状态', 'yms_inventory_status', 103, 1, NOW(), 'YMS园区盘点任务状态');

INSERT IGNORE INTO sys_dict_data (tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_dept, create_by, create_time, remark) VALUES
('000000', 1, '待开始', 'PENDING',     'yms_inventory_status', '', 'default', 'N', 103, 1, NOW(), ''),
('000000', 2, '盘点中', 'IN_PROGRESS', 'yms_inventory_status', '', 'info',    'N', 103, 1, NOW(), ''),
('000000', 3, '已完成', 'COMPLETED',   'yms_inventory_status', '', 'success', 'N', 103, 1, NOW(), ''),
('000000', 4, '有差异', 'DIFF_FOUND',  'yms_inventory_status', '', 'warning', 'N', 103, 1, NOW(), '');

INSERT IGNORE INTO sys_dict_type (tenant_id, dict_name, dict_type, create_dept, create_by, create_time, remark) VALUES
('000000', '盘点扫码状态', 'yms_inventory_scan_status', 103, 1, NOW(), 'YMS盘点明细扫码状态');

INSERT IGNORE INTO sys_dict_data (tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_dept, create_by, create_time, remark) VALUES
('000000', 1, '待扫', 'PENDING', 'yms_inventory_scan_status', '', 'default', 'N', 103, 1, NOW(), ''),
('000000', 2, '已扫', 'SCANNED', 'yms_inventory_scan_status', '', 'success', 'N', 103, 1, NOW(), ''),
('000000', 3, '缺失', 'MISSING', 'yms_inventory_scan_status', '', 'error',   'N', 103, 1, NOW(), ''),
('000000', 4, '多余', 'EXTRA',   'yms_inventory_scan_status', '', 'warning', 'N', 103, 1, NOW(), '');

INSERT IGNORE INTO sys_dict_type (tenant_id, dict_name, dict_type, create_dept, create_by, create_time, remark) VALUES
('000000', '盘点差异类型', 'yms_inventory_diff_type', 103, 1, NOW(), 'YMS盘点差异类型');

INSERT IGNORE INTO sys_dict_data (tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_dept, create_by, create_time, remark) VALUES
('000000', 1, '缺失', 'MISSING',            'yms_inventory_diff_type', '', 'error',   'N', 103, 1, NOW(), ''),
('000000', 2, '多余', 'EXTRA',              'yms_inventory_diff_type', '', 'warning', 'N', 103, 1, NOW(), ''),
('000000', 3, '位置不符', 'POSITION_MISMATCH', 'yms_inventory_diff_type', '', 'warning', 'N', 103, 1, NOW(), ''),
('000000', 4, '状态不符', 'STATUS_MISMATCH',   'yms_inventory_diff_type', '', 'warning', 'N', 103, 1, NOW(), '');
-- DEPRECATED for YMS Phase 1 simplified scope.
-- This script contains appointment/call-rule menu records that were removed from Phase 1.
-- Use yms_phase1_cleanup_20260530.sql and yms_phase1_final_sync_20260530.sql instead.
