-- 园区调度增强：优先级 / WMS 备货回写 权限按钮
INSERT IGNORE INTO sys_menu VALUES(5021, '调整优先级', 5001, 12, '#', '', '', 1, 0, 'F', '0', '0', 'yms:yard:priority', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(5022, 'WMS备货回写', 5001, 13, '#', '', '', 1, 0, 'F', '0', '0', 'yms:yard:wmsSync', '#', 103, 1, NOW(), NULL, NULL, '');
