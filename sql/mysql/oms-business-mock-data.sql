-- =============================================================================
-- OMS 业务模拟数据（海柜 → 货物订单 → 出单工作台 → 预出单 → 出库单）
-- 表名与 yudao-module-oms DO 一致：oms_container_order / oms_cargo_order / ...
-- 前置：base-mock-data.sql（仓库 9001/9002、客户 1001/1002、平台地址 ONT8/LAX9）
--       oms-init-from-reference.sql 或等价全量 OMS 表结构
--       oms-yudao-audit-columns-alter.sql（creator/updater 列，建议已执行）
-- 租户 tenant_id = 1；可重复执行（固定 ID 段 30xxx~39xxx）
-- =============================================================================
SET NAMES utf8mb4;

SET @tid = 1;
SET @creator = 'admin';
SET @now = NOW();
SET @co = 9001;  -- 主体
SET @wh_la = 9001;
SET @wh_nj = 9002;
SET @cust_a = 1001;
SET @cust_b = 1002;
SET @plat_amz = 9001;

-- ========== 清理（子表 → 主表）==========
-- 入库计划依赖货件；重跑 mock 时一并清理演示海柜下的计划，避免残留失效明细
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

DELETE FROM `oms_outbound_order_item` WHERE `tenant_id` = @tid AND `id` BETWEEN 39001 AND 39999;
DELETE FROM `oms_outbound_order`      WHERE `tenant_id` = @tid AND `id` BETWEEN 38001 AND 38999;
DELETE FROM `oms_pre_outbound_item`   WHERE `tenant_id` = @tid AND `id` BETWEEN 37001 AND 37999;
DELETE FROM `oms_pre_outbound`        WHERE `tenant_id` = @tid AND `id` BETWEEN 36001 AND 36999;
DELETE FROM `oms_cargo_order_sku_item`    WHERE `tenant_id` = @tid AND `id` BETWEEN 35001 AND 35999;
DELETE FROM `oms_cargo_order_shipment`    WHERE `tenant_id` = @tid AND `id` BETWEEN 34001 AND 34999;
DELETE FROM `oms_container_cargo_order_rel` WHERE `tenant_id` = @tid AND `id` BETWEEN 33001 AND 33999;
DELETE FROM `oms_cargo_order`         WHERE `tenant_id` = @tid AND `id` BETWEEN 32001 AND 32999;
DELETE FROM `oms_container_order`     WHERE `tenant_id` = @tid AND `id` BETWEEN 31001 AND 31999;
DELETE FROM `biz_root`                WHERE `tenant_id` = @tid AND `id` BETWEEN 30001 AND 30999;

-- ========== 1. 业务主线 ==========
INSERT INTO `biz_root` (
    `id`, `company_id`, `warehouse_id`, `root_no`, `root_type`, `source_module`, `source_order_id`, `source_order_no`,
    `customer_id`, `customer_name`, `root_status`, `exception_flag`, `exception_count`, `start_time`,
    `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`
) VALUES
(30001, @co, @wh_la, 'BR-20260602-000001', 'CARGO_ORDER', 'OMS', 32001, 'CO-20260602-000001', @cust_a, '演示货主 A', 'RUNNING', 0, 0, @now, @creator, @now, @creator, @now, b'0', @tid),
(30002, @co, @wh_la, 'BR-20260602-000002', 'CARGO_ORDER', 'OMS', 32002, 'CO-20260602-000002', @cust_a, '演示货主 A', 'RUNNING', 0, 0, @now, @creator, @now, @creator, @now, b'0', @tid),
(30003, @co, @wh_la, 'BR-20260602-000003', 'CARGO_ORDER', 'OMS', 32003, 'CO-20260602-000003', @cust_a, '演示货主 A', 'RUNNING', 0, 0, @now, @creator, @now, @creator, @now, b'0', @tid),
(30004, @co, @wh_la, 'BR-20260602-000004', 'CARGO_ORDER', 'OMS', 32004, 'CO-20260602-000004', @cust_a, '演示货主 A', 'RUNNING', 0, 0, @now, @creator, @now, @creator, @now, b'0', @tid),
(30005, @co, @wh_la, 'BR-20260602-000005', 'CARGO_ORDER', 'OMS', 32005, 'CO-20260602-000005', @cust_b, '演示货主 B', 'RUNNING', 0, 0, @now, @creator, @now, @creator, @now, b'0', @tid),
(30006, @co, @wh_nj, 'BR-20260602-000006', 'CARGO_ORDER', 'OMS', 32006, 'CO-20260602-000006', @cust_b, '演示货主 B', 'RUNNING', 0, 0, @now, @creator, @now, @creator, @now, b'0', @tid),
(30007, @co, @wh_la, 'BR-20260602-000007', 'CARGO_ORDER', 'OMS', 32007, 'CO-20260602-000007', @cust_a, '演示货主 A', 'RUNNING', 0, 0, @now, @creator, @now, @creator, @now, b'0', @tid),
(30008, @co, @wh_la, 'BR-20260602-000008', 'CARGO_ORDER', 'OMS', 32008, 'CO-20260602-000008', @cust_a, '演示货主 A', 'RUNNING', 0, 0, @now, @creator, @now, @creator, @now, b'0', @tid),
(30009, @co, @wh_la, 'BR-20260602-000009', 'CARGO_ORDER', 'OMS', 32009, 'CO-20260602-000009', @cust_a, '演示货主 A', 'RUNNING', 0, 0, @now, @creator, @now, @creator, @now, b'0', @tid),
(30010, @co, @wh_la, 'BR-20260602-000010', 'CARGO_ORDER', 'OMS', 32010, 'CO-20260602-000010', @cust_a, '演示货主 A', 'RUNNING', 0, 0, @now, @creator, @now, @creator, @now, b'0', @tid),
(30011, @co, @wh_la, 'BR-20260602-000011', 'CARGO_ORDER', 'OMS', 32011, 'CO-20260602-000011', @cust_a, '演示货主 A', 'RUNNING', 0, 0, @now, @creator, @now, @creator, @now, b'0', @tid),
(30012, @co, @wh_la, 'BR-20260602-000012', 'CARGO_ORDER', 'OMS', 32012, 'CO-20260602-000012', @cust_a, '演示货主 A', 'RUNNING', 0, 0, @now, @creator, @now, @creator, @now, b'0', @tid),
(30013, @co, @wh_nj, 'BR-20260602-000013', 'CARGO_ORDER', 'OMS', 32013, 'CO-20260602-000013', @cust_b, '演示货主 B', 'RUNNING', 0, 0, @now, @creator, @now, @creator, @now, b'0', @tid),
(30014, @co, @wh_nj, 'BR-20260602-000014', 'CARGO_ORDER', 'OMS', 32014, 'CO-20260602-000014', @cust_b, '演示货主 B', 'RUNNING', 0, 0, @now, @creator, @now, @creator, @now, b'0', @tid),
(30015, @co, @wh_nj, 'BR-20260602-000015', 'CARGO_ORDER', 'OMS', 32015, 'CO-20260602-000015', @cust_b, '演示货主 B', 'COMPLETED', 0, 0, @now, @creator, @now, @creator, @now, b'0', @tid)
ON DUPLICATE KEY UPDATE `root_status` = VALUES(`root_status`), `updater` = VALUES(`updater`), `update_time` = @now;

