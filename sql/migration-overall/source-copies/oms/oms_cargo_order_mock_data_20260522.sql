-- =============================================================
-- 货物订单模拟数据 v1.0  (2026-05-22)
-- 依赖：oms_container_order_mock_data_20260522.sql 已执行
--
-- 海柜订单对应关系：
--   9100001  SO202605220001  TGHU1234567  IN_TRANSIT  LAX  Pacific Home Goods LLC
--   9100002  SO202605220002  MSCU7654321  HOLDING     LAX  Northstar Outdoor Inc.
--   9100003  SO202605220003  OOLU4567890  DEVANNING   NJ   East Market Supply Co.
--
-- ID 段分配：
--   biz_root                    9150001 – 9150007
--   oms_cargo_order             9200001 – 9200007
--   oms_cargo_order_shipment    9210001 – 9210011
--   oms_cargo_order_sku_item    9220001 – 9220024
--   oms_cargo_order_node_trace  9230001 – 9230032
--   oms_container_cargo_order_rel 9240001 – 9240007
-- =============================================================


-- ============================================================
-- 1. 业务主线 biz_root（每个货物订单对应一条）
-- ============================================================
INSERT IGNORE INTO `biz_root` (
  `id`, `tenant_id`, `company_id`, `warehouse_id`, `root_no`, `root_type`,
  `source_module`, `source_order_id`, `source_order_no`,
  `customer_id`, `customer_name`, `channel_id`, `business_type_id`,
  `current_module`, `current_node`, `current_node_name`, `current_node_time`,
  `root_status`, `exception_flag`, `exception_count`,
  `start_time`, `remark`,
  `create_by`, `create_time`, `update_by`, `update_time`, `deleted`
) VALUES
-- CO001：Pacific Home Goods - Amazon RNO8，在途
(9150001, '000000', 4000001, 4001001, 'BIZ202605150001', 'CARGO',
 'OMS', 9200001, 'CO202605150001',
 8001001, 'Pacific Home Goods LLC', 5001001, 5002001,
 'OMS', 'IN_TRANSIT', '在途', '2026-05-15 14:00:00',
 'RUNNING', 0, 0,
 '2026-05-15 09:00:00', NULL,
 1, '2026-05-15 09:00:00', 1, '2026-05-15 14:00:00', 0),

-- CO002：Pacific Home Goods - 私仓 LA，在途
(9150002, '000000', 4000001, 4001001, 'BIZ202605150002', 'CARGO',
 'OMS', 9200002, 'CO202605150002',
 8001001, 'Pacific Home Goods LLC', 5001001, 5002001,
 'OMS', 'IN_TRANSIT', '在途', '2026-05-15 14:00:00',
 'RUNNING', 0, 0,
 '2026-05-15 09:30:00', NULL,
 1, '2026-05-15 09:30:00', 1, '2026-05-15 14:00:00', 0),

-- CO003：Northstar Outdoor - Amazon SBD1，已到港，有Hold异常
(9150003, '000000', 4000001, 4001001, 'BIZ202605100001', 'CARGO',
 'OMS', 9200003, 'CO202605100001',
 8001002, 'Northstar Outdoor Inc.', 5001002, 5002001,
 'OMS', 'ARRIVED_PORT', '已到港', '2026-05-20 11:20:00',
 'RUNNING', 1, 1,
 '2026-05-10 10:00:00', NULL,
 1, '2026-05-10 10:00:00', 1, '2026-05-20 11:20:00', 0),

-- CO004：Northstar Outdoor - Walmart DC，已到港
(9150004, '000000', 4000001, 4001001, 'BIZ202605100002', 'CARGO',
 'OMS', 9200004, 'CO202605100002',
 8001002, 'Northstar Outdoor Inc.', 5001002, 5002001,
 'OMS', 'ARRIVED_PORT', '已到港', '2026-05-20 11:20:00',
 'RUNNING', 0, 0,
 '2026-05-10 10:30:00', NULL,
 1, '2026-05-10 10:30:00', 1, '2026-05-20 11:20:00', 0),

-- CO005：East Market Supply - Amazon EWR4，拆柜中
(9150005, '000000', 4000001, 4001002, 'BIZ202605050001', 'CARGO',
 'OMS', 9200005, 'CO202605050001',
 8001003, 'East Market Supply Co.', 5001001, 5002002,
 'OMS', 'DEVANNING', '拆柜中', '2026-05-22 10:15:00',
 'RUNNING', 0, 0,
 '2026-05-05 11:00:00', NULL,
 1, '2026-05-05 11:00:00', 1, '2026-05-22 10:15:00', 0),

-- CO006：East Market Supply - Amazon EWR9，拆柜完成
(9150006, '000000', 4000001, 4001002, 'BIZ202605050002', 'CARGO',
 'OMS', 9200006, 'CO202605050002',
 8001003, 'East Market Supply Co.', 5001001, 5002002,
 'OMS', 'DEVANNED', '拆柜完成', '2026-05-22 11:30:00',
 'RUNNING', 0, 0,
 '2026-05-05 11:30:00', NULL,
 1, '2026-05-05 11:30:00', 1, '2026-05-22 11:30:00', 0),

-- CO007：East Market Supply - Amazon EWR4，已入库+预出单
(9150007, '000000', 4000001, 4001002, 'BIZ202605050003', 'CARGO',
 'OMS', 9200007, 'CO202605050003',
 8001003, 'East Market Supply Co.', 5001001, 5002002,
 'OMS', 'INBOUNDED', '已入库', '2026-05-22 14:00:00',
 'RUNNING', 0, 0,
 '2026-05-05 12:00:00', NULL,
 1, '2026-05-05 12:00:00', 1, '2026-05-22 15:00:00', 0);


