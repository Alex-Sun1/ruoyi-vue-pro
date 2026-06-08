-- =====================================================
-- 货物订单模块 DDL  v1.2
-- 表清单:
--   oms_cargo_order            货物订单主表
--   oms_cargo_order_shipment   货件层
--   oms_cargo_order_sku_item   SKU 明细层
--   oms_cargo_order_node_trace 节点轨迹表
-- =====================================================

-- ----------------------------
-- 1. 货物订单主表
-- ----------------------------
DROP TABLE IF EXISTS `oms_cargo_order`;
CREATE TABLE `oms_cargo_order` (
  `id`                          bigint          NOT NULL                    COMMENT '主键ID（雪花）',
  `tenant_id`                   varchar(20)     NOT NULL DEFAULT '000000'   COMMENT '租户ID',
  `company_id`                  bigint          DEFAULT NULL                COMMENT '主体公司ID',
  `biz_root_id`                 bigint          DEFAULT NULL                COMMENT '业务主线ID（全链路串联）',

  -- 货件汇总聚合（服务层在货件变更时回写，供列表展示）
  `shipment_codes`              varchar(2000)   DEFAULT NULL                COMMENT '货件编码汇总（逗号分隔，服务层聚合回写）',
  `po_nos`                      varchar(2000)   DEFAULT NULL                COMMENT 'PO号汇总（逗号分隔，服务层聚合回写）',
  `marks`                       varchar(2000)   DEFAULT NULL                COMMENT '唛头汇总（逗号分隔，服务层聚合回写）',

  -- 订单基础
  `cargo_order_no`              varchar(64)     NOT NULL                    COMMENT '货物订单号',
  `external_order_no`           varchar(128)    DEFAULT NULL                COMMENT '外部订单号（客户/来源系统）',
  `order_source`                varchar(32)     DEFAULT NULL                COMMENT '订单来源(MANUAL/IMPORT/API/PORTAL)',

  -- 客户与业务归属
  `customer_id`                 bigint          DEFAULT NULL                COMMENT '客户ID',
  `customer_name`               varchar(128)    DEFAULT NULL                COMMENT '客户名称（冗余）',
  `business_type_id`            bigint          DEFAULT NULL                COMMENT '业务类型ID',
  `business_type_name`          varchar(128)    DEFAULT NULL                COMMENT '业务类型名称（冗余）',
  `channel_id`                  bigint          DEFAULT NULL                COMMENT '渠道ID',
  `channel_name`                varchar(128)    DEFAULT NULL                COMMENT '渠道名称（冗余）',
  `platform_id`                 bigint          DEFAULT NULL                COMMENT '平台ID',
  `platform_name`               varchar(128)    DEFAULT NULL                COMMENT '平台名称（冗余，如Amazon-US）',
  `customer_service_id`         bigint          DEFAULT NULL                COMMENT '客服ID',
  `customer_service_name`       varchar(128)    DEFAULT NULL                COMMENT '客服名称（冗余）',

  -- 海柜与入库仓
  `container_order_id`          bigint          DEFAULT NULL                COMMENT '关联海柜订单ID',
  `container_no`                varchar(32)     DEFAULT NULL                COMMENT '柜号（冗余）',
  `inbound_warehouse_id`        bigint          DEFAULT NULL                COMMENT '入库仓库ID',
  `inbound_warehouse_name`      varchar(128)    DEFAULT NULL                COMMENT '入库仓库名称（冗余）',

  -- 地址与目的地
  `address_type`                varchar(32)     DEFAULT NULL                COMMENT '地址类型(PLATFORM_WH/PRIVATE/COMMERCIAL)',
  `platform_warehouse_code`     varchar(64)     DEFAULT NULL                COMMENT '平台仓库代码',
  `consignee_name`              varchar(128)    DEFAULT NULL                COMMENT '收货方名称',
  `address_line1`               varchar(255)    DEFAULT NULL                COMMENT '地址Line1',
  `address_line2`               varchar(255)    DEFAULT NULL                COMMENT '地址Line2',
  `city`                        varchar(128)    DEFAULT NULL                COMMENT 'City',
  `state`                       varchar(64)     DEFAULT NULL                COMMENT 'State',
  `zip_code`                    varchar(32)     DEFAULT NULL                COMMENT 'Zip Code',
  `country`                     varchar(64)     DEFAULT NULL                COMMENT 'Country',
  `contact_name`                varchar(128)    DEFAULT NULL                COMMENT '联系人',
  `contact_phone`               varchar(64)     DEFAULT NULL                COMMENT '联系电话',
  `contact_email`               varchar(128)    DEFAULT NULL                COMMENT '联系邮箱',

  -- 快递派送
  `parcel_carrier_name`         varchar(128)    DEFAULT NULL                COMMENT '快递商名称',
  `parcel_tracking_no`          varchar(128)    DEFAULT NULL                COMMENT '快递追踪号',

  -- 转仓
  `transfer_flag`               tinyint(1)      NOT NULL DEFAULT 0          COMMENT '是否转仓',
  `transfer_warehouse_code`     varchar(64)     DEFAULT NULL                COMMENT '转仓目标仓库代码',

  -- 预报货量
  `declared_carton_qty`         decimal(10,2)   DEFAULT NULL                COMMENT '预报箱数',
  `declared_piece_qty`          decimal(12,2)   DEFAULT NULL                COMMENT '预报件数',
  `declared_weight`             decimal(12,3)   DEFAULT NULL                COMMENT '预报重量(kg)',
  `declared_cbm`                decimal(12,3)   DEFAULT NULL                COMMENT '预报体积(m³)',

  -- 实际货量（WMS 回写）
  `actual_carton_qty`           decimal(10,2)   DEFAULT NULL                COMMENT '实际箱数',
  `actual_pallet_qty`           decimal(10,2)   DEFAULT NULL                COMMENT '实际板数（WMS打板统计）',
  `actual_piece_qty`            decimal(12,2)   DEFAULT NULL                COMMENT '实际件数',
  `actual_weight`               decimal(12,3)   DEFAULT NULL                COMMENT '实际重量(kg)',
  `actual_cbm`                  decimal(12,3)   DEFAULT NULL                COMMENT '实际体积(m³)',

  -- 单位
  `weight_unit`                 varchar(16)     DEFAULT 'KG'                COMMENT '重量单位(KG/LB)',
  `volume_unit`                 varchar(16)     DEFAULT 'CBM'               COMMENT '体积单位',

  -- 预出单与出单（并行状态，不进主生命周期）
  `pre_outbound_flag`           tinyint(1)      NOT NULL DEFAULT 0          COMMENT '是否有预出单',
  `pre_outbound_no`             varchar(64)     DEFAULT NULL                COMMENT '预出单号',
  `pre_outbound_status`         varchar(32)     NOT NULL DEFAULT 'NONE'     COMMENT '预出单状态(NONE/PRE_CREATED/CONVERTED/CANCELLED)',
  `pre_outbound_time`           datetime        DEFAULT NULL                COMMENT '生成预出单时间',
  `pre_outbound_convert_time`   datetime        DEFAULT NULL                COMMENT '预出单转正式时间',
  `outbound_batch_no`           varchar(64)     DEFAULT NULL                COMMENT '正式出单号/批次号',
  `outbound_order_status`       varchar(32)     NOT NULL DEFAULT 'NONE'     COMMENT '出单状态(NONE/ORDERED/CANCELLED)',
  `outbound_order_time`         datetime        DEFAULT NULL                COMMENT '正式出单时间',

  -- 主状态
  `order_status`                varchar(32)     NOT NULL DEFAULT 'NORMAL'   COMMENT '订单状态(NORMAL/CANCELLED/CLOSED)',
  `fulfillment_status`          varchar(32)     NOT NULL DEFAULT 'PENDING_ACCEPT' COMMENT '主履约状态',
  -- 并行状态
  `appointment_status`          varchar(32)     NOT NULL DEFAULT 'NONE'     COMMENT '预约状态(NONE/APPOINTED/CANCELLED)',
  `pod_status`                  varchar(32)     NOT NULL DEFAULT 'PENDING'  COMMENT 'POD状态(PENDING/UPLOADED/EXCEPTION)',
  `billing_status`              varchar(32)     NOT NULL DEFAULT 'UNBILLED' COMMENT '账单状态(UNBILLED/BILLED/VOIDED)',

  -- 关键时间节点
  `earliest_dw_time`            datetime        DEFAULT NULL                COMMENT '最早DW时间（货件层聚合，系统回写）',
  `eta`                         datetime        DEFAULT NULL                COMMENT 'ETA预计到港',
  `ata`                         datetime        DEFAULT NULL                COMMENT 'ATA实际到港',
  `actual_pickup_time`          datetime        DEFAULT NULL                COMMENT '实际提柜时间',
  `actual_arrival_time`         datetime        DEFAULT NULL                COMMENT '实际到仓时间',
  `devanning_finish_time`       datetime        DEFAULT NULL                COMMENT '拆柜完成时间',
  `actual_inbound_time`         datetime        DEFAULT NULL                COMMENT '入库完成时间',
  `delivery_lfd`                datetime        DEFAULT NULL                COMMENT '派送LFD（最晚完成派送日期）',
  `delivery_appointment_time`   datetime        DEFAULT NULL                COMMENT '派送预约时间',
  `actual_outbound_time`        datetime        DEFAULT NULL                COMMENT '实际出库时间',
  `signed_time`                 datetime        DEFAULT NULL                COMMENT '签收时间',
  `pod_upload_time`             datetime        DEFAULT NULL                COMMENT 'POD回传时间',
  `billing_time`                datetime        DEFAULT NULL                COMMENT '出账单时间',
  `completed_time`              datetime        DEFAULT NULL                COMMENT '全链路完成时间',

  -- 异常摘要
  `exception_flag`              tinyint(1)      NOT NULL DEFAULT 0          COMMENT '是否有未关闭异常',
  `exception_count`             int             NOT NULL DEFAULT 0          COMMENT '未关闭异常数量',

  -- HOLD 标志
  `hold_flag`                   tinyint(1)      NOT NULL DEFAULT 0          COMMENT 'HOLD标志（0正常/1HOLD中）',
  `hold_status`                 varchar(32)     NOT NULL DEFAULT 'NORMAL'   COMMENT 'NORMAL/HOLDING/RELEASED',
  `hold_type`                   varchar(64)     DEFAULT NULL                COMMENT '暂扣类型',
  `hold_reason`                 varchar(500)    DEFAULT NULL                COMMENT '当前暂扣原因',
  `hold_time`                   datetime        DEFAULT NULL                COMMENT '暂扣时间',
  `hold_user_id`                bigint          DEFAULT NULL                COMMENT '暂扣人ID',
  `hold_user_name`              varchar(128)    DEFAULT NULL                COMMENT '暂扣人名称',
  `release_time`                datetime        DEFAULT NULL                COMMENT '最近放行时间',
  `hold_remark`                 varchar(500)    DEFAULT NULL                COMMENT 'HOLD原因/说明',

  -- 拆单
  `parent_order_id`             bigint          DEFAULT NULL                COMMENT '父订单ID（由拆单产生时填写）',

  -- 备注
  `customer_remark`             text            DEFAULT NULL                COMMENT '客户备注',
  `internal_remark`             text            DEFAULT NULL                COMMENT '内部备注',
  `operation_remark`            text            DEFAULT NULL                COMMENT '操作备注',
  `follow_up_remark`            text            DEFAULT NULL                COMMENT '跟进记录（客服/运营跟进内容）',

  -- 审计
  `remark`                      varchar(500)    DEFAULT NULL                COMMENT '备注',
  `create_dept`                 bigint          DEFAULT NULL                COMMENT '创建部门',
  `create_by`                   bigint          DEFAULT NULL                COMMENT '创建人',
  `create_time`                 datetime        DEFAULT NULL                COMMENT '创建时间',
  `update_by`                   bigint          DEFAULT NULL                COMMENT '更新人',
  `update_time`                 datetime        DEFAULT NULL                COMMENT '更新时间',
  `deleted`                     tinyint(1)      NOT NULL DEFAULT 0          COMMENT '逻辑删除',

  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_cargo_order_no_tenant` (`cargo_order_no`, `tenant_id`),
  KEY `idx_tenant_fulfillment_status` (`tenant_id`, `fulfillment_status`),
  KEY `idx_company_id` (`company_id`),
  KEY `idx_customer_id` (`customer_id`),
  KEY `idx_biz_root_id` (`biz_root_id`),
  KEY `idx_container_order_id` (`container_order_id`),
  KEY `idx_inbound_warehouse_id` (`inbound_warehouse_id`),
  KEY `idx_earliest_dw_time` (`earliest_dw_time`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='货物订单主表';


-- ----------------------------
-- 2. 货件层
-- ----------------------------
DROP TABLE IF EXISTS `oms_cargo_order_shipment`;
CREATE TABLE `oms_cargo_order_shipment` (
  `id`            bigint          NOT NULL                    COMMENT '主键ID',
  `tenant_id`     varchar(20)     NOT NULL DEFAULT '000000'   COMMENT '租户ID',
  `cargo_order_id` bigint         NOT NULL                    COMMENT '货物订单ID',
  `biz_root_id`   bigint          DEFAULT NULL                COMMENT '业务主线ID',

  `shipment_no`   varchar(128)    NOT NULL                    COMMENT '货件编码',
  `po_no`         varchar(128)    DEFAULT NULL                COMMENT 'PO号',
  `shipping_mark` varchar(128)    DEFAULT NULL                COMMENT '唛头',
  `carton_qty`    decimal(10,2)   DEFAULT NULL                COMMENT '货件箱数',
  `weight`        decimal(12,3)   DEFAULT NULL                COMMENT '货件重量(kg)',
  `cbm`           decimal(12,3)   DEFAULT NULL                COMMENT '货件体积(m³)',
  `dw_time`       datetime        DEFAULT NULL                COMMENT 'DW时间（预计到仓，货件编码维度）',
  `remark`        text            DEFAULT NULL                COMMENT '备注',

  `create_by`     bigint          DEFAULT NULL                COMMENT '创建人',
  `create_time`   datetime        DEFAULT NULL                COMMENT '创建时间',
  `update_by`     bigint          DEFAULT NULL                COMMENT '更新人',
  `update_time`   datetime        DEFAULT NULL                COMMENT '更新时间',
  `deleted`       tinyint(1)      NOT NULL DEFAULT 0          COMMENT '逻辑删除',

  PRIMARY KEY (`id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`),
  KEY `idx_biz_root_id` (`biz_root_id`),
  KEY `idx_dw_time` (`dw_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='货物订单货件层（DW时间存此层）';


-- ----------------------------
-- 3. SKU 明细层
-- ----------------------------
DROP TABLE IF EXISTS `oms_cargo_order_sku_item`;
CREATE TABLE `oms_cargo_order_sku_item` (
  `id`              bigint          NOT NULL                    COMMENT '主键ID',
  `tenant_id`       varchar(20)     NOT NULL DEFAULT '000000'   COMMENT '租户ID',
  `cargo_order_id`  bigint          NOT NULL                    COMMENT '货物订单ID（冗余）',
  `shipment_id`     bigint          NOT NULL                    COMMENT '货件ID',
  `shipment_no`     varchar(128)    DEFAULT NULL                COMMENT '货件编码（冗余）',
  `po_no`           varchar(128)    DEFAULT NULL                COMMENT 'PO号（冗余）',
  `shipping_mark`   varchar(128)    DEFAULT NULL                COMMENT '唛头（冗余）',

  `sku`             varchar(128)    DEFAULT NULL                COMMENT 'SKU编码',
  `fnsku`           varchar(128)    DEFAULT NULL                COMMENT 'FNSKU（Amazon）',
  `product_name`    varchar(255)    DEFAULT NULL                COMMENT '商品名称',
  `qty`             decimal(12,2)   DEFAULT NULL                COMMENT '商品数量',
  `carton_qty`      decimal(10,2)   DEFAULT NULL                COMMENT 'SKU维度箱数（可选）',
  `weight`          decimal(12,3)   DEFAULT NULL                COMMENT 'SKU维度重量（可选）',
  `cbm`             decimal(12,3)   DEFAULT NULL                COMMENT 'SKU维度体积（可选）',
  `remark`          text            DEFAULT NULL                COMMENT '备注',

  `create_by`       bigint          DEFAULT NULL                COMMENT '创建人',
  `create_time`     datetime        DEFAULT NULL                COMMENT '创建时间',
  `update_by`       bigint          DEFAULT NULL                COMMENT '更新人',
  `update_time`     datetime        DEFAULT NULL                COMMENT '更新时间',
  `deleted`         tinyint(1)      NOT NULL DEFAULT 0          COMMENT '逻辑删除',

  PRIMARY KEY (`id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`),
  KEY `idx_shipment_id` (`shipment_id`),
  KEY `idx_sku` (`sku`),
  KEY `idx_fnsku` (`fnsku`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='货物订单SKU明细层';


-- ----------------------------
-- 4. 节点轨迹表
-- ----------------------------
DROP TABLE IF EXISTS `oms_cargo_order_node_trace`;
CREATE TABLE `oms_cargo_order_node_trace` (
  `id`              bigint          NOT NULL                    COMMENT '主键ID',
  `tenant_id`       varchar(20)     NOT NULL DEFAULT '000000'   COMMENT '租户ID',
  `cargo_order_id`  bigint          NOT NULL                    COMMENT '货物订单ID',
  `biz_root_id`     bigint          DEFAULT NULL                COMMENT '业务主线ID',

  `node_code`       varchar(64)     NOT NULL                    COMMENT '节点编码（对应 fulfillment_status）',
  `node_name`       varchar(128)    DEFAULT NULL                COMMENT '节点名称（中文）',
  `node_status`     varchar(32)     NOT NULL DEFAULT 'DONE'     COMMENT '节点状态(DONE/PENDING/EXCEPTION)',
  `status_from`     varchar(32)     DEFAULT NULL                COMMENT '变更前状态',
  `status_to`       varchar(32)     DEFAULT NULL                COMMENT '变更后状态',
  `action`          varchar(64)     DEFAULT NULL                COMMENT '触发动作',
  `actual_time`     datetime        DEFAULT NULL                COMMENT '实际完成时间',
  `source_type`     varchar(32)     DEFAULT NULL                COMMENT '来源(MANUAL/OMS/WMS/TMS/SYSTEM)',
  `source_order_no` varchar(128)    DEFAULT NULL                COMMENT '来源单号',
  `operator_id`     bigint          DEFAULT NULL                COMMENT '操作人ID',
  `operator_name`   varchar(64)     DEFAULT NULL                COMMENT '操作人名称',
  `remark`          text            DEFAULT NULL                COMMENT '备注',

  `create_time`     datetime        DEFAULT NULL                COMMENT '创建时间',

  PRIMARY KEY (`id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`),
  KEY `idx_biz_root_id` (`biz_root_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='货物订单节点轨迹表';


-- ----------------------------
-- 5. 字典初始化 SQL
-- RuoYi-Vue-Plus 5.x: sys_dict_type 需要 dict_id（无默认值）
--                      sys_dict_data 需要 dict_code（无默认值）
-- ----------------------------

-- fulfillment_status 字典
INSERT IGNORE INTO sys_dict_type (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, update_by, update_time, remark)
VALUES (9004001, '000000', '货物订单主履约状态', 'oms_cargo_fulfillment_status', 1, NOW(), 1, NOW(), '');

INSERT IGNORE INTO sys_dict_data (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, update_by, update_time, remark)
VALUES
(9004101, '000000', 1,  '待受理',     'PENDING_ACCEPT',    'oms_cargo_fulfillment_status', '', 'default',   'N', 1, NOW(), 1, NOW(), NULL),
(9004102, '000000', 2,  '已受理',     'ACCEPTED',          'oms_cargo_fulfillment_status', '', 'info',      'N', 1, NOW(), 1, NOW(), NULL),
(9004103, '000000', 3,  '在途',       'IN_TRANSIT',        'oms_cargo_fulfillment_status', '', 'info',      'N', 1, NOW(), 1, NOW(), NULL),
(9004104, '000000', 4,  '已到港',     'ARRIVED_PORT',      'oms_cargo_fulfillment_status', '', 'warning',   'N', 1, NOW(), 1, NOW(), NULL),
(9004105, '000000', 5,  '已提柜',     'PICKED_UP',         'oms_cargo_fulfillment_status', '', 'warning',   'N', 1, NOW(), 1, NOW(), NULL),
(9004106, '000000', 6,  '已到仓',     'ARRIVED_WAREHOUSE', 'oms_cargo_fulfillment_status', '', 'warning',   'N', 1, NOW(), 1, NOW(), NULL),
(9004107, '000000', 7,  '拆柜中',     'DEVANNING',         'oms_cargo_fulfillment_status', '', 'warning',   'N', 1, NOW(), 1, NOW(), NULL),
(9004108, '000000', 8,  '拆柜完成',   'DEVANNED',          'oms_cargo_fulfillment_status', '', 'warning',   'N', 1, NOW(), 1, NOW(), NULL),
(9004109, '000000', 9,  '已入库',     'INBOUNDED',         'oms_cargo_fulfillment_status', '', 'success',   'N', 1, NOW(), 1, NOW(), NULL),
(9004110, '000000', 10, '已出单',     'OUTBOUND_ORDERED',  'oms_cargo_fulfillment_status', '', 'success',   'N', 1, NOW(), 1, NOW(), NULL),
(9004111, '000000', 11, '已预约派送', 'DELIVERY_APPOINTED','oms_cargo_fulfillment_status', '', 'success',   'N', 1, NOW(), 1, NOW(), NULL),
(9004112, '000000', 12, '已出库',     'OUTBOUNDED',        'oms_cargo_fulfillment_status', '', 'success',   'N', 1, NOW(), 1, NOW(), NULL),
(9004113, '000000', 13, '派送中',     'DELIVERING',        'oms_cargo_fulfillment_status', '', 'primary',   'N', 1, NOW(), 1, NOW(), NULL),
(9004114, '000000', 14, '已签收',     'DELIVERED',         'oms_cargo_fulfillment_status', '', 'success',   'N', 1, NOW(), 1, NOW(), NULL),
(9004115, '000000', 15, 'POD已回传',  'POD_UPLOADED',      'oms_cargo_fulfillment_status', '', 'success',   'N', 1, NOW(), 1, NOW(), NULL),
(9004116, '000000', 16, '已出账单',   'BILLED',            'oms_cargo_fulfillment_status', '', 'success',   'N', 1, NOW(), 1, NOW(), NULL),
(9004117, '000000', 17, '已完成',     'COMPLETED',         'oms_cargo_fulfillment_status', '', 'success',   'N', 1, NOW(), 1, NOW(), NULL),
(9004118, '000000', 18, '异常中',     'EXCEPTION',         'oms_cargo_fulfillment_status', '', 'error',     'N', 1, NOW(), 1, NOW(), NULL),
(9004119, '000000', 19, '已取消',     'CANCELLED',         'oms_cargo_fulfillment_status', '', 'default',   'N', 1, NOW(), 1, NOW(), NULL);

-- billing_status 字典
INSERT IGNORE INTO sys_dict_type (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, update_by, update_time, remark)
VALUES (9004002, '000000', '货物订单账单状态', 'oms_cargo_billing_status', 1, NOW(), 1, NOW(), '');

INSERT IGNORE INTO sys_dict_data (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, update_by, update_time, remark)
VALUES
(9004121, '000000', 1, '未出账单', 'UNBILLED', 'oms_cargo_billing_status', '', 'warning', 'Y', 1, NOW(), 1, NOW(), NULL),
(9004122, '000000', 2, '已出账单', 'BILLED',   'oms_cargo_billing_status', '', 'success', 'N', 1, NOW(), 1, NOW(), NULL),
(9004123, '000000', 3, '已作废',   'VOIDED',   'oms_cargo_billing_status', '', 'default', 'N', 1, NOW(), 1, NOW(), NULL);

-- pre_outbound_status 字典
INSERT IGNORE INTO sys_dict_type (dict_id, tenant_id, dict_name, dict_type, create_by, create_time, update_by, update_time, remark)
VALUES (9004003, '000000', '货物订单预出单状态', 'oms_cargo_pre_outbound_status', 1, NOW(), 1, NOW(), '');

INSERT IGNORE INTO sys_dict_data (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_by, create_time, update_by, update_time, remark)
VALUES
(9004131, '000000', 1, '无预出单', 'NONE',        'oms_cargo_pre_outbound_status', '', 'default', 'Y', 1, NOW(), 1, NOW(), NULL),
(9004132, '000000', 2, '已预出单', 'PRE_CREATED', 'oms_cargo_pre_outbound_status', '', 'warning', 'N', 1, NOW(), 1, NOW(), NULL),
(9004133, '000000', 3, '已转正式', 'CONVERTED',   'oms_cargo_pre_outbound_status', '', 'success', 'N', 1, NOW(), 1, NOW(), NULL),
(9004134, '000000', 4, '已取消',   'CANCELLED',   'oms_cargo_pre_outbound_status', '', 'error',   'N', 1, NOW(), 1, NOW(), NULL);


-- ----------------------------
-- 6. 菜单 sys_menu
-- 列顺序：menu_id, menu_name, parent_id, order_num, path, component,
--         query, is_frame, is_cache, menu_type, visible, status,
--         perms, icon, create_dept, create_by, create_time,
--         update_by, update_time, remark
-- ID 段：3002（主菜单），3020-3042（按钮权限）
-- 依赖：OMS 父目录 3000 已由 oms_container_order_20260522.sql 创建
-- ----------------------------

-- 主菜单：货物订单
INSERT IGNORE INTO sys_menu VALUES(3002, '货物订单', 3000, 2, 'cargo-order', 'oms/cargo-order/index', '', 1, 0, 'C', '0', '0', 'oms:cargoOrder:list', 'shopping', 103, 1, NOW(), NULL, NULL, '货物订单菜单');

-- CRUD 基础按钮
INSERT IGNORE INTO sys_menu VALUES(3020, '货物订单查询', 3002,  1, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:query',  '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3021, '货物订单新增', 3002,  2, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:add',    '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3022, '货物订单编辑', 3002,  3, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:edit',   '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3023, '货物订单删除', 3002,  4, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:remove', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3024, '货物订单导出', 3002,  5, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:export', '#', 103, 1, NOW(), NULL, NULL, '');

-- 生命周期业务动作按钮
INSERT IGNORE INTO sys_menu VALUES(3025, '受理订单',     3002, 10, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:accept',                  '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3026, '标记在途',     3002, 11, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:markInTransit',           '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3027, '确认到港',     3002, 12, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:confirmArrivedPort',      '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3028, '确认提柜',     3002, 13, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:confirmPickedUp',         '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3029, '确认到仓',     3002, 14, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:confirmArrivedWarehouse', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3030, '开始拆柜',     3002, 15, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:startDevanning',          '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3031, '拆柜完成',     3002, 16, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:finishDevanning',         '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3032, '确认入库',     3002, 17, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:confirmInbounded',        '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3033, '正式出单',     3002, 18, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:createOutboundOrder',     '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3034, '预约派送',     3002, 19, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:appointDelivery',         '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3035, '确认出库',     3002, 20, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:confirmOutbounded',       '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3036, '标记派送中',   3002, 21, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:markDelivering',          '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3037, '确认签收',     3002, 22, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:confirmDelivered',        '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3038, '上传POD',      3002, 23, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:uploadPod',               '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3039, '出账单',       3002, 24, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:confirmBilled',           '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3040, '完结订单',     3002, 25, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:complete',                '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3041, '取消订单',     3002, 26, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:cancel',                  '#', 103, 1, NOW(), NULL, NULL, '');

-- 预出单并行状态按钮
INSERT IGNORE INTO sys_menu VALUES(3042, '创建预出单',   3002, 30, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:createPreOutbound',   '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3043, '转正式出单',   3002, 31, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:convertPreOutbound',  '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3044, '取消预出单',   3002, 32, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:cancelPreOutbound',   '#', 103, 1, NOW(), NULL, NULL, '');

-- 特殊操作按钮
INSERT IGNORE INTO sys_menu VALUES(3045, '修改入库仓',   3002, 40, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:changeInboundWarehouse', '#', 103, 1, NOW(), NULL, NULL, '');
