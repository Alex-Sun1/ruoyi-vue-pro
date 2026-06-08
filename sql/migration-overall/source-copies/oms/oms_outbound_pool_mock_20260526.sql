-- ============================================================
-- 出单工作台模拟数据 v1.0  (2026-05-26)
-- 从海柜 → 货物订单 → 已入库，全部在出单工作台等待出单
--
-- 新增海柜：
--   9100004  SO202605100004  CMAU9876543  DEVANNED  NJ  Pacific Home Goods LLC (5票全部已入库)
--
-- ID 段分配：
--   oms_container_order           9100004
--   biz_root                      9150013 – 9150017
--   oms_cargo_order               9200013 – 9200017
--   oms_cargo_order_shipment      9210017 – 9210021
--   oms_cargo_order_sku_item      9220022 – 9220031
--   oms_cargo_order_node_trace    9230050 – 9230089
--   oms_container_cargo_order_rel 9240013 – 9240017
-- ============================================================


-- ============================================================
-- 1. 海柜订单  CMAU9876543  (DEVANNED，NJ仓，全部已入库)
-- ============================================================
INSERT IGNORE INTO `oms_container_order` (
  `id`, `tenant_id`, `company_id`, `customer_id`, `customer_name`, `channel_id`, `business_type_id`,
  `owner_user_id`, `owner_user_name`, `customer_service_id`, `customer_service_name`,
  `warehouse_id`, `inbound_warehouse_name`, `container_order_no`, `order_source`,
  `container_no`, `container_type`, `seal_no`, `shipping_line_id`, `shipping_line_name`,
  `vessel_name`, `voyage_no`, `route_code`, `mbl_no`, `hbl_no`, `discharge_port_id`, `discharge_port_name`,
  `terminal_id`, `terminal_name`, `eta`, `ata`, `pickup_lfd`, `empty_return_lfd`,
  `terminal_release_status`, `hold_flag`, `hold_types`, `hold_remark`, `exam_flag`, `exam_type`, `exam_remark`,
  `drayage_vendor_id`, `drayage_vendor_name`, `pickup_appointment_no`, `pickup_appointment_time`,
  `actual_pickup_time`, `pickup_remark`, `expected_arrival_time`, `actual_arrival_time`,
  `container_location`, `arrival_remark`, `devanning_no`, `expected_devanning_time`,
  `devanning_method`, `loading_type`, `sorting_method`, `devanning_start_time`, `devanning_finish_time`,
  `devanning_remark`, `empty_return_location`, `empty_return_time`, `empty_return_remark`,
  `pre_plan_truck_qty`, `pre_plan_pallet_qty`, `pre_plan_cbm`, `total_carton_qty`, `total_pallet_qty`, `total_weight`, `total_cbm`,
  `container_exception_flag`, `container_exception_type`, `container_exception_count`,
  `downstream_exception_flag`, `downstream_exception_count`, `container_status`, `internal_remark`,
  `status`, `remark`, `create_by`, `create_time`, `update_by`, `update_time`, `deleted`
) VALUES
(9100004, '000000', 4000001, 8001001, 'Pacific Home Goods LLC', 5001001, 5002001,
 1, 'Lily Chen', 1, 'Amy',
 4001002, 'New Jersey East Coast Warehouse', 'SO202605100004', 'MANUAL',
 'CMAU9876543', '40HQ', 'SEAL55288', 230201, 'MAERSK',
 'MAERSK VENICE', '318E', 'EC1', 'MAEU556677889', 'HBL-NJ-004', 230102, 'USNYC',
 230503, 'APM Terminals Elizabeth', '2026-05-10 06:00:00', '2026-05-10 08:45:00', '2026-05-15', '2026-05-22',
 'RELEASED', 0, NULL, NULL, 0, NULL, NULL,
 7001003, 'NJ Port Drayage', 'PU-NJ-20260511-01', '2026-05-11 09:00:00',
 '2026-05-11 10:20:00', '顺利提柜', '2026-05-11 18:00:00', '2026-05-11 17:55:00',
 'YARD-B-03', '已到仓，停放YARD-B-03', 'DEV202605120004', '2026-05-12 09:00:00',
 'MANUAL', 'FLOOR', 'BY_ORDER', '2026-05-12 09:15:00', '2026-05-14 16:30:00',
 '拆柜完成，5票全部清点入库', 'Maher Empty Return Depot', '2026-05-16 10:00:00', '空柜已还',
 5, 42, 98.600, 1350, 42, 17685.000, 98.600,
 0, NULL, 0, 0, 0, 'DEVANNED', '全部已入库，等待出单',
 '0', '演示数据：NJ已拆柜全入库海柜', 1, '2026-05-08 14:00:00', 1, '2026-05-14 16:30:00', 0);

