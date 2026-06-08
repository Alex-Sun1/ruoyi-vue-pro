-- OMS 菜单与按钮权限（可重复执行，不会 1062）
-- 检查：SELECT id, name, permission FROM system_menu WHERE id BETWEEN 6900 AND 6942;
-- 执行后：系统管理 → 角色管理 → 为角色勾选 OMS 菜单（超级管理员 tenant_id=1 通常 role_id=1）

SET NAMES utf8mb4;

-- ========== 目录 + 页面菜单 ==========
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`,
                           `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`,
                           `create_time`, `updater`, `update_time`, `deleted`)
VALUES
    (6900, 'OMS', '', 1, 60, 0, '/oms', 'ep:management', NULL, NULL, 0, b'1', b'1', b'1',
     'admin', NOW(), 'admin', NOW(), b'0'),
    (6901, '海柜订单', 'oms:containerOrder:list', 2, 1, 6900, 'container-order', 'ep:box',
     'oms/container-order/index', 'OmsContainerOrder', 0, b'1', b'1', b'1',
     'admin', NOW(), 'admin', NOW(), b'0'),
    (6902, '货物订单', 'oms:cargoOrder:list', 2, 2, 6900, 'cargo-order', 'ep:tickets',
     'oms/cargo-order/index', 'OmsCargoOrder', 0, b'1', b'1', b'1',
     'admin', NOW(), 'admin', NOW(), b'0'),
    (6903, '预警中心', 'oms:alert:list', 2, 3, 6900, 'alert', 'ep:warning',
     'oms/alert/index', 'OmsAlert', 0, b'1', b'1', b'1',
     'admin', NOW(), 'admin', NOW(), b'0'),
    (6904, '费用中心', 'oms:fee:list', 2, 4, 6900, 'fee', 'ep:coin',
     'oms/fee/index', 'OmsFee', 0, b'1', b'1', b'1',
     'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `permission` = VALUES(`permission`),
    `type` = VALUES(`type`),
    `sort` = VALUES(`sort`),
    `parent_id` = VALUES(`parent_id`),
    `path` = VALUES(`path`),
    `icon` = VALUES(`icon`),
    `component` = VALUES(`component`),
    `component_name` = VALUES(`component_name`),
    `status` = VALUES(`status`),
    `visible` = VALUES(`visible`),
    `keep_alive` = VALUES(`keep_alive`),
    `always_show` = VALUES(`always_show`),
    `updater` = VALUES(`updater`),
    `update_time` = NOW(),
    `deleted` = VALUES(`deleted`);

-- ========== 按钮权限（type=3）==========
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`,
                           `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`,
                           `create_time`, `updater`, `update_time`, `deleted`)
VALUES
    (6911, '海柜创建', 'oms:container:create', 3, 1, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6912, '海柜编辑', 'oms:container:edit', 3, 2, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6913, '海柜状态更新', 'oms:container:status-update', 3, 3, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6914, '海柜查看', 'oms:container:view', 3, 4, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6915, '海柜复制', 'oms:container:copy', 3, 5, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6916, '海柜受理', 'oms:container:accept', 3, 6, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6921, '委托单状态更新', 'oms:order:status-update', 3, 1, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6922, '委托单预派送', 'oms:order:pre-dispatch', 3, 2, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6923, '委托单挂起', 'oms:order:hold', 3, 3, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6924, '委托单查询', 'oms:order:query', 3, 4, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6931, '预警处理', 'oms:alert:process', 3, 1, 6903, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6932, '预警规则编辑', 'oms:alert-rule:edit', 3, 2, 6903, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6941, '费用冻结申请', 'oms:fee:freeze-request', 3, 1, 6904, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6942, '事件日志查看', 'oms:event-log:view', 3, 2, 6904, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `permission` = VALUES(`permission`),
    `type` = VALUES(`type`),
    `sort` = VALUES(`sort`),
    `parent_id` = VALUES(`parent_id`),
    `status` = VALUES(`status`),
    `visible` = VALUES(`visible`),
    `updater` = VALUES(`updater`),
    `update_time` = NOW(),
    `deleted` = VALUES(`deleted`);
