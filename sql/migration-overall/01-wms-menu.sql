-- WMS 菜单与按钮权限（芋道 system_menu 格式，可重复执行）
-- 执行前：SELECT MAX(id) FROM system_menu;
-- 本脚本菜单 ID：7100~7149
-- 执行后：系统管理 → 角色管理 → 勾选 WMS 菜单（或执行文末 role_menu 授权 SQL）

SET NAMES utf8mb4;

-- ========== 目录 + 页面 ==========
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`,
                           `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`,
                           `create_time`, `updater`, `update_time`, `deleted`)
VALUES
    (7100, 'WMS仓储', '', 1, 45, 0, '/wms', 'ep:office-building', NULL, NULL, 0, b'1', b'1', b'1',
     'admin', NOW(), 'admin', NOW(), b'0'),
    (7101, '库存管理', '', 1, 1, 7100, 'inventory-group', 'ep:box', NULL, NULL, 0, b'1', b'1', b'1',
     'admin', NOW(), 'admin', NOW(), b'0'),
    (7102, '库存查询', 'wms:inventory:list', 2, 1, 7101, 'inventory', 'ep:search',
     'wms/inventory/index', 'WmsInventory', 0, b'1', b'0', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7103, '卡板库存', 'wms:pallet:list', 2, 2, 7101, 'pallet', 'ep:box',
     'wms/pallet/index', 'WmsPallet', 0, b'1', b'0', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7104, '锁定记录', 'wms:inventoryLock:list', 2, 3, 7101, 'inventory-lock', 'ep:lock',
     'wms/inventory-lock/index', 'WmsInventoryLock', 0, b'1', b'0', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7105, '库存流水', 'wms:inventoryTransaction:list', 2, 4, 7101, 'inventory-transaction', 'ep:tickets',
     'wms/inventory-transaction/index', 'WmsInventoryTransaction', 0, b'1', b'0', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7106, '出库历史', 'wms:pallet:list', 2, 5, 7101, 'pallet-outbound', 'ep:document',
     'wms/pallet-outbound/index', 'WmsPalletOutbound', 0, b'1', b'0', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7107, '库存可视化', 'wms:inventory:visualization', 2, 6, 7101, 'inventory-visualization', 'ep:data-analysis',
     'wms/inventory-visualization/index', 'WmsInventoryVisualization', 0, b'1', b'0', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7110, '仓库资料', '', 1, 2, 7100, 'warehouse-data', 'ep:grid', NULL, NULL, 0, b'1', b'1', b'1',
     'admin', NOW(), 'admin', NOW(), b'0'),
    (7111, '库区管理', 'wms:zone:list', 2, 1, 7110, 'zone', 'ep:grid',
     'wms/zone/index', 'WmsZone', 0, b'1', b'0', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7112, '库位管理', 'wms:location:list', 2, 2, 7110, 'location', 'ep:location',
     'wms/location/index', 'WmsLocation', 0, b'1', b'0', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7120, '订单管理', '', 1, 3, 7100, 'order', 'ep:document', NULL, NULL, 0, b'1', b'1', b'1',
     'admin', NOW(), 'admin', NOW(), b'0'),
    (7121, '拆柜订单', 'wms:devanningOrder:list', 2, 1, 7120, 'devanning-order', 'ep:box',
     'wms/devanning-order/index', 'WmsDevanningOrder', 0, b'1', b'0', b'1', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`), `permission` = VALUES(`permission`), `type` = VALUES(`type`),
    `sort` = VALUES(`sort`), `parent_id` = VALUES(`parent_id`), `path` = VALUES(`path`),
    `icon` = VALUES(`icon`), `component` = VALUES(`component`), `component_name` = VALUES(`component_name`),
    `status` = VALUES(`status`), `visible` = VALUES(`visible`), `keep_alive` = VALUES(`keep_alive`),
    `updater` = 'admin', `update_time` = NOW(), `deleted` = b'0';

-- ========== 按钮权限（type=3）==========
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`,
                           `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`,
                           `create_time`, `updater`, `update_time`, `deleted`)
VALUES
    -- 库存
    (7131, '库存详情', 'wms:inventory:query', 3, 1, 7102, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7132, '收货入账', 'wms:inventory:receive', 3, 2, 7102, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7133, '库存锁定', 'wms:inventory:lock', 3, 3, 7102, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7134, '库存调整', 'wms:inventory:adjust', 3, 4, 7102, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7135, '可视化查询', 'wms:inventory:visualization', 3, 1, 7107, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    -- 卡板
    (7136, '卡板移库位', 'wms:pallet:moveLocation', 3, 1, 7103, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7137, '卡板出库', 'wms:pallet:outbound', 3, 2, 7103, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    -- 库区
    (7141, '库区新增', 'wms:zone:add', 3, 1, 7111, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7142, '库区编辑', 'wms:zone:edit', 3, 2, 7111, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7143, '库区删除', 'wms:zone:remove', 3, 3, 7111, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7144, '库区启停', 'wms:zone:changeStatus', 3, 4, 7111, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    -- 库位
    (7145, '库位新增', 'wms:location:add', 3, 1, 7112, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7146, '库位编辑', 'wms:location:edit', 3, 2, 7112, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7147, '库位删除', 'wms:location:remove', 3, 3, 7112, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7148, '库位导入', 'wms:location:import', 3, 4, 7112, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7149, '库位改状态', 'wms:location:changeStatus', 3, 5, 7112, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    -- 拆柜
    (7150, '拆柜详情', 'wms:devanningOrder:query', 3, 1, 7121, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7151, '拆柜新建', 'wms:devanningOrder:add', 3, 2, 7121, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7152, '拆柜编辑', 'wms:devanningOrder:edit', 3, 3, 7121, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7153, '确认提柜', 'wms:devanningOrder:confirmPickup', 3, 4, 7121, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7154, '到仓登记', 'wms:devanningOrder:confirmArrival', 3, 5, 7121, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7155, '开始拆柜', 'wms:devanningOrder:startDevanning', 3, 6, 7121, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7156, '完成拆柜', 'wms:devanningOrder:completeDevanning', 3, 7, 7121, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7157, '标记异常', 'wms:devanningOrder:markException', 3, 8, 7121, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7158, '解除异常', 'wms:devanningOrder:clearException', 3, 9, 7121, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7159, '取消拆柜', 'wms:devanningOrder:cancel', 3, 10, 7121, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7160, 'OMS推单', 'wms:devanningOrder:push', 3, 11, 7121, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7161, 'Dock同步', 'wms:devanningOrder:syncDock', 3, 12, 7121, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7162, '拆柜导出', 'wms:devanningOrder:export', 3, 13, 7121, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`), `permission` = VALUES(`permission`), `parent_id` = VALUES(`parent_id`),
    `updater` = 'admin', `update_time` = NOW(), `deleted` = b'0';

-- ========== 可选：超级管理员授权 ==========
-- INSERT INTO `system_role_menu` (`role_id`, `menu_id`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`)
-- SELECT 1, id, 'admin', NOW(), 'admin', NOW(), b'0', 1 FROM `system_menu` WHERE id BETWEEN 7100 AND 7162 AND deleted = b'0';
