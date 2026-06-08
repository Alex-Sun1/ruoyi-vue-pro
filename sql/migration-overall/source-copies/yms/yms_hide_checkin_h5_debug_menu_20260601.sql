-- =============================================
-- YMS 菜单调整：隐藏后台海柜/装车 H5 Check-in 调试入口
-- 日期：2026-06-01
-- 说明：
--   1. 后台「门岗操作」下不再显示海柜 Check-in、装车 Check-in 页面。
--   2. H5 直达地址继续保留，可通过浏览器直接访问：
--      /h5/yard/driver-checkin
--      /h5/yard/trailer-checkin
--   3. 「司机签到码」页面保留，用于生成海柜 Check-in 和 YardGo 二维码。
-- =============================================

SET SQL_SAFE_UPDATES = 0;

-- 隐藏最新的 H5 调试菜单：5087=海柜 Check-in，5170=装车 Check-in，5171=装车 Check-in 权限按钮
UPDATE sys_menu
SET visible = '1',
    status = '1',
    update_by = 1,
    update_time = NOW(),
    remark = CONCAT(COALESCE(remark, ''), '；2026-06-01 已隐藏：H5 页面改为直接访问调试，不再放入后台菜单')
WHERE menu_id IN (5087, 5170, 5171);

-- 兼容早期拆分菜单：如果历史库里还存在老的海柜/装车 Check-in 菜单，也一并隐藏。
UPDATE sys_menu
SET visible = '1',
    status = '1',
    update_by = 1,
    update_time = NOW(),
    remark = CONCAT(COALESCE(remark, ''), '；2026-06-01 已隐藏：后台不再保留单独 Check-in 调试页')
WHERE menu_id IN (5070, 5071, 5072, 5073, 5074, 5075)
   OR component IN (
        'yms/h5-driver-checkin/index',
        'yms/h5-trailer-checkin/index',
        'yms/gate-container-checkin/index',
        'yms/gate-loading-checkin/index'
      )
   OR path IN (
        'h5-driver-checkin',
        'h5-trailer-checkin',
        'h5/trailer-checkin',
        'gate-container-checkin',
        'gate-loading-checkin'
      );

SET SQL_SAFE_UPDATES = 1;

-- 验证：
-- SELECT menu_id, menu_name, parent_id, path, component, visible, status
-- FROM sys_menu
-- WHERE menu_id IN (5070,5071,5072,5073,5074,5075,5085,5086,5087,5170,5171)
-- ORDER BY menu_id;