-- ============================================================
-- 2. 货物订单主表
-- ============================================================
INSERT IGNORE INTO `oms_cargo_order` (
  `id`, `tenant_id`, `company_id`, `biz_root_id`,
  `cargo_order_no`, `external_order_no`, `order_source`,
  `customer_id`, `customer_name`, `business_type_id`, `business_type_name`,
  `channel_id`, `channel_name`,
  `customer_service_id`, `customer_service_name`,
  `container_order_id`, `container_no`,
  `inbound_warehouse_id`, `inbound_warehouse_name`,
  `address_type`, `platform_warehouse_code`,
  `consignee_name`, `address_line1`, `address_line2`,
  `city`, `state`, `zip_code`, `country`,
  `contact_name`, `contact_phone`, `contact_email`,
  `transfer_flag`,
  `declared_carton_qty`, `declared_piece_qty`, `declared_weight`, `declared_cbm`,
  `actual_carton_qty`, `actual_pallet_qty`, `actual_piece_qty`, `actual_weight`, `actual_cbm`,
  `weight_unit`, `volume_unit`,
  `pre_outbound_flag`, `pre_outbound_no`, `pre_outbound_status`,
  `pre_outbound_time`, `pre_outbound_convert_time`,
  `outbound_batch_no`, `outbound_order_status`, `outbound_order_time`,
  `order_status`, `fulfillment_status`,
  `appointment_status`, `pod_status`, `billing_status`,
  `earliest_dw_time`, `eta`, `ata`,
  `actual_pickup_time`, `actual_arrival_time`,
  `devanning_finish_time`, `actual_inbound_time`,
  `exception_flag`, `exception_count`,
  `customer_remark`, `internal_remark`,
  `remark`, `create_by`, `create_time`, `update_by`, `update_time`, `deleted`
) VALUES

-- -------------------------------------------------------
-- CO9200001：Pacific Home Goods - Amazon RNO8，在途
-- 关联海柜：9100001 (TGHU1234567, IN_TRANSIT, LAX)
-- -------------------------------------------------------
(9200001, '000000', 4000001, 9150001,
 'CO202605150001', 'PHG-2026-05-001', 'MANUAL',
 8001001, 'Pacific Home Goods LLC', 5002001, 'FBA头程',
 5001001, 'Amazon US',
 1, 'Amy',
 9100001, 'TGHU1234567',
 4001001, 'Los Angeles Central Warehouse',
 'PLATFORM_WH', 'RNO8',
 'Amazon.com Services LLC', '3838 Inventory Ave', NULL,
 'Reno', 'NV', '89521', 'US',
 'FBA Receiving', '800-999-0000', 'fba-inbound@amazon.com',
 0,
 550.00, 6600.00, 7260.000, 31.200,
 NULL, NULL, NULL, NULL, NULL,
 'KG', 'CBM',
 0, NULL, 'NONE',
 NULL, NULL,
 NULL, 'NONE', NULL,
 'NORMAL', 'IN_TRANSIT',
 'NONE', 'PENDING', 'UNBILLED',
 '2026-05-28 00:00:00', '2026-05-23 09:30:00', NULL,
 NULL, NULL,
 NULL, NULL,
 0, 0,
 'FBA入仓，请确保标签合规', NULL,
 '演示数据：LAX在途-FBA RNO8', 1, '2026-05-15 09:00:00', 1, '2026-05-15 14:00:00', 0),

-- -------------------------------------------------------
-- CO9200002：Pacific Home Goods - 私仓 LA，在途
-- 关联海柜：9100001 (TGHU1234567, IN_TRANSIT, LAX)
-- -------------------------------------------------------
(9200002, '000000', 4000001, 9150002,
 'CO202605150002', 'PHG-2026-05-002', 'MANUAL',
 8001001, 'Pacific Home Goods LLC', 5002001, 'FBA头程',
 5001001, 'Amazon US',
 1, 'Amy',
 9100001, 'TGHU1234567',
 4001001, 'Los Angeles Central Warehouse',
 'PRIVATE', NULL,
 'PHG Warehouse LA', '12500 S Figueroa St', 'Suite 200',
 'Los Angeles', 'CA', '90061', 'US',
 'Jack Wong', '+1-310-555-0101', 'warehouse@phg.com',
 0,
 430.00, 5160.00, 5590.000, 24.900,
 NULL, NULL, NULL, NULL, NULL,
 'KG', 'CBM',
 0, NULL, 'NONE',
 NULL, NULL,
 NULL, 'NONE', NULL,
 'NORMAL', 'IN_TRANSIT',
 'NONE', 'PENDING', 'UNBILLED',
 '2026-05-28 00:00:00', '2026-05-23 09:30:00', NULL,
 NULL, NULL,
 NULL, NULL,
 0, 0,
 NULL, '与CO001同柜，分拆派送',
 '演示数据：LAX在途-私仓LA', 1, '2026-05-15 09:30:00', 1, '2026-05-15 14:00:00', 0),

-- -------------------------------------------------------
-- CO9200003：Northstar Outdoor - Amazon SBD1，已到港（有Hold异常）
-- 关联海柜：9100002 (MSCU7654321, HOLDING, LAX)
-- -------------------------------------------------------
(9200003, '000000', 4000001, 9150003,
 'CO202605100001', 'NO-2026-05-001', 'IMPORT',
 8001002, 'Northstar Outdoor Inc.', 5002001, 'FBA头程',
 5001002, 'Walmart US',
 1, 'Mia',
 9100002, 'MSCU7654321',
 4001001, 'Los Angeles Central Warehouse',
 'PLATFORM_WH', 'SBD1',
 'Amazon.com Services LLC', '2496 Arden Way', NULL,
 'San Bernardino', 'CA', '92408', 'US',
 'FBA Receiving', '800-999-0000', 'fba-inbound@amazon.com',
 0,
 700.00, 8400.00, 9380.000, 38.500,
 NULL, NULL, NULL, NULL, NULL,
 'KG', 'CBM',
 0, NULL, 'NONE',
 NULL, NULL,
 NULL, 'NONE', NULL,
 'NORMAL', 'ARRIVED_PORT',
 'NONE', 'PENDING', 'UNBILLED',
 '2026-05-26 00:00:00', '2026-05-20 08:00:00', '2026-05-20 11:20:00',
 NULL, NULL,
 NULL, NULL,
 1, 1,
 NULL, '海柜被Hold，预计延误3-5天，DW顺延至5/26',
 '演示数据：LAX到港-Hold中-FBA SBD1', 1, '2026-05-10 10:00:00', 1, '2026-05-20 11:20:00', 0),

