-- 库存可视化菜单
INSERT IGNORE INTO sys_menu VALUES(6007, '库存可视化', 6001, 6, 'inventory-visualization', 'wms/inventory-visualization/index', '', 1, 0, 'C', '0', '0', 'wms:inventory:visualization', 'ep:data-analysis', 103, 1, NOW(), NULL, NULL, '仓库库位平面占用可视化');
INSERT IGNORE INTO sys_menu VALUES(6025, '可视化查询', 6007, 1, '#', '', '', 1, 0, 'F', '0', '0', 'wms:inventory:visualization', '#', 103, 1, NOW(), NULL, NULL, '');
