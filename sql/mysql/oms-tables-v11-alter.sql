-- OMS v1.1 / OMS-PRD-002 表结构增量（在 oms-tables.sql 已执行后运行）
--
-- 【只执行一次】若报 Duplicate column name，说明本脚本已跑过，请勿整文件重跑。
-- 建单相关增量请改执行：oms-container-create-alter.sql
-- 自检：SELECT COLUMN_NAME FROM information_schema.COLUMNS
--       WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_container_order' AND COLUMN_NAME = 'transport_mode';
SET NAMES utf8mb4;

-- 1. 海柜主表
ALTER TABLE `oms_container_order`
    ADD COLUMN `transport_mode` varchar(32) NOT NULL DEFAULT 'SEA_FCL' COMMENT '运输方式' AFTER `container_type`,
    ADD COLUMN `carrier_code` varchar(64) DEFAULT NULL COMMENT '船司/承运商编码' AFTER `transport_mode`,
    ADD COLUMN `vessel_name` varchar(128) DEFAULT NULL COMMENT '船名' AFTER `carrier_code`,
    ADD COLUMN `voyage_no` varchar(64) DEFAULT NULL COMMENT '航次' AFTER `vessel_name`,
    ADD COLUMN `route_code` varchar(64) DEFAULT NULL COMMENT '航线' AFTER `voyage_no`,
    ADD COLUMN `pol_code` varchar(16) DEFAULT NULL COMMENT '起运港' AFTER `route_code`,
    ADD COLUMN `pod_code` varchar(16) DEFAULT NULL COMMENT '目的港' AFTER `pol_code`,
    ADD COLUMN `channel_id` bigint DEFAULT NULL COMMENT '渠道' AFTER `pod_code`,
    ADD COLUMN `cs_user_id` bigint DEFAULT NULL COMMENT '客服用户ID' AFTER `channel_id`,
    ADD COLUMN `tags` json DEFAULT NULL COMMENT '标签JSON数组' AFTER `cs_user_id`,
    ADD COLUMN `internal_remark` varchar(1024) DEFAULT NULL COMMENT '内部备注' AFTER `tags`,
    ADD COLUMN `gross_weight_kg` decimal(18,3) DEFAULT NULL COMMENT '毛重KG' AFTER `internal_remark`,
    ADD COLUMN `total_cbm` decimal(18,3) DEFAULT NULL COMMENT '总体积CBM' AFTER `gross_weight_kg`,
    ADD COLUMN `atd` datetime DEFAULT NULL COMMENT 'ATD' AFTER `eta`,
    ADD COLUMN `ata` datetime DEFAULT NULL COMMENT 'ATA' AFTER `atd`,
    ADD COLUMN `exam_status` varchar(32) NOT NULL DEFAULT 'NONE' COMMENT '查验状态' AFTER `unstuff_status`,
    ADD COLUMN `is_on_hold` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否Hold' AFTER `exam_status`,
    ADD COLUMN `hold_type` varchar(32) DEFAULT NULL COMMENT 'Hold类型' AFTER `is_on_hold`,
    ADD COLUMN `hold_reason` varchar(512) DEFAULT NULL COMMENT 'Hold原因' AFTER `hold_type`,
    ADD COLUMN `hold_since` datetime DEFAULT NULL COMMENT 'Hold开始时间' AFTER `hold_reason`;

-- 2. 码头
ALTER TABLE `oms_container_terminal_info`
    ADD COLUMN `terminal_name` varchar(128) DEFAULT NULL COMMENT '码头名称' AFTER `terminal_code`,
    ADD COLUMN `available_at` datetime DEFAULT NULL COMMENT 'Available时间' AFTER `port_code`,
    ADD COLUMN `available_source` varchar(16) DEFAULT 'manual' COMMENT 'manual/api' AFTER `available_at`,
    ADD COLUMN `pickup_lfd` datetime DEFAULT NULL COMMENT '提柜LFD' AFTER `available_source`,
    ADD COLUMN `pickup_lfd_source` varchar(16) DEFAULT 'manual' AFTER `pickup_lfd`,
    ADD COLUMN `chassis_free_until` datetime DEFAULT NULL COMMENT '车架免费至' AFTER `pickup_lfd_source`,
    ADD COLUMN `calc_chassis_days` int DEFAULT NULL COMMENT '车架天数' AFTER `chassis_free_until`,
    ADD COLUMN `calc_chassis_fee_est` decimal(18,2) DEFAULT NULL COMMENT '车架费预估' AFTER `calc_chassis_days`,
    ADD COLUMN `hold_type` varchar(32) DEFAULT NULL COMMENT 'Hold类型' AFTER `calc_chassis_fee_est`,
    ADD COLUMN `hold_resolved_at` datetime DEFAULT NULL COMMENT 'Hold解除时间' AFTER `hold_type`,
    ADD COLUMN `exam_type` varchar(32) DEFAULT NULL COMMENT '查验类型' AFTER `hold_resolved_at`,
    ADD COLUMN `exam_tags` json DEFAULT NULL COMMENT '查验标签' AFTER `exam_type`,
    ADD COLUMN `exam_start_at` datetime DEFAULT NULL COMMENT '查验开始' AFTER `exam_tags`,
    ADD COLUMN `exam_end_at` datetime DEFAULT NULL COMMENT '查验结束' AFTER `exam_start_at`;