-- -------------------------------------------------------
-- CO9200004：Northstar Outdoor - Walmart DC Ontario，已到港
-- 关联海柜：9100002 (MSCU7654321, HOLDING, LAX)
-- -------------------------------------------------------
(9200004, '000000', 4000001, 9150004,
 'CO202605100002', 'NO-2026-05-002', 'IMPORT',
 8001002, 'Northstar Outdoor Inc.', 5002001, 'FBA头程',
 5001002, 'Walmart US',
 1, 'Mia',
 9100002, 'MSCU7654321',
 4001001, 'Los Angeles Central Warehouse',
 'COMMERCIAL', NULL,
 'Walmart DC Ontario', '4850 E Guasti Rd', NULL,
 'Ontario', 'CA', '91761', 'US',
 'Receiving Dept', '+1-909-555-0200', 'receiving@walmart-dc.com',
 0,
 460.00, 5520.00, 6040.000, 23.600,
 NULL, NULL, NULL, NULL, NULL,
 'KG', 'CBM',
 0, NULL, 'NONE',
 NULL, NULL,
 NULL, 'NONE', NULL,
 'NORMAL', 'ARRIVED_PORT',
 'NONE', 'PENDING', 'UNBILLED',
 '2026-05-26 00:00:00', '2026-05-20 08:00:00', '2026-05-20 11:20:00',
 NULL, NULL,
 NULL, NULL,
 0, 0,
 NULL, '同柜CO003，Hold解除后安排提柜',
 '演示数据：LAX到港-Hold中-Walmart DC', 1, '2026-05-10 10:30:00', 1, '2026-05-20 11:20:00', 0),

-- -------------------------------------------------------
-- CO9200005：East Market Supply - Amazon EWR4，拆柜中
-- 关联海柜：9100003 (OOLU4567890, DEVANNING, NJ)
-- -------------------------------------------------------
(9200005, '000000', 4000001, 9150005,
 'CO202605050001', 'EM-2026-05-001', 'API',
 8001003, 'East Market Supply Co.', 5002002, 'FBM快递',
 5001001, 'Amazon US',
 1, 'Tom',
 9100003, 'OOLU4567890',
 4001002, 'New Jersey East Coast Warehouse',
 'PLATFORM_WH', 'EWR4',
 'Amazon.com Services LLC', '50 New Canton Way', NULL,
 'Robbinsville', 'NJ', '08691', 'US',
 'FBA Receiving', '800-999-0000', 'fba-inbound@amazon.com',
 0,
 800.00, 9600.00, 10640.000, 42.700,
 NULL, NULL, NULL, NULL, NULL,
 'KG', 'CBM',
 0, NULL, 'NONE',
 NULL, NULL,
 NULL, 'NONE', NULL,
 'NORMAL', 'DEVANNING',
 'NONE', 'PENDING', 'UNBILLED',
 '2026-05-22 00:00:00', '2026-05-18 07:00:00', '2026-05-18 09:10:00',
 '2026-05-20 15:30:00', '2026-05-21 09:35:00',
 NULL, NULL,
 0, 0,
 'Please scan each carton upon receiving', '体积大，预计拆柜2天',
 '演示数据：NJ拆柜中-FBA EWR4', 1, '2026-05-05 11:00:00', 1, '2026-05-22 10:15:00', 0),

-- -------------------------------------------------------
-- CO9200006：East Market Supply - Amazon EWR9，拆柜完成
-- 关联海柜：9100003 (OOLU4567890, DEVANNING, NJ)
-- -------------------------------------------------------
(9200006, '000000', 4000001, 9150006,
 'CO202605050002', 'EM-2026-05-002', 'API',
 8001003, 'East Market Supply Co.', 5002002, 'FBM快递',
 5001001, 'Amazon US',
 1, 'Tom',
 9100003, 'OOLU4567890',
 4001002, 'New Jersey East Coast Warehouse',
 'PLATFORM_WH', 'EWR9',
 'Amazon.com Services LLC', '8003 Industrial Blvd', NULL,
 'Carteret', 'NJ', '07008', 'US',
 'FBA Receiving', '800-999-0000', 'fba-inbound@amazon.com',
 0,
 400.00, 4800.00, 5340.000, 21.000,
 402.00, NULL, 4824.00, 5378.500, 21.150,
 'KG', 'CBM',
 0, NULL, 'NONE',
 NULL, NULL,
 NULL, 'NONE', NULL,
 'NORMAL', 'DEVANNED',
 'NONE', 'PENDING', 'UNBILLED',
 '2026-05-22 00:00:00', '2026-05-18 07:00:00', '2026-05-18 09:10:00',
 '2026-05-20 15:30:00', '2026-05-21 09:35:00',
 '2026-05-22 11:30:00', NULL,
 0, 0,
 NULL, '实际多2箱，以实际为准',
 '演示数据：NJ拆柜完成-FBA EWR9', 1, '2026-05-05 11:30:00', 1, '2026-05-22 11:30:00', 0),

