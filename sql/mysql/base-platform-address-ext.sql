-- 平台地址扩展字段 + 变更记录表（已有库增量执行）

SET NAMES utf8mb4;

-- 扩展字段（按实际 MySQL 版本执行；8.0.29+ 可用 IF NOT EXISTS）
ALTER TABLE `base_platform_address`
  ADD COLUMN `wh_property` varchar(50) DEFAULT NULL COMMENT '仓库属性' AFTER `last_verified_at`,
  ADD COLUMN `pallet_cbm` decimal(10,2) DEFAULT NULL COMMENT '单托 CBM' AFTER `wh_property`,
  ADD COLUMN `is_weigh_station` tinyint NOT NULL DEFAULT 0 COMMENT '是否过磅站' AFTER `pallet_cbm`,
  ADD COLUMN `max_weight_ton` decimal(10,3) DEFAULT NULL COMMENT '最高重量(吨)' AFTER `is_weigh_station`;

-- 变更记录表
CREATE TABLE IF NOT EXISTS `base_platform_address_change_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `platform_address_id` bigint NOT NULL COMMENT '平台地址 ID',
  `change_type` varchar(32) NOT NULL COMMENT '变更类型',
  `before_value` text COMMENT '变更前',
  `after_value` text COMMENT '变更后',
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
