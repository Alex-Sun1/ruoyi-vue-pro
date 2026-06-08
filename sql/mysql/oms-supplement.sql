-- OMS 补充脚本：入库计划表 + 菜单权限对齐参考系统
-- 在 oms-init-from-reference.sql 之后执行
SET NAMES utf8mb4;

-- ========== 1. 入库计划表（OMS InboundPlan 依赖） ==========
CREATE TABLE IF NOT EXISTS `wms_inbound_plan` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `warehouse_id` bigint NOT NULL COMMENT '仓库ID',
  `container_order_id` bigint NOT NULL COMMENT '海柜工单ID',
  `container_order_no` varchar(64) DEFAULT NULL COMMENT '海柜工单号冗余',
  `plan_no` varchar(64) NOT NULL COMMENT '计划编号',
  `status` varchar(20) NOT NULL DEFAULT 'draft' COMMENT 'draft/in_progress/completed/cancelled',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_plan_no` (`tenant_id`, `plan_no`),
  KEY `idx_container_order_id` (`container_order_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='入库计划';

CREATE TABLE IF NOT EXISTS `wms_inbound_plan_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `plan_id` bigint NOT NULL COMMENT '计划ID',
  `cargo_order_id` bigint NOT NULL COMMENT '委托单ID',
  `shipment_id` bigint NOT NULL COMMENT '货件ID',
  `group_code` varchar(100) DEFAULT NULL COMMENT '分组',
  `pre_location` varchar(100) DEFAULT NULL COMMENT '预库位',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  KEY `idx_plan_id` (`plan_id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`),
  KEY `idx_shipment_id` (`shipment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='入库计划明细';

CREATE TABLE IF NOT EXISTS `wms_inbound_plan_change_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `plan_id` bigint NOT NULL COMMENT '计划ID',
  `plan_item_id` bigint NOT NULL COMMENT '明细ID',
  `shipment_id` bigint NOT NULL COMMENT '货件ID',
  `old_group_code` varchar(100) DEFAULT NULL COMMENT '变更前',
  `new_group_code` varchar(100) DEFAULT NULL COMMENT '变更后',
  `change_type` varchar(30) NOT NULL COMMENT 'auto_group/quick_config/manual',
  `change_by` bigint DEFAULT NULL COMMENT '操作人',
  `change_time` datetime DEFAULT NULL COMMENT '操作时间',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  KEY `idx_plan_id` (`plan_id`),
  KEY `idx_plan_item_id` (`plan_item_id`),
  KEY `idx_shipment_id` (`shipment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='入库计划变更日志';

-- ========== 2. 页面菜单权限对齐参考 ruoyi-oms ==========
UPDATE `system_menu`
SET `name` = '货物订单',
    `permission` = 'oms:cargoOrder:list',
    `path` = 'cargo-order',
    `component` = 'oms/cargo-order/index',
    `component_name` = 'OmsCargoOrder',
    `updater` = 'admin',
    `update_time` = NOW()
WHERE `id` = 6902;

-- 海柜订单按钮（与参考系统 container-order 一致）
UPDATE `system_menu` SET `permission` = 'oms:containerOrder:query', `name` = '海柜订单查询', `parent_id` = 6901, `updater` = 'admin', `update_time` = NOW() WHERE `id` = 6914;
DELETE FROM `system_menu` WHERE `id` IN (6911, 6912, 6913, 6915, 6916);

INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`,
                           `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`,
                           `create_time`, `updater`, `update_time`, `deleted`)
VALUES
    (6917, '海柜订单查询', 'oms:containerOrder:query', 3, 7, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6918, '海柜订单新增', 'oms:containerOrder:add', 3, 8, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6919, '海柜订单删除', 'oms:containerOrder:remove', 3, 9, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6920, '海柜订单导出', 'oms:containerOrder:export', 3, 10, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6925, '海柜订单改状态', 'oms:containerOrder:updateStatus', 3, 11, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6926, '导入柜内订单', 'oms:containerOrder:importCargo', 3, 12, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6927, '上传附件', 'oms:containerOrder:attachmentUpload', 3, 13, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6928, '上传DO', 'oms:containerOrder:uploadDo', 3, 14, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6929, '删除附件', 'oms:containerOrder:attachmentRemove', 3, 15, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE
    `permission` = VALUES(`permission`), `name` = VALUES(`name`), `updater` = 'admin', `update_time` = NOW(), `deleted` = b'0';

-- 货物订单按钮（oms:cargoOrder:*）
DELETE FROM `system_menu` WHERE `id` IN (6921, 6922, 6923, 6924);

INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`,
                           `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`,
                           `create_time`, `updater`, `update_time`, `deleted`)
VALUES
    (7020, '货物订单查询', 'oms:cargoOrder:query', 3, 1, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7021, '货物订单新增', 'oms:cargoOrder:add', 3, 2, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7022, '货物订单编辑', 'oms:cargoOrder:edit', 3, 3, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7023, '货物订单删除', 'oms:cargoOrder:remove', 3, 4, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7024, '货物订单导出', 'oms:cargoOrder:export', 3, 5, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7025, '受理订单', 'oms:cargoOrder:accept', 3, 10, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7026, '标记在途', 'oms:cargoOrder:markInTransit', 3, 11, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7027, '确认到港', 'oms:cargoOrder:confirmArrivedPort', 3, 12, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7028, '确认提柜', 'oms:cargoOrder:confirmPickedUp', 3, 13, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7029, '确认到仓', 'oms:cargoOrder:confirmArrivedWarehouse', 3, 14, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7030, '开始拆柜', 'oms:cargoOrder:startDevanning', 3, 15, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7031, '拆柜完成', 'oms:cargoOrder:finishDevanning', 3, 16, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7032, '确认入库', 'oms:cargoOrder:confirmInbounded', 3, 17, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7033, '正式出单', 'oms:cargoOrder:createOutboundOrder', 3, 18, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7034, '预约派送', 'oms:cargoOrder:appointDelivery', 3, 19, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7035, '确认出库', 'oms:cargoOrder:confirmOutbounded', 3, 20, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7036, '标记派送中', 'oms:cargoOrder:markDelivering', 3, 21, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7037, '确认签收', 'oms:cargoOrder:confirmDelivered', 3, 22, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7038, '上传POD', 'oms:cargoOrder:uploadPod', 3, 23, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7039, '出账单', 'oms:cargoOrder:confirmBilled', 3, 24, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7040, '完结订单', 'oms:cargoOrder:complete', 3, 25, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7041, '取消订单', 'oms:cargoOrder:cancel', 3, 26, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7042, '创建预出单', 'oms:cargoOrder:createPreOutbound', 3, 30, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7043, '转正式出单', 'oms:cargoOrder:convertPreOutbound', 3, 31, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7044, '取消预出单', 'oms:cargoOrder:cancelPreOutbound', 3, 32, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7045, '修改入库仓', 'oms:cargoOrder:changeInboundWarehouse', 3, 40, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7046, '上传货物附件', 'oms:cargoOrder:attachmentUpload', 3, 41, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7047, '删除货物附件', 'oms:cargoOrder:attachmentRemove', 3, 42, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7048, '货物暂扣', 'oms:cargoOrder:hold', 3, 43, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7049, '货物放行', 'oms:cargoOrder:releaseHold', 3, 44, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7050, '货物拆单', 'oms:cargoOrder:split', 3, 45, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7051, '回并原单', 'oms:cargoOrder:mergeBack', 3, 46, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7052, '取消转仓', 'oms:cargoOrder:cancelTransfer', 3, 47, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7053, '修改转仓', 'oms:cargoOrder:modifyTransfer', 3, 48, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE
    `permission` = VALUES(`permission`), `name` = VALUES(`name`), `parent_id` = VALUES(`parent_id`),
    `updater` = 'admin', `update_time` = NOW(), `deleted` = b'0';

-- 分组规则字段元数据按钮
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`,
                           `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`,
                           `create_time`, `updater`, `update_time`, `deleted`)
VALUES
    (7060, '字段元数据查询', 'oms:cargoGroupingFieldMeta:query', 3, 1, 6954, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7061, '字段元数据新增', 'oms:cargoGroupingFieldMeta:add', 3, 2, 6954, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7062, '字段元数据编辑', 'oms:cargoGroupingFieldMeta:edit', 3, 3, 6954, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE
    `permission` = VALUES(`permission`), `name` = VALUES(`name`), `updater` = 'admin', `update_time` = NOW(), `deleted` = b'0';

-- 出库单额外按钮
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`,
                           `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`,
                           `create_time`, `updater`, `update_time`, `deleted`)