INSERT IGNORE INTO `oms_container_order_trace` (
  `id`, `tenant_id`, `container_order_id`, `container_order_no`, `container_no`,
  `status_from`, `status_to`, `action`, `action_desc`, `operator_id`, `operator_name`,
  `remark`, `create_by`, `create_time`, `update_by`, `update_time`
) VALUES
(9101005, '000000', 9100004, 'SO202605100004', 'CMAU9876543', NULL,        'IN_TRANSIT',       'markInTransit',         '开航，在途',           1, 'Amy',   '演示数据', 1, '2026-05-08 14:00:00', 1, '2026-05-08 14:00:00'),
(9101006, '000000', 9100004, 'SO202605100004', 'CMAU9876543', 'IN_TRANSIT','ARRIVED_PORT',     'confirmArrivedPort',    '靠港 NJ',              1, 'Amy',   '演示数据', 1, '2026-05-10 08:45:00', 1, '2026-05-10 08:45:00'),
(9101007, '000000', 9100004, 'SO202605100004', 'CMAU9876543', 'ARRIVED_PORT','PICKED_UP',      'confirmPickedUp',       '拖车提柜',              1, 'Amy',   '演示数据', 1, '2026-05-11 10:20:00', 1, '2026-05-11 10:20:00'),
(9101008, '000000', 9100004, 'SO202605100004', 'CMAU9876543', 'PICKED_UP','ARRIVED_WAREHOUSE', 'confirmArrivedWarehouse','到仓 YARD-B-03',      1, 'Amy',   '演示数据', 1, '2026-05-11 17:55:00', 1, '2026-05-11 17:55:00'),
(9101009, '000000', 9100004, 'SO202605100004', 'CMAU9876543', 'ARRIVED_WAREHOUSE','DEVANNING', 'startDevanning',        '开始拆柜',              1, 'Amy',   '演示数据', 1, '2026-05-12 09:15:00', 1, '2026-05-12 09:15:00'),
(9101010, '000000', 9100004, 'SO202605100004', 'CMAU9876543', 'DEVANNING','DEVANNED',          'finishDevanning',       '拆柜完成，5票全部入库',  1, 'Amy',   '演示数据', 1, '2026-05-14 16:30:00', 1, '2026-05-14 16:30:00');


-- ============================================================
-- 2. 业务主线
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
(9150013, '000000', 4000001, 4001002, 'BIZ202605080001', 'CARGO', 'OMS', 9200013, 'CO202605080001',
 8001001, 'Pacific Home Goods LLC', 5001001, 5002001, 'OMS', 'INBOUNDED', '已入库', '2026-05-13 10:00:00',
 'RUNNING', 0, 0, '2026-05-08 14:00:00', NULL, 1, '2026-05-08 14:00:00', 1, '2026-05-13 10:00:00', 0),

(9150014, '000000', 4000001, 4001002, 'BIZ202605080002', 'CARGO', 'OMS', 9200014, 'CO202605080002',
 8001001, 'Pacific Home Goods LLC', 5001001, 5002001, 'OMS', 'INBOUNDED', '已入库', '2026-05-13 11:30:00',
 'RUNNING', 0, 0, '2026-05-08 14:00:00', NULL, 1, '2026-05-08 14:00:00', 1, '2026-05-13 11:30:00', 0),

(9150015, '000000', 4000001, 4001002, 'BIZ202605080003', 'CARGO', 'OMS', 9200015, 'CO202605080003',
 8001002, 'Northstar Outdoor Inc.', 5001002, 5002001, 'OMS', 'INBOUNDED', '已入库', '2026-05-14 09:00:00',
 'RUNNING', 0, 0, '2026-05-08 15:00:00', NULL, 1, '2026-05-08 15:00:00', 1, '2026-05-14 09:00:00', 0),

(9150016, '000000', 4000001, 4001002, 'BIZ202605080004', 'CARGO', 'OMS', 9200016, 'CO202605080004',
 8001002, 'Northstar Outdoor Inc.', 5001002, 5002001, 'OMS', 'INBOUNDED', '已入库', '2026-05-14 10:15:00',
 'RUNNING', 0, 0, '2026-05-08 15:30:00', NULL, 1, '2026-05-08 15:30:00', 1, '2026-05-14 10:15:00', 0),

(9150017, '000000', 4000001, 4001002, 'BIZ202605080005', 'CARGO', 'OMS', 9200017, 'CO202605080005',
 8001003, 'East Market Supply Co.', 5001001, 5002002, 'OMS', 'INBOUNDED', '已入库', '2026-05-14 14:00:00',
 'RUNNING', 0, 0, '2026-05-08 16:00:00', NULL, 1, '2026-05-08 16:00:00', 1, '2026-05-14 14:00:00', 0);


-- ============================================================
-- 3. 货物订单（5票，全部 INBOUNDED，在出单工作台等待出单）
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

