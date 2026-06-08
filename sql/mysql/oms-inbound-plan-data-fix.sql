-- 入库计划无明细修复（可重复执行）
-- 场景：重跑 oms-business-mock-data 后货件被删重建，或货物订单 container_order_id 未回填
SET NAMES utf8mb4;
SET @tid = 1;

SET SQL_SAFE_UPDATES = 0;

-- 1. 从海柜关系表回填货物订单上的海柜关联
UPDATE `oms_cargo_order` co
INNER JOIN `oms_container_cargo_order_rel` rel
        ON rel.`cargo_order_id` = co.`id`
       AND rel.`deleted` = 0
       AND rel.`tenant_id` = co.`tenant_id`
INNER JOIN `oms_container_order` ctr
        ON ctr.`id` = rel.`container_order_id`
       AND ctr.`deleted` = 0
SET co.`container_order_id` = rel.`container_order_id`,
    co.`container_no` = COALESCE(NULLIF(co.`container_no`, ''), rel.`container_no`, ctr.`container_no`),
    co.`inbound_warehouse_id` = COALESCE(co.`inbound_warehouse_id`, ctr.`warehouse_id`),
    co.`inbound_warehouse_name` = COALESCE(NULLIF(co.`inbound_warehouse_name`, ''), ctr.`inbound_warehouse_name`),
    co.`updater` = 'admin',
    co.`update_time` = NOW()
WHERE co.`deleted` = 0
  AND co.`tenant_id` = @tid
  AND (co.`container_order_id` IS NULL OR co.`container_order_id` = 0);

-- 2. 删除指向已不存在货件的入库计划明细
DELETE i
FROM `wms_inbound_plan_item` i
LEFT JOIN `oms_cargo_order_shipment` s
       ON s.`id` = i.`shipment_id`
      AND s.`deleted` = 0
WHERE i.`deleted` = 0
  AND i.`tenant_id` = @tid
  AND (i.`shipment_id` IS NULL OR s.`id` IS NULL);

-- 3. 货物订单有汇总货件号但无货件层记录时，补一条货件（入库计划依赖 oms_cargo_order_shipment）
-- id 无自增：用 3480000 + cargo_order_id 生成稳定主键，避开 mock 段 34001~34999 冲突
INSERT INTO `oms_cargo_order_shipment` (
    `id`, `cargo_order_id`, `biz_root_id`, `shipment_no`, `po_no`, `shipping_mark`,
    `carton_qty`, `pallet_qty`, `weight`, `cbm`, `dw_time`,
    `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`
)
SELECT
    3480000 + co.`id`,
    co.`id`,
    co.`biz_root_id`,
    TRIM(SUBSTRING_INDEX(co.`shipment_codes`, ',', 1)),
    NULLIF(TRIM(SUBSTRING_INDEX(co.`po_nos`, ',', 1)), ''),
    NULLIF(TRIM(SUBSTRING_INDEX(co.`marks`, ',', 1)), ''),
    COALESCE(co.`actual_carton_qty`, co.`declared_carton_qty`, 0),
    COALESCE(co.`actual_pallet_qty`, co.`declared_pallet_qty`, 0),
    COALESCE(co.`actual_weight`, co.`declared_weight`, 0),
    COALESCE(co.`actual_cbm`, co.`declared_cbm`, 0),
    co.`earliest_dw_time`,
    'admin', NOW(), 'admin', NOW(), b'0', co.`tenant_id`
FROM `oms_cargo_order` co
WHERE co.`deleted` = 0
  AND co.`tenant_id` = @tid
  AND co.`shipment_codes` IS NOT NULL
  AND TRIM(co.`shipment_codes`) != ''
  AND (
    co.`container_order_id` BETWEEN 31001 AND 31999
    OR co.`id` IN (
        SELECT `cargo_order_id` FROM `oms_container_cargo_order_rel`
        WHERE `container_order_id` BETWEEN 31001 AND 31999 AND `deleted` = 0
    )
  )
  AND NOT EXISTS (
      SELECT 1 FROM `oms_cargo_order_shipment` s
      WHERE s.`cargo_order_id` = co.`id` AND s.`deleted` = 0
  );

-- 4. 演示海柜（31001~31999）清空旧计划，下次打开入库计划会按货件重新生成
DELETE FROM `wms_inbound_plan_change_log`
WHERE `plan_id` IN (
    SELECT `id` FROM `wms_inbound_plan`
    WHERE `tenant_id` = @tid AND `container_order_id` BETWEEN 31001 AND 31999
);
DELETE FROM `wms_inbound_plan_item`
WHERE `plan_id` IN (
    SELECT `id` FROM `wms_inbound_plan`
    WHERE `tenant_id` = @tid AND `container_order_id` BETWEEN 31001 AND 31999
);
DELETE FROM `wms_inbound_plan`
WHERE `tenant_id` = @tid AND `container_order_id` BETWEEN 31001 AND 31999;

SET SQL_SAFE_UPDATES = 1;
