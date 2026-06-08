-- 分组规则种子数据（字段元数据 + 规则，来源 overallSystem/docs/prd/all.sql）
-- 前置：base-mock-data.sql（仓库 9001/9002）、oms-dict-yudao.sql（地址类型/快递商字典）
-- 可重复执行
SET NAMES utf8mb4;

SET @tenant_id = 1;
SET @creator = 'admin';
SET @now = NOW();
SET @wh_la = 9001;
SET @wh_nj = 9002;

-- =============================================================================
-- 0. 表结构兼容（旧版 oms-init 含 warehouse_id NOT NULL，新版用 warehouse_ids）
-- =============================================================================
SET @schema_name := DATABASE();

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_cargo_grouping_rule' AND COLUMN_NAME = 'warehouse_ids') = 0,
  'ALTER TABLE `oms_cargo_grouping_rule` ADD COLUMN `warehouse_ids` json NULL COMMENT ''仓库ID列表JSON'' AFTER `warehouse_name`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_cargo_grouping_rule' AND COLUMN_NAME = 'warehouse_id') > 0,
  'ALTER TABLE `oms_cargo_grouping_rule` MODIFY COLUMN `warehouse_id` bigint NULL DEFAULT NULL COMMENT ''仓库ID(legacy)''',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- =============================================================================
-- 0b. 建表（表不存在时，按新结构创建）
-- =============================================================================
CREATE TABLE IF NOT EXISTS `oms_cargo_grouping_field_meta` (
  `id` bigint NOT NULL COMMENT '主键',
  `table_alias` varchar(32) NOT NULL COMMENT 'order/shipment',
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
  `id` bigint NOT NULL COMMENT '主键',
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

-- =============================================================================
-- 1. 分组字段元数据（14 条）
-- =============================================================================
INSERT INTO `oms_cargo_grouping_field_meta` (
    `id`, `table_alias`, `field_name`, `display_name`, `data_type`, `enum_code`, `ref_type`,
    `can_be_condition`, `can_be_group_key`, `sort_order`, `enabled`, `remark`,
    `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`
) VALUES
(9301001, 'order', 'order_no', '订单号', 'STRING', NULL, NULL, 0, 1, 10, 1, '货物订单号', @creator, @now, @creator, @now, b'0', @tenant_id),
(9301002, 'order', 'order_type', '业务类型/派送方式', 'ENUM', 'base_business_type', NULL, 1, 1, 20, 1, '货物订单业务类型/派送方式', @creator, @now, @creator, @now, b'0', @tenant_id),
(9301003, 'order', 'address_type', '地址类型', 'ENUM', 'oms_address_type', NULL, 1, 1, 30, 1, '平台仓、私仓、商业地址', @creator, @now, @creator, @now, b'0', @tenant_id),
(9301010, 'order', 'platform_id', '平台', 'REF', NULL, 'base_platform', 1, 1, 40, 1, '目的地平台基础资料', @creator, @now, @creator, @now, b'0', @tenant_id),
(9301004, 'order', 'platform_code', '仓库代码', 'REF', NULL, 'base_platform_address', 1, 1, 45, 1, '目的地平台仓代码', @creator, @now, @creator, @now, b'0', @tenant_id),
(9301011, 'order', 'parcel_carrier_name', '快递商', 'ENUM', 'oms_parcel_carrier', NULL, 1, 1, 47, 1, '快递派送承运商字典', @creator, @now, @creator, @now, b'0', @tenant_id),
(9301005, 'order', 'customer_id', '客户', 'REF', NULL, 'base_customer', 1, 0, 50, 1, '客户ID', @creator, @now, @creator, @now, b'0', @tenant_id),
(9301006, 'order', 'channel_id', '渠道', 'REF', NULL, 'base_channel', 1, 0, 60, 1, '业务渠道', @creator, @now, @creator, @now, b'0', @tenant_id),
(9301007, 'shipment', 'shipment_no', '货件编号', 'STRING', NULL, NULL, 0, 1, 70, 1, '货件编号', @creator, @now, @creator, @now, b'0', @tenant_id),
(9301008, 'shipment', 'warehouse_code', '货件仓库代码', 'STRING', NULL, NULL, 0, 1, 80, 1, '货件分组仓库代码，当前从订单仓库代码兜底', @creator, @now, @creator, @now, b'0', @tenant_id),
(9301009, 'shipment', 'shipment_type', '货件类型', 'ENUM', 'oms_shipment_type', NULL, 0, 1, 90, 1, '预留货件类型', @creator, @now, @creator, @now, b'0', @tenant_id),
(9301012, 'order', 'hold_flag', 'HOLD标记', 'ENUM', 'yes_no_int', NULL, 1, 1, 90, 1, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9301013, 'order', 'transfer_flag', '是否转仓', 'ENUM', 'yes_no_int', NULL, 1, 0, 91, 1, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9301014, 'order', 'transfer_warehouse_code', '转仓地址', 'STRING', NULL, NULL, 0, 1, 92, 1, NULL, @creator, @now, @creator, @now, b'0', @tenant_id)
ON DUPLICATE KEY UPDATE
    `display_name` = VALUES(`display_name`),
    `data_type` = VALUES(`data_type`),
    `enum_code` = VALUES(`enum_code`),
    `ref_type` = VALUES(`ref_type`),
    `can_be_condition` = VALUES(`can_be_condition`),
    `can_be_group_key` = VALUES(`can_be_group_key`),
    `sort_order` = VALUES(`sort_order`),
    `enabled` = VALUES(`enabled`),
    `remark` = VALUES(`remark`),
    `updater` = VALUES(`updater`),
    `update_time` = VALUES(`update_time`),
    `deleted` = b'0';

-- yes_no_int 字典
INSERT INTO `system_dict_type` (`id`, `name`, `type`, `status`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
SELECT 7229, '是否(整型)', 'yes_no_int', 0, '0=否 1=是', @creator, @now, @creator, @now, b'0'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `system_dict_type` WHERE `type` = 'yes_no_int' AND `deleted` = b'0');

INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
SELECT 721261, 1, '否', '0', 'yes_no_int', 0, 'default', @creator, @now, @creator, @now, b'0'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `system_dict_data` WHERE `dict_type` = 'yes_no_int' AND `value` = '0' AND `deleted` = b'0');

INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
SELECT 721262, 2, '是', '1', 'yes_no_int', 0, 'success', @creator, @now, @creator, @now, b'0'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `system_dict_data` WHERE `dict_type` = 'yes_no_int' AND `value` = '1' AND `deleted` = b'0');

-- =============================================================================
-- 2. 分组规则（洛杉矶 9001 × 8 条 + 新泽西 9002 × 8 条）
-- =============================================================================
INSERT INTO `oms_cargo_grouping_rule` (
    `id`, `warehouse_id`, `warehouse_name`, `warehouse_ids`, `rule_name`,
    `condition_config`, `group_key_config`,
    `priority`, `is_default`, `status`, `version`, `remark`,
    `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`
) VALUES
(9303001, @wh_la, '洛杉矶一号仓', '["9001"]', 'LA-平台仓分组',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[{"op":"EQ","field":"order.order_type","value":"卡车派送"},{"op":"EQ","field":"order.address_type","value":"PLATFORM_WH"}]}',
 '{"fields":[{"field":"order.platform_id"},{"field":"order.platform_code"}],"separator":"-"}',
 10, 0, 'enabled', 1, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9303002, @wh_la, '洛杉矶一号仓', '["9001"]', 'LA仓-商业地址',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[{"op":"EQ","field":"order.order_type","value":"卡车派送"},{"op":"EQ","field":"order.address_type","value":"COMMERCIAL"}]}',
 '{"fields":[{"field":"order.address_type"},{"field":"order.order_no"}],"separator":"-"}',
 9, 0, 'enabled', 0, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9303003, @wh_la, '洛杉矶一号仓', '["9001"]', 'LA仓-私人地址',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[{"op":"EQ","field":"order.order_type","value":"卡车派送"},{"op":"EQ","field":"order.address_type","value":"PRIVATE"}]}',
 '{"fields":[{"field":"order.address_type"},{"field":"order.order_no"}],"separator":"-"}',
 9, 0, 'enabled', 0, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9303004, @wh_la, '洛杉矶一号仓', '["9001"]', 'LA仓-快递派送',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[{"op":"EQ","field":"order.order_type","value":"快递派送"}]}',
 '{"fields":[{"field":"order.parcel_carrier_name"}],"separator":"-"}',
 8, 0, 'enabled', 0, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9303005, @wh_la, '洛杉矶一号仓', '["9001"]', 'LA仓-客户自提',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[{"op":"EQ","field":"order.order_type","value":"客户自提"}]}',
 '{"fields":[{"field":"order.order_type"},{"field":"order.order_no"}],"separator":"-"}',
 7, 0, 'enabled', 0, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9303006, @wh_la, '洛杉矶一号仓', '["9001"]', 'LA-大货中转',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[{"op":"EQ","field":"order.order_type","value":"大货中转"}]}',
 '{"fields":[{"field":"order.order_type"},{"field":"order.order_no"}],"separator":"-"}',
 6, 0, 'enabled', 1, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9303007, @wh_la, '洛杉矶一号仓', '["9001"]', 'LA-一件代发',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[{"op":"EQ","field":"order.order_type","value":"一件代发"}]}',
 '{"fields":[{"field":"order.order_type"},{"field":"shipment.shipment_no"}],"separator":"-"}',
 6, 0, 'enabled', 1, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9303008, @wh_la, '洛杉矶一号仓', '["9001"]', 'LA仓-默认规则',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[]}',
 '{"fields":[{"field":"order.customer_id"},{"field":"order.order_type"}],"separator":"-"}',
 0, 1, 'enabled', 0, '兜底规则', @creator, @now, @creator, @now, b'0', @tenant_id),
