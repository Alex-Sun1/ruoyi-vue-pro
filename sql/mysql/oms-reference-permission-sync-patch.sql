-- Align OMS menu permissions with the reference system.
-- Idempotent: safe to execute repeatedly.

SET @oms_parent_id := (SELECT id FROM system_menu WHERE permission = '' AND path = '/oms' AND name = 'OMS' AND deleted = b'0' LIMIT 1);

-- Main cargo order page is missing in the target menu tree.
INSERT INTO system_menu (
    name, permission, type, sort, parent_id, path, icon, component, component_name,
    status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted
)
SELECT '货物订单', 'oms:cargoOrder:list', 2, 2, @oms_parent_id, 'cargo-order', '#',
       'oms/cargo-order/index', 'OmsCargoOrder', 0, b'1', b'0', b'1',
       'system', NOW(), 'system', NOW(), b'0'
WHERE @oms_parent_id IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM system_menu WHERE permission = 'oms:cargoOrder:list' AND deleted = b'0'
  );

SET @cargo_order_menu_id := (SELECT id FROM system_menu WHERE permission = 'oms:cargoOrder:list' AND deleted = b'0' LIMIT 1);
SET @container_order_menu_id := (SELECT id FROM system_menu WHERE permission = 'oms:containerOrder:list' AND deleted = b'0' LIMIT 1);
SET @inbound_plan_menu_id := (SELECT id FROM system_menu WHERE permission = 'wms:inboundPlan:list' AND deleted = b'0' LIMIT 1);
SET @pre_outbound_menu_id := (SELECT id FROM system_menu WHERE permission = 'oms:preOutbound:list' AND deleted = b'0' LIMIT 1);
SET @outbound_order_menu_id := (SELECT id FROM system_menu WHERE permission = 'oms:outboundOrder:list' AND deleted = b'0' LIMIT 1);
SET @grouping_rule_menu_id := (SELECT id FROM system_menu WHERE permission = 'oms:cargoGroupingRule:list' AND deleted = b'0' LIMIT 1);

INSERT INTO system_menu (
    name, permission, type, sort, parent_id, path, icon, component, component_name,
    status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted
)
SELECT item.name, item.permission, 3, item.sort_no, item.parent_id, '', '', '', NULL,
       0, b'1', b'1', b'1', 'system', NOW(), 'system', NOW(), b'0'
FROM (
    SELECT '导入货物订单' AS name, 'oms:cargoOrder:import' AS permission, 30 AS sort_no, @cargo_order_menu_id AS parent_id
    UNION ALL SELECT '新增货物订单', 'oms:cargoOrder:add', 10, @cargo_order_menu_id
    UNION ALL SELECT '编辑货物订单', 'oms:cargoOrder:edit', 20, @cargo_order_menu_id
    UNION ALL SELECT '删除货物订单', 'oms:cargoOrder:remove', 40, @cargo_order_menu_id
    UNION ALL SELECT '海柜入库计划', 'oms:containerOrder:inboundPlan', 80, @container_order_menu_id
    UNION ALL SELECT '取消入库计划', 'wms:inboundPlan:cancel', 50, @inbound_plan_menu_id
    UNION ALL SELECT '分组字段查询', 'oms:cargoGroupingFieldMeta:list', 70, @grouping_rule_menu_id
    UNION ALL SELECT '预出单取消', 'oms:preOutbound:cancel', 40, @pre_outbound_menu_id
    UNION ALL SELECT '出库订单取消', 'oms:outboundOrder:cancel', 40, @outbound_order_menu_id
) item
WHERE item.parent_id IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM system_menu existing
      WHERE existing.permission = item.permission AND existing.deleted = b'0'
  );

-- Keep the old container button permissions, but also add the new permissions used by the OMS module.
INSERT INTO system_menu (
    name, permission, type, sort, parent_id, path, icon, component, component_name,
    status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted
)
SELECT item.name, item.permission, 3, item.sort_no, @container_order_menu_id, '', '', '', NULL,
       0, b'1', b'1', b'1', 'system', NOW(), 'system', NOW(), b'0'
FROM (
    SELECT '柜单新增' AS name, 'oms:containerOrder:add' AS permission, 10 AS sort_no
    UNION ALL SELECT '柜单编辑', 'oms:containerOrder:edit', 20
    UNION ALL SELECT '柜单删除', 'oms:containerOrder:remove', 30
    UNION ALL SELECT '柜单导出', 'oms:containerOrder:export', 40
    UNION ALL SELECT '导入关联货物', 'oms:containerOrder:importCargo', 50
) item
WHERE @container_order_menu_id IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM system_menu existing
      WHERE existing.permission = item.permission AND existing.deleted = b'0'
  );

-- Grant the new permissions to admin roles so the pages/buttons are available immediately.
INSERT INTO system_role_menu (
    role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id
)
SELECT r.id, m.id, 'system', NOW(), 'system', NOW(), b'0', r.tenant_id
FROM system_role r
JOIN system_menu m ON m.deleted = b'0'
WHERE r.deleted = b'0'
  AND r.code IN ('super_admin', 'tenant_admin')
  AND m.permission IN (
      'oms:cargoOrder:list',
      'oms:cargoOrder:add',
      'oms:cargoOrder:edit',
      'oms:cargoOrder:remove',
      'oms:cargoOrder:import',
      'oms:containerOrder:add',
      'oms:containerOrder:edit',
      'oms:containerOrder:remove',
      'oms:containerOrder:export',
      'oms:containerOrder:importCargo',
      'oms:containerOrder:inboundPlan',
      'wms:inboundPlan:cancel',
      'oms:cargoGroupingFieldMeta:list',
      'oms:preOutbound:cancel',
      'oms:outboundOrder:cancel'
  )
  AND NOT EXISTS (
      SELECT 1 FROM system_role_menu rm
      WHERE rm.role_id = r.id
        AND rm.menu_id = m.id
        AND rm.deleted = b'0'
        AND rm.tenant_id = r.tenant_id
  );
