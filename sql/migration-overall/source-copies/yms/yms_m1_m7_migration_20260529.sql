-- =============================================
-- YMS M1-M7 新增表结构迁移脚本
-- 日期：2026-05-29
-- 包含：堆场分区、黑名单（直接按车牌/电话）、时段模板、预约、门卫签到、YardGo机器人任务
-- 注：车队/司机/车辆无需预注册，车辆信息由预约或签到时采集
-- =============================================

-- =============================================
-- M7 堆场分区表
-- =============================================
CREATE TABLE `yms_yard_zone` (
    `id`            BIGINT          NOT NULL                    COMMENT '主键',
    `tenant_id`     VARCHAR(20)     NOT NULL DEFAULT '000000'   COMMENT '租户ID',
    `warehouse_id`  BIGINT          NOT NULL                    COMMENT '仓库ID',
    `zone_code`     VARCHAR(30)     NOT NULL                    COMMENT '分区编码',
    `zone_name`     VARCHAR(100)    NOT NULL                    COMMENT '分区名称',
    `zone_type`     VARCHAR(30)     NOT NULL DEFAULT 'CONTAINER' COMMENT '分区类型：CONTAINER/TRUCK/SELF_PICKUP/PARKING',
    `sort_order`    INT             DEFAULT NULL                COMMENT '排序',
    `remark`        VARCHAR(500)    DEFAULT NULL,
    `create_dept`   BIGINT          DEFAULT NULL,
    `create_by`     BIGINT          DEFAULT NULL,
    `create_time`   DATETIME        DEFAULT NULL,
    `update_by`     BIGINT          DEFAULT NULL,
    `update_time`   DATETIME        DEFAULT NULL,
    `deleted`       TINYINT(1)      NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_zone_code_tenant` (`zone_code`, `tenant_id`),
    KEY `idx_warehouse_id` (`warehouse_id`),
    KEY `idx_zone_type` (`zone_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='YMS堆场分区表';

-- =============================================
-- M6 黑名单表（直接按车牌/手机号拦截，不依赖预注册车辆/司机）
-- =============================================
CREATE TABLE `yms_blacklist` (
    `id`                BIGINT          NOT NULL                    COMMENT '主键',
    `tenant_id`         VARCHAR(20)     NOT NULL DEFAULT '000000'   COMMENT '租户ID',
    `target_type`       VARCHAR(20)     NOT NULL                    COMMENT '拦截类型：PLATE_NO车牌/DRIVER_PHONE司机电话',
    `target_value`      VARCHAR(100)    NOT NULL                    COMMENT '拦截值（车牌号或司机电话）',
    `reason`            VARCHAR(500)    NOT NULL                    COMMENT '加入原因',
    `blacklist_time`    DATETIME        DEFAULT NULL                COMMENT '加入时间',
    `expire_time`       DATETIME        DEFAULT NULL                COMMENT '过期时间（NULL=永久）',
    `status`            VARCHAR(20)     NOT NULL DEFAULT 'ACTIVE'   COMMENT '状态：ACTIVE/EXPIRED/REMOVED',
    `operator_id`       BIGINT          DEFAULT NULL                COMMENT '操作员ID',
    `operator_name`     VARCHAR(50)     DEFAULT NULL                COMMENT '操作员姓名（快照）',
    `remark`            VARCHAR(500)    DEFAULT NULL,
    `create_dept`       BIGINT          DEFAULT NULL,
    `create_by`         BIGINT          DEFAULT NULL,
    `create_time`       DATETIME        DEFAULT NULL,
    `update_by`         BIGINT          DEFAULT NULL,
    `update_time`       DATETIME        DEFAULT NULL,
    `deleted`           TINYINT(1)      NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_type_value` (`target_type`, `target_value`),
    KEY `idx_status` (`status`),
    KEY `idx_expire_time` (`expire_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='YMS黑名单（车牌/手机号直接拦截）';

-- =============================================
-- M1 时段模板表
-- =============================================
CREATE TABLE `yms_slot_template` (
    `id`            BIGINT          NOT NULL                    COMMENT '主键',
    `tenant_id`     VARCHAR(20)     NOT NULL DEFAULT '000000'   COMMENT '租户ID',
    `warehouse_id`  BIGINT          NOT NULL                    COMMENT '仓库ID',
    `weekdays`      VARCHAR(20)     NOT NULL                    COMMENT '适用星期（逗号分隔，1=周一...7=周日，如 1,2,3,4,5）',
    `slot_start`    VARCHAR(10)     NOT NULL                    COMMENT '开始时间（HH:mm）',
    `slot_end`      VARCHAR(10)     NOT NULL                    COMMENT '结束时间（HH:mm）',
    `capacity`      INT             NOT NULL DEFAULT 10         COMMENT '容量（该时段最大预约数）',
    `task_type`     VARCHAR(30)     NOT NULL DEFAULT 'ALL'      COMMENT '适用任务类型：DEVANNING/LOADING/ALL',
    `enabled`       TINYINT(1)      NOT NULL DEFAULT 1          COMMENT '是否启用(0否1是)',
    `remark`        VARCHAR(500)    DEFAULT NULL,
    `create_dept`   BIGINT          DEFAULT NULL,
    `create_by`     BIGINT          DEFAULT NULL,
    `create_time`   DATETIME        DEFAULT NULL,
    `update_by`     BIGINT          DEFAULT NULL,
    `update_time`   DATETIME        DEFAULT NULL,
    `deleted`       TINYINT(1)      NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_warehouse_enabled` (`warehouse_id`, `enabled`),
    KEY `idx_task_type` (`task_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='YMS预约时段模板';

-- =============================================
-- M1 预约表
-- =============================================
CREATE TABLE `yms_appointment` (
    `id`                BIGINT          NOT NULL                    COMMENT '主键',
    `tenant_id`         VARCHAR(20)     NOT NULL DEFAULT '000000'   COMMENT '租户ID',
    `apt_no`            VARCHAR(64)     NOT NULL                    COMMENT '预约编号（APT+日期+序号）',
    `warehouse_id`      BIGINT          NOT NULL                    COMMENT '仓库ID',
    `slot_template_id`  BIGINT          DEFAULT NULL                COMMENT '时段模板ID',
    `apt_date`          DATE            NOT NULL                    COMMENT '预约日期（yyyy-MM-dd）',
    `apt_slot`          VARCHAR(20)     NOT NULL                    COMMENT '时段（HH:mm-HH:mm）',
    `task_type`         VARCHAR(30)     NOT NULL                    COMMENT '任务类型：DEVANNING/LOADING',
    `plate_no`          VARCHAR(30)     NOT NULL                    COMMENT '车牌号',
    `driver_name`       VARCHAR(50)     DEFAULT NULL                COMMENT '司机姓名',
    `driver_phone`      VARCHAR(30)     DEFAULT NULL                COMMENT '司机电话',
    `container_no`      VARCHAR(64)     DEFAULT NULL                COMMENT '柜号（可选）',
    `source_order_no`   VARCHAR(64)     DEFAULT NULL                COMMENT '关联订单号（可选）',
    `status`            VARCHAR(20)     NOT NULL DEFAULT 'PENDING'  COMMENT '状态：PENDING/CONFIRMED/CANCELLED/COMPLETED/NO_SHOW',
    `yard_task_id`      BIGINT          DEFAULT NULL                COMMENT '关联园区任务ID（签到后关联）',
    `cancel_reason`     VARCHAR(500)    DEFAULT NULL                COMMENT '取消原因',
    `remark`            VARCHAR(500)    DEFAULT NULL,
    `create_dept`       BIGINT          DEFAULT NULL,
    `create_by`         BIGINT          DEFAULT NULL,
    `create_time`       DATETIME        DEFAULT NULL,
    `update_by`         BIGINT          DEFAULT NULL,
    `update_time`       DATETIME        DEFAULT NULL,
    `deleted`           TINYINT(1)      NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_apt_no_tenant` (`apt_no`, `tenant_id`),
    KEY `idx_warehouse_date_slot` (`warehouse_id`, `apt_date`, `apt_slot`),
    KEY `idx_plate_no_status` (`plate_no`, `status`),
    KEY `idx_status` (`status`),
    KEY `idx_apt_date` (`apt_date`),
    KEY `idx_yard_task_id` (`yard_task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='YMS预约表';

-- =============================================
-- M2 门卫签到表
-- =============================================
CREATE TABLE `yms_check_in` (
    `id`                BIGINT          NOT NULL                    COMMENT '主键',
    `tenant_id`         VARCHAR(20)     NOT NULL DEFAULT '000000'   COMMENT '租户ID',
    `warehouse_id`      BIGINT          NOT NULL                    COMMENT '仓库ID',
    `apt_id`            BIGINT          DEFAULT NULL                COMMENT '预约ID（有预约时）',
    `apt_no`            VARCHAR(64)     DEFAULT NULL                COMMENT '预约编号（快照）',
    `yard_task_id`      BIGINT          DEFAULT NULL                COMMENT '关联园区任务ID',
    `yard_task_no`      VARCHAR(64)     DEFAULT NULL                COMMENT '园区任务号（快照）',
    `plate_no`          VARCHAR(30)     NOT NULL                    COMMENT '车牌号',
    `driver_name`       VARCHAR(50)     DEFAULT NULL                COMMENT '司机姓名',
    `driver_phone`      VARCHAR(30)     DEFAULT NULL                COMMENT '司机电话',
    `id_card_no`        VARCHAR(30)     DEFAULT NULL                COMMENT '身份证号',
    `container_no`      VARCHAR(64)     DEFAULT NULL                COMMENT '柜号',
    `task_type`         VARCHAR(30)     DEFAULT NULL                COMMENT '任务类型',
    `check_result`      VARCHAR(20)     NOT NULL DEFAULT 'PENDING'  COMMENT '检查结果：PASSED/REJECTED/BLACKLISTED/PENDING',
    `reject_reason`     VARCHAR(500)    DEFAULT NULL                COMMENT '拒绝原因',
    `match_type`        VARCHAR(20)     NOT NULL DEFAULT 'WALK_IN'  COMMENT '匹配方式：APT_MATCH/WALK_IN/MANUAL',
    `check_in_time`     DATETIME        DEFAULT NULL                COMMENT '签到时间',
    `operator_id`       BIGINT          DEFAULT NULL                COMMENT '操作员ID',
    `operator_name`     VARCHAR(50)     DEFAULT NULL                COMMENT '操作员姓名',
    `remark`            VARCHAR(500)    DEFAULT NULL,
    `create_dept`       BIGINT          DEFAULT NULL,
    `create_by`         BIGINT          DEFAULT NULL,
    `create_time`       DATETIME        DEFAULT NULL,
    `update_by`         BIGINT          DEFAULT NULL,
    `update_time`       DATETIME        DEFAULT NULL,
    `deleted`           TINYINT(1)      NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_warehouse_result` (`warehouse_id`, `check_result`),
    KEY `idx_plate_no` (`plate_no`),
    KEY `idx_check_in_time` (`check_in_time`),
    KEY `idx_yard_task_id` (`yard_task_id`),
    KEY `idx_apt_id` (`apt_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='YMS门卫签到记录';

-- =============================================
-- M5 YardGo 机器人任务表
-- =============================================
CREATE TABLE `yms_yardgo_task` (
    `id`                BIGINT          NOT NULL                    COMMENT '主键',
    `tenant_id`         VARCHAR(20)     NOT NULL DEFAULT '000000'   COMMENT '租户ID',
    `yard_task_id`      BIGINT          NOT NULL                    COMMENT '园区任务ID',
    `yard_task_no`      VARCHAR(64)     DEFAULT NULL                COMMENT '园区任务号（快照）',
    `warehouse_id`      BIGINT          DEFAULT NULL                COMMENT '仓库ID',
    `dock_id`           BIGINT          DEFAULT NULL                COMMENT 'Dock ID（快照）',
    `dock_code`         VARCHAR(30)     DEFAULT NULL                COMMENT 'Dock编码（快照）',
    `robot_task_id`     VARCHAR(100)    DEFAULT NULL                COMMENT '机器人系统任务ID（外部）',
    `robot_status`      VARCHAR(30)     NOT NULL DEFAULT 'PENDING'  COMMENT '机器人任务状态：PENDING/RUNNING/PAUSED/COMPLETED/FAILED/CANCELLED',
    `task_type`         VARCHAR(30)     DEFAULT NULL                COMMENT '任务类型（快照）',
    `progress`          DECIMAL(5,2)    DEFAULT NULL                COMMENT '完成进度（0~100）',
    `start_time`        DATETIME        DEFAULT NULL                COMMENT '开始执行时间',
    `finish_time`       DATETIME        DEFAULT NULL                COMMENT '完成时间',
    `callback_payload`  TEXT            DEFAULT NULL                COMMENT '最后一次回调原始数据',
    `remark`            VARCHAR(500)    DEFAULT NULL,
    `create_dept`       BIGINT          DEFAULT NULL,
    `create_by`         BIGINT          DEFAULT NULL,
    `create_time`       DATETIME        DEFAULT NULL,
    `update_by`         BIGINT          DEFAULT NULL,
    `update_time`       DATETIME        DEFAULT NULL,
    `deleted`           TINYINT(1)      NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_yard_task_id` (`yard_task_id`),
    KEY `idx_robot_task_id` (`robot_task_id`),
    KEY `idx_robot_status` (`robot_status`),
    KEY `idx_warehouse_status` (`warehouse_id`, `robot_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='YMS YardGo机器人任务表';

-- =============================================
-- 字典数据初始化
-- 列顺序（sys_dict_type）: tenant_id, dict_name, dict_type, create_dept, create_by, create_time, update_by, update_time, remark
-- 列顺序（sys_dict_data）: tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_dept, create_by, create_time, update_by, update_time, remark
-- =============================================

-- yms_zone_type 堆场分区类型
INSERT INTO sys_dict_type (tenant_id, dict_name, dict_type, create_dept, create_by, create_time, remark) VALUES
('000000', '堆场分区类型', 'yms_zone_type', 103, 1, NOW(), 'YMS堆场分区类型');

INSERT INTO sys_dict_data (tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_dept, create_by, create_time, remark) VALUES
('000000', 1, '集装箱区', 'CONTAINER',   'yms_zone_type', '', 'info',    'N', 103, 1, NOW(), '集装箱停放区'),
('000000', 2, '卡车区',   'TRUCK',        'yms_zone_type', '', 'info',    'N', 103, 1, NOW(), '普通卡车区'),
('000000', 3, '自提区',   'SELF_PICKUP',  'yms_zone_type', '', 'default', 'N', 103, 1, NOW(), '自提车辆区'),
('000000', 4, '停车区',   'PARKING',      'yms_zone_type', '', 'default', 'N', 103, 1, NOW(), '普通停车区');

-- yms_task_type 任务类型（预约/园区任务通用）
INSERT INTO sys_dict_type (tenant_id, dict_name, dict_type, create_dept, create_by, create_time, remark) VALUES
('000000', 'YMS任务类型', 'yms_task_type', 103, 1, NOW(), 'YMS预约和园区任务类型');

INSERT INTO sys_dict_data (tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_dept, create_by, create_time, remark) VALUES
('000000', 1, '卸柜',     'DEVANNING',          'yms_task_type', '', 'info',    'Y', 103, 1, NOW(), '集装箱卸货'),
('000000', 2, '配送装车', 'DELIVERY_LOADING',   'yms_task_type', '', 'default', 'N', 103, 1, NOW(), '外发配送装车'),
('000000', 3, '调拨装车', 'TRANSFER_LOADING',   'yms_task_type', '', 'default', 'N', 103, 1, NOW(), '仓间调拨装车'),
('000000', 4, '自提装车', 'PICKUP_LOADING',     'yms_task_type', '', 'default', 'N', 103, 1, NOW(), '客户自提'),
('000000', 5, '退货装车', 'RETURN_LOADING',     'yms_task_type', '', 'warning', 'N', 103, 1, NOW(), '退货装车');

-- yms_appointment_status 预约状态
INSERT INTO sys_dict_type (tenant_id, dict_name, dict_type, create_dept, create_by, create_time, remark) VALUES
('000000', 'YMS预约状态', 'yms_appointment_status', 103, 1, NOW(), 'YMS预约状态');

INSERT INTO sys_dict_data (tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_dept, create_by, create_time, remark) VALUES
('000000', 1, '待确认', 'PENDING',   'yms_appointment_status', '', 'warning', 'Y', 103, 1, NOW(), '等待仓库确认'),
('000000', 2, '已确认', 'CONFIRMED', 'yms_appointment_status', '', 'success', 'N', 103, 1, NOW(), '仓库已确认'),
('000000', 3, '已取消', 'CANCELLED', 'yms_appointment_status', '', 'default', 'N', 103, 1, NOW(), '已取消'),
('000000', 4, '已完成', 'COMPLETED', 'yms_appointment_status', '', 'info',    'N', 103, 1, NOW(), '车辆已入场完成'),
('000000', 5, '未到场', 'NO_SHOW',   'yms_appointment_status', '', 'error',   'N', 103, 1, NOW(), '预约时段内未到场');

-- yms_check_result 门卫签到结果
INSERT INTO sys_dict_type (tenant_id, dict_name, dict_type, create_dept, create_by, create_time, remark) VALUES
('000000', 'YMS签到结果', 'yms_check_result', 103, 1, NOW(), 'YMS门卫签到检查结果');

INSERT INTO sys_dict_data (tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_dept, create_by, create_time, remark) VALUES
('000000', 1, '通过',     'PASSED',      'yms_check_result', '', 'success', 'N', 103, 1, NOW(), '验证通过放行'),
('000000', 2, '黑名单',   'BLACKLISTED', 'yms_check_result', '', 'error',   'N', 103, 1, NOW(), '命中黑名单拦截'),
('000000', 3, '拒绝',     'REJECTED',    'yms_check_result', '', 'warning', 'N', 103, 1, NOW(), '无预约拒绝入场'),
('000000', 4, '待人工',   'PENDING',     'yms_check_result', '', 'info',    'Y', 103, 1, NOW(), '等待人工审核');

-- yms_robot_status YardGo机器人任务状态
INSERT INTO sys_dict_type (tenant_id, dict_name, dict_type, create_dept, create_by, create_time, remark) VALUES
('000000', 'YardGo机器人状态', 'yms_robot_status', 103, 1, NOW(), 'YardGo机器人任务状态');

INSERT INTO sys_dict_data (tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_dept, create_by, create_time, remark) VALUES
('000000', 1, '待执行', 'PENDING',   'yms_robot_status', '', 'default', 'Y', 103, 1, NOW(), '等待机器人接收'),
('000000', 2, '执行中', 'RUNNING',   'yms_robot_status', '', 'info',    'N', 103, 1, NOW(), '机器人作业中'),
('000000', 3, '已暂停', 'PAUSED',    'yms_robot_status', '', 'warning', 'N', 103, 1, NOW(), '任务暂停'),
('000000', 4, '已完成', 'COMPLETED', 'yms_robot_status', '', 'success', 'N', 103, 1, NOW(), '作业完成'),
('000000', 5, '失败',   'FAILED',    'yms_robot_status', '', 'error',   'N', 103, 1, NOW(), '机器人报错'),
('000000', 6, '已取消', 'CANCELLED', 'yms_robot_status', '', 'default', 'N', 103, 1, NOW(), '已取消');

-- =============================================
-- 菜单权限初始化（YMS M1-M7 新增菜单）
-- parent_id 需替换为实际YMS父菜单的ID
-- =============================================

-- 以下 @YMS_PARENT_ID 需替换为实际 YMS 模块菜单的父 ID
SET @YMS_PARENT_ID = (SELECT menu_id FROM sys_menu WHERE menu_name = 'YMS' AND parent_id = 0 LIMIT 1);

-- M7 堆场分区
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_time)
VALUES ('堆场分区', @YMS_PARENT_ID, 71, 'yms/zone', 'yms/zone/index', 1, 0, 'C', '0', '0', 'yms:yardZone:list', 'ep:grid', NOW());
SET @ZONE_MENU_ID = LAST_INSERT_ID();
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, menu_type, visible, status, perms, create_time) VALUES
('堆场分区查询', @ZONE_MENU_ID, 1, '#', 'F', '0', '0', 'yms:yardZone:query', NOW()),
('堆场分区新增', @ZONE_MENU_ID, 2, '#', 'F', '0', '0', 'yms:yardZone:add', NOW()),
('堆场分区编辑', @ZONE_MENU_ID, 3, '#', 'F', '0', '0', 'yms:yardZone:edit', NOW()),
('堆场分区删除', @ZONE_MENU_ID, 4, '#', 'F', '0', '0', 'yms:yardZone:remove', NOW());

-- M7 月台管理（指向基础资料 yard:dock 权限）
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_time)
VALUES ('月台管理', @YMS_PARENT_ID, 72, 'yms/dock', 'yms/dock/index', 1, 0, 'C', '0', '0', 'yard:dock:list', 'ep:office-building', NOW());
SET @DOCK_MENU_ID = LAST_INSERT_ID();
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, menu_type, visible, status, perms, create_time) VALUES
('月台查询', @DOCK_MENU_ID, 1, '#', 'F', '0', '0', 'yard:dock:query', NOW()),
('月台新增', @DOCK_MENU_ID, 2, '#', 'F', '0', '0', 'yard:dock:add', NOW()),
('月台编辑', @DOCK_MENU_ID, 3, '#', 'F', '0', '0', 'yard:dock:edit', NOW()),
('月台删除', @DOCK_MENU_ID, 4, '#', 'F', '0', '0', 'yard:dock:remove', NOW());

-- M6 黑名单
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_time)
VALUES ('黑名单管理', @YMS_PARENT_ID, 64, 'yms/blacklist', 'yms/blacklist/index', 1, 0, 'C', '0', '0', 'yms:blacklist:list', 'ep:warning', NOW());
SET @BL_MENU_ID = LAST_INSERT_ID();
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, menu_type, visible, status, perms, create_time) VALUES
('黑名单查询', @BL_MENU_ID, 1, '#', 'F', '0', '0', 'yms:blacklist:query', NOW()),
('黑名单移出', @BL_MENU_ID, 2, '#', 'F', '0', '0', 'yms:blacklist:remove', NOW());

