-- WMS 系统字典（芋道 / ruoyi-vue-pro 格式）
-- 执行前：SELECT MAX(id) FROM system_dict_type; SELECT MAX(id) FROM system_dict_data;
-- 本脚本 dict_type.id 7200~7211；dict_data.id 72001~72127
-- 若 type 已存在请先删除或调整 ID 段

SET NAMES utf8mb4;

-- ========== 字典类型 ==========
INSERT INTO `system_dict_type` (`id`, `name`, `type`, `status`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `deleted_time`) VALUES
(7200, 'WMS库区类型', 'wms_zone_type', 0, 'WMS库区业务类型', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7201, 'WMS库区状态', 'wms_zone_status', 0, 'WMS库区启停状态', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7202, 'WMS存放方式', 'wms_storage_method', 0, '库区存放方式', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7203, 'WMS库位状态', 'wms_location_status', 0, 'WMS库位状态', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7204, 'WMS库存状态', 'wms_inventory_status', 0, 'WMS货件级库存状态', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7205, 'WMS卡板状态', 'wms_pallet_status', 0, 'WMS卡板状态', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7206, 'WMS锁定状态', 'wms_inventory_lock_status', 0, 'WMS库存锁定状态', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7207, 'WMS库存流水类型', 'wms_inventory_transaction_type', 0, 'WMS库存流水类型', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7208, 'WMS卡板类型', 'wms_pallet_type', 0, '常规/退货', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7209, 'WMS拆柜方式', 'wms_devanning_method', 0, 'WMS拆柜作业方式', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7210, 'WMS来源单类型', 'wms_source_order_type', 0, 'WMS拆柜来源单类型', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7211, 'WMS拆柜订单状态', 'wms_devanning_status', 0, 'WMS拆柜订单状态', 'admin', NOW(), 'admin', NOW(), b'0', NULL)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `remark` = VALUES(`remark`), `updater` = 'admin', `update_time` = NOW();

-- ========== wms_zone_type ==========
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(72001, 1, '快递区', 'EXPRESS', 'wms_zone_type', 0, 'info', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72002, 2, '暂存区', 'TEMP', 'wms_zone_type', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72003, 3, '私仓库区', 'PRIVATE', 'wms_zone_type', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72004, 4, '异常区', 'EXCEPTION', 'wms_zone_type', 0, 'danger', '', '', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`), `sort` = VALUES(`sort`), `color_type` = VALUES(`color_type`), `updater` = 'admin', `update_time` = NOW();

-- ========== wms_zone_status ==========
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(72011, 1, '启用', 'ENABLED', 'wms_zone_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72012, 2, '停用', 'DISABLED', 'wms_zone_status', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`), `sort` = VALUES(`sort`), `color_type` = VALUES(`color_type`), `updater` = 'admin', `update_time` = NOW();

-- ========== wms_storage_method ==========
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(72021, 1, '地堆', 'FLOOR', 'wms_storage_method', 0, 'info', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72022, 2, '货架', 'RACK', 'wms_storage_method', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`), `sort` = VALUES(`sort`), `color_type` = VALUES(`color_type`), `updater` = 'admin', `update_time` = NOW();

-- ========== wms_location_status ==========
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(72031, 1, '正常', 'NORMAL', 'wms_location_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72032, 2, '停用', 'DISABLED', 'wms_location_status', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72033, 3, '锁定', 'LOCKED', 'wms_location_status', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`), `sort` = VALUES(`sort`), `color_type` = VALUES(`color_type`), `updater` = 'admin', `update_time` = NOW();

