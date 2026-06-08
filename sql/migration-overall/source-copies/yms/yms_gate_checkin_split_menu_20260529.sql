-- =============================================
-- YMS Gate Check-in 拆分菜单补丁
-- 日期：2026-05-29
-- 说明：新增 海柜Check-in / 装车Check-in 两个操作台菜单与按钮权限
-- 父菜单：园区管理 menu_id = 5000
-- =============================================

-- 海柜 Check-in 操作台
INSERT IGNORE INTO sys_menu VALUES(5070, '海柜Check-in', 5000, 52, 'gate-container-checkin', 'yms/gate-container-checkin/index', '', 1, 0, 'C', '0', '0', 'yms:gate:containerCheckIn', 'check-square', 103, 1, NOW(), NULL, NULL, '门卫海柜 Check-in 操作台');
INSERT IGNORE INTO sys_menu VALUES(5072, '海柜Check-in-办理', 5070, 1, '#', '', '', 1, 0, 'F', '0', '0', 'yms:gate:containerCheckIn', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5073, '海柜Check-in-手动放行', 5070, 2, '#', '', '', 1, 0, 'F', '0', '0', 'yms:gate:manualPass', '#', 103, 1, NOW(), NULL, NULL, '');

-- 装车 Check-in 操作台
INSERT IGNORE INTO sys_menu VALUES(5071, '装车Check-in', 5000, 53, 'gate-loading-checkin', 'yms/gate-loading-checkin/index', '', 1, 0, 'C', '0', '0', 'yms:gate:loadingCheckIn', 'check-square', 103, 1, NOW(), NULL, NULL, '门卫装车 Check-in 操作台');
INSERT IGNORE INTO sys_menu VALUES(5074, '装车Check-in-办理', 5071, 1, '#', '', '', 1, 0, 'F', '0', '0', 'yms:gate:loadingCheckIn', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5075, '装车Check-in-手动放行', 5071, 2, '#', '', '', 1, 0, 'F', '0', '0', 'yms:gate:manualPass', '#', 103, 1, NOW(), NULL, NULL, '');

-- 在场列表
INSERT IGNORE INTO sys_menu VALUES(5076, '在场列表', 5000, 54, 'gate-in-yard', 'yms/gate-in-yard/index', '', 1, 0, 'C', '0', '0', 'yms:gate:inYard', 'team', 103, 1, NOW(), NULL, NULL, '当前在场车辆/海柜/车厢');
INSERT IGNORE INTO sys_menu VALUES(5077, '在场列表查询', 5076, 1, '#', '', '', 1, 0, 'F', '0', '0', 'yms:gate:inYard', '#', 103, 1, NOW(), NULL, NULL, '');

-- Check-out 操作台
INSERT IGNORE INTO sys_menu VALUES(5078, 'Check-out离场', 5000, 55, 'gate-check-out', 'yms/gate-check-out/index', '', 1, 0, 'C', '0', '0', 'yms:gate:checkout', 'logout', 103, 1, NOW(), NULL, NULL, '门卫 Check-out 离场操作台');
INSERT IGNORE INTO sys_menu VALUES(5079, 'Check-out办理', 5078, 1, '#', '', '', 1, 0, 'F', '0', '0', 'yms:gate:checkout', '#', 103, 1, NOW(), NULL, NULL, '');

