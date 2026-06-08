SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS `base_channel` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `channel_code` varchar(32) NOT NULL COMMENT 'channel code',
  `channel_name` varchar(128) NOT NULL COMMENT 'channel name',
  `channel_type` varchar(32) NOT NULL COMMENT 'channel type',
  `container_mode` varchar(32) DEFAULT NULL COMMENT 'container mode',
  `priority` int NOT NULL DEFAULT 0 COMMENT 'priority',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT 'sort order',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0 enable 1 disable',
  `remark` varchar(512) DEFAULT NULL COMMENT 'remark',
  `creator` varchar(64) DEFAULT '' COMMENT 'creator',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'create time',
  `updater` varchar(64) DEFAULT '' COMMENT 'updater',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'update time',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT 'deleted',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT 'tenant id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_base_channel_code` (`tenant_id`, `channel_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='base channel';

CREATE TABLE IF NOT EXISTS `base_business_type` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `business_type_code` varchar(32) NOT NULL COMMENT 'business type code',
  `business_type_name` varchar(128) NOT NULL COMMENT 'business type name',
  `business_category` varchar(32) NOT NULL COMMENT 'business category',
  `operation_flow_type` varchar(32) DEFAULT NULL COMMENT 'operation flow type',
  `receive_required` bit(1) NOT NULL DEFAULT b'0' COMMENT 'receive required',
  `inbound_required` bit(1) NOT NULL DEFAULT b'0' COMMENT 'inbound required',
  `putaway_required` bit(1) NOT NULL DEFAULT b'0' COMMENT 'putaway required',
  `storage_required` bit(1) NOT NULL DEFAULT b'0' COMMENT 'storage required',
  `picking_required` bit(1) NOT NULL DEFAULT b'0' COMMENT 'picking required',
  `outbound_required` bit(1) NOT NULL DEFAULT b'0' COMMENT 'outbound required',
  `delivery_required` bit(1) NOT NULL DEFAULT b'0' COMMENT 'delivery required',
  `appointment_required` bit(1) NOT NULL DEFAULT b'0' COMMENT 'appointment required',
  `vas_supported` bit(1) NOT NULL DEFAULT b'0' COMMENT 'vas supported',
  `billing_mode` varchar(32) DEFAULT NULL COMMENT 'billing mode',
  `sorting_strategy` varchar(32) DEFAULT NULL COMMENT 'sorting strategy',
  `sorting_field` varchar(64) DEFAULT NULL COMMENT 'sorting field',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT 'sort order',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0 enable 1 disable',
  `remark` varchar(512) DEFAULT NULL COMMENT 'remark',
  `creator` varchar(64) DEFAULT '' COMMENT 'creator',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'create time',
  `updater` varchar(64) DEFAULT '' COMMENT 'updater',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'update time',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT 'deleted',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT 'tenant id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_base_business_type_code` (`tenant_id`, `business_type_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='base business type';

CREATE TABLE IF NOT EXISTS `base_value_added_service` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `service_code` varchar(32) NOT NULL COMMENT 'service code',
  `service_name` varchar(128) NOT NULL COMMENT 'service name',
  `service_category` varchar(32) NOT NULL COMMENT 'service category',
  `billing_mode` varchar(32) DEFAULT NULL COMMENT 'billing mode',
  `chargeable_flag` bit(1) NOT NULL DEFAULT b'1' COMMENT 'chargeable',
  `operation_required` bit(1) NOT NULL DEFAULT b'0' COMMENT 'operation required',
  `pda_operation_flag` bit(1) NOT NULL DEFAULT b'0' COMMENT 'pda operation',
  `photo_required` bit(1) NOT NULL DEFAULT b'0' COMMENT 'photo required',
  `qc_required` bit(1) NOT NULL DEFAULT b'0' COMMENT 'qc required',
  `support_batch_operation` bit(1) NOT NULL DEFAULT b'0' COMMENT 'support batch operation',
  `default_selected` bit(1) NOT NULL DEFAULT b'0' COMMENT 'default selected',
  `priority` int NOT NULL DEFAULT 0 COMMENT 'priority',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT 'sort order',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0 enable 1 disable',
  `remark` varchar(512) DEFAULT NULL COMMENT 'remark',
  `creator` varchar(64) DEFAULT '' COMMENT 'creator',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'create time',
  `updater` varchar(64) DEFAULT '' COMMENT 'updater',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'update time',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT 'deleted',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT 'tenant id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_base_vas_code` (`tenant_id`, `service_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='base value added service';

INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
VALUES
(6810, '渠道管理', 'base:channel:list', 2, 1, 6740, 'channel', 'ep:connection', 'base/channel/index', 'BaseChannel', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6811, '业务类型', 'base:business-type:list', 2, 2, 6780, 'business-type', 'ep:operation', 'base/business-type/index', 'BaseBusinessType', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6812, '增值服务', 'base:vas:list', 2, 3, 6780, 'vas', 'ep:plus', 'base/value-added-service/index', 'BaseValueAddedService', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `permission` = VALUES(`permission`), `component` = VALUES(`component`);

INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
VALUES
(6813, '渠道查询', 'base:channel:list', 3, 1, 6810, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6814, '渠道新增', 'base:channel:add', 3, 2, 6810, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6815, '渠道编辑', 'base:channel:edit', 3, 3, 6810, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6816, '渠道删除', 'base:channel:remove', 3, 4, 6810, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6817, '渠道导出', 'base:channel:export', 3, 5, 6810, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6818, '业务类型查询', 'base:business-type:list', 3, 1, 6811, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6819, '业务类型新增', 'base:business-type:add', 3, 2, 6811, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6820, '业务类型编辑', 'base:business-type:edit', 3, 3, 6811, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6821, '业务类型删除', 'base:business-type:remove', 3, 4, 6811, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6822, '业务类型导出', 'base:business-type:export', 3, 5, 6811, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6823, '增值服务查询', 'base:vas:list', 3, 1, 6812, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6824, '增值服务新增', 'base:vas:add', 3, 2, 6812, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6825, '增值服务编辑', 'base:vas:edit', 3, 3, 6812, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6826, '增值服务删除', 'base:vas:remove', 3, 4, 6812, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6827, '增值服务导出', 'base:vas:export', 3, 5, 6812, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `permission` = VALUES(`permission`);