VALUES
    (7070, '确认预约', 'oms:outboundOrder:confirmAppointment', 3, 4, 6953, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7071, '确认签收', 'oms:outboundOrder:confirmSigned', 3, 5, 6953, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7072, '确认出库', 'oms:outboundOrder:confirmOutbounded', 3, 6, 6953, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7073, '出库单删除', 'oms:outboundOrder:remove', 3, 7, 6953, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7074, '出库单导出', 'oms:outboundOrder:export', 3, 8, 6953, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7075, '上传出库附件', 'oms:outboundOrder:attachmentUpload', 3, 9, 6953, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7076, '删除出库附件', 'oms:outboundOrder:attachmentRemove', 3, 10, 6953, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7077, '规则优先级', 'oms:cargoGroupingRule:priority', 3, 7, 6954, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7078, '规则禁用', 'oms:cargoGroupingRule:disable', 3, 8, 6954, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7079, '规则复制', 'oms:cargoGroupingRule:copy', 3, 9, 6954, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7080, '预出单删除', 'oms:preOutbound:remove', 3, 4, 6951, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7081, '预出单导出', 'oms:preOutbound:export', 3, 5, 6951, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE
    `permission` = VALUES(`permission`), `name` = VALUES(`name`), `parent_id` = VALUES(`parent_id`),
    `updater` = 'admin', `update_time` = NOW(), `deleted` = b'0';

-- ========== 3. 分组字段元数据表补齐芋道 BaseDO 列（creator/updater/deleted）==========
-- 旧库由 oms-init-from-reference 建表时无 deleted，CargoGroupingFieldMetaDO 继承 TenantBaseDO 会报错

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_cargo_grouping_field_meta' AND COLUMN_NAME = 'creator') = 0
    AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_cargo_grouping_field_meta' AND COLUMN_NAME = 'create_by') > 0,
  'ALTER TABLE `oms_cargo_grouping_field_meta` ADD COLUMN `creator` varchar(64) DEFAULT '''' COMMENT ''创建者'' AFTER `update_time`, ADD COLUMN `updater` varchar(64) DEFAULT '''' COMMENT ''更新者'' AFTER `creator`',
  'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

UPDATE `oms_cargo_grouping_field_meta`
SET `creator` = CAST(`create_by` AS CHAR)
WHERE `create_by` IS NOT NULL AND (`creator` IS NULL OR `creator` = '');

UPDATE `oms_cargo_grouping_field_meta`
SET `updater` = CAST(`update_by` AS CHAR)
WHERE `update_by` IS NOT NULL AND (`updater` IS NULL OR `updater` = '');

SET @sql := IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_cargo_grouping_field_meta' AND COLUMN_NAME = 'deleted') = 0
    AND (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_cargo_grouping_field_meta' AND COLUMN_NAME = 'updater') > 0,
  'ALTER TABLE `oms_cargo_grouping_field_meta` ADD COLUMN `deleted` bit(1) NOT NULL DEFAULT b''0'' COMMENT ''是否删除'' AFTER `updater`',
  IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_cargo_grouping_field_meta' AND COLUMN_NAME = 'deleted') = 0,
    'ALTER TABLE `oms_cargo_grouping_field_meta` ADD COLUMN `deleted` bit(1) NOT NULL DEFAULT b''0'' COMMENT ''是否删除'' AFTER `update_time`',
    'SELECT 1'
  )
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
