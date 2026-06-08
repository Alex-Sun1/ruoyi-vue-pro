-- YMS consolidated migration


-- ========== yms_phase1_redesign_20260529.sql ==========
-- =============================================
-- YMS Phase 1 Redesign Migration
-- 基于《YMS堆场管理系统完整PRD v1.0》重新设计
-- 日期：2026-05-29
-- 说明：
--   1. yard_dock 在 BASE 模块管理，YMS 引用其 ID，不重复建表
--   2. 本脚本新增核心业务表：海柜资源、车厢资源、堆场位、院内任务、叫号规则、预约规则等
--   3. ALTER 已有表：yms_yard_task、yms_appointment、yms_check_in
--   4. 更新字典：yard_dock 类型补全、新增 YMS 核心字典
--   5. 新增菜单
-- =============================================

-- =============================================
-- 1. yms_container_resource 海柜资源表
--    管理海柜在园区内的全生命周期状态与位置
-- =============================================
CREATE TABLE IF NOT EXISTS `yms_container_resource` (
    `id`                        BIGINT          NOT NULL                        COMMENT '主键',
    `tenant_id`                 BIGINT          NOT NULL DEFAULT 0              COMMENT '租户编号',
    `company_id`                BIGINT          DEFAULT NULL                    COMMENT '主体公司ID',
    `warehouse_id`              BIGINT          NOT NULL                        COMMENT '仓库/园区ID',

    -- 柜子基本信息
    `container_no`              VARCHAR(64)     NOT NULL                        COMMENT '柜号',
    `container_type`            VARCHAR(30)     DEFAULT NULL                    COMMENT '柜型：40HQ/45HQ/53FT/20GP/40GP',
    `carrier`                   VARCHAR(100)    DEFAULT NULL                    COMMENT '船司（MAERSK/COSCO等）',
    `seal_no`                   VARCHAR(64)     DEFAULT NULL                    COMMENT '封条号',

    -- 关联业务
    `related_order_id`          BIGINT          DEFAULT NULL                    COMMENT '关联海柜订单ID',
    `related_order_no`          VARCHAR(64)     DEFAULT NULL                    COMMENT '关联海柜订单号（快照）',
    `biz_root_id`               BIGINT          DEFAULT NULL                    COMMENT '业务主线ID',

    -- 状态
    `container_status`          VARCHAR(30)     NOT NULL DEFAULT 'EXPECTED_ARRIVAL' COMMENT '柜状态',
    `empty_status`              VARCHAR(20)     NOT NULL DEFAULT 'FULL'         COMMENT '重空状态：FULL重柜/EMPTY空柜',

    -- 位置
    `yard_position_id`          BIGINT          DEFAULT NULL                    COMMENT '当前堆场位ID',
    `yard_zone_id`              BIGINT          DEFAULT NULL                    COMMENT '当前堆场区ID（冗余）',
    `dock_id`                   BIGINT          DEFAULT NULL                    COMMENT '当前 Dock ID（上口时）',
    `dock_code`                 VARCHAR(30)     DEFAULT NULL                    COMMENT 'Dock 编号（快照）',

    -- 关键时间节点
    `eta_time`                  DATETIME        DEFAULT NULL                    COMMENT '预计到仓时间',
    `arrived_time`              DATETIME        DEFAULT NULL                    COMMENT '实际到达时间',
    `devanning_start_time`      DATETIME        DEFAULT NULL                    COMMENT '拆柜开始时间',
    `devanning_finish_time`     DATETIME        DEFAULT NULL                    COMMENT '拆柜完成时间',
    `leave_time`                DATETIME        DEFAULT NULL                    COMMENT '离场时间',

    -- LFD
    `lfd_pickup`                DATE            DEFAULT NULL                    COMMENT '提柜 LFD（最晚提柜日期）',
    `lfd_return`                DATE            DEFAULT NULL                    COMMENT '还柜 LFD（最晚还柜日期）',

    -- 车辆信息（运送柜到仓的车辆）
    `tractor_no`                VARCHAR(30)     DEFAULT NULL                    COMMENT '车头号',
    `plate_no`                  VARCHAR(30)     DEFAULT NULL                    COMMENT '车牌号',
    `driver_name`               VARCHAR(50)     DEFAULT NULL                    COMMENT '司机姓名',
    `driver_phone`              VARCHAR(20)     DEFAULT NULL                    COMMENT '司机电话',

    -- 异常
    `exception_flag`            TINYINT(1)      NOT NULL DEFAULT 0              COMMENT '是否异常',
    `exception_reason`          VARCHAR(500)    DEFAULT NULL                    COMMENT '异常原因',

    `remark`                    VARCHAR(500)    DEFAULT NULL,
    `creator`               VARCHAR(64)     DEFAULT ''                    COMMENT '创建者',
    `create_time`           DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`               VARCHAR(64)     DEFAULT ''                    COMMENT '更新者',
    `update_time`           DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`               BIT(1)          NOT NULL DEFAULT b'0'         COMMENT '是否删除',

    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_container_no_tenant` (`container_no`, `tenant_id`, `deleted`),
    KEY `idx_warehouse_status` (`warehouse_id`, `container_status`),
    KEY `idx_company_id` (`company_id`),
    KEY `idx_related_order` (`related_order_id`),
    KEY `idx_yard_position` (`yard_position_id`),
    KEY `idx_lfd_return` (`lfd_return`),
    KEY `idx_biz_root_id` (`biz_root_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='YMS海柜资源表（海柜在园区的全生命周期）';

-- =============================================
-- 2. yms_trailer_resource 车厢资源表
--    管理供应商车辆/租赁车厢/自有车厢在园区的状态
-- =============================================
CREATE TABLE IF NOT EXISTS `yms_trailer_resource` (
    `id`                        BIGINT          NOT NULL                        COMMENT '主键',
    `tenant_id`                 BIGINT          NOT NULL DEFAULT 0              COMMENT '租户编号',
    `company_id`                BIGINT          DEFAULT NULL                    COMMENT '主体公司ID',
    `warehouse_id`              BIGINT          NOT NULL                        COMMENT '仓库/园区ID',

    -- 车厢信息
    `trailer_no`                VARCHAR(64)     DEFAULT NULL                    COMMENT '车厢号',
    `tractor_no`                VARCHAR(30)     DEFAULT NULL                    COMMENT '车头号',
    `plate_no`                  VARCHAR(30)     DEFAULT NULL                    COMMENT '车牌号（整车）',
    `driver_name`               VARCHAR(50)     DEFAULT NULL                    COMMENT '司机姓名',
    `driver_phone`              VARCHAR(20)     DEFAULT NULL                    COMMENT '司机电话',
    `driver_id_no`              VARCHAR(30)     DEFAULT NULL                    COMMENT '司机身份证号',

    -- 车辆来源（决定调度和离场逻辑）
    `vehicle_source`            VARCHAR(30)     NOT NULL DEFAULT 'SUPPLIER_TRUCK' COMMENT '车辆来源：SUPPLIER_TRUCK/RENTED_TRAILER/OWN_TRAILER/TEMP_TRUCK',
    `supplier_id`               BIGINT          DEFAULT NULL                    COMMENT '供应商ID（SUPPLIER_TRUCK时）',
    `supplier_name`             VARCHAR(100)    DEFAULT NULL                    COMMENT '供应商名称（快照）',

    -- 关联业务
    `related_loading_task_id`   BIGINT          DEFAULT NULL                    COMMENT '关联装车园区任务ID',
    `related_order_no`          VARCHAR(64)     DEFAULT NULL                    COMMENT '关联出库/派送单号',
    `biz_root_id`               BIGINT          DEFAULT NULL                    COMMENT '业务主线ID',

    -- 状态
    `trailer_status`            VARCHAR(30)     NOT NULL DEFAULT 'EXPECTED_ARRIVAL' COMMENT '车厢状态',

    -- 位置
    `yard_position_id`          BIGINT          DEFAULT NULL                    COMMENT '当前堆场位ID',
    `yard_zone_id`              BIGINT          DEFAULT NULL                    COMMENT '当前堆场区ID（冗余）',
    `dock_id`                   BIGINT          DEFAULT NULL                    COMMENT '当前 Dock ID（上口时）',
    `dock_code`                 VARCHAR(30)     DEFAULT NULL                    COMMENT 'Dock 编号（快照）',

    -- 时间节点
    `arrive_time`               DATETIME        DEFAULT NULL                    COMMENT '到仓时间',
    `loading_start_time`        DATETIME        DEFAULT NULL                    COMMENT '装车开始时间',
    `loading_finish_time`       DATETIME        DEFAULT NULL                    COMMENT '装车完成时间',
    `leave_time`                DATETIME        DEFAULT NULL                    COMMENT '离场时间',

    -- WMS 状态
    `wms_ready_status`          VARCHAR(30)     NOT NULL DEFAULT 'NOT_REQUIRED' COMMENT 'WMS备货状态：NOT_REQUIRED/PENDING/READY',
    `wms_ready_time`            DATETIME        DEFAULT NULL                    COMMENT 'WMS备货完成时间',

    -- 异常
    `exception_flag`            TINYINT(1)      NOT NULL DEFAULT 0              COMMENT '是否异常',
    `exception_reason`          VARCHAR(500)    DEFAULT NULL                    COMMENT '异常原因',

    `remark`                    VARCHAR(500)    DEFAULT NULL,
    `creator`               VARCHAR(64)     DEFAULT ''                    COMMENT '创建者',
    `create_time`           DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`               VARCHAR(64)     DEFAULT ''                    COMMENT '更新者',
    `update_time`           DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`               BIT(1)          NOT NULL DEFAULT b'0'         COMMENT '是否删除',

    PRIMARY KEY (`id`),
    KEY `idx_warehouse_status` (`warehouse_id`, `trailer_status`),
    KEY `idx_plate_no` (`plate_no`),
    KEY `idx_trailer_no` (`trailer_no`),
    KEY `idx_vehicle_source` (`vehicle_source`),
    KEY `idx_related_loading_task` (`related_loading_task_id`),
    KEY `idx_biz_root_id` (`biz_root_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='YMS车厢资源表（供应商车辆/租赁车厢/自有车厢）';

-- =============================================
-- 3. yms_yard_position 堆场位表
--    记录园区内每个物理位置的类型和占用情况
-- =============================================
CREATE TABLE IF NOT EXISTS `yms_yard_position` (
    `id`                    BIGINT          NOT NULL                    COMMENT '主键',
    `tenant_id`             VARCHAR(20)     NOT NULL DEFAULT '000000'   COMMENT '租户ID',
    `warehouse_id`          BIGINT          NOT NULL                    COMMENT '仓库/园区ID',
    `zone_id`               BIGINT          NOT NULL                    COMMENT '所属堆场区ID（yms_yard_zone.id）',
    `zone_code`             VARCHAR(30)     DEFAULT NULL                COMMENT '堆场区编码（冗余）',

    -- 位置编码
    `position_code`         VARCHAR(30)     NOT NULL                    COMMENT '位置编码（如 A-01, B-03）',
    `position_name`         VARCHAR(100)    DEFAULT NULL                COMMENT '位置名称',
    `position_type`         VARCHAR(30)     NOT NULL DEFAULT 'CONTAINER_SLOT' COMMENT '位置类型：CONTAINER_SLOT/EMPTY_CONTAINER_SLOT/TRAILER_SLOT/WAITING_SLOT/BLOCKED_SLOT',
    `position_status`       VARCHAR(20)     NOT NULL DEFAULT 'FREE'     COMMENT '位置状态：FREE/OCCUPIED/RESERVED/DISABLED',

    -- 网格坐标（用于地图显示）
    `grid_row`              INT             DEFAULT NULL                COMMENT '行坐标',
    `grid_col`              INT             DEFAULT NULL                COMMENT '列坐标',

    -- 占用信息
    `occupied_object_type`  VARCHAR(20)     DEFAULT NULL                COMMENT '占用对象类型：CONTAINER/EMPTY_CONTAINER/TRAILER',
    `occupied_object_id`    BIGINT          DEFAULT NULL                COMMENT '占用对象ID',
    `occupied_object_no`    VARCHAR(64)     DEFAULT NULL                COMMENT '占用对象编号（柜号/车厢号，快照）',
    `occupied_since`        DATETIME        DEFAULT NULL                COMMENT '占用开始时间',

    `remark`                VARCHAR(500)    DEFAULT NULL,
    `creator`               VARCHAR(64)     DEFAULT ''                    COMMENT '创建者',
    `create_time`           DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`               VARCHAR(64)     DEFAULT ''                    COMMENT '更新者',
    `update_time`           DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`               BIT(1)          NOT NULL DEFAULT b'0'         COMMENT '是否删除',

    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_position_code_zone` (`position_code`, `zone_id`, `deleted`),
    KEY `idx_zone_id` (`zone_id`),
    KEY `idx_warehouse_type_status` (`warehouse_id`, `position_type`, `position_status`),
    KEY `idx_occupied_object` (`occupied_object_type`, `occupied_object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='YMS堆场位表（园区物理位置管理）';

-- =============================================
-- 4. yms_internal_task 院内任务表
--    海柜上口/下口/挪柜/盘点/车厢上口等执行任务
--    替代原 yms_yardgo_task，更完整支持各类型
-- =============================================
CREATE TABLE IF NOT EXISTS `yms_internal_task` (
    `id`                    BIGINT          NOT NULL                    COMMENT '主键',
    `tenant_id`             VARCHAR(20)     NOT NULL DEFAULT '000000'   COMMENT '租户ID',
    `warehouse_id`          BIGINT          NOT NULL                    COMMENT '仓库/园区ID',
    `task_no`               VARCHAR(64)     NOT NULL                    COMMENT '院内任务编号（IT+日期+序号）',

    -- 关联主任务
    `parent_yard_task_id`   BIGINT          DEFAULT NULL                COMMENT '关联园区主任务ID（yms_yard_task.id）',
    `parent_yard_task_no`   VARCHAR(64)     DEFAULT NULL                COMMENT '园区主任务号（快照）',

    -- 任务类型
    `internal_task_type`    VARCHAR(30)     NOT NULL                    COMMENT '院内任务类型：CONTAINER_TO_DOCK/CONTAINER_OFF_DOCK/TRAILER_TO_DOCK/TRAILER_OFF_DOCK/CONTAINER_MOVE/TRAILER_MOVE/EMPTY_CONTAINER_RETURN/YARD_INVENTORY_SCAN',

    -- 操作对象
    `object_type`           VARCHAR(20)     NOT NULL                    COMMENT '操作对象类型：CONTAINER/TRAILER',
    `object_id`             BIGINT          DEFAULT NULL                COMMENT '操作对象ID',
    `object_no`             VARCHAR(64)     DEFAULT NULL                COMMENT '操作对象编号（柜号/车厢号，快照）',

    -- 位置
    `from_position_id`      BIGINT          DEFAULT NULL                COMMENT '起始位置ID',
    `from_position_code`    VARCHAR(30)     DEFAULT NULL                COMMENT '起始位置编码（快照）',
    `to_position_id`        BIGINT          DEFAULT NULL                COMMENT '目标位置ID（移动任务）',
    `to_position_code`      VARCHAR(30)     DEFAULT NULL                COMMENT '目标位置编码（快照）',
    `to_dock_id`            BIGINT          DEFAULT NULL                COMMENT '目标 Dock ID（上口任务）',
    `to_dock_code`          VARCHAR(30)     DEFAULT NULL                COMMENT '目标 Dock 编号（快照）',

    -- 执行人
    `executor_type`         VARCHAR(20)     DEFAULT NULL                COMMENT '执行者类型：MANUAL/FORKLIFT/YARDGOAT',
    `executor_id`           BIGINT          DEFAULT NULL                COMMENT '执行者ID（用户ID或设备ID）',
    `executor_name`         VARCHAR(50)     DEFAULT NULL                COMMENT '执行者名称（快照）',

    -- 状态
    `task_status`           VARCHAR(20)     NOT NULL DEFAULT 'PENDING'  COMMENT '任务状态：PENDING/ASSIGNED/ACCEPTED/IN_PROGRESS/COMPLETED/FAILED/CANCELLED',
    `priority`              INT             NOT NULL DEFAULT 5          COMMENT '优先级（1-10）',

    -- 时间节点
    `assign_time`           DATETIME        DEFAULT NULL                COMMENT '分配时间',
    `accept_time`           DATETIME        DEFAULT NULL                COMMENT '接单时间',
    `start_time`            DATETIME        DEFAULT NULL                COMMENT '开始执行时间',
    `finish_time`           DATETIME        DEFAULT NULL                COMMENT '完成时间',
    `deadline_time`         DATETIME        DEFAULT NULL                COMMENT '截止时间（SLA）',

    -- 结果
    `fail_reason`           VARCHAR(500)    DEFAULT NULL                COMMENT '失败原因',
    `photo_urls`            TEXT            DEFAULT NULL                COMMENT '现场照片URL（JSON数组）',

    `remark`                VARCHAR(500)    DEFAULT NULL,
    `creator`               VARCHAR(64)     DEFAULT ''                    COMMENT '创建者',
    `create_time`           DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`               VARCHAR(64)     DEFAULT ''                    COMMENT '更新者',
    `update_time`           DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`               BIT(1)          NOT NULL DEFAULT b'0'         COMMENT '是否删除',

    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_task_no_tenant` (`task_no`, `tenant_id`),
    KEY `idx_parent_yard_task` (`parent_yard_task_id`),
    KEY `idx_warehouse_type_status` (`warehouse_id`, `internal_task_type`, `task_status`),
    KEY `idx_executor` (`executor_id`, `task_status`),
    KEY `idx_object` (`object_type`, `object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='YMS院内任务表（上口/下口/挪柜/盘点）';

-- =============================================
-- 5. yms_appointment_rule 预约规则配置表
--    替代 yms_slot_template，支持更灵活的规则配置
-- =============================================
CREATE TABLE IF NOT EXISTS `yms_appointment_rule` (
    `id`                        BIGINT          NOT NULL                    COMMENT '主键',
    `tenant_id`                 VARCHAR(20)     NOT NULL DEFAULT '000000'   COMMENT '租户ID',
    `rule_name`                 VARCHAR(100)    NOT NULL                    COMMENT '规则名称',
    `warehouse_id`              BIGINT          NOT NULL                    COMMENT '仓库/园区ID',

    -- 适用范围
    `business_type`             VARCHAR(30)     DEFAULT NULL                COMMENT '业务类型：DEVANNING/DELIVERY_LOADING/TRANSFER_LOADING/PICKUP_LOADING/RETURN_LOADING（NULL=ALL）',
    `vehicle_source`            VARCHAR(30)     DEFAULT NULL                COMMENT '车辆来源（NULL=ALL）',
    `dock_type`                 VARCHAR(30)     DEFAULT NULL                COMMENT 'Dock类型（NULL=ALL）',
    `customer_level`            VARCHAR(30)     DEFAULT NULL                COMMENT '客户等级（NULL=ALL）',

    -- 预约规则参数
    `advance_days_min`          INT             NOT NULL DEFAULT 1          COMMENT '最少提前预约天数',
    `advance_days_max`          INT             NOT NULL DEFAULT 7          COMMENT '最多提前预约天数',
    `cancel_deadline_minutes`   INT             NOT NULL DEFAULT 60         COMMENT '最晚取消时间（预约时段前N分钟）',
    `late_grace_minutes`        INT             NOT NULL DEFAULT 30         COMMENT '迟到宽限时间（分钟）',
    `no_show_minutes`           INT             NOT NULL DEFAULT 60         COMMENT '爽约判定时间（超过预约时段N分钟未签到）',
    `auto_confirm`              TINYINT(1)      NOT NULL DEFAULT 0          COMMENT '是否自动确认（0否1是）',
    `holiday_flag`              TINYINT(1)      NOT NULL DEFAULT 0          COMMENT '是否适用节假日（0否1是）',

    `enabled`                   TINYINT(1)      NOT NULL DEFAULT 1          COMMENT '是否启用',
    `sort_order`                INT             DEFAULT 0                   COMMENT '规则优先级（值越小越先匹配）',
    `remark`                    VARCHAR(500)    DEFAULT NULL,
    `creator`               VARCHAR(64)     DEFAULT ''                    COMMENT '创建者',
    `create_time`           DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`               VARCHAR(64)     DEFAULT ''                    COMMENT '更新者',
    `update_time`           DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`               BIT(1)          NOT NULL DEFAULT b'0'         COMMENT '是否删除',

    PRIMARY KEY (`id`),
    KEY `idx_warehouse_enabled` (`warehouse_id`, `enabled`),
    KEY `idx_business_type` (`business_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='YMS预约规则配置表';

-- =============================================
-- 6. yms_appointment_rule_slot 预约时段配置表
-- =============================================
CREATE TABLE IF NOT EXISTS `yms_appointment_rule_slot` (
    `id`            BIGINT          NOT NULL                    COMMENT '主键',
    `tenant_id`     VARCHAR(20)     NOT NULL DEFAULT '000000'   COMMENT '租户ID',
    `rule_id`       BIGINT          NOT NULL                    COMMENT '预约规则ID',
    `weekday`       TINYINT         NOT NULL                    COMMENT '星期（1=周一...7=周日）',
    `start_time`    VARCHAR(10)     NOT NULL                    COMMENT '时段开始时间（HH:mm）',
    `end_time`      VARCHAR(10)     NOT NULL                    COMMENT '时段结束时间（HH:mm）',
    `slot_minutes`  INT             NOT NULL DEFAULT 60         COMMENT '时段粒度（分钟）',
    `capacity`      INT             NOT NULL DEFAULT 4          COMMENT '每时段容量',
    `enabled`       TINYINT(1)      NOT NULL DEFAULT 1          COMMENT '是否启用',

    PRIMARY KEY (`id`),
    KEY `idx_rule_weekday` (`rule_id`, `weekday`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='YMS预约时段配置表';

-- =============================================
-- 7. yms_call_rule 叫号规则配置表
-- =============================================
CREATE TABLE IF NOT EXISTS `yms_call_rule` (
    `id`                        BIGINT          NOT NULL                    COMMENT '主键',
    `tenant_id`                 VARCHAR(20)     NOT NULL DEFAULT '000000'   COMMENT '租户ID',
    `rule_name`                 VARCHAR(100)    NOT NULL                    COMMENT '规则名称',
    `warehouse_id`              BIGINT          NOT NULL                    COMMENT '仓库/园区ID',
    `task_type`                 VARCHAR(30)     NOT NULL                    COMMENT '适用任务类型：DEVANNING/DELIVERY_LOADING/TRANSFER_LOADING/PICKUP_LOADING/RETURN_LOADING',
    `dock_type`                 VARCHAR(30)     DEFAULT NULL                COMMENT '适用Dock类型（NULL=ALL）',

    -- 规则参数
    `wms_ready_required`        TINYINT(1)      NOT NULL DEFAULT 0          COMMENT '是否要求WMS备货完成（装车类任务用）',
    `appointment_required`      TINYINT(1)      NOT NULL DEFAULT 0          COMMENT '是否要求有预约',
    `allow_manual_insert`       TINYINT(1)      NOT NULL DEFAULT 1          COMMENT '是否允许人工插队',
    `auto_call_enabled`         TINYINT(1)      NOT NULL DEFAULT 0          COMMENT '是否自动叫号',
    `require_dispatch_confirm`  TINYINT(1)      NOT NULL DEFAULT 1          COMMENT '是否需要调度员确认',
    `max_call_count`            INT             NOT NULL DEFAULT 3          COMMENT '最大叫号次数（超过则标记超时）',
    `call_timeout_minutes`      INT             NOT NULL DEFAULT 15         COMMENT '叫号超时时间（分钟）',

    `enabled`                   TINYINT(1)      NOT NULL DEFAULT 1          COMMENT '是否启用',
    `sort_order`                INT             DEFAULT 0,
    `remark`                    VARCHAR(500)    DEFAULT NULL,
    `creator`               VARCHAR(64)     DEFAULT ''                    COMMENT '创建者',
    `create_time`           DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`               VARCHAR(64)     DEFAULT ''                    COMMENT '更新者',
    `update_time`           DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`               BIT(1)          NOT NULL DEFAULT b'0'         COMMENT '是否删除',

    PRIMARY KEY (`id`),
    KEY `idx_warehouse_task_type` (`warehouse_id`, `task_type`, `enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='YMS叫号规则配置表';

-- =============================================
-- 8. yms_call_rule_condition 叫号前置条件表
-- =============================================
CREATE TABLE IF NOT EXISTS `yms_call_rule_condition` (
    `id`                BIGINT          NOT NULL                    COMMENT '主键',
    `tenant_id`         BIGINT          NOT NULL DEFAULT 0          COMMENT '租户编号',
    `rule_id`           BIGINT          NOT NULL                    COMMENT '叫号规则ID',
    `condition_field`   VARCHAR(50)     NOT NULL                    COMMENT '条件字段（如 container_status/wms_status）',
    `operator`          VARCHAR(10)     NOT NULL                    COMMENT '运算符：EQ/NEQ/IN/GTE/LTE',
    `condition_value`   VARCHAR(200)    NOT NULL                    COMMENT '条件值',
    `sort_order`        INT             NOT NULL DEFAULT 1          COMMENT '排序',

    `creator`               VARCHAR(64)     DEFAULT ''                    COMMENT '创建者',
    `create_time`           DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`               VARCHAR(64)     DEFAULT ''                    COMMENT '更新者',
    `update_time`           DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`               BIT(1)          NOT NULL DEFAULT b'0'         COMMENT '是否删除',

    PRIMARY KEY (`id`),
    KEY `idx_rule_id` (`rule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='YMS叫号前置条件表';

-- =============================================
-- 9. yms_call_rule_sort 叫号排序规则表
-- =============================================
CREATE TABLE IF NOT EXISTS `yms_call_rule_sort` (
    `id`                BIGINT          NOT NULL                    COMMENT '主键',
    `tenant_id`         BIGINT          NOT NULL DEFAULT 0          COMMENT '租户编号',
    `rule_id`           BIGINT          NOT NULL                    COMMENT '叫号规则ID',
    `sort_field`        VARCHAR(50)     NOT NULL                    COMMENT '排序字段：appointment_time/arrive_time/wms_ready_time/lfd_return/customer_level/priority/waiting_minutes',
    `sort_direction`    VARCHAR(4)      NOT NULL DEFAULT 'ASC'      COMMENT '排序方向：ASC/DESC',
    `priority_order`    INT             NOT NULL DEFAULT 1          COMMENT '排序优先级（1=最高优先级）',

    `creator`               VARCHAR(64)     DEFAULT ''                    COMMENT '创建者',
    `create_time`           DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`               VARCHAR(64)     DEFAULT ''                    COMMENT '更新者',
    `update_time`           DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`               BIT(1)          NOT NULL DEFAULT b'0'         COMMENT '是否删除',

    PRIMARY KEY (`id`),
    KEY `idx_rule_id` (`rule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='YMS叫号排序规则表';

-- =============================================
-- 10. yms_call_record 叫号记录表
-- =============================================
CREATE TABLE IF NOT EXISTS `yms_call_record` (
    `id`                BIGINT          NOT NULL                    COMMENT '主键',
    `tenant_id`         BIGINT          NOT NULL DEFAULT 0          COMMENT '租户编号',
    `warehouse_id`      BIGINT          NOT NULL                    COMMENT '仓库/园区ID',
    `yard_task_id`      BIGINT          NOT NULL                    COMMENT '园区任务ID',
    `yard_task_no`      VARCHAR(64)     DEFAULT NULL                COMMENT '园区任务号（快照）',
    `call_rule_id`      BIGINT          DEFAULT NULL                COMMENT '叫号规则ID',
    `call_no`           INT             NOT NULL DEFAULT 1          COMMENT '第几次叫号',
    `call_status`       VARCHAR(20)     NOT NULL DEFAULT 'CALLED'   COMMENT '叫号状态：CALLED已叫号/RESPONDED已响应/TIMEOUT超时/CANCELLED已取消',
    `call_type`         VARCHAR(20)     NOT NULL DEFAULT 'AUTO'     COMMENT '叫号方式：AUTO自动/MANUAL人工',
    `caller_id`         BIGINT          DEFAULT NULL                COMMENT '叫号操作员ID（人工叫号时）',
    `caller_name`       VARCHAR(50)     DEFAULT NULL                COMMENT '叫号操作员姓名',
    `dock_id`           BIGINT          DEFAULT NULL                COMMENT '分配 Dock ID',
    `dock_code`         VARCHAR(30)     DEFAULT NULL                COMMENT '分配 Dock 编号（快照）',
    `call_time`         DATETIME        NOT NULL                    COMMENT '叫号时间',
    `respond_time`      DATETIME        DEFAULT NULL                COMMENT '响应时间',
    `timeout_time`      DATETIME        DEFAULT NULL                COMMENT '超时时间',
    `cancel_time`       DATETIME        DEFAULT NULL                COMMENT '取消时间',
    `create_time`       DATETIME        DEFAULT NULL,

    PRIMARY KEY (`id`),
    KEY `idx_yard_task_id` (`yard_task_id`),
    KEY `idx_warehouse_status` (`warehouse_id`, `call_status`),
    KEY `idx_call_time` (`call_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='YMS叫号记录表';

-- =============================================
-- 10.5 基础表（必须在 ALTER 之前创建）
-- yms_yard_task / yms_appointment / yms_check_in 为 Phase1 增量脚本的前置依赖
-- =============================================
CREATE TABLE IF NOT EXISTS `yms_yard_task` (
    `id` bigint NOT NULL COMMENT '主键',
    `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
    `yard_task_no` varchar(64) NOT NULL COMMENT '园区任务号（YT+日期+序号）',
    `task_type` varchar(30) NOT NULL COMMENT '任务类型：DEVANNING/DELIVERY_LOADING/TRANSFER_LOADING/PICKUP_LOADING/RETURN_LOADING/OTHER',
    `warehouse_id` bigint DEFAULT NULL COMMENT '仓库ID',
    `source_order_type` varchar(30) DEFAULT NULL COMMENT '来源单据类型：CONTAINER_ORDER/DELIVERY_ORDER/TRANSFER_ORDER/etc',
    `source_order_id` bigint DEFAULT NULL COMMENT '来源单据ID',
    `source_order_no` varchar(64) DEFAULT NULL COMMENT '来源单据号（快照）',
    `container_no` varchar(64) DEFAULT NULL COMMENT '柜号（快照）',
    `container_resource_id` bigint DEFAULT NULL COMMENT '海柜资源ID（DEVANNING任务）',
    `trailer_resource_id` bigint DEFAULT NULL COMMENT '车厢资源ID（LOADING任务）',
    `wms_ready_status` varchar(30) NOT NULL DEFAULT 'NOT_REQUIRED' COMMENT 'WMS备货状态：NOT_REQUIRED/PENDING/READY',
    `wms_ready_time` datetime DEFAULT NULL COMMENT 'WMS备货完成时间',
    `appointment_id` bigint DEFAULT NULL COMMENT '预约ID',
    `dock_assign_time` datetime DEFAULT NULL COMMENT 'Dock分配时间',
    `call_time` datetime DEFAULT NULL COMMENT '叫号时间',
    `priority` int NOT NULL DEFAULT 5 COMMENT '优先级（1-10，越小越高）',
    `truck_no` varchar(30) DEFAULT NULL COMMENT '车牌号',
    `driver_name` varchar(50) DEFAULT NULL COMMENT '司机姓名',
    `driver_phone` varchar(20) DEFAULT NULL COMMENT '司机电话',
    `driver_license_no` varchar(50) DEFAULT NULL COMMENT '司机驾照号码',
    `eta_yard_time` datetime DEFAULT NULL COMMENT '预计到园区时间',
    `gate_in_time` datetime DEFAULT NULL COMMENT '到园区时间（签到）',
    `dock_start_time` datetime DEFAULT NULL COMMENT 'Dock作业开始时间',
    `dock_finish_time` datetime DEFAULT NULL COMMENT 'Dock作业完成时间',
    `release_time` datetime DEFAULT NULL COMMENT '放行时间',
    `gate_out_time` datetime DEFAULT NULL COMMENT '离园时间',
    `dock_id` bigint DEFAULT NULL COMMENT '当前Dock ID（yard_dock.id）',
    `dock_code` varchar(30) DEFAULT NULL COMMENT 'Dock编号（快照）',
    `operation_task_id` bigint DEFAULT NULL COMMENT 'WMS作业任务ID',
    `operation_status` varchar(30) DEFAULT NULL COMMENT 'WMS作业状态',
    `operation_progress` decimal(5,2) DEFAULT NULL COMMENT '作业进度百分比',
    `operation_start_time` datetime DEFAULT NULL COMMENT '作业开始时间',
    `operation_finish_time` datetime DEFAULT NULL COMMENT '作业完成时间',
    `estimated_finish_time` datetime DEFAULT NULL COMMENT '预计完成时间',
    `loaded_qty` decimal(10,0) DEFAULT NULL COMMENT '已装数量',
    `total_qty` decimal(10,0) DEFAULT NULL COMMENT '应装数量',
    `loaded_pallet_qty` decimal(10,0) DEFAULT NULL COMMENT '已装板数',
    `total_pallet_qty` decimal(10,0) DEFAULT NULL COMMENT '应装板数',
    `yard_status` varchar(30) NOT NULL DEFAULT 'CREATED' COMMENT '园区状态',
    `visit_no` int NOT NULL DEFAULT '1' COMMENT '第几次到仓',
    `unload_round_no` int NOT NULL DEFAULT '1' COMMENT '作业轮次',
    `active_task_key` varchar(100) DEFAULT NULL COMMENT '活跃任务唯一键(source_order_type:source_order_id)，终态置NULL',
    `is_reentry` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否重复到仓',
    `reentry_reason` varchar(200) DEFAULT NULL COMMENT '重复到仓原因',
    `parent_task_id` bigint DEFAULT NULL COMMENT '上一次任务ID',
    `exception_flag` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否异常',
    `exception_reason` varchar(500) DEFAULT NULL COMMENT '异常原因',
    `source` varchar(30) NOT NULL DEFAULT 'OMS_PUSH' COMMENT '任务来源：OMS_PUSH/MANUAL',
    `remark` varchar(500) DEFAULT NULL,
    `creator` varchar(64) DEFAULT '' COMMENT '创建者',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater` varchar(64) DEFAULT '' COMMENT '更新者',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_yard_task_no` (`yard_task_no`,`tenant_id`),
    UNIQUE KEY `uk_active_task_key` (`active_task_key`),
    KEY `idx_source_order` (`source_order_type`,`source_order_id`),
    KEY `idx_warehouse_status` (`warehouse_id`,`yard_status`),
    KEY `idx_task_type_status` (`task_type`,`yard_status`),
    KEY `idx_dock_status` (`dock_id`,`yard_status`),
    KEY `idx_container_no` (`container_no`),
    KEY `idx_gate_in_time` (`gate_in_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='YMS园区任务主表';

CREATE TABLE IF NOT EXISTS `yms_yard_task_log` (
    `id` bigint NOT NULL COMMENT '主键',
    `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
    `yard_task_id` bigint NOT NULL COMMENT '园区任务ID',
    `action_type` varchar(50) NOT NULL COMMENT '操作类型',
    `before_status` varchar(30) DEFAULT NULL COMMENT '操作前状态',
    `after_status` varchar(30) DEFAULT NULL COMMENT '操作后状态',
    `action_content` text COMMENT '操作内容',
    `operator_id` bigint DEFAULT NULL,
    `operator_name` varchar(50) DEFAULT NULL,
    `action_time` datetime DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_yard_task_id` (`yard_task_id`),
    KEY `idx_action_time` (`action_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='园区任务操作日志';

CREATE TABLE IF NOT EXISTS `yms_appointment` (
    `id` bigint NOT NULL COMMENT '主键',
    `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
    `apt_no` varchar(64) NOT NULL COMMENT '预约编号（APT+日期+序号）',
    `warehouse_id` bigint NOT NULL COMMENT '仓库ID',
    `slot_template_id` bigint DEFAULT NULL COMMENT '时段模板ID',
    `apt_date` date NOT NULL COMMENT '预约日期（yyyy-MM-dd）',
    `apt_slot` varchar(20) NOT NULL COMMENT '时段（HH:mm-HH:mm）',
    `task_type` varchar(30) NOT NULL COMMENT '任务类型：DEVANNING/LOADING',
    `plate_no` varchar(30) NOT NULL COMMENT '车牌号',
    `driver_name` varchar(50) DEFAULT NULL COMMENT '司机姓名',
    `driver_phone` varchar(30) DEFAULT NULL COMMENT '司机电话',
    `container_no` varchar(64) DEFAULT NULL COMMENT '柜号（可选）',
    `source_order_no` varchar(64) DEFAULT NULL COMMENT '关联订单号（可选）',
    `status` varchar(20) NOT NULL DEFAULT 'PENDING' COMMENT '状态：PENDING/CONFIRMED/CANCELLED/COMPLETED/NO_SHOW',
    `yard_task_id` bigint DEFAULT NULL COMMENT '关联园区任务ID（签到后关联）',
    `cancel_reason` varchar(500) DEFAULT NULL COMMENT '取消原因',
    `remark` varchar(500) DEFAULT NULL,
    `creator` varchar(64) DEFAULT '' COMMENT '创建者',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater` varchar(64) DEFAULT '' COMMENT '更新者',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_apt_no_tenant` (`apt_no`, `tenant_id`),
    KEY `idx_warehouse_date_slot` (`warehouse_id`, `apt_date`, `apt_slot`),
    KEY `idx_plate_no_status` (`plate_no`, `status`),
    KEY `idx_status` (`status`),
    KEY `idx_apt_date` (`apt_date`),
    KEY `idx_yard_task_id` (`yard_task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='YMS预约表';

CREATE TABLE IF NOT EXISTS `yms_check_in` (
    `id` bigint NOT NULL COMMENT '主键',
    `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
    `warehouse_id` bigint NOT NULL COMMENT '仓库ID',
    `apt_id` bigint DEFAULT NULL COMMENT '预约ID（有预约时）',
    `apt_no` varchar(64) DEFAULT NULL COMMENT '预约编号（快照）',
    `yard_task_id` bigint DEFAULT NULL COMMENT '关联园区任务ID',
    `yard_task_no` varchar(64) DEFAULT NULL COMMENT '园区任务号（快照）',
    `plate_no` varchar(30) NOT NULL COMMENT '车牌号',
    `driver_name` varchar(50) DEFAULT NULL COMMENT '司机姓名',
    `driver_phone` varchar(30) DEFAULT NULL COMMENT '司机电话',
    `id_card_no` varchar(30) DEFAULT NULL COMMENT '身份证号',
    `container_no` varchar(64) DEFAULT NULL COMMENT '柜号',
    `task_type` varchar(30) DEFAULT NULL COMMENT '任务类型',
    `check_result` varchar(20) NOT NULL DEFAULT 'PENDING' COMMENT '检查结果：PASSED/REJECTED/BLACKLISTED/PENDING',
    `reject_reason` varchar(500) DEFAULT NULL COMMENT '拒绝原因',
    `match_type` varchar(20) NOT NULL DEFAULT 'WALK_IN' COMMENT '匹配方式：APT_MATCH/WALK_IN/MANUAL',
    `check_in_time` datetime DEFAULT NULL COMMENT '签到时间',
    `operator_id` bigint DEFAULT NULL COMMENT '操作员ID',
    `operator_name` varchar(50) DEFAULT NULL COMMENT '操作员姓名',
    `remark` varchar(500) DEFAULT NULL,
    `creator` varchar(64) DEFAULT '' COMMENT '创建者',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater` varchar(64) DEFAULT '' COMMENT '更新者',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
    PRIMARY KEY (`id`),
    KEY `idx_warehouse_result` (`warehouse_id`, `check_result`),
    KEY `idx_plate_no` (`plate_no`),
    KEY `idx_check_in_time` (`check_in_time`),
    KEY `idx_yard_task_id` (`yard_task_id`),
    KEY `idx_apt_id` (`apt_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='YMS门卫签到记录';

-- =============================================
-- 11. ALTER yms_yard_task 增加 Phase 1 新字段
-- MySQL 不支持 ADD COLUMN IF NOT EXISTS，使用存储过程幂等添加
-- =============================================
DROP PROCEDURE IF EXISTS yms_add_column_if_missing;
DELIMITER //
CREATE PROCEDURE yms_add_column_if_missing(
    IN p_table   VARCHAR(64),
    IN p_column  VARCHAR(64),
    IN p_def     TEXT
)
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = DATABASE()
          AND TABLE_NAME   = p_table
    ) AND NOT EXISTS (
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

-- =============================================
-- 12. ALTER yms_appointment 增加新字段
-- =============================================
CALL yms_add_column_if_missing('yms_appointment', 'appointment_rule_id',
    'BIGINT DEFAULT NULL COMMENT ''预约规则ID'' AFTER `slot_template_id`');
CALL yms_add_column_if_missing('yms_appointment', 'business_type',
    'VARCHAR(30) DEFAULT NULL COMMENT ''业务类型：DEVANNING/DELIVERY_LOADING/...'' AFTER `task_type`');
CALL yms_add_column_if_missing('yms_appointment', 'vehicle_source',
    'VARCHAR(30) DEFAULT NULL COMMENT ''车辆来源'' AFTER `business_type`');
CALL yms_add_column_if_missing('yms_appointment', 'trailer_no',
    'VARCHAR(64) DEFAULT NULL COMMENT ''车厢号'' AFTER `container_no`');
CALL yms_add_column_if_missing('yms_appointment', 'slot_start_time',
    'TIME DEFAULT NULL COMMENT ''预约时段开始时间'' AFTER `apt_slot`');
CALL yms_add_column_if_missing('yms_appointment', 'slot_end_time',
    'TIME DEFAULT NULL COMMENT ''预约时段结束时间'' AFTER `slot_start_time`');

-- =============================================
-- 13. ALTER yms_check_in 增加新字段
-- =============================================
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

-- =============================================
-- 14~20. 字典数据（已迁移，请勿在此执行）
-- 请单独执行：sql/migration-overall/02-yms-dict.sql
-- 原因：参考系统用 sys_dict_type/sys_dict_data，芋道用 system_dict_type/system_dict_data
-- =============================================

-- =============================================
-- 21. 新菜单（已跳过，见下方说明）
-- 请单独配置 YMS 菜单（system_menu 格式，参考 sql/mysql/oms-menu.sql）
-- 原因：参考系统用 sys_menu，芋道用 system_menu
-- =============================================
/*

INSERT IGNORE INTO sys_dict_data (tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_dept, create_by, create_time, remark) VALUES
('000000', 1, '海柜拆柜Dock',   'CONTAINER_DOCK',    'yms_dock_type', '', 'primary',  'N', 103, 1, NOW(), '专用海柜拆柜Dock'),
('000000', 2, '装车Dock',       'TRUCK_DOCK',         'yms_dock_type', '', 'success',  'Y', 103, 1, NOW(), '普通装车Dock'),
('000000', 3, '自提Dock',       'SELF_PICKUP_DOCK',   'yms_dock_type', '', 'info',     'N', 103, 1, NOW(), '自提专用Dock'),
('000000', 4, '混合Dock',       'MIXED_DOCK',         'yms_dock_type', '', 'warning',  'N', 103, 1, NOW(), '混合使用Dock');

-- Dock状态补充 RESERVED（已被占用而等待进场）
INSERT IGNORE INTO sys_dict_type (tenant_id, dict_name, dict_type, create_dept, create_by, create_time, remark) VALUES
('000000', 'YMS月台状态', 'yms_dock_status', 103, 1, NOW(), 'YMS月台运行状态');

INSERT IGNORE INTO sys_dict_data (tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_dept, create_by, create_time, remark) VALUES
('000000', 1, '空闲',    'IDLE',         'yms_dock_status', '', 'success', 'Y', 103, 1, NOW(), '可分配'),
('000000', 2, '已预占',  'RESERVED',     'yms_dock_status', '', 'warning', 'N', 103, 1, NOW(), '已分配待使用'),
('000000', 3, '作业中',  'OCCUPIED',     'yms_dock_status', '', 'primary', 'N', 103, 1, NOW(), '正在作业'),
('000000', 4, '维修',    'MAINTENANCE',  'yms_dock_status', '', 'error',   'N', 103, 1, NOW(), '维修中'),
('000000', 5, '停用',    'CLOSED',       'yms_dock_status', '', 'default', 'N', 103, 1, NOW(), '已停用');

-- =============================================
-- 15. 新字典：海柜资源
-- =============================================
INSERT IGNORE INTO sys_dict_type (tenant_id, dict_name, dict_type, create_dept, create_by, create_time, remark) VALUES
('000000', '海柜状态',   'yms_container_status', 103, 1, NOW(), '海柜在园区的状态'),
('000000', '海柜柜型',   'yms_container_type',   103, 1, NOW(), '海柜柜型'),
('000000', '重空状态',   'yms_empty_status',      103, 1, NOW(), '重柜/空柜状态');

INSERT IGNORE INTO sys_dict_data (tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_dept, create_by, create_time, remark) VALUES
-- 海柜状态
('000000', 1,  '预计到仓',     'EXPECTED_ARRIVAL',   'yms_container_status', '', 'default',  'Y', 103, 1, NOW(), '尚未到达'),
('000000', 2,  '运输中',       'IN_TRANSIT',          'yms_container_status', '', 'info',     'N', 103, 1, NOW(), '在途'),
('000000', 3,  '已到园区',     'ARRIVED',             'yms_container_status', '', 'primary',  'N', 103, 1, NOW(), '已签到'),
('000000', 4,  '已甩柜',       'DROPPED',             'yms_container_status', '', 'warning',  'N', 103, 1, NOW(), '甩柜等待'),
('000000', 5,  '等待拆柜',     'WAIT_DEVANNING',      'yms_container_status', '', 'warning',  'N', 103, 1, NOW(), '在等待队列中'),
('000000', 6,  '已上口',       'ON_DOCK',             'yms_container_status', '', 'primary',  'N', 103, 1, NOW(), '已到Dock'),
('000000', 7,  '拆柜中',       'DEVANNING',           'yms_container_status', '', 'primary',  'N', 103, 1, NOW(), 'WMS作业中'),
('000000', 8,  '拆柜完成',     'DEVANNED',            'yms_container_status', '', 'success',  'N', 103, 1, NOW(), '拆柜已完成'),
('000000', 9,  '空柜待还',     'EMPTY_WAIT_RETURN',   'yms_container_status', '', 'warning',  'N', 103, 1, NOW(), '等待还柜'),
('000000', 10, '已还柜',       'RETURNED',            'yms_container_status', '', 'success',  'N', 103, 1, NOW(), '已还柜'),
('000000', 11, '已离园',       'LEFT_YARD',           'yms_container_status', '', 'default',  'N', 103, 1, NOW(), '已离场'),
('000000', 12, '异常',         'EXCEPTION',           'yms_container_status', '', 'error',    'N', 103, 1, NOW(), '异常状态'),
-- 柜型
('000000', 1, '40HQ', '40HQ', 'yms_container_type', '', 'primary', 'Y', 103, 1, NOW(), '40尺高柜'),
('000000', 2, '45HQ', '45HQ', 'yms_container_type', '', 'success', 'N', 103, 1, NOW(), '45尺高柜'),
('000000', 3, '53FT', '53FT', 'yms_container_type', '', 'info',    'N', 103, 1, NOW(), '53尺平柜'),
('000000', 4, '20GP', '20GP', 'yms_container_type', '', 'default', 'N', 103, 1, NOW(), '20尺标准柜'),
('000000', 5, '40GP', '40GP', 'yms_container_type', '', 'default', 'N', 103, 1, NOW(), '40尺标准柜'),
-- 重空状态
('000000', 1, '重柜', 'FULL',  'yms_empty_status', '', 'primary', 'Y', 103, 1, NOW(), '有货重柜'),
('000000', 2, '空柜', 'EMPTY', 'yms_empty_status', '', 'default', 'N', 103, 1, NOW(), '空柜');

-- =============================================
-- 16. 新字典：车厢资源
-- =============================================
INSERT IGNORE INTO sys_dict_type (tenant_id, dict_name, dict_type, create_dept, create_by, create_time, remark) VALUES
('000000', '车厢状态',   'yms_trailer_status',  103, 1, NOW(), '车厢在园区的状态'),
('000000', '车辆来源',   'yms_vehicle_source',  103, 1, NOW(), '车辆/车厢来源类型');

INSERT IGNORE INTO sys_dict_data (tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_dept, create_by, create_time, remark) VALUES
-- 车厢状态
('000000', 1, '预计到仓',     'EXPECTED_ARRIVAL', 'yms_trailer_status', '', 'default',  'Y', 103, 1, NOW(), '尚未到达'),
('000000', 2, '空车厢已到',   'ARRIVED_EMPTY',    'yms_trailer_status', '', 'info',     'N', 103, 1, NOW(), '空车厢到仓'),
('000000', 3, '等待装车',     'WAIT_LOADING',     'yms_trailer_status', '', 'warning',  'N', 103, 1, NOW(), '在等待队列'),
('000000', 4, '已上口',       'ON_DOCK',          'yms_trailer_status', '', 'primary',  'N', 103, 1, NOW(), '已到Dock'),
('000000', 5, '装车中',       'LOADING',          'yms_trailer_status', '', 'primary',  'N', 103, 1, NOW(), 'WMS装车中'),
('000000', 6, '装车完成',     'LOADED',           'yms_trailer_status', '', 'success',  'N', 103, 1, NOW(), '装车已完成'),
('000000', 7, '等待提走',     'WAIT_PICKUP',      'yms_trailer_status', '', 'warning',  'N', 103, 1, NOW(), '等待车头提走（租赁车厢）'),
('000000', 8, '已离场',       'LEFT_YARD',        'yms_trailer_status', '', 'default',  'N', 103, 1, NOW(), '已离场'),
('000000', 9, '异常',         'EXCEPTION',        'yms_trailer_status', '', 'error',    'N', 103, 1, NOW(), '异常状态'),
-- 车辆来源
('000000', 1, '供应商车辆',   'SUPPLIER_TRUCK',  'yms_vehicle_source', '', 'primary', 'Y', 103, 1, NOW(), '供应商自带车头+车厢'),
('000000', 2, '租赁车厢',     'RENTED_TRAILER',  'yms_vehicle_source', '', 'info',    'N', 103, 1, NOW(), '我方租赁车厢（空车厢先到）'),
('000000', 3, '自有车厢',     'OWN_TRAILER',     'yms_vehicle_source', '', 'success', 'N', 103, 1, NOW(), '自有车厢'),
('000000', 4, '临时车辆',     'TEMP_TRUCK',      'yms_vehicle_source', '', 'warning', 'N', 103, 1, NOW(), '临时外部车辆');

-- =============================================
-- 17. 新字典：堆场位
-- =============================================
INSERT IGNORE INTO sys_dict_type (tenant_id, dict_name, dict_type, create_dept, create_by, create_time, remark) VALUES
('000000', '堆场位类型',   'yms_position_type',   103, 1, NOW(), '堆场位位置类型'),
('000000', '堆场位状态',   'yms_position_status', 103, 1, NOW(), '堆场位占用状态');

INSERT IGNORE INTO sys_dict_data (tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_dept, create_by, create_time, remark) VALUES
-- 堆场位类型
('000000', 1, '海柜位',     'CONTAINER_SLOT',       'yms_position_type', '', 'primary', 'Y', 103, 1, NOW(), '存放重柜/在场海柜'),
('000000', 2, '空柜位',     'EMPTY_CONTAINER_SLOT', 'yms_position_type', '', 'info',    'N', 103, 1, NOW(), '存放空柜'),
('000000', 3, '车厢位',     'TRAILER_SLOT',         'yms_position_type', '', 'success', 'N', 103, 1, NOW(), '存放车厢'),
('000000', 4, '临时等待位', 'WAITING_SLOT',         'yms_position_type', '', 'warning', 'N', 103, 1, NOW(), '临时等待/暂存'),
('000000', 5, '禁用位',     'BLOCKED_SLOT',         'yms_position_type', '', 'error',   'N', 103, 1, NOW(), '禁用/不可用'),
-- 堆场位状态
('000000', 1, '空闲',     'FREE',     'yms_position_status', '', 'success', 'Y', 103, 1, NOW(), '可使用'),
('000000', 2, '占用中',   'OCCUPIED', 'yms_position_status', '', 'primary', 'N', 103, 1, NOW(), '已有对象'),
('000000', 3, '已预占',   'RESERVED', 'yms_position_status', '', 'warning', 'N', 103, 1, NOW(), '已分配待使用'),
('000000', 4, '禁用',     'DISABLED', 'yms_position_status', '', 'default', 'N', 103, 1, NOW(), '不可用');

-- =============================================
-- 18. 新字典：院内任务
-- =============================================
INSERT IGNORE INTO sys_dict_type (tenant_id, dict_name, dict_type, create_dept, create_by, create_time, remark) VALUES
('000000', '院内任务类型',   'yms_internal_task_type',   103, 1, NOW(), '院内任务类型'),
('000000', '院内任务状态',   'yms_internal_task_status', 103, 1, NOW(), '院内任务执行状态');

INSERT IGNORE INTO sys_dict_data (tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_dept, create_by, create_time, remark) VALUES
-- 院内任务类型
('000000', 1, '海柜上口',     'CONTAINER_TO_DOCK',    'yms_internal_task_type', '', 'primary', 'N', 103, 1, NOW(), '海柜移到Dock'),
('000000', 2, '海柜下口',     'CONTAINER_OFF_DOCK',   'yms_internal_task_type', '', 'success', 'N', 103, 1, NOW(), '海柜离开Dock'),
('000000', 3, '车厢上口',     'TRAILER_TO_DOCK',      'yms_internal_task_type', '', 'primary', 'N', 103, 1, NOW(), '车厢移到Dock'),
('000000', 4, '车厢下口',     'TRAILER_OFF_DOCK',     'yms_internal_task_type', '', 'success', 'N', 103, 1, NOW(), '车厢离开Dock'),
('000000', 5, '院内挪柜',     'CONTAINER_MOVE',       'yms_internal_task_type', '', 'warning', 'N', 103, 1, NOW(), '柜子在堆场内移动'),
('000000', 6, '院内挪车厢',   'TRAILER_MOVE',         'yms_internal_task_type', '', 'warning', 'N', 103, 1, NOW(), '车厢在堆场内移动'),
('000000', 7, '空柜还柜',     'EMPTY_CONTAINER_RETURN','yms_internal_task_type','', 'info',    'N', 103, 1, NOW(), '空柜移至还柜区'),
('000000', 8, '园区盘点',     'YARD_INVENTORY_SCAN',  'yms_internal_task_type', '', 'default', 'N', 103, 1, NOW(), '盘点扫描'),
-- 院内任务状态
('000000', 1, '待分配', 'PENDING',     'yms_internal_task_status', '', 'default', 'Y', 103, 1, NOW(), '等待分配执行人'),
('000000', 2, '已分配', 'ASSIGNED',    'yms_internal_task_status', '', 'info',    'N', 103, 1, NOW(), '已分配执行人'),
('000000', 3, '已接单', 'ACCEPTED',    'yms_internal_task_status', '', 'warning', 'N', 103, 1, NOW(), '执行人已接受'),
('000000', 4, '执行中', 'IN_PROGRESS', 'yms_internal_task_status', '', 'primary', 'N', 103, 1, NOW(), '正在执行'),
('000000', 5, '已完成', 'COMPLETED',   'yms_internal_task_status', '', 'success', 'N', 103, 1, NOW(), '执行完成'),
('000000', 6, '失败',   'FAILED',      'yms_internal_task_status', '', 'error',   'N', 103, 1, NOW(), '执行失败'),
('000000', 7, '已取消', 'CANCELLED',   'yms_internal_task_status', '', 'default', 'N', 103, 1, NOW(), '已取消');

-- =============================================
-- 19. 更新 yms_task_type 字典（完整版）
-- =============================================
INSERT IGNORE INTO sys_dict_type (tenant_id, dict_name, dict_type, create_dept, create_by, create_time, remark) VALUES
('000000', '园区任务类型', 'yms_task_type', 103, 1, NOW(), 'YMS园区任务类型');

INSERT IGNORE INTO sys_dict_data (tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_dept, create_by, create_time, remark) VALUES
('000000', 1, '拆柜',     'DEVANNING',          'yms_task_type', '', 'primary', 'Y', 103, 1, NOW(), '海柜拆柜任务'),
('000000', 2, '派送装车', 'DELIVERY_LOADING',   'yms_task_type', '', 'success', 'N', 103, 1, NOW(), '派送出库装车'),
('000000', 3, '调拨装车', 'TRANSFER_LOADING',   'yms_task_type', '', 'info',    'N', 103, 1, NOW(), '调拨装车'),
('000000', 4, '自提装车', 'PICKUP_LOADING',     'yms_task_type', '', 'warning', 'N', 103, 1, NOW(), '自提客户'),
('000000', 5, '退货装车', 'RETURN_LOADING',     'yms_task_type', '', 'error',   'N', 103, 1, NOW(), '退货装车'),
('000000', 6, '院内挪柜', 'INTERNAL_MOVE',      'yms_task_type', '', 'default', 'N', 103, 1, NOW(), '院内挪柜任务'),
('000000', 7, '园区盘点', 'YARD_INVENTORY',     'yms_task_type', '', 'default', 'N', 103, 1, NOW(), '园区盘点任务');

-- =============================================
-- 20. 更新 yms_yard_status 字典（完整状态）
-- =============================================
INSERT IGNORE INTO sys_dict_type (tenant_id, dict_name, dict_type, create_dept, create_by, create_time, remark) VALUES
('000000', '拆柜任务状态', 'yms_devanning_status', 103, 1, NOW(), '拆柜园区任务状态'),
('000000', '装车任务状态', 'yms_loading_status',   103, 1, NOW(), '装车园区任务状态');

INSERT IGNORE INTO sys_dict_data (tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_dept, create_by, create_time, remark) VALUES
-- 拆柜状态
('000000', 1,  '已创建',     'CREATED',           'yms_devanning_status', '', 'default', 'N', 103, 1, NOW(), ''),
('000000', 2,  '等待到仓',   'WAIT_CONTAINER',    'yms_devanning_status', '', 'default', 'N', 103, 1, NOW(), '海柜尚未到仓'),
('000000', 3,  '海柜已到',   'CONTAINER_ARRIVED', 'yms_devanning_status', '', 'info',    'N', 103, 1, NOW(), ''),
('000000', 4,  '已分配位置', 'YARD_ASSIGNED',     'yms_devanning_status', '', 'info',    'N', 103, 1, NOW(), '已分配堆场位'),
('000000', 5,  '等待叫号',   'WAIT_CALL',         'yms_devanning_status', '', 'warning', 'N', 103, 1, NOW(), ''),
('000000', 6,  '已叫号',     'CALLED',            'yms_devanning_status', '', 'primary', 'N', 103, 1, NOW(), ''),
('000000', 7,  '上口中',     'MOVE_TO_DOCK',      'yms_devanning_status', '', 'primary', 'N', 103, 1, NOW(), ''),
('000000', 8,  '已上口',     'ON_DOCK',           'yms_devanning_status', '', 'primary', 'N', 103, 1, NOW(), ''),
('000000', 9,  'WMS拆柜中',  'WMS_WORKING',       'yms_devanning_status', '', 'primary', 'N', 103, 1, NOW(), ''),
('000000', 10, 'WMS完成',    'WMS_FINISHED',      'yms_devanning_status', '', 'success', 'N', 103, 1, NOW(), ''),
('000000', 11, '下口中',     'MOVE_OFF_DOCK',     'yms_devanning_status', '', 'info',    'N', 103, 1, NOW(), ''),
('000000', 12, '空柜待还',   'WAIT_RETURN',       'yms_devanning_status', '', 'warning', 'N', 103, 1, NOW(), ''),
('000000', 13, '已离园',     'LEFT_YARD',         'yms_devanning_status', '', 'default', 'N', 103, 1, NOW(), 'Y'),
('000000', 14, '已取消',     'CANCELLED',         'yms_devanning_status', '', 'default', 'N', 103, 1, NOW(), ''),
('000000', 15, '异常',       'EXCEPTION',         'yms_devanning_status', '', 'error',   'N', 103, 1, NOW(), ''),
-- 装车状态
('000000', 1,  '已创建',        'CREATED',          'yms_loading_status', '', 'default', 'Y', 103, 1, NOW(), ''),
('000000', 2,  '等待WMS备货',   'WAIT_WMS_READY',   'yms_loading_status', '', 'default', 'N', 103, 1, NOW(), ''),
('000000', 3,  '等待车辆到仓',  'WAIT_VEHICLE',     'yms_loading_status', '', 'warning', 'N', 103, 1, NOW(), ''),
('000000', 4,  '车辆已到仓',    'VEHICLE_ARRIVED',  'yms_loading_status', '', 'info',    'N', 103, 1, NOW(), ''),
('000000', 5,  '等待叫号',      'WAIT_CALL',        'yms_loading_status', '', 'warning', 'N', 103, 1, NOW(), ''),
('000000', 6,  '已叫号',        'CALLED',           'yms_loading_status', '', 'primary', 'N', 103, 1, NOW(), ''),
('000000', 7,  '上口中',        'MOVE_TO_DOCK',     'yms_loading_status', '', 'primary', 'N', 103, 1, NOW(), ''),
('000000', 8,  '已上口',        'ON_DOCK',          'yms_loading_status', '', 'primary', 'N', 103, 1, NOW(), ''),
('000000', 9,  'WMS装车中',     'WMS_LOADING',      'yms_loading_status', '', 'primary', 'N', 103, 1, NOW(), ''),
('000000', 10, 'WMS装车完成',   'WMS_LOADED',       'yms_loading_status', '', 'success', 'N', 103, 1, NOW(), ''),
('000000', 11, '下口中',        'MOVE_OFF_DOCK',    'yms_loading_status', '', 'info',    'N', 103, 1, NOW(), ''),
('000000', 12, '等待离场',      'WAIT_LEAVE',       'yms_loading_status', '', 'warning', 'N', 103, 1, NOW(), ''),
('000000', 13, '已离园',        'LEFT_YARD',        'yms_loading_status', '', 'default', 'N', 103, 1, NOW(), ''),
('000000', 14, '已取消',        'CANCELLED',        'yms_loading_status', '', 'default', 'N', 103, 1, NOW(), ''),
('000000', 15, '异常',          'EXCEPTION',        'yms_loading_status', '', 'error',   'N', 103, 1, NOW(), '');

-- =============================================
-- 21. 新菜单：Phase 1 新增模块
-- =============================================
SET @YMS_PARENT_ID = (SELECT menu_id FROM sys_menu WHERE menu_name = 'YMS' AND parent_id = 0 LIMIT 1);

-- 海柜资源管理
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time)
VALUES ('海柜资源', @YMS_PARENT_ID, 40, 'yms/container', 'yms/container/index', 1, 0, 'C', '0', '0', 'yms:containerResource:list', 'ep:box', 103, 1, NOW());
SET @CONTAINER_MENU = LAST_INSERT_ID();
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, menu_type, visible, status, perms, create_dept, create_by, create_time) VALUES
('海柜资源查询', @CONTAINER_MENU, 1, '#', 'F', '0', '0', 'yms:containerResource:query',  103, 1, NOW()),
('海柜资源新增', @CONTAINER_MENU, 2, '#', 'F', '0', '0', 'yms:containerResource:add',    103, 1, NOW()),
('海柜资源编辑', @CONTAINER_MENU, 3, '#', 'F', '0', '0', 'yms:containerResource:edit',   103, 1, NOW()),
('海柜资源删除', @CONTAINER_MENU, 4, '#', 'F', '0', '0', 'yms:containerResource:remove', 103, 1, NOW()),
('海柜分配堆场位', @CONTAINER_MENU, 5, '#', 'F', '0', '0', 'yms:containerResource:assignPosition', 103, 1, NOW()),
('海柜叫号',     @CONTAINER_MENU, 6, '#', 'F', '0', '0', 'yms:containerResource:call',   103, 1, NOW());

-- 车厢资源管理
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time)
VALUES ('车厢资源', @YMS_PARENT_ID, 41, 'yms/trailer', 'yms/trailer/index', 1, 0, 'C', '0', '0', 'yms:trailerResource:list', 'ep:truck', 103, 1, NOW());
SET @TRAILER_MENU = LAST_INSERT_ID();
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, menu_type, visible, status, perms, create_dept, create_by, create_time) VALUES
('车厢资源查询', @TRAILER_MENU, 1, '#', 'F', '0', '0', 'yms:trailerResource:query',  103, 1, NOW()),
('车厢资源新增', @TRAILER_MENU, 2, '#', 'F', '0', '0', 'yms:trailerResource:add',    103, 1, NOW()),
('车厢资源编辑', @TRAILER_MENU, 3, '#', 'F', '0', '0', 'yms:trailerResource:edit',   103, 1, NOW()),
('车厢资源删除', @TRAILER_MENU, 4, '#', 'F', '0', '0', 'yms:trailerResource:remove', 103, 1, NOW()),
('车厢叫号',     @TRAILER_MENU, 5, '#', 'F', '0', '0', 'yms:trailerResource:call',   103, 1, NOW());

-- 堆场位管理
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time)
VALUES ('堆场位管理', @YMS_PARENT_ID, 72, 'yms/yard-position', 'yms/yard-position/index', 1, 0, 'C', '0', '0', 'yms:yardPosition:list', 'ep:location', 103, 1, NOW());
SET @POS_MENU = LAST_INSERT_ID();
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, menu_type, visible, status, perms, create_dept, create_by, create_time) VALUES
('堆场位查询', @POS_MENU, 1, '#', 'F', '0', '0', 'yms:yardPosition:query',  103, 1, NOW()),
('堆场位新增', @POS_MENU, 2, '#', 'F', '0', '0', 'yms:yardPosition:add',    103, 1, NOW()),
('堆场位编辑', @POS_MENU, 3, '#', 'F', '0', '0', 'yms:yardPosition:edit',   103, 1, NOW()),
('堆场位删除', @POS_MENU, 4, '#', 'F', '0', '0', 'yms:yardPosition:remove', 103, 1, NOW());

-- 拆柜调度中心
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time)
VALUES ('拆柜调度', @YMS_PARENT_ID, 60, 'yms/devanning-dispatch', 'yms/devanning-dispatch/index', 1, 0, 'C', '0', '0', 'yms:dispatch:devanning', 'ep:operation', 103, 1, NOW());
SET @DEV_DISPATCH_MENU = LAST_INSERT_ID();
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, menu_type, visible, status, perms, create_dept, create_by, create_time) VALUES
('拆柜调度查看',   @DEV_DISPATCH_MENU, 1, '#', 'F', '0', '0', 'yms:dispatch:devanning',    103, 1, NOW()),
('手动叫号',       @DEV_DISPATCH_MENU, 2, '#', 'F', '0', '0', 'yms:dispatch:manualCall',   103, 1, NOW()),
('分配Dock',       @DEV_DISPATCH_MENU, 3, '#', 'F', '0', '0', 'yms:dispatch:assignDock',   103, 1, NOW()),
('调整优先级',     @DEV_DISPATCH_MENU, 4, '#', 'F', '0', '0', 'yms:dispatch:setPriority',  103, 1, NOW());

-- 装车调度中心
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time)
VALUES ('装车调度', @YMS_PARENT_ID, 61, 'yms/loading-dispatch', 'yms/loading-dispatch/index', 1, 0, 'C', '0', '0', 'yms:dispatch:loading', 'ep:van', 103, 1, NOW());
SET @LOAD_DISPATCH_MENU = LAST_INSERT_ID();
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, menu_type, visible, status, perms, create_dept, create_by, create_time) VALUES
('装车调度查看', @LOAD_DISPATCH_MENU, 1, '#', 'F', '0', '0', 'yms:dispatch:loading',    103, 1, NOW()),
('手动叫号',     @LOAD_DISPATCH_MENU, 2, '#', 'F', '0', '0', 'yms:dispatch:manualCall', 103, 1, NOW()),
('分配Dock',     @LOAD_DISPATCH_MENU, 3, '#', 'F', '0', '0', 'yms:dispatch:assignDock', 103, 1, NOW());

-- 院内任务中心
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time)
VALUES ('院内任务', @YMS_PARENT_ID, 50, 'yms/internal-task', 'yms/internal-task/index', 1, 0, 'C', '0', '0', 'yms:internalTask:list', 'ep:list', 103, 1, NOW());
SET @ITASK_MENU = LAST_INSERT_ID();
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, menu_type, visible, status, perms, create_dept, create_by, create_time) VALUES
('院内任务查询', @ITASK_MENU, 1, '#', 'F', '0', '0', 'yms:internalTask:query',   103, 1, NOW()),
('分配执行人',   @ITASK_MENU, 2, '#', 'F', '0', '0', 'yms:internalTask:assign',  103, 1, NOW()),
('开始任务',     @ITASK_MENU, 3, '#', 'F', '0', '0', 'yms:internalTask:start',   103, 1, NOW()),
('完成任务',     @ITASK_MENU, 4, '#', 'F', '0', '0', 'yms:internalTask:complete',103, 1, NOW()),
('取消任务',     @ITASK_MENU, 5, '#', 'F', '0', '0', 'yms:internalTask:cancel',  103, 1, NOW());

-- 预约规则配置
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time)
VALUES ('预约规则', @YMS_PARENT_ID, 11, 'yms/appointment-rule', 'yms/appointment-rule/index', 1, 0, 'C', '0', '0', 'yms:appointmentRule:list', 'ep:setting', 103, 1, NOW());
SET @APT_RULE_MENU = LAST_INSERT_ID();
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, menu_type, visible, status, perms, create_dept, create_by, create_time) VALUES
('预约规则查询', @APT_RULE_MENU, 1, '#', 'F', '0', '0', 'yms:appointmentRule:query',  103, 1, NOW()),
('预约规则新增', @APT_RULE_MENU, 2, '#', 'F', '0', '0', 'yms:appointmentRule:add',    103, 1, NOW()),
('预约规则编辑', @APT_RULE_MENU, 3, '#', 'F', '0', '0', 'yms:appointmentRule:edit',   103, 1, NOW()),
('预约规则删除', @APT_RULE_MENU, 4, '#', 'F', '0', '0', 'yms:appointmentRule:remove', 103, 1, NOW()),
('启用/禁用',   @APT_RULE_MENU, 5, '#', 'F', '0', '0', 'yms:appointmentRule:toggle', 103, 1, NOW());

-- 叫号规则配置
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_dept, create_by, create_time)
VALUES ('叫号规则', @YMS_PARENT_ID, 62, 'yms/call-rule', 'yms/call-rule/index', 1, 0, 'C', '0', '0', 'yms:callRule:list', 'ep:phone', 103, 1, NOW());
SET @CALL_RULE_MENU = LAST_INSERT_ID();
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, menu_type, visible, status, perms, create_dept, create_by, create_time) VALUES
('叫号规则查询', @CALL_RULE_MENU, 1, '#', 'F', '0', '0', 'yms:callRule:query',  103, 1, NOW()),
('叫号规则新增', @CALL_RULE_MENU, 2, '#', 'F', '0', '0', 'yms:callRule:add',    103, 1, NOW()),
('叫号规则编辑', @CALL_RULE_MENU, 3, '#', 'F', '0', '0', 'yms:callRule:edit',   103, 1, NOW()),
('叫号规则删除', @CALL_RULE_MENU, 4, '#', 'F', '0', '0', 'yms:callRule:remove', 103, 1, NOW()),
('启用/禁用',   @CALL_RULE_MENU, 5, '#', 'F', '0', '0', 'yms:callRule:toggle', 103, 1, NOW());
-- DEPRECATED for YMS Phase 1 simplified scope.
-- Do not execute this legacy redesign script after 2026-05-30.
-- Use yms_phase1_cleanup_20260530.sql and yms_phase1_final_sync_20260530.sql instead.
*/

-- ========== yms_m1_m7_migration_20260529.sql ==========
-- =============================================
-- YMS M1-M7 新增表结构迁移脚本
-- 日期：2026-05-29
-- 包含：堆场分区、黑名单（直接按车牌/电话）、时段模板、预约、门卫签到、YardGo机器人任务
-- 注：车队/司机/车辆无需预注册，车辆信息由预约或签到时采集
-- =============================================

-- =============================================
-- M7 堆场分区表
-- =============================================
CREATE TABLE IF NOT EXISTS `yms_yard_zone` (
    `id`            BIGINT          NOT NULL                    COMMENT '主键',
    `tenant_id`     BIGINT          NOT NULL DEFAULT 0          COMMENT '租户编号',
    `warehouse_id`  BIGINT          NOT NULL                    COMMENT '仓库ID',
    `zone_code`     VARCHAR(30)     NOT NULL                    COMMENT '分区编码',
    `zone_name`     VARCHAR(100)    NOT NULL                    COMMENT '分区名称',
    `zone_type`     VARCHAR(30)     NOT NULL DEFAULT 'CONTAINER' COMMENT '分区类型：CONTAINER/TRUCK/SELF_PICKUP/PARKING',
    `sort_order`    INT             DEFAULT NULL                COMMENT '排序',
    `remark`        VARCHAR(500)    DEFAULT NULL,
    `creator`       VARCHAR(64)     DEFAULT ''                  COMMENT '创建者',
    `create_time`   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`       VARCHAR(64)     DEFAULT ''                  COMMENT '更新者',
    `update_time`   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`       BIT(1)          NOT NULL DEFAULT b'0'       COMMENT '是否删除',
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
    `tenant_id`         BIGINT          NOT NULL DEFAULT 0          COMMENT '租户编号',
    `target_type`       VARCHAR(20)     NOT NULL                    COMMENT '拦截类型：PLATE_NO车牌/DRIVER_PHONE司机电话',
    `target_value`      VARCHAR(100)    NOT NULL                    COMMENT '拦截值（车牌号或司机电话）',
    `reason`            VARCHAR(500)    NOT NULL                    COMMENT '加入原因',
    `blacklist_time`    DATETIME        DEFAULT NULL                COMMENT '加入时间',
    `expire_time`       DATETIME        DEFAULT NULL                COMMENT '过期时间（NULL=永久）',
    `status`            VARCHAR(20)     NOT NULL DEFAULT 'ACTIVE'   COMMENT '状态：ACTIVE/EXPIRED/REMOVED',
    `operator_id`       BIGINT          DEFAULT NULL                COMMENT '操作员ID',
    `operator_name`     VARCHAR(50)     DEFAULT NULL                COMMENT '操作员姓名（快照）',
    `remark`            VARCHAR(500)    DEFAULT NULL,
    `creator`               VARCHAR(64)     DEFAULT ''                    COMMENT '创建者',
    `create_time`           DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`               VARCHAR(64)     DEFAULT ''                    COMMENT '更新者',
    `update_time`           DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`               BIT(1)          NOT NULL DEFAULT b'0'         COMMENT '是否删除',
    PRIMARY KEY (`id`),
    KEY `idx_type_value` (`target_type`, `target_value`),
    KEY `idx_status` (`status`),
    KEY `idx_expire_time` (`expire_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='YMS黑名单（车牌/手机号直接拦截）';

-- =============================================
-- M1 时段模板表
-- =============================================
CREATE TABLE IF NOT EXISTS `yms_slot_template` (
    `id`            BIGINT          NOT NULL                    COMMENT '主键',
    `tenant_id`     BIGINT          NOT NULL DEFAULT 0          COMMENT '租户编号',
    `warehouse_id`  BIGINT          NOT NULL                    COMMENT '仓库ID',
    `weekdays`      VARCHAR(20)     NOT NULL                    COMMENT '适用星期（逗号分隔，1=周一...7=周日，如 1,2,3,4,5）',
    `slot_start`    VARCHAR(10)     NOT NULL                    COMMENT '开始时间（HH:mm）',
    `slot_end`      VARCHAR(10)     NOT NULL                    COMMENT '结束时间（HH:mm）',
    `capacity`      INT             NOT NULL DEFAULT 10         COMMENT '容量（该时段最大预约数）',
    `task_type`     VARCHAR(30)     NOT NULL DEFAULT 'ALL'      COMMENT '适用任务类型：DEVANNING/LOADING/ALL',
    `enabled`       TINYINT(1)      NOT NULL DEFAULT 1          COMMENT '是否启用(0否1是)',
    `remark`        VARCHAR(500)    DEFAULT NULL,
    `creator`       VARCHAR(64)     DEFAULT ''                  COMMENT '创建者',
    `create_time`   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`       VARCHAR(64)     DEFAULT ''                  COMMENT '更新者',
    `update_time`   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`       BIT(1)          NOT NULL DEFAULT b'0'       COMMENT '是否删除',
    PRIMARY KEY (`id`),
    KEY `idx_warehouse_enabled` (`warehouse_id`, `enabled`),
    KEY `idx_task_type` (`task_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='YMS预约时段模板';

-- =============================================
-- M1 预约表（已在 10.5 节创建，此处保留兼容注释）
-- CREATE TABLE IF NOT EXISTS `yms_appointment` ...

-- =============================================
-- M2 门卫签到表（已在 10.5 节创建，此处跳过重复建表）
-- CREATE TABLE IF NOT EXISTS `yms_check_in` ...

-- =============================================
-- M5 YardGo 机器人任务表
-- =============================================
CREATE TABLE `yms_yardgo_task` (
    `id`                BIGINT          NOT NULL                    COMMENT '主键',
    `tenant_id`         BIGINT          NOT NULL DEFAULT 0          COMMENT '租户编号',
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
    `creator`               VARCHAR(64)     DEFAULT ''                    COMMENT '创建者',
    `create_time`           DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`               VARCHAR(64)     DEFAULT ''                    COMMENT '更新者',
    `update_time`           DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`               BIT(1)          NOT NULL DEFAULT b'0'         COMMENT '是否删除',
    PRIMARY KEY (`id`),
    KEY `idx_yard_task_id` (`yard_task_id`),
    KEY `idx_robot_task_id` (`robot_task_id`),
    KEY `idx_robot_status` (`robot_status`),
    KEY `idx_warehouse_status` (`warehouse_id`, `robot_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='YMS YardGo机器人任务表';

-- =============================================
-- 缺失表补全（盘点 / Dock 排队）
-- =============================================
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

-- =============================================
-- 字典数据初始化（已迁移，请执行 02-yms-dict.sql）
-- 菜单权限初始化（待转为 system_menu 格式）
-- =============================================
/*

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
*/

-- ========== yms_missing_columns_patch.sql ==========
-- =============================================
-- YMS 缺失字段补丁（一次性执行）
-- 日期：2026-05-31
-- 说明：可重复执行，列已存在则自动跳过
-- =============================================

DROP PROCEDURE IF EXISTS _add_col;
DELIMITER //
CREATE PROCEDURE _add_col(IN t VARCHAR(64), IN c VARCHAR(64), IN def TEXT)
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = t
    ) AND NOT EXISTS (
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

-- ========== yms_phase1_alter_patch_20260529.sql ==========
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
    IF EXISTS (
        SELECT 1 FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = DATABASE()
          AND TABLE_NAME   = p_table
    ) AND NOT EXISTS (
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

-- ========== yms_gate_checkout_alter_20260529.sql ==========
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

-- ========== yms_gate_checkout_driver_20260529.sql ==========
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

-- ========== yms_yardgo_task_flow_patch_20260531.sql ==========
-- =============================================
-- YMS YardGo 任务流调整
-- 日期：2026-05-31
-- 口径：
--   1. 停车位统一按堆场位理解；
--   2. 院内任务采用司机自领取模式，PENDING = 待领取；
--   3. ASSIGNED 仅作为未来调度派单预留，不作为当前必经状态；
--   4. 上口、换 Dock、下口均通过 YardGo 院内任务执行。
-- 以下 sys_dict_* 已迁移至 02-yms-dict.sql
-- =============================================
/*

INSERT INTO sys_dict_type
    (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, remark)
SELECT 6000003600, '000000', 'YMS院内任务状态', 'yms_internal_task_status', 1, NOW(), 'YardGo院内任务状态'
WHERE NOT EXISTS (
    SELECT 1 FROM sys_dict_type WHERE dict_type = 'yms_internal_task_status'
);

INSERT INTO sys_dict_data
    (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
SELECT 6000003601, '000000', 1, '待领取', 'PENDING', 'yms_internal_task_status', '', 'default', 'Y', 1, NOW(), '等待 YardGo 司机领取'
WHERE NOT EXISTS (
    SELECT 1 FROM sys_dict_data WHERE dict_type = 'yms_internal_task_status' AND dict_value = 'PENDING'
);

INSERT INTO sys_dict_data
    (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
SELECT 6000003602, '000000', 2, '已分配', 'ASSIGNED', 'yms_internal_task_status', '', 'info', 'N', 1, NOW(), '预留状态：未来如启用调度派单，可用于已分配执行人'
WHERE NOT EXISTS (
    SELECT 1 FROM sys_dict_data WHERE dict_type = 'yms_internal_task_status' AND dict_value = 'ASSIGNED'
);

INSERT INTO sys_dict_data
    (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
SELECT 6000003603, '000000', 3, '已领取', 'ACCEPTED', 'yms_internal_task_status', '', 'warning', 'N', 1, NOW(), 'YardGo 司机已领取'
WHERE NOT EXISTS (
    SELECT 1 FROM sys_dict_data WHERE dict_type = 'yms_internal_task_status' AND dict_value = 'ACCEPTED'
);

INSERT INTO sys_dict_data
    (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
SELECT 6000003604, '000000', 4, '执行中', 'IN_PROGRESS', 'yms_internal_task_status', '', 'processing', 'N', 1, NOW(), 'YardGo任务执行中'
WHERE NOT EXISTS (
    SELECT 1 FROM sys_dict_data WHERE dict_type = 'yms_internal_task_status' AND dict_value = 'IN_PROGRESS'
);

INSERT INTO sys_dict_data
    (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
SELECT 6000003605, '000000', 5, '已完成', 'COMPLETED', 'yms_internal_task_status', '', 'success', 'N', 1, NOW(), 'YardGo任务已完成'
WHERE NOT EXISTS (
    SELECT 1 FROM sys_dict_data WHERE dict_type = 'yms_internal_task_status' AND dict_value = 'COMPLETED'
);

INSERT INTO sys_dict_data
    (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
SELECT 6000003606, '000000', 6, '异常', 'FAILED', 'yms_internal_task_status', '', 'error', 'N', 1, NOW(), 'YardGo任务异常'
WHERE NOT EXISTS (
    SELECT 1 FROM sys_dict_data WHERE dict_type = 'yms_internal_task_status' AND dict_value = 'FAILED'
);

INSERT INTO sys_dict_data
    (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, remark)
SELECT 6000003607, '000000', 7, '已取消', 'CANCELLED', 'yms_internal_task_status', '', 'default', 'N', 1, NOW(), 'YardGo任务已取消'
WHERE NOT EXISTS (
    SELECT 1 FROM sys_dict_data WHERE dict_type = 'yms_internal_task_status' AND dict_value = 'CANCELLED'
);

UPDATE sys_dict_data
SET dict_label = '待领取',
    list_class = 'default',
    remark = '等待 YardGo 司机领取',
    update_by = 1,
    update_time = NOW()
WHERE dict_type = 'yms_internal_task_status'
  AND dict_value = 'PENDING';

UPDATE sys_dict_data
SET dict_label = '已领取',
    list_class = 'warning',
    remark = 'YardGo 司机已领取',
    update_by = 1,
    update_time = NOW()
WHERE dict_type = 'yms_internal_task_status'
  AND dict_value = 'ACCEPTED';

UPDATE sys_dict_data
SET remark = '预留状态：未来如启用调度派单，可用于已分配执行人',
    update_by = 1,
    update_time = NOW()
WHERE dict_type = 'yms_internal_task_status'
  AND dict_value = 'ASSIGNED';
*/

-- ========== yms_dock_converge_base_20260529.sql ==========
-- YMS 月台菜单收敛到基础资料 /yard/dock（消除 yms/dock 双维护）
-- 以下 sys_menu 更新需转为 system_menu 格式后单独执行
/*
-- 1. 隐藏 YMS 模块下重复的「月台管理」菜单（保留基础资料 → 堆场 → 月台管理）
--    WHERE 使用主键 menu_id，兼容 MySQL Safe Update Mode
UPDATE sys_menu
SET visible = '1',
    remark  = CONCAT(IFNULL(remark, ''), ' [已收敛至基础资料/yard/dock]')
WHERE menu_id IN (
    SELECT menu_id FROM (
        SELECT menu_id
        FROM sys_menu
        WHERE path = 'yms/dock'
          AND component = 'yms/dock/index'
    ) AS dock_menu
);

-- 2. 若环境中 YMS 月台菜单尚未创建，上述 UPDATE 影响 0 行，可忽略；请直接使用「基础资料 → 月台管理」

-- 3. 兼容旧书签 /yms/dock：前端路由已指向 yard/dock 页面组件
*/
