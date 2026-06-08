-- =============================================
-- YMS 菜单二级分组重构
-- 日期：2026-05-30
-- 说明：
--   1. 将扁平的 14 个菜单重组为 4 个二级目录（门岗操作/调度管理/资源管理/作业管理）
--   2. 删除堆场位管理（废弃，实际业务全走 yard_dock）
--   3. 司机签到码前端未建，暂设为不可见
-- =============================================

SET SQL_SAFE_UPDATES = 0;

-- =============================================
-- PART 1：新增四个二级目录
-- =============================================

INSERT IGNORE INTO sys_menu VALUES(
    5160, '门岗操作', 5000, 2, 'gate-group', NULL, '', 1, 0, 'M', '0', '0', '',
    'check-square', 103, 1, NOW(), NULL, NULL, '门岗签入/签出管理'
);
INSERT IGNORE INTO sys_menu VALUES(
    5161, '调度管理', 5000, 3, 'dispatch-group', NULL, '', 1, 0, 'M', '0', '0', '',
    'monitor', 103, 1, NOW(), NULL, NULL, '调度与任务管理'
);
INSERT IGNORE INTO sys_menu VALUES(
    5162, '资源管理', 5000, 4, 'resource-group', NULL, '', 1, 0, 'M', '0', '0', '',
    'ep:box', 103, 1, NOW(), NULL, NULL, '海柜/车厢资源'
);
INSERT IGNORE INTO sys_menu VALUES(
    5163, '作业管理', 5000, 5, 'operation-group', NULL, '', 1, 0, 'M', '0', '0', '',
    'ep:list', 103, 1, NOW(), NULL, NULL, '院内任务与园区盘点'
);

-- =============================================
-- PART 2：移动菜单到对应目录
-- =============================================

-- 园区总览 保持在 5000 直属，排序第 1
UPDATE sys_menu SET parent_id = 5000, order_num = 1, visible = '0' WHERE menu_id = 5080;

-- 门岗操作（5160）
UPDATE sys_menu SET parent_id = 5160, order_num = 1, visible = '0' WHERE menu_id = 5068; -- 统一Check-in
UPDATE sys_menu SET parent_id = 5160, order_num = 2, visible = '1' WHERE menu_id = 5085; -- 司机签到码（前端未建，先隐藏）
UPDATE sys_menu SET parent_id = 5160, order_num = 3, visible = '0' WHERE menu_id = 5076; -- 在场列表
UPDATE sys_menu SET parent_id = 5160, order_num = 4, visible = '0' WHERE menu_id = 5078; -- Check-out离场

-- 调度管理（5161）
UPDATE sys_menu SET parent_id = 5161, order_num = 1, visible = '0' WHERE menu_id = 5001; -- 园区调度
UPDATE sys_menu SET parent_id = 5161, order_num = 2, visible = '0' WHERE menu_id = 5004; -- 任务管理
UPDATE sys_menu SET parent_id = 5161, order_num = 3, visible = '0' WHERE menu_id = 5005; -- 拆柜调度
UPDATE sys_menu SET parent_id = 5161, order_num = 4, visible = '0' WHERE menu_id = 5006; -- 装车调度
-- 调度隐藏子页一并移过来（路由跳转用，不显示在菜单）
UPDATE sys_menu SET parent_id = 5161, visible = '1' WHERE menu_id IN (5002, 5003);

-- 资源管理（5162）
UPDATE sys_menu SET parent_id = 5162, order_num = 1, visible = '0' WHERE menu_id = 5040; -- 海柜资源
UPDATE sys_menu SET parent_id = 5162, order_num = 2, visible = '0' WHERE menu_id = 5050; -- 车厢资源

-- 作业管理（5163）
UPDATE sys_menu SET parent_id = 5163, order_num = 1, visible = '0' WHERE menu_id = 5060; -- 院内任务
UPDATE sys_menu SET parent_id = 5163, order_num = 2, visible = '0' WHERE menu_id = 5140; -- 园区盘点

-- =============================================
-- PART 3：删除堆场位管理（废弃）
-- yms_yard_position 表从未被业务代码使用，
-- 停车位/堆场位统一在 yard_dock（基础数据-月台设置）中管理
-- =============================================

DELETE FROM sys_role_menu WHERE menu_id IN (5030, 5031, 5032, 5033, 5034);
DELETE FROM sys_menu        WHERE menu_id IN (5030, 5031, 5032, 5033, 5034);

SET SQL_SAFE_UPDATES = 1;

-- =============================================
-- 验证查询
-- =============================================
-- SELECT m.menu_id, m.menu_name, m.parent_id, p.menu_name AS parent_name,
--        m.order_num, m.visible, m.component
-- FROM sys_menu m
-- LEFT JOIN sys_menu p ON m.parent_id = p.menu_id
-- WHERE m.menu_id BETWEEN 5000 AND 5199
--    OR m.menu_id IN (5160,5161,5162,5163)
-- ORDER BY COALESCE(m.parent_id,0), m.order_num;
