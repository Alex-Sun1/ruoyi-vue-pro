-- ============================================================
-- YMS M1-M7 完整数据库迁移脚本
-- 版本：v2.0 | 日期：2026-05-29
-- ============================================================

-- ─────────────────────────────────────────────
-- 0. 扩展现有 yms_yard_task 表
-- ─────────────────────────────────────────────
ALTER TABLE `yms_yard_task`
  ADD COLUMN IF NOT EXISTS `prev_status`   VARCHAR(30)  DEFAULT NULL  COMMENT '异常前的状态（解除异常后恢复用）' AFTER `yard_status`,
  ADD COLUMN IF NOT EXISTS `priority`      TINYINT      NOT NULL DEFAULT 50 COMMENT '优先级（1=最高，100=最低）' AFTER `prev_status`,
  ADD COLUMN IF NOT EXISTS `apt_id`        BIGINT       DEFAULT NULL  COMMENT '关联预约单ID' AFTER `source_order_no`,
  ADD COLUMN IF NOT EXISTS `driver_id`     BIGINT       DEFAULT NULL  COMMENT '关联司机档案ID' AFTER `driver_phone`,
  ADD COLUMN IF NOT EXISTS `vehicle_id`    BIGINT       DEFAULT NULL  COMMENT '关联车辆档案ID' AFTER `driver_id`,
  ADD COLUMN IF NOT EXISTS `source_type`   VARCHAR(20)  NOT NULL DEFAULT 'MANUAL' COMMENT '来源类型：OMS/APPOINTMENT/MANUAL' AFTER `source_order_type`;

