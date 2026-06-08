-- ============================================================
-- OMS 模块补丁（对齐参考系统 ruoyi-oms）
-- 目标库：Yudao ruoyi-vue-pro（bigint tenant_id, creator/updater varchar）
-- 执行前请备份；可重复执行（条件 DDL）
-- ============================================================
SET NAMES utf8mb4;

-- ===================== 1. biz_root 生命周期字段 =====================
SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='biz_root' AND COLUMN_NAME='current_module')=0,
  'ALTER TABLE `biz_root` ADD COLUMN `current_module` varchar(32) DEFAULT NULL COMMENT ''当前模块'' AFTER `status`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='biz_root' AND COLUMN_NAME='current_node')=0,
  'ALTER TABLE `biz_root` ADD COLUMN `current_node` varchar(64) DEFAULT NULL COMMENT ''当前节点'' AFTER `current_module`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='biz_root' AND COLUMN_NAME='current_node_name')=0,
  'ALTER TABLE `biz_root` ADD COLUMN `current_node_name` varchar(64) DEFAULT NULL COMMENT ''当前节点名称'' AFTER `current_node`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='biz_root' AND COLUMN_NAME='current_node_time')=0,
  'ALTER TABLE `biz_root` ADD COLUMN `current_node_time` datetime DEFAULT NULL COMMENT ''当前节点时间'' AFTER `current_node_name`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='biz_root' AND COLUMN_NAME='root_status')=0,
  'ALTER TABLE `biz_root` ADD COLUMN `root_status` varchar(32) DEFAULT ''RUNNING'' COMMENT ''RUNNING/DONE/CANCELLED'' AFTER `current_node_time`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='biz_root' AND COLUMN_NAME='complete_time')=0,
  'ALTER TABLE `biz_root` ADD COLUMN `complete_time` datetime DEFAULT NULL COMMENT ''完成时间'' AFTER `root_status`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='biz_root' AND COLUMN_NAME='cancel_time')=0,
  'ALTER TABLE `biz_root` ADD COLUMN `cancel_time` datetime DEFAULT NULL COMMENT ''取消时间'' AFTER `complete_time`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ===================== 2. cargo_order 出库/分组/生命周期扩展 =====================
SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='cargo_order' AND COLUMN_NAME='container_order_id')=0,
  'ALTER TABLE `cargo_order` ADD COLUMN `container_order_id` bigint DEFAULT NULL COMMENT ''海柜工单ID'' AFTER `biz_root_id`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='cargo_order' AND COLUMN_NAME='container_no')=0,
  'ALTER TABLE `cargo_order` ADD COLUMN `container_no` varchar(32) DEFAULT NULL COMMENT ''柜号冗余'' AFTER `container_order_id`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='cargo_order' AND COLUMN_NAME='shipment_codes')=0,
  'ALTER TABLE `cargo_order` ADD COLUMN `shipment_codes` varchar(2000) DEFAULT NULL COMMENT ''货件编码汇总'' AFTER `shipment_code`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='cargo_order' AND COLUMN_NAME='group_code')=0,
  'ALTER TABLE `cargo_order` ADD COLUMN `group_code` varchar(100) DEFAULT NULL COMMENT ''入库分组'' AFTER `cbm`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='cargo_order' AND COLUMN_NAME='customer_name')=0,
  'ALTER TABLE `cargo_order` ADD COLUMN `customer_name` varchar(128) DEFAULT NULL COMMENT ''客户名称冗余'' AFTER `customer_id`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='cargo_order' AND COLUMN_NAME='channel_name')=0,
  'ALTER TABLE `cargo_order` ADD COLUMN `channel_name` varchar(128) DEFAULT NULL COMMENT ''渠道名称冗余'' AFTER `customer_name`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='cargo_order' AND COLUMN_NAME='business_type_name')=0,
  'ALTER TABLE `cargo_order` ADD COLUMN `business_type_name` varchar(64) DEFAULT NULL COMMENT ''业务类型名称'' AFTER `biz_type`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='cargo_order' AND COLUMN_NAME='pre_outbound_flag')=0,
  'ALTER TABLE `cargo_order` ADD COLUMN `pre_outbound_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT ''是否有预出单'' AFTER `group_code`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='cargo_order' AND COLUMN_NAME='pre_outbound_no')=0,
  'ALTER TABLE `cargo_order` ADD COLUMN `pre_outbound_no` varchar(64) DEFAULT NULL COMMENT ''预出单号'' AFTER `pre_outbound_flag`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='cargo_order' AND COLUMN_NAME='pre_outbound_status')=0,
  'ALTER TABLE `cargo_order` ADD COLUMN `pre_outbound_status` varchar(32) NOT NULL DEFAULT ''NONE'' COMMENT ''预出单状态'' AFTER `pre_outbound_no`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='cargo_order' AND COLUMN_NAME='pre_outbound_time')=0,
  'ALTER TABLE `cargo_order` ADD COLUMN `pre_outbound_time` datetime DEFAULT NULL COMMENT ''预出单创建时间'' AFTER `pre_outbound_status`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='cargo_order' AND COLUMN_NAME='pre_outbound_convert_time')=0,
  'ALTER TABLE `cargo_order` ADD COLUMN `pre_outbound_convert_time` datetime DEFAULT NULL COMMENT ''预出单转正式时间'' AFTER `pre_outbound_time`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='cargo_order' AND COLUMN_NAME='outbound_batch_no')=0,
  'ALTER TABLE `cargo_order` ADD COLUMN `outbound_batch_no` varchar(64) DEFAULT NULL COMMENT ''出库批次号/出库单号'' AFTER `pre_outbound_convert_time`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='cargo_order' AND COLUMN_NAME='outbound_order_status')=0,
  'ALTER TABLE `cargo_order` ADD COLUMN `outbound_order_status` varchar(32) NOT NULL DEFAULT ''NONE'' COMMENT ''出库单状态'' AFTER `outbound_batch_no`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='cargo_order' AND COLUMN_NAME='outbound_order_time')=0,
  'ALTER TABLE `cargo_order` ADD COLUMN `outbound_order_time` datetime DEFAULT NULL COMMENT ''正式出单时间'' AFTER `outbound_order_status`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='cargo_order' AND COLUMN_NAME='hold_flag')=0,
  'ALTER TABLE `cargo_order` ADD COLUMN `hold_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT ''扣货标记'' AFTER `on_hold`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='cargo_order' AND COLUMN_NAME='transfer_flag')=0,
  'ALTER TABLE `cargo_order` ADD COLUMN `transfer_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT ''转仓标记'' AFTER `is_transfer`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='cargo_order' AND COLUMN_NAME='transfer_warehouse_code')=0,
  'ALTER TABLE `cargo_order` ADD COLUMN `transfer_warehouse_code` varchar(64) DEFAULT NULL COMMENT ''转仓目标仓库代码'' AFTER `transfer_platform_address_code`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='cargo_order' AND COLUMN_NAME='declared_carton_qty')=0,
  'ALTER TABLE `cargo_order` ADD COLUMN `declared_carton_qty` decimal(10,2) DEFAULT NULL COMMENT ''预报箱数'' AFTER `planned_ctns`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='cargo_order' AND COLUMN_NAME='actual_carton_qty')=0,
  'ALTER TABLE `cargo_order` ADD COLUMN `actual_carton_qty` decimal(10,2) DEFAULT NULL COMMENT ''实际箱数'' AFTER `wms_actual_ctns`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='cargo_order' AND COLUMN_NAME='declared_cbm')=0,
  'ALTER TABLE `cargo_order` ADD COLUMN `declared_cbm` decimal(12,3) DEFAULT NULL COMMENT ''预报体积'' AFTER `cbm`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='cargo_order' AND COLUMN_NAME='actual_cbm')=0,
  'ALTER TABLE `cargo_order` ADD COLUMN `actual_cbm` decimal(12,3) DEFAULT NULL COMMENT ''实际体积'' AFTER `declared_cbm`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='cargo_order' AND COLUMN_NAME='delivery_lfd')=0,
  'ALTER TABLE `cargo_order` ADD COLUMN `delivery_lfd` datetime DEFAULT NULL COMMENT ''派送LFD'' AFTER `lfd`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='cargo_order' AND COLUMN_NAME='earliest_dw_time')=0,
  'ALTER TABLE `cargo_order` ADD COLUMN `earliest_dw_time` datetime DEFAULT NULL COMMENT ''最早DW时间'' AFTER `dw_date`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='cargo_order' AND COLUMN_NAME='appointment_status')=0,
  'ALTER TABLE `cargo_order` ADD COLUMN `appointment_status` varchar(32) DEFAULT ''NONE'' COMMENT ''预约状态'' AFTER `appointment_no`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='cargo_order' AND COLUMN_NAME='pod_status')=0,
  'ALTER TABLE `cargo_order` ADD COLUMN `pod_status` varchar(32) DEFAULT NULL COMMENT ''POD状态'' AFTER `appointment_status`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='cargo_order' AND COLUMN_NAME='billing_status')=0,
  'ALTER TABLE `cargo_order` ADD COLUMN `billing_status` varchar(32) DEFAULT NULL COMMENT ''出账状态'' AFTER `pod_status`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ===================== 3. shipment 分组字段 =====================
SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='shipment' AND COLUMN_NAME='group_code')=0,
  'ALTER TABLE `shipment` ADD COLUMN `group_code` varchar(100) DEFAULT NULL COMMENT ''入库分组'' AFTER `cbm`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ===================== 4. 海柜 WMS/YMS 集成字段 =====================
SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='oms_container_order' AND COLUMN_NAME='devanning_order_no')=0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `devanning_order_no` varchar(64) DEFAULT NULL COMMENT ''WMS拆柜单号'' AFTER `unstuff_status`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='oms_container_order' AND COLUMN_NAME='devanning_appointment_time')=0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `devanning_appointment_time` datetime DEFAULT NULL COMMENT ''拆柜预约时间'' AFTER `devanning_order_no`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='oms_container_order' AND COLUMN_NAME='expected_devanning_time')=0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `expected_devanning_time` datetime DEFAULT NULL COMMENT ''预计拆柜时间'' AFTER `devanning_appointment_time`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='oms_container_order' AND COLUMN_NAME='actual_arrival_time')=0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `actual_arrival_time` datetime DEFAULT NULL COMMENT ''实际到仓时间'' AFTER `ata`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='oms_container_order' AND COLUMN_NAME='actual_pickup_time')=0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `actual_pickup_time` datetime DEFAULT NULL COMMENT ''实际提柜时间'' AFTER `actual_arrival_time`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='oms_container_order' AND COLUMN_NAME='devanning_start_time')=0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `devanning_start_time` datetime DEFAULT NULL COMMENT ''拆柜开始时间'' AFTER `actual_pickup_time`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='oms_container_order' AND COLUMN_NAME='devanning_finish_time')=0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `devanning_finish_time` datetime DEFAULT NULL COMMENT ''拆柜完成时间'' AFTER `devanning_start_time`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='oms_container_order' AND COLUMN_NAME='pre_plan_truck_qty')=0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `pre_plan_truck_qty` decimal(10,2) DEFAULT NULL COMMENT ''预排车数'' AFTER `order_completed_count`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='oms_container_order' AND COLUMN_NAME='pre_plan_cbm')=0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `pre_plan_cbm` decimal(12,3) DEFAULT NULL COMMENT ''预排方数'' AFTER `pre_plan_truck_qty`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='oms_container_order' AND COLUMN_NAME='downstream_exception_flag')=0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `downstream_exception_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT ''下游推送异常'' AFTER `pre_plan_cbm`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ===================== 5. 节点轨迹 =====================
CREATE TABLE IF NOT EXISTS `cargo_order_node_trace` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `cargo_order_id` bigint NOT NULL COMMENT '委托单ID',
  `biz_root_id` bigint DEFAULT NULL COMMENT '业务主线ID',
  `node_code` varchar(64) NOT NULL COMMENT '节点编码',
  `node_name` varchar(64) DEFAULT NULL COMMENT '节点名称',
  `node_status` varchar(32) DEFAULT 'DONE' COMMENT '节点状态',
  `status_from` varchar(64) DEFAULT NULL COMMENT '来源状态',
  `status_to` varchar(64) DEFAULT NULL COMMENT '目标状态',
  `action` varchar(64) DEFAULT NULL COMMENT '动作',
  `actual_time` datetime DEFAULT NULL COMMENT '实际时间',
  `source_type` varchar(32) DEFAULT 'OMS' COMMENT '来源',
  `operator_id` bigint DEFAULT NULL COMMENT '操作人',
  `operator_name` varchar(64) DEFAULT NULL COMMENT '操作人姓名',
  `remark` varchar(512) DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`),
  KEY `idx_biz_root_id` (`biz_root_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='委托单生命周期节点轨迹';

-- ===================== 6. 入库计划 =====================
CREATE TABLE IF NOT EXISTS `wms_inbound_plan` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `warehouse_id` bigint NOT NULL COMMENT '仓库ID',
  `container_order_id` bigint NOT NULL COMMENT '海柜工单ID',
  `container_order_no` varchar(64) DEFAULT NULL COMMENT '海柜工单号冗余',
  `plan_no` varchar(64) NOT NULL COMMENT '计划编号',
  `status` varchar(20) NOT NULL DEFAULT 'draft' COMMENT 'draft/in_progress/completed/cancelled',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_plan_no` (`tenant_id`, `plan_no`),
  KEY `idx_container_order_id` (`container_order_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='入库计划';

CREATE TABLE IF NOT EXISTS `wms_inbound_plan_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `plan_id` bigint NOT NULL COMMENT '计划ID',
  `cargo_order_id` bigint NOT NULL COMMENT '委托单ID',
  `shipment_id` bigint NOT NULL COMMENT '货件ID',
  `group_code` varchar(100) DEFAULT NULL COMMENT '分组',
  `pre_location` varchar(100) DEFAULT NULL COMMENT '预库位',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  KEY `idx_plan_id` (`plan_id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`),
  KEY `idx_shipment_id` (`shipment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='入库计划明细';

CREATE TABLE IF NOT EXISTS `wms_inbound_plan_change_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `plan_id` bigint NOT NULL COMMENT '计划ID',
  `plan_item_id` bigint NOT NULL COMMENT '明细ID',
  `shipment_id` bigint NOT NULL COMMENT '货件ID',
  `old_group_code` varchar(100) DEFAULT NULL COMMENT '变更前',
  `new_group_code` varchar(100) DEFAULT NULL COMMENT '变更后',
  `change_type` varchar(30) NOT NULL COMMENT 'auto_group/quick_config/manual',
  `change_by` bigint DEFAULT NULL COMMENT '操作人',
  `change_time` datetime DEFAULT NULL COMMENT '操作时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  KEY `idx_plan_id` (`plan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='入库计划分组变更日志';

-- ===================== 7. 预出单 / 出库单 =====================
CREATE TABLE IF NOT EXISTS `oms_pre_outbound` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `biz_root_id` bigint DEFAULT NULL COMMENT '业务主线',
  `cargo_order_id` bigint DEFAULT NULL COMMENT '兼容字段',
  `cargo_order_no` varchar(512) DEFAULT NULL COMMENT '委托单号汇总',
  `cargo_order_count` int NOT NULL DEFAULT 0 COMMENT '关联委托单数',
  `pre_outbound_no` varchar(64) NOT NULL COMMENT '预出单号',
  `pre_outbound_status` varchar(32) NOT NULL DEFAULT 'PENDING_INBOUND' COMMENT '状态',
  `outbound_direction` varchar(32) NOT NULL DEFAULT 'DELIVERY' COMMENT '方向',
  `outbound_warehouse_id` bigint DEFAULT NULL COMMENT '出库仓',
  `outbound_warehouse_name` varchar(128) DEFAULT NULL COMMENT '出库仓名称',
  `customer_name` varchar(128) DEFAULT NULL COMMENT '客户',
  `container_no` varchar(256) DEFAULT NULL COMMENT '柜号',
  `shipment_codes` varchar(2000) DEFAULT NULL COMMENT '货件',
  `declared_carton_qty` decimal(10,2) DEFAULT NULL,
  `declared_pallet_qty` decimal(10,2) DEFAULT NULL,
  `declared_weight` decimal(12,3) DEFAULT NULL,
  `declared_cbm` decimal(12,3) DEFAULT NULL,
  `actual_carton_qty` decimal(10,2) DEFAULT NULL,
  `actual_pallet_qty` decimal(10,2) DEFAULT NULL,
  `actual_weight` decimal(12,3) DEFAULT NULL,
  `actual_cbm` decimal(12,3) DEFAULT NULL,
  `earliest_dw_time` datetime DEFAULT NULL,
  `delivery_lfd` datetime DEFAULT NULL,
  `ready_time` datetime DEFAULT NULL,
  `converted_time` datetime DEFAULT NULL,
  `outbound_order_no` varchar(64) DEFAULT NULL,
  `appointment_no` varchar(64) DEFAULT NULL,
  `appointment_time` datetime DEFAULT NULL,
  `delivery_truck` varchar(128) DEFAULT NULL,
  `loading_type` varchar(32) DEFAULT NULL,
  `transport_type` varchar(32) DEFAULT NULL,
  `delivery_tag` varchar(128) DEFAULT NULL,
  `destination` varchar(255) DEFAULT NULL,
  `delivery_method` varchar(64) DEFAULT NULL,
  `follow_record` varchar(1000) DEFAULT NULL,
  `remark` varchar(500) DEFAULT NULL,
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_pre_outbound_no` (`tenant_id`, `pre_outbound_no`),
  KEY `idx_pre_status` (`pre_outbound_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='预出单';

CREATE TABLE IF NOT EXISTS `oms_pre_outbound_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `pre_outbound_id` bigint NOT NULL COMMENT '预出单ID',
  `pre_outbound_no` varchar(64) NOT NULL COMMENT '预出单号',
  `cargo_order_id` bigint NOT NULL COMMENT '委托单ID',
  `cargo_order_no` varchar(64) NOT NULL COMMENT '委托单号',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  KEY `idx_pre_outbound_id` (`pre_outbound_id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='预出单明细';

CREATE TABLE IF NOT EXISTS `oms_outbound_order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `biz_root_id` bigint DEFAULT NULL COMMENT '业务主线',
  `cargo_order_id` bigint DEFAULT NULL COMMENT '兼容字段',
  `cargo_order_no` varchar(512) DEFAULT NULL COMMENT '委托单号汇总',
  `pre_outbound_id` bigint DEFAULT NULL COMMENT '预出单ID',
  `pre_outbound_no` varchar(64) DEFAULT NULL COMMENT '预出单号',
  `cargo_order_count` int NOT NULL DEFAULT 0 COMMENT '关联委托单数',
  `outbound_order_no` varchar(64) NOT NULL COMMENT '出库单号',
  `outbound_status` varchar(32) NOT NULL DEFAULT 'CREATED' COMMENT '状态',
  `outbound_direction` varchar(32) NOT NULL DEFAULT 'DELIVERY' COMMENT '方向',
  `outbound_warehouse_id` bigint DEFAULT NULL COMMENT '出库仓',
  `outbound_warehouse_name` varchar(128) DEFAULT NULL COMMENT '出库仓名称',
  `customer_name` varchar(128) DEFAULT NULL COMMENT '客户',
  `container_no` varchar(256) DEFAULT NULL COMMENT '柜号',
  `shipment_codes` varchar(2000) DEFAULT NULL COMMENT '货件',
  `actual_carton_qty` decimal(10,2) DEFAULT NULL,
  `actual_pallet_qty` decimal(10,2) DEFAULT NULL,
  `actual_weight` decimal(12,3) DEFAULT NULL,
  `actual_cbm` decimal(12,3) DEFAULT NULL,
  `delivery_method` varchar(64) DEFAULT NULL,
  `appointment_status` varchar(32) DEFAULT 'NONE',
  `appointment_time` datetime DEFAULT NULL,
  `delivery_lfd` datetime DEFAULT NULL,
  `contact_name` varchar(128) DEFAULT NULL,
  `contact_phone` varchar(64) DEFAULT NULL,
  `contact_email` varchar(128) DEFAULT NULL,
  `transfer_in_warehouse_id` bigint DEFAULT NULL,
  `transfer_method` varchar(64) DEFAULT NULL,
  `transfer_reason` varchar(500) DEFAULT NULL,
  `actual_outbound_time` datetime DEFAULT NULL,
  `pod_status` varchar(32) DEFAULT 'PENDING',
  `pod_upload_time` datetime DEFAULT NULL,
  `completed_time` datetime DEFAULT NULL,
  `remark` varchar(500) DEFAULT NULL,
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_outbound_order_no` (`tenant_id`, `outbound_order_no`),
  KEY `idx_outbound_status` (`outbound_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='出库单';

CREATE TABLE IF NOT EXISTS `oms_outbound_order_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `outbound_order_id` bigint NOT NULL COMMENT '出库单ID',
  `outbound_order_no` varchar(64) NOT NULL COMMENT '出库单号',
  `cargo_order_id` bigint NOT NULL COMMENT '委托单ID',
  `cargo_order_no` varchar(64) NOT NULL COMMENT '委托单号',
  `pre_outbound_item_id` bigint DEFAULT NULL COMMENT '预出单明细ID',
  `actual_carton_qty` decimal(10,2) DEFAULT NULL,
  `actual_pallet_qty` decimal(10,2) DEFAULT NULL,
  `actual_weight` decimal(12,3) DEFAULT NULL,
  `actual_cbm` decimal(12,3) DEFAULT NULL,
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_outbound_cargo` (`outbound_order_id`, `cargo_order_id`, `tenant_id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='出库单明细';

-- ===================== 8. 分组规则 =====================
CREATE TABLE IF NOT EXISTS `oms_cargo_grouping_field_meta` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `table_alias` varchar(32) NOT NULL COMMENT 'order/shipment',
  `field_name` varchar(64) NOT NULL COMMENT '字段名',
  `display_name` varchar(128) NOT NULL COMMENT '展示名',
  `data_type` varchar(32) NOT NULL COMMENT '类型',
  `enum_code` varchar(64) DEFAULT NULL,
  `ref_type` varchar(64) DEFAULT NULL,
  `can_be_condition` tinyint(1) NOT NULL DEFAULT 1,
  `can_be_group_key` tinyint(1) NOT NULL DEFAULT 1,
  `sort_order` int NOT NULL DEFAULT 0,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `remark` varchar(500) DEFAULT NULL,
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_grouping_field` (`table_alias`, `field_name`, `tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='分组字段元数据';

CREATE TABLE IF NOT EXISTS `oms_cargo_grouping_rule` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `warehouse_name` varchar(128) DEFAULT NULL COMMENT '仓库名称',
  `warehouse_ids` json DEFAULT NULL COMMENT '仓库ID列表JSON',
  `rule_name` varchar(128) NOT NULL COMMENT '规则名称',
  `condition_config` json NOT NULL COMMENT '条件JSON',
  `group_key_config` json NOT NULL COMMENT '分组键JSON',
  `priority` int NOT NULL DEFAULT 0 COMMENT '优先级',
  `is_default` tinyint(1) NOT NULL DEFAULT 0 COMMENT '内置规则',
  `status` varchar(32) NOT NULL DEFAULT 'enabled' COMMENT 'enabled/disabled',
  `version` int NOT NULL DEFAULT 0 COMMENT '乐观锁',
  `remark` varchar(500) DEFAULT NULL,
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  KEY `idx_grouping_rule_status` (`status`, `priority`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='分组规则';

-- ===================== 9. 数据回填（WHERE 含主键 id，兼容 MySQL Safe Update Mode） =====================
UPDATE `cargo_order` SET `declared_carton_qty` = `planned_ctns` WHERE `id` > 0 AND `declared_carton_qty` IS NULL AND `planned_ctns` IS NOT NULL;
UPDATE `cargo_order` SET `actual_carton_qty` = `wms_actual_ctns` WHERE `id` > 0 AND `actual_carton_qty` IS NULL AND `wms_actual_ctns` IS NOT NULL;
UPDATE `cargo_order` SET `declared_cbm` = `cbm` WHERE `id` > 0 AND `declared_cbm` IS NULL AND `cbm` IS NOT NULL;
UPDATE `cargo_order` SET `hold_flag` = IF(`on_hold` = 1 OR `on_hold` = b'1', 1, 0) WHERE `id` > 0 AND `hold_flag` = 0;
UPDATE `cargo_order` SET `transfer_flag` = IF(`is_transfer` = 1 OR `is_transfer` = b'1', 1, 0) WHERE `id` > 0 AND `transfer_flag` = 0;
UPDATE `cargo_order` SET `transfer_warehouse_code` = `transfer_platform_address_code` WHERE `id` > 0 AND `transfer_warehouse_code` IS NULL AND `transfer_platform_address_code` IS NOT NULL;
UPDATE `cargo_order` co
INNER JOIN `biz_relation` br ON br.cargo_order_id = co.id AND br.deleted = 0 AND br.relation_type = 'LOADED_IN'
SET co.container_order_id = br.container_order_id
WHERE co.id > 0 AND co.container_order_id IS NULL;

UPDATE `cargo_order` co
INNER JOIN `oms_container_order` c ON c.id = co.container_order_id AND c.deleted = 0
SET co.container_no = c.container_no
WHERE co.id > 0 AND co.container_no IS NULL;

UPDATE `biz_root` br
INNER JOIN `cargo_order` co ON co.biz_root_id = br.id
SET br.current_module = 'OMS',
    br.current_node = COALESCE(NULLIF(co.fulfillment_status, ''), 'PENDING_ACCEPT'),
    br.root_status = CASE WHEN co.fulfillment_status IN ('COMPLETED','POD_SIGNED') THEN 'DONE' WHEN co.fulfillment_status = 'CANCELLED' THEN 'CANCELLED' ELSE 'RUNNING' END
WHERE br.id > 0 AND br.current_node IS NULL;