-- CO9200013：Pacific Home Goods → Amazon EWR4，已入库，DW已超期（紧急）
(9200013, '000000', 4000001, 9150013,
 'CO202605080001', 'PHG-2026-05-008', 'MANUAL',
 8001001, 'Pacific Home Goods LLC', 5002001, 'FBA头程',
 5001001, 'Amazon US',
 1, 'Amy',
 9100004, 'CMAU9876543',
 4001002, 'New Jersey East Coast Warehouse',
 'PLATFORM_WH', 'EWR4',
 'Amazon.com Services LLC', '50 New Canton Way', NULL,
 'Robbinsville', 'NJ', '08691', 'US',
 'FBA Receiving', '800-999-0000', 'fba-inbound@amazon.com',
 0,
 280.00, 3360.00, 3668.000, 15.400,
 280.00, 10.00, 3360.00, 3680.000, 15.500,
 'KG', 'CBM',
 0, NULL, 'NONE', NULL, NULL,
 NULL, 'NONE', NULL,
 'NORMAL', 'INBOUNDED',
 'NONE', 'PENDING', 'UNBILLED',
 '2026-05-20 00:00:00', '2026-05-10 06:00:00', '2026-05-10 08:45:00',
 '2026-05-11 10:20:00', '2026-05-11 17:55:00',
 '2026-05-14 16:30:00', '2026-05-13 10:00:00',
 0, 0,
 'Please deliver ASAP, DW已过期', 'DW已过期，优先安排出单',
 '演示数据：INBOUNDED，DW已超期，出单工作台-紧急', 1, '2026-05-08 14:00:00', 1, '2026-05-13 10:00:00', 0),

-- CO9200014：Pacific Home Goods → Amazon EWR9，已入库
(9200014, '000000', 4000001, 9150014,
 'CO202605080002', 'PHG-2026-05-009', 'MANUAL',
 8001001, 'Pacific Home Goods LLC', 5002001, 'FBA头程',
 5001001, 'Amazon US',
 1, 'Amy',
 9100004, 'CMAU9876543',
 4001002, 'New Jersey East Coast Warehouse',
 'PLATFORM_WH', 'EWR9',
 'Amazon.com Services LLC', '8003 Industrial Blvd', NULL,
 'Carteret', 'NJ', '07008', 'US',
 'FBA Receiving', '800-999-0000', 'fba-inbound@amazon.com',
 0,
 310.00, 3720.00, 4061.000, 17.200,
 312.00, 11.00, 3744.00, 4082.400, 17.330,
 'KG', 'CBM',
 0, NULL, 'NONE', NULL, NULL,
 NULL, 'NONE', NULL,
 'NORMAL', 'INBOUNDED',
 'NONE', 'PENDING', 'UNBILLED',
 '2026-05-28 00:00:00', '2026-05-10 06:00:00', '2026-05-10 08:45:00',
 '2026-05-11 10:20:00', '2026-05-11 17:55:00',
 '2026-05-14 16:30:00', '2026-05-13 11:30:00',
 0, 0,
 NULL, '实收多2箱，DW 5/28',
 '演示数据：INBOUNDED，出单工作台-FBA EWR9', 1, '2026-05-08 14:00:00', 1, '2026-05-13 11:30:00', 0),

-- CO9200015：Northstar Outdoor → Amazon BDL2，已入库
(9200015, '000000', 4000001, 9150015,
 'CO202605080003', 'NO-2026-05-008', 'IMPORT',
 8001002, 'Northstar Outdoor Inc.', 5002001, 'FBA头程',
 5001002, 'Walmart US',
 1, 'Mia',
 9100004, 'CMAU9876543',
 4001002, 'New Jersey East Coast Warehouse',
 'PLATFORM_WH', 'BDL2',
 'Amazon.com Services LLC', '8 Logistics Dr', NULL,
 'Bloomfield', 'CT', '06002', 'US',
 'FBA Receiving', '800-999-0000', 'fba-inbound@amazon.com',
 0,
 260.00, 3120.00, 3458.000, 14.600,
 260.00, 9.00, 3120.00, 3458.000, 14.600,
 'KG', 'CBM',
 0, NULL, 'NONE', NULL, NULL,
 NULL, 'NONE', NULL,
 'NORMAL', 'INBOUNDED',
 'NONE', 'PENDING', 'UNBILLED',
 '2026-05-26 00:00:00', '2026-05-10 06:00:00', '2026-05-10 08:45:00',
 '2026-05-11 10:20:00', '2026-05-11 17:55:00',
 '2026-05-14 16:30:00', '2026-05-14 09:00:00',
 0, 0,
 NULL, 'DW 5/26 临近，需尽快出单',
 '演示数据：INBOUNDED，出单工作台-FBA BDL2', 1, '2026-05-08 15:00:00', 1, '2026-05-14 09:00:00', 0),