-- ─────────────────────────────────────────────
-- M7 RESOURCE：园区区域
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `yms_yard_zone` (
  `id`            BIGINT          NOT NULL                  COMMENT '主键ID',
  `tenant_id`     VARCHAR(20)     NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `warehouse_id`  BIGINT          NOT NULL                  COMMENT '园区ID',
  `zone_code`     VARCHAR(20)     NOT NULL                  COMMENT '区域编码',
  `zone_name`     VARCHAR(50)     NOT NULL                  COMMENT '区域名称',
  `zone_type`     VARCHAR(20)     NOT NULL DEFAULT 'CONTAINER' COMMENT '区域类型：CONTAINER/TRUCK/SELF_PICKUP/PARKING',
  `sort_order`    INT             NOT NULL DEFAULT 0        COMMENT '排序',
  `remark`        VARCHAR(200)    DEFAULT NULL,
  `create_dept`   BIGINT          DEFAULT NULL,
  `create_by`     BIGINT          DEFAULT NULL,
  `create_time`   DATETIME        DEFAULT NULL,
  `update_by`     BIGINT          DEFAULT NULL,
  `update_time`   DATETIME        DEFAULT NULL,
  `deleted`       TINYINT(1)      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_zone_code_warehouse` (`zone_code`, `warehouse_id`, `tenant_id`),
  KEY `idx_warehouse` (`warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='园区区域';

-- ─────────────────────────────────────────────
-- M7 RESOURCE：Dock 资源
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `yms_dock` (
  `id`                  BIGINT          NOT NULL                  COMMENT '主键ID',
  `tenant_id`           VARCHAR(20)     NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `warehouse_id`        BIGINT          NOT NULL                  COMMENT '园区ID',
  `zone_id`             BIGINT          DEFAULT NULL              COMMENT '所属区域ID',
  `dock_code`           VARCHAR(20)     NOT NULL                  COMMENT 'Dock编号',
  `dock_name`           VARCHAR(50)     DEFAULT NULL              COMMENT 'Dock名称',
  `dock_type`           VARCHAR(20)     NOT NULL DEFAULT 'TRUCK'  COMMENT '类型：CONTAINER/TRUCK/SELF_PICKUP',
  `status`              VARCHAR(20)     NOT NULL DEFAULT 'IDLE'   COMMENT '状态：IDLE/OCCUPIED/MAINTENANCE/CLOSED',
  `support_task_types`  VARCHAR(200)    DEFAULT NULL              COMMENT '支持的任务类型（逗号分隔）',
  `maintenance_reason`  VARCHAR(200)    DEFAULT NULL              COMMENT '维修原因',
  `maintenance_until`   DATETIME        DEFAULT NULL              COMMENT '预计恢复时间',
  `map_x`               DECIMAL(10,4)   DEFAULT NULL              COMMENT '平面图X坐标（预留）',
  `map_y`               DECIMAL(10,4)   DEFAULT NULL              COMMENT '平面图Y坐标（预留）',
  `sort_order`          INT             NOT NULL DEFAULT 0        COMMENT '排序',
  `remark`              VARCHAR(200)    DEFAULT NULL,
  `create_dept`         BIGINT          DEFAULT NULL,
  `create_by`           BIGINT          DEFAULT NULL,
  `create_time`         DATETIME        DEFAULT NULL,
  `update_by`           BIGINT          DEFAULT NULL,
  `update_time`         DATETIME        DEFAULT NULL,
  `deleted`             TINYINT(1)      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_dock_code_warehouse` (`dock_code`, `warehouse_id`, `tenant_id`),
  KEY `idx_warehouse_status` (`warehouse_id`, `status`),
  KEY `idx_zone_id` (`zone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Dock资源';

-- ─────────────────────────────────────────────
-- M6 DRIVER：车队
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `yms_fleet` (
  `id`            BIGINT          NOT NULL                  COMMENT '主键ID',
  `tenant_id`     VARCHAR(20)     NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `fleet_name`    VARCHAR(100)    NOT NULL                  COMMENT '车队/货代名称',
  `contact_name`  VARCHAR(50)     DEFAULT NULL              COMMENT '联系人',
  `contact_phone` VARCHAR(20)     DEFAULT NULL              COMMENT '联系电话',
  `remark`        VARCHAR(300)    DEFAULT NULL,
  `create_dept`   BIGINT          DEFAULT NULL,
  `create_by`     BIGINT          DEFAULT NULL,
  `create_time`   DATETIME        DEFAULT NULL,
  `update_by`     BIGINT          DEFAULT NULL,
  `update_time`   DATETIME        DEFAULT NULL,
  `deleted`       TINYINT(1)      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_tenant` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='车队/货代档案';

-- ─────────────────────────────────────────────
-- M6 DRIVER：司机档案
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `yms_driver` (
  `id`               BIGINT          NOT NULL                  COMMENT '主键ID',
  `tenant_id`        VARCHAR(20)     NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `name`             VARCHAR(50)     NOT NULL                  COMMENT '姓名',
  `phone`            VARCHAR(20)     NOT NULL                  COMMENT '手机号',
  `id_card_no`       VARCHAR(30)     DEFAULT NULL              COMMENT '证件号',
  `license_no`       VARCHAR(50)     DEFAULT NULL              COMMENT '驾照编号',
  `license_type`     VARCHAR(10)     DEFAULT NULL              COMMENT '驾照类型（A/B/C）',
  `license_expire`   DATE            DEFAULT NULL              COMMENT '驾照到期日',
  `fleet_id`         BIGINT          DEFAULT NULL              COMMENT '所属车队ID',
  `fleet_name`       VARCHAR(100)    DEFAULT NULL              COMMENT '车队名称（冗余）',
  `blacklisted`      TINYINT(1)      NOT NULL DEFAULT 0        COMMENT '是否黑名单',
  `blacklist_reason` VARCHAR(300)    DEFAULT NULL              COMMENT '黑名单原因',
  `remark`           VARCHAR(300)    DEFAULT NULL,
  `create_dept`      BIGINT          DEFAULT NULL,
  `create_by`        BIGINT          DEFAULT NULL,
  `create_time`      DATETIME        DEFAULT NULL,
  `update_by`        BIGINT          DEFAULT NULL,
  `update_time`      DATETIME        DEFAULT NULL,
  `deleted`          TINYINT(1)      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_phone` (`phone`),
  KEY `idx_fleet_id` (`fleet_id`),
  KEY `idx_blacklisted` (`tenant_id`, `blacklisted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='司机档案';

-- ─────────────────────────────────────────────
-- M6 DRIVER：车辆档案
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `yms_vehicle` (
  `id`                BIGINT          NOT NULL                  COMMENT '主键ID',
  `tenant_id`         VARCHAR(20)     NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `plate_no`          VARCHAR(30)     NOT NULL                  COMMENT '车牌号',
  `vehicle_type`      VARCHAR(30)     NOT NULL DEFAULT 'BOX_TRUCK' COMMENT '车型：CONTAINER_TRUCK/BOX_TRUCK/VAN/OTHER',
  `max_load_kg`       DECIMAL(8,0)    DEFAULT NULL              COMMENT '额定载重(kg)',
  `support_dock_types` VARCHAR(100)   DEFAULT NULL              COMMENT '适配Dock类型（逗号分隔）',
  `insurance_expire`  DATE            DEFAULT NULL              COMMENT '保险到期日',
  `inspection_expire` DATE            DEFAULT NULL              COMMENT '年检到期日',
  `fleet_id`          BIGINT          DEFAULT NULL              COMMENT '所属车队ID',
  `fleet_name`        VARCHAR(100)    DEFAULT NULL              COMMENT '车队名称（冗余）',
  `blacklisted`       TINYINT(1)      NOT NULL DEFAULT 0        COMMENT '是否黑名单',
  `blacklist_reason`  VARCHAR(300)    DEFAULT NULL,
  `remark`            VARCHAR(300)    DEFAULT NULL,
  `create_dept`       BIGINT          DEFAULT NULL,
  `create_by`         BIGINT          DEFAULT NULL,
  `create_time`       DATETIME        DEFAULT NULL,
  `update_by`         BIGINT          DEFAULT NULL,
  `update_time`       DATETIME        DEFAULT NULL,
  `deleted`           TINYINT(1)      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_plate_tenant` (`plate_no`, `tenant_id`),
  KEY `idx_fleet_id` (`fleet_id`),
  KEY `idx_blacklisted` (`tenant_id`, `blacklisted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='车辆档案';

-- ─────────────────────────────────────────────
-- M6 DRIVER：黑名单
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `yms_blacklist` (
  `id`              BIGINT          NOT NULL                  COMMENT '主键ID',
  `tenant_id`       VARCHAR(20)     NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `target_type`     VARCHAR(20)     NOT NULL                  COMMENT '对象类型：PLATE_NO/DRIVER_PHONE/DRIVER_ID_CARD',
  `target_value`    VARCHAR(50)     NOT NULL                  COMMENT '对象值',
  `reason`          VARCHAR(300)    NOT NULL                  COMMENT '加黑原因',
  `reason_type`     VARCHAR(30)     DEFAULT NULL              COMMENT '原因类型：TIMEOUT/VIOLATION/DAMAGE/OTHER',
  `effective_from`  DATETIME        NOT NULL                  COMMENT '生效时间',
  `effective_until` DATETIME        DEFAULT NULL              COMMENT '过期时间（NULL=永久）',
  `status`          VARCHAR(10)     NOT NULL DEFAULT 'ACTIVE' COMMENT '状态：ACTIVE/EXPIRED/REMOVED',
  `create_dept`     BIGINT          DEFAULT NULL,
  `create_by`       BIGINT          DEFAULT NULL,
  `create_time`     DATETIME        DEFAULT NULL,
  `update_by`       BIGINT          DEFAULT NULL,
  `update_time`     DATETIME        DEFAULT NULL,
  `deleted`         TINYINT(1)      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_target` (`tenant_id`, `target_type`, `target_value`, `status`),
  KEY `idx_effective` (`effective_until`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='黑名单';

-- ─────────────────────────────────────────────
-- M1 APT：时段模板
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `yms_slot_template` (
  `id`            BIGINT          NOT NULL                  COMMENT '主键ID',
  `tenant_id`     VARCHAR(20)     NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `warehouse_id`  BIGINT          NOT NULL                  COMMENT '园区ID',
  `template_name` VARCHAR(50)     NOT NULL                  COMMENT '模板名称',
  `week_day`      TINYINT         NOT NULL                  COMMENT '星期几（1=周一，7=周日，0=节假日）',
  `slot_start`    TIME            NOT NULL                  COMMENT '时段开始时间',
  `slot_end`      TIME            NOT NULL                  COMMENT '时段结束时间',
  `capacity_container` INT        NOT NULL DEFAULT 0        COMMENT '海柜容量上限',
  `capacity_truck`     INT        NOT NULL DEFAULT 0        COMMENT '普通货车容量上限',
  `enabled`       TINYINT(1)      NOT NULL DEFAULT 1        COMMENT '是否启用',
  `remark`        VARCHAR(200)    DEFAULT NULL,
  `create_by`     BIGINT          DEFAULT NULL,
  `create_time`   DATETIME        DEFAULT NULL,
  `update_by`     BIGINT          DEFAULT NULL,
  `update_time`   DATETIME        DEFAULT NULL,
  `deleted`       TINYINT(1)      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_warehouse_weekday` (`warehouse_id`, `week_day`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='预约时段模板';

-- ─────────────────────────────────────────────
-- M1 APT：预约单
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `yms_appointment` (
  `id`              BIGINT          NOT NULL                  COMMENT '主键ID',
  `tenant_id`       VARCHAR(20)     NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `warehouse_id`    BIGINT          NOT NULL                  COMMENT '园区ID',
  `apt_no`          VARCHAR(64)     NOT NULL                  COMMENT '预约单号',
  `task_type`       VARCHAR(30)     NOT NULL                  COMMENT '业务类型',
  `plate_no`        VARCHAR(30)     DEFAULT NULL              COMMENT '车牌号',
  `container_no`    VARCHAR(30)     DEFAULT NULL              COMMENT '集装箱号',
  `driver_name`     VARCHAR(50)     DEFAULT NULL              COMMENT '司机姓名',
  `driver_phone`    VARCHAR(20)     DEFAULT NULL              COMMENT '司机手机',
  `source_order_no` VARCHAR(64)     DEFAULT NULL              COMMENT '关联货物订单号',
  `apt_date`        DATE            NOT NULL                  COMMENT '预约日期',
  `slot_id`         BIGINT          DEFAULT NULL              COMMENT '时段模板ID',
  `apt_time_start`  DATETIME        NOT NULL                  COMMENT '预约时段开始',
  `apt_time_end`    DATETIME        NOT NULL                  COMMENT '预约时段结束',
  `status`          VARCHAR(20)     NOT NULL DEFAULT 'PENDING_CONFIRM' COMMENT '预约状态',
  `reject_reason`   VARCHAR(300)    DEFAULT NULL              COMMENT '拒绝原因',
  `no_show_at`      DATETIME        DEFAULT NULL              COMMENT '爽约判定时间',
  `applicant_type`  VARCHAR(20)     NOT NULL DEFAULT 'DRIVER' COMMENT '申请方：DRIVER/AGENT/STAFF',
  `applicant_id`    BIGINT          DEFAULT NULL              COMMENT '申请人ID',
  `applicant_name`  VARCHAR(50)     DEFAULT NULL              COMMENT '申请人姓名',
  `contact_phone`   VARCHAR(20)     DEFAULT NULL              COMMENT '联系电话',
  `create_dept`     BIGINT          DEFAULT NULL,
  `create_by`       BIGINT          DEFAULT NULL,
  `create_time`     DATETIME        DEFAULT NULL,
  `update_by`       BIGINT          DEFAULT NULL,
  `update_time`     DATETIME        DEFAULT NULL,
  `deleted`         TINYINT(1)      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_apt_no_tenant` (`apt_no`, `tenant_id`),
  KEY `idx_warehouse_date` (`warehouse_id`, `apt_date`),
  KEY `idx_status` (`tenant_id`, `status`),
  KEY `idx_plate_no` (`plate_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='预约单';

-- ─────────────────────────────────────────────
-- M2 GATE：Check-in 签到记录
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `yms_check_in` (
  `id`              BIGINT          NOT NULL                  COMMENT '主键ID',
  `tenant_id`       VARCHAR(20)     NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `warehouse_id`    BIGINT          NOT NULL                  COMMENT '园区ID',
  `yard_task_id`    BIGINT          DEFAULT NULL              COMMENT '关联园区任务ID',
  `apt_id`          BIGINT          DEFAULT NULL              COMMENT '关联预约单ID',
  `plate_no`        VARCHAR(30)     NOT NULL                  COMMENT '车牌号',
  `container_no`    VARCHAR(30)     DEFAULT NULL              COMMENT '集装箱号',
  `driver_name`     VARCHAR(50)     DEFAULT NULL              COMMENT '司机姓名',
  `driver_phone`    VARCHAR(20)     DEFAULT NULL              COMMENT '司机手机',
  `driver_id`       BIGINT          DEFAULT NULL              COMMENT '关联司机档案ID',
  `status`          VARCHAR(20)     NOT NULL DEFAULT 'IN_YARD' COMMENT '在场状态：IN_YARD/LEFT/BLOCKED',
  `match_result`    VARCHAR(20)     NOT NULL DEFAULT 'PASS'   COMMENT '匹配结果：PASS/WARN/BLOCK',
  `match_warnings`  JSON            DEFAULT NULL              COMMENT '告警详情',
  `in_time`         DATETIME        NOT NULL                  COMMENT '到场时间',
  `out_time`        DATETIME        DEFAULT NULL              COMMENT '离场时间',
  `stay_minutes`    INT             DEFAULT NULL              COMMENT '在场时长（分钟）',
  `photo_urls`      JSON            DEFAULT NULL              COMMENT '照片URL列表',
  `in_operator_id`  BIGINT          DEFAULT NULL              COMMENT '签到操作人',
  `in_channel`      VARCHAR(20)     NOT NULL DEFAULT 'GATE'   COMMENT '签到渠道：GATE/APP/QR_CODE',
  `out_operator_id` BIGINT          DEFAULT NULL              COMMENT '离场操作人',
  `create_time`     DATETIME        DEFAULT NULL,
  `update_time`     DATETIME        DEFAULT NULL,
  `deleted`         TINYINT(1)      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_warehouse_status` (`warehouse_id`, `status`),
  KEY `idx_plate_no_status` (`plate_no`, `status`),
  KEY `idx_yard_task_id` (`yard_task_id`),
  KEY `idx_in_time` (`in_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Check-in 签到记录';

-- ─────────────────────────────────────────────
-- M5 YARDGO：场内作业任务
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `yms_yardgo_task` (
  `id`               BIGINT          NOT NULL                  COMMENT '主键ID',
  `tenant_id`        VARCHAR(20)     NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `warehouse_id`     BIGINT          NOT NULL                  COMMENT '园区ID',
  `yard_task_id`     BIGINT          DEFAULT NULL              COMMENT '关联园区任务ID',
  `task_type`        VARCHAR(30)     NOT NULL                  COMMENT '作业类型：MOVE_CONTAINER/DEVANNING_SUPPORT/LOADING_SUPPORT/CONTAINER_SCAN/YARD_INSPECTION/CUSTOM',
  `status`           VARCHAR(20)     NOT NULL DEFAULT 'PENDING' COMMENT '状态：PENDING/ASSIGNED/IN_PROGRESS/COMPLETED/CANCELLED/FAILED',
  `executor_type`    VARCHAR(20)     NOT NULL DEFAULT 'FORKLIFT' COMMENT '执行者类型：FORKLIFT/ROBOT_DOG/YARDGO_DEVICE/MANUAL',
  `executor_id`      BIGINT          DEFAULT NULL              COMMENT '执行者ID',
  `executor_name`    VARCHAR(50)     DEFAULT NULL              COMMENT '执行者名称（冗余）',
  `task_desc`        VARCHAR(300)    DEFAULT NULL              COMMENT '作业说明',
  `from_zone`        VARCHAR(50)     DEFAULT NULL              COMMENT '起始区域',
  `to_zone`          VARCHAR(50)     DEFAULT NULL              COMMENT '目标区域',
  `target_location`  JSON            DEFAULT NULL              COMMENT '目标坐标（机器狗用）',
  `ext_task_id`      VARCHAR(100)    DEFAULT NULL              COMMENT '外部设备任务ID',
  `ext_result`       JSON            DEFAULT NULL              COMMENT '设备返回结果',
  `fail_reason`      VARCHAR(300)    DEFAULT NULL              COMMENT '失败原因',
  `retry_count`      TINYINT         NOT NULL DEFAULT 0        COMMENT '重试次数',
  `origin_task_id`   BIGINT          DEFAULT NULL              COMMENT '降级前原始任务ID',
  `assign_time`      DATETIME        DEFAULT NULL              COMMENT '分配时间',
  `start_time`       DATETIME        DEFAULT NULL              COMMENT '开始时间',
  `finish_time`      DATETIME        DEFAULT NULL              COMMENT '完成时间',
  `remark`           VARCHAR(300)    DEFAULT NULL,
  `create_dept`      BIGINT          DEFAULT NULL,
  `create_by`        BIGINT          DEFAULT NULL,
  `create_time`      DATETIME        DEFAULT NULL,
  `update_by`        BIGINT          DEFAULT NULL,
  `update_time`      DATETIME        DEFAULT NULL,
  `deleted`          TINYINT(1)      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_yard_task_id` (`yard_task_id`),
  KEY `idx_executor_id` (`executor_id`),
  KEY `idx_status` (`tenant_id`, `status`),
  KEY `idx_ext_task_id` (`ext_task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='场内作业任务（YardGo）';

-- ─────────────────────────────────────────────
-- 菜单 SQL（M1-M7 新增菜单，parent_id=5000 为 YMS 根菜单，按需调整）
-- ─────────────────────────────────────────────
-- M7 资源管理
INSERT IGNORE INTO sys_menu VALUES(5010, 'Dock管理',   5000, 10, 'dock',        'yms/dock/index',        '', 1, 0, 'C', '0', '0', 'yms:dock:list',        'dashboard', 103, 1, NOW(), NULL, NULL, 'Dock资源管理');
INSERT IGNORE INTO sys_menu VALUES(5011, '区域管理',   5000, 11, 'zone',        'yms/zone/index',        '', 1, 0, 'C', '0', '0', 'yms:zone:list',        'tree',      103, 1, NOW(), NULL, NULL, '园区区域管理');
-- M6 司机档案
INSERT IGNORE INTO sys_menu VALUES(5020, '司机档案',   5000, 20, 'driver',      'yms/driver/index',      '', 1, 0, 'C', '0', '0', 'yms:driver:list',      'user',      103, 1, NOW(), NULL, NULL, '司机档案管理');
INSERT IGNORE INTO sys_menu VALUES(5021, '车辆档案',   5000, 21, 'vehicle',     'yms/vehicle/index',     '', 1, 0, 'C', '0', '0', 'yms:vehicle:list',     'car',       103, 1, NOW(), NULL, NULL, '车辆档案管理');
INSERT IGNORE INTO sys_menu VALUES(5022, '黑名单',     5000, 22, 'blacklist',   'yms/blacklist/index',   '', 1, 0, 'C', '0', '0', 'yms:blacklist:list',   'lock',      103, 1, NOW(), NULL, NULL, '黑名单管理');
-- M1 预约管理
INSERT IGNORE INTO sys_menu VALUES(5030, '预约管理',   5000, 30, 'appointment', 'yms/appointment/index', '', 1, 0, 'C', '0', '0', 'yms:apt:list',         'calendar',  103, 1, NOW(), NULL, NULL, '预约管理');
-- M2 Check-in
INSERT IGNORE INTO sys_menu VALUES(5040, '门禁签到',   5000, 40, 'gate',        'yms/gate/index',        '', 1, 0, 'C', '0', '0', 'yms:gate:list',        'door',      103, 1, NOW(), NULL, NULL, '门禁签到管理');
-- M5 YardGo
INSERT IGNORE INTO sys_menu VALUES(5050, '场内作业',   5000, 50, 'yardgo',      'yms/yardgo/index',      '', 1, 0, 'C', '0', '0', 'yms:yardgo:list',      'wrench',    103, 1, NOW(), NULL, NULL, '场内作业任务');
