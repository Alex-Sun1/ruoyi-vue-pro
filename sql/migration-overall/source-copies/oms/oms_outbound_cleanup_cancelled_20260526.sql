-- ============================================================
-- 清理历史 CANCELLED 出库单 & 预出单脏数据
-- 背景：旧 cancel() 逻辑只改状态不删记录，导致数据残留
-- 执行顺序：先重置货物订单状态，再逻辑删除单据
-- ============================================================

SET SQL_SAFE_UPDATES = 0;

-- ============================================================
-- Part 1: 清理 CANCELLED 出库单
-- 旧逻辑：outbound_order.outbound_status = 'CANCELLED'
--         cargo_order.outbound_order_status = 'CANCELLED'（未重置）
--         cargo_order.fulfillment_status = 'OUTBOUND_ORDERED'（未重置）
-- ============================================================

-- Step 1-1: 通过 items 表重置货物订单 → 弹回出单工作台
UPDATE oms_cargo_order co
  INNER JOIN oms_outbound_order_item oi ON co.id = oi.cargo_order_id AND oi.deleted = 0
  INNER JOIN oms_outbound_order o ON oi.outbound_order_id = o.id
SET co.outbound_order_status = 'NONE',
    co.outbound_batch_no     = NULL,
    co.outbound_order_time   = NULL,
    co.fulfillment_status    = 'INBOUNDED',
    co.pre_outbound_status   = 'NONE',
    co.pre_outbound_no       = NULL,
    co.pre_outbound_flag     = 0,
    co.update_time           = NOW()
WHERE o.outbound_status = 'CANCELLED'
  AND o.deleted = 0
  AND o.id > 0;

-- Step 1-2: 逻辑删除 items
UPDATE oms_outbound_order_item oi
  INNER JOIN oms_outbound_order o ON oi.outbound_order_id = o.id
SET oi.deleted      = 1,
    oi.update_time  = NOW()
WHERE o.outbound_status = 'CANCELLED'
  AND o.deleted = 0
  AND o.id > 0;

-- Step 1-3: 逻辑删除出库单
UPDATE oms_outbound_order
SET deleted     = 1,
    update_time = NOW()
WHERE outbound_status = 'CANCELLED'
  AND deleted = 0
  AND id > 0;

-- ============================================================
-- Part 2: 清理 CANCELLED 预出单
-- 旧逻辑：pre_outbound.pre_outbound_status = 'CANCELLED'
--         货物订单已由旧 cancel() 正确重置（pre_outbound_status=NONE）
--         只需删除单据本身
-- ============================================================

-- Step 2-1: 逻辑删除 items
UPDATE oms_pre_outbound_item pi
  INNER JOIN oms_pre_outbound p ON pi.pre_outbound_id = p.id
SET pi.deleted     = 1,
    pi.update_time = NOW()
WHERE p.pre_outbound_status = 'CANCELLED'
  AND p.deleted = 0
  AND p.id > 0;

-- Step 2-2: 逻辑删除预出单
UPDATE oms_pre_outbound
SET deleted     = 1,
    update_time = NOW()
WHERE pre_outbound_status = 'CANCELLED'
  AND deleted = 0
  AND id > 0;

-- ============================================================
-- Part 3: 清理 CONVERTED 预出单（转单后应随之删除，历史遗留）
-- 对应出库单已存在，货物订单状态正常，只需删除预出单记录
-- ============================================================

-- Step 3-1: 逻辑删除 items
UPDATE oms_pre_outbound_item pi
  INNER JOIN oms_pre_outbound p ON pi.pre_outbound_id = p.id
SET pi.deleted     = 1,
    pi.update_time = NOW()
WHERE p.pre_outbound_status = 'CONVERTED'
  AND p.deleted = 0
  AND p.id > 0;

-- Step 3-2: 逻辑删除预出单
UPDATE oms_pre_outbound
SET deleted     = 1,
    update_time = NOW()
WHERE pre_outbound_status = 'CONVERTED'
  AND deleted = 0
  AND id > 0;

SET SQL_SAFE_UPDATES = 1;

-- 验证：执行后以下查询应全部返回 0
SELECT COUNT(*) AS remaining_cancelled_outbound  FROM oms_outbound_order  WHERE outbound_status   = 'CANCELLED' AND deleted = 0;
SELECT COUNT(*) AS remaining_cancelled_pre        FROM oms_pre_outbound    WHERE pre_outbound_status = 'CANCELLED' AND deleted = 0;
SELECT COUNT(*) AS remaining_converted_pre        FROM oms_pre_outbound    WHERE pre_outbound_status = 'CONVERTED' AND deleted = 0;
