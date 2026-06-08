-- OMS 菜单补丁：仅补 v1.1 新增按钮（首次已执行旧版 oms-menu 时用）
-- 主菜单 6900-6904 已存在时执行本文件即可，勿重复插目录行

SET NAMES utf8mb4;

INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`,
                           `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`,
                           `create_time`, `updater`, `update_time`, `deleted`)
VALUES
    (6914, '海柜查看', 'oms:container:view', 3, 4, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6915, '海柜复制', 'oms:container:copy', 3, 5, 6901, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6924, '委托单查询', 'oms:order:query', 3, 4, 6902, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `permission` = VALUES(`permission`),
    `parent_id` = VALUES(`parent_id`),
    `updater` = VALUES(`updater`),
    `update_time` = NOW(),
    `deleted` = VALUES(`deleted`);

-- 检查是否已有：SELECT id, permission FROM system_menu WHERE id IN (6914, 6915, 6924);
