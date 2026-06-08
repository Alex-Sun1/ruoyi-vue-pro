-- OMS 菜单去重修复（解决「订单追踪」+「货物订单」重复显示）
-- 场景：init 把 6902 改成订单追踪，reference-permission-sync-patch 又插入了货物订单
-- 执行后重新跑 oms-supplement.sql，并在角色管理里刷新 OMS 授权
-- 兼容 MySQL Workbench Safe Update Mode

SET NAMES utf8mb4;
SET SQL_SAFE_UPDATES = 0;

-- 1) 删除非 6902 的重复「货物订单」页面
DELETE rm FROM `system_role_menu` rm
INNER JOIN `system_menu` m ON m.`id` = rm.`menu_id`
WHERE m.`permission` = 'oms:cargoOrder:list'
  AND m.`id` <> 6902
  AND m.`deleted` = b'0';

DELETE FROM `system_menu`
WHERE `permission` = 'oms:cargoOrder:list'
  AND `id` <> 6902
  AND `deleted` = b'0';

-- 2) 删除孤立的「订单追踪」页面（旧 path / 旧 permission）
DELETE rm FROM `system_role_menu` rm
INNER JOIN `system_menu` m ON m.`id` = rm.`menu_id`
WHERE m.`deleted` = b'0'
  AND m.`type` = 2
  AND m.`parent_id` = 6900
  AND (
      m.`name` = '订单追踪'
      OR m.`path` = 'order-tracking'
      OR m.`permission` = 'oms:order:list'
  )
  AND m.`id` <> 6902;

DELETE FROM `system_menu`
WHERE `deleted` = b'0'
  AND `type` = 2
  AND `parent_id` = 6900
  AND (
      `name` = '订单追踪'
      OR `path` = 'order-tracking'
      OR `permission` = 'oms:order:list'
  )
  AND `id` <> 6902;

-- 3) 6902 统一为「货物订单」（与参考系统 / 前端一致）
UPDATE `system_menu`
SET `name` = '货物订单',
    `permission` = 'oms:cargoOrder:list',
    `path` = 'cargo-order',
    `icon` = 'ep:tickets',
    `component` = 'oms/cargo-order/index',
    `component_name` = 'OmsCargoOrder',
    `keep_alive` = b'1',
    `visible` = b'1',
    `updater` = 'admin',
    `update_time` = NOW()
WHERE `id` = 6902;

-- 3.1) 6901 统一为「海柜订单」（旧脚本误写为「柜单管理」）
UPDATE `system_menu`
SET `name` = '海柜订单',
    `updater` = 'admin',
    `update_time` = NOW()
WHERE `id` = 6901;

SET SQL_SAFE_UPDATES = 1;

-- 4) 验证
-- SELECT id, name, permission, path, icon FROM system_menu
-- WHERE parent_id = 6900 AND type = 2 AND deleted = b'0' ORDER BY sort;
