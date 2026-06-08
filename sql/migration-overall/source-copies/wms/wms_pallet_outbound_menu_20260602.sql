-- 出库历史菜单（已有库执行一次）
INSERT IGNORE INTO sys_menu VALUES(6006, '出库历史', 6001, 5, 'pallet-outbound', 'wms/pallet-outbound/index', '', 1, 0, 'C', '0', '0', 'wms:pallet:list', 'ep:document', 103, 1, NOW(), NULL, NULL, '已出库卡板只读查询');