-- ========== wms_inventory_status ==========
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(72041, 1, '在库', 'IN_STOCK', 'wms_inventory_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72042, 2, '部分出库', 'PARTIAL_OUT', 'wms_inventory_status', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72043, 3, '已清空', 'DEPLETED', 'wms_inventory_status', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72044, 4, '冻结', 'HOLD', 'wms_inventory_status', 0, 'danger', '', '', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`), `sort` = VALUES(`sort`), `color_type` = VALUES(`color_type`), `updater` = 'admin', `update_time` = NOW();

-- ========== wms_pallet_status ==========
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(72051, 1, '在库', 'IN_STOCK', 'wms_pallet_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72052, 2, '已出单', 'PRE_OUTBOUND', 'wms_pallet_status', 0, 'info', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72053, 3, '出库', 'OUTBOUND', 'wms_pallet_status', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72054, 4, 'HOLD', 'HOLD', 'wms_pallet_status', 0, 'warning', '', '订单拦截', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`), `sort` = VALUES(`sort`), `color_type` = VALUES(`color_type`), `remark` = VALUES(`remark`), `updater` = 'admin', `update_time` = NOW();

-- ========== wms_pallet_type ==========
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(72061, 1, '常规', 'NORMAL', 'wms_pallet_type', 0, 'info', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72062, 2, '退货', 'RETURN', 'wms_pallet_type', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`), `sort` = VALUES(`sort`), `color_type` = VALUES(`color_type`), `updater` = 'admin', `update_time` = NOW();

-- ========== wms_inventory_lock_status ==========
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(72071, 1, '锁定中', 'LOCKED', 'wms_inventory_lock_status', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72072, 2, '已释放', 'RELEASED', 'wms_inventory_lock_status', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72073, 3, '已消耗', 'CONSUMED', 'wms_inventory_lock_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`), `sort` = VALUES(`sort`), `color_type` = VALUES(`color_type`), `updater` = 'admin', `update_time` = NOW();

-- ========== wms_inventory_transaction_type ==========
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(72081, 1, '收货', 'RECEIVE', 'wms_inventory_transaction_type', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72082, 2, '打板', 'PALLETIZE', 'wms_inventory_transaction_type', 0, 'info', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72083, 3, '上架', 'PUTAWAY', 'wms_inventory_transaction_type', 0, 'info', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72084, 4, '移库', 'MOVE', 'wms_inventory_transaction_type', 0, 'info', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72085, 5, '锁定', 'LOCK', 'wms_inventory_transaction_type', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72086, 6, '释放', 'UNLOCK', 'wms_inventory_transaction_type', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72087, 7, '出库', 'OUTBOUND', 'wms_inventory_transaction_type', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72088, 8, '盘点', 'COUNT', 'wms_inventory_transaction_type', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72089, 9, '调整', 'ADJUST', 'wms_inventory_transaction_type', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72090, 10, '异常', 'EXCEPTION', 'wms_inventory_transaction_type', 0, 'danger', '', '', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`), `sort` = VALUES(`sort`), `color_type` = VALUES(`color_type`), `updater` = 'admin', `update_time` = NOW();

-- ========== wms_devanning_method ==========
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(72101, 1, '人工', 'MANUAL', 'wms_devanning_method', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72102, 2, '叉车', 'FORKLIFT', 'wms_devanning_method', 0, 'info', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72103, 3, '机械', 'MACHINE', 'wms_devanning_method', 0, 'primary', '', '', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`), `sort` = VALUES(`sort`), `color_type` = VALUES(`color_type`), `updater` = 'admin', `update_time` = NOW();

-- ========== wms_source_order_type ==========
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(72111, 1, 'OMS海柜订单', 'CONTAINER_ORDER', 'wms_source_order_type', 0, 'info', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72112, 2, '手动创建', 'MANUAL', 'wms_source_order_type', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`), `sort` = VALUES(`sort`), `color_type` = VALUES(`color_type`), `updater` = 'admin', `update_time` = NOW();

-- ========== wms_devanning_status ==========
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(72121, 1, '未提柜', 'UNPICKEDUP', 'wms_devanning_status', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72122, 2, '已提柜', 'PICKEDUP', 'wms_devanning_status', 0, 'info', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72123, 3, '已到仓', 'ARRIVED', 'wms_devanning_status', 0, 'primary', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72124, 4, '拆柜中', 'DEVANNING', 'wms_devanning_status', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72125, 5, '拆柜完成', 'DEVANNED', 'wms_devanning_status', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72126, 6, '异常', 'EXCEPTION', 'wms_devanning_status', 0, 'danger', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(72127, 7, '取消', 'CANCELLED', 'wms_devanning_status', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`), `sort` = VALUES(`sort`), `color_type` = VALUES(`color_type`), `updater` = 'admin', `update_time` = NOW();
