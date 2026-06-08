-- 库存调整按钮权限（已有库执行一次即可）
INSERT IGNORE INTO sys_menu VALUES(6024, '库存调整', 6002, 4, '#', '', '', 1, 0, 'F', '0', '0', 'wms:inventory:adjust', '#', 103, 1, NOW(), NULL, NULL, '');
