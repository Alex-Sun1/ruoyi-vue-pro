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

INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `create_time`, `remark`) VALUES
(6000003001, '000000', 'OMS分组规则状态', 'oms_cargo_grouping_rule_status', NOW(), 'OMS货物订单分组规则状态'),
(6000003002, '000000', 'OMS分组字段数据类型', 'oms_cargo_grouping_field_data_type', NOW(), 'OMS分组字段数据类型'),
(6000003003, '000000', 'OMS分组规则匹配操作符', 'oms_cargo_grouping_condition_op', NOW(), 'OMS分组规则匹配操作符'),
(6000003004, '000000', 'OMS快递商', 'oms_parcel_carrier', NOW(), 'OMS快递派送承运商')
ON DUPLICATE KEY UPDATE `dict_name` = VALUES(`dict_name`), `dict_type` = VALUES(`dict_type`), `update_time` = NOW();

INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `list_class`, `is_default`, `create_time`, `remark`) VALUES
(6000003101, '000000', 1, '启用', 'enabled', 'oms_cargo_grouping_rule_status', 'success', 'Y', NOW(), NULL),
(6000003102, '000000', 2, '停用', 'disabled', 'oms_cargo_grouping_rule_status', 'default', 'N', NOW(), NULL),
(6000003201, '000000', 1, '文本', 'STRING', 'oms_cargo_grouping_field_data_type', 'default', 'N', NOW(), NULL),
(6000003202, '000000', 2, '数字', 'NUMBER', 'oms_cargo_grouping_field_data_type', 'default', 'N', NOW(), NULL),
(6000003203, '000000', 3, '日期', 'DATE', 'oms_cargo_grouping_field_data_type', 'default', 'N', NOW(), NULL),
(6000003204, '000000', 4, '枚举', 'ENUM', 'oms_cargo_grouping_field_data_type', 'info', 'N', NOW(), NULL),
(6000003205, '000000', 5, '基础资料', 'REF', 'oms_cargo_grouping_field_data_type', 'info', 'N', NOW(), NULL),
(6000003301, '000000', 1, '等于', 'EQ', 'oms_cargo_grouping_condition_op', 'default', 'Y', NOW(), NULL),
(6000003302, '000000', 2, '不等于', 'NEQ', 'oms_cargo_grouping_condition_op', 'default', 'N', NOW(), NULL),
(6000003303, '000000', 3, '包含于', 'IN', 'oms_cargo_grouping_condition_op', 'default', 'N', NOW(), NULL),
(6000003304, '000000', 4, '不包含于', 'NOT_IN', 'oms_cargo_grouping_condition_op', 'default', 'N', NOW(), NULL),
(6000003305, '000000', 5, '为空', 'IS_NULL', 'oms_cargo_grouping_condition_op', 'default', 'N', NOW(), NULL),
(6000003306, '000000', 6, '不为空', 'IS_NOT_NULL', 'oms_cargo_grouping_condition_op', 'default', 'N', NOW(), NULL),
(6000003401, '000000', 1, 'UPS', 'UPS', 'oms_parcel_carrier', 'primary', 'Y', NOW(), NULL),
(6000003402, '000000', 2, 'FedEx', 'FedEx', 'oms_parcel_carrier', 'info', 'N', NOW(), NULL),
(6000003403, '000000', 3, 'USPS', 'USPS', 'oms_parcel_carrier', 'success', 'N', NOW(), NULL),
(6000003404, '000000', 4, 'DHL', 'DHL', 'oms_parcel_carrier', 'warning', 'N', NOW(), NULL),
(6000003405, '000000', 5, 'OnTrac', 'OnTrac', 'oms_parcel_carrier', 'default', 'N', NOW(), NULL),
(6000003406, '000000', 6, 'LaserShip', 'LaserShip', 'oms_parcel_carrier', 'default', 'N', NOW(), NULL),
(6000003407, '000000', 7, 'Amazon Shipping', 'Amazon Shipping', 'oms_parcel_carrier', 'default', 'N', NOW(), NULL)
ON DUPLICATE KEY UPDATE `dict_label` = VALUES(`dict_label`), `dict_value` = VALUES(`dict_value`), `dict_type` = VALUES(`dict_type`), `list_class` = VALUES(`list_class`), `update_time` = NOW();

INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query_param`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_time`, `remark`) VALUES
(3060, '分组规则配置', 3000, 8, 'cargo-grouping-rule', 'oms/cargo-grouping-rule/index', NULL, 1, 0, 'C', '0', '0', 'oms:cargoGroupingRule:list', 'tree', NOW(), '货物订单分组规则配置'),
(3061, '分组规则查询', 3060, 1, '', '', NULL, 1, 0, 'F', '0', '0', 'oms:cargoGroupingRule:query', '#', NOW(), ''),
(3062, '分组规则新增', 3060, 2, '', '', NULL, 1, 0, 'F', '0', '0', 'oms:cargoGroupingRule:add', '#', NOW(), ''),
(3063, '分组规则编辑', 3060, 3, '', '', NULL, 1, 0, 'F', '0', '0', 'oms:cargoGroupingRule:edit', '#', NOW(), ''),
(3064, '分组规则删除', 3060, 4, '', '', NULL, 1, 0, 'F', '0', '0', 'oms:cargoGroupingRule:remove', '#', NOW(), ''),
(3065, '分组规则启用', 3060, 5, '', '', NULL, 1, 0, 'F', '0', '0', 'oms:cargoGroupingRule:enable', '#', NOW(), ''),
(3066, '分组规则停用', 3060, 6, '', '', NULL, 1, 0, 'F', '0', '0', 'oms:cargoGroupingRule:disable', '#', NOW(), ''),
(3067, '分组规则复制', 3060, 7, '', '', NULL, 1, 0, 'F', '0', '0', 'oms:cargoGroupingRule:copy', '#', NOW(), ''),
(3068, '分组规则优先级', 3060, 8, '', '', NULL, 1, 0, 'F', '0', '0', 'oms:cargoGroupingRule:priority', '#', NOW(), ''),
(3069, '分组规则试算', 3060, 9, '', '', NULL, 1, 0, 'F', '0', '0', 'oms:cargoGroupingRule:test', '#', NOW(), ''),
(3070, '分组字段查询', 3060, 10, '', '', NULL, 1, 0, 'F', '0', '0', 'oms:cargoGroupingFieldMeta:list', '#', NOW(), ''),
(3071, '分组字段新增', 3060, 11, '', '', NULL, 1, 0, 'F', '0', '0', 'oms:cargoGroupingFieldMeta:add', '#', NOW(), ''),
(3072, '分组字段编辑', 3060, 12, '', '', NULL, 1, 0, 'F', '0', '0', 'oms:cargoGroupingFieldMeta:edit', '#', NOW(), '')
ON DUPLICATE KEY UPDATE
  `menu_name` = VALUES(`menu_name`),
  `parent_id` = VALUES(`parent_id`),
  `order_num` = VALUES(`order_num`),
  `path` = VALUES(`path`),
  `component` = VALUES(`component`),
  `perms` = VALUES(`perms`),
  `icon` = VALUES(`icon`),
  `update_time` = NOW();

INSERT IGNORE INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 1, `menu_id`
FROM `sys_menu`
WHERE `menu_id` BETWEEN 3060 AND 3072;

INSERT IGNORE INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT r.`role_id`, m.`menu_id`
FROM `sys_role` r
JOIN `sys_menu` m ON m.`menu_id` BETWEEN 3060 AND 3072
WHERE r.`role_key` IN ('superadmin', 'admin');
