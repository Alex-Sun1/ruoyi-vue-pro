-- OMS init（Yudao 手工整理版：DDL + 可重复补丁 + system_menu 6900+）
-- 说明：参考系统「建表」与「ADD COLUMN 补丁」不可重复；本文件已去重。
-- 维护：改 sql/migration-overall/source-copies/oms 后运行 node scripts/rebuild-oms-init.mjs
-- 执行顺序:
--   1. sql/mysql/oms-teardown.sql
--   2. sql/mysql/oms-init-from-reference.sql
--   3. sql/mysql/oms-dict-yudao.sql
--   4. sql/mysql/oms-supplement.sql
SET NAMES utf8mb4;



-- ===== fix_cargo_order_schema_20260522.sql =====

-- =================================================================
-- 货物订单表结构修复脚本
-- 问题：oms_cargo_order / oms_cargo_order_shipment 使用旧 schema，
--       与 CargoOrder.java / CargoOrderShipment.java 实体字段不匹配，
--       导致 selectVoList 生成的 SELECT 语句包含数据库中不存在的列，
--       海柜订单详情接口（queryById → cargoOrderMapper.selectVoList）报 500。
--
-- 修复：DROP + CREATE 重建 4 张货物订单相关表，并重新插入演示数据。
-- 注意：此操作会清空以下表的现有数据：
--   oms_cargo_order
--   oms_cargo_order_shipment
--   oms_cargo_order_sku_item
--   oms_cargo_order_node_trace
--   oms_container_cargo_order_rel（关联表数据，一并清理再重插）
-- =================================================================

-- -------------------------------------------------------
-- Part 1: 重建表结构（来自 cargo_order_ddl.sql）
-- -------------------------------------------------------

SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS `oms_cargo_order`;
CREATE TABLE `oms_cargo_order` (
  `id`                          bigint          NOT NULL                    COMMENT '主键ID（雪花）',
  `tenant_id`                   varchar(20)     NOT NULL DEFAULT '000000'   COMMENT '租户ID',
  `company_id`                  bigint          DEFAULT NULL                COMMENT '主体公司ID',
  `biz_root_id`                 bigint          DEFAULT NULL                COMMENT '业务主线ID（全链路串联）',
  `shipment_codes`              varchar(2000)   DEFAULT NULL                COMMENT '货件编码汇总（逗号分隔，服务层聚合回写）',
  `po_nos`                      varchar(2000)   DEFAULT NULL                COMMENT 'PO号汇总（逗号分隔，服务层聚合回写）',
  `marks`                       varchar(2000)   DEFAULT NULL                COMMENT '唛头汇总（逗号分隔，服务层聚合回写）',
  `cargo_order_no`              varchar(64)     NOT NULL                    COMMENT '货物订单号',
  `external_order_no`           varchar(128)    DEFAULT NULL                COMMENT '外部订单号（客户/来源系统）',
  `order_source`                varchar(32)     DEFAULT NULL                COMMENT '订单来源(MANUAL/IMPORT/API/PORTAL)',
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
  `container_order_id`          bigint          DEFAULT NULL                COMMENT '关联海柜订单ID',
  `container_no`                varchar(32)     DEFAULT NULL                COMMENT '柜号（冗余）',
  `inbound_warehouse_id`        bigint          DEFAULT NULL                COMMENT '入库仓库ID',
  `inbound_warehouse_name`      varchar(128)    DEFAULT NULL                COMMENT '入库仓库名称（冗余）',
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
  `parcel_carrier_name`         varchar(128)    DEFAULT NULL                COMMENT '快递商名称',
  `parcel_tracking_no`          varchar(128)    DEFAULT NULL                COMMENT '快递追踪号',
  `transfer_flag`               tinyint(1)      NOT NULL DEFAULT 0          COMMENT '是否转仓',
  `transfer_warehouse_code`     varchar(64)     DEFAULT NULL                COMMENT '转仓目标仓库代码',
  `forecast_qty_unit`           varchar(32)     NOT NULL DEFAULT 'BY_CARTON' COMMENT '预报计量单位 BY_CARTON/BY_PALLET',
  `declared_carton_qty`         decimal(10,2)   DEFAULT NULL                COMMENT '预报箱数',
  `declared_pallet_qty`         decimal(10,2)   DEFAULT NULL                COMMENT '预报板数',
  `declared_piece_qty`          decimal(12,2)   DEFAULT NULL                COMMENT '预报件数',
  `declared_weight`             decimal(12,3)   DEFAULT NULL                COMMENT '预报重量(kg)',
  `declared_cbm`                decimal(12,3)   DEFAULT NULL                COMMENT '预报体积(m³)',
  `actual_carton_qty`           decimal(10,2)   DEFAULT NULL                COMMENT '实际箱数',
  `actual_pallet_qty`           decimal(10,2)   DEFAULT NULL                COMMENT '实际板数（WMS打板统计）',
  `actual_piece_qty`            decimal(12,2)   DEFAULT NULL                COMMENT '实际件数',
  `actual_weight`               decimal(12,3)   DEFAULT NULL                COMMENT '实际重量(kg)',
  `actual_cbm`                  decimal(12,3)   DEFAULT NULL                COMMENT '实际体积(m³)',
  `weight_unit`                 varchar(16)     DEFAULT 'KG'                COMMENT '重量单位(KG/LB)',
  `volume_unit`                 varchar(16)     DEFAULT 'CBM'               COMMENT '体积单位',
  `pre_outbound_flag`           tinyint(1)      NOT NULL DEFAULT 0          COMMENT '是否有预出单',
  `pre_outbound_no`             varchar(64)     DEFAULT NULL                COMMENT '预出单号',
  `pre_outbound_status`         varchar(32)     NOT NULL DEFAULT 'NONE'     COMMENT '预出单状态',
  `pre_outbound_time`           datetime        DEFAULT NULL                COMMENT '生成预出单时间',
  `pre_outbound_convert_time`   datetime        DEFAULT NULL                COMMENT '预出单转正式时间',
  `outbound_batch_no`           varchar(64)     DEFAULT NULL                COMMENT '正式出单号/批次号',
  `outbound_order_status`       varchar(32)     NOT NULL DEFAULT 'NONE'     COMMENT '出单状态',
  `outbound_order_time`         datetime        DEFAULT NULL                COMMENT '正式出单时间',
  `order_status`                varchar(32)     NOT NULL DEFAULT 'NORMAL'   COMMENT '订单状态',
  `fulfillment_status`          varchar(32)     NOT NULL DEFAULT 'PENDING_ACCEPT' COMMENT '主履约状态',
  `appointment_status`          varchar(32)     NOT NULL DEFAULT 'NONE'     COMMENT '预约状态',
  `pod_status`                  varchar(32)     NOT NULL DEFAULT 'PENDING'  COMMENT 'POD状态',
  `billing_status`              varchar(32)     NOT NULL DEFAULT 'UNBILLED' COMMENT '账单状态',
  `earliest_dw_time`            datetime        DEFAULT NULL                COMMENT '最早DW时间（货件层聚合，系统回写）',
  `eta`                         datetime        DEFAULT NULL                COMMENT 'ETA预计到港',
  `ata`                         datetime        DEFAULT NULL                COMMENT 'ATA实际到港',
  `actual_pickup_time`          datetime        DEFAULT NULL                COMMENT '实际提柜时间',
  `actual_arrival_time`         datetime        DEFAULT NULL                COMMENT '实际到仓时间',
  `devanning_finish_time`       datetime        DEFAULT NULL                COMMENT '拆柜完成时间',
  `actual_inbound_time`         datetime        DEFAULT NULL                COMMENT '入库完成时间',
  `delivery_appointment_time`   datetime        DEFAULT NULL                COMMENT '派送预约时间',
  `actual_outbound_time`        datetime        DEFAULT NULL                COMMENT '实际出库时间',
  `signed_time`                 datetime        DEFAULT NULL                COMMENT '签收时间',
  `pod_upload_time`             datetime        DEFAULT NULL                COMMENT 'POD回传时间',
  `billing_time`                datetime        DEFAULT NULL                COMMENT '出账单时间',
  `completed_time`              datetime        DEFAULT NULL                COMMENT '全链路完成时间',
  `exception_flag`              tinyint(1)      NOT NULL DEFAULT 0          COMMENT '是否有未关闭异常',
  `exception_count`             int             NOT NULL DEFAULT 0          COMMENT '未关闭异常数量',
  `parent_order_id`             bigint          DEFAULT NULL                COMMENT '父订单ID（由拆单产生时填写）',
  `customer_remark`             text            DEFAULT NULL                COMMENT '客户备注',
  `internal_remark`             text            DEFAULT NULL                COMMENT '内部备注',
  `operation_remark`            text            DEFAULT NULL                COMMENT '操作备注',
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


DROP TABLE IF EXISTS `oms_cargo_order_shipment`;
CREATE TABLE `oms_cargo_order_shipment` (
  `id`            bigint          NOT NULL                    COMMENT '主键ID',
  `tenant_id`     varchar(20)     NOT NULL DEFAULT '000000'   COMMENT '租户ID',
  `cargo_order_id` bigint         NOT NULL                    COMMENT '货物订单ID',
  `biz_root_id`   bigint          DEFAULT NULL                COMMENT '业务主线ID',
  `create_dept`   bigint          DEFAULT NULL                COMMENT '创建部门',
  `shipment_no`   varchar(128)    NOT NULL                    COMMENT '货件编码',
  `po_no`         varchar(128)    DEFAULT NULL                COMMENT 'PO号',
  `shipping_mark` varchar(128)    DEFAULT NULL                COMMENT '唛头',
  `carton_qty`    decimal(10,2)   DEFAULT NULL                COMMENT '货件箱数',
  `pallet_qty`    decimal(12,0)   DEFAULT NULL                COMMENT '预报板数',
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='货物订单货件层';


DROP TABLE IF EXISTS `oms_cargo_order_sku_item`;
CREATE TABLE `oms_cargo_order_sku_item` (
  `id`              bigint          NOT NULL                    COMMENT '主键ID',
  `tenant_id`       varchar(20)     NOT NULL DEFAULT '000000'   COMMENT '租户ID',
  `cargo_order_id`  bigint          NOT NULL                    COMMENT '货物订单ID（冗余）',
  `shipment_id`     bigint          NOT NULL                    COMMENT '货件ID',
  `create_dept`     bigint          DEFAULT NULL                COMMENT '创建部门',
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


DROP TABLE IF EXISTS `oms_cargo_order_node_trace`;
CREATE TABLE `oms_cargo_order_node_trace` (
  `id`              bigint          NOT NULL                    COMMENT '主键ID',
  `tenant_id`       varchar(20)     NOT NULL DEFAULT '000000'   COMMENT '租户ID',
  `cargo_order_id`  bigint          NOT NULL                    COMMENT '货物订单ID',
  `biz_root_id`     bigint          DEFAULT NULL                COMMENT '业务主线ID',
  `node_code`       varchar(64)     NOT NULL                    COMMENT '节点编码',
  `node_name`       varchar(128)    DEFAULT NULL                COMMENT '节点名称',
  `node_status`     varchar(32)     NOT NULL DEFAULT 'DONE'     COMMENT '节点状态',
  `status_from`     varchar(32)     DEFAULT NULL                COMMENT '变更前状态',
  `status_to`       varchar(32)     DEFAULT NULL                COMMENT '变更后状态',
  `action`          varchar(64)     DEFAULT NULL                COMMENT '触发动作',
  `actual_time`     datetime        DEFAULT NULL                COMMENT '实际完成时间',
  `source_type`     varchar(32)     DEFAULT NULL                COMMENT '来源',
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


SET FOREIGN_KEY_CHECKS=1;

-- 清理关联表旧数据（结构不变，只清数据）
-- [跳过 mock DELETE：关联表在后文 CREATE]


-- -------------------------------------------------------



-- ===== fix_cargo_order_fields_20260523.sql =====

-- ============================================================
-- Patch: oms_cargo_order 补充字段（可重复执行）
-- 日期: 2026-05-23
-- 说明: 新增 HOLD、派送LFD、跟进记录、货件汇总聚合字段
-- 执行前提: cargo_order_ddl.sql 已执行（oms_cargo_order 表存在）
-- ============================================================

-- 临时存储过程：列不存在才执行 ALTER（MySQL 兼容，可重复跑）
DROP PROCEDURE IF EXISTS `_add_col`;
DELIMITER $$
CREATE PROCEDURE `_add_col`(
  IN p_table  VARCHAR(64),
  IN p_col    VARCHAR(64),
  IN p_def    TEXT
)
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME   = p_table
      AND COLUMN_NAME  = p_col
  ) THEN
    SET @_ddl = CONCAT('ALTER TABLE `', p_table, '` ADD COLUMN ', p_def);
    PREPARE _s FROM @_ddl;
    EXECUTE _s;
    DEALLOCATE PREPARE _s;
  END IF;
END$$
DELIMITER ;

-- 1. 货件汇总聚合字段（服务层聚合回写，供列表展示）
CALL _add_col('oms_cargo_order', 'shipment_codes',
  '`shipment_codes` varchar(2000) DEFAULT NULL COMMENT ''货件编码汇总（逗号分隔，服务层聚合回写）'' AFTER `biz_root_id`');
CALL _add_col('oms_cargo_order', 'po_nos',
  '`po_nos` varchar(2000) DEFAULT NULL COMMENT ''PO号汇总（逗号分隔，服务层聚合回写）'' AFTER `shipment_codes`');
CALL _add_col('oms_cargo_order', 'marks',
  '`marks` varchar(2000) DEFAULT NULL COMMENT ''唛头汇总（逗号分隔，服务层聚合回写）'' AFTER `po_nos`');

-- 2. HOLD 标志（货物订单维度，区别于海柜 Hold）
CALL _add_col('oms_cargo_order', 'hold_flag',
  '`hold_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT ''HOLD标志（0正常/1HOLD中）'' AFTER `exception_count`');
CALL _add_col('oms_cargo_order', 'hold_status',
  '`hold_status` varchar(32) NOT NULL DEFAULT ''NORMAL'' COMMENT ''NORMAL/HOLDING/RELEASED'' AFTER `hold_flag`');
CALL _add_col('oms_cargo_order', 'hold_type',
  '`hold_type` varchar(64) DEFAULT NULL COMMENT ''暂扣类型'' AFTER `hold_status`');
CALL _add_col('oms_cargo_order', 'hold_reason',
  '`hold_reason` varchar(500) DEFAULT NULL COMMENT ''当前暂扣原因'' AFTER `hold_type`');
CALL _add_col('oms_cargo_order', 'hold_time',
  '`hold_time` datetime DEFAULT NULL COMMENT ''暂扣时间'' AFTER `hold_reason`');
CALL _add_col('oms_cargo_order', 'hold_user_id',
  '`hold_user_id` bigint DEFAULT NULL COMMENT ''暂扣人ID'' AFTER `hold_time`');
CALL _add_col('oms_cargo_order', 'hold_user_name',
  '`hold_user_name` varchar(128) DEFAULT NULL COMMENT ''暂扣人名称'' AFTER `hold_user_id`');
CALL _add_col('oms_cargo_order', 'release_time',
  '`release_time` datetime DEFAULT NULL COMMENT ''最近放行时间'' AFTER `hold_user_name`');
CALL _add_col('oms_cargo_order', 'hold_remark',
  '`hold_remark` varchar(500) DEFAULT NULL COMMENT ''HOLD原因/说明'' AFTER `hold_reason`');

-- 3. 派送LFD（最晚完成派送日期）
CALL _add_col('oms_cargo_order', 'delivery_lfd',
  '`delivery_lfd` datetime DEFAULT NULL COMMENT ''派送LFD（最晚完成派送日期）'' AFTER `actual_inbound_time`');

-- 4. 跟进记录
CALL _add_col('oms_cargo_order', 'follow_up_remark',
  '`follow_up_remark` text DEFAULT NULL COMMENT ''跟进记录（客服/运营跟进内容）'' AFTER `operation_remark`');

-- 5. oms_cargo_order_shipment 补充 create_dept
CALL _add_col('oms_cargo_order_shipment', 'create_dept',
  '`create_dept` bigint DEFAULT NULL COMMENT ''创建部门'' AFTER `deleted`');

-- 6. oms_cargo_order_sku_item 补充 create_dept
CALL _add_col('oms_cargo_order_sku_item', 'create_dept',
  '`create_dept` bigint DEFAULT NULL COMMENT ''创建部门'' AFTER `deleted`');

-- 清理临时存储过程
DROP PROCEDURE IF EXISTS `_add_col`;



-- ===== oms_container_order_20260522.sql =====

-- ----------------------------
-- OMS 海柜订单第一版：列表、新增、详情
-- ----------------------------

CREATE TABLE IF NOT EXISTS `biz_root` (
  `id` bigint NOT NULL COMMENT '业务主线ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `company_id` bigint NOT NULL COMMENT '主体ID',
  `warehouse_id` bigint DEFAULT NULL COMMENT '当前主仓库ID',
  `root_no` varchar(64) NOT NULL COMMENT '业务主线编号',
  `root_type` varchar(30) NOT NULL COMMENT '业务主线类型',
  `source_module` varchar(30) NOT NULL COMMENT '来源模块',
  `source_order_id` bigint NOT NULL COMMENT '来源订单ID',
  `source_order_no` varchar(64) NOT NULL COMMENT '来源订单号',
  `customer_id` bigint DEFAULT NULL COMMENT '客户ID',
  `customer_name` varchar(128) DEFAULT NULL COMMENT '客户名称',
  `channel_id` bigint DEFAULT NULL COMMENT '渠道ID',
  `business_type_id` bigint DEFAULT NULL COMMENT '业务类型ID',
  `current_module` varchar(30) DEFAULT NULL COMMENT '当前模块',
  `current_node` varchar(64) DEFAULT NULL COMMENT '当前节点编码',
  `current_node_name` varchar(128) DEFAULT NULL COMMENT '当前节点名称',
  `current_node_time` datetime DEFAULT NULL COMMENT '当前节点时间',
  `root_status` varchar(30) NOT NULL DEFAULT 'RUNNING' COMMENT '主线状态',
  `exception_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否异常',
  `exception_count` int NOT NULL DEFAULT 0 COMMENT '异常数',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `complete_time` datetime DEFAULT NULL COMMENT '完成时间',
  `cancel_time` datetime DEFAULT NULL COMMENT '取消时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_root_no_tenant` (`root_no`, `tenant_id`),
  KEY `idx_source_order` (`source_module`, `source_order_id`),
  KEY `idx_company_warehouse` (`company_id`, `warehouse_id`),
  KEY `idx_root_status` (`tenant_id`, `root_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='业务主线根';

CREATE TABLE IF NOT EXISTS `oms_container_order` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `company_id` bigint NOT NULL COMMENT '主体ID',
  `customer_id` bigint NOT NULL COMMENT '客户ID',
  `customer_name` varchar(128) NOT NULL COMMENT '客户名称',
  `channel_id` bigint DEFAULT NULL COMMENT '渠道ID',
  `business_type_id` bigint DEFAULT NULL COMMENT '业务类型ID',
  `owner_user_id` bigint DEFAULT NULL COMMENT '负责人ID',
  `owner_user_name` varchar(64) DEFAULT NULL COMMENT '负责人名称',
  `customer_service_id` bigint DEFAULT NULL COMMENT '客服ID',
  `customer_service_name` varchar(64) DEFAULT NULL COMMENT '客服名称',
  `warehouse_id` bigint NOT NULL COMMENT '入库仓库ID',
  `inbound_warehouse_name` varchar(128) DEFAULT NULL COMMENT '入库仓库名称',
  `container_order_no` varchar(64) NOT NULL COMMENT '海柜订单号',
  `order_source` varchar(32) NOT NULL DEFAULT 'MANUAL' COMMENT '订单来源',
  `container_no` varchar(32) NOT NULL COMMENT '柜号',
  `container_type` varchar(30) NOT NULL COMMENT '柜型',
  `seal_no` varchar(64) DEFAULT NULL COMMENT '封条号',
  `shipping_line_id` bigint DEFAULT NULL COMMENT '船公司ID',
  `shipping_line_name` varchar(128) DEFAULT NULL COMMENT '船公司名称',
  `vessel_name` varchar(128) DEFAULT NULL COMMENT '船名',
  `voyage_no` varchar(64) DEFAULT NULL COMMENT '航次',
  `route_code` varchar(64) DEFAULT NULL COMMENT '航线代码',
  `mbl_no` varchar(64) DEFAULT NULL COMMENT 'MBL',
  `hbl_no` varchar(64) DEFAULT NULL COMMENT 'HBL',
  `discharge_port_id` bigint DEFAULT NULL COMMENT '卸货港ID',
  `discharge_port_name` varchar(128) DEFAULT NULL COMMENT '卸货港名称',
  `terminal_id` bigint DEFAULT NULL COMMENT '码头ID',
  `terminal_name` varchar(128) DEFAULT NULL COMMENT '码头名称',
  `eta` datetime DEFAULT NULL COMMENT '预计到港',
  `ata` datetime DEFAULT NULL COMMENT '实际到港',
  `pickup_lfd` date DEFAULT NULL COMMENT '提柜LFD，仅日期',
  `empty_return_lfd` date DEFAULT NULL COMMENT '还柜LFD，仅日期',
  `terminal_release_status` varchar(30) NOT NULL DEFAULT 'UNKNOWN' COMMENT '码头释放状态',
  `hold_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否Hold',
  `hold_types` varchar(255) DEFAULT NULL COMMENT 'Hold类型，逗号分隔',
  `hold_remark` varchar(500) DEFAULT NULL COMMENT 'Hold备注',
  `exam_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否查验',
  `exam_types` varchar(255) DEFAULT NULL COMMENT '查验类型，逗号分隔',
  `exam_type` varchar(64) DEFAULT NULL COMMENT '查验类型',
  `exam_remark` varchar(500) DEFAULT NULL COMMENT '查验备注',
  `drayage_vendor_id` bigint DEFAULT NULL COMMENT '提柜供应商ID',
  `drayage_vendor_name` varchar(128) DEFAULT NULL COMMENT '提柜供应商名称',
  `pickup_appointment_no` varchar(64) DEFAULT NULL COMMENT '提柜预约号',
  `pickup_appointment_time` datetime DEFAULT NULL COMMENT '提柜预约时间',
  `actual_pickup_time` datetime DEFAULT NULL COMMENT '实际提柜时间',
  `pickup_remark` text DEFAULT NULL COMMENT '提柜备注',
  `expected_arrival_time` datetime DEFAULT NULL COMMENT '预计到仓时间',
  `actual_arrival_time` datetime DEFAULT NULL COMMENT '实际到仓时间',
  `container_location` varchar(128) DEFAULT NULL COMMENT '海柜Location',
  `arrival_remark` text DEFAULT NULL COMMENT '到仓备注',
  `devanning_no` varchar(64) DEFAULT NULL COMMENT '拆柜单号',
  `devanning_order_no` varchar(64) DEFAULT NULL COMMENT '拆柜单号',
  `devanning_warehouse_id` bigint DEFAULT NULL COMMENT '拆柜仓库ID',
  `expected_devanning_time` datetime DEFAULT NULL COMMENT '预计拆柜时间',
  `devanning_appointment_time` datetime DEFAULT NULL COMMENT '拆柜预约时间',
  `devanning_method` varchar(30) DEFAULT NULL COMMENT '拆柜方式',
  `loading_type` varchar(32) DEFAULT NULL COMMENT '装载类型',
  `sorting_method` varchar(32) DEFAULT NULL COMMENT '分货方式',
  `devanning_start_time` datetime DEFAULT NULL COMMENT '开始拆柜时间',
  `devanning_finish_time` datetime DEFAULT NULL COMMENT '拆柜完成时间',
  `devanning_remark` text DEFAULT NULL COMMENT '拆柜备注',
  `empty_return_location` varchar(128) DEFAULT NULL COMMENT '还柜地点',
  `empty_return_appointment_no` varchar(64) DEFAULT NULL COMMENT '还柜预约号',
  `empty_return_time` datetime DEFAULT NULL COMMENT '实际还柜时间',
  `empty_return_status` varchar(30) DEFAULT NULL COMMENT '还柜状态',
  `empty_return_remark` text DEFAULT NULL COMMENT '还柜备注',
  `pre_plan_truck_qty` decimal(12,0) DEFAULT 0 COMMENT '预排车数，关联预出单数量',
  `pre_plan_pallet_qty` decimal(12,0) DEFAULT 0 COMMENT '预排板数（历史兼容字段）',
  `pre_plan_cbm` decimal(12,3) DEFAULT 0 COMMENT '预排体积',
  `total_carton_qty` decimal(12,0) DEFAULT 0 COMMENT '总箱数',
  `total_pallet_qty` decimal(12,0) DEFAULT 0 COMMENT '总板数',
  `total_weight` decimal(12,3) DEFAULT 0 COMMENT '总重量kg',
  `total_cbm` decimal(12,3) DEFAULT 0 COMMENT '总体积CBM',
  `container_exception_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否海柜异常',
  `container_exception_type` varchar(128) DEFAULT NULL COMMENT '海柜异常类型',
  `container_exception_count` int NOT NULL DEFAULT 0 COMMENT '海柜异常数',
  `downstream_exception_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否下游异常',
  `downstream_exception_count` int NOT NULL DEFAULT 0 COMMENT '下游异常数',
  `container_status` varchar(30) NOT NULL DEFAULT 'PENDING_ACCEPT' COMMENT '海柜状态',
  `internal_remark` text DEFAULT NULL COMMENT '内部备注',
  `status` varchar(10) NOT NULL DEFAULT '0' COMMENT '启停状态',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_container_order_no_tenant` (`container_order_no`, `tenant_id`),
  KEY `idx_tenant_status` (`tenant_id`, `container_status`),
  KEY `idx_company_warehouse` (`company_id`, `warehouse_id`),
  KEY `idx_container_no` (`container_no`),
  KEY `idx_eta` (`eta`),
  KEY `idx_pickup_lfd` (`pickup_lfd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='OMS海柜订单';

-- [跳过旧版 oms_cargo_order / oms_cargo_order_shipment：货物订单表见 fix_cargo_order_schema]

CREATE TABLE IF NOT EXISTS `oms_container_cargo_order_rel` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `container_order_id` bigint NOT NULL COMMENT '海柜订单ID',
  `container_order_no` varchar(64) NOT NULL COMMENT '海柜订单号',
  `container_no` varchar(32) NOT NULL COMMENT '柜号',
  `cargo_order_id` bigint NOT NULL COMMENT '货物订单ID',
  `cargo_order_no` varchar(64) NOT NULL COMMENT '货物订单号',
  `relation_type` varchar(30) NOT NULL COMMENT '关系类型',
  `relation_status` varchar(30) NOT NULL DEFAULT 'ACTIVE' COMMENT '关系状态',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_container_cargo` (`container_order_id`, `cargo_order_id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='OMS海柜货物订单关系';

CREATE TABLE IF NOT EXISTS `oms_container_order_trace` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `container_order_id` bigint NOT NULL COMMENT '海柜订单ID',
  `container_order_no` varchar(64) NOT NULL COMMENT '海柜订单号',
  `container_no` varchar(32) DEFAULT NULL COMMENT '柜号',
  `status_from` varchar(30) DEFAULT NULL COMMENT '变更前状态',
  `status_to` varchar(30) NOT NULL COMMENT '变更后状态',
  `action` varchar(64) NOT NULL COMMENT '动作编码',
  `action_desc` varchar(200) DEFAULT NULL COMMENT '动作说明',
  `operator_id` bigint DEFAULT NULL COMMENT '操作人ID',
  `operator_name` varchar(64) DEFAULT NULL COMMENT '操作人名称',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_container_order_id` (`container_order_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='OMS海柜订单轨迹';



-- ===== oms_container_order_enhancement_20260525.sql =====

-- ============================================================
-- 海柜订单字段增强：可提时间 / 要求到仓时间 / Hold&查验字典
-- Date: 2026-05-25
-- 说明：可重复执行
-- ============================================================

-- 1. 新增字段
SET @need_available := (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'oms_container_order'
    AND COLUMN_NAME = 'available_time'
);

SET @add_available_sql := IF(
  @need_available = 0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `available_time` datetime DEFAULT NULL COMMENT ''可提时间（海柜Available）'' AFTER `empty_return_lfd`',
  'SELECT ''available_time 列已存在，跳过'' AS msg'
);
PREPARE stmt FROM @add_available_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @need_required_arrival := (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'oms_container_order'
    AND COLUMN_NAME = 'required_arrival_time'
);

SET @add_required_arrival_sql := IF(
  @need_required_arrival = 0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `required_arrival_time` datetime DEFAULT NULL COMMENT ''要求到仓时间'' AFTER `expected_arrival_time`',
  'SELECT ''required_arrival_time 列已存在，跳过'' AS msg'
);
PREPARE stmt FROM @add_required_arrival_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2. Hold 类型字典


-- 3. 查验类型字典



-- ===== oms_order_enhancement_20260523.sql =====

-- 海柜订单 & 货物订单附件、HOLD、拆单回并增强

CREATE TABLE IF NOT EXISTS `biz_attachment` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `biz_root_id` bigint DEFAULT NULL COMMENT '业务主线ID，海柜附件可为空',
  `target_type` varchar(64) NOT NULL COMMENT '目标类型：CARGO_ORDER/CARGO_SHIPMENT/CONTAINER_ORDER/POD/EXCEPTION',
  `target_id` bigint NOT NULL COMMENT '目标对象ID',
  `target_no` varchar(64) NOT NULL COMMENT '目标对象编号',
  `attachment_type` varchar(64) NOT NULL COMMENT '附件类型：DO/BOL/POD/INVOICE/EXCEPTION_IMAGE/CUSTOMER_FILE/OTHER',
  `file_name` varchar(255) NOT NULL COMMENT '文件名',
  `file_url` varchar(500) NOT NULL COMMENT '文件URL',
  `file_size` bigint DEFAULT NULL COMMENT '文件大小',
  `file_ext` varchar(32) DEFAULT NULL COMMENT '文件后缀',
  `mime_type` varchar(128) DEFAULT NULL COMMENT 'MIME类型',
  `customer_visible_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT '客户是否可见',
  `internal_visible_flag` tinyint(1) NOT NULL DEFAULT 1 COMMENT '内部是否可见',
  `upload_user_id` bigint DEFAULT NULL COMMENT '上传人ID',
  `upload_user_name` varchar(128) DEFAULT NULL COMMENT '上传人名称',
  `upload_time` datetime NOT NULL COMMENT '上传时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  KEY `idx_target` (`target_type`, `target_id`),
  KEY `idx_biz_root_id` (`biz_root_id`),
  KEY `idx_attachment_type` (`attachment_type`),
  KEY `idx_upload_time` (`upload_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='业务附件表';

CREATE TABLE IF NOT EXISTS `oms_cargo_order_hold_record` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `cargo_order_id` bigint NOT NULL COMMENT '货物订单ID',
  `cargo_order_no` varchar(64) NOT NULL COMMENT '货物订单号',
  `biz_root_id` bigint DEFAULT NULL COMMENT '业务主线ID',
  `hold_type` varchar(64) NOT NULL COMMENT '暂扣类型',
  `hold_reason` varchar(500) NOT NULL COMMENT '暂扣原因',
  `hold_status` varchar(32) NOT NULL COMMENT 'HOLDING/RELEASED',
  `hold_time` datetime NOT NULL COMMENT '暂扣时间',
  `hold_user_id` bigint DEFAULT NULL COMMENT '暂扣人ID',
  `hold_user_name` varchar(128) DEFAULT NULL COMMENT '暂扣人名称',
  `release_reason` varchar(500) DEFAULT NULL COMMENT '放行原因',
  `release_time` datetime DEFAULT NULL COMMENT '放行时间',
  `release_user_id` bigint DEFAULT NULL COMMENT '放行人ID',
  `release_user_name` varchar(128) DEFAULT NULL COMMENT '放行人名称',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`),
  KEY `idx_biz_root_id` (`biz_root_id`),
  KEY `idx_hold_status` (`hold_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='货物订单HOLD记录';

SET @schema_name = DATABASE();

SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_container_order' AND column_name = 'attachment_count') = 0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `attachment_count` int NOT NULL DEFAULT 0 COMMENT ''海柜附件总数'' AFTER `downstream_exception_count`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_container_order' AND column_name = 'do_attachment_count') = 0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `do_attachment_count` int NOT NULL DEFAULT 0 COMMENT ''DO附件数量'' AFTER `attachment_count`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_container_order' AND column_name = 'latest_attachment_time') = 0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `latest_attachment_time` datetime DEFAULT NULL COMMENT ''最近附件上传时间'' AFTER `do_attachment_count`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_container_order' AND column_name = 'latest_do_upload_time') = 0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `latest_do_upload_time` datetime DEFAULT NULL COMMENT ''最近DO上传时间'' AFTER `latest_attachment_time`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'attachment_count') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `attachment_count` int NOT NULL DEFAULT 0 COMMENT ''本单附件数量'' AFTER `parent_order_id`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'pod_attachment_count') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `pod_attachment_count` int NOT NULL DEFAULT 0 COMMENT ''POD附件数量'' AFTER `attachment_count`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'exception_attachment_count') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `exception_attachment_count` int NOT NULL DEFAULT 0 COMMENT ''异常附件数量'' AFTER `pod_attachment_count`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'latest_attachment_time') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `latest_attachment_time` datetime DEFAULT NULL COMMENT ''最近附件上传时间'' AFTER `exception_attachment_count`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'hold_status') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `hold_status` varchar(32) NOT NULL DEFAULT ''NORMAL'' COMMENT ''NORMAL/HOLDING/RELEASED'' AFTER `hold_flag`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'hold_type') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `hold_type` varchar(64) DEFAULT NULL COMMENT ''暂扣类型'' AFTER `hold_status`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'hold_reason') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `hold_reason` varchar(500) DEFAULT NULL COMMENT ''当前暂扣原因'' AFTER `hold_type`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'hold_time') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `hold_time` datetime DEFAULT NULL COMMENT ''暂扣时间'' AFTER `hold_reason`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'hold_user_id') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `hold_user_id` bigint DEFAULT NULL COMMENT ''暂扣人ID'' AFTER `hold_time`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'hold_user_name') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `hold_user_name` varchar(128) DEFAULT NULL COMMENT ''暂扣人名称'' AFTER `hold_user_id`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'release_time') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `release_time` datetime DEFAULT NULL COMMENT ''最近放行时间'' AFTER `hold_user_name`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'parent_order_no') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `parent_order_no` varchar(64) DEFAULT NULL COMMENT ''父级货物订单号'' AFTER `parent_order_id`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'root_order_id') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `root_order_id` bigint DEFAULT NULL COMMENT ''最初原单ID'' AFTER `parent_order_no`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'root_order_no') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `root_order_no` varchar(64) DEFAULT NULL COMMENT ''最初原单号'' AFTER `root_order_id`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'split_flag') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `split_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT ''是否参与拆单'' AFTER `root_order_no`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'split_role') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `split_role` varchar(32) NOT NULL DEFAULT ''NORMAL'' COMMENT ''NORMAL/SPLIT_PARENT/SPLIT_CHILD'' AFTER `split_flag`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'split_status') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `split_status` varchar(32) NOT NULL DEFAULT ''NONE'' COMMENT ''NONE/SPLIT_ACTIVE/MERGED_BACK/PARTIAL_MERGED_BACK'' AFTER `split_role`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'split_group_no') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `split_group_no` varchar(64) DEFAULT NULL COMMENT ''拆单批次号'' AFTER `split_status`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'child_order_count') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `child_order_count` int NOT NULL DEFAULT 0 COMMENT ''子单数量'' AFTER `split_group_no`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'merged_back_time') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `merged_back_time` datetime DEFAULT NULL COMMENT ''回并时间'' AFTER `child_order_count`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'merged_back_by') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `merged_back_by` bigint DEFAULT NULL COMMENT ''回并人'' AFTER `merged_back_time`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'split_source') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `split_source` varchar(32) DEFAULT NULL COMMENT ''CUSTOMER/INTERNAL'' AFTER `merged_back_by`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'customer_visible_flag') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `customer_visible_flag` tinyint(1) NOT NULL DEFAULT 1 COMMENT ''客户是否可见'' AFTER `split_source`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'customer_split_reason') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `customer_split_reason` varchar(500) DEFAULT NULL COMMENT ''客户拆单原因'' AFTER `customer_visible_flag`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'internal_split_reason') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `internal_split_reason` varchar(500) DEFAULT NULL COMMENT ''内部拆单原因'' AFTER `customer_split_reason`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'split_requested_by') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `split_requested_by` varchar(32) DEFAULT NULL COMMENT ''发起来源'' AFTER `internal_split_reason`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'split_requested_user_id') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `split_requested_user_id` bigint DEFAULT NULL COMMENT ''发起人ID'' AFTER `split_requested_by`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'split_requested_user_name') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `split_requested_user_name` varchar(128) DEFAULT NULL COMMENT ''发起人名称'' AFTER `split_requested_user_id`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'split_time') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `split_time` datetime DEFAULT NULL COMMENT ''拆单时间'' AFTER `split_requested_user_name`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'split_fee_flag') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `split_fee_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT ''是否可能产生拆单费用'' AFTER `split_time`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'split_fee_amount') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `split_fee_amount` decimal(10,2) DEFAULT NULL COMMENT ''拆单费用'' AFTER `split_fee_flag`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'split_fee_remark') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `split_fee_remark` varchar(500) DEFAULT NULL COMMENT ''拆单费用备注'' AFTER `split_fee_amount`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;



-- ===== oms_cargo_grouping_rule_20260527.sql =====

-- OMS cargo grouping rule

CREATE TABLE IF NOT EXISTS `oms_cargo_grouping_field_meta` (
  `id` bigint NOT NULL COMMENT 'ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `table_alias` varchar(32) NOT NULL COMMENT '表别名 order/shipment',
  `field_name` varchar(64) NOT NULL COMMENT '字段名',
  `display_name` varchar(128) NOT NULL COMMENT '展示名称',
  `data_type` varchar(32) NOT NULL COMMENT 'STRING/NUMBER/DATE/ENUM/REF',
  `enum_code` varchar(64) DEFAULT NULL COMMENT '字典编码',
  `ref_type` varchar(64) DEFAULT NULL COMMENT '引用资料类型',
  `can_be_condition` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否可作为条件',
  `can_be_group_key` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否可作为分组键',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序',
  `enabled` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_grouping_field` (`table_alias`,`field_name`),
  KEY `idx_grouping_field_enabled` (`enabled`),
  KEY `idx_grouping_field_condition` (`can_be_condition`),
  KEY `idx_grouping_field_group_key` (`can_be_group_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='OMS货物订单分组字段元数据';

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_cargo_grouping_field_meta' AND COLUMN_NAME = 'tenant_id') = 0,
  'ALTER TABLE `oms_cargo_grouping_field_meta` ADD COLUMN `tenant_id` varchar(20) NOT NULL DEFAULT ''000000'' COMMENT ''租户ID'' AFTER `id`',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

CREATE TABLE IF NOT EXISTS `oms_cargo_grouping_rule` (
  `id` bigint NOT NULL COMMENT 'ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `warehouse_id` bigint NOT NULL COMMENT '仓库ID',
  `warehouse_name` varchar(128) DEFAULT NULL COMMENT '仓库名称',
  `rule_name` varchar(128) NOT NULL COMMENT '规则名称',
  `condition_config` json NOT NULL COMMENT '匹配条件JSON',
  `group_key_config` json NOT NULL COMMENT '分组键JSON',
  `priority` int NOT NULL DEFAULT 0 COMMENT '优先级，越大越先匹配',
  `is_default` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否内置默认规则',
  `status` varchar(32) NOT NULL DEFAULT 'enabled' COMMENT 'enabled/disabled',
  `version` int NOT NULL DEFAULT 0 COMMENT '乐观锁版本',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  KEY `idx_grouping_rule_warehouse` (`warehouse_id`),
  KEY `idx_grouping_rule_status` (`status`),
  KEY `idx_grouping_rule_priority` (`warehouse_id`,`status`,`priority`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='OMS货物订单分组规则';

INSERT IGNORE INTO `oms_cargo_grouping_field_meta`
(`id`, `table_alias`, `field_name`, `display_name`, `data_type`, `enum_code`, `ref_type`, `can_be_condition`, `can_be_group_key`, `sort_order`, `enabled`, `remark`, `create_by`, `create_time`)
VALUES
(9301001, 'order', 'order_no', '订单号', 'STRING', NULL, NULL, 0, 1, 10, 1, '货物订单号', 1, NOW()),
(9301002, 'order', 'order_type', '业务类型/派送方式', 'ENUM', 'base_business_type', NULL, 1, 1, 20, 1, '货物订单业务类型/派送方式', 1, NOW()),
(9301003, 'order', 'address_type', '地址类型', 'ENUM', 'oms_address_type', NULL, 1, 1, 30, 1, '平台仓、私仓、商业地址', 1, NOW()),
(9301010, 'order', 'platform_id', '平台', 'REF', NULL, 'base_platform', 1, 1, 40, 1, '目的地平台基础资料', 1, NOW()),
(9301004, 'order', 'platform_code', '仓库代码', 'REF', NULL, 'base_platform_address', 1, 1, 45, 1, '目的地平台仓代码', 1, NOW()),
(9301011, 'order', 'parcel_carrier_name', '快递商', 'ENUM', 'oms_parcel_carrier', NULL, 1, 1, 47, 1, '快递派送承运商字典', 1, NOW()),
(9301005, 'order', 'customer_id', '客户', 'REF', NULL, 'base_customer', 1, 0, 50, 1, '客户ID', 1, NOW()),
(9301006, 'order', 'channel_id', '渠道', 'REF', NULL, 'base_channel', 1, 0, 60, 1, '业务渠道', 1, NOW()),
(9301007, 'shipment', 'shipment_no', '货件编号', 'STRING', NULL, NULL, 0, 1, 70, 1, '货件编号', 1, NOW()),
(9301008, 'shipment', 'warehouse_code', '货件仓库代码', 'STRING', NULL, NULL, 0, 1, 80, 1, '货件分组仓库代码，当前从订单仓库代码兜底', 1, NOW()),
(9301009, 'shipment', 'shipment_type', '货件类型', 'ENUM', 'oms_shipment_type', NULL, 0, 1, 90, 1, '预留货件类型', 1, NOW());

UPDATE `oms_cargo_grouping_field_meta`
SET `display_name` = CASE `id`
  WHEN 9301001 THEN '订单号'
  WHEN 9301002 THEN '业务类型/派送方式'
  WHEN 9301003 THEN '地址类型'
  WHEN 9301004 THEN '仓库代码'
  WHEN 9301005 THEN '客户'
  WHEN 9301006 THEN '渠道'
  WHEN 9301007 THEN '货件编号'
  WHEN 9301008 THEN '货件仓库代码'
  WHEN 9301009 THEN '货件类型'
  WHEN 9301010 THEN '平台'
  WHEN 9301011 THEN '快递商'
  ELSE `display_name`
END,
`remark` = CASE `id`
  WHEN 9301001 THEN '货物订单号'
  WHEN 9301002 THEN '货物订单业务类型/派送方式'
  WHEN 9301003 THEN '平台仓、私仓、商业地址'
  WHEN 9301004 THEN '目的地平台仓代码'
  WHEN 9301005 THEN '客户ID'
  WHEN 9301006 THEN '业务渠道'
  WHEN 9301007 THEN '货件编号'
  WHEN 9301008 THEN '货件分组仓库代码，当前从订单仓库代码兜底'
  WHEN 9301009 THEN '预留货件类型'
  WHEN 9301010 THEN '目的地平台基础资料'
  WHEN 9301011 THEN '快递派送承运商字典'
  ELSE `remark`
END
WHERE `id` BETWEEN 9301001 AND 9301011;

UPDATE `oms_cargo_grouping_field_meta`
SET `ref_type` = 'base_platform_address', `sort_order` = 45
WHERE `id` = 9301004;

UPDATE `oms_cargo_grouping_field_meta`
SET `ref_type` = 'base_platform', `sort_order` = 40, `can_be_condition` = 1, `can_be_group_key` = 1
WHERE `id` = 9301010;

UPDATE `oms_cargo_grouping_field_meta`
SET `data_type` = 'ENUM',
    `enum_code` = 'oms_parcel_carrier',
    `ref_type` = NULL,
    `sort_order` = 47,
    `can_be_condition` = 1,
    `can_be_group_key` = 1
WHERE `id` = 9301011;

INSERT IGNORE INTO `oms_cargo_grouping_rule`
(`id`, `tenant_id`, `warehouse_id`, `warehouse_name`, `rule_name`, `condition_config`, `group_key_config`, `priority`, `is_default`, `status`, `version`, `remark`, `create_by`, `create_time`, `deleted`)
VALUES
(9302001, '000000', 4001001, 'Los Angeles Central Warehouse', 'LA仓-FBA平台仓分组', JSON_OBJECT('mode','VALUE_MATCH','logic','AND','conditions',JSON_ARRAY(JSON_OBJECT('field','order.order_type','op','IN','value',JSON_ARRAY('FBA头程','快递派送')),JSON_OBJECT('field','order.address_type','op','EQ','value','平台仓'))), JSON_OBJECT('separator','-','fields',JSON_ARRAY(JSON_OBJECT('field','order.platform_code'),JSON_OBJECT('field','shipment.warehouse_code'))), 50, 1, 'enabled', 0, '内置规则：FBA/快递平台仓按仓库代码与货件仓库代码分组', 1, NOW(), 0),
(9302002, '000000', 4001001, 'Los Angeles Central Warehouse', 'LA仓-卡车派送按州城市分组', JSON_OBJECT('mode','VALUE_MATCH','logic','AND','conditions',JSON_ARRAY(JSON_OBJECT('field','order.order_type','op','EQ','value','卡车派送'))), JSON_OBJECT('separator','-','fields',JSON_ARRAY(JSON_OBJECT('field','order.state'),JSON_OBJECT('field','order.city'))), 30, 1, 'enabled', 0, '内置规则：卡车派送按州和城市分组', 1, NOW(), 0),
(9302003, '000000', 4001001, 'Los Angeles Central Warehouse', 'LA仓-默认规则', JSON_OBJECT('mode','VALUE_MATCH','logic','AND','conditions',JSON_ARRAY()), JSON_OBJECT('separator','-','fields',JSON_ARRAY(JSON_OBJECT('field','order.customer_id'),JSON_OBJECT('field','order.order_type'))), 0, 1, 'enabled', 0, '兜底规则', 1, NOW(), 0),
(9302101, '000000', 4001002, 'New Jersey East Coast Warehouse', 'NJ仓-FBA平台仓分组', JSON_OBJECT('mode','VALUE_MATCH','logic','AND','conditions',JSON_ARRAY(JSON_OBJECT('field','order.address_type','op','EQ','value','平台仓'))), JSON_OBJECT('separator','-','fields',JSON_ARRAY(JSON_OBJECT('field','order.platform_code'),JSON_OBJECT('field','shipment.warehouse_code'))), 50, 1, 'enabled', 0, '内置规则：平台仓按仓库代码分组', 1, NOW(), 0),
(9302102, '000000', 4001002, 'New Jersey East Coast Warehouse', 'NJ仓-默认规则', JSON_OBJECT('mode','VALUE_MATCH','logic','AND','conditions',JSON_ARRAY()), JSON_OBJECT('separator','-','fields',JSON_ARRAY(JSON_OBJECT('field','order.customer_id'),JSON_OBJECT('field','order.order_type'))), 0, 1, 'enabled', 0, '兜底规则', 1, NOW(), 0),
(9302201, '000000', 4001003, 'Texas Central Hub', 'TX仓-默认规则', JSON_OBJECT('mode','VALUE_MATCH','logic','AND','conditions',JSON_ARRAY()), JSON_OBJECT('separator','-','fields',JSON_ARRAY(JSON_OBJECT('field','order.customer_id'),JSON_OBJECT('field','order.order_type'))), 0, 1, 'enabled', 0, '兜底规则', 1, NOW(), 0);

UPDATE `oms_cargo_grouping_rule`
SET `rule_name` = 'LA仓-FBA平台仓分组',
    `condition_config` = JSON_OBJECT('mode','VALUE_MATCH','logic','AND','conditions',JSON_ARRAY(JSON_OBJECT('field','order.order_type','op','IN','value',JSON_ARRAY('FBA头程','快递派送')),JSON_OBJECT('field','order.address_type','op','EQ','value','PLATFORM_WH'))),
    `group_key_config` = JSON_OBJECT('separator','-','fields',JSON_ARRAY(JSON_OBJECT('field','order.platform_code'),JSON_OBJECT('field','shipment.warehouse_code'))),
    `remark` = '内置规则：FBA/快递平台仓按仓库代码与货件仓库代码分组'
WHERE `id` = 9302001;

UPDATE `oms_cargo_grouping_rule`
SET `rule_name` = 'LA仓-卡车派送按州城市分组',
    `condition_config` = JSON_OBJECT('mode','VALUE_MATCH','logic','AND','conditions',JSON_ARRAY(JSON_OBJECT('field','order.order_type','op','EQ','value','卡车派送'))),
    `group_key_config` = JSON_OBJECT('separator','-','fields',JSON_ARRAY(JSON_OBJECT('field','order.state'),JSON_OBJECT('field','order.city'))),
    `remark` = '内置规则：卡车派送按州和城市分组'
WHERE `id` = 9302002;

UPDATE `oms_cargo_grouping_rule`
SET `rule_name` = 'LA仓-默认规则',
    `condition_config` = JSON_OBJECT('mode','VALUE_MATCH','logic','AND','conditions',JSON_ARRAY()),
    `group_key_config` = JSON_OBJECT('separator','-','fields',JSON_ARRAY(JSON_OBJECT('field','order.customer_id'),JSON_OBJECT('field','order.order_type'))),
    `remark` = '兜底规则'
WHERE `id` = 9302003;

UPDATE `oms_cargo_grouping_rule`
SET `rule_name` = 'NJ仓-FBA平台仓分组',
    `condition_config` = JSON_OBJECT('mode','VALUE_MATCH','logic','AND','conditions',JSON_ARRAY(JSON_OBJECT('field','order.address_type','op','EQ','value','PLATFORM_WH'))),
    `group_key_config` = JSON_OBJECT('separator','-','fields',JSON_ARRAY(JSON_OBJECT('field','order.platform_code'),JSON_OBJECT('field','shipment.warehouse_code'))),
    `remark` = '内置规则：平台仓按仓库代码分组'
WHERE `id` = 9302101;

UPDATE `oms_cargo_grouping_rule`
SET `rule_name` = 'NJ仓-默认规则',
    `condition_config` = JSON_OBJECT('mode','VALUE_MATCH','logic','AND','conditions',JSON_ARRAY()),
    `group_key_config` = JSON_OBJECT('separator','-','fields',JSON_ARRAY(JSON_OBJECT('field','order.customer_id'),JSON_OBJECT('field','order.order_type'))),
    `remark` = '兜底规则'
WHERE `id` = 9302102;

UPDATE `oms_cargo_grouping_rule`
SET `rule_name` = 'TX仓-默认规则',
    `condition_config` = JSON_OBJECT('mode','VALUE_MATCH','logic','AND','conditions',JSON_ARRAY()),
    `group_key_config` = JSON_OBJECT('separator','-','fields',JSON_ARRAY(JSON_OBJECT('field','order.customer_id'),JSON_OBJECT('field','order.order_type'))),
    `remark` = '兜底规则'
WHERE `id` = 9302201;



-- ===== oms_biz_root_lifecycle_20260527.sql =====

-- =============================================================
-- OMS cargo lifecycle migration
-- Date: 2026-05-27
-- Goal:
--   1. Use biz_root.current_node as the source of truth for cargo lifecycle.
--   2. Backfill biz_root from existing oms_cargo_order.fulfillment_status.
--   3. Remove redundant oms_cargo_order.current_node/current_node_time.
-- 兼容 MySQL Workbench Safe Update Mode
-- =============================================================

SET SQL_SAFE_UPDATES = 0;

UPDATE `oms_cargo_order` co
LEFT JOIN `biz_root` br ON br.`id` = co.`biz_root_id`
SET co.`biz_root_id` = co.`id` + 900000000000000000
WHERE co.`deleted` = 0
  AND co.`biz_root_id` IS NULL
  AND br.`id` IS NULL;

INSERT IGNORE INTO `biz_root` (
    `id`, `tenant_id`, `company_id`, `warehouse_id`, `root_no`, `root_type`,
    `source_module`, `source_order_id`, `source_order_no`,
    `customer_id`, `customer_name`, `channel_id`, `business_type_id`,
    `current_module`, `current_node`, `current_node_name`, `current_node_time`,
    `root_status`, `exception_flag`, `exception_count`, `start_time`,
    `complete_time`, `cancel_time`, `remark`,
    `create_by`, `create_time`, `update_by`, `update_time`, `deleted`
)
SELECT co.`biz_root_id`,
       co.`tenant_id`,
       co.`company_id`,
       co.`inbound_warehouse_id`,
       co.`cargo_order_no`,
       'CARGO_ORDER',
       'OMS',
       co.`id`,
       co.`cargo_order_no`,
       co.`customer_id`,
       co.`customer_name`,
       co.`channel_id`,
       co.`business_type_id`,
       'OMS',
       COALESCE(NULLIF(co.`fulfillment_status`, ''), 'PENDING_ACCEPT'),
       CASE COALESCE(NULLIF(co.`fulfillment_status`, ''), 'PENDING_ACCEPT')
           WHEN 'PENDING_ACCEPT' THEN '待受理'
           WHEN 'ACCEPTED' THEN '已受理'
           WHEN 'IN_TRANSIT' THEN '在途'
           WHEN 'ARRIVED_PORT' THEN '已到港'
           WHEN 'PICKED_UP' THEN '已提柜'
           WHEN 'ARRIVED_WAREHOUSE' THEN '已到仓'
           WHEN 'DEVANNING' THEN '拆柜中'
           WHEN 'DEVANNED' THEN '拆柜完成'
           WHEN 'INBOUNDED' THEN '已入库'
           WHEN 'OUTBOUND_ORDERED' THEN '已出单'
           WHEN 'DELIVERY_APPOINTED' THEN '已预约派送'
           WHEN 'OUTBOUNDED' THEN '已出库'
           WHEN 'DELIVERING' THEN '派送中'
           WHEN 'DELIVERED' THEN '已签收'
           WHEN 'POD_UPLOADED' THEN 'POD已上传'
           WHEN 'BILLED' THEN '已出账'
           WHEN 'COMPLETED' THEN '已完成'
           WHEN 'CANCELLED' THEN '已取消'
           ELSE '待受理'
       END,
       COALESCE(co.`update_time`, co.`create_time`, NOW()),
       CASE COALESCE(NULLIF(co.`fulfillment_status`, ''), 'PENDING_ACCEPT')
           WHEN 'COMPLETED' THEN 'DONE'
           WHEN 'CANCELLED' THEN 'CANCELLED'
           ELSE 'RUNNING'
       END,
       0,
       0,
       COALESCE(co.`create_time`, NOW()),
       CASE WHEN co.`fulfillment_status` = 'COMPLETED' THEN COALESCE(co.`completed_time`, co.`update_time`) ELSE NULL END,
       CASE WHEN co.`fulfillment_status` = 'CANCELLED' THEN co.`update_time` ELSE NULL END,
       '历史货物订单补建业务主线',
       co.`create_by`,
       COALESCE(co.`create_time`, NOW()),
       co.`update_by`,
       co.`update_time`,
       0
FROM `oms_cargo_order` co
LEFT JOIN `biz_root` br ON br.`id` = co.`biz_root_id`
WHERE co.`deleted` = 0
  AND co.`biz_root_id` IS NOT NULL
  AND br.`id` IS NULL;

UPDATE `biz_root` br
INNER JOIN `oms_cargo_order` co ON co.`biz_root_id` = br.`id`
SET br.`current_module` = 'OMS',
    br.`current_node` = COALESCE(NULLIF(co.`fulfillment_status`, ''), br.`current_node`, 'PENDING_ACCEPT'),
    br.`current_node_name` = CASE COALESCE(NULLIF(co.`fulfillment_status`, ''), br.`current_node`, 'PENDING_ACCEPT')
        WHEN 'PENDING_ACCEPT' THEN '待受理'
        WHEN 'ACCEPTED' THEN '已受理'
        WHEN 'IN_TRANSIT' THEN '在途'
        WHEN 'ARRIVED_PORT' THEN '已到港'
        WHEN 'PICKED_UP' THEN '已提柜'
        WHEN 'ARRIVED_WAREHOUSE' THEN '已到仓'
        WHEN 'DEVANNING' THEN '拆柜中'
        WHEN 'DEVANNED' THEN '拆柜完成'
        WHEN 'INBOUNDED' THEN '已入库'
        WHEN 'OUTBOUND_ORDERED' THEN '已出单'
        WHEN 'DELIVERY_APPOINTED' THEN '已预约派送'
        WHEN 'OUTBOUNDED' THEN '已出库'
        WHEN 'DELIVERING' THEN '派送中'
        WHEN 'DELIVERED' THEN '已签收'
        WHEN 'POD_UPLOADED' THEN 'POD已上传'
        WHEN 'BILLED' THEN '已出账'
        WHEN 'COMPLETED' THEN '已完成'
        WHEN 'CANCELLED' THEN '已取消'
        WHEN 'CARGO_CREATED' THEN '待受理'
        ELSE COALESCE(br.`current_node_name`, '待受理')
    END,
    br.`current_node_time` = COALESCE(br.`current_node_time`, co.`update_time`, co.`create_time`, NOW()),
    br.`root_status` = CASE COALESCE(NULLIF(co.`fulfillment_status`, ''), br.`current_node`, 'PENDING_ACCEPT')
        WHEN 'COMPLETED' THEN 'DONE'
        WHEN 'CANCELLED' THEN 'CANCELLED'
        ELSE 'RUNNING'
    END,
    br.`complete_time` = CASE
        WHEN COALESCE(NULLIF(co.`fulfillment_status`, ''), br.`current_node`) = 'COMPLETED'
            THEN COALESCE(co.`completed_time`, br.`complete_time`, co.`update_time`)
        ELSE br.`complete_time`
    END,
    br.`cancel_time` = CASE
        WHEN COALESCE(NULLIF(co.`fulfillment_status`, ''), br.`current_node`) = 'CANCELLED'
            THEN COALESCE(br.`cancel_time`, co.`update_time`)
        ELSE br.`cancel_time`
    END
WHERE co.`deleted` = 0;

UPDATE `biz_root`
SET `current_node` = 'PENDING_ACCEPT',
    `current_node_name` = '待受理'
WHERE `root_type` IN ('CARGO', 'CARGO_ORDER')
  AND `current_node` = 'CARGO_CREATED';

SET SQL_SAFE_UPDATES = 1;

SET @idx_exists := (
    SELECT COUNT(1)
    FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'biz_root'
      AND INDEX_NAME = 'idx_biz_root_current_node'
);
SET @sql := IF(@idx_exists = 0,
    'ALTER TABLE `biz_root` ADD INDEX `idx_biz_root_current_node` (`current_node`)',
    'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @col_exists := (
    SELECT COUNT(1)
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'oms_cargo_order'
      AND COLUMN_NAME = 'current_node'
);
SET @sql := IF(@col_exists > 0,
    'ALTER TABLE `oms_cargo_order` DROP COLUMN `current_node`',
    'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @col_exists := (
    SELECT COUNT(1)
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'oms_cargo_order'
      AND COLUMN_NAME = 'current_node_time'
);
SET @sql := IF(@col_exists > 0,
    'ALTER TABLE `oms_cargo_order` DROP COLUMN `current_node_time`',
    'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;



-- ===== oms_cargo_order_enhancement_20260524.sql =====

-- =====================================================
-- 海柜/货物订单增强 DDL + 权限  2026-05-24
-- 内容：按板按箱计量、转仓动作权限、导入权限
-- =====================================================

SET @schema_name = DATABASE();

-- 货物订单：预报计量单位 + 预报板数
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'forecast_qty_unit') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `forecast_qty_unit` varchar(32) NOT NULL DEFAULT ''BY_CARTON'' COMMENT ''预报计量单位 BY_CARTON/BY_PALLET'' AFTER `transfer_warehouse_code`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'declared_pallet_qty') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `declared_pallet_qty` decimal(10,2) DEFAULT NULL COMMENT ''预报板数'' AFTER `declared_carton_qty`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 货件层：预报板数
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order_shipment' AND column_name = 'pallet_qty') = 0,
  'ALTER TABLE `oms_cargo_order_shipment` ADD COLUMN `pallet_qty` decimal(12,0) DEFAULT NULL COMMENT ''预报板数'' AFTER `carton_qty`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 字典：预报计量单位

-- 菜单权限



-- ===== oms_outbound_20260524.sql =====

-- OMS outbound pool / pre-outbound / outbound order

CREATE TABLE IF NOT EXISTS `oms_pre_outbound` (
  `id` bigint NOT NULL COMMENT 'ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `biz_root_id` bigint DEFAULT NULL COMMENT '业务主线ID',
  `cargo_order_id` bigint NOT NULL COMMENT '货物订单ID',
  `cargo_order_no` varchar(64) NOT NULL COMMENT '货物订单号',
  `pre_outbound_no` varchar(64) NOT NULL COMMENT '预出单号',
  `pre_outbound_status` varchar(32) NOT NULL DEFAULT 'PENDING_INBOUND' COMMENT 'PENDING_INBOUND/DEVANNING/READY_TO_CONVERT/CONVERTED/CANCELLED',
  `outbound_direction` varchar(32) NOT NULL DEFAULT 'DELIVERY' COMMENT 'DELIVERY/TRANSFER',
  `outbound_warehouse_id` bigint DEFAULT NULL COMMENT '出库仓库ID',
  `outbound_warehouse_name` varchar(128) DEFAULT NULL COMMENT '出库仓库名称',
  `customer_name` varchar(128) DEFAULT NULL COMMENT '客户',
  `container_no` varchar(32) DEFAULT NULL COMMENT '柜号',
  `shipment_codes` varchar(2000) DEFAULT NULL COMMENT '货件编码',
  `declared_carton_qty` decimal(10,2) DEFAULT NULL COMMENT '预报箱数',
  `declared_pallet_qty` decimal(10,2) DEFAULT NULL COMMENT '预报板数',
  `declared_weight` decimal(12,3) DEFAULT NULL COMMENT '预报重量',
  `declared_cbm` decimal(12,3) DEFAULT NULL COMMENT '预报体积',
  `actual_carton_qty` decimal(10,2) DEFAULT NULL COMMENT '实际箱数',
  `actual_pallet_qty` decimal(10,2) DEFAULT NULL COMMENT '实际板数',
  `actual_weight` decimal(12,3) DEFAULT NULL COMMENT '实际重量',
  `actual_cbm` decimal(12,3) DEFAULT NULL COMMENT '实际体积',
  `earliest_dw_time` datetime DEFAULT NULL COMMENT '最早DW时间',
  `delivery_lfd` datetime DEFAULT NULL COMMENT '派送LFD',
  `ready_time` datetime DEFAULT NULL COMMENT '可转出库时间',
  `converted_time` datetime DEFAULT NULL COMMENT '转正式出库时间',
  `outbound_order_no` varchar(64) DEFAULT NULL COMMENT '出库订单号',
  `appointment_no` varchar(64) DEFAULT NULL COMMENT '预约号',
  `appointment_time` datetime DEFAULT NULL COMMENT '预约日期',
  `delivery_truck` varchar(128) DEFAULT NULL COMMENT '派送卡车',
  `loading_type` varchar(32) DEFAULT NULL COMMENT '装车类型 PALLET/FLOOR',
  `transport_type` varchar(32) DEFAULT NULL COMMENT '运输类型 FTL/LTL',
  `delivery_tag` varchar(128) DEFAULT NULL COMMENT '派送标签',
  `destination` varchar(255) DEFAULT NULL COMMENT '目的地',
  `delivery_method` varchar(64) DEFAULT NULL COMMENT '派送方式/业务类型',
  `follow_record` varchar(1000) DEFAULT NULL COMMENT '跟进记录',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_pre_outbound_no_tenant` (`pre_outbound_no`, `tenant_id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`),
  KEY `idx_biz_root_id` (`biz_root_id`),
  KEY `idx_pre_status` (`pre_outbound_status`),
  KEY `idx_appointment_time` (`appointment_time`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='OMS预出单';

CREATE TABLE IF NOT EXISTS `oms_outbound_order` (
  `id` bigint NOT NULL COMMENT 'ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `biz_root_id` bigint DEFAULT NULL COMMENT '业务主线ID',
  `cargo_order_id` bigint NOT NULL COMMENT '货物订单ID',
  `cargo_order_no` varchar(64) NOT NULL COMMENT '货物订单号',
  `pre_outbound_id` bigint DEFAULT NULL COMMENT '预出单ID',
  `pre_outbound_no` varchar(64) DEFAULT NULL COMMENT '预出单号',
  `outbound_order_no` varchar(64) NOT NULL COMMENT '出库订单号',
  `outbound_status` varchar(32) NOT NULL DEFAULT 'CREATED' COMMENT 'CREATED/DISPATCHED/OUTBOUNDED/DELIVERING/DELIVERED/ARRIVED/POD_UPLOADED/COMPLETED/CANCELLED',
  `outbound_direction` varchar(32) NOT NULL DEFAULT 'DELIVERY' COMMENT 'DELIVERY/TRANSFER',
  `outbound_warehouse_id` bigint DEFAULT NULL COMMENT '出库仓库ID',
  `outbound_warehouse_name` varchar(128) DEFAULT NULL COMMENT '出库仓库名称',
  `customer_name` varchar(128) DEFAULT NULL COMMENT '客户',
  `container_no` varchar(32) DEFAULT NULL COMMENT '柜号',
  `shipment_codes` varchar(2000) DEFAULT NULL COMMENT '货件编码',
  `actual_carton_qty` decimal(10,2) DEFAULT NULL COMMENT '实际箱数',
  `actual_pallet_qty` decimal(10,2) DEFAULT NULL COMMENT '实际板数',
  `actual_weight` decimal(12,3) DEFAULT NULL COMMENT '实际重量',
  `actual_cbm` decimal(12,3) DEFAULT NULL COMMENT '实际体积',
  `delivery_method` varchar(64) DEFAULT NULL COMMENT '派送方式',
  `appointment_status` varchar(32) DEFAULT 'NONE' COMMENT '预约状态',
  `appointment_time` datetime DEFAULT NULL COMMENT '预约时间',
  `delivery_lfd` datetime DEFAULT NULL COMMENT '派送LFD',
  `contact_name` varchar(128) DEFAULT NULL COMMENT '联系人',
  `contact_phone` varchar(64) DEFAULT NULL COMMENT '联系电话',
  `contact_email` varchar(128) DEFAULT NULL COMMENT '邮箱',
  `address_line1` varchar(255) DEFAULT NULL COMMENT '地址1',
  `address_line2` varchar(255) DEFAULT NULL COMMENT '地址2',
  `city` varchar(128) DEFAULT NULL COMMENT '城市',
  `state` varchar(64) DEFAULT NULL COMMENT '州',
  `zip_code` varchar(32) DEFAULT NULL COMMENT '邮编',
  `country` varchar(64) DEFAULT NULL COMMENT '国家',
  `transfer_out_warehouse_id` bigint DEFAULT NULL COMMENT '调出仓ID',
  `transfer_in_warehouse_id` bigint DEFAULT NULL COMMENT '调入仓ID',
  `transfer_reason` varchar(500) DEFAULT NULL COMMENT '调拨原因',
  `transfer_method` varchar(64) DEFAULT NULL COMMENT '调拨方式',
  `estimated_transfer_time` datetime DEFAULT NULL COMMENT '预计调出时间',
  `estimated_arrival_time` datetime DEFAULT NULL COMMENT '预计到达时间',
  `carrier` varchar(128) DEFAULT NULL COMMENT '承运商',
  `tracking_no` varchar(128) DEFAULT NULL COMMENT '追踪号',
  `actual_outbound_time` datetime DEFAULT NULL COMMENT '实际出库时间',
  `actual_signed_time` datetime DEFAULT NULL COMMENT '签收时间',
  `actual_arrival_time` datetime DEFAULT NULL COMMENT '实际到达时间',
  `pod_status` varchar(32) DEFAULT 'PENDING' COMMENT 'POD状态',
  `pod_upload_time` datetime DEFAULT NULL COMMENT 'POD上传时间',
  `completed_time` datetime DEFAULT NULL COMMENT '完成时间',
  `dispatch_remark` varchar(500) DEFAULT NULL COMMENT '调度备注',
  `operation_remark` varchar(500) DEFAULT NULL COMMENT '操作备注',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_outbound_order_no_tenant` (`outbound_order_no`, `tenant_id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`),
  KEY `idx_pre_outbound_id` (`pre_outbound_id`),
  KEY `idx_biz_root_id` (`biz_root_id`),
  KEY `idx_outbound_status` (`outbound_status`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='OMS出库订单';

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_cargo_order' AND COLUMN_NAME = 'outbound_direction') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `outbound_direction` varchar(32) DEFAULT NULL COMMENT ''出单方向 DELIVERY/TRANSFER'' AFTER `outbound_order_status`',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_cargo_order' AND COLUMN_NAME = 'latest_pre_outbound_id') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `latest_pre_outbound_id` bigint DEFAULT NULL COMMENT ''最新预出单ID'' AFTER `pre_outbound_no`',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_cargo_order' AND COLUMN_NAME = 'latest_outbound_order_id') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `latest_outbound_order_id` bigint DEFAULT NULL COMMENT ''最新出库订单ID'' AFTER `outbound_batch_no`',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- [跳过 sys_dict / sys_menu / outbound mock；字典见 oms-dict-yudao.sql]



-- ===== oms_pre_outbound_item_20260525.sql =====

-- 预出单明细行（关联货物订单，卡板维度展示由前端/后续打板功能扩展）

CREATE TABLE IF NOT EXISTS `oms_pre_outbound_item` (
  `id` bigint NOT NULL COMMENT 'ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `pre_outbound_id` bigint NOT NULL COMMENT '预出单ID',
  `pre_outbound_no` varchar(64) NOT NULL COMMENT '预出单号',
  `cargo_order_id` bigint NOT NULL COMMENT '货物订单ID',
  `cargo_order_no` varchar(64) NOT NULL COMMENT '货物订单号',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_pre_outbound_cargo_tenant` (`pre_outbound_id`, `cargo_order_id`, `tenant_id`),
  KEY `idx_pre_outbound_id` (`pre_outbound_id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='OMS预出单明细';

-- [跳过历史回填：全新库无 oms_pre_outbound 存量，明细随业务创建]


-- ===== oms_outbound_1ton_refactor_20260526.sql =====

-- ==================================================
-- OMS 出库链路 1:N 重构
-- 日期：2026-05-26
-- 背景：出库单与货物订单由 1:1 改为 1:N
--       多个货物订单可合并进一个预出单/出库单
-- 影响表：
--   新增 oms_outbound_order_item（出库单明细）
--   变更 oms_outbound_order（cargo_order_id 改可空，增加 cargo_order_count）
--   变更 oms_pre_outbound（cargo_order_id 改可空，增加 cargo_order_count）
-- ==================================================

-- ----------------------------
-- 1. 新增 oms_outbound_order_item（出库单明细，货物订单维度）
-- ----------------------------
CREATE TABLE IF NOT EXISTS `oms_outbound_order_item` (
  `id`                   bigint        NOT NULL                   COMMENT 'ID（雪花算法）',
  `tenant_id`            varchar(20)   NOT NULL DEFAULT '000000'  COMMENT '租户ID',
  `outbound_order_id`    bigint        NOT NULL                   COMMENT '出库单ID',
  `outbound_order_no`    varchar(64)   NOT NULL                   COMMENT '出库单号',
  `cargo_order_id`       bigint        NOT NULL                   COMMENT '货物订单ID',
  `cargo_order_no`       varchar(64)   NOT NULL                   COMMENT '货物订单号',
  `pre_outbound_item_id` bigint        DEFAULT NULL               COMMENT '来源预出单明细ID（从预出单转换时填充）',
  `actual_carton_qty`    decimal(10,2) DEFAULT NULL               COMMENT '实际箱数',
  `actual_pallet_qty`    decimal(10,2) DEFAULT NULL               COMMENT '实际板数',
  `actual_weight`        decimal(12,3) DEFAULT NULL               COMMENT '实际重量(kg)',
  `actual_cbm`           decimal(12,3) DEFAULT NULL               COMMENT '实际体积(m³)',
  `create_dept`          bigint        DEFAULT NULL               COMMENT '创建部门',
  `create_by`            bigint        DEFAULT NULL               COMMENT '创建人',
  `create_time`          datetime      DEFAULT NULL               COMMENT '创建时间',
  `update_by`            bigint        DEFAULT NULL               COMMENT '更新人',
  `update_time`          datetime      DEFAULT NULL               COMMENT '更新时间',
  `deleted`              tinyint(1)    NOT NULL DEFAULT 0         COMMENT '逻辑删除（0正常1删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_outbound_cargo_tenant` (`outbound_order_id`, `cargo_order_id`, `tenant_id`),
  KEY `idx_outbound_order_id` (`outbound_order_id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`),
  KEY `idx_pre_outbound_item_id` (`pre_outbound_item_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='OMS出库单明细（货物订单维度）';

-- ----------------------------
-- 2. oms_outbound_order 主表变更
--    2.1 cargo_order_id 改为可空（关系移至明细表，保留兼容）
--    2.2 cargo_order_no 改为可空
--    2.3 新增 cargo_order_count（关联货物订单数，服务层维护）
-- ----------------------------

SET @sql := IF(
  (SELECT IS_NULLABLE FROM information_schema.COLUMNS
   WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_outbound_order' AND COLUMN_NAME = 'cargo_order_id') = 'NO',
  'ALTER TABLE `oms_outbound_order` MODIFY COLUMN `cargo_order_id` bigint DEFAULT NULL COMMENT ''货物订单ID（兼容字段，1:N后由明细表管理）''',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT IS_NULLABLE FROM information_schema.COLUMNS
   WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_outbound_order' AND COLUMN_NAME = 'cargo_order_no') = 'NO',
  'ALTER TABLE `oms_outbound_order` MODIFY COLUMN `cargo_order_no` varchar(64) DEFAULT NULL COMMENT ''货物订单号（兼容字段，1:N后由明细表管理）''',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS
   WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_outbound_order' AND COLUMN_NAME = 'cargo_order_count') = 0,
  'ALTER TABLE `oms_outbound_order` ADD COLUMN `cargo_order_count` int NOT NULL DEFAULT 0 COMMENT ''关联货物订单数'' AFTER `pre_outbound_no`',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ----------------------------
-- 3. oms_pre_outbound 主表变更
--    3.1 cargo_order_id 改为可空（关系由 oms_pre_outbound_item 管理）
--    3.2 cargo_order_no 改为可空
--    3.3 新增 cargo_order_count
-- ----------------------------

SET @sql := IF(
  (SELECT IS_NULLABLE FROM information_schema.COLUMNS
   WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_pre_outbound' AND COLUMN_NAME = 'cargo_order_id') = 'NO',
  'ALTER TABLE `oms_pre_outbound` MODIFY COLUMN `cargo_order_id` bigint DEFAULT NULL COMMENT ''货物订单ID（兼容字段，1:N后由明细表管理）''',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT IS_NULLABLE FROM information_schema.COLUMNS
   WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_pre_outbound' AND COLUMN_NAME = 'cargo_order_no') = 'NO',
  'ALTER TABLE `oms_pre_outbound` MODIFY COLUMN `cargo_order_no` varchar(64) DEFAULT NULL COMMENT ''货物订单号（兼容字段，1:N后由明细表管理）''',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS
   WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_pre_outbound' AND COLUMN_NAME = 'cargo_order_count') = 0,
  'ALTER TABLE `oms_pre_outbound` ADD COLUMN `cargo_order_count` int NOT NULL DEFAULT 0 COMMENT ''关联货物订单数'' AFTER `cargo_order_no`',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ----------------------------
-- 4. 存量数据迁移
--    将已有 oms_outbound_order 中的 cargo_order_id 回填到 oms_outbound_order_item
--    注意：id 使用 id + 8000000000 作为迁移偏移，生产环境执行后应由服务层雪花ID接管
-- ----------------------------
INSERT INTO `oms_outbound_order_item` (
  `id`, `tenant_id`,
  `outbound_order_id`, `outbound_order_no`,
  `cargo_order_id`, `cargo_order_no`,
  `actual_carton_qty`, `actual_pallet_qty`, `actual_weight`, `actual_cbm`,
  `create_by`, `create_time`, `deleted`
)
SELECT
  o.`id` + 8000000000,
  o.`tenant_id`,
  o.`id`,
  o.`outbound_order_no`,
  o.`cargo_order_id`,
  o.`cargo_order_no`,
  o.`actual_carton_qty`,
  o.`actual_pallet_qty`,
  o.`actual_weight`,
  o.`actual_cbm`,
  o.`create_by`,
  NOW(),
  0
FROM `oms_outbound_order` o
WHERE o.`deleted` = 0
  AND o.`cargo_order_id` IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM `oms_outbound_order_item` i
    WHERE i.`outbound_order_id` = o.`id`
      AND i.`cargo_order_id` = o.`cargo_order_id`
      AND i.`deleted` = 0
  );

-- ----------------------------
-- 5. 回填计数字段（关闭安全更新模式，避免 Error 1175）
-- ----------------------------
SET SQL_SAFE_UPDATES = 0;

-- 5.1 回填 oms_outbound_order.cargo_order_count
UPDATE `oms_outbound_order` o
SET `cargo_order_count` = (
  SELECT COUNT(*) FROM `oms_outbound_order_item` i
  WHERE i.`outbound_order_id` = o.`id` AND i.`deleted` = 0
)
WHERE o.`id` > 0 AND o.`deleted` = 0;

-- 5.2 回填 oms_pre_outbound.cargo_order_count
UPDATE `oms_pre_outbound` p
SET `cargo_order_count` = (
  SELECT COUNT(*) FROM `oms_pre_outbound_item` i
  WHERE i.`pre_outbound_id` = p.`id` AND i.`deleted` = 0
)
WHERE p.`id` > 0 AND p.`deleted` = 0;

SET SQL_SAFE_UPDATES = 1;

-- ----------------------------
-- 6. 权限菜单整合
--    "单个创建"和"批量创建"合并为同一入口，保留批量权限标识（向下兼容）
--    删除已无实际对应逻辑的"单条创建预出单/出库单"独立权限按钮
-- ----------------------------


-- 将旧的单条权限按钮下线（visible=1 隐藏，不删除保留数据）



-- ===== oms_outbound_cleanup_cancelled_20260526.sql =====

-- ============================================================
-- 清理历史 CANCELLED 出库单 & 预出单脏数据
-- 背景：旧 cancel() 逻辑只改状态不删记录，导致数据残留
-- 执行顺序：先重置货物订单状态，再逻辑删除单据
-- ============================================================

SET SQL_SAFE_UPDATES = 0;

-- ============================================================
-- Part 1: 清理 CANCELLED 出库单
-- 旧逻辑：outbound_order.outbound_status = 'CANCELLED'
--         cargo_order.outbound_order_status = 'CANCELLED'（未重置）
--         cargo_order.fulfillment_status = 'OUTBOUND_ORDERED'（未重置）
-- ============================================================

-- Step 1-1: 通过 items 表重置货物订单 → 弹回出单工作台
UPDATE oms_cargo_order co
  INNER JOIN oms_outbound_order_item oi ON co.id = oi.cargo_order_id AND oi.deleted = 0
  INNER JOIN oms_outbound_order o ON oi.outbound_order_id = o.id
SET co.outbound_order_status = 'NONE',
    co.outbound_batch_no     = NULL,
    co.outbound_order_time   = NULL,
    co.fulfillment_status    = 'INBOUNDED',
    co.pre_outbound_status   = 'NONE',
    co.pre_outbound_no       = NULL,
    co.pre_outbound_flag     = 0,
    co.update_time           = NOW()
WHERE o.outbound_status = 'CANCELLED'
  AND o.deleted = 0
  AND o.id > 0;

-- Step 1-2: 逻辑删除 items
UPDATE oms_outbound_order_item oi
  INNER JOIN oms_outbound_order o ON oi.outbound_order_id = o.id
SET oi.deleted      = 1,
    oi.update_time  = NOW()
WHERE o.outbound_status = 'CANCELLED'
  AND o.deleted = 0
  AND o.id > 0;

-- Step 1-3: 逻辑删除出库单
UPDATE oms_outbound_order
SET deleted     = 1,
    update_time = NOW()
WHERE outbound_status = 'CANCELLED'
  AND deleted = 0
  AND id > 0;

-- ============================================================
-- Part 2: 清理 CANCELLED 预出单
-- 旧逻辑：pre_outbound.pre_outbound_status = 'CANCELLED'
--         货物订单已由旧 cancel() 正确重置（pre_outbound_status=NONE）
--         只需删除单据本身
-- ============================================================

-- Step 2-1: 逻辑删除 items
UPDATE oms_pre_outbound_item pi
  INNER JOIN oms_pre_outbound p ON pi.pre_outbound_id = p.id
SET pi.deleted     = 1,
    pi.update_time = NOW()
WHERE p.pre_outbound_status = 'CANCELLED'
  AND p.deleted = 0
  AND p.id > 0;

-- Step 2-2: 逻辑删除预出单
UPDATE oms_pre_outbound
SET deleted     = 1,
    update_time = NOW()
WHERE pre_outbound_status = 'CANCELLED'
  AND deleted = 0
  AND id > 0;

-- ============================================================
-- Part 3: 清理 CONVERTED 预出单（转单后应随之删除，历史遗留）
-- 对应出库单已存在，货物订单状态正常，只需删除预出单记录
-- ============================================================

-- Step 3-1: 逻辑删除 items
UPDATE oms_pre_outbound_item pi
  INNER JOIN oms_pre_outbound p ON pi.pre_outbound_id = p.id
SET pi.deleted     = 1,
    pi.update_time = NOW()
WHERE p.pre_outbound_status = 'CONVERTED'
  AND p.deleted = 0
  AND p.id > 0;

-- Step 3-2: 逻辑删除预出单
UPDATE oms_pre_outbound
SET deleted     = 1,
    update_time = NOW()
WHERE pre_outbound_status = 'CONVERTED'
  AND deleted = 0
  AND id > 0;

SET SQL_SAFE_UPDATES = 1;

-- 验证：执行后以下查询应全部返回 0
SELECT COUNT(*) AS remaining_cancelled_outbound  FROM oms_outbound_order  WHERE outbound_status   = 'CANCELLED' AND deleted = 0;
SELECT COUNT(*) AS remaining_cancelled_pre        FROM oms_pre_outbound    WHERE pre_outbound_status = 'CANCELLED' AND deleted = 0;
SELECT COUNT(*) AS remaining_converted_pre        FROM oms_pre_outbound    WHERE pre_outbound_status = 'CONVERTED' AND deleted = 0;



-- ===== oms_cargo_order_summary_backfill_20260527.sql =====

-- =============================================================
-- Backfill cargo order shipment summary fields
-- Date: 2026-05-27
-- Fields:
--   oms_cargo_order.shipment_codes
--   oms_cargo_order.po_nos
--   oms_cargo_order.marks
-- 兼容 MySQL Workbench Safe Update Mode
-- =============================================================

SET @schema_name = DATABASE();

SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order_shipment' AND column_name = 'pallet_qty') = 0,
  'ALTER TABLE `oms_cargo_order_shipment` ADD COLUMN `pallet_qty` decimal(12,0) DEFAULT NULL COMMENT ''预报板数'' AFTER `carton_qty`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'declared_pallet_qty') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `declared_pallet_qty` decimal(10,2) DEFAULT NULL COMMENT ''预报板数'' AFTER `declared_carton_qty`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET SQL_SAFE_UPDATES = 0;

UPDATE `oms_cargo_order` co
INNER JOIN (
    SELECT `cargo_order_id`,
           GROUP_CONCAT(DISTINCT NULLIF(`shipment_no`, '') ORDER BY `shipment_no` SEPARATOR ', ') AS `shipment_codes`,
           GROUP_CONCAT(DISTINCT NULLIF(`po_no`, '') ORDER BY `po_no` SEPARATOR ', ') AS `po_nos`,
           GROUP_CONCAT(DISTINCT NULLIF(`shipping_mark`, '') ORDER BY `shipping_mark` SEPARATOR ', ') AS `marks`,
           SUM(COALESCE(`carton_qty`, 0)) AS `declared_carton_qty`,
           SUM(COALESCE(`pallet_qty`, 0)) AS `declared_pallet_qty`,
           SUM(COALESCE(`weight`, 0)) AS `declared_weight`,
           SUM(COALESCE(`cbm`, 0)) AS `declared_cbm`,
           MIN(`dw_time`) AS `earliest_dw_time`
    FROM `oms_cargo_order_shipment`
    WHERE `deleted` = 0
    GROUP BY `cargo_order_id`
) s ON s.`cargo_order_id` = co.`id`
SET co.`shipment_codes` = s.`shipment_codes`,
    co.`po_nos` = s.`po_nos`,
    co.`marks` = s.`marks`,
    co.`declared_carton_qty` = s.`declared_carton_qty`,
    co.`declared_pallet_qty` = s.`declared_pallet_qty`,
    co.`declared_weight` = s.`declared_weight`,
    co.`declared_cbm` = s.`declared_cbm`,
    co.`earliest_dw_time` = s.`earliest_dw_time`
WHERE co.`deleted` = 0
  AND co.`id` > 0;

SET SQL_SAFE_UPDATES = 1;



-- ===== oms_container_pre_plan_backfill_20260525.sql =====

-- 海柜预排车数 / 预排方数：按关联预出单（非已取消）一次性回刷
-- 兼容 MySQL Workbench Safe Update Mode（WHERE 使用主键 id）
-- pre_plan_truck_qty = 预出单单数；pre_plan_cbm = actual_cbm（无则 declared_cbm）合计

-- 1) 先清零（避免 LEFT JOIN 在 safe mode 下无法更新全表）
UPDATE `oms_container_order`
SET `pre_plan_truck_qty` = 0,
    `pre_plan_pallet_qty` = 0,
    `pre_plan_cbm` = 0
WHERE `deleted` = 0
  AND `id` > 0;

-- 2) 按海柜汇总预出单后回写
UPDATE `oms_container_order` co
INNER JOIN (
    SELECT link.container_order_id,
           COUNT(DISTINCT po.id) AS truck_qty,
           SUM(
               CASE
                   WHEN po.actual_cbm IS NOT NULL AND po.actual_cbm > 0 THEN po.actual_cbm
                   ELSE IFNULL(po.declared_cbm, 0)
               END
           ) AS plan_cbm
    FROM `oms_pre_outbound` po
    INNER JOIN (
        SELECT po.id AS pre_outbound_id, c.container_order_id
        FROM `oms_pre_outbound` po
        INNER JOIN `oms_cargo_order` c ON c.id = po.cargo_order_id AND c.deleted = 0
        WHERE po.deleted = 0
          AND po.pre_outbound_status <> 'CANCELLED'
          AND c.container_order_id IS NOT NULL
        UNION
        SELECT poi.pre_outbound_id, c.container_order_id
        FROM `oms_pre_outbound_item` poi
        INNER JOIN `oms_cargo_order` c ON c.id = poi.cargo_order_id AND c.deleted = 0
        INNER JOIN `oms_pre_outbound` po ON po.id = poi.pre_outbound_id AND po.deleted = 0
        WHERE poi.deleted = 0
          AND po.pre_outbound_status <> 'CANCELLED'
          AND c.container_order_id IS NOT NULL
    ) link ON link.pre_outbound_id = po.id
    WHERE po.deleted = 0
      AND po.pre_outbound_status <> 'CANCELLED'
    GROUP BY link.container_order_id
) agg ON agg.container_order_id = co.id
SET co.pre_plan_truck_qty = agg.truck_qty,
    co.pre_plan_pallet_qty = agg.truck_qty,
    co.pre_plan_cbm = agg.plan_cbm
WHERE co.deleted = 0
  AND co.id > 0;



-- ===== sql/mysql/oms-menu.sql =====

-- OMS 菜单与按钮权限（可重复执行，不会 1062）
-- 检查：SELECT id, name, permission FROM system_menu WHERE id BETWEEN 6900 AND 6942;
-- 执行后：系统管理 → 角色管理 → 为角色勾选 OMS 菜单（超级管理员 tenant_id=1 通常 role_id=1）

SET NAMES utf8mb4;

-- ========== 目录 + 页面菜单 ==========
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`,
                           `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`,
                           `create_time`, `updater`, `update_time`, `deleted`)
VALUES
    (6900, 'OMS', '', 1, 60, 0, '/oms', 'ep:management', NULL, NULL, 0, b'1', b'1', b'1',
     'admin', NOW(), 'admin', NOW(), b'0'),
    (6901, '海柜订单', 'oms:containerOrder:list', 2, 1, 6900, 'container-order', 'ep:box',
     'oms/container-order/index', 'OmsContainerOrder', 0, b'1', b'1', b'1',
     'admin', NOW(), 'admin', NOW(), b'0'),
    (6902, '货物订单', 'oms:cargoOrder:list', 2, 2, 6900, 'cargo-order', 'ep:tickets',
     'oms/cargo-order/index', 'OmsCargoOrder', 0, b'1', b'1', b'1',
     'admin', NOW(), 'admin', NOW(), b'0'),
    (6903, '预警中心', 'oms:alert:list', 2, 3, 6900, 'alert', 'ep:warning',
     'oms/alert/index', 'OmsAlert', 0, b'1', b'1', b'1',
     'admin', NOW(), 'admin', NOW(), b'0'),
    (6904, '费用中心', 'oms:fee:list', 2, 4, 6900, 'fee', 'ep:coin',
     'oms/fee/index', 'OmsFee', 0, b'1', b'1', b'1',
     'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `permission` = VALUES(`permission`),
    `type` = VALUES(`type`),
    `sort` = VALUES(`sort`),
    `parent_id` = VALUES(`parent_id`),
    `path` = VALUES(`path`),
    `icon` = VALUES(`icon`),
    `component` = VALUES(`component`),
    `component_name` = VALUES(`component_name`),
    `status` = VALUES(`status`),
    `visible` = VALUES(`visible`),
    `keep_alive` = VALUES(`keep_alive`),
    `always_show` = VALUES(`always_show`),
    `updater` = VALUES(`updater`),
    `update_time` = NOW(),
    `deleted` = VALUES(`deleted`);

-- ========== 按钮权限（type=3）==========
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`,
                           `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`,
                           `create_time`, `updater`, `update_time`, `deleted`)
VALUES
    (6911, '海柜创建', 'oms:container:create', 3, 1, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6912, '海柜编辑', 'oms:container:edit', 3, 2, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6913, '海柜状态更新', 'oms:container:status-update', 3, 3, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6914, '海柜查看', 'oms:container:view', 3, 4, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6915, '海柜复制', 'oms:container:copy', 3, 5, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6916, '海柜受理', 'oms:container:accept', 3, 6, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6921, '委托单状态更新', 'oms:order:status-update', 3, 1, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6922, '委托单预派送', 'oms:order:pre-dispatch', 3, 2, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6923, '委托单挂起', 'oms:order:hold', 3, 3, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6924, '委托单查询', 'oms:order:query', 3, 4, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6931, '预警处理', 'oms:alert:process', 3, 1, 6903, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6932, '预警规则编辑', 'oms:alert-rule:edit', 3, 2, 6903, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6941, '费用冻结申请', 'oms:fee:freeze-request', 3, 1, 6904, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6942, '事件日志查看', 'oms:event-log:view', 3, 2, 6904, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `permission` = VALUES(`permission`),
    `type` = VALUES(`type`),
    `sort` = VALUES(`sort`),
    `parent_id` = VALUES(`parent_id`),
    `status` = VALUES(`status`),
    `visible` = VALUES(`visible`),
    `updater` = VALUES(`updater`),
    `update_time` = NOW(),
    `deleted` = VALUES(`deleted`);



-- ===== sql/migration-overall/03-oms-menu-ext.sql =====

-- OMS 菜单扩展（出库/入库计划/分组规则/事件日志）
-- 依赖：已执行 sql/mysql/oms-menu.sql（6900 根目录）
-- 本脚本 ID：6950~6999；可重复执行

SET NAMES utf8mb4;

-- ========== 新增页面 ==========
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`,
                           `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`,
                           `create_time`, `updater`, `update_time`, `deleted`)
VALUES
    (6950, '入库计划', 'wms:inboundPlan:list', 2, 5, 6900, 'inbound-plan', 'ep:upload',
     'oms/inbound-plan/index', 'OmsInboundPlan', 0, b'1', b'0', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6951, '预出单', 'oms:preOutbound:list', 2, 6, 6900, 'pre-outbound', 'ep:document',
     'oms/pre-outbound/index', 'OmsPreOutbound', 0, b'1', b'0', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6952, '出单工作台', 'oms:outboundPool:list', 2, 7, 6900, 'outbound-pool', 'ep:shopping-cart',
     'oms/outbound-pool/index', 'OmsOutboundPool', 0, b'1', b'0', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6953, '出库订单', 'oms:outboundOrder:list', 2, 8, 6900, 'outbound-order', 'ep:sell',
     'oms/outbound-order/index', 'OmsOutboundOrder', 0, b'1', b'0', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6954, '分组规则', 'oms:cargoGroupingRule:list', 2, 9, 6900, 'cargo-grouping-rule', 'ep:setting',
     'oms/cargo-grouping-rule/index', 'OmsCargoGroupingRule', 0, b'1', b'0', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6955, '事件日志', 'oms:event-log:view', 2, 10, 6900, 'event-log', 'ep:document',
     'oms/biz-event/index', 'OmsBizEventLog', 0, b'1', b'0', b'1', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`), `permission` = VALUES(`permission`), `sort` = VALUES(`sort`),
    `path` = VALUES(`path`), `icon` = VALUES(`icon`), `component` = VALUES(`component`),
    `component_name` = VALUES(`component_name`), `keep_alive` = VALUES(`keep_alive`),
    `updater` = 'admin', `update_time` = NOW(), `deleted` = b'0';

-- ========== 按钮权限 ==========
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`,
                           `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`,
                           `create_time`, `updater`, `update_time`, `deleted`)
VALUES
    -- 入库计划
    (6961, '自动分组', 'wms:inboundPlan:autoGroup', 3, 1, 6950, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6962, '应用规则', 'wms:inboundPlan:applyRule', 3, 2, 6950, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6963, '开始作业', 'wms:inboundPlan:startWork', 3, 3, 6950, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6964, '完成计划', 'wms:inboundPlan:complete', 3, 4, 6950, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    -- 预出单
    (6971, '预出单查询', 'oms:preOutbound:query', 3, 1, 6951, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6972, '转出库单', 'oms:preOutbound:convert', 3, 2, 6951, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6973, '预出单编辑', 'oms:preOutbound:edit', 3, 3, 6951, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    -- 出单工作台
    (6981, '创建预出单', 'oms:outboundPool:createPreOutbound', 3, 1, 6952, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6982, '创建出库单', 'oms:outboundPool:createOutboundOrder', 3, 2, 6952, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6983, '批量预出单', 'oms:outboundPool:batchCreatePreOutbound', 3, 3, 6952, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6984, '批量出库单', 'oms:outboundPool:batchCreateOutboundOrder', 3, 4, 6952, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    -- 出库订单
    (6991, '出库单查询', 'oms:outboundOrder:query', 3, 1, 6953, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6992, '出库单编辑', 'oms:outboundOrder:edit', 3, 2, 6953, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6993, '出库完成', 'oms:outboundOrder:complete', 3, 3, 6953, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    -- 分组规则
    (6994, '规则查询', 'oms:cargoGroupingRule:query', 3, 1, 6954, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6995, '规则新增', 'oms:cargoGroupingRule:add', 3, 2, 6954, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6996, '规则编辑', 'oms:cargoGroupingRule:edit', 3, 3, 6954, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6997, '规则删除', 'oms:cargoGroupingRule:remove', 3, 4, 6954, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6998, '规则测试', 'oms:cargoGroupingRule:test', 3, 5, 6954, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6999, '规则启用', 'oms:cargoGroupingRule:enable', 3, 6, 6954, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`), `permission` = VALUES(`permission`), `parent_id` = VALUES(`parent_id`),
    `updater` = 'admin', `update_time` = NOW(), `deleted` = b'0';

-- ========== 可选：超级管理员授权 ==========
-- INSERT INTO `system_role_menu` (`role_id`, `menu_id`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`)
-- SELECT 1, id, 'admin', NOW(), 'admin', NOW(), b'0', 1 FROM `system_menu` WHERE id BETWEEN 6950 AND 6999 AND deleted = b'0';

