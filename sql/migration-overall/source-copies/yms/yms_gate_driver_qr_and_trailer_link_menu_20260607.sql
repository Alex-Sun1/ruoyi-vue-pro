-- =============================================
-- YMS 司机签到码 & 装车签到链接 菜单
-- 日期：2026-06-07
-- 框架：yudao（system_menu，非 sys_menu）
-- 说明：
--   1. 开启 gate-driver-qr "司机签到码" 菜单可见
--      如不存在则插入（component = 'yms/gate-driver-qr/index'）
--   2. 新增 gate-trailer-link "装车签到链接" 菜单
--      如不存在则插入（component = 'yms/gate-trailer-link/index'）
--   父节点：取 gate-checkin 所在目录（parent_id of 'yms/gate-checkin/index'）
-- =============================================

-- =============================================
-- STEP 1：确认父节点 ID（门岗操作目录）
-- 通过 gate-checkin 的 parent_id 获取，可先执行以下查询确认：
-- SELECT id, name, parent_id FROM system_menu WHERE component = 'yms/gate-checkin/index' AND deleted = 0;
-- =============================================

SET SQL_SAFE_UPDATES = 0;

-- =============================================
-- PART 1：激活 gate-driver-qr 菜单
-- 若已存在（component = 'yms/gate-driver-qr/index'），则更新为可见状态
-- =============================================

UPDATE system_menu
SET name           = '司机签到码',
    permission     = 'yms:gate:driverQr',
    type           = 2,
    sort           = 2,
    path           = 'gate-driver-qr',
    icon           = 'ep:qrcode',
    component      = 'yms/gate-driver-qr/index',
    component_name = 'YmsGateDriverQr',
    status         = 0,
    visible        = b'1',
    keep_alive     = b'0',
    always_show    = b'1',
    updater        = '1',
    update_time    = NOW()
WHERE component = 'yms/gate-driver-qr/index'
  AND deleted   = 0;

-- 若不存在则插入（ON DUPLICATE 基于 component 无法直接用，改用 INSERT … WHERE NOT EXISTS）
INSERT INTO system_menu (name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted)
SELECT '司机签到码', 'yms:gate:driverQr', 2, 2,
       -- 父节点：取 gate-checkin 的 parent_id
       (SELECT parent_id FROM system_menu WHERE component = 'yms/gate-checkin/index' AND deleted = 0 LIMIT 1),
       'gate-driver-qr', 'ep:qrcode', 'yms/gate-driver-qr/index', 'YmsGateDriverQr',
       0, b'1', b'0', b'1',
       '1', NOW(), '1', NOW(), b'0'
WHERE NOT EXISTS (
    SELECT 1 FROM system_menu WHERE component = 'yms/gate-driver-qr/index' AND deleted = 0
);

-- =============================================
-- PART 2：新增 gate-trailer-link "装车签到链接"
-- 若已存在则更新，若不存在则插入
-- =============================================

UPDATE system_menu
SET name           = '装车签到链接',
    permission     = 'yms:gate:trailerLink',
    type           = 2,
    sort           = 3,
    path           = 'gate-trailer-link',
    icon           = 'ep:van',
    component      = 'yms/gate-trailer-link/index',
    component_name = 'YmsGateTrailerLink',
    status         = 0,
    visible        = b'1',
    keep_alive     = b'0',
    always_show    = b'1',
    updater        = '1',
    update_time    = NOW()
WHERE component = 'yms/gate-trailer-link/index'
  AND deleted   = 0;

INSERT INTO system_menu (name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted)
SELECT '装车签到链接', 'yms:gate:trailerLink', 2, 3,
       (SELECT parent_id FROM system_menu WHERE component = 'yms/gate-checkin/index' AND deleted = 0 LIMIT 1),
       'gate-trailer-link', 'ep:van', 'yms/gate-trailer-link/index', 'YmsGateTrailerLink',
       0, b'1', b'0', b'1',
       '1', NOW(), '1', NOW(), b'0'
WHERE NOT EXISTS (
    SELECT 1 FROM system_menu WHERE component = 'yms/gate-trailer-link/index' AND deleted = 0
);

-- =============================================
-- PART 3：按钮权限（可选，如角色管理中需要细粒度控制）
-- =============================================

-- gate-driver-qr 按钮权限
INSERT INTO system_menu (name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted)
SELECT '签到码查看', 'yms:gate:driverQr', 3, 1,
       (SELECT id FROM system_menu WHERE component = 'yms/gate-driver-qr/index' AND deleted = 0 LIMIT 1),
       '', '#', '', '', 0, b'1', b'0', b'1',
       '1', NOW(), '1', NOW(), b'0'
WHERE NOT EXISTS (
    SELECT 1 FROM system_menu
    WHERE permission = 'yms:gate:driverQr'
      AND type = 3
      AND parent_id = (SELECT id FROM system_menu WHERE component = 'yms/gate-driver-qr/index' AND deleted = 0 LIMIT 1)
      AND deleted = 0
);

-- gate-trailer-link 按钮权限
INSERT INTO system_menu (name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted)
SELECT '链接查看', 'yms:gate:trailerLink', 3, 1,
       (SELECT id FROM system_menu WHERE component = 'yms/gate-trailer-link/index' AND deleted = 0 LIMIT 1),
       '', '#', '', '', 0, b'1', b'0', b'1',
       '1', NOW(), '1', NOW(), b'0'
WHERE NOT EXISTS (
    SELECT 1 FROM system_menu
    WHERE permission = 'yms:gate:trailerLink'
      AND type = 3
      AND parent_id = (SELECT id FROM system_menu WHERE component = 'yms/gate-trailer-link/index' AND deleted = 0 LIMIT 1)
      AND deleted = 0
);

SET SQL_SAFE_UPDATES = 1;

-- =============================================
-- 验证查询（执行后取消注释确认结果）
-- =============================================
-- SELECT id, name, permission, type, sort, parent_id, path, component, status, visible
-- FROM system_menu
-- WHERE component IN (
--     'yms/gate-checkin/index',
--     'yms/gate-driver-qr/index',
--     'yms/gate-trailer-link/index'
-- ) AND deleted = 0
-- ORDER BY parent_id, sort;