-- -------------------------------------------------------
-- CO9200007：East Market Supply - Amazon EWR4，已入库 + 预出单
-- 关联海柜：9100003 (OOLU4567890, DEVANNING, NJ)
-- -------------------------------------------------------
(9200007, '000000', 4000001, 9150007,
 'CO202605050003', 'EM-2026-05-003', 'API',
 8001003, 'East Market Supply Co.', 5002002, 'FBM快递',
 5001001, 'Amazon US',
 1, 'Tom',
 9100003, 'OOLU4567890',
 4001002, 'New Jersey East Coast Warehouse',
 'PLATFORM_WH', 'EWR4',
 'Amazon.com Services LLC', '50 New Canton Way', NULL,
 'Robbinsville', 'NJ', '08691', 'US',
 'FBA Receiving', '800-999-0000', 'fba-inbound@amazon.com',
 0,
 220.00, 2640.00, 2930.000, 11.400,
 220.00, 8.00, 2640.00, 2944.500, 11.520,
 'KG', 'CBM',
 1, 'PRE202605220001', 'PRE_CREATED',
 '2026-05-22 15:00:00', NULL,
 NULL, 'NONE', NULL,
 'NORMAL', 'INBOUNDED',
 'NONE', 'PENDING', 'UNBILLED',
 '2026-05-22 00:00:00', '2026-05-18 07:00:00', '2026-05-18 09:10:00',
 '2026-05-20 15:30:00', '2026-05-21 09:35:00',
 '2026-05-22 10:50:00', '2026-05-22 14:00:00',
 0, 0,
 NULL, '小票，优先完成入库，已创建预出单待客户确认',
 '演示数据：NJ已入库+预出单-FBA EWR4', 1, '2026-05-05 12:00:00', 1, '2026-05-22 15:00:00', 0);


-- ============================================================
-- 3. 货件层 oms_cargo_order_shipment
-- ============================================================
INSERT IGNORE INTO `oms_cargo_order_shipment` (
  `id`, `tenant_id`, `cargo_order_id`, `biz_root_id`,
  `shipment_no`, `po_no`, `shipping_mark`,
  `carton_qty`, `weight`, `cbm`,
  `dw_time`, `remark`,
  `create_by`, `create_time`, `update_by`, `update_time`, `deleted`
) VALUES

-- CO9200001 货件（2个）
(9210001, '000000', 9200001, 9150001,
 'PH-RNO8-001A', 'PO-PHG-2026-3301', 'PHG/RNO8/LOT1',
 300.00, 3960.000, 17.000,
 '2026-05-28 00:00:00', 'Amazon RNO8入仓，Lot1',
 1, '2026-05-15 09:00:00', 1, '2026-05-15 09:00:00', 0),

(9210002, '000000', 9200001, 9150001,
 'PH-RNO8-001B', 'PO-PHG-2026-3302', 'PHG/RNO8/LOT2',
 250.00, 3300.000, 14.200,
 '2026-05-28 00:00:00', 'Amazon RNO8入仓，Lot2',
 1, '2026-05-15 09:00:00', 1, '2026-05-15 09:00:00', 0),

-- CO9200002 货件（1个）
(9210003, '000000', 9200002, 9150002,
 'PH-LAX-002A', 'PO-PHG-2026-3303', 'PHG/LAX/PRIV',
 430.00, 5590.000, 24.900,
 '2026-05-28 00:00:00', '私仓LA，整票',
 1, '2026-05-15 09:30:00', 1, '2026-05-15 09:30:00', 0),

-- CO9200003 货件（2个）
(9210004, '000000', 9200003, 9150003,
 'NO-SBD1-001A', 'PO-NO-2026-1101', 'NO/SBD1/A',
 400.00, 5360.000, 22.000,
 '2026-05-26 00:00:00', 'Hold延误，DW顺延',
 1, '2026-05-10 10:00:00', 1, '2026-05-10 10:00:00', 0),

(9210005, '000000', 9200003, 9150003,
 'NO-SBD1-001B', 'PO-NO-2026-1102', 'NO/SBD1/B',
 300.00, 4020.000, 16.500,
 '2026-05-26 00:00:00', 'Hold延误，DW顺延',
 1, '2026-05-10 10:00:00', 1, '2026-05-10 10:00:00', 0),

-- CO9200004 货件（2个）
(9210006, '000000', 9200004, 9150004,
 'NO-WAL-001A', 'PO-NO-2026-1201', 'NO/WAL/A',
 250.00, 3275.000, 12.800,
 '2026-05-26 00:00:00', 'Walmart DC Ontario，Hold延误',
 1, '2026-05-10 10:30:00', 1, '2026-05-10 10:30:00', 0),

(9210007, '000000', 9200004, 9150004,
 'NO-WAL-001B', 'PO-NO-2026-1202', 'NO/WAL/B',
 210.00, 2765.000, 10.800,
 '2026-05-26 00:00:00', 'Walmart DC Ontario，Hold延误',
 1, '2026-05-10 10:30:00', 1, '2026-05-10 10:30:00', 0),

-- CO9200005 货件（2个）
(9210008, '000000', 9200005, 9150005,
 'EM-EWR4-001A', 'PO-EM-2026-8801', 'EM/EWR4/S1',
 450.00, 5985.000, 24.000,
 '2026-05-22 00:00:00', '拆柜中，第一批',
 1, '2026-05-05 11:00:00', 1, '2026-05-05 11:00:00', 0),

(9210009, '000000', 9200005, 9150005,
 'EM-EWR4-001B', 'PO-EM-2026-8802', 'EM/EWR4/S2',
 350.00, 4655.000, 18.700,
 '2026-05-22 00:00:00', '拆柜中，第二批',
 1, '2026-05-05 11:00:00', 1, '2026-05-05 11:00:00', 0),

-- CO9200006 货件（1个）
(9210010, '000000', 9200006, 9150006,
 'EM-EWR9-001A', 'PO-EM-2026-8901', 'EM/EWR9/S1',
 400.00, 5340.000, 21.000,
 '2026-05-22 00:00:00', '拆柜完成，实收402箱',
 1, '2026-05-05 11:30:00', 1, '2026-05-22 11:30:00', 0),

