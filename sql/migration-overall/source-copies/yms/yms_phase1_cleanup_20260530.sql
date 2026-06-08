-- =============================================
-- YMS Phase 1 简化清理脚本
-- 日期：2026-05-30
-- 说明：删除 Phase 1 不需要的菜单、表，新增 yms_check_in 字段，新增统一 Check-in 菜单
-- 执行顺序：PART1 菜单 → PART2 删表 → PART3 改表 → PART4 新菜单
-- =============================================

SET SQL_SAFE_UPDATES = 0;

-- =============================================
-- PART 1：菜单清理
-- =============================================

-- ── Step 1：删除二级分组目录（5191-5198 全部删除）─────────────────────
-- 5191 监控总览 / 5192 调度作业 / 5193 门岗出入 / 5194 预约管理
-- 5195 堆场资源 / 5196 场内作业 / 5197 规则风控 / 5198 异常盘点
DELETE FROM sys_role_menu WHERE menu_id IN (5191,5192,5193,5194,5195,5196,5197,5198);
DELETE FROM sys_menu        WHERE menu_id IN (5191,5192,5193,5194,5195,5196,5197,5198);

-- ── Step 2：保留的菜单移回 5000 并重排序号 ────────────────────────────
UPDATE sys_menu SET parent_id = 5000, order_num =  1, visible = '0' WHERE menu_id = 5080;  -- 园区总览
UPDATE sys_menu SET parent_id = 5000, order_num =  2, visible = '0' WHERE menu_id = 5001;  -- 园区调度
UPDATE sys_menu SET parent_id = 5000, order_num =  3, visible = '0' WHERE menu_id = 5004;  -- 任务管理
UPDATE sys_menu SET parent_id = 5000, order_num =  4, visible = '0' WHERE menu_id = 5005;  -- 拆柜调度
UPDATE sys_menu SET parent_id = 5000, order_num =  5, visible = '0' WHERE menu_id = 5006;  -- 装车调度
UPDATE sys_menu SET parent_id = 5000, order_num =  8, visible = '0' WHERE menu_id = 5076;  -- 在场列表
UPDATE sys_menu SET parent_id = 5000, order_num =  9, visible = '0' WHERE menu_id = 5078;  -- Check-out
UPDATE sys_menu SET parent_id = 5000, order_num = 10, visible = '0' WHERE menu_id = 5040;  -- 海柜资源
UPDATE sys_menu SET parent_id = 5000, order_num = 11, visible = '0' WHERE menu_id = 5050;  -- 车厢资源
UPDATE sys_menu SET parent_id = 5000, order_num = 12, visible = '0' WHERE menu_id = 5030;  -- 堆场位
UPDATE sys_menu SET parent_id = 5000, order_num = 13, visible = '0' WHERE menu_id = 5060;  -- 院内任务
UPDATE sys_menu SET parent_id = 5000, order_num = 14, visible = '0' WHERE menu_id = 5140;  -- 园区盘点

-- 调度隐藏页也移回 5000
UPDATE sys_menu SET parent_id = 5000 WHERE menu_id IN (5002, 5003);

-- ── Step 3：删除叫号规则菜单（5110-5115）─────────────────────────────
DELETE FROM sys_role_menu WHERE menu_id IN (5110,5111,5112,5113,5114,5115);
DELETE FROM sys_menu        WHERE menu_id IN (5110,5111,5112,5113,5114,5115);

-- ── Step 4：删除预约规则菜单（5090-5094）─────────────────────────────
DELETE FROM sys_role_menu WHERE menu_id IN (5090,5091,5092,5093,5094);
DELETE FROM sys_menu        WHERE menu_id IN (5090,5091,5092,5093,5094);

-- ── Step 5：删除预约看板菜单（5100）──────────────────────────────────
DELETE FROM sys_role_menu WHERE menu_id = 5100;
DELETE FROM sys_menu        WHERE menu_id = 5100;

-- ── Step 6：删除等待池菜单（5120,5121）───────────────────────────────
DELETE FROM sys_role_menu WHERE menu_id IN (5120,5121);
DELETE FROM sys_menu        WHERE menu_id IN (5120,5121);