(9303101, @wh_nj, '新泽西一号仓', '["9002"]', 'NJ-平台仓分组',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[{"op":"EQ","field":"order.order_type","value":"卡车派送"},{"op":"EQ","field":"order.address_type","value":"PLATFORM_WH"}]}',
 '{"fields":[{"field":"order.platform_id"},{"field":"order.platform_code"}],"separator":"-"}',
 10, 0, 'enabled', 1, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9303102, @wh_nj, '新泽西一号仓', '["9002"]', 'NJ仓-商业地址',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[{"op":"EQ","field":"order.order_type","value":"卡车派送"},{"op":"EQ","field":"order.address_type","value":"COMMERCIAL"}]}',
 '{"fields":[{"field":"order.address_type"},{"field":"order.order_no"}],"separator":"-"}',
 9, 0, 'enabled', 0, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9303103, @wh_nj, '新泽西一号仓', '["9002"]', 'NJ仓-私人地址',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[{"op":"EQ","field":"order.order_type","value":"卡车派送"},{"op":"EQ","field":"order.address_type","value":"PRIVATE"}]}',
 '{"fields":[{"field":"order.address_type"},{"field":"order.order_no"}],"separator":"-"}',
 9, 0, 'enabled', 0, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9303104, @wh_nj, '新泽西一号仓', '["9002"]', 'NJ仓-快递派送',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[{"op":"EQ","field":"order.order_type","value":"快递派送"}]}',
 '{"fields":[{"field":"order.parcel_carrier_name"}],"separator":"-"}',
 8, 0, 'enabled', 0, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9303105, @wh_nj, '新泽西一号仓', '["9002"]', 'NJ仓-客户自提',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[{"op":"EQ","field":"order.order_type","value":"客户自提"}]}',
 '{"fields":[{"field":"order.order_type"},{"field":"order.order_no"}],"separator":"-"}',
 7, 0, 'enabled', 0, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9303106, @wh_nj, '新泽西一号仓', '["9002"]', 'NJ-大货中转',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[{"op":"EQ","field":"order.order_type","value":"大货中转"}]}',
 '{"fields":[{"field":"order.order_type"},{"field":"order.order_no"}],"separator":"-"}',
 6, 0, 'enabled', 1, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9303107, @wh_nj, '新泽西一号仓', '["9002"]', 'NJ-一件代发',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[{"op":"EQ","field":"order.order_type","value":"一件代发"}]}',
 '{"fields":[{"field":"order.order_type"},{"field":"shipment.shipment_no"}],"separator":"-"}',
 6, 0, 'enabled', 1, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9303108, @wh_nj, '新泽西一号仓', '["9002"]', 'NJ仓-默认规则',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[]}',
 '{"fields":[{"field":"order.customer_id"},{"field":"order.order_type"}],"separator":"-"}',
 0, 1, 'enabled', 0, '兜底规则', @creator, @now, @creator, @now, b'0', @tenant_id)
ON DUPLICATE KEY UPDATE
    `warehouse_id` = VALUES(`warehouse_id`),
    `warehouse_name` = VALUES(`warehouse_name`),
    `warehouse_ids` = VALUES(`warehouse_ids`),
    `rule_name` = VALUES(`rule_name`),
    `condition_config` = VALUES(`condition_config`),
    `group_key_config` = VALUES(`group_key_config`),
    `priority` = VALUES(`priority`),
    `is_default` = VALUES(`is_default`),
    `status` = VALUES(`status`),
    `remark` = VALUES(`remark`),
    `updater` = VALUES(`updater`),
    `update_time` = VALUES(`update_time`),
    `deleted` = b'0';

-- =============================================================================
-- 3. 验证
-- =============================================================================
SELECT COUNT(*) AS field_meta_cnt FROM oms_cargo_grouping_field_meta WHERE tenant_id = 1 AND deleted = b'0';
SELECT COUNT(*) AS rule_cnt FROM oms_cargo_grouping_rule WHERE tenant_id = 1 AND deleted = b'0';
SELECT id, warehouse_name, rule_name, priority, status FROM oms_cargo_grouping_rule WHERE tenant_id = 1 AND deleted = b'0' ORDER BY warehouse_name, priority DESC;