-- M1 时段模板
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_time)
VALUES ('时段模板', @YMS_PARENT_ID, 11, 'yms/slot-template', 'yms/slot-template/index', 1, 0, 'C', '0', '0', 'yms:slotTemplate:list', 'ep:clock', NOW());
SET @ST_MENU_ID = LAST_INSERT_ID();
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, menu_type, visible, status, perms, create_time) VALUES
('时段模板查询', @ST_MENU_ID, 1, '#', 'F', '0', '0', 'yms:slotTemplate:query', NOW()),
('时段模板新增', @ST_MENU_ID, 2, '#', 'F', '0', '0', 'yms:slotTemplate:add', NOW()),
('时段模板编辑', @ST_MENU_ID, 3, '#', 'F', '0', '0', 'yms:slotTemplate:edit', NOW()),
('时段模板删除', @ST_MENU_ID, 4, '#', 'F', '0', '0', 'yms:slotTemplate:remove', NOW());

-- M1 预约管理
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_time)
VALUES ('预约管理', @YMS_PARENT_ID, 12, 'yms/appointment', 'yms/appointment/index', 1, 0, 'C', '0', '0', 'yms:appointment:list', 'ep:calendar', NOW());
SET @APT_MENU_ID = LAST_INSERT_ID();
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, menu_type, visible, status, perms, create_time) VALUES
('预约查询', @APT_MENU_ID, 1, '#', 'F', '0', '0', 'yms:appointment:query', NOW()),
('预约新增', @APT_MENU_ID, 2, '#', 'F', '0', '0', 'yms:appointment:add', NOW()),
('预约编辑', @APT_MENU_ID, 3, '#', 'F', '0', '0', 'yms:appointment:edit', NOW()),
('预约删除', @APT_MENU_ID, 4, '#', 'F', '0', '0', 'yms:appointment:remove', NOW()),
('预约确认', @APT_MENU_ID, 5, '#', 'F', '0', '0', 'yms:appointment:confirm', NOW()),
('预约取消', @APT_MENU_ID, 6, '#', 'F', '0', '0', 'yms:appointment:cancel', NOW()),
('标记未到', @APT_MENU_ID, 7, '#', 'F', '0', '0', 'yms:appointment:noShow', NOW());

