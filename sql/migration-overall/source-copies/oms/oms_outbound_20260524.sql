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

INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `create_time`, `remark`) VALUES
(6000001001, '000000', '出单方向', 'oms_outbound_direction', NOW(), 'OMS出单方向'),
(6000001002, '000000', '出单准备状态', 'oms_outbound_readiness', NOW(), '出单工作台准备状态'),
(6000001003, '000000', '预出单状态', 'oms_pre_outbound_status', NOW(), '预出单状态'),
(6000001004, '000000', '出库订单状态', 'oms_outbound_status', NOW(), '出库订单状态')
ON DUPLICATE KEY UPDATE `dict_name` = VALUES(`dict_name`), `dict_type` = VALUES(`dict_type`), `update_time` = NOW();

INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `list_class`, `is_default`, `create_time`, `remark`) VALUES
(6000001101, '000000', 1, '派送', 'DELIVERY', 'oms_outbound_direction', 'primary', 'Y', NOW(), NULL),
(6000001102, '000000', 2, '调拨', 'TRANSFER', 'oms_outbound_direction', 'info', 'N', NOW(), NULL),
(6000001201, '000000', 1, '未入库', 'NOT_INBOUNDED', 'oms_outbound_readiness', 'warning', 'N', NOW(), NULL),
(6000001202, '000000', 2, '拆柜中', 'DEVANNING', 'oms_outbound_readiness', 'info', 'N', NOW(), NULL),
(6000001203, '000000', 3, '已入库', 'INBOUNDED', 'oms_outbound_readiness', 'success', 'N', NOW(), NULL),
(6000001301, '000000', 1, '待入库', 'PENDING_INBOUND', 'oms_pre_outbound_status', 'warning', 'N', NOW(), NULL),
(6000001302, '000000', 2, '拆柜中', 'DEVANNING', 'oms_pre_outbound_status', 'info', 'N', NOW(), NULL),
(6000001303, '000000', 3, '可转出库', 'READY_TO_CONVERT', 'oms_pre_outbound_status', 'success', 'N', NOW(), NULL),
(6000001304, '000000', 4, '已转出库', 'CONVERTED', 'oms_pre_outbound_status', 'success', 'N', NOW(), NULL),
(6000001305, '000000', 5, '已取消', 'CANCELLED', 'oms_pre_outbound_status', 'default', 'N', NOW(), NULL),
(6000001401, '000000', 1, '已创建', 'CREATED', 'oms_outbound_status', 'info', 'N', NOW(), NULL),
(6000001402, '000000', 2, '已派发', 'DISPATCHED', 'oms_outbound_status', 'info', 'N', NOW(), NULL),
(6000001403, '000000', 3, '已出库', 'OUTBOUNDED', 'oms_outbound_status', 'success', 'N', NOW(), NULL),
(6000001404, '000000', 4, '派送中', 'DELIVERING', 'oms_outbound_status', 'info', 'N', NOW(), NULL),
(6000001405, '000000', 5, '已签收', 'DELIVERED', 'oms_outbound_status', 'success', 'N', NOW(), NULL),
(6000001406, '000000', 6, '已完成', 'COMPLETED', 'oms_outbound_status', 'success', 'N', NOW(), NULL),
(6000001407, '000000', 7, '已取消', 'CANCELLED', 'oms_outbound_status', 'default', 'N', NOW(), NULL)
ON DUPLICATE KEY UPDATE `dict_label` = VALUES(`dict_label`), `dict_value` = VALUES(`dict_value`), `dict_type` = VALUES(`dict_type`), `list_class` = VALUES(`list_class`), `update_time` = NOW();

INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_time`, `remark`) VALUES
(3010, '出单工作台', 3000, 3, 'outbound-pool', 'oms/outbound-pool/index', NULL, 1, 0, 'C', '0', '0', 'oms:outboundPool:list', 'list', NOW(), ''),
(3011, '预出单管理', 3000, 4, 'pre-outbound', 'oms/pre-outbound/index', NULL, 1, 0, 'C', '0', '0', 'oms:preOutbound:list', 'calendar', NOW(), ''),
(3012, '出库订单', 3000, 5, 'outbound-order', 'oms/outbound-order/index', NULL, 1, 0, 'C', '0', '0', 'oms:outboundOrder:list', 'truck', NOW(), ''),
(301010, '创建预出单', 3010, 1, '', '', NULL, 1, 0, 'F', '0', '0', 'oms:outboundPool:createPreOutbound', '#', NOW(), ''),
(301011, '创建出库订单', 3010, 2, '', '', NULL, 1, 0, 'F', '0', '0', 'oms:outboundPool:createOutboundOrder', '#', NOW(), ''),
(301012, '批量创建预出单', 3010, 3, '', '', NULL, 1, 0, 'F', '0', '0', 'oms:outboundPool:batchCreatePreOutbound', '#', NOW(), ''),
(301013, '批量创建出库订单', 3010, 4, '', '', NULL, 1, 0, 'F', '0', '0', 'oms:outboundPool:batchCreateOutboundOrder', '#', NOW(), ''),
(301110, '预出单查询', 3011, 1, '', '', NULL, 1, 0, 'F', '0', '0', 'oms:preOutbound:query', '#', NOW(), ''),
(301111, '预出单取消', 3011, 2, '', '', NULL, 1, 0, 'F', '0', '0', 'oms:preOutbound:cancel', '#', NOW(), ''),
(301112, '预出单转出库', 3011, 3, '', '', NULL, 1, 0, 'F', '0', '0', 'oms:preOutbound:convert', '#', NOW(), ''),
(301113, '预出单导出', 3011, 4, '', '', NULL, 1, 0, 'F', '0', '0', 'oms:preOutbound:export', '#', NOW(), ''),
(301210, '出库订单查询', 3012, 1, '', '', NULL, 1, 0, 'F', '0', '0', 'oms:outboundOrder:query', '#', NOW(), ''),
(301211, '出库订单编辑', 3012, 2, '', '', NULL, 1, 0, 'F', '0', '0', 'oms:outboundOrder:edit', '#', NOW(), ''),
(301212, '出库订单取消', 3012, 3, '', '', NULL, 1, 0, 'F', '0', '0', 'oms:outboundOrder:cancel', '#', NOW(), ''),
(301213, '出库订单完成', 3012, 4, '', '', NULL, 1, 0, 'F', '0', '0', 'oms:outboundOrder:complete', '#', NOW(), ''),
(301214, '出库订单导出', 3012, 5, '', '', NULL, 1, 0, 'F', '0', '0', 'oms:outboundOrder:export', '#', NOW(), ''),
(301215, '确认预约', 3012, 6, '', '', NULL, 1, 0, 'F', '0', '0', 'oms:outboundOrder:confirmAppointment', '#', NOW(), ''),
(301216, '确认出库', 3012, 7, '', '', NULL, 1, 0, 'F', '0', '0', 'oms:outboundOrder:confirmOutbounded', '#', NOW(), ''),
(301217, '确认签收', 3012, 8, '', '', NULL, 1, 0, 'F', '0', '0', 'oms:outboundOrder:confirmSigned', '#', NOW(), ''),
(301218, '上传附件', 3012, 9, '', '', NULL, 1, 0, 'F', '0', '0', 'oms:outboundOrder:attachmentUpload', '#', NOW(), ''),
(301219, '删除附件', 3012, 10, '', '', NULL, 1, 0, 'F', '0', '0', 'oms:outboundOrder:attachmentRemove', '#', NOW(), '')
ON DUPLICATE KEY UPDATE
  `menu_name` = VALUES(`menu_name`),
  `parent_id` = VALUES(`parent_id`),
  `order_num` = VALUES(`order_num`),
  `path` = VALUES(`path`),
  `component` = VALUES(`component`),
  `perms` = VALUES(`perms`),
  `icon` = VALUES(`icon`),
  `update_time` = NOW();

UPDATE `oms_cargo_order`
SET `company_id` = 4000001,
    `inbound_warehouse_id` = 4001001,
    `inbound_warehouse_name` = 'Los Angeles Central Warehouse',
    `pre_outbound_status` = 'NONE',
    `outbound_order_status` = 'NONE',
    `hold_flag` = 0,
    `hold_status` = 'NORMAL',
    `update_time` = NOW()
WHERE `id` = 1001;

UPDATE `oms_cargo_order`
SET `fulfillment_status` = 'DEVANNING',
    `company_id` = 4000001,
    `inbound_warehouse_id` = 4001001,
    `inbound_warehouse_name` = 'Los Angeles Central Warehouse',
    `pre_outbound_status` = 'NONE',
    `outbound_order_status` = 'NONE',
    `hold_flag` = 0,
    `hold_status` = 'NORMAL',
    `actual_carton_qty` = 40,
    `actual_pallet_qty` = 4,
    `actual_weight` = 420,
    `actual_cbm` = 2.1,
    `delivery_lfd` = DATE_ADD(CURDATE(), INTERVAL 5 DAY),
    `earliest_dw_time` = DATE_ADD(CURDATE(), INTERVAL 2 DAY),
    `update_time` = NOW()
WHERE `id` = 1002;

UPDATE `oms_cargo_order`
SET `fulfillment_status` = 'INBOUNDED',
    `company_id` = 4000001,
    `inbound_warehouse_id` = 4001001,
    `inbound_warehouse_name` = 'Los Angeles Central Warehouse',
    `pre_outbound_status` = 'PRE_CREATED',
    `pre_outbound_flag` = 1,
    `pre_outbound_no` = 'POB202605240001',
    `outbound_order_status` = 'NONE',
    `hold_flag` = 0,
    `hold_status` = 'NORMAL',
    `actual_carton_qty` = `declared_carton_qty`,
    `actual_pallet_qty` = COALESCE(`actual_pallet_qty`, `declared_pallet_qty`),
    `actual_weight` = COALESCE(`actual_weight`, `declared_weight`),
    `actual_cbm` = COALESCE(`actual_cbm`, `declared_cbm`),
    `delivery_lfd` = DATE_ADD(CURDATE(), INTERVAL 7 DAY),
    `earliest_dw_time` = DATE_ADD(CURDATE(), INTERVAL 3 DAY),
    `update_time` = NOW()
WHERE `id` = 1003;

INSERT INTO `oms_pre_outbound` (`id`, `tenant_id`, `biz_root_id`, `cargo_order_id`, `cargo_order_no`, `pre_outbound_no`, `pre_outbound_status`, `outbound_direction`, `outbound_warehouse_id`, `outbound_warehouse_name`, `customer_name`, `container_no`, `shipment_codes`, `declared_carton_qty`, `declared_pallet_qty`, `declared_weight`, `declared_cbm`, `actual_carton_qty`, `actual_pallet_qty`, `actual_weight`, `actual_cbm`, `earliest_dw_time`, `delivery_lfd`, `ready_time`, `remark`, `create_time`, `deleted`)
SELECT 6000002001, `tenant_id`, `biz_root_id`, `id`, `cargo_order_no`, 'POB202605240001', 'READY_TO_CONVERT', 'DELIVERY', `inbound_warehouse_id`, `inbound_warehouse_name`, `customer_name`, `container_no`, `shipment_codes`, `declared_carton_qty`, `declared_pallet_qty`, `declared_weight`, `declared_cbm`, `actual_carton_qty`, `actual_pallet_qty`, `actual_weight`, `actual_cbm`, `earliest_dw_time`, `delivery_lfd`, NOW(), 'mock pre outbound', NOW(), 0
FROM `oms_cargo_order`
WHERE `id` = 1003
ON DUPLICATE KEY UPDATE `pre_outbound_status` = VALUES(`pre_outbound_status`), `ready_time` = VALUES(`ready_time`), `update_time` = NOW();

UPDATE `oms_cargo_order`
SET `fulfillment_status` = 'OUTBOUND_ORDERED',
    `company_id` = 4000001,
    `inbound_warehouse_id` = 4001001,
    `inbound_warehouse_name` = 'Los Angeles Central Warehouse',
    `pre_outbound_status` = 'CONVERTED',
    `outbound_order_status` = 'CREATED',
    `outbound_batch_no` = 'OB202605240001',
    `outbound_order_time` = NOW(),
    `hold_flag` = 0,
    `hold_status` = 'NORMAL',
    `update_time` = NOW()
WHERE `id` = 1004;

INSERT INTO `oms_outbound_order` (`id`, `tenant_id`, `biz_root_id`, `cargo_order_id`, `cargo_order_no`, `pre_outbound_id`, `pre_outbound_no`, `outbound_order_no`, `outbound_status`, `outbound_direction`, `outbound_warehouse_id`, `outbound_warehouse_name`, `customer_name`, `container_no`, `shipment_codes`, `actual_carton_qty`, `actual_pallet_qty`, `actual_weight`, `actual_cbm`, `appointment_status`, `pod_status`, `remark`, `create_time`, `deleted`)
SELECT 6000003001, `tenant_id`, `biz_root_id`, `id`, `cargo_order_no`, NULL, `pre_outbound_no`, 'OB202605240001', 'CREATED', 'DELIVERY', `inbound_warehouse_id`, `inbound_warehouse_name`, `customer_name`, `container_no`, `shipment_codes`, `actual_carton_qty`, `actual_pallet_qty`, `actual_weight`, `actual_cbm`, 'NONE', 'PENDING', 'mock outbound order', NOW(), 0
FROM `oms_cargo_order`
WHERE `id` = 1004
ON DUPLICATE KEY UPDATE `outbound_status` = VALUES(`outbound_status`), `update_time` = NOW();

UPDATE `sys_menu` SET `menu_name` = _utf8mb4 0xE587BAE58D95E5B7A5E4BD9CE58FB0 WHERE `menu_id` = 3010;
UPDATE `sys_menu` SET `menu_name` = _utf8mb4 0xE9A284E587BAE58D95E7AEA1E79086 WHERE `menu_id` = 3011;
UPDATE `sys_menu` SET `menu_name` = _utf8mb4 0xE587BAE5BA93E8AEA2E58D95 WHERE `menu_id` = 3012;
UPDATE `sys_menu`
SET `menu_type` = 'C',
    `component` = CASE `menu_id`
      WHEN 3010 THEN 'oms/outbound-pool/index'
      WHEN 3011 THEN 'oms/pre-outbound/index'
      WHEN 3012 THEN 'oms/outbound-order/index'
      ELSE `component`
    END,
    `path` = CASE `menu_id`
      WHEN 3010 THEN 'outbound-pool'
      WHEN 3011 THEN 'pre-outbound'
      WHEN 3012 THEN 'outbound-order'
      ELSE `path`
    END,
    `visible` = '0',
    `status` = '0'
WHERE `menu_id` IN (3010, 3011, 3012);
UPDATE `sys_menu` SET `menu_name` = _utf8mb4 0xE5889BE5BBBAE9A284E587BAE58D95 WHERE `menu_id` = 301010;
UPDATE `sys_menu` SET `menu_name` = _utf8mb4 0xE5889BE5BBBAE587BAE5BA93E8AEA2E58D95 WHERE `menu_id` = 301011;
UPDATE `sys_menu` SET `menu_name` = _utf8mb4 0xE689B9E9878FE5889BE5BBBAE9A284E587BAE58D95 WHERE `menu_id` = 301012;
UPDATE `sys_menu` SET `menu_name` = _utf8mb4 0xE689B9E9878FE5889BE5BBBAE587BAE5BA93E8AEA2E58D95 WHERE `menu_id` = 301013;
UPDATE `sys_menu` SET `menu_name` = _utf8mb4 0xE9A284E587BAE58D95E69FA5E8AFA2 WHERE `menu_id` = 301110;
UPDATE `sys_menu` SET `menu_name` = _utf8mb4 0xE9A284E587BAE58D95E58F96E6B688 WHERE `menu_id` = 301111;
UPDATE `sys_menu` SET `menu_name` = _utf8mb4 0xE9A284E587BAE58D95E8BDACE587BAE5BA93 WHERE `menu_id` = 301112;
UPDATE `sys_menu` SET `menu_name` = _utf8mb4 0xE9A284E587BAE58D95E5AFBCE587BA WHERE `menu_id` = 301113;
UPDATE `sys_menu` SET `menu_name` = _utf8mb4 0xE587BAE5BA93E8AEA2E58D95E69FA5E8AFA2 WHERE `menu_id` = 301210;
UPDATE `sys_menu` SET `menu_name` = _utf8mb4 0xE587BAE5BA93E8AEA2E58D95E7BC96E8BE91 WHERE `menu_id` = 301211;
UPDATE `sys_menu` SET `menu_name` = _utf8mb4 0xE587BAE5BA93E8AEA2E58D95E58F96E6B688 WHERE `menu_id` = 301212;
UPDATE `sys_menu` SET `menu_name` = _utf8mb4 0xE587BAE5BA93E8AEA2E58D95E5AE8CE68890 WHERE `menu_id` = 301213;
UPDATE `sys_menu` SET `menu_name` = _utf8mb4 0xE587BAE5BA93E8AEA2E58D95E5AFBCE587BA WHERE `menu_id` = 301214;

UPDATE `sys_dict_type` SET `dict_name` = _utf8mb4 0xE587BAE58D95E696B9E59091 WHERE `dict_type` = 'oms_outbound_direction';
UPDATE `sys_dict_type` SET `dict_name` = _utf8mb4 0xE587BAE58D95E58786E5A487E78AB6E68081 WHERE `dict_type` = 'oms_outbound_readiness';
UPDATE `sys_dict_type` SET `dict_name` = _utf8mb4 0xE9A284E587BAE58D95E78AB6E68081 WHERE `dict_type` = 'oms_pre_outbound_status';
UPDATE `sys_dict_type` SET `dict_name` = _utf8mb4 0xE587BAE5BA93E8AEA2E58D95E78AB6E68081 WHERE `dict_type` = 'oms_outbound_status';
UPDATE `sys_dict_data` SET `dict_label` = _utf8mb4 0xE6B4BEE98081 WHERE `dict_type` = 'oms_outbound_direction' AND `dict_value` = 'DELIVERY';
UPDATE `sys_dict_data` SET `dict_label` = _utf8mb4 0xE8B083E68BA8 WHERE `dict_type` = 'oms_outbound_direction' AND `dict_value` = 'TRANSFER';
UPDATE `sys_dict_data` SET `dict_label` = _utf8mb4 0xE69CAAE585A5E5BA93 WHERE `dict_type` = 'oms_outbound_readiness' AND `dict_value` = 'NOT_INBOUNDED';
UPDATE `sys_dict_data` SET `dict_label` = _utf8mb4 0xE68B86E69F9CE4B8AD WHERE `dict_type` = 'oms_outbound_readiness' AND `dict_value` = 'DEVANNING';
UPDATE `sys_dict_data` SET `dict_label` = _utf8mb4 0xE5B7B2E585A5E5BA93 WHERE `dict_type` = 'oms_outbound_readiness' AND `dict_value` = 'INBOUNDED';
UPDATE `sys_dict_data` SET `dict_label` = _utf8mb4 0xE5BE85E585A5E5BA93 WHERE `dict_type` = 'oms_pre_outbound_status' AND `dict_value` = 'PENDING_INBOUND';
UPDATE `sys_dict_data` SET `dict_label` = _utf8mb4 0xE68B86E69F9CE4B8AD WHERE `dict_type` = 'oms_pre_outbound_status' AND `dict_value` = 'DEVANNING';
UPDATE `sys_dict_data` SET `dict_label` = _utf8mb4 0xE58FAFE8BDACE587BAE5BA93 WHERE `dict_type` = 'oms_pre_outbound_status' AND `dict_value` = 'READY_TO_CONVERT';
UPDATE `sys_dict_data` SET `dict_label` = _utf8mb4 0xE5B7B2E8BDACE587BAE5BA93 WHERE `dict_type` = 'oms_pre_outbound_status' AND `dict_value` = 'CONVERTED';
UPDATE `sys_dict_data` SET `dict_label` = _utf8mb4 0xE5B7B2E58F96E6B688 WHERE `dict_type` = 'oms_pre_outbound_status' AND `dict_value` = 'CANCELLED';
UPDATE `sys_dict_data` SET `dict_label` = _utf8mb4 0xE5B7B2E5889BE5BBBA WHERE `dict_type` = 'oms_outbound_status' AND `dict_value` = 'CREATED';
UPDATE `sys_dict_data` SET `dict_label` = _utf8mb4 0xE5B7B2E6B4BEE58F91 WHERE `dict_type` = 'oms_outbound_status' AND `dict_value` = 'DISPATCHED';
UPDATE `sys_dict_data` SET `dict_label` = _utf8mb4 0xE5B7B2E587BAE5BA93 WHERE `dict_type` = 'oms_outbound_status' AND `dict_value` = 'OUTBOUNDED';
UPDATE `sys_dict_data` SET `dict_label` = _utf8mb4 0xE6B4BEE98081E4B8AD WHERE `dict_type` = 'oms_outbound_status' AND `dict_value` = 'DELIVERING';
UPDATE `sys_dict_data` SET `dict_label` = _utf8mb4 0xE5B7B2E7ADBEE694B6 WHERE `dict_type` = 'oms_outbound_status' AND `dict_value` = 'DELIVERED';
UPDATE `sys_dict_data` SET `dict_label` = _utf8mb4 0xE5B7B2E5AE8CE68890 WHERE `dict_type` = 'oms_outbound_status' AND `dict_value` = 'COMPLETED';
UPDATE `sys_dict_data` SET `dict_label` = _utf8mb4 0xE5B7B2E58F96E6B688 WHERE `dict_type` = 'oms_outbound_status' AND `dict_value` = 'CANCELLED';

INSERT IGNORE INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT r.`role_id`, m.`menu_id`
FROM `sys_role` r
JOIN `sys_menu` m ON m.`menu_id` IN (
  3000, 3010, 3011, 3012,
  301010, 301011, 301012, 301013,
  301110, 301111, 301112, 301113,
  301210, 301211, 301212, 301213, 301214
)
WHERE r.`role_id` IN (1, 3, 4);