-- ========== 2. 海柜订单（8 柜）==========
INSERT INTO `oms_container_order` (
    `id`, `company_id`, `customer_id`, `customer_name`, `warehouse_id`, `inbound_warehouse_name`,
    `container_order_no`, `order_source`, `container_no`, `container_type`,
    `vessel_name`, `voyage_no`, `mbl_no`, `eta`, `ata`, `pickup_lfd`, `empty_return_lfd`,
    `terminal_release_status`, `hold_flag`, `exam_flag`,
    `expected_arrival_time`, `actual_arrival_time`, `container_location`,
    `total_carton_qty`, `total_pallet_qty`, `total_weight`, `total_cbm`,
    `container_exception_flag`, `downstream_exception_flag`,
    `container_status`, `internal_remark`, `status`,
    `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`
) VALUES
(31001, @co, @cust_a, '演示货主 A', @wh_la, '洛杉矶一号仓', 'SO-20260602-001', 'MANUAL', 'MSCU1234567', '40HQ',
 'MSC OSCAR', '521W', 'MBL-LA-001', DATE_ADD(@now, INTERVAL 5 DAY), NULL, DATE_ADD(@now, INTERVAL 8 DAY), DATE_ADD(@now, INTERVAL 14 DAY),
 'RELEASED', 0, 0, DATE_ADD(@now, INTERVAL 6 DAY), NULL, 'CNT-LA-Y01', 420, 18, 12500.000, 58.500, 0, 0,
 'IN_TRANSIT', '在途-柜内2票待出单', '0', @creator, @now, @creator, @now, b'0', @tid),
(31002, @co, @cust_a, '演示货主 A', @wh_la, '洛杉矶一号仓', 'SO-20260602-002', 'MANUAL', 'HLCU7654321', '40HQ',
 'HAPAG BERLIN', '088E', 'MBL-LA-002', DATE_SUB(@now, INTERVAL 3 DAY), DATE_SUB(@now, INTERVAL 2 DAY), DATE_ADD(@now, INTERVAL 2 DAY), DATE_ADD(@now, INTERVAL 10 DAY),
 'RELEASED', 0, 0, DATE_SUB(@now, INTERVAL 1 DAY), DATE_SUB(@now, INTERVAL 1 DAY), 'DOC-LA-A02', 380, 16, 11200.000, 52.300, 0, 0,
 'DEVANNING', '拆柜中', '0', @creator, @now, @creator, @now, b'0', @tid),
(31003, @co, @cust_a, '演示货主 A', @wh_la, '洛杉矶一号仓', 'SO-20260602-003', 'IMPORT', 'OOLU9876543', '20GP',
 'OOCL MALAYSIA', '045E', 'MBL-LA-003', DATE_SUB(@now, INTERVAL 5 DAY), DATE_SUB(@now, INTERVAL 4 DAY), DATE_ADD(@now, INTERVAL 1 DAY), DATE_ADD(@now, INTERVAL 8 DAY),
 'RELEASED', 0, 0, DATE_SUB(@now, INTERVAL 2 DAY), DATE_SUB(@now, INTERVAL 2 DAY), 'DOC-LA-A01', 260, 10, 6800.000, 28.600, 0, 0,
 'ARRIVED_WAREHOUSE', '已到仓待拆', '0', @creator, @now, @creator, @now, b'0', @tid),
(31004, @co, @cust_b, '演示货主 B', @wh_la, '洛杉矶一号仓', 'SO-20260602-004', 'MANUAL', 'EGSU5566778', '40HQ',
 'EVER GOLDEN', '112W', 'MBL-LA-004', DATE_SUB(@now, INTERVAL 7 DAY), DATE_SUB(@now, INTERVAL 6 DAY), DATE_SUB(@now, INTERVAL 1 DAY), DATE_ADD(@now, INTERVAL 5 DAY),
 'RELEASED', 0, 0, DATE_SUB(@now, INTERVAL 4 DAY), DATE_SUB(@now, INTERVAL 4 DAY), 'DOC-LA-B01', 510, 22, 14800.000, 61.200, 0, 0,
 'DEVANNED', '拆柜完成-多票可出单', '0', @creator, @now, @creator, @now, b'0', @tid),
(31005, @co, @cust_b, '演示货主 B', @wh_nj, '新泽西一号仓', 'SO-20260602-005', 'IMPORT', 'MAEU3344556', '40GP',
 'MAERSK SENTOSA', '339W', 'MBL-NJ-001', DATE_ADD(@now, INTERVAL 2 DAY), NULL, DATE_ADD(@now, INTERVAL 5 DAY), DATE_ADD(@now, INTERVAL 12 DAY),
 'UNKNOWN', 0, 0, DATE_ADD(@now, INTERVAL 3 DAY), NULL, NULL, 300, 12, 9200.000, 38.400, 0, 0,
 'PENDING_ACCEPT', '待受理', '0', @creator, @now, @creator, @now, b'0', @tid),
(31006, @co, @cust_a, '演示货主 A', @wh_nj, '新泽西一号仓', 'SO-20260602-006', 'MANUAL', 'CMAU2233445', '45HQ',
 'CMA CGM MARCO', '201E', 'MBL-NJ-002', DATE_SUB(@now, INTERVAL 4 DAY), DATE_SUB(@now, INTERVAL 3 DAY), DATE_ADD(@now, INTERVAL 3 DAY), DATE_ADD(@now, INTERVAL 11 DAY),
 'HOLDING', 1, 0, DATE_SUB(@now, INTERVAL 1 DAY), NULL, NULL, 180, 8, 5600.000, 24.100, 1, 0,
 'HOLDING', '海关Hold', '0', @creator, @now, @creator, @now, b'0', @tid),
(31007, @co, @cust_b, '演示货主 B', @wh_nj, '新泽西一号仓', 'SO-20260602-007', 'MANUAL', 'COSU8899001', '40HQ',
 'COSCO SHIPPING', '078W', 'MBL-NJ-003', DATE_SUB(@now, INTERVAL 10 DAY), DATE_SUB(@now, INTERVAL 9 DAY), DATE_SUB(@now, INTERVAL 3 DAY), DATE_ADD(@now, INTERVAL 2 DAY),
 'RELEASED', 0, 0, DATE_SUB(@now, INTERVAL 7 DAY), DATE_SUB(@now, INTERVAL 7 DAY), 'DOC-NJ-A01', 440, 19, 13100.000, 55.800, 0, 0,
 'COMPLETED', '已完成海柜', '0', @creator, @now, @creator, @now, b'0', @tid),
(31008, @co, @cust_a, '演示货主 A', @wh_la, '洛杉矶一号仓', 'SO-20260602-008', 'API', 'KMTU1122334', '20GP',
 'K-LINE', '055N', 'MBL-LA-008', DATE_ADD(@now, INTERVAL 10 DAY), NULL, DATE_ADD(@now, INTERVAL 15 DAY), DATE_ADD(@now, INTERVAL 20 DAY),
 'UNKNOWN', 0, 0, DATE_ADD(@now, INTERVAL 11 DAY), NULL, NULL, 150, 6, 4200.000, 18.500, 0, 0,
 'PICKED_UP', '已提柜在途到仓', '0', @creator, @now, @creator, @now, b'0', @tid)