-- ── Step 7：删除异常中心菜单（5130,5131,5132）────────────────────────
DELETE FROM sys_role_menu WHERE menu_id IN (5130,5131,5132);
DELETE FROM sys_menu        WHERE menu_id IN (5130,5131,5132);

-- ── Step 8：删除堆场地图菜单（5150,5151）─────────────────────────────
DELETE FROM sys_role_menu WHERE menu_id IN (5150,5151);
DELETE FROM sys_menu        WHERE menu_id IN (5150,5151);

-- ── Step 9：删除拆分 Check-in 菜单（5070-5075，合并为统一页面后删除）──
DELETE FROM sys_role_menu WHERE menu_id IN (5070,5071,5072,5073,5074,5075);
DELETE FROM sys_menu        WHERE menu_id IN (5070,5071,5072,5073,5074,5075);

-- ── Step 10：通过 component 删除预约列表 / 时段模板 / YardGo / 黑名单 ──
-- （这些菜单在 m1_m7_migration 中创建，ID 不在固定区间内，用 component 定位）

-- 预约管理列表 yms/appointment/index（先删子菜单，再删父菜单）
DELETE FROM sys_role_menu WHERE menu_id IN (
    SELECT menu_id FROM (
        SELECT child.menu_id FROM sys_menu child
        INNER JOIN sys_menu parent ON child.parent_id = parent.menu_id
        WHERE parent.component = 'yms/appointment/index'
        UNION ALL
        SELECT menu_id FROM sys_menu WHERE component = 'yms/appointment/index'
    ) _apt
);
DELETE FROM sys_menu WHERE menu_id IN (
    SELECT menu_id FROM (
        SELECT child.menu_id FROM sys_menu child
        INNER JOIN sys_menu parent ON child.parent_id = parent.menu_id
        WHERE parent.component = 'yms/appointment/index'
        UNION ALL
        SELECT menu_id FROM sys_menu WHERE component = 'yms/appointment/index'
    ) _apt2
);

-- 时段模板 yms/slot-template/index
DELETE FROM sys_role_menu WHERE menu_id IN (
    SELECT menu_id FROM (
        SELECT child.menu_id FROM sys_menu child
        INNER JOIN sys_menu parent ON child.parent_id = parent.menu_id
        WHERE parent.component = 'yms/slot-template/index'
        UNION ALL
        SELECT menu_id FROM sys_menu WHERE component = 'yms/slot-template/index'
    ) _slot
);
DELETE FROM sys_menu WHERE menu_id IN (
    SELECT menu_id FROM (
        SELECT child.menu_id FROM sys_menu child
        INNER JOIN sys_menu parent ON child.parent_id = parent.menu_id
        WHERE parent.component = 'yms/slot-template/index'
        UNION ALL
        SELECT menu_id FROM sys_menu WHERE component = 'yms/slot-template/index'
    ) _slot2
);

-- YardGo yms/yardgo/index
DELETE FROM sys_role_menu WHERE menu_id IN (
    SELECT menu_id FROM (
        SELECT child.menu_id FROM sys_menu child
        INNER JOIN sys_menu parent ON child.parent_id = parent.menu_id
        WHERE parent.component = 'yms/yardgo/index'
        UNION ALL
        SELECT menu_id FROM sys_menu WHERE component = 'yms/yardgo/index'
    ) _yardgo
);
DELETE FROM sys_menu WHERE menu_id IN (
    SELECT menu_id FROM (
        SELECT child.menu_id FROM sys_menu child
        INNER JOIN sys_menu parent ON child.parent_id = parent.menu_id
        WHERE parent.component = 'yms/yardgo/index'
        UNION ALL
        SELECT menu_id FROM sys_menu WHERE component = 'yms/yardgo/index'
    ) _yardgo2
);

