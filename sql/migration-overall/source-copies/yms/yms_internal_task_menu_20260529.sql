-- =============================================
-- YMS Phase 1 院内任务菜单补丁
-- 父菜单：园区管理 menu_id = 5000
-- =============================================

INSERT IGNORE INTO sys_menu VALUES(5060, '院内任务', 5000, 50, 'internal-task', 'yms/internal-task/index', '', 1, 0, 'C', '0', '0', 'yms:internalTask:list', 'list', 103, 1, NOW(), NULL, NULL, 'YMS院内任务中心');
INSERT IGNORE INTO sys_menu VALUES(5061, '院内任务查询', 5060, 1, '#', '', '', 1, 0, 'F', '0', '0', 'yms:internalTask:query',   '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5062, '院内任务新增', 5060, 2, '#', '', '', 1, 0, 'F', '0', '0', 'yms:internalTask:add',     '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5063, '分配执行人',   5060, 3, '#', '', '', 1, 0, 'F', '0', '0', 'yms:internalTask:assign',  '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5064, '执行任务',     5060, 4, '#', '', '', 1, 0, 'F', '0', '0', 'yms:internalTask:operate', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5065, '完成任务',     5060, 5, '#', '', '', 1, 0, 'F', '0', '0', 'yms:internalTask:complete','#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5066, '取消任务',     5060, 6, '#', '', '', 1, 0, 'F', '0', '0', 'yms:internalTask:cancel',  '#', 103, 1, NOW(), NULL, NULL, '');
