-- 海柜预排车数 / 预排方数：按关联预出单（非已取消）一次性回刷
-- 兼容 MySQL Workbench Safe Update Mode（WHERE 使用主键 id）
-- pre_plan_truck_qty = 预出单单数；pre_plan_cbm = actual_cbm（无则 declared_cbm）合计

-- 1) 先清零（避免 LEFT JOIN 在 safe mode 下无法更新全表）
UPDATE `oms_container_order`
SET `pre_plan_truck_qty` = 0,
    `pre_plan_pallet_qty` = 0,
    `pre_plan_cbm` = 0
WHERE `deleted` = 0
  AND `id` > 0;

-- 2) 按海柜汇总预出单后回写
UPDATE `oms_container_order` co
INNER JOIN (
    SELECT link.container_order_id,
           COUNT(DISTINCT po.id) AS truck_qty,
           SUM(
               CASE
                   WHEN po.actual_cbm IS NOT NULL AND po.actual_cbm > 0 THEN po.actual_cbm
                   ELSE IFNULL(po.declared_cbm, 0)
               END
           ) AS plan_cbm
    FROM `oms_pre_outbound` po
    INNER JOIN (
        SELECT po.id AS pre_outbound_id, c.container_order_id
        FROM `oms_pre_outbound` po
        INNER JOIN `oms_cargo_order` c ON c.id = po.cargo_order_id AND c.deleted = 0
        WHERE po.deleted = 0
          AND po.pre_outbound_status <> 'CANCELLED'
          AND c.container_order_id IS NOT NULL
        UNION
        SELECT poi.pre_outbound_id, c.container_order_id
        FROM `oms_pre_outbound_item` poi
        INNER JOIN `oms_cargo_order` c ON c.id = poi.cargo_order_id AND c.deleted = 0
        INNER JOIN `oms_pre_outbound` po ON po.id = poi.pre_outbound_id AND po.deleted = 0
        WHERE poi.deleted = 0
          AND po.pre_outbound_status <> 'CANCELLED'
          AND c.container_order_id IS NOT NULL
    ) link ON link.pre_outbound_id = po.id
    WHERE po.deleted = 0
      AND po.pre_outbound_status <> 'CANCELLED'
    GROUP BY link.container_order_id
) agg ON agg.container_order_id = co.id
SET co.pre_plan_truck_qty = agg.truck_qty,
    co.pre_plan_pallet_qty = agg.truck_qty,
    co.pre_plan_cbm = agg.plan_cbm
WHERE co.deleted = 0
  AND co.id > 0;
