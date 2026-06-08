-- =============================================
-- YMS Phase 0 菜单补丁
-- 日期：2026-05-29
-- 说明：堆场位 / 海柜资源 / 车厢资源 菜单与按钮权限
-- 父菜单：园区管理 menu_id = 5000（yms_menu_20260528.sql）
-- =============================================

-- 堆场位管理
INSERT IGNORE INTO sys_menu VALUES(5030, '堆场位管理', 5000, 73, 'yard-position', 'yms/yard-position/index', '', 1, 0, 'C', '0', '0', 'yms:yardPosition:list', 'location', 103, 1, NOW(), NULL, NULL, 'YMS堆场位管理');
INSERT IGNORE INTO sys_menu VALUES(5031, '堆场位查询', 5030, 1, '#', '', '', 1, 0, 'F', '0', '0', 'yms:yardPosition:query',  '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5032, '堆场位新增', 5030, 2, '#', '', '', 1, 0, 'F', '0', '0', 'yms:yardPosition:add',    '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5033, '堆场位编辑', 5030, 3, '#', '', '', 1, 0, 'F', '0', '0', 'yms:yardPosition:edit',   '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5034, '堆场位删除', 5030, 4, '#', '', '', 1, 0, 'F', '0', '0', 'yms:yardPosition:remove', '#', 103, 1, NOW(), NULL, NULL, '');

-- 海柜资源
INSERT IGNORE INTO sys_menu VALUES(5040, '海柜资源', 5000, 40, 'container', 'yms/container/index', '', 1, 0, 'C', '0', '0', 'yms:containerResource:list', 'box', 103, 1, NOW(), NULL, NULL, 'YMS海柜资源管理');
INSERT IGNORE INTO sys_menu VALUES(5041, '海柜资源查询', 5040, 1, '#', '', '', 1, 0, 'F', '0', '0', 'yms:containerResource:query',          '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5042, '海柜资源新增', 5040, 2, '#', '', '', 1, 0, 'F', '0', '0', 'yms:containerResource:add',            '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5043, '海柜资源编辑', 5040, 3, '#', '', '', 1, 0, 'F', '0', '0', 'yms:containerResource:edit',           '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5044, '海柜资源删除', 5040, 4, '#', '', '', 1, 0, 'F', '0', '0', 'yms:containerResource:remove',         '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5045, '海柜分配堆场位', 5040, 5, '#', '', '', 1, 0, 'F', '0', '0', 'yms:containerResource:assignPosition', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5046, '海柜叫号',     5040, 6, '#', '', '', 1, 0, 'F', '0', '0', 'yms:containerResource:call',           '#', 103, 1, NOW(), NULL, NULL, '');

-- 车厢资源
INSERT IGNORE INTO sys_menu VALUES(5050, '车厢资源', 5000, 41, 'trailer', 'yms/trailer/index', '', 1, 0, 'C', '0', '0', 'yms:trailerResource:list', 'truck', 103, 1, NOW(), NULL, NULL, 'YMS车厢资源管理');
INSERT IGNORE INTO sys_menu VALUES(5051, '车厢资源查询', 5050, 1, '#', '', '', 1, 0, 'F', '0', '0', 'yms:trailerResource:query',          '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5052, '车厢资源新增', 5050, 2, '#', '', '', 1, 0, 'F', '0', '0', 'yms:trailerResource:add',            '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5053, '车厢资源编辑', 5050, 3, '#', '', '', 1, 0, 'F', '0', '0', 'yms:trailerResource:edit',           '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5054, '车厢资源删除', 5050, 4, '#', '', '', 1, 0, 'F', '0', '0', 'yms:trailerResource:remove',         '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5055, '车厢分配堆场位', 5050, 5, '#', '', '', 1, 0, 'F', '0', '0', 'yms:trailerResource:assignPosition', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5056, '车厢叫号',     5050, 6, '#', '', '', 1, 0, 'F', '0', '0', 'yms:trailerResource:call',           '#', 103, 1, NOW(), NULL, NULL, '');
