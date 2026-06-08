-- OMS 模块表结构（P0：CORE + 海柜/委托单/事件/预警/费用）
-- 依赖：base-tables.sql（mdm_company、mdm_warehouse、mdm_client）、org-permission-tables.sql
SET NAMES utf8mb4;

-- ========== CORE ==========
DROP TABLE IF EXISTS `biz_timeline`;
DROP TABLE IF EXISTS `biz_event`;
DROP TABLE IF EXISTS `biz_relation`;
DROP TABLE IF EXISTS `cargo_order_item`;
DROP TABLE IF EXISTS `shipment`;
DROP TABLE IF EXISTS `cargo_order`;
DROP TABLE IF EXISTS `biz_root`;

CREATE TABLE `biz_root` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `root_no` varchar(32) NOT NULL COMMENT '业务主线号 BR-YYYYMMDD-XXXXXX',
  `biz_type` varchar(32) NOT NULL DEFAULT 'CARGO_ORDER' COMMENT '业务类型',
  `status` varchar(32) NOT NULL DEFAULT 'ACTIVE' COMMENT '状态',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_root_no` (`tenant_id`, `root_no`),
  KEY `idx_biz_type` (`biz_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='业务主线';

CREATE TABLE `cargo_order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `order_no` varchar(32) NOT NULL COMMENT '委托单号 CO-YYYYMMDD-XXXXXX',
  `biz_root_id` bigint NOT NULL COMMENT '业务主线',
  `warehouse_id` bigint NOT NULL COMMENT '目的仓',
  `customer_id` bigint NOT NULL COMMENT '直客 mdm_client.id',
  `fulfillment_status` varchar(32) NOT NULL DEFAULT 'PENDING_UNSTUFF' COMMENT '履约状态',
  `calc_risk_level` varchar(16) DEFAULT NULL COMMENT '风险等级',
  `remark` varchar(512) DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_order_no` (`tenant_id`, `order_no`),
  KEY `idx_biz_root_id` (`biz_root_id`),
  KEY `idx_warehouse_id` (`warehouse_id`),
  KEY `idx_customer_id` (`customer_id`),
  KEY `idx_fulfillment_status` (`fulfillment_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='委托单';

CREATE TABLE `shipment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `cargo_order_id` bigint NOT NULL COMMENT '委托单',
  `shipment_no` varchar(64) DEFAULT NULL COMMENT '运单号',
  `carrier` varchar(64) DEFAULT NULL COMMENT '承运商',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='运单';

CREATE TABLE `cargo_order_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `cargo_order_id` bigint NOT NULL COMMENT '委托单',
  `sku_code` varchar(64) DEFAULT NULL COMMENT 'SKU',
  `qty` int NOT NULL DEFAULT 0 COMMENT '件数',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='委托单明细';

CREATE TABLE `biz_relation` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `relation_type` varchar(32) NOT NULL COMMENT 'LOADED_IN 等',
  `cargo_order_id` bigint NOT NULL COMMENT '委托单',
  `container_order_id` bigint NOT NULL COMMENT '海柜工单',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_relation` (`tenant_id`, `relation_type`, `cargo_order_id`, `container_order_id`),
  KEY `idx_container_order_id` (`container_order_id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='业务关联';

CREATE TABLE `biz_event` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `event_id` varchar(64) NOT NULL COMMENT '幂等事件ID',
  `event_code` varchar(64) NOT NULL COMMENT '事件码',
  `biz_root_id` bigint DEFAULT NULL COMMENT '业务主线',
  `container_order_id` bigint DEFAULT NULL COMMENT '海柜',
  `payload` text COMMENT 'JSON',
  `status` varchar(16) NOT NULL DEFAULT 'SUCCESS' COMMENT 'SUCCESS/FAILED/PENDING',
  `retry_count` int NOT NULL DEFAULT 0 COMMENT '重试次数',
  `error_message` varchar(512) DEFAULT NULL COMMENT '错误信息',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_event_id` (`tenant_id`, `event_id`),
  KEY `idx_biz_root_id` (`biz_root_id`),
  KEY `idx_container_order_id` (`container_order_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='业务事件';

CREATE TABLE `biz_timeline` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `biz_root_id` bigint NOT NULL COMMENT '业务主线',
  `event_code` varchar(64) NOT NULL COMMENT '事件码',
  `event_time` datetime NOT NULL COMMENT '事件时间',
  `title` varchar(128) NOT NULL COMMENT '标题',
  `content` varchar(1024) DEFAULT NULL COMMENT '内容',
  `operator_id` bigint DEFAULT NULL COMMENT '操作人',
  `operator_name` varchar(64) DEFAULT NULL COMMENT '操作人姓名',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  KEY `idx_biz_root_id` (`biz_root_id`),
  KEY `idx_event_time` (`event_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='业务时间轴';

-- ========== OMS 海柜 ==========
DROP TABLE IF EXISTS `oms_container_remark`;
DROP TABLE IF EXISTS `oms_container_fee_snapshot`;
DROP TABLE IF EXISTS `oms_container_wms_snapshot`;
DROP TABLE IF EXISTS `oms_container_transport_info`;
DROP TABLE IF EXISTS `oms_container_terminal_info`;
DROP TABLE IF EXISTS `oms_container_order`;

CREATE TABLE `oms_container_order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `work_order_no` varchar(32) NOT NULL COMMENT '海柜工单 WKSC-YYYYMMDD-XXXXXX',
  `container_no` varchar(32) NOT NULL COMMENT '柜号',
  `bl_no` varchar(64) NOT NULL COMMENT '提单号',
  `customer_id` bigint NOT NULL COMMENT '直客',
  `warehouse_id` bigint NOT NULL COMMENT '目的仓',
  `container_type` varchar(16) DEFAULT NULL COMMENT '柜型',
  `eta` datetime DEFAULT NULL COMMENT 'ETA',
  `pickup_lfd` datetime DEFAULT NULL COMMENT '提柜 LFD',
  `return_lfd` datetime DEFAULT NULL COMMENT '还柜 LFD',
  `container_status` varchar(32) NOT NULL DEFAULT 'SAILING' COMMENT '海柜状态',
  `unstuff_status` varchar(32) NOT NULL DEFAULT 'NOT_CREATED' COMMENT '拆柜状态',
  `calc_risk_level` varchar(16) DEFAULT NULL COMMENT '风险',
  `order_total_count` int NOT NULL DEFAULT 0 COMMENT '柜内订单总数',
  `order_completed_count` int NOT NULL DEFAULT 0 COMMENT '已完成数',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_work_order_no` (`tenant_id`, `work_order_no`),
  KEY `idx_warehouse_id` (`warehouse_id`),
  KEY `idx_customer_id` (`customer_id`),
  KEY `idx_container_status` (`container_status`),
  KEY `idx_eta` (`eta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='海柜工单';

CREATE TABLE `oms_container_terminal_info` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `container_order_id` bigint NOT NULL COMMENT '海柜',
  `terminal_code` varchar(64) DEFAULT NULL COMMENT '码头',
  `port_code` varchar(32) DEFAULT NULL COMMENT '港口',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_container_order_id` (`container_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='海柜码头信息';

CREATE TABLE `oms_container_transport_info` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `container_order_id` bigint NOT NULL COMMENT '海柜',
  `vessel_name` varchar(128) DEFAULT NULL COMMENT '船名',
  `voyage_no` varchar(64) DEFAULT NULL COMMENT '航次',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_container_order_id` (`container_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='海柜运输信息';

CREATE TABLE `oms_container_wms_snapshot` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `container_order_id` bigint NOT NULL COMMENT '海柜',
  `snapshot_json` text COMMENT 'WMS快照JSON',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_container_order_id` (`container_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='海柜WMS快照';

CREATE TABLE `oms_container_fee_snapshot` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `container_order_id` bigint NOT NULL COMMENT '海柜',
  `fee_status` varchar(32) NOT NULL DEFAULT 'NOT_GENERATED' COMMENT '费用状态',
  `snapshot_json` text COMMENT '费用快照JSON',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_container_order_id` (`container_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='海柜费用快照';

CREATE TABLE `oms_container_remark` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `container_order_id` bigint NOT NULL COMMENT '海柜',
  `content` varchar(1024) NOT NULL COMMENT '备注内容',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  KEY `idx_container_order_id` (`container_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='海柜备注';

-- ========== 路由模板（不按仓过滤）==========
DROP TABLE IF EXISTS `oms_route_node`;
DROP TABLE IF EXISTS `oms_route_template`;
CREATE TABLE `oms_route_template` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `template_code` varchar(64) NOT NULL COMMENT '模板编码',
  `template_name` varchar(128) NOT NULL COMMENT '模板名称',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_code` (`tenant_id`, `template_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='路由模板';

CREATE TABLE `oms_route_node` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `cargo_order_id` bigint NOT NULL COMMENT '委托单',
  `node_code` varchar(64) NOT NULL COMMENT '节点编码',
  `node_name` varchar(128) NOT NULL COMMENT '节点名称',
  `node_time` datetime DEFAULT NULL COMMENT '节点时间',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='委托单路由节点';

-- ========== 预警 ==========
DROP TABLE IF EXISTS `oms_alert_instance`;
DROP TABLE IF EXISTS `oms_alert_rule`;
CREATE TABLE `oms_alert_rule` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `rule_code` varchar(64) NOT NULL COMMENT '规则码',
  `rule_name` varchar(128) NOT NULL COMMENT '规则名称',
  `enabled` bit(1) NOT NULL DEFAULT b'1' COMMENT '启用',
  `config_json` text COMMENT '配置',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_rule_code` (`tenant_id`, `rule_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='预警规则';

CREATE TABLE `oms_alert_instance` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `rule_code` varchar(64) NOT NULL COMMENT '规则码',
  `object_type` varchar(32) NOT NULL COMMENT '对象类型',
  `object_id` bigint NOT NULL COMMENT '对象ID',
  `warehouse_id` bigint NOT NULL COMMENT '仓库（冗余便于过滤）',
  `severity` varchar(16) NOT NULL DEFAULT 'WARN' COMMENT '严重程度',
  `status` varchar(16) NOT NULL DEFAULT 'OPEN' COMMENT 'OPEN/RESOLVED/SNOOZED',
  `message` varchar(512) DEFAULT NULL COMMENT '消息',
  `snooze_until` datetime DEFAULT NULL COMMENT '暂缓至',
  `resolved_time` datetime DEFAULT NULL COMMENT '解决时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  KEY `idx_warehouse_id` (`warehouse_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='预警实例';

-- ========== 费用 ==========
DROP TABLE IF EXISTS `oms_freeze_request`;
DROP TABLE IF EXISTS `oms_fee`;
CREATE TABLE `oms_fee` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `container_order_id` bigint NOT NULL COMMENT '海柜',
  `warehouse_id` bigint NOT NULL COMMENT '仓库（冗余）',
  `fee_type` varchar(64) NOT NULL COMMENT '费项',
  `amount` decimal(18,2) NOT NULL DEFAULT 0.00 COMMENT '金额',
  `currency` varchar(8) NOT NULL DEFAULT 'USD' COMMENT '币种',
  `fee_status` varchar(32) NOT NULL DEFAULT 'NOT_GENERATED' COMMENT '费用状态',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  KEY `idx_container_order_id` (`container_order_id`),
  KEY `idx_warehouse_id` (`warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='费用明细';

CREATE TABLE `oms_freeze_request` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `container_order_id` bigint NOT NULL COMMENT '海柜',
  `warehouse_id` bigint NOT NULL COMMENT '仓库',
  `reason` varchar(512) NOT NULL COMMENT '原因',
  `status` varchar(16) NOT NULL DEFAULT 'PENDING' COMMENT '状态',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  KEY `idx_container_order_id` (`container_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='费用冻结申请';
