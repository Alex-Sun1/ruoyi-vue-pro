-- =============================================
-- YMS 园区管理菜单分组
-- 日期：2026-05-29
-- 说明：在「园区管理」(5000) 下增加二级目录，收敛平铺菜单
-- 执行后：超级管理员/已有 YMS 权限的角色需重新登录以刷新菜单缓存
-- =============================================

-- ── 二级目录（M，component 为空 → 前端 ParentView）────────────────────
INSERT IGNORE INTO sys_menu VALUES
(5191, '监控总览', 5000, 1, 'monitor', NULL, '', 1, 0, 'M', '0', '0', '', 'dashboard', 103, 1, NOW(), NULL, NULL, '园区大屏与堆场可视化'),
(5192, '调度作业', 5000, 2, 'dispatch-work', NULL, '', 1, 0, 'M', '0', '0', '', 'monitor', 103, 1, NOW(), NULL, NULL, 'Dock调度与园区任务'),
(5193, '门岗出入', 5000, 3, 'gate-work', NULL, '', 1, 0, 'M', '0', '0', '', 'login', 103, 1, NOW(), NULL, NULL, 'Check-in / Check-out 与在场'),
(5194, '预约管理', 5000, 4, 'appointment-work', NULL, '', 1, 0, 'M', '0', '0', '', 'calendar', 103, 1, NOW(), NULL, NULL, '预约、时段与看板'),
(5195, '堆场资源', 5000, 5, 'yard-resource', NULL, '', 1, 0, 'M', '0', '0', '', 'box', 103, 1, NOW(), NULL, NULL, '海柜/车厢与堆位'),
(5196, '场内作业', 5000, 6, 'yard-operation', NULL, '', 1, 0, 'M', '0', '0', '', 'tool', 103, 1, NOW(), NULL, NULL, '院内任务与机器人'),
(5197, '规则风控', 5000, 7, 'rule-control', NULL, '', 1, 0, 'M', '0', '0', '', 'setting', 103, 1, NOW(), NULL, NULL, '叫号规则与黑名单'),
(5198, '异常盘点', 5000, 8, 'exception-audit', NULL, '', 1, 0, 'M', '0', '0', '', 'warning', 103, 1, NOW(), NULL, NULL, '异常中心与园区盘点');

-- ── 5191 监控总览 ────────────────────────────────────────────────────
UPDATE sys_menu SET parent_id = 5191, order_num = 1 WHERE menu_id = 5080;
UPDATE sys_menu SET parent_id = 5191, order_num = 2 WHERE menu_id = 5150;

-- ── 5192 调度作业（隐藏路由仍挂 5000，避免改路径）────────────────────
UPDATE sys_menu SET parent_id = 5192, order_num = 1 WHERE menu_id = 5001;
UPDATE sys_menu SET parent_id = 5192, order_num = 2 WHERE menu_id = 5004;
UPDATE sys_menu SET parent_id = 5192, order_num = 3 WHERE menu_id = 5005;
UPDATE sys_menu SET parent_id = 5192, order_num = 4 WHERE menu_id = 5006;
UPDATE sys_menu SET parent_id = 5192, order_num = 5 WHERE menu_id = 5120;

-- ── 5193 门岗出入 ────────────────────────────────────────────────────
UPDATE sys_menu SET parent_id = 5193, order_num = 1 WHERE menu_id = 5070;
UPDATE sys_menu SET parent_id = 5193, order_num = 2 WHERE menu_id = 5071;
UPDATE sys_menu SET parent_id = 5193, order_num = 3 WHERE menu_id = 5076;
UPDATE sys_menu SET parent_id = 5193, order_num = 4 WHERE menu_id = 5078;

-- 旧版「门卫操作台」已由拆分页替代，侧边栏隐藏（权限保留）
-- 使用 menu_id 子查询，兼容 MySQL safe update mode
UPDATE sys_menu SET parent_id = 5193, order_num = 99, visible = '1'
WHERE menu_id IN (
    SELECT menu_id FROM (
        SELECT menu_id FROM sys_menu
        WHERE parent_id = 5000 AND menu_type = 'C' AND component = 'yms/gate/index'
    ) _yms_gate_legacy
);

