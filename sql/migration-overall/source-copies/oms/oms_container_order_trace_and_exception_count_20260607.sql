-- =====================================================================
-- 修复：创建 oms_container_order_trace 表 + 补充 downstream_exception_count 列
-- 原因：
--   1. oms_container_order_trace 从未被任何活跃 migration 创建，导致
--      ContainerOrderServiceImpl.saveTrace() 在 updateStatus PICKED_UP 时 INSERT 失败报系统异常
--   2. 03-oms-patch.sql 只添加了 downstream_exception_flag，漏掉了 downstream_exception_count，
--      导致 markContainerDownstreamException / clearContainerDownstreamException 也抛异常
--   3. id 列需要 AUTO_INCREMENT：全局 id-type: NONE 对 MySQL 自动适配为 AUTO，依赖 DB 自增
-- =====================================================================

-- 1a. 表已存在时：补 AUTO_INCREMENT（表存在但 id 无自增）
SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS
   WHERE TABLE_SCHEMA = DATABASE()
     AND TABLE_NAME = 'oms_container_order_trace'
     AND COLUMN_NAME = 'id'
     AND EXTRA LIKE '%auto_increment%') = 0
  AND
  (SELECT COUNT(*) FROM information_schema.TABLES
   WHERE TABLE_SCHEMA = DATABASE()
     AND TABLE_NAME = 'oms_container_order_trace') = 1,
  'ALTER TABLE `oms_container_order_trace` MODIFY COLUMN `id` bigint NOT NULL AUTO_INCREMENT COMMENT ''主键ID''',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 1b. 海柜订单轨迹表（使用 yudao BaseDO 规范字段：creator/updater/deleted/tenant_id bigint）
CREATE TABLE IF NOT EXISTS `oms_container_order_trace` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  `container_order_id` bigint NOT NULL COMMENT '海柜订单ID',
  `container_order_no` varchar(64) NOT NULL COMMENT '海柜订单号',
  `container_no` varchar(32) DEFAULT NULL COMMENT '柜号',
  `status_from` varchar(30) DEFAULT NULL COMMENT '变更前状态',
  `status_to` varchar(30) NOT NULL COMMENT '变更后状态',
  `action` varchar(64) NOT NULL COMMENT '动作编码',
  `action_desc` varchar(200) DEFAULT NULL COMMENT '动作说明',
  `operator_id` bigint DEFAULT NULL COMMENT '操作人ID',
  `operator_name` varchar(64) DEFAULT NULL COMMENT '操作人名称',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`),
  KEY `idx_container_order_id` (`container_order_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='OMS海柜订单状态变更轨迹';

-- 2. 补充 downstream_exception_count 列（03-oms-patch.sql 遗漏）
SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS
   WHERE TABLE_SCHEMA = DATABASE()
     AND TABLE_NAME = 'oms_container_order'
     AND COLUMN_NAME = 'downstream_exception_count') = 0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `downstream_exception_count` int NOT NULL DEFAULT 0 COMMENT ''下游推送异常次数'' AFTER `downstream_exception_flag`',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
