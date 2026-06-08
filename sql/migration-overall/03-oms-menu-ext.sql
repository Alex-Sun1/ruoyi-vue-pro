-- OMS 菜单扩展（出库/入库计划/分组规则/事件日志）
-- 依赖：已执行 sql/mysql/oms-menu.sql（6900 根目录）
-- 本脚本 ID：6950~6999；可重复执行

SET NAMES utf8mb4;

-- ========== 新增页面 ==========
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`,
                           `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`,
                           `create_time`, `updater`, `update_time`, `deleted`)
VALUES
    (6950, '入库计划', 'wms:inboundPlan:list', 2, 5, 6900, 'inbound-plan', 'ep:upload',
     'oms/inbound-plan/index', 'OmsInboundPlan', 0, b'1', b'0', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6951, '预出单', 'oms:preOutbound:list', 2, 6, 6900, 'pre-outbound', 'ep:document',
     'oms/pre-outbound/index', 'OmsPreOutbound', 0, b'1', b'0', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6952, '出单工作台', 'oms:outboundPool:list', 2, 7, 6900, 'outbound-pool', 'ep:shopping-cart',
     'oms/outbound-pool/index', 'OmsOutboundPool', 0, b'1', b'0', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6953, '出库订单', 'oms:outboundOrder:list', 2, 8, 6900, 'outbound-order', 'ep:sell',
     'oms/outbound-order/index', 'OmsOutboundOrder', 0, b'1', b'0', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6954, '分组规则', 'oms:cargoGroupingRule:list', 2, 9, 6900, 'cargo-grouping-rule', 'ep:setting',
     'oms/cargo-grouping-rule/index', 'OmsCargoGroupingRule', 0, b'1', b'0', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6955, '事件日志', 'oms:event-log:view', 2, 10, 6900, 'event-log', 'ep:document',
     'oms/biz-event/index', 'OmsBizEventLog', 0, b'1', b'0', b'1', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`), `permission` = VALUES(`permission`), `sort` = VALUES(`sort`),
    `path` = VALUES(`path`), `icon` = VALUES(`icon`), `component` = VALUES(`component`),
    `component_name` = VALUES(`component_name`), `keep_alive` = VALUES(`keep_alive`),
    `updater` = 'admin', `update_time` = NOW(), `deleted` = b'0';

-- ========== 按钮权限 ==========
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`,
                           `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`,
                           `create_time`, `updater`, `update_time`, `deleted`)
VALUES
    -- 入库计划
    (6961, '自动分组', 'wms:inboundPlan:autoGroup', 3, 1, 6950, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6962, '应用规则', 'wms:inboundPlan:applyRule', 3, 2, 6950, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6963, '开始作业', 'wms:inboundPlan:startWork', 3, 3, 6950, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6964, '完成计划', 'wms:inboundPlan:complete', 3, 4, 6950, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    -- 预出单
    (6971, '预出单查询', 'oms:preOutbound:query', 3, 1, 6951, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6972, '转出库单', 'oms:preOutbound:convert', 3, 2, 6951, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6973, '预出单编辑', 'oms:preOutbound:edit', 3, 3, 6951, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    -- 出单工作台
    (6981, '创建预出单', 'oms:outboundPool:createPreOutbound', 3, 1, 6952, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6982, '创建出库单', 'oms:outboundPool:createOutboundOrder', 3, 2, 6952, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6983, '批量预出单', 'oms:outboundPool:batchCreatePreOutbound', 3, 3, 6952, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6984, '批量出库单', 'oms:outboundPool:batchCreateOutboundOrder', 3, 4, 6952, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    -- 出库订单
    (6991, '出库单查询', 'oms:outboundOrder:query', 3, 1, 6953, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6992, '出库单编辑', 'oms:outboundOrder:edit', 3, 2, 6953, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6993, '出库完成', 'oms:outboundOrder:complete', 3, 3, 6953, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    -- 分组规则
    (6994, '规则查询', 'oms:cargoGroupingRule:query', 3, 1, 6954, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6995, '规则新增', 'oms:cargoGroupingRule:add', 3, 2, 6954, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6996, '规则编辑', 'oms:cargoGroupingRule:edit', 3, 3, 6954, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6997, '规则删除', 'oms:cargoGroupingRule:remove', 3, 4, 6954, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6998, '规则测试', 'oms:cargoGroupingRule:test', 3, 5, 6954, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
    (6999, '规则启用', 'oms:cargoGroupingRule:enable', 3, 6, 6954, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0')
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`), `permission` = VALUES(`permission`), `parent_id` = VALUES(`parent_id`),
    `updater` = 'admin', `update_time` = NOW(), `deleted` = b'0';

-- ========== 可选：超级管理员授权 ==========
-- INSERT INTO `system_role_menu` (`role_id`, `menu_id`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`)
-- SELECT 1, id, 'admin', NOW(), 'admin', NOW(), b'0', 1 FROM `system_menu` WHERE id BETWEEN 6950 AND 6999 AND deleted = b'0';
