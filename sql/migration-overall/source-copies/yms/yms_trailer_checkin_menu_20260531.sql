-- =============================================
-- 装车 Check-in 菜单
-- 日期：2026-05-31
-- 说明：
--   1. 将 5085 "司机签到码" 改名为 "海柜 Check-in" 并设为可见
--   2. 新增 5170 "装车 Check-in" 到门岗操作（5160）
-- =============================================

SET SQL_SAFE_UPDATES = 0;

-- =============================================
-- PART 1：5085 "司机签到码" → "海柜 Check-in"
-- 前端 gate-driver-qr 页已改版，仅用于海柜，设为可见
-- =============================================

UPDATE sys_menu
SET menu_name = '海柜 Check-in',
    visible   = '0',
    remark    = '海柜司机自助签到二维码管理（每个仓库独立二维码）'
WHERE menu_id = 5085;

UPDATE sys_menu
SET menu_name = '海柜签到码查看'
WHERE menu_id = 5086;

-- =============================================
-- PART 2：新增 5170 "装车 Check-in" 业务页面
-- 父节点：5160 门岗操作，排在海柜 Check-in 之后
-- 组件指向实际 H5 登记页（h5-trailer-checkin），可直接测试
-- =============================================

INSERT IGNORE INTO sys_menu VALUES(
    5170, '装车 Check-in', 5160, 3,
    'h5/trailer-checkin', 'yms/h5-trailer-checkin/index',
    '', 1, 0, 'C', '0', '0', 'yms:gate:trailerCheckin',
    'ep:truck', 103, 1, NOW(), NULL, NULL,
    '装车司机预登记页（提货号查派送信息 + 填写司机信息）'
);

-- 按钮权限（页面访问）
INSERT IGNORE INTO sys_menu VALUES(
    5171, '预登记访问', 5170, 1,
    '#', '', '', 1, 0, 'F', '0', '0', 'yms:gate:trailerCheckin',
    '#', 103, 1, NOW(), NULL, NULL, ''
);

SET SQL_SAFE_UPDATES = 1;

-- =============================================
-- 验证查询
-- =============================================
-- SELECT menu_id, menu_name, parent_id, order_num, visible, component
-- FROM sys_menu
-- WHERE menu_id IN (5160, 5085, 5086, 5170, 5171)
-- ORDER BY parent_id, order_num;
