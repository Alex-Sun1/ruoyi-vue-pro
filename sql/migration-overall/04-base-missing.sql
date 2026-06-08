-- ============================================================
-- 基础资料缺失表：航线 / 码头 / 船舶 / 堆场分区 / 月台
-- 目标：Yudao ruoyi-vue-pro（creator/updater/deleted/tenant_id bigint）
-- 执行前请确认 ID 不与现有 system_menu 冲突
-- ============================================================
SET NAMES utf8mb4;

-- ── 1. base_shipping_route ──────────────────────────────────
CREATE TABLE IF NOT EXISTS `base_shipping_route` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `route_code` varchar(64) NOT NULL COMMENT '航线代码',
  `route_name` varchar(128) NOT NULL COMMENT '航线名称',
  `route_name_en` varchar(128) DEFAULT NULL COMMENT '英文航线名称',
  `shipping_line_id` bigint DEFAULT NULL COMMENT '船司 ID',
  `shipping_line_code` varchar(64) DEFAULT NULL COMMENT '船司代码',
  `shipping_line_name` varchar(128) DEFAULT NULL COMMENT '船司名称',
  `origin_port_id` bigint DEFAULT NULL COMMENT '起运港 ID',
  `origin_port_code` varchar(64) DEFAULT NULL COMMENT '起运港代码',
  `origin_port_name` varchar(128) DEFAULT NULL COMMENT '起运港名称',
  `destination_port_id` bigint DEFAULT NULL COMMENT '目的港 ID',
  `destination_port_code` varchar(64) DEFAULT NULL COMMENT '目的港代码',
  `destination_port_name` varchar(128) DEFAULT NULL COMMENT '目的港名称',
  `default_transit_days` int DEFAULT NULL COMMENT '默认航程天数',
  `route_type` varchar(32) DEFAULT 'DIRECT' COMMENT 'DIRECT/TRANSSHIP',
  `reference_min_days` int DEFAULT NULL COMMENT '参考最短天数',
  `reference_avg_days` int DEFAULT NULL COMMENT '参考平均天数',
  `reference_max_days` int DEFAULT NULL COMMENT '参考最长天数',
  `reference_freight` decimal(10,2) DEFAULT NULL COMMENT '参考运价',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0 启用 / 1 停用',
  `remark` varchar(512) DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_shipping_route_code` (`tenant_id`, `route_code`),
  KEY `idx_shipping_route_line` (`tenant_id`, `shipping_line_id`),
  KEY `idx_shipping_route_ports` (`origin_port_id`, `destination_port_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='航线';

-- ── 2. base_terminal ────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `base_terminal` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `terminal_code` varchar(64) NOT NULL COMMENT '码头代码',
  `terminal_name` varchar(128) NOT NULL COMMENT '码头名称',
  `terminal_name_en` varchar(128) DEFAULT NULL COMMENT '英文名称',
  `port_id` bigint NOT NULL COMMENT '所属港口 ID',
  `port_code` varchar(64) DEFAULT NULL COMMENT '所属港口代码',
  `port_name` varchar(128) DEFAULT NULL COMMENT '所属港口名称',
  `country_code` varchar(32) DEFAULT NULL COMMENT '国家代码',
  `state_code` varchar(32) DEFAULT NULL COMMENT '州/省代码',
  `city` varchar(128) DEFAULT NULL COMMENT '城市',
  `address` varchar(255) DEFAULT NULL COMMENT '地址',
  `contact_phone` varchar(64) DEFAULT NULL COMMENT '联系电话',
  `contact_email` varchar(128) DEFAULT NULL COMMENT '联系邮箱',
  `website` varchar(255) DEFAULT NULL COMMENT '官网',
  `appointment_supported` tinyint NOT NULL DEFAULT 0 COMMENT '是否支持预约',
  `default_appointment_method` varchar(32) DEFAULT NULL COMMENT '默认预约方式',
  `default_release_method` varchar(32) DEFAULT NULL COMMENT '默认放行方式',
  `timezone` varchar(64) DEFAULT NULL COMMENT '时区',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0 启用 / 1 停用',
  `remark` varchar(512) DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_terminal_code` (`tenant_id`, `terminal_code`),
  KEY `idx_terminal_port` (`tenant_id`, `port_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='码头';

