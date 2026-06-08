-- =============================================
-- YMS 园区管理模块 — 菜单权限初始化
-- 日期：2026-05-28
-- ID 段：5000 ~ 5099
-- =============================================

-- ── 一级目录：园区管理 ──────────────────────────────────────────────
INSERT IGNORE INTO sys_menu VALUES(5000, '园区管理', 0, 50, 'yms', NULL, '', 1, 0, 'M', '0', '0', '', 'fork', 103, 1, NOW(), NULL, NULL, 'YMS园区管理目录');

-- ── 菜单页：园区调度（主页，侧边栏可见）──────────────────────────────
INSERT IGNORE INTO sys_menu VALUES(5001, '园区调度', 5000, 1, 'dispatch', 'yms/dispatch/index', '', 1, 0, 'C', '0', '0', 'yms:yard:view', 'monitor', 103, 1, NOW(), NULL, NULL, '园区调度总览');

-- ── 隐藏页：任务详情（通过路由跳转，不显示在侧边栏）────────────────
INSERT IGNORE INTO sys_menu VALUES(5002, '任务详情', 5000, 2, 'dispatch-detail', 'yms/dispatch-detail/index', '', 1, 0, 'C', '1', '0', 'yms:yard:view', '#', 103, 1, NOW(), NULL, NULL, '园区任务详情页（隐藏）');

-- ── 隐藏页：新建任务（通过路由跳转，不显示在侧边栏）────────────────
INSERT IGNORE INTO sys_menu VALUES(5003, '新建任务', 5000, 3, 'dispatch-create', 'yms/dispatch-create/index', '', 1, 0, 'C', '1', '0', 'yms:yard:create', '#', 103, 1, NOW(), NULL, NULL, '手动新建园区任务页（隐藏）');

-- ── 按钮权限（挂在园区调度菜单下）────────────────────────────────────
INSERT IGNORE INTO sys_menu VALUES(5010, '查看任务',  5001, 1, '#', '', '', 1, 0, 'F', '0', '0', 'yms:yard:view',       '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5011, '新建任务',  5001, 2, '#', '', '', 1, 0, 'F', '0', '0', 'yms:yard:create',     '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5012, 'OMS推送',   5001, 3, '#', '', '', 1, 0, 'F', '0', '0', 'yms:yard:push',       '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5013, '签到',      5001, 4, '#', '', '', 1, 0, 'F', '0', '0', 'yms:yard:checkin',    '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5014, '分配Dock',  5001, 5, '#', '', '', 1, 0, 'F', '0', '0', 'yms:yard:assignDock', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5015, '开始作业',  5001, 6, '#', '', '', 1, 0, 'F', '0', '0', 'yms:yard:start',      '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5016, '完成作业',  5001, 7, '#', '', '', 1, 0, 'F', '0', '0', 'yms:yard:finish',     '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5017, '放行',      5001, 8, '#', '', '', 1, 0, 'F', '0', '0', 'yms:yard:release',    '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5018, '异常处理',  5001, 9, '#', '', '', 1, 0, 'F', '0', '0', 'yms:yard:exception',  '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5019, '离园',      5001,10, '#', '', '', 1, 0, 'F', '0', '0', 'yms:yard:leave',      '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5020, '取消任务',  5001,11, '#', '', '', 1, 0, 'F', '0', '0', 'yms:yard:cancel',     '#', 103, 1, NOW(), NULL, NULL, '');

-- ── 菜单页：任务管理（侧边栏可见，专注任务列表管理）────────────────────
INSERT IGNORE INTO sys_menu VALUES(5004, '任务管理', 5000, 2, 'task', 'yms/task/index', '', 1, 0, 'C', '0', '0', 'yms:yard:view', 'list', 103, 1, NOW(), NULL, NULL, '园区任务管理列表');

-- ── 菜单页：拆柜调度（侧边栏可见）────────────────────────────────────
INSERT IGNORE INTO sys_menu VALUES(5005, '拆柜调度', 5000, 3, 'devanning', 'yms/devanning/index', '', 1, 0, 'C', '0', '0', 'yms:yard:view', 'unpack', 103, 1, NOW(), NULL, NULL, '拆柜调度页面');

-- ── 菜单页：装车调度（侧边栏可见）────────────────────────────────────
INSERT IGNORE INTO sys_menu VALUES(5006, '装车调度', 5000, 4, 'loading', 'yms/loading/index', '', 1, 0, 'C', '0', '0', 'yms:yard:view', 'car', 103, 1, NOW(), NULL, NULL, '装车调度页面');