-- CO9200016：Northstar Outdoor → 私仓 NJ，已入库
(9200016, '000000', 4000001, 9150016,
 'CO202605080004', 'NO-2026-05-009', 'IMPORT',
 8001002, 'Northstar Outdoor Inc.', 5002001, 'FBA头程',
 5001002, 'Walmart US',
 1, 'Mia',
 9100004, 'CMAU9876543',
 4001002, 'New Jersey East Coast Warehouse',
 'PRIVATE', NULL,
 'Northstar NJ Distribution', '205 Raritan Center Pkwy', NULL,
 'Edison', 'NJ', '08837', 'US',
 'David Park', '+1-732-555-0310', 'inbound@northstar-nj.com',
 0,
 180.00, 2160.00, 2394.000, 10.000,
 180.00, 7.00, 2160.00, 2394.000, 10.000,
 'KG', 'CBM',
 0, NULL, 'NONE', NULL, NULL,
 NULL, 'NONE', NULL,
 'NORMAL', 'INBOUNDED',
 'NONE', 'PENDING', 'UNBILLED',
 '2026-05-30 00:00:00', '2026-05-10 06:00:00', '2026-05-10 08:45:00',
 '2026-05-11 10:20:00', '2026-05-11 17:55:00',
 '2026-05-14 16:30:00', '2026-05-14 10:15:00',
 0, 0,
 NULL, '私仓，需预约送货时间',
 '演示数据：INBOUNDED，出单工作台-私仓NJ', 1, '2026-05-08 15:30:00', 1, '2026-05-14 10:15:00', 0),

-- CO9200017：East Market Supply → Amazon MDW2，已入库
(9200017, '000000', 4000001, 9150017,
 'CO202605080005', 'EM-2026-05-008', 'API',
 8001003, 'East Market Supply Co.', 5002002, 'FBM快递',
 5001001, 'Amazon US',
 1, 'Tom',
 9100004, 'CMAU9876543',
 4001002, 'New Jersey East Coast Warehouse',
 'PLATFORM_WH', 'MDW2',
 'Amazon.com Services LLC', '250 Emerald Dr', NULL,
 'Joliet', 'IL', '60433', 'US',
 'FBA Receiving', '800-999-0000', 'fba-inbound@amazon.com',
 0,
 320.00, 3840.00, 4224.000, 17.900,
 320.00, 12.00, 3840.00, 4224.000, 17.900,
 'KG', 'CBM',
 0, NULL, 'NONE', NULL, NULL,
 NULL, 'NONE', NULL,
 'NORMAL', 'INBOUNDED',
 'NONE', 'PENDING', 'UNBILLED',
 '2026-05-29 00:00:00', '2026-05-10 06:00:00', '2026-05-10 08:45:00',
 '2026-05-11 10:20:00', '2026-05-11 17:55:00',
 '2026-05-14 16:30:00', '2026-05-14 14:00:00',
 0, 0,
 'Amazon MDW2，标签已贴好', NULL,
 '演示数据：INBOUNDED，出单工作台-FBA MDW2', 1, '2026-05-08 16:00:00', 1, '2026-05-14 14:00:00', 0);


-- ============================================================
-- 4. 货件层
-- ============================================================
INSERT IGNORE INTO `oms_cargo_order_shipment` (
  `id`, `tenant_id`, `cargo_order_id`, `biz_root_id`,
  `shipment_no`, `po_no`, `shipping_mark`,
  `carton_qty`, `weight`, `cbm`,
  `dw_time`, `remark`,
  `create_by`, `create_time`, `update_by`, `update_time`, `deleted`
) VALUES
(9210017, '000000', 9200013, 9150013, 'PH-EWR4-008A', 'PO-PHG-2026-4401', 'PHG/EWR4/S8', 280.00, 3668.000, 15.400, '2026-05-20 00:00:00', 'DW已过期，紧急',           1, '2026-05-08 14:00:00', 1, '2026-05-13 10:00:00', 0),
(9210018, '000000', 9200014, 9150014, 'PH-EWR9-009A', 'PO-PHG-2026-4402', 'PHG/EWR9/S9', 310.00, 4061.000, 17.200, '2026-05-28 00:00:00', 'EWR9，实收多2箱',           1, '2026-05-08 14:00:00', 1, '2026-05-13 11:30:00', 0),
(9210019, '000000', 9200015, 9150015, 'NO-BDL2-008A', 'PO-NO-2026-2201',  'NO/BDL2/A',  260.00, 3458.000, 14.600, '2026-05-26 00:00:00', 'BDL2 FBA',                   1, '2026-05-08 15:00:00', 1, '2026-05-14 09:00:00', 0),
(9210020, '000000', 9200016, 9150016, 'NO-NJP-009A',  'PO-NO-2026-2301',  'NO/NJP/A',   180.00, 2394.000, 10.000, '2026-05-30 00:00:00', '私仓Edison，需预约',          1, '2026-05-08 15:30:00', 1, '2026-05-14 10:15:00', 0),
(9210021, '000000', 9200017, 9150017, 'EM-MDW2-008A', 'PO-EM-2026-9901',  'EM/MDW2/S8', 320.00, 4224.000, 17.900, '2026-05-29 00:00:00', 'MDW2 FBA，标签已贴',          1, '2026-05-08 16:00:00', 1, '2026-05-14 14:00:00', 0);