-- ── 5194 预约管理 ────────────────────────────────────────────────────
UPDATE sys_menu SET parent_id = 5194, order_num = 1
WHERE menu_id IN (
    SELECT menu_id FROM (
        SELECT menu_id FROM sys_menu
        WHERE parent_id = 5000 AND menu_type = 'C' AND component = 'yms/slot-template/index'
    ) _yms_slot_template
);
UPDATE sys_menu SET parent_id = 5194, order_num = 2
WHERE menu_id IN (
    SELECT menu_id FROM (
        SELECT menu_id FROM sys_menu
        WHERE parent_id = 5000 AND menu_type = 'C' AND component = 'yms/appointment/index'
    ) _yms_appointment
);
UPDATE sys_menu SET parent_id = 5194, order_num = 3 WHERE menu_id = 5090;
UPDATE sys_menu SET parent_id = 5194, order_num = 4 WHERE menu_id = 5100;

-- ── 5195 堆场资源 ────────────────────────────────────────────────────
UPDATE sys_menu SET parent_id = 5195, order_num = 1 WHERE menu_id = 5040;
UPDATE sys_menu SET parent_id = 5195, order_num = 2 WHERE menu_id = 5050;
-- 堆场位已收敛至基础资料，YMS 入口隐藏（数据页仍可直链）
UPDATE sys_menu SET parent_id = 5195, order_num = 3, visible = '1' WHERE menu_id = 5030;
UPDATE sys_menu SET parent_id = 5195, order_num = 4
WHERE menu_id IN (
    SELECT menu_id FROM (
        SELECT menu_id FROM sys_menu
        WHERE parent_id = 5000 AND menu_type = 'C' AND component = 'yms/zone/index'
    ) _yms_zone
);
UPDATE sys_menu SET parent_id = 5195, order_num = 5
WHERE menu_id IN (
    SELECT menu_id FROM (
        SELECT menu_id FROM sys_menu
        WHERE parent_id = 5000 AND menu_type = 'C' AND component = 'yms/dock/index'
    ) _yms_dock
);

-- ── 5196 场内作业 ────────────────────────────────────────────────────
UPDATE sys_menu SET parent_id = 5196, order_num = 1 WHERE menu_id = 5060;
UPDATE sys_menu SET parent_id = 5196, order_num = 2
WHERE menu_id IN (
    SELECT menu_id FROM (
        SELECT menu_id FROM sys_menu
        WHERE parent_id = 5000 AND menu_type = 'C' AND component = 'yms/yardgo/index'
    ) _yms_yardgo
);

-- ── 5197 规则风控 ────────────────────────────────────────────────────
UPDATE sys_menu SET parent_id = 5197, order_num = 1 WHERE menu_id = 5110;
UPDATE sys_menu SET parent_id = 5197, order_num = 2
WHERE menu_id IN (
    SELECT menu_id FROM (
        SELECT menu_id FROM sys_menu
        WHERE parent_id = 5000 AND menu_type = 'C' AND component = 'yms/blacklist/index'
    ) _yms_blacklist
);

-- ── 5198 异常盘点 ────────────────────────────────────────────────────
UPDATE sys_menu SET parent_id = 5198, order_num = 1 WHERE menu_id = 5130;
UPDATE sys_menu SET parent_id = 5198, order_num = 2 WHERE menu_id = 5140;

-- ── 为已授权 YMS 的角色补全二级目录权限 ───────────────────────────────
INSERT IGNORE INTO sys_role_menu (role_id, menu_id)
SELECT DISTINCT rm.role_id, g.menu_id
FROM sys_role_menu rm
INNER JOIN sys_menu m ON m.menu_id = rm.menu_id
CROSS JOIN (
    SELECT 5191 AS menu_id UNION ALL SELECT 5192 UNION ALL SELECT 5193 UNION ALL SELECT 5194
    UNION ALL SELECT 5195 UNION ALL SELECT 5196 UNION ALL SELECT 5197 UNION ALL SELECT 5198
) g
WHERE m.menu_id = 5000
   OR m.parent_id = 5000
   OR m.parent_id BETWEEN 5191 AND 5198;