-- M2 门卫操作台
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_time)
VALUES ('门卫操作台', @YMS_PARENT_ID, 21, 'yms/gate', 'yms/gate/index', 1, 0, 'C', '0', '0', 'yms:gate:list', 'ep:monitor', NOW());
SET @GATE_MENU_ID = LAST_INSERT_ID();
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, menu_type, visible, status, perms, create_time) VALUES
('签到记录查询', @GATE_MENU_ID, 1, '#', 'F', '0', '0', 'yms:gate:query', NOW()),
('入场登记', @GATE_MENU_ID, 2, '#', 'F', '0', '0', 'yms:gate:checkIn', NOW()),
('手动放行', @GATE_MENU_ID, 3, '#', 'F', '0', '0', 'yms:gate:manualPass', NOW());

-- M5 YardGo 机器人任务
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_time)
VALUES ('YardGo任务', @YMS_PARENT_ID, 51, 'yms/yardgo', 'yms/yardgo/index', 1, 0, 'C', '0', '0', 'yms:yardgo:list', 'ep:robot', NOW());
SET @YG_MENU_ID = LAST_INSERT_ID();
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, menu_type, visible, status, perms, create_time) VALUES
('YardGo查询', @YG_MENU_ID, 1, '#', 'F', '0', '0', 'yms:yardgo:query', NOW()),
('YardGo取消', @YG_MENU_ID, 2, '#', 'F', '0', '0', 'yms:yardgo:cancel', NOW());
-- DEPRECATED for YMS Phase 1 simplified scope.
-- Do not execute this legacy migration after 2026-05-30.
-- Use yms_phase1_cleanup_20260530.sql and yms_phase1_final_sync_20260530.sql instead.
