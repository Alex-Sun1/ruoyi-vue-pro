-- =============================================
-- 修正：装车 Check-in 菜单指向 + 海柜 Check-in 改名
-- 日期：2026-05-31
-- 背景：
--   5087 是 h5-driver-checkin 调试页，需要改名为「海柜 Check-in」
--   5085 之前被误改名，回滚回「司机签到码」
--   5170 组件被误设为 gate-trailer-link，改为 h5-trailer-checkin
-- =============================================

SET SQL_SAFE_UPDATES = 0;

-- 1. 5087「海柜 Check-in」直达 H5 调试页
INSERT INTO sys_menu (
    menu_id, menu_name, parent_id, order_num, path, component, query_param,
    is_frame, is_cache, menu_type, visible, status, perms, icon,
    create_by, create_time, remark
) VALUES (
    5087, '海柜 Check-in', 5160, 3, 'h5-driver-checkin', 'yms/h5-driver-checkin/index', NULL,
    1, 0, 'C', '0', '0', 'yms:gate:driverQr', 'mdi:truck-check-outline',
    1, NOW(), '海柜司机自助 Check-in 调试入口（h5-driver-checkin）'
) ON DUPLICATE KEY UPDATE
    menu_name = VALUES(menu_name),
    parent_id = VALUES(parent_id),
    order_num = VALUES(order_num),
    path = VALUES(path),
    component = VALUES(component),
    visible = VALUES(visible),
    status = VALUES(status),
    perms = VALUES(perms),
    icon = VALUES(icon),
    remark = VALUES(remark),
    update_by = 1,
    update_time = NOW();

-- 2. 5085 回滚误改的名字（QR 码页保持原名）
UPDATE sys_menu
SET menu_name = '司机签到码',
    remark    = '司机自助签到二维码管理（每个仓库独立二维码）'
WHERE menu_id = 5085;

UPDATE sys_menu SET menu_name = '签到码查看' WHERE menu_id = 5086;

-- 3. 5170「装车 Check-in」组件改为实际 H5 业务页
UPDATE sys_menu
SET order_num = 4,
    path      = 'h5-trailer-checkin',
    component = 'yms/h5-trailer-checkin/index',
    perms     = 'yms:gate:trailerCheckin',
    remark    = '装车司机预登记页（提货号查派送信息 + 填写司机信息）'
WHERE menu_id = 5170;

UPDATE sys_menu
SET menu_name = '装车 Check-in查看',
    perms = 'yms:gate:trailerCheckin'
WHERE menu_id = 5171;

UPDATE sys_menu SET order_num = 5 WHERE menu_id = 5076;
UPDATE sys_menu SET order_num = 6 WHERE menu_id = 5078;

SET SQL_SAFE_UPDATES = 1;

-- 验证
-- SELECT menu_id, menu_name, path, component, visible
-- FROM sys_menu WHERE menu_id IN (5085, 5086, 5087, 5170)
-- ORDER BY menu_id;
