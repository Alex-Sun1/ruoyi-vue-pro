-- ============================================================
-- 入库计划 DDL
-- 生成日期：2026-05-27
-- ============================================================

-- ============================================================
-- 1. 入库计划主表
-- ============================================================
CREATE TABLE `wms_inbound_plan` (
  `id`                  bigint          NOT NULL                    COMMENT '主键ID（雪花）',
  `tenant_id`           varchar(20)     NOT NULL DEFAULT '000000'   COMMENT '租户ID',
  `warehouse_id`        bigint          NOT NULL                    COMMENT '仓库ID',
  `container_order_id`  bigint          NOT NULL                    COMMENT '海柜订单ID',
  `container_order_no`  varchar(64)     DEFAULT NULL                COMMENT '海柜订单编号（冗余展示）',
  `plan_no`             varchar(64)     NOT NULL                    COMMENT '入库计划编号（系统生成）',
  `status`              varchar(20)     NOT NULL DEFAULT 'draft'    COMMENT '状态：draft/in_progress/completed/cancelled',
  `remark`              varchar(500)    DEFAULT NULL                COMMENT '备注',
  `create_dept`         bigint          DEFAULT NULL                COMMENT '创建部门',
  `create_by`           bigint          DEFAULT NULL                COMMENT '创建人',
  `create_time`         datetime        DEFAULT NULL                COMMENT '创建时间',
  `update_by`           bigint          DEFAULT NULL                COMMENT '更新人',
  `update_time`         datetime        DEFAULT NULL                COMMENT '更新时间',
  `deleted`             tinyint(1)      NOT NULL DEFAULT 0          COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_plan_no_tenant` (`plan_no`, `tenant_id`),
  UNIQUE KEY `uk_container_order` (`container_order_id`, `tenant_id`, `deleted`),
  KEY `idx_tenant_warehouse` (`tenant_id`, `warehouse_id`),
  KEY `idx_status` (`status`),
  KEY `idx_container_order_id` (`container_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='入库计划主表';

-- ============================================================
-- 2. 入库计划明细（货件维度）
-- ============================================================
CREATE TABLE `wms_inbound_plan_item` (
  `id`              bigint          NOT NULL                    COMMENT '主键ID（雪花）',
  `tenant_id`       varchar(20)     NOT NULL DEFAULT '000000'   COMMENT '租户ID',
  `plan_id`         bigint          NOT NULL                    COMMENT '入库计划ID',
  `cargo_order_id`  bigint          NOT NULL                    COMMENT '货物订单ID',
  `shipment_id`     bigint          NOT NULL                    COMMENT '货件ID',
  `group_code`      varchar(100)    DEFAULT NULL                COMMENT '分组（核心字段，三种方式可写入）',
  `pre_location`    varchar(100)    DEFAULT NULL                COMMENT '系统预库位',
  `create_dept`     bigint          DEFAULT NULL                COMMENT '创建部门',
  `create_by`       bigint          DEFAULT NULL                COMMENT '创建人',
  `create_time`     datetime        DEFAULT NULL                COMMENT '创建时间',
  `update_by`       bigint          DEFAULT NULL                COMMENT '更新人',
  `update_time`     datetime        DEFAULT NULL                COMMENT '更新时间',
  `deleted`         tinyint(1)      NOT NULL DEFAULT 0          COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_plan_shipment` (`plan_id`, `shipment_id`, `deleted`),
  KEY `idx_plan_id` (`plan_id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`),
  KEY `idx_shipment_id` (`shipment_id`),
  KEY `idx_group_code` (`group_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='入库计划明细（货件维度，展示数据实时JOIN）';

-- ============================================================
-- 3. 分组变更日志
-- ============================================================
CREATE TABLE `wms_inbound_plan_change_log` (
  `id`              bigint          NOT NULL                    COMMENT '主键ID（雪花）',
  `tenant_id`       varchar(20)     NOT NULL DEFAULT '000000'   COMMENT '租户ID',
  `plan_id`         bigint          NOT NULL                    COMMENT '入库计划ID',
  `plan_item_id`    bigint          NOT NULL                    COMMENT '计划明细ID',
  `shipment_id`     bigint          NOT NULL                    COMMENT '货件ID',
  `old_group_code`  varchar(100)    DEFAULT NULL                COMMENT '变更前分组',
  `new_group_code`  varchar(100)    DEFAULT NULL                COMMENT '变更后分组',
  `change_type`     varchar(30)     NOT NULL                    COMMENT '变更类型：auto_group/quick_config/manual',
  `change_by`       bigint          DEFAULT NULL                COMMENT '操作人',
  `change_time`     datetime        DEFAULT NULL                COMMENT '操作时间',
  PRIMARY KEY (`id`),
  KEY `idx_plan_id` (`plan_id`),
  KEY `idx_plan_item_id` (`plan_item_id`),
  KEY `idx_shipment_id` (`shipment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='入库计划分组变更日志';

-- ============================================================
-- 4. 现有表新增字段
-- ============================================================

-- 货件表新增分组字段
ALTER TABLE `oms_cargo_order_shipment`
  ADD COLUMN `group_code` varchar(100) DEFAULT NULL COMMENT '入库分组（由入库计划写入）' AFTER `cbm`;

-- 货物订单表新增分组字段
ALTER TABLE `oms_cargo_order`
  ADD COLUMN `group_code` varchar(100) DEFAULT NULL COMMENT '入库分组（从货件汇总，多分组时存MULTI）' AFTER `actual_cbm`;

-- 平台地址表新增单板CBM
ALTER TABLE `platform_address`
  ADD COLUMN `unit_pallet_cbm` decimal(10,3) DEFAULT NULL COMMENT '单板CBM，用于计算预计打板数' AFTER `zipCode`;

-- ============================================================
-- 5. 字典初始化
-- ============================================================
-- 入库计划状态
INSERT INTO sys_dict_type (dict_name, dict_type, status, remark) VALUES ('入库计划状态', 'wms_inbound_plan_status', '0', '');
INSERT INTO sys_dict_data (dict_sort, dict_label, dict_value, dict_type, status) VALUES
(1, '草稿',   'draft',       'wms_inbound_plan_status', '0'),
(2, '作业中', 'in_progress', 'wms_inbound_plan_status', '0'),
(3, '已完结', 'completed',   'wms_inbound_plan_status', '0'),
(4, '已取消', 'cancelled',   'wms_inbound_plan_status', '0');

-- 分组变更类型
INSERT INTO sys_dict_type (dict_name, dict_type, status, remark) VALUES ('分组变更类型', 'wms_group_change_type', '0', '');
INSERT INTO sys_dict_data (dict_sort, dict_label, dict_value, dict_type, status) VALUES
(1, '自动分组',   'auto_group',    'wms_group_change_type', '0'),
(2, '快速配置',   'quick_config',  'wms_group_change_type', '0'),
(3, '手动编辑',   'manual',        'wms_group_change_type', '0');
