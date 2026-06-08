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
    `tenant_id`                 VARCHAR(20)     NOT NULL DEFAULT '000000'       COMMENT '租户ID',
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
    `create_dept`               BIGINT          DEFAULT NULL,
    `create_by`                 BIGINT          DEFAULT NULL,
    `create_time`               DATETIME        DEFAULT NULL,
    `update_by`                 BIGINT          DEFAULT NULL,
    `update_time`               DATETIME        DEFAULT NULL,
    `deleted`                   TINYINT(1)      NOT NULL DEFAULT 0,

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
    `tenant_id`                 VARCHAR(20)     NOT NULL DEFAULT '000000'       COMMENT '租户ID',
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
    `create_dept`               BIGINT          DEFAULT NULL,
    `create_by`                 BIGINT          DEFAULT NULL,
    `create_time`               DATETIME        DEFAULT NULL,
    `update_by`                 BIGINT          DEFAULT NULL,
    `update_time`               DATETIME        DEFAULT NULL,
    `deleted`                   TINYINT(1)      NOT NULL DEFAULT 0,

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
    `create_dept`           BIGINT          DEFAULT NULL,
    `create_by`             BIGINT          DEFAULT NULL,
    `create_time`           DATETIME        DEFAULT NULL,
    `update_by`             BIGINT          DEFAULT NULL,
    `update_time`           DATETIME        DEFAULT NULL,
    `deleted`               TINYINT(1)      NOT NULL DEFAULT 0,

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
    `create_dept`           BIGINT          DEFAULT NULL,
    `create_by`             BIGINT          DEFAULT NULL,
    `create_time`           DATETIME        DEFAULT NULL,
    `update_by`             BIGINT          DEFAULT NULL,
    `update_time`           DATETIME        DEFAULT NULL,
    `deleted`               TINYINT(1)      NOT NULL DEFAULT 0,

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
    `create_dept`               BIGINT          DEFAULT NULL,
    `create_by`                 BIGINT          DEFAULT NULL,
    `create_time`               DATETIME        DEFAULT NULL,
    `update_by`                 BIGINT          DEFAULT NULL,
    `update_time`               DATETIME        DEFAULT NULL,
    `deleted`                   TINYINT(1)      NOT NULL DEFAULT 0,

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
    `create_dept`               BIGINT          DEFAULT NULL,
    `create_by`                 BIGINT          DEFAULT NULL,
    `create_time`               DATETIME        DEFAULT NULL,
    `update_by`                 BIGINT          DEFAULT NULL,
    `update_time`               DATETIME        DEFAULT NULL,
    `deleted`                   TINYINT(1)      NOT NULL DEFAULT 0,

    PRIMARY KEY (`id`),
    KEY `idx_warehouse_task_type` (`warehouse_id`, `task_type`, `enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='YMS叫号规则配置表';

-- =============================================
-- 8. yms_call_rule_condition 叫号前置条件表
-- =============================================
CREATE TABLE IF NOT EXISTS `yms_call_rule_condition` (
    `id`                BIGINT          NOT NULL                    COMMENT '主键',
    `tenant_id`         VARCHAR(20)     NOT NULL DEFAULT '000000'   COMMENT '租户ID',
    `rule_id`           BIGINT          NOT NULL                    COMMENT '叫号规则ID',
    `condition_field`   VARCHAR(50)     NOT NULL                    COMMENT '条件字段（如 container_status/wms_status）',
    `operator`          VARCHAR(10)     NOT NULL                    COMMENT '运算符：EQ/NEQ/IN/GTE/LTE',
    `condition_value`   VARCHAR(200)    NOT NULL                    COMMENT '条件值',
    `sort_order`        INT             NOT NULL DEFAULT 1          COMMENT '排序',

    PRIMARY KEY (`id`),
    KEY `idx_rule_id` (`rule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='YMS叫号前置条件表';

-- =============================================
-- 9. yms_call_rule_sort 叫号排序规则表
-- =============================================
CREATE TABLE IF NOT EXISTS `yms_call_rule_sort` (
    `id`                BIGINT          NOT NULL                    COMMENT '主键',
    `tenant_id`         VARCHAR(20)     NOT NULL DEFAULT '000000'   COMMENT '租户ID',
    `rule_id`           BIGINT          NOT NULL                    COMMENT '叫号规则ID',
    `sort_field`        VARCHAR(50)     NOT NULL                    COMMENT '排序字段：appointment_time/arrive_time/wms_ready_time/lfd_return/customer_level/priority/waiting_minutes',
    `sort_direction`    VARCHAR(4)      NOT NULL DEFAULT 'ASC'      COMMENT '排序方向：ASC/DESC',
    `priority_order`    INT             NOT NULL DEFAULT 1          COMMENT '排序优先级（1=最高优先级）',

    PRIMARY KEY (`id`),
    KEY `idx_rule_id` (`rule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='YMS叫号排序规则表';

-- =============================================
-- 10. yms_call_record 叫号记录表
-- =============================================
CREATE TABLE IF NOT EXISTS `yms_call_record` (
    `id`                BIGINT          NOT NULL                    COMMENT '主键',
    `tenant_id`         VARCHAR(20)     NOT NULL DEFAULT '000000'   COMMENT '租户ID',
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
-- 14. 更新 yard_dock dock_type 字典（补全PRD对齐值）
-- =============================================
INSERT IGNORE INTO sys_dict_type (tenant_id, dict_name, dict_type, create_dept, create_by, create_time, remark) VALUES
('000000', 'YMS月台类型', 'yms_dock_type', 103, 1, NOW(), 'YMS月台/Dock类型');

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