-- 黑名单 yms/blacklist/index
DELETE FROM sys_role_menu WHERE menu_id IN (
    SELECT menu_id FROM (
        SELECT child.menu_id FROM sys_menu child
        INNER JOIN sys_menu parent ON child.parent_id = parent.menu_id
        WHERE parent.component = 'yms/blacklist/index'
        UNION ALL
        SELECT menu_id FROM sys_menu WHERE component = 'yms/blacklist/index'
    ) _bl
);
DELETE FROM sys_menu WHERE menu_id IN (
    SELECT menu_id FROM (
        SELECT child.menu_id FROM sys_menu child
        INNER JOIN sys_menu parent ON child.parent_id = parent.menu_id
        WHERE parent.component = 'yms/blacklist/index'
        UNION ALL
        SELECT menu_id FROM sys_menu WHERE component = 'yms/blacklist/index'
    ) _bl2
);

-- ── Step 11：旧版 gate/index 隐藏页标记为不可见 ──────────────────────
UPDATE sys_menu SET visible = '1' WHERE component = 'yms/gate/index';

-- ── Step 12：zone 和 dock 菜单移回 5000（原来被移到 5195 堆场资源下）──
UPDATE sys_menu SET parent_id = 5000, order_num = 15, visible = '0'
WHERE component IN ('yms/zone/index', 'yms/dock/index');

-- =============================================
-- PART 2：删除数据库表
-- =============================================

DROP TABLE IF EXISTS `yms_appointment`;
DROP TABLE IF EXISTS `yms_appointment_rule`;
DROP TABLE IF EXISTS `yms_appointment_rule_slot`;
DROP TABLE IF EXISTS `yms_call_rule`;
DROP TABLE IF EXISTS `yms_call_rule_condition`;
DROP TABLE IF EXISTS `yms_call_rule_sort`;
DROP TABLE IF EXISTS `yms_call_record`;
DROP TABLE IF EXISTS `yms_blacklist`;
DROP TABLE IF EXISTS `yms_slot_template`;
DROP TABLE IF EXISTS `yms_yardgo_task`;

-- =============================================
-- PART 3：修改 yms_check_in，支持双通道 Check-in
-- =============================================

DROP PROCEDURE IF EXISTS yms_p1_add_col;
DELIMITER //
CREATE PROCEDURE yms_p1_add_col(IN p_table VARCHAR(64), IN p_col VARCHAR(64), IN p_def TEXT)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table AND COLUMN_NAME = p_col
    ) THEN
        SET @s = CONCAT('ALTER TABLE `', p_table, '` ADD COLUMN `', p_col, '` ', p_def);
        PREPARE stmt FROM @s;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END//
DELIMITER ;

-- 登记来源：GATE=门岗操作 / DRIVER_SELF=司机自助 H5
CALL yms_p1_add_col('yms_check_in', 'checkin_source',
    "VARCHAR(20) NOT NULL DEFAULT 'GATE' COMMENT '登记来源 GATE/DRIVER_SELF' AFTER `check_in_type`");

-- 停车位（门岗分配 或 司机自报）
CALL yms_p1_add_col('yms_check_in', 'position_id',
    'BIGINT DEFAULT NULL COMMENT ''停车位ID''');
CALL yms_p1_add_col('yms_check_in', 'position_code',
    "VARCHAR(50) DEFAULT NULL COMMENT '停车位编码'");

-- OMS 数据比对结果
CALL yms_p1_add_col('yms_check_in', 'oms_mismatch_flag',
    "TINYINT(1) NOT NULL DEFAULT 0 COMMENT '与OMS数据不符标记'");
CALL yms_p1_add_col('yms_check_in', 'oms_mismatch_fields',
    "VARCHAR(500) DEFAULT NULL COMMENT '不符字段列表 JSON数组，如[\"plate_no\",\"driver_name\"]'");

DROP PROCEDURE IF EXISTS yms_p1_add_col;

-- =============================================
-- PART 4：新增统一 Check-in 菜单 & 司机签到码菜单
-- =============================================

-- 统一 Check-in 操作台（替代原拆分的海柜/装车两个入口，order_num=6/7 之间空出位置给它）
INSERT IGNORE INTO sys_menu VALUES(
    5068, '统一Check-in', 5000, 6,
    'gate/check-in', 'yms/gate-checkin/index',
    '', 1, 0, 'C', '0', '0', 'yms:gate:checkIn',
    'check-square', 103, 1, NOW(), NULL, NULL,
    '门岗统一 Check-in 操作台（海柜/装车/Walk-in 统一入口）'
);
INSERT IGNORE INTO sys_menu VALUES(5069, 'Check-in办理', 5068, 1, '#', '', '', 1, 0, 'F', '0', '0', 'yms:gate:checkIn', '#', 103, 1, NOW(), NULL, NULL, '');