-- ── 3. base_vessel ──────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `base_vessel` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `vessel_code` varchar(64) NOT NULL COMMENT '船舶代码',
  `vessel_name` varchar(128) NOT NULL COMMENT '船舶名称',
  `vessel_name_en` varchar(128) DEFAULT NULL COMMENT '英文船名',
  `imo_no` varchar(64) DEFAULT NULL COMMENT 'IMO 编号',
  `mmsi` varchar(64) DEFAULT NULL COMMENT 'MMSI',
  `call_sign` varchar(64) DEFAULT NULL COMMENT '呼号',
  `shipping_line_id` bigint NOT NULL COMMENT '船司 ID',
  `shipping_line_code` varchar(64) DEFAULT NULL COMMENT '船司代码',
  `shipping_line_name` varchar(128) DEFAULT NULL COMMENT '船司名称',
  `vessel_type` varchar(32) DEFAULT 'CONTAINER' COMMENT '船舶类型',
  `capacity_teu` int DEFAULT NULL COMMENT 'TEU 容量',
  `length_m` decimal(10,2) DEFAULT NULL COMMENT '船长(米)',
  `width_m` decimal(10,2) DEFAULT NULL COMMENT '船宽(米)',
  `build_year` int DEFAULT NULL COMMENT '建造年份',
  `flag_country` varchar(64) DEFAULT NULL COMMENT '船旗国',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0 启用 / 1 停用',
  `remark` varchar(512) DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_vessel_code` (`tenant_id`, `vessel_code`),
  KEY `idx_vessel_line` (`tenant_id`, `shipping_line_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='船舶';

-- ── 4. yard_zone ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `yard_zone` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `warehouse_id` bigint NOT NULL COMMENT '仓库 ID',
  `zone_code` varchar(30) NOT NULL COMMENT '分区编码',
  `zone_name` varchar(100) NOT NULL COMMENT '分区名称',
  `zone_type` varchar(30) NOT NULL DEFAULT 'CONTAINER' COMMENT '分区类型',
  `sort_order` int DEFAULT NULL COMMENT '排序',
  `remark` varchar(512) DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_yard_zone_code` (`tenant_id`, `zone_code`, `deleted`),
  KEY `idx_yard_zone_warehouse` (`warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='堆场分区';

-- ── 5. yard_dock ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `yard_dock` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `dock_code` varchar(64) NOT NULL COMMENT '月台编码',
  `dock_name` varchar(128) NOT NULL COMMENT '月台名称',
  `location_type` varchar(32) NOT NULL DEFAULT 'DOCK' COMMENT '位置类型',
  `warehouse_id` bigint NOT NULL COMMENT '仓库 ID',
  `warehouse_code` varchar(64) DEFAULT NULL COMMENT '仓库代码',
  `warehouse_name` varchar(128) DEFAULT NULL COMMENT '仓库名称',
  `zone_id` bigint DEFAULT NULL COMMENT '堆场分区 ID',
  `zone_code` varchar(30) DEFAULT NULL COMMENT '堆场分区编码',
  `business_type_id` bigint DEFAULT NULL COMMENT '业务类型 ID',
  `business_type_code` varchar(64) DEFAULT NULL COMMENT '业务类型编码',
  `business_type_name` varchar(128) DEFAULT NULL COMMENT '业务类型名称',
  `dock_location` varchar(64) DEFAULT NULL COMMENT '月台位置',
  `grid_row` int DEFAULT NULL COMMENT '行',
  `grid_col` int DEFAULT NULL COMMENT '列',
  `allowed_vehicle_types` varchar(255) DEFAULT NULL COMMENT '允许车型',
  `appointment_supported` tinyint NOT NULL DEFAULT 1 COMMENT '是否支持预约',
  `max_concurrent` int NOT NULL DEFAULT 1 COMMENT '最大并发',
  `dock_status` varchar(32) NOT NULL DEFAULT 'IDLE' COMMENT '月台状态',
  `occupied_object_type` varchar(20) DEFAULT NULL COMMENT '占用对象类型',
  `occupied_object_id` bigint DEFAULT NULL COMMENT '占用对象 ID',
  `occupied_object_no` varchar(64) DEFAULT NULL COMMENT '占用对象编号',
  `occupied_since` datetime DEFAULT NULL COMMENT '占用开始时间',
  `enabled_flag` tinyint NOT NULL DEFAULT 1 COMMENT '启用标志',
  `sort_order` int DEFAULT 0 COMMENT '排序',
  `dispatch_priority` int NOT NULL DEFAULT 1 COMMENT '调度优先级',
  `dock_type` varchar(30) DEFAULT NULL COMMENT 'Dock 类型',
  `enable_queue` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否允许排队',
  `max_queue_count` int DEFAULT NULL COMMENT '最大排队数',
  `remark` varchar(512) DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_yard_dock_code` (`tenant_id`, `dock_code`),
  KEY `idx_yard_dock_warehouse` (`tenant_id`, `warehouse_id`),
  KEY `idx_yard_dock_status` (`dock_status`, `enabled_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='月台与堆位';

