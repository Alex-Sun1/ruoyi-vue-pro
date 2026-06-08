-- 基础资料 — 多语言与启用语言（配合国家 BASE-001）
-- 已合并进 base-tables.sql；若只补建这两张表，在 overseas 库执行本文件即可。
SET NAMES utf8mb4;
USE overseas;
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

INSERT INTO `base_language` (`id`, `lang_code`, `name_en`, `name_native`, `status`, `sort_order`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`) VALUES
(1, 'zh', 'Chinese', '中文', 0, 1, 'admin', NOW(), 'admin', NOW(), b'0', 1),
(2, 'en', 'English', 'English', 0, 2, 'admin', NOW(), 'admin', NOW(), b'0', 1),
(3, 'de', 'German', 'Deutsch', 0, 3, 'admin', NOW(), 'admin', NOW(), b'0', 1),
(4, 'ja', 'Japanese', '日本語', 0, 4, 'admin', NOW(), 'admin', NOW(), b'0', 1),
(5, 'vi', 'Vietnamese', 'Tiếng Việt', 0, 5, 'admin', NOW(), 'admin', NOW(), b'0', 1)
ON DUPLICATE KEY UPDATE `name_en` = VALUES(`name_en`);
