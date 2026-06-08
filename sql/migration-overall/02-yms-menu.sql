-- YMS 菜单与按钮权限（芋道 system_menu 格式，可重复执行）
-- 执行前：SELECT MAX(id) FROM system_menu;
-- 本脚本菜单 ID：7500~7599（首批 8 页 + 常用按钮）
-- 执行后：系统管理 → 角色管理 → 勾选 YMS 菜单

SET NAMES utf8mb4;

-- ========== 目录 + 页面 ==========
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`,
                           `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`,
                           `create_time`, `updater`, `update_time`, `deleted`)
VALUES
    (7500, 'YMS堆场', '', 1, 55, 0, '/yms', 'ep:place', NULL, NULL, 0, b'1', b'1', b'1',
     'admin', NOW(), 'admin', NOW(), b'0'),
    (7501, '堆场资源', '', 1, 1, 7500, 'resource', 'ep:box', NULL, NULL, 0, b'1', b'1', b'1',
     'admin', NOW(), 'admin', NOW(), b'0'),
    (7502, '堆场分区', 'yms:yardZone:list', 2, 1, 7501, 'zone', 'ep:grid',
     'yms/zone/index', 'YmsZone', 0, b'1', b'0', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7503, '堆场位', 'yms:yardPosition:list', 2, 2, 7501, 'yard-position', 'ep:location',
     'yms/yard-position/index', 'YmsYardPosition', 0, b'1', b'0', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7504, '海柜资源', 'yms:containerResource:list', 2, 3, 7501, 'container', 'ep:box',
     'yms/container/index', 'YmsContainer', 0, b'1', b'0', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7505, '车厢资源', 'yms:trailerResource:list', 2, 4, 7501, 'trailer', 'ep:van',
     'yms/trailer/index', 'YmsTrailer', 0, b'1', b'0', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7510, '预约门岗', '', 1, 2, 7500, 'gate-group', 'ep:monitor', NULL, NULL, 0, b'1', b'1', b'1',
     'admin', NOW(), 'admin', NOW(), b'0'),
    (7511, '预约管理', 'yms:appointment:list', 2, 1, 7510, 'appointment', 'ep:calendar',
     'yms/appointment/index', 'YmsAppointment', 0, b'1', b'0', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7512, '门卫操作台', 'yms:gate:list', 2, 2, 7510, 'gate', 'ep:monitor',
     'yms/gate/index', 'YmsGate', 0, b'1', b'0', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7520, '调度作业', '', 1, 3, 7500, 'dispatch-group', 'ep:operation', NULL, NULL, 0, b'1', b'1', b'1',
     'admin', NOW(), 'admin', NOW(), b'0'),
    (7521, '调度看板', 'yms:yard:view', 2, 1, 7520, 'dispatch', 'ep:data-board',
     'yms/dispatch/index', 'YmsDispatch', 0, b'1', b'0', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7522, '院内任务', 'yms:internalTask:list', 2, 2, 7520, 'internal-task', 'ep:list',
     'yms/internal-task/index', 'YmsInternalTask', 0, b'1', b'0', b'1', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`), `permission` = VALUES(`permission`), `type` = VALUES(`type`),
    `sort` = VALUES(`sort`), `parent_id` = VALUES(`parent_id`), `path` = VALUES(`path`),
    `icon` = VALUES(`icon`), `component` = VALUES(`component`), `component_name` = VALUES(`component_name`),
    `status` = VALUES(`status`), `visible` = VALUES(`visible`), `keep_alive` = VALUES(`keep_alive`),
    `updater` = 'admin', `update_time` = NOW(), `deleted` = b'0';

-- ========== 按钮权限 ==========
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`,
                           `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`,
                           `create_time`, `updater`, `update_time`, `deleted`)
VALUES
    -- 堆场分区
    (7531, '分区查询', 'yms:yardZone:query', 3, 1, 7502, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7532, '分区新增', 'yms:yardZone:add', 3, 2, 7502, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7533, '分区编辑', 'yms:yardZone:edit', 3, 3, 7502, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7534, '分区删除', 'yms:yardZone:remove', 3, 4, 7502, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    -- 堆场位
    (7541, '堆场位查询', 'yms:yardPosition:query', 3, 1, 7503, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7542, '堆场位新增', 'yms:yardPosition:add', 3, 2, 7503, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7543, '堆场位编辑', 'yms:yardPosition:edit', 3, 3, 7503, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7544, '堆场位删除', 'yms:yardPosition:remove', 3, 4, 7503, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    -- 海柜资源
    (7551, '海柜查询', 'yms:containerResource:query', 3, 1, 7504, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7552, '海柜编辑', 'yms:containerResource:edit', 3, 2, 7504, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7553, '分配堆位', 'yms:containerResource:assignPosition', 3, 3, 7504, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    -- 车厢资源
    (7561, '车厢查询', 'yms:trailerResource:query', 3, 1, 7505, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7562, '车厢编辑', 'yms:trailerResource:edit', 3, 2, 7505, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    -- 预约
    (7571, '预约查询', 'yms:appointment:query', 3, 1, 7511, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7572, '预约新增', 'yms:appointment:add', 3, 2, 7511, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7573, '预约编辑', 'yms:appointment:edit', 3, 3, 7511, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7574, '预约删除', 'yms:appointment:remove', 3, 4, 7511, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    -- 门岗
    (7581, '签到记录', 'yms:gate:list', 3, 1, 7512, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7582, '入场登记', 'yms:gate:checkIn', 3, 2, 7512, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7583, '离场登记', 'yms:gate:checkout', 3, 3, 7512, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7584, '在场列表', 'yms:gate:inYard', 3, 4, 7512, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    -- 调度
    (7591, '分配月台', 'yms:yard:assignDock', 3, 1, 7521, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7592, '开始作业', 'yms:yard:start', 3, 2, 7521, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7593, '完成作业', 'yms:yard:finish', 3, 3, 7521, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7594, '异常处理', 'yms:yard:exception', 3, 4, 7521, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    -- 院内任务
    (7595, '任务查询', 'yms:internalTask:query', 3, 1, 7522, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7596, '任务新增', 'yms:internalTask:add', 3, 2, 7522, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7597, '任务分配', 'yms:internalTask:assign', 3, 3, 7522, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7598, '任务完成', 'yms:internalTask:complete', 3, 4, 7522, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (7599, '任务取消', 'yms:internalTask:cancel', 3, 5, 7522, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`), `permission` = VALUES(`permission`), `parent_id` = VALUES(`parent_id`),
    `updater` = 'admin', `update_time` = NOW(), `deleted` = b'0';

-- ========== 可选：超级管理员授权 ==========
-- INSERT INTO `system_role_menu` (`role_id`, `menu_id`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`)
-- SELECT 1, id, 'admin', NOW(), 'admin', NOW(), b'0', 1 FROM `system_menu` WHERE id BETWEEN 7500 AND 7599 AND deleted = b'0';