-- ============================================================
-- 5. SKU 明细层
-- ============================================================
INSERT IGNORE INTO `oms_cargo_order_sku_item` (
  `id`, `tenant_id`, `cargo_order_id`, `shipment_id`, `shipment_no`,
  `po_no`, `shipping_mark`,
  `sku`, `fnsku`, `product_name`,
  `qty`, `carton_qty`, `weight`, `cbm`, `remark`,
  `create_by`, `create_time`, `update_by`, `update_time`, `deleted`
) VALUES
-- CO9200013
(9220022, '000000', 9200013, 9210017, 'PH-EWR4-008A', 'PO-PHG-2026-4401', 'PHG/EWR4/S8', 'PHG-LAMP-007',  'X014LAMP01', 'Smart RGB Floor Lamp',         1680.00, 140.00, 1868.000,  7.700, NULL, 1, '2026-05-08 14:00:00', 1, '2026-05-08 14:00:00', 0),
(9220023, '000000', 9200013, 9210017, 'PH-EWR4-008A', 'PO-PHG-2026-4401', 'PHG/EWR4/S8', 'PHG-CORD-008',  'X015CORD01', 'USB-C Cable 3-pack',           2800.00, 140.00, 1812.000,  7.700, NULL, 1, '2026-05-08 14:00:00', 1, '2026-05-08 14:00:00', 0),
-- CO9200014
(9220024, '000000', 9200014, 9210018, 'PH-EWR9-009A', 'PO-PHG-2026-4402', 'PHG/EWR9/S9', 'PHG-DESK-009',  'X016DESK01', 'Foldable Standing Desk',       1550.00, 155.00, 2031.000,  8.600, NULL, 1, '2026-05-08 14:00:00', 1, '2026-05-08 14:00:00', 0),
(9220025, '000000', 9200014, 9210018, 'PH-EWR9-009A', 'PO-PHG-2026-4402', 'PHG/EWR9/S9', 'PHG-MONT-010',  'X017MONT01', 'Monitor Arm Dual VESA',        1550.00, 155.00, 2031.000,  8.600, NULL, 1, '2026-05-08 14:00:00', 1, '2026-05-08 14:00:00', 0),
-- CO9200015
(9220026, '000000', 9200015, 9210019, 'NO-BDL2-008A', 'PO-NO-2026-2201',  'NO/BDL2/A',   'NO-BOOT-005',   'X018BOOT01', 'Waterproof Hiking Boots L',    1300.00, 130.00, 1729.000,  7.300, NULL, 1, '2026-05-08 15:00:00', 1, '2026-05-08 15:00:00', 0),
(9220027, '000000', 9200015, 9210019, 'NO-BDL2-008A', 'PO-NO-2026-2201',  'NO/BDL2/A',   'NO-HELM-006',   'X019HELM01', 'Bike Helmet Adjustable',       1300.00, 130.00, 1729.000,  7.300, NULL, 1, '2026-05-08 15:00:00', 1, '2026-05-08 15:00:00', 0),
-- CO9200016
(9220028, '000000', 9200016, 9210020, 'NO-NJP-009A',  'PO-NO-2026-2301',  'NO/NJP/A',    'NO-KAYAK-007',  'X020KAYA01', 'Inflatable Kayak Single',       900.00,  90.00, 1197.000,  5.000, NULL, 1, '2026-05-08 15:30:00', 1, '2026-05-08 15:30:00', 0),
(9220029, '000000', 9200016, 9210020, 'NO-NJP-009A',  'PO-NO-2026-2301',  'NO/NJP/A',    'NO-PUMP-008',   'X021PUMP01', 'Electric Air Pump Portable',    900.00,  90.00, 1197.000,  5.000, NULL, 1, '2026-05-08 15:30:00', 1, '2026-05-08 15:30:00', 0),
-- CO9200017
(9220030, '000000', 9200017, 9210021, 'EM-MDW2-008A', 'PO-EM-2026-9901',  'EM/MDW2/S8',  'EM-CUBE-009',   'X022CUBE01', 'Speed Cube 3x3 Competition',   3200.00, 160.00, 2112.000,  8.950, NULL, 1, '2026-05-08 16:00:00', 1, '2026-05-08 16:00:00', 0),
(9220031, '000000', 9200017, 9210021, 'EM-MDW2-008A', 'PO-EM-2026-9901',  'EM/MDW2/S8',  'EM-CLAY-010',   'X023CLAY01', 'Modeling Clay Set 36 Colors',  3200.00, 160.00, 2112.000,  8.950, NULL, 1, '2026-05-08 16:00:00', 1, '2026-05-08 16:00:00', 0);