ON DUPLICATE KEY UPDATE `container_status` = VALUES(`container_status`), `updater` = VALUES(`updater`), `update_time` = @now;

-- ========== 3. 货物订单（15 票，覆盖出单全链路）==========
-- 32001~32006：出单工作台（pre_outbound_status=NONE, outbound_order_status=NONE）
-- 32007~32011：已建预出单（各状态）
-- 32012~32015：已转出库单
INSERT INTO `oms_cargo_order` (
    `id`, `company_id`, `biz_root_id`, `shipment_codes`, `po_nos`, `marks`,
    `cargo_order_no`, `order_source`, `customer_id`, `customer_name`,
    `business_type_name`, `platform_id`, `platform_name`,
    `container_order_id`, `container_no`, `inbound_warehouse_id`, `inbound_warehouse_name`,
    `address_type`, `platform_warehouse_code`, `consignee_name`, `address_line1`, `city`, `state`, `zip_code`, `country`,
    `transfer_flag`, `transfer_warehouse_code`,
    `declared_carton_qty`, `declared_pallet_qty`, `declared_weight`, `declared_cbm`,
    `actual_carton_qty`, `actual_pallet_qty`, `actual_weight`, `actual_cbm`,
    `pre_outbound_flag`, `pre_outbound_no`, `pre_outbound_status`,
    `outbound_batch_no`, `outbound_order_status`,
    `order_status`, `fulfillment_status`, `appointment_status`, `pod_status`, `billing_status`,
    `earliest_dw_time`, `delivery_lfd`, `actual_inbound_time`, `devanning_finish_time`,
    `hold_flag`, `exception_flag`,
    `customer_remark`, `internal_remark`,
    `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`
) VALUES
-- 【出单工作台】已入库可建预出单
(32001, @co, 30001, 'FBA-001,FBA-002', 'PO-A-001,PO-A-002', 'MARK-A',
 'CO-20260602-000001', 'MANUAL', @cust_a, '演示货主 A', '卡车派送', @plat_amz, 'Amazon',
 31004, 'EGSU5566778', @wh_la, '洛杉矶一号仓', 'PLATFORM_WH', 'ONT8', 'Amazon ONT8', '1910 E Central Ave', 'Ontario', 'CA', '91761', 'US',
 0, NULL, 80, 4, 560.000, 4.200, 80, 4, 558.000, 4.150, 0, NULL, 'NONE', NULL, 'NONE',
 'NORMAL', 'INBOUNDED', 'NONE', 'PENDING', 'UNBILLED', DATE_ADD(@now, INTERVAL 2 DAY), DATE_ADD(@now, INTERVAL 7 DAY), DATE_SUB(@now, INTERVAL 1 DAY), DATE_SUB(@now, INTERVAL 2 DAY),
 0, 0, NULL, '工作台-已入库可出单', @creator, @now, @creator, @now, b'0', @tid),
(32002, @co, 30002, 'FBA-003', 'PO-A-003', 'MARK-A2',
 'CO-20260602-000002', 'MANUAL', @cust_a, '演示货主 A', '卡车派送', @plat_amz, 'Amazon',
 31004, 'EGSU5566778', @wh_la, '洛杉矶一号仓', 'PLATFORM_WH', 'LAX9', 'Amazon LAX9', '6750 Kimball Ave', 'Los Angeles', 'CA', '90805', 'US',
 0, NULL, 60, 3, 430.000, 3.400, 60, 3, 428.000, 3.350, 0, NULL, 'NONE', NULL, 'NONE',
 'NORMAL', 'INBOUNDED', 'NONE', 'PENDING', 'UNBILLED', DATE_ADD(@now, INTERVAL 3 DAY), DATE_ADD(@now, INTERVAL 8 DAY), DATE_SUB(@now, INTERVAL 1 DAY), DATE_SUB(@now, INTERVAL 2 DAY),
 0, 0, NULL, '工作台-同柜第二票', @creator, @now, @creator, @now, b'0', @tid),
-- 拆柜中 / 未到仓完
(32003, @co, 30003, 'FBA-004', 'PO-A-004', 'MARK-B',
 'CO-20260602-000003', 'MANUAL', @cust_a, '演示货主 A', '卡车派送', @plat_amz, 'Amazon',
 31002, 'HLCU7654321', @wh_la, '洛杉矶一号仓', 'PLATFORM_WH', 'ONT8', 'Amazon ONT8', '1910 E Central Ave', 'Ontario', 'CA', '91761', 'US',
 0, NULL, 72, 3, 510.000, 3.900, 40, 2, 320.000, 2.500, 0, NULL, 'NONE', NULL, 'NONE',
 'NORMAL', 'DEVANNING', 'NONE', 'PENDING', 'UNBILLED', DATE_ADD(@now, INTERVAL 4 DAY), DATE_ADD(@now, INTERVAL 9 DAY), NULL, NULL,
 0, 0, NULL, '工作台-拆柜中', @creator, @now, @creator, @now, b'0', @tid),
(32004, @co, 30004, 'FBA-005', 'PO-A-005', 'MARK-B2',
 'CO-20260602-000004', 'IMPORT', @cust_a, '演示货主 A', '卡车派送', @plat_amz, 'Amazon',
 31002, 'HLCU7654321', @wh_la, '洛杉矶一号仓', 'PLATFORM_WH', 'LAX9', 'Amazon LAX9', '6750 Kimball Ave', 'Los Angeles', 'CA', '90805', 'US',
 0, NULL, 55, 2, 390.000, 3.100, 55, 2, 388.000, 3.050, 0, NULL, 'NONE', NULL, 'NONE',
 'NORMAL', 'DEVANNED', 'NONE', 'PENDING', 'UNBILLED', DATE_ADD(@now, INTERVAL 5 DAY), DATE_ADD(@now, INTERVAL 10 DAY), NULL, DATE_SUB(@now, INTERVAL 3 HOUR),
 0, 0, NULL, '工作台-拆柜完成待入库', @creator, @now, @creator, @now, b'0', @tid),
(32005, @co, 30005, 'FBA-006', 'PO-B-001', 'MARK-C',
 'CO-20260602-000005', 'MANUAL', @cust_b, '演示货主 B', '卡车派送', @plat_amz, 'Amazon',
 31003, 'OOLU9876543', @wh_la, '洛杉矶一号仓', 'PLATFORM_WH', 'FTW1', 'Amazon FTW1', '3351 S Houston Ave', 'Houston', 'TX', '77001', 'US',
 0, NULL, 48, 2, 340.000, 2.800, NULL, NULL, NULL, NULL, 0, NULL, 'NONE', NULL, 'NONE',
 'NORMAL', 'ARRIVED_WAREHOUSE', 'NONE', 'PENDING', 'UNBILLED', DATE_ADD(@now, INTERVAL 6 DAY), DATE_ADD(@now, INTERVAL 12 DAY), NULL, NULL,
 0, 0, NULL, '工作台-已到仓', @creator, @now, @creator, @now, b'0', @tid),
