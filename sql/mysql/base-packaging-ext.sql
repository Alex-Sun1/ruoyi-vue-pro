-- 包装规格库扩展（已有库增量执行）
SET NAMES utf8mb4;

ALTER TABLE `mdm_packaging`
  ADD COLUMN `pkg_type` tinyint NOT NULL DEFAULT 1 COMMENT '类型' AFTER `pkg_name`,
  ADD COLUMN `source_type` tinyint NOT NULL DEFAULT 1 COMMENT '来源' AFTER `pkg_type`,
  ADD COLUMN `client_id` bigint DEFAULT NULL COMMENT '关联客户' AFTER `source_type`,
  ADD COLUMN `warehouse_ids` varchar(512) DEFAULT NULL COMMENT '适用仓库JSON' AFTER `client_id`,
  ADD COLUMN `pkg_length` decimal(10,2) DEFAULT NULL COMMENT '长' AFTER `warehouse_ids`,
  ADD COLUMN `pkg_width` decimal(10,2) DEFAULT NULL COMMENT '宽' AFTER `pkg_length`,
  ADD COLUMN `pkg_height` decimal(10,2) DEFAULT NULL COMMENT '高' AFTER `pkg_width`,
  ADD COLUMN `dimension_unit` varchar(8) NOT NULL DEFAULT 'CM' COMMENT '尺寸单位' AFTER `pkg_height`,
  ADD COLUMN `tare_weight` decimal(10,3) DEFAULT NULL COMMENT '皮重' AFTER `dimension_unit`,
  ADD COLUMN `weight_unit` varchar(8) NOT NULL DEFAULT 'KG' COMMENT '重量单位' AFTER `tare_weight`,
  ADD COLUMN `max_load_weight` decimal(10,3) DEFAULT NULL COMMENT '最大承重' AFTER `weight_unit`,
  ADD COLUMN `material` varchar(64) DEFAULT NULL COMMENT '材质' AFTER `max_load_weight`,
  ADD COLUMN `material_sku` varchar(64) DEFAULT NULL COMMENT '包材SKU' AFTER `material`,
  ADD COLUMN `unit_cost` decimal(12,4) DEFAULT NULL COMMENT '单位成本' AFTER `material_sku`,
  ADD COLUMN `cost_currency` varchar(3) DEFAULT NULL COMMENT '成本币种' AFTER `unit_cost`,
  ADD COLUMN `is_custom` tinyint NOT NULL DEFAULT 0 COMMENT '是否定制' AFTER `cost_currency`,
  ADD COLUMN `is_default` tinyint NOT NULL DEFAULT 0 COMMENT '是否默认' AFTER `is_custom`,
  ADD COLUMN `scan_required` tinyint NOT NULL DEFAULT 0 COMMENT '是否需扫码' AFTER `is_default`;