-- ============================================================
-- 6. 节点轨迹（全流程：PENDING_ACCEPT → INBOUNDED）
-- ============================================================
INSERT IGNORE INTO `oms_cargo_order_node_trace` (
  `id`, `tenant_id`, `cargo_order_id`, `biz_root_id`,
  `node_code`, `node_name`, `node_status`,
  `status_from`, `status_to`, `action`,
  `actual_time`, `source_type`, `operator_id`, `operator_name`, `remark`,
  `create_time`
) VALUES
-- === CO9200013 (EWR4，DW已过期) ===
(9230050,'000000',9200013,9150013,'PENDING_ACCEPT','待受理','DONE',NULL,'PENDING_ACCEPT','mockCreate','2026-05-08 14:00:00','MANUAL',1,'admin','创建','2026-05-08 14:00:00'),
(9230051,'000000',9200013,9150013,'ACCEPTED','已受理','DONE','PENDING_ACCEPT','ACCEPTED','accept','2026-05-08 16:00:00','MANUAL',1,'Amy','审核通过','2026-05-08 16:00:00'),
(9230052,'000000',9200013,9150013,'IN_TRANSIT','在途','DONE','ACCEPTED','IN_TRANSIT','markInTransit','2026-05-08 18:00:00','OMS',1,'Amy','开航','2026-05-08 18:00:00'),
(9230053,'000000',9200013,9150013,'ARRIVED_PORT','已到港','DONE','IN_TRANSIT','ARRIVED_PORT','confirmArrivedPort','2026-05-10 08:45:00','OMS',1,'Amy','靠港NJ','2026-05-10 08:45:00'),
(9230054,'000000',9200013,9150013,'PICKED_UP','已提柜','DONE','ARRIVED_PORT','PICKED_UP','confirmPickedUp','2026-05-11 10:20:00','OMS',1,'Amy','拖车提柜','2026-05-11 10:20:00'),
(9230055,'000000',9200013,9150013,'ARRIVED_WAREHOUSE','已到仓','DONE','PICKED_UP','ARRIVED_WAREHOUSE','confirmArrivedWarehouse','2026-05-11 17:55:00','OMS',1,'Amy','到仓YARD-B-03','2026-05-11 17:55:00'),
(9230056,'000000',9200013,9150013,'DEVANNING','拆柜中','DONE','ARRIVED_WAREHOUSE','DEVANNING','startDevanning','2026-05-12 09:15:00','OMS',1,'Amy','开始拆柜','2026-05-12 09:15:00'),
(9230057,'000000',9200013,9150013,'DEVANNED','拆柜完成','DONE','DEVANNING','DEVANNED','finishDevanning','2026-05-14 16:30:00','OMS',1,'Amy','拆柜完成','2026-05-14 16:30:00'),
(9230058,'000000',9200013,9150013,'INBOUNDED','已入库','DONE','DEVANNED','INBOUNDED','confirmInbounded','2026-05-13 10:00:00','WMS',1,'Amy','WMS入库确认，10板','2026-05-13 10:00:00'),

-- === CO9200014 (EWR9) ===
(9230059,'000000',9200014,9150014,'PENDING_ACCEPT','待受理','DONE',NULL,'PENDING_ACCEPT','mockCreate','2026-05-08 14:00:00','MANUAL',1,'admin','创建','2026-05-08 14:00:00'),
(9230060,'000000',9200014,9150014,'ACCEPTED','已受理','DONE','PENDING_ACCEPT','ACCEPTED','accept','2026-05-08 16:05:00','MANUAL',1,'Amy','审核通过','2026-05-08 16:05:00'),
(9230061,'000000',9200014,9150014,'IN_TRANSIT','在途','DONE','ACCEPTED','IN_TRANSIT','markInTransit','2026-05-08 18:00:00','OMS',1,'Amy','开航','2026-05-08 18:00:00'),
(9230062,'000000',9200014,9150014,'ARRIVED_PORT','已到港','DONE','IN_TRANSIT','ARRIVED_PORT','confirmArrivedPort','2026-05-10 08:45:00','OMS',1,'Amy','靠港NJ','2026-05-10 08:45:00'),
(9230063,'000000',9200014,9150014,'PICKED_UP','已提柜','DONE','ARRIVED_PORT','PICKED_UP','confirmPickedUp','2026-05-11 10:20:00','OMS',1,'Amy','拖车提柜','2026-05-11 10:20:00'),
(9230064,'000000',9200014,9150014,'ARRIVED_WAREHOUSE','已到仓','DONE','PICKED_UP','ARRIVED_WAREHOUSE','confirmArrivedWarehouse','2026-05-11 17:55:00','OMS',1,'Amy','到仓','2026-05-11 17:55:00'),
(9230065,'000000',9200014,9150014,'DEVANNING','拆柜中','DONE','ARRIVED_WAREHOUSE','DEVANNING','startDevanning','2026-05-12 09:15:00','OMS',1,'Amy','开始拆柜','2026-05-12 09:15:00'),
(9230066,'000000',9200014,9150014,'DEVANNED','拆柜完成','DONE','DEVANNING','DEVANNED','finishDevanning','2026-05-14 16:30:00','OMS',1,'Amy','实收312箱','2026-05-14 16:30:00'),
(9230067,'000000',9200014,9150014,'INBOUNDED','已入库','DONE','DEVANNED','INBOUNDED','confirmInbounded','2026-05-13 11:30:00','WMS',1,'Amy','WMS入库确认，11板','2026-05-13 11:30:00'),