-- CO9200007 货件（1个）
(9210011, '000000', 9200007, 9150007,
 'EM-EWR4-002A', 'PO-EM-2026-9001', 'EM/EWR4/S3',
 220.00, 2930.000, 11.400,
 '2026-05-22 00:00:00', '已入库，8板',
 1, '2026-05-05 12:00:00', 1, '2026-05-22 14:00:00', 0);


-- ============================================================
-- 4. SKU 明细层 oms_cargo_order_sku_item
-- ============================================================
INSERT IGNORE INTO `oms_cargo_order_sku_item` (
  `id`, `tenant_id`, `cargo_order_id`, `shipment_id`, `shipment_no`,
  `po_no`, `shipping_mark`,
  `sku`, `fnsku`, `product_name`,
  `qty`, `carton_qty`, `weight`, `cbm`, `remark`,
  `create_by`, `create_time`, `update_by`, `update_time`, `deleted`
) VALUES

-- CO9200001 / 货件9210001 SKU
(9220001, '000000', 9200001, 9210001, 'PH-RNO8-001A',
 'PO-PHG-2026-3301', 'PHG/RNO8/LOT1',
 'PHG-LAMP-001', 'X001ABCDE1', 'Modern LED Desk Lamp',
 2400.00, 200.00, 2640.000, 11.200, NULL,
 1, '2026-05-15 09:00:00', 1, '2026-05-15 09:00:00', 0),

(9220002, '000000', 9200001, 9210001, 'PH-RNO8-001A',
 'PO-PHG-2026-3301', 'PHG/RNO8/LOT1',
 'PHG-CHAIR-002', 'X002ABCDE2', 'Ergonomic Office Chair Cushion',
 1200.00, 100.00, 1320.000, 5.800, NULL,
 1, '2026-05-15 09:00:00', 1, '2026-05-15 09:00:00', 0),

-- CO9200001 / 货件9210002 SKU
(9220003, '000000', 9200001, 9210002, 'PH-RNO8-001B',
 'PO-PHG-2026-3302', 'PHG/RNO8/LOT2',
 'PHG-STAND-003', 'X003ABCDE3', 'Bamboo Monitor Stand',
 2500.00, 250.00, 3300.000, 14.200, NULL,
 1, '2026-05-15 09:00:00', 1, '2026-05-15 09:00:00', 0),

-- CO9200003 / 货件9210004 SKU
(9220004, '000000', 9200003, 9210004, 'NO-SBD1-001A',
 'PO-NO-2026-1101', 'NO/SBD1/A',
 'NO-TENT-001', 'X004ABCDE4', '4-Person Camping Tent',
 800.00, 200.00, 2680.000, 11.000, NULL,
 1, '2026-05-10 10:00:00', 1, '2026-05-10 10:00:00', 0),

(9220005, '000000', 9200003, 9210004, 'NO-SBD1-001A',
 'PO-NO-2026-1101', 'NO/SBD1/A',
 'NO-PACK-002', 'X005ABCDE5', 'Hiking Backpack 65L',
 1200.00, 200.00, 2680.000, 11.000, NULL,
 1, '2026-05-10 10:00:00', 1, '2026-05-10 10:00:00', 0),

-- CO9200003 / 货件9210005 SKU
(9220006, '000000', 9200003, 9210005, 'NO-SBD1-001B',
 'PO-NO-2026-1102', 'NO/SBD1/B',
 'NO-SLEEP-003', 'X006ABCDE6', 'Mummy Sleeping Bag -20°C',
 900.00, 150.00, 2010.000, 8.250, NULL,
 1, '2026-05-10 10:00:00', 1, '2026-05-10 10:00:00', 0),

(9220007, '000000', 9200003, 9210005, 'NO-SBD1-001B',
 'PO-NO-2026-1102', 'NO/SBD1/B',
 'NO-STOVE-004', 'X007ABCDE7', 'Portable Camping Stove',
 1050.00, 150.00, 2010.000, 8.250, NULL,
 1, '2026-05-10 10:00:00', 1, '2026-05-10 10:00:00', 0),

-- CO9200005 / 货件9210008 SKU
(9220008, '000000', 9200005, 9210008, 'EM-EWR4-001A',
 'PO-EM-2026-8801', 'EM/EWR4/S1',
 'EM-TOYS-001', 'X008ABCDE8', 'Educational Building Blocks Set',
 5400.00, 270.00, 3591.000, 14.400, NULL,
 1, '2026-05-05 11:00:00', 1, '2026-05-05 11:00:00', 0),

(9220009, '000000', 9200005, 9210008, 'EM-EWR4-001A',
 'PO-EM-2026-8801', 'EM/EWR4/S1',
 'EM-TOYS-002', 'X009ABCDE9', 'Magnetic Drawing Board',
 2700.00, 180.00, 2394.000, 9.600, NULL,
 1, '2026-05-05 11:00:00', 1, '2026-05-05 11:00:00', 0),

-- CO9200005 / 货件9210009 SKU
(9220010, '000000', 9200005, 9210009, 'EM-EWR4-001B',
 'PO-EM-2026-8802', 'EM/EWR4/S2',
 'EM-PUZZ-003', 'X010ABCDE0', '1000-Piece Jigsaw Puzzle',
 3500.00, 350.00, 4655.000, 18.700, NULL,
 1, '2026-05-05 11:00:00', 1, '2026-05-05 11:00:00', 0),

-- CO9200006 / 货件9210010 SKU
(9220011, '000000', 9200006, 9210010, 'EM-EWR9-001A',
 'PO-EM-2026-8901', 'EM/EWR9/S1',
 'EM-DOLL-004', 'X011ABCDE1', 'Soft Plush Doll 40cm',
 4800.00, 240.00, 3204.000, 12.600, NULL,
 1, '2026-05-05 11:30:00', 1, '2026-05-22 11:30:00', 0),

