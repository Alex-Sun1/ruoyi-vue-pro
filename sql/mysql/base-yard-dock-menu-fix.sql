-- 月台设置菜单 component 与前端页面路径对齐
-- 现象：菜单存在但点击白屏/404（component=yard/dock/index，实际页面 base/yard-dock/index）
-- 执行后请重新登录或刷新权限缓存

UPDATE `system_menu`
SET `component` = 'base/yard-dock/index',
    `component_name` = 'BaseYardDock',
    `updater` = 'admin',
    `update_time` = NOW()
WHERE `id` = 6852;