-- ── 6. 字典 ─────────────────────────────────────────────────
INSERT INTO `system_dict_type` (`id`, `name`, `type`, `status`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `deleted_time`)
VALUES (9004100, '船舶类型', 'base_vessel_type', 0, 'Vessel type', 'admin', NOW(), 'admin', NOW(), b'0', NULL)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
VALUES
(9004200, 1, '集装箱船', 'CONTAINER', 'base_vessel_type', 0, 'success', '', 'Container vessel', 'admin', NOW(), 'admin', NOW(), b'0'),
(9004201, 2, '散货船', 'BULK', 'base_vessel_type', 0, 'info', '', 'Bulk vessel', 'admin', NOW(), 'admin', NOW(), b'0'),
(9004202, 3, '冷藏船', 'REEFER', 'base_vessel_type', 0, 'warning', '', 'Reefer vessel', 'admin', NOW(), 'admin', NOW(), b'0'),
(9004203, 4, '滚装船', 'RORO', 'base_vessel_type', 0, 'default', '', 'Ro-Ro vessel', 'admin', NOW(), 'admin', NOW(), b'0'),
(9004204, 5, '其他', 'OTHER', 'base_vessel_type', 0, 'default', '', 'Other vessel', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`);

INSERT INTO `system_dict_type` (`id`, `name`, `type`, `status`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `deleted_time`)
VALUES (9005100, '月台位置类型', 'yard_location_type', 0, 'Dock location type', 'admin', NOW(), 'admin', NOW(), b'0', NULL)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
VALUES
(9005200, 1, '道口', 'DOCK', 'yard_location_type', 0, 'info', '', 'Dock', 'admin', NOW(), 'admin', NOW(), b'0'),
(9005201, 2, '停车位', 'PARKING', 'yard_location_type', 0, 'default', '', 'Parking', 'admin', NOW(), 'admin', NOW(), b'0'),
(9005202, 3, '海柜堆位', 'CONTAINER_SLOT', 'yard_location_type', 0, 'primary', '', 'Container slot', 'admin', NOW(), 'admin', NOW(), b'0'),
(9005203, 4, '空柜堆位', 'EMPTY_CONTAINER_SLOT', 'yard_location_type', 0, 'info', '', 'Empty container slot', 'admin', NOW(), 'admin', NOW(), b'0'),
(9005204, 5, '车厢堆位', 'TRAILER_SLOT', 'yard_location_type', 0, 'success', '', 'Trailer slot', 'admin', NOW(), 'admin', NOW(), b'0'),
(9005205, 6, '等待位', 'WAITING_SLOT', 'yard_location_type', 0, 'warning', '', 'Waiting slot', 'admin', NOW(), 'admin', NOW(), b'0'),
(9005206, 7, '禁入位', 'BLOCKED_SLOT', 'yard_location_type', 0, 'danger', '', 'Blocked slot', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`);