-- 3. 运输
ALTER TABLE `oms_container_transport_info`
    ADD COLUMN `trucker_id` bigint DEFAULT NULL COMMENT '卡车商ID' AFTER `voyage_no`,
    ADD COLUMN `trucker_name` varchar(128) DEFAULT NULL COMMENT '卡车商名称' AFTER `trucker_id`,
    ADD COLUMN `eta_warehouse` datetime DEFAULT NULL COMMENT '预计到仓' AFTER `trucker_name`,
    ADD COLUMN `required_warehouse_at` datetime DEFAULT NULL COMMENT '要求到仓' AFTER `eta_warehouse`,
    ADD COLUMN `chassis_no` varchar(64) DEFAULT NULL COMMENT '车架号' AFTER `required_warehouse_at`,
    ADD COLUMN `dock_no` varchar(64) DEFAULT NULL COMMENT '月台' AFTER `chassis_no`,
    ADD COLUMN `dock_assigned_at` datetime DEFAULT NULL COMMENT '月台分配时间' AFTER `dock_no`,
    ADD COLUMN `picked_up_at` datetime DEFAULT NULL COMMENT '提柜时间' AFTER `dock_assigned_at`,
    ADD COLUMN `arrived_at` datetime DEFAULT NULL COMMENT '到仓时间' AFTER `picked_up_at`;

-- 4. 拆柜信息（新表）
CREATE TABLE IF NOT EXISTS `oms_container_unstuff_info` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `container_order_id` bigint NOT NULL COMMENT '海柜',
  `wms_task_id` varchar(64) DEFAULT NULL COMMENT 'WMS任务ID',
  `wms_unstuff_status` varchar(32) DEFAULT NULL COMMENT 'WMS拆柜状态',
  `wms_unstuff_start_at` datetime DEFAULT NULL COMMENT '拆柜开始',
  `wms_unstuff_end_at` datetime DEFAULT NULL COMMENT '拆柜结束',
  `wms_actual_ctns` int DEFAULT NULL COMMENT '实际件数',
  `wms_total_orders` int DEFAULT NULL COMMENT '订单总数',
  `wms_completed_orders` int DEFAULT NULL COMMENT '完成订单数',
  `wms_exception_orders` int DEFAULT NULL COMMENT '异常订单数',
  `empty_reported_at` datetime DEFAULT NULL COMMENT '报空时间',
  `empty_location` varchar(128) DEFAULT NULL COMMENT '报空位置',
  `returned_at` datetime DEFAULT NULL COMMENT '还柜时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_container_order_id` (`container_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='海柜拆柜信息';