(9220012, '000000', 9200006, 9210010, 'EM-EWR9-001A',
 'PO-EM-2026-8901', 'EM/EWR9/S1',
 'EM-CARD-005', 'X012ABCDE2', 'Flash Cards Learning Set',
 3200.00, 160.00, 2136.000, 8.400, NULL,
 1, '2026-05-05 11:30:00', 1, '2026-05-22 11:30:00', 0),

-- CO9200007 / 货件9210011 SKU
(9220013, '000000', 9200007, 9210011, 'EM-EWR4-002A',
 'PO-EM-2026-9001', 'EM/EWR4/S3',
 'EM-GAME-006', 'X013ABCDE3', 'Strategy Board Game Family Edition',
 2640.00, 220.00, 2944.500, 11.520, NULL,
 1, '2026-05-05 12:00:00', 1, '2026-05-22 14:00:00', 0);


-- ============================================================
-- 5. 节点轨迹 oms_cargo_order_node_trace
-- ============================================================
INSERT IGNORE INTO `oms_cargo_order_node_trace` (
  `id`, `tenant_id`, `cargo_order_id`, `biz_root_id`,
  `node_code`, `node_name`, `node_status`,
  `status_from`, `status_to`, `action`,
  `actual_time`, `source_type`, `operator_id`, `operator_name`, `remark`,
  `create_time`
) VALUES

-- === CO9200001（TGHU1234567，IN_TRANSIT）===
(9230001, '000000', 9200001, 9150001,
 'PENDING_ACCEPT', '待受理', 'DONE',
 NULL, 'PENDING_ACCEPT', 'mockCreate',
 '2026-05-15 09:00:00', 'MANUAL', 1, 'admin', '创建货物订单',
 '2026-05-15 09:00:00'),

(9230002, '000000', 9200001, 9150001,
 'ACCEPTED', '已受理', 'DONE',
 'PENDING_ACCEPT', 'ACCEPTED', 'accept',
 '2026-05-15 10:30:00', 'MANUAL', 1, 'Amy', '审核通过，已受理',
 '2026-05-15 10:30:00'),

(9230003, '000000', 9200001, 9150001,
 'IN_TRANSIT', '在途', 'DONE',
 'ACCEPTED', 'IN_TRANSIT', 'markInTransit',
 '2026-05-15 14:00:00', 'OMS', 1, 'Amy', '船公司已开航，标记在途',
 '2026-05-15 14:00:00'),

-- === CO9200002（TGHU1234567，IN_TRANSIT）===
(9230004, '000000', 9200002, 9150002,
 'PENDING_ACCEPT', '待受理', 'DONE',
 NULL, 'PENDING_ACCEPT', 'mockCreate',
 '2026-05-15 09:30:00', 'MANUAL', 1, 'admin', '创建货物订单',
 '2026-05-15 09:30:00'),

(9230005, '000000', 9200002, 9150002,
 'ACCEPTED', '已受理', 'DONE',
 'PENDING_ACCEPT', 'ACCEPTED', 'accept',
 '2026-05-15 10:35:00', 'MANUAL', 1, 'Amy', '审核通过，已受理',
 '2026-05-15 10:35:00'),

(9230006, '000000', 9200002, 9150002,
 'IN_TRANSIT', '在途', 'DONE',
 'ACCEPTED', 'IN_TRANSIT', 'markInTransit',
 '2026-05-15 14:00:00', 'OMS', 1, 'Amy', '与CO001同柜，同步标记在途',
 '2026-05-15 14:00:00'),

-- === CO9200003（MSCU7654321，ARRIVED_PORT，Hold）===
(9230007, '000000', 9200003, 9150003,
 'PENDING_ACCEPT', '待受理', 'DONE',
 NULL, 'PENDING_ACCEPT', 'mockCreate',
 '2026-05-10 10:00:00', 'MANUAL', 1, 'admin', '创建货物订单',
 '2026-05-10 10:00:00'),

(9230008, '000000', 9200003, 9150003,
 'ACCEPTED', '已受理', 'DONE',
 'PENDING_ACCEPT', 'ACCEPTED', 'accept',
 '2026-05-10 11:00:00', 'MANUAL', 1, 'Mia', '审核通过，已受理',
 '2026-05-10 11:00:00'),

(9230009, '000000', 9200003, 9150003,
 'IN_TRANSIT', '在途', 'DONE',
 'ACCEPTED', 'IN_TRANSIT', 'markInTransit',
 '2026-05-12 09:00:00', 'OMS', 1, 'Mia', '已开航，标记在途',
 '2026-05-12 09:00:00'),

(9230010, '000000', 9200003, 9150003,
 'ARRIVED_PORT', '已到港', 'DONE',
 'IN_TRANSIT', 'ARRIVED_PORT', 'confirmArrivedPort',
 '2026-05-20 11:20:00', 'OMS', 1, 'Mia', '船已靠港，海柜被Hold待查验',
 '2026-05-20 11:20:00'),

-- === CO9200004（MSCU7654321，ARRIVED_PORT）===
(9230011, '000000', 9200004, 9150004,
 'PENDING_ACCEPT', '待受理', 'DONE',
 NULL, 'PENDING_ACCEPT', 'mockCreate',
 '2026-05-10 10:30:00', 'MANUAL', 1, 'admin', '创建货物订单',
 '2026-05-10 10:30:00'),

(9230012, '000000', 9200004, 9150004,
 'ACCEPTED', '已受理', 'DONE',
 'PENDING_ACCEPT', 'ACCEPTED', 'accept',
 '2026-05-10 11:05:00', 'MANUAL', 1, 'Mia', '审核通过，已受理',
 '2026-05-10 11:05:00'),

