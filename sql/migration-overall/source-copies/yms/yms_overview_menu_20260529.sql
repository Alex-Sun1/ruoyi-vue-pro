-- =============================================
-- YMS 园区总览菜单补丁
-- 日期：2026-05-29
-- 说明：新增园区总览 Dashboard 菜单
-- 父菜单：园区管理 menu_id = 5000
-- =============================================

INSERT IGNORE INTO sys_menu VALUES(5080, '园区总览', 5000, 0, 'overview', 'yms/overview/index', '', 1, 0, 'C', '0', '0', 'yms:dashboard:view', 'dashboard', 103, 1, NOW(), NULL, NULL, 'YMS园区总览大屏');
INSERT IGNORE INTO sys_menu VALUES(5081, '园区总览查看', 5080, 1, '#', '', '', 1, 0, 'F', '0', '0', 'yms:dashboard:view', '#', 103, 1, NOW(), NULL, NULL, '');
