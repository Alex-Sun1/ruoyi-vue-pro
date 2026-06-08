-- 叫号规则 toggle 权限补丁（phase2 菜单缺此项）
INSERT IGNORE INTO sys_menu VALUES(5115, '叫号规则启用禁用', 5110, 5, '#', '', '', 1, 0, 'F', '0', '0', 'yms:callRule:toggle', '#', 103, 1, NOW(), NULL, NULL, '');