(9230013, '000000', 9200004, 9150004,
 'IN_TRANSIT', '在途', 'DONE',
 'ACCEPTED', 'IN_TRANSIT', 'markInTransit',
 '2026-05-12 09:00:00', 'OMS', 1, 'Mia', '已开航，与CO003同柜',
 '2026-05-12 09:00:00'),

(9230014, '000000', 9200004, 9150004,
 'ARRIVED_PORT', '已到港', 'DONE',
 'IN_TRANSIT', 'ARRIVED_PORT', 'confirmArrivedPort',
 '2026-05-20 11:20:00', 'OMS', 1, 'Mia', '船已靠港，等待Hold解除',
 '2026-05-20 11:20:00'),

-- === CO9200005（OOLU4567890，DEVANNING）===
(9230015, '000000', 9200005, 9150005,
 'PENDING_ACCEPT', '待受理', 'DONE',
 NULL, 'PENDING_ACCEPT', 'mockCreate',
 '2026-05-05 11:00:00', 'MANUAL', 1, 'admin', '创建货物订单',
 '2026-05-05 11:00:00'),

(9230016, '000000', 9200005, 9150005,
 'ACCEPTED', '已受理', 'DONE',
 'PENDING_ACCEPT', 'ACCEPTED', 'accept',
 '2026-05-05 14:00:00', 'MANUAL', 1, 'Tom', '审核通过，已受理',
 '2026-05-05 14:00:00'),

(9230017, '000000', 9200005, 9150005,
 'IN_TRANSIT', '在途', 'DONE',
 'ACCEPTED', 'IN_TRANSIT', 'markInTransit',
 '2026-05-07 08:00:00', 'OMS', 1, 'Tom', '已开航',
 '2026-05-07 08:00:00'),

(9230018, '000000', 9200005, 9150005,
 'ARRIVED_PORT', '已到港', 'DONE',
 'IN_TRANSIT', 'ARRIVED_PORT', 'confirmArrivedPort',
 '2026-05-18 09:10:00', 'OMS', 1, 'Tom', '船靠港 NY/NJ',
 '2026-05-18 09:10:00'),

(9230019, '000000', 9200005, 9150005,
 'PICKED_UP', '已提柜', 'DONE',
 'ARRIVED_PORT', 'PICKED_UP', 'confirmPickedUp',
 '2026-05-20 15:30:00', 'OMS', 1, 'Tom', '拖车已提柜',
 '2026-05-20 15:30:00'),

(9230020, '000000', 9200005, 9150005,
 'ARRIVED_WAREHOUSE', '已到仓', 'DONE',
 'PICKED_UP', 'ARRIVED_WAREHOUSE', 'confirmArrivedWarehouse',
 '2026-05-21 09:35:00', 'OMS', 1, 'Tom', '海柜已到仓，停放 YARD-A-08',
 '2026-05-21 09:35:00'),

(9230021, '000000', 9200005, 9150005,
 'DEVANNING', '拆柜中', 'DONE',
 'ARRIVED_WAREHOUSE', 'DEVANNING', 'startDevanning',
 '2026-05-22 10:15:00', 'OMS', 1, 'Tom', '开始拆柜，人工+叉车',
 '2026-05-22 10:15:00'),

-- === CO9200006（OOLU4567890，DEVANNED）===
(9230022, '000000', 9200006, 9150006,
 'PENDING_ACCEPT', '待受理', 'DONE',
 NULL, 'PENDING_ACCEPT', 'mockCreate',
 '2026-05-05 11:30:00', 'MANUAL', 1, 'admin', '创建货物订单',
 '2026-05-05 11:30:00'),

(9230023, '000000', 9200006, 9150006,
 'ACCEPTED', '已受理', 'DONE',
 'PENDING_ACCEPT', 'ACCEPTED', 'accept',
 '2026-05-05 14:30:00', 'MANUAL', 1, 'Tom', '审核通过，已受理',
 '2026-05-05 14:30:00'),

(9230024, '000000', 9200006, 9150006,
 'IN_TRANSIT', '在途', 'DONE',
 'ACCEPTED', 'IN_TRANSIT', 'markInTransit',
 '2026-05-07 08:00:00', 'OMS', 1, 'Tom', '已开航，与CO005/007同柜',
 '2026-05-07 08:00:00'),

(9230025, '000000', 9200006, 9150006,
 'ARRIVED_PORT', '已到港', 'DONE',
 'IN_TRANSIT', 'ARRIVED_PORT', 'confirmArrivedPort',
 '2026-05-18 09:10:00', 'OMS', 1, 'Tom', '船靠港',
 '2026-05-18 09:10:00'),

(9230026, '000000', 9200006, 9150006,
 'PICKED_UP', '已提柜', 'DONE',
 'ARRIVED_PORT', 'PICKED_UP', 'confirmPickedUp',
 '2026-05-20 15:30:00', 'OMS', 1, 'Tom', '拖车已提柜',
 '2026-05-20 15:30:00'),

(9230027, '000000', 9200006, 9150006,
 'ARRIVED_WAREHOUSE', '已到仓', 'DONE',
 'PICKED_UP', 'ARRIVED_WAREHOUSE', 'confirmArrivedWarehouse',
 '2026-05-21 09:35:00', 'OMS', 1, 'Tom', '到仓',
 '2026-05-21 09:35:00'),

(9230028, '000000', 9200006, 9150006,
 'DEVANNING', '拆柜中', 'DONE',
 'ARRIVED_WAREHOUSE', 'DEVANNING', 'startDevanning',
 '2026-05-22 10:15:00', 'OMS', 1, 'Tom', '开始拆柜',
 '2026-05-22 10:15:00'),

(9230029, '000000', 9200006, 9150006,
 'DEVANNED', '拆柜完成', 'DONE',
 'DEVANNING', 'DEVANNED', 'finishDevanning',
 '2026-05-22 11:30:00', 'OMS', 1, 'Tom', '拆柜完成，实收402箱，比预报多2箱',
 '2026-05-22 11:30:00'),

