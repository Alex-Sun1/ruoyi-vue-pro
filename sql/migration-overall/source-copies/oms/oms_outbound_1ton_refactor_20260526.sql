-- ==================================================
-- OMS 出库链路 1:N 重构
-- 日期：2026-05-26
-- 背景：出库单与货物订单由 1:1 改为 1:N
--       多个货物订单可合并进一个预出单/出库单
-- 影响表：
--   新增 oms_outbound_order_item（出库单明细）
--   变更 oms_outbound_order（cargo_order_id 改可空，增加 cargo_order_count）
--   变更 oms_pre_outbound（cargo_order_id 改可空，增加 cargo_order_count）
-- ==================================================

-- ----------------------------
-- 1. 新增 oms_outbound_order_item（出库单明细，货物订单维度）
-- ----------------------------
CREATE TABLE IF NOT EXISTS `oms_outbound_order_item` (
  `id`                   bigint        NOT NULL                   COMMENT 'ID（雪花算法）',
  `tenant_id`            varchar(20)   NOT NULL DEFAULT '000000'  COMMENT '租户ID',
  `outbound_order_id`    bigint        NOT NULL                   COMMENT '出库单ID',
  `outbound_order_no`    varchar(64)   NOT NULL                   COMMENT '出库单号',
  `cargo_order_id`       bigint        NOT NULL                   COMMENT '货物订单ID',
  `cargo_order_no`       varchar(64)   NOT NULL                   COMMENT '货物订单号',
  `pre_outbound_item_id` bigint        DEFAULT NULL               COMMENT '来源预出单明细ID（从预出单转换时填充）',
  `actual_carton_qty`    decimal(10,2) DEFAULT NULL               COMMENT '实际箱数',
  `actual_pallet_qty`    decimal(10,2) DEFAULT NULL               COMMENT '实际板数',
  `actual_weight`        decimal(12,3) DEFAULT NULL               COMMENT '实际重量(kg)',
  `actual_cbm`           decimal(12,3) DEFAULT NULL               COMMENT '实际体积(m³)',
  `create_dept`          bigint        DEFAULT NULL               COMMENT '创建部门',
  `create_by`            bigint        DEFAULT NULL               COMMENT '创建人',
  `create_time`          datetime      DEFAULT NULL               COMMENT '创建时间',
  `update_by`            bigint        DEFAULT NULL               COMMENT '更新人',
  `update_time`          datetime      DEFAULT NULL               COMMENT '更新时间',
  `deleted`              tinyint(1)    NOT NULL DEFAULT 0         COMMENT '逻辑删除（0正常1删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_outbound_cargo_tenant` (`outbound_order_id`, `cargo_order_id`, `tenant_id`),
  KEY `idx_outbound_order_id` (`outbound_order_id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`),
  KEY `idx_pre_outbound_item_id` (`pre_outbound_item_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='OMS出库单明细（货物订单维度）';

-- ----------------------------
-- 2. oms_outbound_order 主表变更
--    2.1 cargo_order_id 改为可空（关系移至明细表，保留兼容）
--    2.2 cargo_order_no 改为可空
--    2.3 新增 cargo_order_count（关联货物订单数，服务层维护）
-- ----------------------------

SET @sql := IF(
  (SELECT IS_NULLABLE FROM information_schema.COLUMNS
   WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_outbound_order' AND COLUMN_NAME = 'cargo_order_id') = 'NO',
  'ALTER TABLE `oms_outbound_order` MODIFY COLUMN `cargo_order_id` bigint DEFAULT NULL COMMENT ''货物订单ID（兼容字段，1:N后由明细表管理）''',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT IS_NULLABLE FROM information_schema.COLUMNS
   WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_outbound_order' AND COLUMN_NAME = 'cargo_order_no') = 'NO',
  'ALTER TABLE `oms_outbound_order` MODIFY COLUMN `cargo_order_no` varchar(64) DEFAULT NULL COMMENT ''货物订单号（兼容字段，1:N后由明细表管理）''',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS
   WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_outbound_order' AND COLUMN_NAME = 'cargo_order_count') = 0,
  'ALTER TABLE `oms_outbound_order` ADD COLUMN `cargo_order_count` int NOT NULL DEFAULT 0 COMMENT ''关联货物订单数'' AFTER `pre_outbound_no`',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ----------------------------
-- 3. oms_pre_outbound 主表变更
--    3.1 cargo_order_id 改为可空（关系由 oms_pre_outbound_item 管理）
--    3.2 cargo_order_no 改为可空
--    3.3 新增 cargo_order_count
-- ----------------------------

SET @sql := IF(
  (SELECT IS_NULLABLE FROM information_schema.COLUMNS
   WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_pre_outbound' AND COLUMN_NAME = 'cargo_order_id') = 'NO',
  'ALTER TABLE `oms_pre_outbound` MODIFY COLUMN `cargo_order_id` bigint DEFAULT NULL COMMENT ''货物订单ID（兼容字段，1:N后由明细表管理）''',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT IS_NULLABLE FROM information_schema.COLUMNS
   WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_pre_outbound' AND COLUMN_NAME = 'cargo_order_no') = 'NO',
  'ALTER TABLE `oms_pre_outbound` MODIFY COLUMN `cargo_order_no` varchar(64) DEFAULT NULL COMMENT ''货物订单号（兼容字段，1:N后由明细表管理）''',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS
   WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_pre_outbound' AND COLUMN_NAME = 'cargo_order_count') = 0,
  'ALTER TABLE `oms_pre_outbound` ADD COLUMN `cargo_order_count` int NOT NULL DEFAULT 0 COMMENT ''关联货物订单数'' AFTER `cargo_order_no`',
  'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ----------------------------
-- 4. 存量数据迁移
--    将已有 oms_outbound_order 中的 cargo_order_id 回填到 oms_outbound_order_item
--    注意：id 使用 id + 8000000000 作为迁移偏移，生产环境执行后应由服务层雪花ID接管
-- ----------------------------
INSERT INTO `oms_outbound_order_item` (
  `id`, `tenant_id`,
  `outbound_order_id`, `outbound_order_no`,
  `cargo_order_id`, `cargo_order_no`,
  `actual_carton_qty`, `actual_pallet_qty`, `actual_weight`, `actual_cbm`,
  `create_by`, `create_time`, `deleted`
)
SELECT
  o.`id` + 8000000000,
  o.`tenant_id`,
  o.`id`,
  o.`outbound_order_no`,
  o.`cargo_order_id`,
  o.`cargo_order_no`,
  o.`actual_carton_qty`,
  o.`actual_pallet_qty`,
  o.`actual_weight`,
  o.`actual_cbm`,
  o.`create_by`,
  NOW(),
  0
FROM `oms_outbound_order` o
WHERE o.`deleted` = 0
  AND o.`cargo_order_id` IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM `oms_outbound_order_item` i
    WHERE i.`outbound_order_id` = o.`id`
      AND i.`cargo_order_id` = o.`cargo_order_id`
      AND i.`deleted` = 0
  );

-- ----------------------------
-- 5. 回填计数字段（关闭安全更新模式，避免 Error 1175）
-- ----------------------------
SET SQL_SAFE_UPDATES = 0;

-- 5.1 回填 oms_outbound_order.cargo_order_count
UPDATE `oms_outbound_order` o
SET `cargo_order_count` = (
  SELECT COUNT(*) FROM `oms_outbound_order_item` i
  WHERE i.`outbound_order_id` = o.`id` AND i.`deleted` = 0
)
WHERE o.`id` > 0 AND o.`deleted` = 0;

-- 5.2 回填 oms_pre_outbound.cargo_order_count
UPDATE `oms_pre_outbound` p
SET `cargo_order_count` = (
  SELECT COUNT(*) FROM `oms_pre_outbound_item` i
  WHERE i.`pre_outbound_id` = p.`id` AND i.`deleted` = 0
)
WHERE p.`id` > 0 AND p.`deleted` = 0;

SET SQL_SAFE_UPDATES = 1;

-- ----------------------------
-- 6. 权限菜单整合
--    "单个创建"和"批量创建"合并为同一入口，保留批量权限标识（向下兼容）
--    删除已无实际对应逻辑的"单条创建预出单/出库单"独立权限按钮
-- ----------------------------
UPDATE `sys_menu`
SET `menu_name`  = '创建预出单',
    `order_num`  = 1,
    `update_time` = NOW()
WHERE `menu_id` = 301012
  AND `perms`   = 'oms:outboundPool:batchCreatePreOutbound';

UPDATE `sys_menu`
SET `menu_name`  = '创建出库单',
    `order_num`  = 2,
    `update_time` = NOW()
WHERE `menu_id` = 301013
  AND `perms`   = 'oms:outboundPool:batchCreateOutboundOrder';

-- 将旧的单条权限按钮下线（visible=1 隐藏，不删除保留数据）
UPDATE `sys_menu`
SET `visible`    = '1',
    `update_time` = NOW()
WHERE `menu_id` IN (301010, 301011);
