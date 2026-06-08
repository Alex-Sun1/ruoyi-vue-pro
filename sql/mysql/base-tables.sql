-- 基础资料模块表结构
SET NAMES utf8mb4;

-- 国家
DROP TABLE IF EXISTS `base_country`;
CREATE TABLE `base_country` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `code` varchar(2) NOT NULL COMMENT 'code',
  `name_en` varchar(128) NOT NULL COMMENT 'name_en',
  `phone_code` varchar(16) DEFAULT NULL COMMENT 'phone_code',
  `currency_code` varchar(3) DEFAULT NULL COMMENT 'currency_code',
  `timezone_default` varchar(64) DEFAULT NULL COMMENT 'timezone_default',
  `is_active` tinyint NOT NULL DEFAULT 1 COMMENT 'is_active',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT 'sort_order',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_unique` (`tenant_id`, `code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='国家';

-- 州/省
DROP TABLE IF EXISTS `base_state_province`;
CREATE TABLE `base_state_province` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `country_code` varchar(2) NOT NULL COMMENT 'country_code',
  `code` varchar(32) NOT NULL COMMENT 'code',
  `name_en` varchar(128) NOT NULL COMMENT 'name_en',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT 'sort_order',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT 'status',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_unique` (`tenant_id`, `country_code`, `code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='州/省';