-- === CO9200007（OOLU4567890，INBOUNDED + 预出单）===
(9230030, '000000', 9200007, 9150007,
 'PENDING_ACCEPT', '待受理', 'DONE',
 NULL, 'PENDING_ACCEPT', 'mockCreate',
 '2026-05-05 12:00:00', 'MANUAL', 1, 'admin', '创建货物订单',
 '2026-05-05 12:00:00'),

(9230031, '000000', 9200007, 9150007,
 'ACCEPTED', '已受理', 'DONE',
 'PENDING_ACCEPT', 'ACCEPTED', 'accept',
 '2026-05-05 15:00:00', 'MANUAL', 1, 'Tom', '审核通过',
 '2026-05-05 15:00:00'),

(9230032, '000000', 9200007, 9150007,
 'IN_TRANSIT', '在途', 'DONE',
 'ACCEPTED', 'IN_TRANSIT', 'markInTransit',
 '2026-05-07 08:00:00', 'OMS', 1, 'Tom', '已开航',
 '2026-05-07 08:00:00'),

(9230033, '000000', 9200007, 9150007,
 'ARRIVED_PORT', '已到港', 'DONE',
 'IN_TRANSIT', 'ARRIVED_PORT', 'confirmArrivedPort',
 '2026-05-18 09:10:00', 'OMS', 1, 'Tom', '船靠港',
 '2026-05-18 09:10:00'),

(9230034, '000000', 9200007, 9150007,
 'PICKED_UP', '已提柜', 'DONE',
 'ARRIVED_PORT', 'PICKED_UP', 'confirmPickedUp',
 '2026-05-20 15:30:00', 'OMS', 1, 'Tom', '拖车已提柜',
 '2026-05-20 15:30:00'),

(9230035, '000000', 9200007, 9150007,
 'ARRIVED_WAREHOUSE', '已到仓', 'DONE',
 'PICKED_UP', 'ARRIVED_WAREHOUSE', 'confirmArrivedWarehouse',
 '2026-05-21 09:35:00', 'OMS', 1, 'Tom', '到仓',
 '2026-05-21 09:35:00'),

(9230036, '000000', 9200007, 9150007,
 'DEVANNING', '拆柜中', 'DONE',
 'ARRIVED_WAREHOUSE', 'DEVANNING', 'startDevanning',
 '2026-05-22 10:15:00', 'OMS', 1, 'Tom', '开始拆柜',
 '2026-05-22 10:15:00'),

(9230037, '000000', 9200007, 9150007,
 'DEVANNED', '拆柜完成', 'DONE',
 'DEVANNING', 'DEVANNED', 'finishDevanning',
 '2026-05-22 10:50:00', 'OMS', 1, 'Tom', '小票220箱，拆完确认',
 '2026-05-22 10:50:00'),

(9230038, '000000', 9200007, 9150007,
 'INBOUNDED', '已入库', 'DONE',
 'DEVANNED', 'INBOUNDED', 'confirmInbounded',
 '2026-05-22 14:00:00', 'WMS', 1, 'Tom', 'WMS入库确认，上架8板',
 '2026-05-22 14:00:00'),

(9230039, '000000', 9200007, 9150007,
 'INBOUNDED', '预出单创建', 'DONE',
 'INBOUNDED', 'INBOUNDED', 'createPreOutbound',
 '2026-05-22 15:00:00', 'MANUAL', 1, 'Tom', '创建预出单: PRE202605220001，待客户确认发货计划',
 '2026-05-22 15:00:00');


-- ============================================================
-- 6. 海柜-货物订单关联表 oms_container_cargo_order_rel
-- ============================================================
INSERT IGNORE INTO `oms_container_cargo_order_rel` (
  `id`, `tenant_id`,
  `container_order_id`, `container_order_no`, `container_no`,
  `cargo_order_id`, `cargo_order_no`,
  `relation_type`, `relation_status`,
  `create_by`, `create_time`, `update_by`, `update_time`
) VALUES
(9240001, '000000', 9100001, 'SO202605220001', 'TGHU1234567', 9200001, 'CO202605150001', 'SPLIT', 'ACTIVE', 1, '2026-05-15 09:00:00', 1, '2026-05-15 09:00:00'),
(9240002, '000000', 9100001, 'SO202605220001', 'TGHU1234567', 9200002, 'CO202605150002', 'SPLIT', 'ACTIVE', 1, '2026-05-15 09:30:00', 1, '2026-05-15 09:30:00'),
(9240003, '000000', 9100002, 'SO202605220002', 'MSCU7654321', 9200003, 'CO202605100001', 'SPLIT', 'ACTIVE', 1, '2026-05-10 10:00:00', 1, '2026-05-10 10:00:00'),
(9240004, '000000', 9100002, 'SO202605220002', 'MSCU7654321', 9200004, 'CO202605100002', 'SPLIT', 'ACTIVE', 1, '2026-05-10 10:30:00', 1, '2026-05-10 10:30:00'),
(9240005, '000000', 9100003, 'SO202605220003', 'OOLU4567890', 9200005, 'CO202605050001', 'SPLIT', 'ACTIVE', 1, '2026-05-05 11:00:00', 1, '2026-05-05 11:00:00'),
(9240006, '000000', 9100003, 'SO202605220003', 'OOLU4567890', 9200006, 'CO202605050002', 'SPLIT', 'ACTIVE', 1, '2026-05-05 11:30:00', 1, '2026-05-05 11:30:00'),
(9240007, '000000', 9100003, 'SO202605220003', 'OOLU4567890', 9200007, 'CO202605050003', 'SPLIT', 'ACTIVE', 1, '2026-05-05 12:00:00', 1, '2026-05-05 12:00:00');