(32006, @co, 30006, 'FBA-007', 'PO-B-002', 'MARK-C2',
 'CO-20260602-000006', 'MANUAL', @cust_b, '演示货主 B', '卡车派送', NULL, NULL,
 31004, 'EGSU5566778', @wh_nj, '新泽西一号仓', 'PRIVATE', NULL, 'Private WH LLC', '2500 Industrial Blvd', 'Los Angeles', 'CA', '90001', 'US',
 1, 'RNO1', 36, 2, 280.000, 2.200, 36, 2, 278.000, 2.180, 0, NULL, 'NONE', NULL, 'NONE',
 'NORMAL', 'INBOUNDED', 'NONE', 'PENDING', 'UNBILLED', DATE_ADD(@now, INTERVAL 1 DAY), DATE_ADD(@now, INTERVAL 6 DAY), DATE_SUB(@now, INTERVAL 2 DAY), DATE_SUB(@now, INTERVAL 3 DAY),
 0, 0, '转仓单', '工作台-转仓+已入库', @creator, @now, @creator, @now, b'0', @tid),
-- 【预出单】已占用，不出现在工作台
(32007, @co, 30007, 'FBA-008', 'PO-A-008', 'MARK-D',
 'CO-20260602-000007', 'MANUAL', @cust_a, '演示货主 A', '卡车派送', @plat_amz, 'Amazon',
 31001, 'MSCU1234567', @wh_la, '洛杉矶一号仓', 'PLATFORM_WH', 'ONT8', 'Amazon ONT8', '1910 E Central Ave', 'Ontario', 'CA', '91761', 'US',
 0, NULL, 42, 2, 310.000, 2.500, 30, 1, 220.000, 1.800, 1, 'POB-20260602-001', 'PENDING_INBOUND', NULL, 'NONE',
 'NORMAL', 'DEVANNING', 'NONE', 'PENDING', 'UNBILLED', DATE_ADD(@now, INTERVAL 7 DAY), DATE_ADD(@now, INTERVAL 14 DAY), NULL, NULL,
 0, 0, NULL, '预出单-待入库', @creator, @now, @creator, @now, b'0', @tid),
(32008, @co, 30008, 'FBA-009', 'PO-A-009', 'MARK-D2',
 'CO-20260602-000008', 'MANUAL', @cust_a, '演示货主 A', '卡车派送', @plat_amz, 'Amazon',
 31002, 'HLCU7654321', @wh_la, '洛杉矶一号仓', 'PLATFORM_WH', 'LAX9', 'Amazon LAX9', '6750 Kimball Ave', 'Los Angeles', 'CA', '90805', 'US',
 0, NULL, 50, 2, 360.000, 2.900, 35, 2, 300.000, 2.400, 1, 'POB-20260602-002', 'DEVANNING', NULL, 'NONE',
 'NORMAL', 'DEVANNING', 'NONE', 'PENDING', 'UNBILLED', DATE_ADD(@now, INTERVAL 4 DAY), DATE_ADD(@now, INTERVAL 11 DAY), NULL, NULL,
 0, 0, NULL, '预出单-拆柜中(合并1)', @creator, @now, @creator, @now, b'0', @tid),
(32009, @co, 30009, 'FBA-010', 'PO-A-010', 'MARK-D3',
 'CO-20260602-000009', 'MANUAL', @cust_a, '演示货主 A', '卡车派送', @plat_amz, 'Amazon',
 31002, 'HLCU7654321', @wh_la, '洛杉矶一号仓', 'PLATFORM_WH', 'ONT8', 'Amazon ONT8', '1910 E Central Ave', 'Ontario', 'CA', '91761', 'US',
 0, NULL, 38, 2, 270.000, 2.100, 38, 2, 268.000, 2.080, 1, 'POB-20260602-002', 'DEVANNING', NULL, 'NONE',
 'NORMAL', 'DEVANNING', 'NONE', 'PENDING', 'UNBILLED', DATE_ADD(@now, INTERVAL 4 DAY), DATE_ADD(@now, INTERVAL 11 DAY), NULL, NULL,
 0, 0, NULL, '预出单-拆柜中(合并2)', @creator, @now, @creator, @now, b'0', @tid),
(32010, @co, 30010, 'FBA-011', 'PO-A-011', 'MARK-E',
 'CO-20260602-000010', 'MANUAL', @cust_a, '演示货主 A', '卡车派送', @plat_amz, 'Amazon',
 31004, 'EGSU5566778', @wh_la, '洛杉矶一号仓', 'PLATFORM_WH', 'ONT8', 'Amazon ONT8', '1910 E Central Ave', 'Ontario', 'CA', '91761', 'US',
 0, NULL, 44, 2, 320.000, 2.600, 44, 2, 318.000, 2.550, 1, 'POB-20260602-003', 'READY_TO_CONVERT', NULL, 'NONE',
 'NORMAL', 'INBOUNDED', 'NONE', 'PENDING', 'UNBILLED', DATE_ADD(@now, INTERVAL 2 DAY), DATE_ADD(@now, INTERVAL 8 DAY), DATE_SUB(@now, INTERVAL 1 DAY), DATE_SUB(@now, INTERVAL 2 DAY),
 0, 0, NULL, '预出单-可转出库(合并1)', @creator, @now, @creator, @now, b'0', @tid),
(32011, @co, 30011, 'FBA-012', 'PO-A-012', 'MARK-E2',
 'CO-20260602-000011', 'MANUAL', @cust_a, '演示货主 A', '卡车派送', @plat_amz, 'Amazon',
 31004, 'EGSU5566778', @wh_la, '洛杉矶一号仓', 'PLATFORM_WH', 'LAX9', 'Amazon LAX9', '6750 Kimball Ave', 'Los Angeles', 'CA', '90805', 'US',
 0, NULL, 32, 1, 240.000, 1.900, 32, 1, 238.000, 1.880, 1, 'POB-20260602-003', 'READY_TO_CONVERT', NULL, 'NONE',
 'NORMAL', 'INBOUNDED', 'NONE', 'PENDING', 'UNBILLED', DATE_ADD(@now, INTERVAL 2 DAY), DATE_ADD(@now, INTERVAL 8 DAY), DATE_SUB(@now, INTERVAL 1 DAY), DATE_SUB(@now, INTERVAL 2 DAY),
 0, 0, NULL, '预出单-可转出库(合并2)', @creator, @now, @creator, @now, b'0', @tid),
-- 【出库单】已转正式出单
(32012, @co, 30012, 'FBA-013', 'PO-A-013', 'MARK-F',
 'CO-20260602-000012', 'MANUAL', @cust_a, '演示货主 A', '卡车派送', @plat_amz, 'Amazon',
 31004, 'EGSU5566778', @wh_la, '洛杉矶一号仓', 'PLATFORM_WH', 'ONT8', 'Amazon ONT8', '1910 E Central Ave', 'Ontario', 'CA', '91761', 'US',
 0, NULL, 56, 3, 400.000, 3.200, 56, 3, 398.000, 3.180, 1, 'POB-20260602-004', 'CONVERTED', 'OB-20260602-001', 'CREATED',
 'NORMAL', 'OUTBOUND_ORDERED', 'NONE', 'PENDING', 'UNBILLED', DATE_ADD(@now, INTERVAL 1 DAY), DATE_ADD(@now, INTERVAL 6 DAY), DATE_SUB(@now, INTERVAL 2 DAY), DATE_SUB(@now, INTERVAL 3 DAY),
 0, 0, NULL, '出库单-已创建', @creator, @now, @creator, @now, b'0', @tid),
