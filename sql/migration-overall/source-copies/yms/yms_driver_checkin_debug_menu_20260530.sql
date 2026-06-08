-- YMS driver self check-in debug menu
-- Purpose: expose the existing H5 driver check-in page in the desktop menu for debugging.

INSERT IGNORE INTO sys_menu VALUES(
    5087, '司机Check-in调试', COALESCE((SELECT menu_id FROM (SELECT menu_id FROM sys_menu WHERE menu_id = 5160) t), 5000), 3,
    'h5-driver-checkin', 'yms/h5-driver-checkin/index',
    '', 1, 0, 'C', '0', '0', 'yms:gate:driverQr',
    'qrcode', 103, 1, NOW(), NULL, NULL,
    '司机自助 Check-in H5 调试入口'
);

UPDATE sys_menu
SET parent_id = COALESCE((SELECT menu_id FROM (SELECT menu_id FROM sys_menu WHERE menu_id = 5160) t), 5000),
    order_num = 3,
    path = 'h5-driver-checkin',
    component = 'yms/h5-driver-checkin/index',
    visible = '0',
    status = '0',
    perms = 'yms:gate:driverQr',
    menu_name = '司机Check-in调试',
    remark = '司机自助 Check-in H5 调试入口'
WHERE menu_id = 5087;