-- === CO9200015 (BDL2) ===
(9230068,'000000',9200015,9150015,'PENDING_ACCEPT','待受理','DONE',NULL,'PENDING_ACCEPT','mockCreate','2026-05-08 15:00:00','MANUAL',1,'admin','创建','2026-05-08 15:00:00'),
(9230069,'000000',9200015,9150015,'ACCEPTED','已受理','DONE','PENDING_ACCEPT','ACCEPTED','accept','2026-05-08 17:00:00','MANUAL',1,'Mia','审核通过','2026-05-08 17:00:00'),
(9230070,'000000',9200015,9150015,'IN_TRANSIT','在途','DONE','ACCEPTED','IN_TRANSIT','markInTransit','2026-05-08 18:00:00','OMS',1,'Mia','开航','2026-05-08 18:00:00'),
(9230071,'000000',9200015,9150015,'ARRIVED_PORT','已到港','DONE','IN_TRANSIT','ARRIVED_PORT','confirmArrivedPort','2026-05-10 08:45:00','OMS',1,'Mia','靠港NJ','2026-05-10 08:45:00'),
(9230072,'000000',9200015,9150015,'PICKED_UP','已提柜','DONE','ARRIVED_PORT','PICKED_UP','confirmPickedUp','2026-05-11 10:20:00','OMS',1,'Mia','拖车提柜','2026-05-11 10:20:00'),
(9230073,'000000',9200015,9150015,'ARRIVED_WAREHOUSE','已到仓','DONE','PICKED_UP','ARRIVED_WAREHOUSE','confirmArrivedWarehouse','2026-05-11 17:55:00','OMS',1,'Mia','到仓','2026-05-11 17:55:00'),
(9230074,'000000',9200015,9150015,'DEVANNING','拆柜中','DONE','ARRIVED_WAREHOUSE','DEVANNING','startDevanning','2026-05-12 09:15:00','OMS',1,'Mia','开始拆柜','2026-05-12 09:15:00'),
(9230075,'000000',9200015,9150015,'DEVANNED','拆柜完成','DONE','DEVANNING','DEVANNED','finishDevanning','2026-05-14 16:30:00','OMS',1,'Mia','拆柜完成','2026-05-14 16:30:00'),
(9230076,'000000',9200015,9150015,'INBOUNDED','已入库','DONE','DEVANNED','INBOUNDED','confirmInbounded','2026-05-14 09:00:00','WMS',1,'Mia','WMS入库确认，9板','2026-05-14 09:00:00'),

-- === CO9200016 (私仓NJ) ===
(9230077,'000000',9200016,9150016,'PENDING_ACCEPT','待受理','DONE',NULL,'PENDING_ACCEPT','mockCreate','2026-05-08 15:30:00','MANUAL',1,'admin','创建','2026-05-08 15:30:00'),
(9230078,'000000',9200016,9150016,'ACCEPTED','已受理','DONE','PENDING_ACCEPT','ACCEPTED','accept','2026-05-08 17:30:00','MANUAL',1,'Mia','审核通过','2026-05-08 17:30:00'),
(9230079,'000000',9200016,9150016,'IN_TRANSIT','在途','DONE','ACCEPTED','IN_TRANSIT','markInTransit','2026-05-08 18:00:00','OMS',1,'Mia','开航','2026-05-08 18:00:00'),
(9230080,'000000',9200016,9150016,'ARRIVED_PORT','已到港','DONE','IN_TRANSIT','ARRIVED_PORT','confirmArrivedPort','2026-05-10 08:45:00','OMS',1,'Mia','靠港NJ','2026-05-10 08:45:00'),
(9230081,'000000',9200016,9150016,'PICKED_UP','已提柜','DONE','ARRIVED_PORT','PICKED_UP','confirmPickedUp','2026-05-11 10:20:00','OMS',1,'Mia','拖车提柜','2026-05-11 10:20:00'),
(9230082,'000000',9200016,9150016,'ARRIVED_WAREHOUSE','已到仓','DONE','PICKED_UP','ARRIVED_WAREHOUSE','confirmArrivedWarehouse','2026-05-11 17:55:00','OMS',1,'Mia','到仓','2026-05-11 17:55:00'),
(9230083,'000000',9200016,9150016,'DEVANNING','拆柜中','DONE','ARRIVED_WAREHOUSE','DEVANNING','startDevanning','2026-05-12 09:15:00','OMS',1,'Mia','开始拆柜','2026-05-12 09:15:00'),
(9230084,'000000',9200016,9150016,'DEVANNED','拆柜完成','DONE','DEVANNING','DEVANNED','finishDevanning','2026-05-14 16:30:00','OMS',1,'Mia','拆柜完成','2026-05-14 16:30:00'),
(9230085,'000000',9200016,9150016,'INBOUNDED','已入库','DONE','DEVANNED','INBOUNDED','confirmInbounded','2026-05-14 10:15:00','WMS',1,'Mia','WMS入库确认，7板','2026-05-14 10:15:00'),