-- 司机自助签到码管理（生成/打印仓库专属二维码）
INSERT IGNORE INTO sys_menu VALUES(
    5085, '司机签到码', 5000, 7,
    'gate/driver-qr', 'yms/gate-driver-qr/index',
    '', 1, 0, 'C', '0', '0', 'yms:gate:driverQr',
    'qrcode', 103, 1, NOW(), NULL, NULL,
    '司机自助签到二维码管理（每个仓库独立二维码）'
);
INSERT IGNORE INTO sys_menu VALUES(5086, '签到码查看', 5085, 1, '#', '', '', 1, 0, 'F', '0', '0', 'yms:gate:driverQr', '#', 103, 1, NOW(), NULL, NULL, '');

-- =============================================
-- PART 5：清理相关字典（删除预约/叫号/黑名单相关字典）
-- =============================================

-- 预约状态字典
DELETE FROM sys_dict_data WHERE dict_type IN (
    'yms_appointment_status',
    'yms_appointment_match_type',
    'yms_call_rule_sort_field',
    'yms_call_status',
    'yms_blacklist_type',
    'yms_blacklist_status'
);
DELETE FROM sys_dict_type WHERE dict_type IN (
    'yms_appointment_status',
    'yms_appointment_match_type',
    'yms_call_rule_sort_field',
    'yms_call_status',
    'yms_blacklist_type',
    'yms_blacklist_status'
);

-- =============================================
-- PART 6：Phase 1 状态口径收敛
-- 到仓状态统一使用 ARRIVED，不再区分 CONTAINER_ARRIVED / VEHICLE_ARRIVED。
-- =============================================

UPDATE yms_yard_task
SET yard_status = 'ARRIVED'
WHERE yard_status IN ('CONTAINER_ARRIVED', 'VEHICLE_ARRIVED');

UPDATE yms_yard_task_log
SET before_status = 'ARRIVED'
WHERE before_status IN ('CONTAINER_ARRIVED', 'VEHICLE_ARRIVED');

UPDATE yms_yard_task_log
SET after_status = 'ARRIVED'
WHERE after_status IN ('CONTAINER_ARRIVED', 'VEHICLE_ARRIVED');

DELETE FROM sys_dict_data
WHERE dict_type IN ('yms_devanning_status', 'yms_loading_status')
  AND dict_value IN ('CONTAINER_ARRIVED', 'VEHICLE_ARRIVED');

INSERT IGNORE INTO sys_dict_type
(`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `create_dept`, `create_by`, `create_time`, `remark`)
VALUES
(6000003501, '000000', 'YMS拆柜任务状态', 'yms_devanning_status', 103, 1, NOW(), 'YMS拆柜任务状态'),
(6000003502, '000000', 'YMS装车任务状态', 'yms_loading_status', 103, 1, NOW(), 'YMS装车任务状态');

INSERT IGNORE INTO sys_dict_data
(`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `create_dept`, `create_by`, `create_time`, `remark`)
VALUES
(6000003511, '000000', 3, '已到仓', 'ARRIVED', 'yms_devanning_status', '', 'info', 'N', 103, 1, NOW(), '统一到仓状态'),
(6000003512, '000000', 3, '已到仓', 'ARRIVED', 'yms_loading_status', '', 'info', 'N', 103, 1, NOW(), '统一到仓状态');

SET SQL_SAFE_UPDATES = 1;

-- =============================================
-- 验证查询（执行后可运行以下查询确认结果）
-- =============================================
-- SELECT menu_id, menu_name, parent_id, component FROM sys_menu WHERE menu_id BETWEEN 5000 AND 5199 ORDER BY menu_id;
-- SHOW TABLES LIKE 'yms_%';
-- DESC yms_check_in;