(32013, @co, 30013, 'FBA-014', 'PO-B-014', 'MARK-G',
 'CO-20260602-000013', 'MANUAL', @cust_b, '演示货主 B', '卡车派送', @plat_amz, 'Amazon',
 31007, 'COSU8899001', @wh_nj, '新泽西一号仓', 'PLATFORM_WH', 'EWR4', 'Amazon EWR4', '50 New Canton Way', 'Edison', 'NJ', '08817', 'US',
 0, NULL, 64, 3, 450.000, 3.600, 64, 3, 448.000, 3.550, 1, 'POB-20260602-005', 'CONVERTED', 'OB-20260602-002', 'DISPATCHED',
 'NORMAL', 'OUTBOUND_ORDERED', 'CONFIRMED', 'PENDING', 'UNBILLED', DATE_SUB(@now, INTERVAL 2 DAY), DATE_ADD(@now, INTERVAL 4 DAY), DATE_SUB(@now, INTERVAL 5 DAY), DATE_SUB(@now, INTERVAL 6 DAY),
 0, 0, NULL, '出库单-已派发', @creator, @now, @creator, @now, b'0', @tid),
(32014, @co, 30014, 'FBA-015', 'PO-B-015', 'MARK-G2',
 'CO-20260602-000014', 'MANUAL', @cust_b, '演示货主 B', '卡车派送', @plat_amz, 'Amazon',
 31007, 'COSU8899001', @wh_nj, '新泽西一号仓', 'PLATFORM_WH', 'LAX9', 'Amazon LAX9', '6750 Kimball Ave', 'Los Angeles', 'CA', '90805', 'US',
 0, NULL, 40, 2, 290.000, 2.300, 40, 2, 288.000, 2.280, 1, 'POB-20260602-006', 'CONVERTED', 'OB-20260602-003', 'DELIVERING',
 'NORMAL', 'DELIVERING', 'CONFIRMED', 'PENDING', 'UNBILLED', DATE_SUB(@now, INTERVAL 3 DAY), DATE_ADD(@now, INTERVAL 2 DAY), DATE_SUB(@now, INTERVAL 6 DAY), DATE_SUB(@now, INTERVAL 7 DAY),
 0, 0, NULL, '出库单-派送中', @creator, @now, @creator, @now, b'0', @tid),
(32015, @co, 30015, 'FBA-016', 'PO-B-016', 'MARK-H',
 'CO-20260602-000015', 'MANUAL', @cust_b, '演示货主 B', '卡车派送', @plat_amz, 'Amazon',
 31007, 'COSU8899001', @wh_nj, '新泽西一号仓', 'PLATFORM_WH', 'ONT8', 'Amazon ONT8', '1910 E Central Ave', 'Ontario', 'CA', '91761', 'US',
 0, NULL, 28, 1, 200.000, 1.600, 28, 1, 198.000, 1.580, 1, 'POB-20260602-007', 'CONVERTED', 'OB-20260602-004', 'COMPLETED',
 'NORMAL', 'COMPLETED', 'CONFIRMED', 'UPLOADED', 'BILLED', DATE_SUB(@now, INTERVAL 10 DAY), DATE_SUB(@now, INTERVAL 5 DAY), DATE_SUB(@now, INTERVAL 12 DAY), DATE_SUB(@now, INTERVAL 13 DAY),
 0, 0, NULL, '出库单-已完成', @creator, @now, @creator, @now, b'0', @tid)
ON DUPLICATE KEY UPDATE
    `container_order_id` = VALUES(`container_order_id`),
    `container_no` = VALUES(`container_no`),
    `inbound_warehouse_id` = VALUES(`inbound_warehouse_id`),
    `inbound_warehouse_name` = VALUES(`inbound_warehouse_name`),
    `fulfillment_status` = VALUES(`fulfillment_status`),
    `pre_outbound_status` = VALUES(`pre_outbound_status`),
    `outbound_order_status` = VALUES(`outbound_order_status`),
    `updater` = VALUES(`updater`), `update_time` = @now;