-- === CO9200017 (MDW2) ===
(9230086,'000000',9200017,9150017,'PENDING_ACCEPT','待受理','DONE',NULL,'PENDING_ACCEPT','mockCreate','2026-05-08 16:00:00','MANUAL',1,'admin','创建','2026-05-08 16:00:00'),
(9230087,'000000',9200017,9150017,'ACCEPTED','已受理','DONE','PENDING_ACCEPT','ACCEPTED','accept','2026-05-08 18:00:00','MANUAL',1,'Tom','审核通过','2026-05-08 18:00:00'),
(9230088,'000000',9200017,9150017,'IN_TRANSIT','在途','DONE','ACCEPTED','IN_TRANSIT','markInTransit','2026-05-08 18:30:00','OMS',1,'Tom','开航','2026-05-08 18:30:00'),
(9230089,'000000',9200017,9150017,'ARRIVED_PORT','已到港','DONE','IN_TRANSIT','ARRIVED_PORT','confirmArrivedPort','2026-05-10 08:45:00','OMS',1,'Tom','靠港NJ','2026-05-10 08:45:00'),
(9230090,'000000',9200017,9150017,'PICKED_UP','已提柜','DONE','ARRIVED_PORT','PICKED_UP','confirmPickedUp','2026-05-11 10:20:00','OMS',1,'Tom','拖车提柜','2026-05-11 10:20:00'),
(9230091,'000000',9200017,9150017,'ARRIVED_WAREHOUSE','已到仓','DONE','PICKED_UP','ARRIVED_WAREHOUSE','confirmArrivedWarehouse','2026-05-11 17:55:00','OMS',1,'Tom','到仓','2026-05-11 17:55:00'),
(9230092,'000000',9200017,9150017,'DEVANNING','拆柜中','DONE','ARRIVED_WAREHOUSE','DEVANNING','startDevanning','2026-05-12 09:15:00','OMS',1,'Tom','开始拆柜','2026-05-12 09:15:00'),
(9230093,'000000',9200017,9150017,'DEVANNED','拆柜完成','DONE','DEVANNING','DEVANNED','finishDevanning','2026-05-14 16:30:00','OMS',1,'Tom','拆柜完成','2026-05-14 16:30:00'),
(9230094,'000000',9200017,9150017,'INBOUNDED','已入库','DONE','DEVANNED','INBOUNDED','confirmInbounded','2026-05-14 14:00:00','WMS',1,'Tom','WMS入库确认，12板','2026-05-14 14:00:00');


-- ============================================================
-- 7. 海柜-货物订单关联
-- ============================================================
INSERT IGNORE INTO `oms_container_cargo_order_rel` (
  `id`, `tenant_id`,
  `container_order_id`, `container_order_no`, `container_no`,
  `cargo_order_id`, `cargo_order_no`,
  `relation_type`, `relation_status`,
  `create_by`, `create_time`, `update_by`, `update_time`
) VALUES
(9240013, '000000', 9100004, 'SO202605100004', 'CMAU9876543', 9200013, 'CO202605080001', 'SPLIT', 'ACTIVE', 1, '2026-05-08 14:00:00', 1, '2026-05-08 14:00:00'),
(9240014, '000000', 9100004, 'SO202605100004', 'CMAU9876543', 9200014, 'CO202605080002', 'SPLIT', 'ACTIVE', 1, '2026-05-08 14:00:00', 1, '2026-05-08 14:00:00'),
(9240015, '000000', 9100004, 'SO202605100004', 'CMAU9876543', 9200015, 'CO202605080003', 'SPLIT', 'ACTIVE', 1, '2026-05-08 15:00:00', 1, '2026-05-08 15:00:00'),
(9240016, '000000', 9100004, 'SO202605100004', 'CMAU9876543', 9200016, 'CO202605080004', 'SPLIT', 'ACTIVE', 1, '2026-05-08 15:30:00', 1, '2026-05-08 15:30:00'),
(9240017, '000000', 9100004, 'SO202605100004', 'CMAU9876543', 9200017, 'CO202605080005', 'SPLIT', 'ACTIVE', 1, '2026-05-08 16:00:00', 1, '2026-05-08 16:00:00');