-- 5. 委托单扩展
ALTER TABLE `cargo_order`
    ADD COLUMN `warehouse_code` varchar(64) DEFAULT NULL COMMENT '仓库编码' AFTER `warehouse_id`,
    ADD COLUMN `platform` varchar(64) DEFAULT NULL COMMENT '平台' AFTER `warehouse_code`,
    ADD COLUMN `biz_type` varchar(64) DEFAULT NULL COMMENT '业务类型' AFTER `platform`,
    ADD COLUMN `end_customer_id` bigint DEFAULT NULL COMMENT '终端客户' AFTER `customer_id`,
    ADD COLUMN `address_type` varchar(32) DEFAULT NULL COMMENT '地址类型' AFTER `biz_type`,
    ADD COLUMN `goods_name` varchar(256) DEFAULT NULL COMMENT '品名' AFTER `address_type`,
    ADD COLUMN `shipment_code` varchar(64) DEFAULT NULL COMMENT '货件编码' AFTER `goods_name`,
    ADD COLUMN `po_no` varchar(64) DEFAULT NULL COMMENT 'PO' AFTER `shipment_code`,
    ADD COLUMN `planned_ctns` int DEFAULT NULL COMMENT '计划件数' AFTER `po_no`,
    ADD COLUMN `wms_actual_ctns` int DEFAULT NULL COMMENT 'WMS实际件数' AFTER `planned_ctns`,
    ADD COLUMN `gross_weight_lbs` decimal(18,3) DEFAULT NULL COMMENT '毛重LBS' AFTER `wms_actual_ctns`,
    ADD COLUMN `gross_weight_kg` decimal(18,3) DEFAULT NULL COMMENT '毛重KG' AFTER `gross_weight_lbs`,
    ADD COLUMN `cbm` decimal(18,3) DEFAULT NULL COMMENT '体积' AFTER `gross_weight_kg`,
    ADD COLUMN `lfd` date DEFAULT NULL COMMENT 'LFD' AFTER `cbm`,
    ADD COLUMN `dw_date` date DEFAULT NULL COMMENT 'DW日期' AFTER `lfd`,
    ADD COLUMN `dw_start` varchar(16) DEFAULT NULL COMMENT 'DW开始' AFTER `dw_date`,
    ADD COLUMN `dw_end` varchar(16) DEFAULT NULL COMMENT 'DW结束' AFTER `dw_start`,
    ADD COLUMN `tms_order_id` varchar(64) DEFAULT NULL COMMENT 'TMS单号' AFTER `dw_end`,
    ADD COLUMN `is_transfer` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否转运' AFTER `tms_order_id`,
    ADD COLUMN `wms_exception_ctns` int DEFAULT 0 COMMENT 'WMS异常件数' AFTER `is_transfer`,
    ADD COLUMN `calc_age_days` int DEFAULT NULL COMMENT '库龄天数' AFTER `wms_exception_ctns`,
    ADD COLUMN `internal_remark` varchar(1024) DEFAULT NULL COMMENT '内部备注' AFTER `calc_age_days`,
    ADD COLUMN `current_route_node` varchar(64) DEFAULT NULL COMMENT '当前路由节点' AFTER `internal_remark`;

-- 6. 订单路由节点（重命名兼容：若仅有 oms_route_node 则保留，新增别名表）
CREATE TABLE IF NOT EXISTS `oms_order_route_node` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `cargo_order_id` bigint NOT NULL COMMENT '委托单',
  `node_code` varchar(64) NOT NULL COMMENT '节点编码',
  `node_name` varchar(128) NOT NULL COMMENT '节点名称',
  `node_time` datetime DEFAULT NULL COMMENT '节点时间',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序',
  `status` varchar(16) DEFAULT 'pending' COMMENT 'done/current/pending',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='订单路由节点';

-- 7. biz_event 扩展（事件日志页）
ALTER TABLE `biz_event`
    ADD COLUMN `biz_root_no` varchar(32) DEFAULT NULL COMMENT '业务主线号' AFTER `biz_root_id`,
    ADD COLUMN `biz_type` varchar(32) DEFAULT NULL COMMENT '业务类型' AFTER `biz_root_no`,
    ADD COLUMN `source_system` varchar(32) DEFAULT 'OMS' COMMENT '来源系统' AFTER `event_code`,
    ADD COLUMN `source_table` varchar(64) DEFAULT NULL COMMENT '来源表' AFTER `source_system`,
    ADD COLUMN `source_id` bigint DEFAULT NULL COMMENT '来源ID' AFTER `source_table`,
    ADD COLUMN `event_time` datetime DEFAULT NULL COMMENT '事件时间' AFTER `source_id`,
    ADD COLUMN `operator_id` bigint DEFAULT NULL COMMENT '操作人' AFTER `event_time`,
    ADD COLUMN `operator_name` varchar(64) DEFAULT NULL COMMENT '操作人' AFTER `operator_id`,
    ADD COLUMN `is_manual` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否人工' AFTER `operator_name`,
    ADD COLUMN `consume_status` varchar(16) DEFAULT NULL COMMENT '消费状态' AFTER `status`,
    ADD COLUMN `consume_error` varchar(512) DEFAULT NULL COMMENT '消费错误' AFTER `consume_status`;