-- ========== 4. 海柜-货物关系 ==========
INSERT INTO `oms_container_cargo_order_rel` (
    `id`, `container_order_id`, `container_order_no`, `container_no`, `cargo_order_id`, `cargo_order_no`,
    `relation_type`, `relation_status`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`
) VALUES
(33001, 31004, 'SO-20260602-004', 'EGSU5566778', 32001, 'CO-20260602-000001', 'LOADED_IN', 'ACTIVE', @creator, @now, @creator, @now, b'0', @tid),
(33002, 31004, 'SO-20260602-004', 'EGSU5566778', 32002, 'CO-20260602-000002', 'LOADED_IN', 'ACTIVE', @creator, @now, @creator, @now, b'0', @tid),
(33003, 31002, 'SO-20260602-002', 'HLCU7654321', 32003, 'CO-20260602-000003', 'LOADED_IN', 'ACTIVE', @creator, @now, @creator, @now, b'0', @tid),
(33004, 31002, 'SO-20260602-002', 'HLCU7654321', 32004, 'CO-20260602-000004', 'LOADED_IN', 'ACTIVE', @creator, @now, @creator, @now, b'0', @tid),
(33005, 31003, 'SO-20260602-003', 'OOLU9876543', 32005, 'CO-20260602-000005', 'LOADED_IN', 'ACTIVE', @creator, @now, @creator, @now, b'0', @tid),
(33006, 31004, 'SO-20260602-004', 'EGSU5566778', 32006, 'CO-20260602-000006', 'LOADED_IN', 'ACTIVE', @creator, @now, @creator, @now, b'0', @tid),
(33007, 31001, 'SO-20260602-001', 'MSCU1234567', 32007, 'CO-20260602-000007', 'LOADED_IN', 'ACTIVE', @creator, @now, @creator, @now, b'0', @tid),
(33008, 31002, 'SO-20260602-002', 'HLCU7654321', 32008, 'CO-20260602-000008', 'LOADED_IN', 'ACTIVE', @creator, @now, @creator, @now, b'0', @tid),
(33009, 31002, 'SO-20260602-002', 'HLCU7654321', 32009, 'CO-20260602-000009', 'LOADED_IN', 'ACTIVE', @creator, @now, @creator, @now, b'0', @tid),
(33010, 31004, 'SO-20260602-004', 'EGSU5566778', 32010, 'CO-20260602-000010', 'LOADED_IN', 'ACTIVE', @creator, @now, @creator, @now, b'0', @tid),
(33011, 31004, 'SO-20260602-004', 'EGSU5566778', 32011, 'CO-20260602-000011', 'LOADED_IN', 'ACTIVE', @creator, @now, @creator, @now, b'0', @tid),
(33012, 31004, 'SO-20260602-004', 'EGSU5566778', 32012, 'CO-20260602-000012', 'LOADED_IN', 'ACTIVE', @creator, @now, @creator, @now, b'0', @tid),
(33013, 31007, 'SO-20260602-007', 'COSU8899001', 32013, 'CO-20260602-000013', 'LOADED_IN', 'ACTIVE', @creator, @now, @creator, @now, b'0', @tid),
(33014, 31007, 'SO-20260602-007', 'COSU8899001', 32014, 'CO-20260602-000014', 'LOADED_IN', 'ACTIVE', @creator, @now, @creator, @now, b'0', @tid),
(33015, 31007, 'SO-20260602-007', 'COSU8899001', 32015, 'CO-20260602-000015', 'LOADED_IN', 'ACTIVE', @creator, @now, @creator, @now, b'0', @tid)
ON DUPLICATE KEY UPDATE `relation_status` = VALUES(`relation_status`), `updater` = VALUES(`updater`), `update_time` = @now;

-- ========== 5. 货件层 + SKU（抽样）==========
INSERT INTO `oms_cargo_order_shipment` (
    `id`, `cargo_order_id`, `biz_root_id`, `shipment_no`, `po_no`, `shipping_mark`,
    `carton_qty`, `pallet_qty`, `weight`, `cbm`, `dw_time`,
    `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`
) VALUES
(34001, 32001, 30001, 'FBA-001', 'PO-A-001', 'MARK-A', 40, 2, 280.000, 2.100, DATE_ADD(@now, INTERVAL 2 DAY), @creator, @now, @creator, @now, b'0', @tid),
(34002, 32001, 30001, 'FBA-002', 'PO-A-002', 'MARK-A', 40, 2, 278.000, 2.050, DATE_ADD(@now, INTERVAL 2 DAY), @creator, @now, @creator, @now, b'0', @tid),
(34003, 32002, 30002, 'FBA-003', 'PO-A-003', 'MARK-A2', 60, 3, 428.000, 3.350, DATE_ADD(@now, INTERVAL 3 DAY), @creator, @now, @creator, @now, b'0', @tid),
(34004, 32008, 30008, 'FBA-009', 'PO-A-009', 'MARK-D2', 50, 2, 300.000, 2.400, DATE_ADD(@now, INTERVAL 4 DAY), @creator, @now, @creator, @now, b'0', @tid),
(34005, 32010, 30010, 'FBA-011', 'PO-A-011', 'MARK-E', 44, 2, 318.000, 2.550, DATE_ADD(@now, INTERVAL 2 DAY), @creator, @now, @creator, @now, b'0', @tid),
(34006, 32012, 30012, 'FBA-013', 'PO-A-013', 'MARK-F', 56, 3, 398.000, 3.180, DATE_ADD(@now, INTERVAL 1 DAY), @creator, @now, @creator, @now, b'0', @tid),
(34007, 32003, 30003, 'FBA-004', 'PO-A-004', 'MARK-B', 72, 3, 510.000, 3.900, DATE_ADD(@now, INTERVAL 4 DAY), @creator, @now, @creator, @now, b'0', @tid),
(34008, 32004, 30004, 'FBA-005', 'PO-A-005', 'MARK-B2', 55, 2, 390.000, 3.100, DATE_ADD(@now, INTERVAL 5 DAY), @creator, @now, @creator, @now, b'0', @tid),
(34009, 32005, 30005, 'FBA-006', 'PO-B-001', 'MARK-C', 48, 2, 340.000, 2.800, DATE_ADD(@now, INTERVAL 6 DAY), @creator, @now, @creator, @now, b'0', @tid),
(34010, 32006, 30006, 'FBA-007', 'PO-B-002', 'MARK-C2', 36, 2, 280.000, 2.200, DATE_ADD(@now, INTERVAL 1 DAY), @creator, @now, @creator, @now, b'0', @tid),
(34011, 32007, 30007, 'FBA-008', 'PO-A-008', 'MARK-D', 42, 2, 310.000, 2.500, DATE_ADD(@now, INTERVAL 7 DAY), @creator, @now, @creator, @now, b'0', @tid),
(34012, 32008, 30008, 'FBA-009', 'PO-A-009', 'MARK-D2', 50, 2, 360.000, 2.900, DATE_ADD(@now, INTERVAL 4 DAY), @creator, @now, @creator, @now, b'0', @tid),
(34013, 32009, 30009, 'FBA-010', 'PO-A-010', 'MARK-D3', 38, 2, 270.000, 2.100, DATE_ADD(@now, INTERVAL 4 DAY), @creator, @now, @creator, @now, b'0', @tid),
(34014, 32011, 30011, 'FBA-012', 'PO-A-012', 'MARK-E2', 32, 1, 240.000, 1.900, DATE_ADD(@now, INTERVAL 2 DAY), @creator, @now, @creator, @now, b'0', @tid)
ON DUPLICATE KEY UPDATE `carton_qty` = VALUES(`carton_qty`), `updater` = VALUES(`updater`), `update_time` = @now;

INSERT INTO `oms_cargo_order_sku_item` (
    `id`, `cargo_order_id`, `shipment_id`, `shipment_no`, `po_no`, `sku`, `fnsku`, `product_name`, `qty`, `carton_qty`,
    `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`
) VALUES
(35001, 32001, 34001, 'FBA-001', 'PO-A-001', 'SKU-PHONE-001', 'X001FN01', '蓝牙耳机 Pro', 240, 20, @creator, @now, @creator, @now, b'0', @tid),
(35002, 32001, 34002, 'FBA-002', 'PO-A-002', 'SKU-PHONE-002', 'X001FN02', '手机支架', 120, 20, @creator, @now, @creator, @now, b'0', @tid),
(35003, 32002, 34003, 'FBA-003', 'PO-A-003', 'SKU-HOME-001', 'X002FN01', 'LED 台灯', 180, 30, @creator, @now, @creator, @now, b'0', @tid),
(35004, 32012, 34006, 'FBA-013', 'PO-A-013', 'SKU-HOME-002', 'X002FN02', '收纳盒套装', 168, 28, @creator, @now, @creator, @now, b'0', @tid)
ON DUPLICATE KEY UPDATE `qty` = VALUES(`qty`), `updater` = VALUES(`updater`), `update_time` = @now;

-- ========== 6. 预出单（7 张，覆盖各状态）==========
INSERT INTO `oms_pre_outbound` (
    `id`, `biz_root_id`, `cargo_order_id`, `cargo_order_no`, `cargo_order_count`,
    `pre_outbound_no`, `pre_outbound_status`, `outbound_direction`,
    `outbound_warehouse_id`, `outbound_warehouse_name`, `customer_name`, `container_no`, `shipment_codes`,
    `declared_carton_qty`, `declared_pallet_qty`, `declared_weight`, `declared_cbm`,
    `actual_carton_qty`, `actual_pallet_qty`, `actual_weight`, `actual_cbm`,
    `earliest_dw_time`, `delivery_lfd`, `ready_time`, `converted_time`, `outbound_order_no`,
    `loading_type`, `transport_type`, `destination`, `remark`,
    `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`
) VALUES
(36001, 30007, 32007, 'CO-20260602-000007', 1, 'POB-20260602-001', 'PENDING_INBOUND', 'DELIVERY',
 @wh_la, '洛杉矶一号仓', '演示货主 A', 'MSCU1234567', 'FBA-008', 42, 2, 310.000, 2.500, 30, 1, 220.000, 1.800,
 DATE_ADD(@now, INTERVAL 7 DAY), DATE_ADD(@now, INTERVAL 14 DAY), NULL, NULL, NULL, 'PALLET', 'FTL', 'Amazon ONT8', '待入库', @creator, @now, @creator, @now, b'0', @tid),
(36002, NULL, NULL, NULL, 2, 'POB-20260602-002', 'DEVANNING', 'DELIVERY',
 @wh_la, '洛杉矶一号仓', '演示货主 A', 'HLCU7654321', 'FBA-009,FBA-010', 88, 4, 630.000, 5.000, 73, 4, 568.000, 4.480,
 DATE_ADD(@now, INTERVAL 4 DAY), DATE_ADD(@now, INTERVAL 11 DAY), NULL, NULL, NULL, 'PALLET', 'FTL', 'Amazon LAX9', '合并2票-拆柜中', @creator, @now, @creator, @now, b'0', @tid),
(36003, NULL, NULL, NULL, 2, 'POB-20260602-003', 'READY_TO_CONVERT', 'DELIVERY',
 @wh_la, '洛杉矶一号仓', '演示货主 A', 'EGSU5566778', 'FBA-011,FBA-012', 76, 3, 560.000, 4.500, 76, 3, 556.000, 4.430,
 DATE_ADD(@now, INTERVAL 2 DAY), DATE_ADD(@now, INTERVAL 8 DAY), @now, NULL, NULL, 'PALLET', 'FTL', 'Amazon ONT8', '可转出库', @creator, @now, @creator, @now, b'0', @tid),
(36004, 30012, 32012, 'CO-20260602-000012', 1, 'POB-20260602-004', 'CONVERTED', 'DELIVERY',
 @wh_la, '洛杉矶一号仓', '演示货主 A', 'EGSU5566778', 'FBA-013', 56, 3, 400.000, 3.200, 56, 3, 398.000, 3.180,
 DATE_ADD(@now, INTERVAL 1 DAY), DATE_ADD(@now, INTERVAL 6 DAY), DATE_SUB(@now, INTERVAL 1 DAY), DATE_SUB(@now, INTERVAL 12 HOUR), 'OB-20260602-001', 'PALLET', 'FTL', 'Amazon ONT8', '已转正式出库', @creator, @now, @creator, @now, b'0', @tid),
(36005, 30013, 32013, 'CO-20260602-000013', 1, 'POB-20260602-005', 'CONVERTED', 'DELIVERY',
 @wh_nj, '新泽西一号仓', '演示货主 B', 'COSU8899001', 'FBA-014', 64, 3, 450.000, 3.600, 64, 3, 448.000, 3.550,
 DATE_SUB(@now, INTERVAL 2 DAY), DATE_ADD(@now, INTERVAL 4 DAY), DATE_SUB(@now, INTERVAL 2 DAY), DATE_SUB(@now, INTERVAL 1 DAY), 'OB-20260602-002', 'PALLET', 'LTL', 'Amazon EWR4', '已派发', @creator, @now, @creator, @now, b'0', @tid),
(36006, 30014, 32014, 'CO-20260602-000014', 1, 'POB-20260602-006', 'CONVERTED', 'DELIVERY',
 @wh_nj, '新泽西一号仓', '演示货主 B', 'COSU8899001', 'FBA-015', 40, 2, 290.000, 2.300, 40, 2, 288.000, 2.280,
 DATE_SUB(@now, INTERVAL 3 DAY), DATE_ADD(@now, INTERVAL 2 DAY), DATE_SUB(@now, INTERVAL 3 DAY), DATE_SUB(@now, INTERVAL 2 DAY), 'OB-20260602-003', 'FLOOR', 'FTL', 'Amazon LAX9', '派送中', @creator, @now, @creator, @now, b'0', @tid),
(36007, 30015, 32015, 'CO-20260602-000015', 1, 'POB-20260602-007', 'CONVERTED', 'DELIVERY',
 @wh_nj, '新泽西一号仓', '演示货主 B', 'COSU8899001', 'FBA-016', 28, 1, 200.000, 1.600, 28, 1, 198.000, 1.580,
 DATE_SUB(@now, INTERVAL 10 DAY), DATE_SUB(@now, INTERVAL 5 DAY), DATE_SUB(@now, INTERVAL 8 DAY), DATE_SUB(@now, INTERVAL 7 DAY), 'OB-20260602-004', 'PALLET', 'FTL', 'Amazon ONT8', '已完成', @creator, @now, @creator, @now, b'0', @tid)
ON DUPLICATE KEY UPDATE `pre_outbound_status` = VALUES(`pre_outbound_status`), `updater` = VALUES(`updater`), `update_time` = @now;

INSERT INTO `oms_pre_outbound_item` (
    `id`, `pre_outbound_id`, `pre_outbound_no`, `cargo_order_id`, `cargo_order_no`,
    `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`
) VALUES
(37001, 36001, 'POB-20260602-001', 32007, 'CO-20260602-000007', @creator, @now, @creator, @now, b'0', @tid),
(37002, 36002, 'POB-20260602-002', 32008, 'CO-20260602-000008', @creator, @now, @creator, @now, b'0', @tid),
(37003, 36002, 'POB-20260602-002', 32009, 'CO-20260602-000009', @creator, @now, @creator, @now, b'0', @tid),
(37004, 36003, 'POB-20260602-003', 32010, 'CO-20260602-000010', @creator, @now, @creator, @now, b'0', @tid),
(37005, 36003, 'POB-20260602-003', 32011, 'CO-20260602-000011', @creator, @now, @creator, @now, b'0', @tid),
(37006, 36004, 'POB-20260602-004', 32012, 'CO-20260602-000012', @creator, @now, @creator, @now, b'0', @tid),
(37007, 36005, 'POB-20260602-005', 32013, 'CO-20260602-000013', @creator, @now, @creator, @now, b'0', @tid),
(37008, 36006, 'POB-20260602-006', 32014, 'CO-20260602-000014', @creator, @now, @creator, @now, b'0', @tid),
(37009, 36007, 'POB-20260602-007', 32015, 'CO-20260602-000015', @creator, @now, @creator, @now, b'0', @tid)
ON DUPLICATE KEY UPDATE `updater` = VALUES(`updater`), `update_time` = @now;

-- ========== 7. 出库单（4 张，覆盖 CREATED → COMPLETED）==========
INSERT INTO `oms_outbound_order` (
    `id`, `biz_root_id`, `cargo_order_id`, `cargo_order_no`, `pre_outbound_id`, `pre_outbound_no`, `cargo_order_count`,
    `outbound_order_no`, `outbound_status`, `outbound_direction`,
    `outbound_warehouse_id`, `outbound_warehouse_name`, `customer_name`, `container_no`, `shipment_codes`,
    `actual_carton_qty`, `actual_pallet_qty`, `actual_weight`, `actual_cbm`,
    `delivery_method`, `appointment_status`, `appointment_time`, `delivery_lfd`,
    `contact_name`, `contact_phone`, `address_line1`, `city`, `state`, `zip_code`, `country`,
    `carrier`, `tracking_no`, `actual_outbound_time`, `actual_signed_time`, `pod_status`, `completed_time`, `remark`,
    `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`
) VALUES
(38001, 30012, 32012, 'CO-20260602-000012', 36004, 'POB-20260602-004', 1,
 'OB-20260602-001', 'CREATED', 'DELIVERY', @wh_la, '洛杉矶一号仓', '演示货主 A', 'EGSU5566778', 'FBA-013',
 56, 3, 398.000, 3.180, '卡车派送', 'NONE', NULL, DATE_ADD(@now, INTERVAL 6 DAY),
 'John Smith', '+1-909-555-0001', '1910 E Central Ave', 'Ontario', 'CA', '91761', 'US',
 NULL, NULL, NULL, NULL, 'PENDING', NULL, '刚创建待派发', @creator, @now, @creator, @now, b'0', @tid),
(38002, 30013, 32013, 'CO-20260602-000013', 36005, 'POB-20260602-005', 1,
 'OB-20260602-002', 'DISPATCHED', 'DELIVERY', @wh_nj, '新泽西一号仓', '演示货主 B', 'COSU8899001', 'FBA-014',
 64, 3, 448.000, 3.550, '卡车派送', 'CONFIRMED', DATE_ADD(@now, INTERVAL 2 DAY), DATE_ADD(@now, INTERVAL 4 DAY),
 'Sarah Lee', '+1-973-555-0003', '50 New Canton Way', 'Edison', 'NJ', '08817', 'US',
 'Swift Transport', 'SW-882910', DATE_SUB(@now, INTERVAL 6 HOUR), NULL, 'PENDING', NULL, '已派车', @creator, @now, @creator, @now, b'0', @tid),
(38003, 30014, 32014, 'CO-20260602-000014', 36006, 'POB-20260602-006', 1,
 'OB-20260602-003', 'DELIVERING', 'DELIVERY', @wh_nj, '新泽西一号仓', '演示货主 B', 'COSU8899001', 'FBA-015',
 40, 2, 288.000, 2.280, '卡车派送', 'CONFIRMED', DATE_SUB(@now, INTERVAL 1 DAY), DATE_ADD(@now, INTERVAL 2 DAY),
 'Mike Johnson', '+1-323-555-0002', '6750 Kimball Ave', 'Los Angeles', 'CA', '90805', 'US',
 'Pacific Haul', 'PH-773201', DATE_SUB(@now, INTERVAL 1 DAY), NULL, 'PENDING', NULL, '在途派送', @creator, @now, @creator, @now, b'0', @tid),
(38004, 30015, 32015, 'CO-20260602-000015', 36007, 'POB-20260602-007', 1,
 'OB-20260602-004', 'COMPLETED', 'DELIVERY', @wh_nj, '新泽西一号仓', '演示货主 B', 'COSU8899001', 'FBA-016',
 28, 1, 198.000, 1.580, '卡车派送', 'CONFIRMED', DATE_SUB(@now, INTERVAL 8 DAY), DATE_SUB(@now, INTERVAL 5 DAY),
 'John Smith', '+1-909-555-0001', '1910 E Central Ave', 'Ontario', 'CA', '91761', 'US',
 'Swift Transport', 'SW-110022', DATE_SUB(@now, INTERVAL 7 DAY), DATE_SUB(@now, INTERVAL 5 DAY), 'UPLOADED', DATE_SUB(@now, INTERVAL 4 DAY), '已签收完成', @creator, @now, @creator, @now, b'0', @tid)
ON DUPLICATE KEY UPDATE `outbound_status` = VALUES(`outbound_status`), `updater` = VALUES(`updater`), `update_time` = @now;

INSERT INTO `oms_outbound_order_item` (
    `id`, `outbound_order_id`, `outbound_order_no`, `cargo_order_id`, `cargo_order_no`, `pre_outbound_item_id`,
    `actual_carton_qty`, `actual_pallet_qty`, `actual_weight`, `actual_cbm`,
    `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`
) VALUES
(39001, 38001, 'OB-20260602-001', 32012, 'CO-20260602-000012', 37006, 56, 3, 398.000, 3.180, @creator, @now, @creator, @now, b'0', @tid),
(39002, 38002, 'OB-20260602-002', 32013, 'CO-20260602-000013', 37007, 64, 3, 448.000, 3.550, @creator, @now, @creator, @now, b'0', @tid),
(39003, 38003, 'OB-20260602-003', 32014, 'CO-20260602-000014', 37008, 40, 2, 288.000, 2.280, @creator, @now, @creator, @now, b'0', @tid),
(39004, 38004, 'OB-20260602-004', 32015, 'CO-20260602-000015', 37009, 28, 1, 198.000, 1.580, @creator, @now, @creator, @now, b'0', @tid)
ON DUPLICATE KEY UPDATE `actual_carton_qty` = VALUES(`actual_carton_qty`), `updater` = VALUES(`updater`), `update_time` = @now;

-- 可选字段回写（列存在时）
SET @has_latest_pre := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_cargo_order' AND COLUMN_NAME = 'latest_pre_outbound_id');
SET @sql := IF(@has_latest_pre > 0,
    'UPDATE `oms_cargo_order` SET `latest_pre_outbound_id` = CASE `id`
        WHEN 32007 THEN 36001 WHEN 32008 THEN 36002 WHEN 32009 THEN 36002 WHEN 32010 THEN 36003 WHEN 32011 THEN 36003
        WHEN 32012 THEN 36004 WHEN 32013 THEN 36005 WHEN 32014 THEN 36006 WHEN 32015 THEN 36007 ELSE `latest_pre_outbound_id` END,
     `latest_outbound_order_id` = CASE `id`
        WHEN 32012 THEN 38001 WHEN 32013 THEN 38002 WHEN 32014 THEN 38003 WHEN 32015 THEN 38004 ELSE `latest_outbound_order_id` END,
     `updater` = ''admin'', `update_time` = NOW() WHERE `id` BETWEEN 32007 AND 32015',
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @has_order_total := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_container_order' AND COLUMN_NAME = 'order_total_count');
SET @sql := IF(@has_order_total > 0,
    'UPDATE `oms_container_order` co SET co.`order_total_count` = (
        SELECT COUNT(*) FROM `oms_container_cargo_order_rel` r WHERE r.`container_order_id` = co.`id` AND r.`deleted` = 0
     ), co.`updater` = ''admin'', co.`update_time` = NOW() WHERE co.`id` BETWEEN 31001 AND 31008',
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ========== 自检 ==========
SELECT 'oms_container_order' AS tbl, COUNT(*) AS cnt FROM `oms_container_order` WHERE `id` BETWEEN 31001 AND 31999 AND `tenant_id` = @tid
UNION ALL SELECT 'oms_cargo_order', COUNT(*) FROM `oms_cargo_order` WHERE `id` BETWEEN 32001 AND 32999 AND `tenant_id` = @tid
UNION ALL SELECT 'outbound_pool(工作台)', COUNT(*) FROM `oms_cargo_order`
    WHERE `id` BETWEEN 32001 AND 32006 AND `tenant_id` = @tid
      AND `fulfillment_status` IN ('PENDING_ACCEPT','ACCEPTED','IN_TRANSIT','ARRIVED_PORT','PICKED_UP','ARRIVED_WAREHOUSE','DEVANNING','DEVANNED','INBOUNDED')
      AND (`pre_outbound_status` IS NULL OR `pre_outbound_status` = 'NONE')
      AND (`outbound_order_status` IS NULL OR `outbound_order_status` = 'NONE')
UNION ALL SELECT 'oms_pre_outbound', COUNT(*) FROM `oms_pre_outbound` WHERE `id` BETWEEN 36001 AND 36999 AND `tenant_id` = @tid
UNION ALL SELECT 'oms_outbound_order', COUNT(*) FROM `oms_outbound_order` WHERE `id` BETWEEN 38001 AND 38999 AND `tenant_id` = @tid;
