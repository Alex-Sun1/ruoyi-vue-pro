-- SKU 扩展表结构（已有库增量执行）
SET NAMES utf8mb4;

-- 客户、包装（若不存在）
CREATE TABLE IF NOT EXISTS `mdm_client` (
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

CREATE TABLE IF NOT EXISTS `mdm_packaging` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `pkg_code` varchar(32) NOT NULL COMMENT '包装编码',
  `pkg_name` varchar(128) NOT NULL COMMENT '包装名称',
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

ALTER TABLE `mdm_sku`
  ADD COLUMN `length_cm` decimal(10,2) DEFAULT NULL COMMENT '长(cm)' AFTER `unit`,
  ADD COLUMN `width_cm` decimal(10,2) DEFAULT NULL COMMENT '宽(cm)' AFTER `length_cm`,
  ADD COLUMN `height_cm` decimal(10,2) DEFAULT NULL COMMENT '高(cm)' AFTER `width_cm`,
  ADD COLUMN `weight_kg` decimal(10,3) DEFAULT NULL COMMENT '重量(kg)' AFTER `height_cm`,
  ADD COLUMN `volume_cbm` decimal(12,6) DEFAULT NULL COMMENT '体积(CBM)' AFTER `weight_kg`,
  ADD COLUMN `package_length_cm` decimal(10,2) DEFAULT NULL COMMENT '包装长(cm)' AFTER `volume_cbm`,
  ADD COLUMN `package_width_cm` decimal(10,2) DEFAULT NULL COMMENT '包装宽(cm)' AFTER `package_length_cm`,
  ADD COLUMN `package_height_cm` decimal(10,2) DEFAULT NULL COMMENT '包装高(cm)' AFTER `package_width_cm`,
  ADD COLUMN `package_weight_kg` decimal(10,3) DEFAULT NULL COMMENT '包装重量(kg)' AFTER `package_height_cm`,
  ADD COLUMN `is_fragile` tinyint NOT NULL DEFAULT 0 COMMENT '易碎' AFTER `package_weight_kg`,
  ADD COLUMN `is_liquid` tinyint NOT NULL DEFAULT 0 COMMENT '液体' AFTER `is_fragile`,
  ADD COLUMN `is_battery` tinyint NOT NULL DEFAULT 0 COMMENT '带电' AFTER `is_liquid`,
  ADD COLUMN `is_magnetic` tinyint NOT NULL DEFAULT 0 COMMENT '带磁' AFTER `is_battery`,
  ADD COLUMN `is_dangerous` tinyint NOT NULL DEFAULT 0 COMMENT '危险品' AFTER `is_magnetic`,
  ADD COLUMN `is_oversize` tinyint NOT NULL DEFAULT 0 COMMENT '超大件' AFTER `is_dangerous`,
  ADD COLUMN `default_pkg_id` bigint DEFAULT NULL COMMENT '默认包装 ID' AFTER `is_oversize`,
  ADD COLUMN `declared_name_cn` varchar(256) DEFAULT NULL COMMENT '申报名称(中)' AFTER `default_pkg_id`,
  ADD COLUMN `declared_name_en` varchar(256) DEFAULT NULL COMMENT '申报名称(英)' AFTER `declared_name_cn`,
  ADD COLUMN `hs_code` varchar(16) DEFAULT NULL COMMENT 'HS 编码' AFTER `declared_name_en`,
  ADD COLUMN `declared_value` decimal(12,2) DEFAULT NULL COMMENT '申报价值' AFTER `hs_code`,
  ADD COLUMN `declared_currency` varchar(3) DEFAULT NULL COMMENT '申报币种' AFTER `declared_value`,
  ADD COLUMN `origin_country_code` varchar(2) DEFAULT NULL COMMENT '原产国' AFTER `declared_currency`,
  ADD COLUMN `image_url` varchar(512) DEFAULT NULL COMMENT '图片 URL' AFTER `origin_country_code`,
  ADD COLUMN `brand` varchar(64) DEFAULT NULL COMMENT '品牌' AFTER `image_url`,
  ADD COLUMN `model` varchar(64) DEFAULT NULL COMMENT '型号' AFTER `brand`,
  ADD COLUMN `color` varchar(64) DEFAULT NULL COMMENT '颜色' AFTER `model`,
  ADD COLUMN `size_spec` varchar(64) DEFAULT NULL COMMENT '尺码规格' AFTER `color`;

CREATE TABLE IF NOT EXISTS `mdm_sku_default_fee` (
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

CREATE TABLE IF NOT EXISTS `mdm_sku_inventory` (
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