INSERT INTO `system_dict_type` (`id`, `name`, `type`, `status`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `deleted_time`)
VALUES (9005101, '月台位置', 'yard_dock_location', 0, 'Dock yard position', 'admin', NOW(), 'admin', NOW(), b'0', NULL)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
VALUES
(9005210, 1, '前院道口', 'FRONT_YARD_DOCK', 'yard_dock_location', 0, 'success', '', 'Front yard dock', 'admin', NOW(), 'admin', NOW(), b'0'),
(9005211, 2, '后院道口', 'BACK_YARD_DOCK', 'yard_dock_location', 0, 'info', '', 'Back yard dock', 'admin', NOW(), 'admin', NOW(), b'0'),
(9005212, 3, '前院停车位', 'FRONT_YARD_PARKING', 'yard_dock_location', 0, 'warning', '', 'Front yard parking', 'admin', NOW(), 'admin', NOW(), b'0'),
(9005213, 4, '后院停车位', 'BACK_YARD_PARKING', 'yard_dock_location', 0, 'default', '', 'Back yard parking', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`);

INSERT INTO `system_dict_type` (`id`, `name`, `type`, `status`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `deleted_time`)
VALUES (9005102, '堆场分区类型', 'yard_zone_type', 0, 'Yard zone type', 'admin', NOW(), 'admin', NOW(), b'0', NULL)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
VALUES
(9005220, 1, '海柜区', 'CONTAINER', 'yard_zone_type', 0, 'primary', '', NULL, 'admin', NOW(), 'admin', NOW(), b'0'),
(9005221, 2, '车厢区', 'TRUCK', 'yard_zone_type', 0, 'success', '', NULL, 'admin', NOW(), 'admin', NOW(), b'0'),
(9005222, 3, '自提区', 'SELF_PICKUP', 'yard_zone_type', 0, 'info', '', NULL, 'admin', NOW(), 'admin', NOW(), b'0'),
(9005223, 4, '停车区', 'PARKING', 'yard_zone_type', 0, 'default', '', NULL, 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`);

-- ── 7. 菜单（parent: 6750 运输资料 / 6850 堆场管理）──────────
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
VALUES
(6830, '航线管理', 'base:data:view', 2, 3, 6750, 'shipping-route', 'ep:guide', 'base/shipping-route/index', 'BaseShippingRoute', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6831, '码头管理', 'base:data:view', 2, 4, 6750, 'terminal', 'ep:map-location', 'base/terminal/index', 'BaseTerminal', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6832, '船舶管理', 'base:data:view', 2, 5, 6750, 'vessel', 'ep:ship', 'base/vessel/index', 'BaseVessel', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6850, '堆场管理', '', 1, 9, 6700, 'yard', 'ep:office-building', NULL, NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6851, '堆场分区', 'yard:zone:list', 2, 1, 6850, 'zone', 'ep:grid', 'yard/zone/index', 'YardZone', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6852, '月台设置', 'yard:dock:list', 2, 2, 6850, 'dock', 'ep:home-filled', 'base/yard-dock/index', 'BaseYardDock', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `component` = VALUES(`component`), `permission` = VALUES(`permission`);

INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
VALUES
(6853, '堆场分区新增', 'yard:zone:add', 3, 1, 6851, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6854, '堆场分区编辑', 'yard:zone:edit', 3, 2, 6851, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6855, '堆场分区删除', 'yard:zone:remove', 3, 3, 6851, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6856, '月台新增', 'yard:dock:add', 3, 1, 6852, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6857, '月台编辑', 'yard:dock:edit', 3, 2, 6852, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6858, '月台删除', 'yard:dock:remove', 3, 3, 6852, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6859, '月台导出', 'yard:dock:export', 3, 4, 6852, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `permission` = VALUES(`permission`);
