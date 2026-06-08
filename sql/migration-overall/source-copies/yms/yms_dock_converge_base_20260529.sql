-- YMS 月台菜单收敛到基础资料 /yard/dock（消除 yms/dock 双维护）
-- 1. 隐藏 YMS 模块下重复的「月台管理」菜单（保留基础资料 → 堆场 → 月台管理）
--    WHERE 使用主键 menu_id，兼容 MySQL Safe Update Mode
UPDATE sys_menu
SET visible = '1',
    remark  = CONCAT(IFNULL(remark, ''), ' [已收敛至基础资料/yard/dock]')
WHERE menu_id IN (
    SELECT menu_id FROM (
        SELECT menu_id
        FROM sys_menu
        WHERE path = 'yms/dock'
          AND component = 'yms/dock/index'
    ) AS dock_menu
);

-- 2. 若环境中 YMS 月台菜单尚未创建，上述 UPDATE 影响 0 行，可忽略；请直接使用「基础资料 → 月台管理」

-- 3. 兼容旧书签 /yms/dock：前端路由已指向 yard/dock 页面组件