-- 城市
DROP TABLE IF EXISTS `base_city`;
CREATE TABLE `base_city` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `country_code` varchar(2) NOT NULL COMMENT 'country_code',
  `state_code` varchar(32) NOT NULL COMMENT 'state_code',
  `name_en` varchar(128) NOT NULL COMMENT 'name_en',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT 'status',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_unique` (`tenant_id`, `country_code`, `state_code`, `name_en`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='城市';

-- 邮编
DROP TABLE IF EXISTS `base_zip_code`;
CREATE TABLE `base_zip_code` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `country_code` varchar(2) NOT NULL COMMENT 'country_code',
  `state_code` varchar(32) DEFAULT NULL COMMENT 'state_code',
  `city_name` varchar(128) NOT NULL COMMENT 'city_name',
  `zip` varchar(32) NOT NULL COMMENT 'zip',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_unique` (`tenant_id`, `country_code`, `zip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='邮编';

-- 时区
DROP TABLE IF EXISTS `base_timezone`;
CREATE TABLE `base_timezone` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `tz_code` varchar(64) NOT NULL COMMENT 'tz_code',
  `name_en` varchar(128) NOT NULL COMMENT 'name_en',
  `utc_offset` varchar(16) NOT NULL COMMENT 'utc_offset',
  `country_code` varchar(2) DEFAULT NULL COMMENT 'country_code',
  `is_dst` tinyint NOT NULL DEFAULT 0 COMMENT 'is_dst',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT 'status',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT 'sort_order',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_unique` (`tenant_id`, `tz_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='时区';

-- 币种
DROP TABLE IF EXISTS `base_currency`;
CREATE TABLE `base_currency` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `code` varchar(3) NOT NULL COMMENT 'code',
  `name_en` varchar(128) NOT NULL COMMENT 'name_en',
  `symbol` varchar(16) NOT NULL COMMENT 'symbol',
  `decimal_places` tinyint NOT NULL DEFAULT 2 COMMENT 'decimal_places',
  `is_base` tinyint NOT NULL DEFAULT 0 COMMENT 'is_base',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT 'status',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT 'sort_order',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_unique` (`tenant_id`, `code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='币种';

-- 汇率
DROP TABLE IF EXISTS `base_exchange_rate`;
CREATE TABLE `base_exchange_rate` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `from_currency` varchar(3) NOT NULL COMMENT 'from_currency',
  `to_currency` varchar(3) NOT NULL COMMENT 'to_currency',
  `rate` decimal(18,6) NOT NULL COMMENT 'rate',
  `effective_date` date NOT NULL COMMENT 'effective_date',
  `expired_date` date DEFAULT NULL COMMENT 'expired_date',
  `is_current` tinyint NOT NULL DEFAULT 1 COMMENT 'is_current',
  `remark` varchar(512) DEFAULT NULL COMMENT 'remark',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_unique` (`tenant_id`, `from_currency`, `to_currency`, `effective_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='汇率';

-- 平台
DROP TABLE IF EXISTS `base_platform`;
CREATE TABLE `base_platform` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `code` varchar(32) NOT NULL COMMENT 'code',
  `name_en` varchar(128) NOT NULL COMMENT 'name_en',
  `type_code` varchar(32) NOT NULL COMMENT 'type_code',
  `logo_oss_id` bigint DEFAULT NULL COMMENT 'logo_oss_id',
  `logo_url` varchar(512) DEFAULT NULL COMMENT 'logo_url',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT 'status',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT 'sort_order',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_unique` (`tenant_id`, `code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='平台';

-- 平台地址
DROP TABLE IF EXISTS `base_platform_address`;
CREATE TABLE `base_platform_address` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `platform_id` bigint NOT NULL COMMENT 'platform_id',
  `address_code` varchar(64) NOT NULL COMMENT 'address_code',
  `address_type` tinyint NOT NULL COMMENT 'address_type',
  `name_en` varchar(128) NOT NULL COMMENT 'name_en',
  `country_code` varchar(2) NOT NULL COMMENT 'country_code',
  `state_code` varchar(32) DEFAULT NULL COMMENT 'state_code',
  `city` varchar(128) DEFAULT NULL COMMENT 'city',
  `address_line1` varchar(256) NOT NULL COMMENT 'address_line1',
  `address_line2` varchar(256) DEFAULT NULL COMMENT 'address_line2',
  `zip_code` varchar(32) DEFAULT NULL COMMENT 'zip_code',
  `contact_name` varchar(64) DEFAULT NULL COMMENT 'contact_name',
  `contact_phone` varchar(32) DEFAULT NULL COMMENT 'contact_phone',
  `last_verified_at` datetime DEFAULT NULL COMMENT 'last_verified_at',
  `wh_property` varchar(50) DEFAULT NULL COMMENT '仓库属性，字典 MDM_WH_PROPERTY',
  `pallet_cbm` decimal(10,2) DEFAULT NULL COMMENT '单托 CBM',
  `is_weigh_station` tinyint NOT NULL DEFAULT 0 COMMENT '是否过磅站 0否1是',
  `max_weight_ton` decimal(10,3) DEFAULT NULL COMMENT '最高重量(吨)',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT 'status',
  `remark` varchar(512) DEFAULT NULL COMMENT 'remark',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_unique` (`tenant_id`, `platform_id`, `address_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='平台地址';

-- 平台地址变更记录（只增不改删）
DROP TABLE IF EXISTS `base_platform_address_change_log`;
CREATE TABLE `base_platform_address_change_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `platform_address_id` bigint NOT NULL COMMENT '平台地址 ID',
  `change_type` varchar(32) NOT NULL COMMENT '变更类型：CREATE/UPDATE/STATUS_CHANGE/IMPORT',
  `before_value` text COMMENT '变更前(JSON)',
  `after_value` text COMMENT '变更后(JSON)',
  `change_reason` varchar(512) DEFAULT NULL COMMENT '变更原因',
  `operator_name` varchar(64) DEFAULT NULL COMMENT '操作人昵称',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  KEY `idx_platform_address_id` (`platform_address_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='平台地址变更记录';

-- 港口
DROP TABLE IF EXISTS `base_port`;
CREATE TABLE `base_port` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `port_code` varchar(16) NOT NULL COMMENT 'port_code',
  `name_en` varchar(128) NOT NULL COMMENT 'name_en',
  `country_code` varchar(2) NOT NULL COMMENT 'country_code',
  `state_code` varchar(32) DEFAULT NULL COMMENT 'state_code',
  `city` varchar(128) DEFAULT NULL COMMENT 'city',
  `port_type` tinyint NOT NULL COMMENT 'port_type',
  `timezone` varchar(64) DEFAULT NULL COMMENT 'timezone',
  `container_query_url` varchar(512) DEFAULT NULL COMMENT 'container_query_url',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT 'status',
  `remark` varchar(512) DEFAULT NULL COMMENT 'remark',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_unique` (`tenant_id`, `port_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='港口';

-- 船司
DROP TABLE IF EXISTS `base_shipping_line`;
CREATE TABLE `base_shipping_line` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `code` varchar(16) NOT NULL COMMENT 'code',
  `name_en` varchar(128) NOT NULL COMMENT 'name_en',
  `name_abbr` varchar(32) DEFAULT NULL COMMENT 'name_abbr',
  `country_code` varchar(2) DEFAULT NULL COMMENT 'country_code',
  `contact_email` varchar(128) DEFAULT NULL COMMENT 'contact_email',
  `contact_phone` varchar(32) DEFAULT NULL COMMENT 'contact_phone',
  `website` varchar(256) DEFAULT NULL COMMENT 'website',
  `tracking_url` varchar(512) DEFAULT NULL COMMENT 'tracking_url',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT 'status',
  `remark` varchar(512) DEFAULT NULL COMMENT 'remark',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_unique` (`tenant_id`, `code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='船司';

-- 费项
DROP TABLE IF EXISTS `mdm_fee_item`;
CREATE TABLE `mdm_fee_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `fee_code` varchar(32) NOT NULL COMMENT 'fee_code',
  `fee_name` varchar(128) NOT NULL COMMENT 'fee_name',
  `fee_category` varchar(32) NOT NULL COMMENT 'fee_category',
  `business_stage` varchar(32) NOT NULL COMMENT 'business_stage',
  `business_type` varchar(32) DEFAULT NULL COMMENT 'business_type',
  `is_system` tinyint NOT NULL DEFAULT 0 COMMENT 'is_system',
  `is_billable` tinyint NOT NULL DEFAULT 1 COMMENT 'is_billable',
  `description` varchar(512) DEFAULT NULL COMMENT 'description',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT 'status',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT 'sort_order',
  `remark` varchar(512) DEFAULT NULL COMMENT 'remark',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_unique` (`tenant_id`, `fee_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='费项';

-- 客户（SKU 货主，完整模块上线前供下拉）
DROP TABLE IF EXISTS `mdm_client`;
CREATE TABLE `mdm_client` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `client_code` varchar(32) NOT NULL COMMENT '客户编码',
  `client_name` varchar(128) NOT NULL COMMENT '客户名称',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态',
  `remark` varchar(512) DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_client_code` (`tenant_id`, `client_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='客户';

-- 包装
DROP TABLE IF EXISTS `mdm_packaging`;
CREATE TABLE `mdm_packaging` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `pkg_code` varchar(32) NOT NULL COMMENT '包装编码',
  `pkg_name` varchar(128) NOT NULL COMMENT '包装名称',
  `pkg_type` tinyint NOT NULL COMMENT '类型 1纸箱2气泡袋3塑料袋4木箱5其他',
  `source_type` tinyint NOT NULL DEFAULT 1 COMMENT '来源 1仓库自有2客户提供3供应商采购',
  `client_id` bigint DEFAULT NULL COMMENT '关联客户',
  `warehouse_ids` varchar(512) DEFAULT NULL COMMENT '适用仓库ID JSON数组，空=全部',
  `pkg_length` decimal(10,2) DEFAULT NULL COMMENT '长',
  `pkg_width` decimal(10,2) DEFAULT NULL COMMENT '宽',
  `pkg_height` decimal(10,2) DEFAULT NULL COMMENT '高',
  `dimension_unit` varchar(8) NOT NULL DEFAULT 'CM' COMMENT '尺寸单位 CM/IN',
  `tare_weight` decimal(10,3) DEFAULT NULL COMMENT '皮重',
  `weight_unit` varchar(8) NOT NULL DEFAULT 'KG' COMMENT '重量单位 KG/LB',
  `max_load_weight` decimal(10,3) DEFAULT NULL COMMENT '最大承重',
  `material` varchar(64) DEFAULT NULL COMMENT '材质',
  `material_sku` varchar(64) DEFAULT NULL COMMENT '包材SKU',
  `unit_cost` decimal(12,4) DEFAULT NULL COMMENT '单位成本',
  `cost_currency` varchar(3) DEFAULT NULL COMMENT '成本币种',
  `is_custom` tinyint NOT NULL DEFAULT 0 COMMENT '是否定制',
  `is_default` tinyint NOT NULL DEFAULT 0 COMMENT '是否默认',
  `scan_required` tinyint NOT NULL DEFAULT 0 COMMENT '是否需扫码 0否1是',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序',
  `remark` varchar(512) DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_pkg_code` (`tenant_id`, `pkg_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='包装';

-- SKU
DROP TABLE IF EXISTS `mdm_sku_default_fee`;
DROP TABLE IF EXISTS `mdm_sku_inventory`;
DROP TABLE IF EXISTS `mdm_sku`;
CREATE TABLE `mdm_sku` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `client_id` bigint NOT NULL COMMENT '客户 ID',
  `sku_code` varchar(64) NOT NULL COMMENT 'SKU 编码',
  `sku_name` varchar(256) NOT NULL COMMENT 'SKU 名称',
  `sku_name_en` varchar(256) DEFAULT NULL COMMENT '英文名称',
  `barcode` varchar(64) DEFAULT NULL COMMENT '条码',
  `unit` varchar(16) NOT NULL DEFAULT 'pcs' COMMENT '单位',
  `length_cm` decimal(10,2) DEFAULT NULL COMMENT '长(cm)',
  `width_cm` decimal(10,2) DEFAULT NULL COMMENT '宽(cm)',
  `height_cm` decimal(10,2) DEFAULT NULL COMMENT '高(cm)',
  `weight_kg` decimal(10,3) DEFAULT NULL COMMENT '重量(kg)',
  `volume_cbm` decimal(12,6) DEFAULT NULL COMMENT '体积(CBM)',
  `package_length_cm` decimal(10,2) DEFAULT NULL COMMENT '包装长(cm)',
  `package_width_cm` decimal(10,2) DEFAULT NULL COMMENT '包装宽(cm)',
  `package_height_cm` decimal(10,2) DEFAULT NULL COMMENT '包装高(cm)',
  `package_weight_kg` decimal(10,3) DEFAULT NULL COMMENT '包装重量(kg)',
  `is_fragile` tinyint NOT NULL DEFAULT 0 COMMENT '易碎',
  `is_liquid` tinyint NOT NULL DEFAULT 0 COMMENT '液体',
  `is_battery` tinyint NOT NULL DEFAULT 0 COMMENT '带电',
  `is_magnetic` tinyint NOT NULL DEFAULT 0 COMMENT '带磁',
  `is_dangerous` tinyint NOT NULL DEFAULT 0 COMMENT '危险品',
  `is_oversize` tinyint NOT NULL DEFAULT 0 COMMENT '超大件',
  `default_pkg_id` bigint DEFAULT NULL COMMENT '默认包装 ID',
  `declared_name_cn` varchar(256) DEFAULT NULL COMMENT '申报名称(中)',
  `declared_name_en` varchar(256) DEFAULT NULL COMMENT '申报名称(英)',
  `hs_code` varchar(16) DEFAULT NULL COMMENT 'HS 编码',
  `declared_value` decimal(12,2) DEFAULT NULL COMMENT '申报价值',
  `declared_currency` varchar(3) DEFAULT NULL COMMENT '申报币种',
  `origin_country_code` varchar(2) DEFAULT NULL COMMENT '原产国',
  `image_url` varchar(512) DEFAULT NULL COMMENT '图片 URL',
  `brand` varchar(64) DEFAULT NULL COMMENT '品牌',
  `model` varchar(64) DEFAULT NULL COMMENT '型号',
  `color` varchar(64) DEFAULT NULL COMMENT '颜色',
  `size_spec` varchar(64) DEFAULT NULL COMMENT '尺码规格',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态',
  `remark` varchar(512) DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_client_sku` (`tenant_id`, `client_id`, `sku_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='SKU';

CREATE TABLE `mdm_sku_default_fee` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `sku_id` bigint NOT NULL COMMENT 'SKU ID',
  `fee_code` varchar(32) NOT NULL COMMENT '费项代码',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sku_fee` (`tenant_id`, `sku_id`, `fee_code`),
  KEY `idx_sku_id` (`sku_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='SKU 默认费项';

CREATE TABLE `mdm_sku_inventory` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `sku_id` bigint NOT NULL COMMENT 'SKU ID',
  `qty_on_hand` decimal(18,4) NOT NULL DEFAULT 0.0000 COMMENT '在手数量',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_sku` (`tenant_id`, `sku_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='SKU 库存汇总';

-- 主体
DROP TABLE IF EXISTS `mdm_company`;
CREATE TABLE `mdm_company` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `company_code` varchar(32) NOT NULL COMMENT 'company_code',
  `company_name` varchar(128) NOT NULL COMMENT 'company_name',
  `company_name_en` varchar(128) DEFAULT NULL COMMENT 'company_name_en',
  `tax_no` varchar(64) DEFAULT NULL COMMENT 'tax_no',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT 'status',
  `sort` int NOT NULL DEFAULT 0 COMMENT 'sort',
  `remark` varchar(512) DEFAULT NULL COMMENT 'remark',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_unique` (`tenant_id`, `company_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='主体';

-- 仓库
DROP TABLE IF EXISTS `mdm_warehouse`;
CREATE TABLE `mdm_warehouse` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `warehouse_code` varchar(32) NOT NULL COMMENT 'warehouse_code',
  `warehouse_name` varchar(128) NOT NULL COMMENT 'warehouse_name',
  `company_id` bigint DEFAULT NULL COMMENT 'company_id',
  `timezone_code` varchar(64) NOT NULL COMMENT 'timezone_code',
  `country_code` varchar(2) DEFAULT NULL COMMENT 'country_code',
  `address` varchar(512) DEFAULT NULL COMMENT 'address',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT 'status',
  `sort` int NOT NULL DEFAULT 0 COMMENT 'sort',
  `remark` varchar(512) DEFAULT NULL COMMENT 'remark',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_unique` (`tenant_id`, `warehouse_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='仓库';

-- ========== 多语言（国家 BASE-001 等依赖，勿漏执行）==========
DROP TABLE IF EXISTS `base_entity_translation`;
CREATE TABLE `base_entity_translation` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `entity_type` varchar(32) NOT NULL COMMENT '实体类型，如 country',
  `entity_id` bigint NOT NULL COMMENT '实体主键',
  `field_name` varchar(32) NOT NULL COMMENT '字段名，如 name',
  `lang_code` varchar(16) NOT NULL COMMENT '语言代码，如 zh、en',
  `value` varchar(512) NOT NULL COMMENT '翻译内容',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_translation` (`tenant_id`, `entity_type`, `entity_id`, `field_name`, `lang_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='实体多语言翻译';

DROP TABLE IF EXISTS `base_language`;
CREATE TABLE `base_language` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `lang_code` varchar(16) NOT NULL COMMENT '语言代码',
  `name_en` varchar(128) NOT NULL COMMENT '英文名称',
  `name_native` varchar(128) NOT NULL COMMENT '本地名称',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0=启用 1=停用',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_lang` (`tenant_id`, `lang_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='启用语言';
