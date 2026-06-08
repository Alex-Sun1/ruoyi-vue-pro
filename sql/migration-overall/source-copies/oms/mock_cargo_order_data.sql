-- ============================================================
-- 模拟数据: oms_cargo_order 及关联表
-- 日期: 2026-05-23
-- 用途: 开发/测试环境验证前端页面字段展示
-- 注意: 勿在生产环境执行
-- ============================================================

-- ----------------------------
-- 清空旧模拟数据（按依赖顺序）
-- ----------------------------
DELETE FROM `oms_cargo_order_node_trace` WHERE `cargo_order_id` IN (1001,1002,1003,1004,1005);
DELETE FROM `oms_cargo_order_sku_item`   WHERE `cargo_order_id` IN (1001,1002,1003,1004,1005);
DELETE FROM `oms_cargo_order_shipment`   WHERE `cargo_order_id` IN (1001,1002,1003,1004,1005);
DELETE FROM `oms_cargo_order`            WHERE `id`             IN (1001,1002,1003,1004,1005);

-- ----------------------------
-- 1. 货物订单主表 (5条，覆盖典型场景)
-- ----------------------------
INSERT INTO `oms_cargo_order` (
  `id`, `tenant_id`, `company_id`, `biz_root_id`,
  `shipment_codes`, `po_nos`, `marks`,
  `cargo_order_no`, `external_order_no`, `order_source`,
  `customer_id`, `customer_name`,
  `business_type_id`, `business_type_name`,
  `platform_id`, `platform_name`,
  `customer_service_id`, `customer_service_name`,
  `container_order_id`, `container_no`,
  `inbound_warehouse_id`, `inbound_warehouse_name`,
  `address_type`, `platform_warehouse_code`,
  `consignee_name`, `address_line1`, `address_line2`,
  `city`, `state`, `zip_code`, `country`,
  `contact_name`, `contact_phone`, `contact_email`,
  `transfer_flag`, `transfer_warehouse_code`,
  `declared_carton_qty`, `declared_weight`, `declared_cbm`,
  `actual_carton_qty`, `actual_pallet_qty`, `actual_weight`, `actual_cbm`,
  `pre_outbound_status`, `outbound_batch_no`,
  `order_status`, `fulfillment_status`,
  `appointment_status`, `pod_status`, `billing_status`,
  `earliest_dw_time`, `eta`, `ata`,
  `actual_pickup_time`, `actual_arrival_time`, `devanning_finish_time`,
  `actual_inbound_time`, `delivery_lfd`,
  `delivery_appointment_time`, `actual_outbound_time`, `signed_time`,
  `exception_flag`, `exception_count`,
  `hold_flag`, `hold_remark`,
  `customer_remark`, `internal_remark`, `operation_remark`, `follow_up_remark`,
  `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `deleted`
) VALUES

-- 订单1: 在途中，平台仓，无异常
(1001, '000000', 100, 10001,
 'SC-001,SC-002', 'PO-20260501-001,PO-20260501-002', 'MARK-A',
 'CO-2026-000001', 'EXT-REF-001', 'MANUAL',
 200, '测试客户A',
 10, 'FBA头程',
 20, 'Amazon US',
 30, '张客服',
 5001, 'CNSHA2600001',
 40, '洛杉矶仓(LAX)',
 'PLATFORM_WH', 'ONT8',
 'Amazon Fulfillment Center', '1 Fulfillment Way', NULL,
 'Ontario', 'CA', '91761', 'US',
 'John Smith', '+1-909-555-0001', 'john.smith@amazon.com',
 0, NULL,
 120, 860.500, 6.800,
 NULL, NULL, NULL, NULL,
 'NONE', NULL,
 'NORMAL', 'IN_TRANSIT',
 'NONE', 'PENDING', 'UNBILLED',
 '2026-06-01 00:00:00', '2026-05-28 00:00:00', NULL,
 NULL, NULL, NULL,
 NULL, '2026-06-05 00:00:00',
 NULL, NULL, NULL,
 0, 0,
 0, NULL,
 '请注意FBA入仓要求', NULL, NULL, NULL,
 103, 1, NOW(), 1, NOW(), 0),

-- 订单2: 已到仓，私仓，转仓，有跟进记录
(1002, '000000', 100, 10002,
 'SC-003', 'PO-20260502-001', 'MARK-B',
 'CO-2026-000002', 'EXT-REF-002', 'IMPORT',
 201, '测试客户B',
 11, '私仓派送',
 NULL, NULL,
 30, '张客服',
 5002, 'CNSHA2600002',
 40, '洛杉矶仓(LAX)',
 'PRIVATE', NULL,
 'Private Warehouse LLC', '2500 Industrial Blvd', 'Suite 300',
 'Los Angeles', 'CA', '90001', 'US',
 'Mike Johnson', '+1-323-555-0002', 'mike@private-wh.com',
 1, 'RNO1',
 80, 560.000, 4.200,
 82, 4, 558.500, 4.150,
 'NONE', NULL,
 'NORMAL', 'ARRIVED_WAREHOUSE',
 'NONE', 'PENDING', 'UNBILLED',
 '2026-05-20 00:00:00', '2026-05-18 00:00:00', '2026-05-19 10:30:00',
 '2026-05-20 08:00:00', '2026-05-20 14:00:00', NULL,
 NULL, '2026-06-10 00:00:00',
 NULL, NULL, NULL,
 0, 0,
 0, NULL,
 NULL, '转仓至RNO1，需重新预约', '已联系转仓仓库确认接收', '2026-05-21 客户确认转仓，预计6月10前完成派送',
 103, 1, NOW(), 1, NOW(), 0),

-- 订单3: 已入库，商业地址，HOLD中，有异常
(1003, '000000', 100, 10003,
 'SC-004,SC-005,SC-006', 'PO-20260503-001,PO-20260503-002,PO-20260503-003', 'MARK-C1,MARK-C2',
 'CO-2026-000003', 'EXT-REF-003', 'API',
 202, '测试客户C',
 12, '商业地址派送',
 NULL, NULL,
 31, '李客服',
 5003, 'CNSHA2600003',
 41, '纽约仓(JFK)',
 'COMMERCIAL', NULL,
 'XYZ Distribution Co.', '888 Commerce Street', NULL,
 'Newark', 'NJ', '07102', 'US',
 'Sarah Lee', '+1-973-555-0003', 'sarah@xyzdc.com',
 0, NULL,
 200, 1450.000, 11.500,
 198, 10, 1445.000, 11.480,
 'PRE_CREATED', 'PRE-2026-003',
 'NORMAL', 'INBOUNDED',
 'NONE', 'PENDING', 'UNBILLED',
 '2026-05-15 00:00:00', '2026-05-12 00:00:00', '2026-05-13 09:00:00',
 '2026-05-14 07:00:00', '2026-05-14 16:00:00', '2026-05-15 12:00:00',
 '2026-05-16 10:00:00', '2026-06-15 00:00:00',
 NULL, NULL, NULL,
 1, 2,
 1, '客户要求暂停出单，等待清关文件补充',
 '请保管好货物', '客户有清关问题，等待文件', '已通知仓库暂停出单', '2026-05-20 与客户沟通，预计5月25前提供文件',
 103, 1, NOW(), 1, NOW(), 0),

-- 订单4: 已出库派送中，已预出单转正式，有出库单号
(1004, '000000', 100, 10004,
 'SC-007', 'PO-20260504-001', 'MARK-D',
 'CO-2026-000004', NULL, 'PORTAL',
 200, '测试客户A',
 10, 'FBA头程',
 20, 'Amazon US',
 30, '张客服',
 5004, 'CNSHA2600004',
 41, '纽约仓(JFK)',
 'PLATFORM_WH', 'JFK7',
 'Amazon Fulfillment Center JFK7', '600 Outer Road', NULL,
 'Jamaica', 'NY', '11430', 'US',
 'Amazon Receiving', '+1-718-555-0004', NULL,
 0, NULL,
 50, 380.000, 2.900,
 50, 3, 379.500, 2.890,
 'CONVERTED', 'OB-2026-004',
 'NORMAL', 'DELIVERING',
 'APPOINTED', 'PENDING', 'UNBILLED',
 '2026-05-10 00:00:00', '2026-05-08 00:00:00', '2026-05-09 11:00:00',
 '2026-05-10 06:00:00', '2026-05-10 15:00:00', '2026-05-11 10:00:00',
 '2026-05-12 09:00:00', '2026-05-20 00:00:00',
 '2026-05-18 09:00:00', '2026-05-18 14:00:00', NULL,
 0, 0,
 0, NULL,
 NULL, NULL, '已出单，快递追踪正常', '2026-05-19 快递显示已到目的城市，预计明天签收',
 103, 1, NOW(), 1, NOW(), 0),

-- 订单5: 已完成，已出账单
(1005, '000000', 100, 10005,
 'SC-008,SC-009', 'PO-20260420-001', 'MARK-E',
 'CO-2026-000005', 'EXT-REF-005', 'MANUAL',
 203, '测试客户D',
 11, '私仓派送',
 NULL, NULL,
 31, '李客服',
 5005, 'CNSHA2600005',
 42, '西雅图仓(SEA)',
 'PRIVATE', NULL,
 'Seattle Storage Inc.', '1200 Harbor Ave SW', NULL,
 'Seattle', 'WA', '98126', 'US',
 'Tom Wang', '+1-206-555-0005', 'tom@sea-storage.com',
 0, NULL,
 30, 210.000, 1.600,
 30, 2, 209.800, 1.590,
 'CONVERTED', 'OB-2026-005',
 'NORMAL', 'COMPLETED',
 'APPOINTED', 'UPLOADED', 'BILLED',
 '2026-04-25 00:00:00', '2026-04-22 00:00:00', '2026-04-23 10:00:00',
 '2026-04-24 07:00:00', '2026-04-24 16:00:00', '2026-04-25 11:00:00',
 '2026-04-26 09:00:00', '2026-05-05 00:00:00',
 '2026-05-03 10:00:00', '2026-05-03 15:00:00', '2026-05-04 11:00:00',
 0, 0,
 0, NULL,
 NULL, NULL, '全程顺利，已出账', NULL,
 103, 1, NOW(), 1, NOW(), 0);


-- ----------------------------
-- 2. 货件层 (每单1-3个货件)
-- ----------------------------
INSERT INTO `oms_cargo_order_shipment` (
  `id`, `tenant_id`, `cargo_order_id`, `biz_root_id`,
  `shipment_no`, `po_no`, `shipping_mark`,
  `carton_qty`, `weight`, `cbm`, `dw_time`,
  `remark`, `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `deleted`
) VALUES
-- 订单1 货件
(10011, '000000', 1001, 10001, 'SC-001', 'PO-20260501-001', 'MARK-A', 60, 430.000, 3.400, '2026-06-01 00:00:00', NULL, 103, 1, NOW(), 1, NOW(), 0),
(10012, '000000', 1001, 10001, 'SC-002', 'PO-20260501-002', 'MARK-A', 60, 430.500, 3.400, '2026-06-01 00:00:00', NULL, 103, 1, NOW(), 1, NOW(), 0),
-- 订单2 货件
(10021, '000000', 1002, 10002, 'SC-003', 'PO-20260502-001', 'MARK-B', 80, 560.000, 4.200, '2026-05-20 00:00:00', NULL, 103, 1, NOW(), 1, NOW(), 0),
-- 订单3 货件
(10031, '000000', 1003, 10003, 'SC-004', 'PO-20260503-001', 'MARK-C1', 70, 500.000, 3.900, '2026-05-15 00:00:00', NULL, 103, 1, NOW(), 1, NOW(), 0),
(10032, '000000', 1003, 10003, 'SC-005', 'PO-20260503-002', 'MARK-C2', 80, 580.000, 4.600, '2026-05-15 00:00:00', NULL, 103, 1, NOW(), 1, NOW(), 0),
(10033, '000000', 1003, 10003, 'SC-006', 'PO-20260503-003', 'MARK-C2', 50, 370.000, 3.000, '2026-05-15 00:00:00', NULL, 103, 1, NOW(), 1, NOW(), 0),
-- 订单4 货件
(10041, '000000', 1004, 10004, 'SC-007', 'PO-20260504-001', 'MARK-D', 50, 380.000, 2.900, '2026-05-10 00:00:00', NULL, 103, 1, NOW(), 1, NOW(), 0),
-- 订单5 货件
(10051, '000000', 1005, 10005, 'SC-008', 'PO-20260420-001', 'MARK-E', 15, 105.000, 0.800, '2026-04-25 00:00:00', NULL, 103, 1, NOW(), 1, NOW(), 0),
(10052, '000000', 1005, 10005, 'SC-009', 'PO-20260420-001', 'MARK-E', 15, 105.000, 0.800, '2026-04-25 00:00:00', NULL, 103, 1, NOW(), 1, NOW(), 0);


-- ----------------------------
-- 3. SKU 明细层
-- ----------------------------
INSERT INTO `oms_cargo_order_sku_item` (
  `id`, `tenant_id`, `cargo_order_id`, `shipment_id`, `shipment_no`, `po_no`, `shipping_mark`,
  `sku`, `fnsku`, `product_name`, `qty`, `carton_qty`,
  `create_dept`, `create_by`, `create_time`, `update_by`, `update_time`, `deleted`
) VALUES
-- 订单1 SKU
(100111, '000000', 1001, 10011, 'SC-001', 'PO-20260501-001', 'MARK-A', 'SKU-A001', 'X001FNSKU1', 'Wireless Earbuds Pro', 600, 60, 103, 1, NOW(), 1, NOW(), 0),
(100121, '000000', 1001, 10012, 'SC-002', 'PO-20260501-002', 'MARK-A', 'SKU-A002', 'X001FNSKU2', 'Phone Case Pack', 1200, 60, 103, 1, NOW(), 1, NOW(), 0),
-- 订单2 SKU
(100211, '000000', 1002, 10021, 'SC-003', 'PO-20260502-001', 'MARK-B', 'SKU-B001', NULL, 'Storage Shelf Unit', 80, 80, 103, 1, NOW(), 1, NOW(), 0),
-- 订单3 SKU
(100311, '000000', 1003, 10031, 'SC-004', 'PO-20260503-001', 'MARK-C1', 'SKU-C001', 'Y002FNSKU1', 'LED Ring Light', 420, 70, 103, 1, NOW(), 1, NOW(), 0),
(100321, '000000', 1003, 10032, 'SC-005', 'PO-20260503-002', 'MARK-C2', 'SKU-C002', 'Y002FNSKU2', 'Tripod Stand', 400, 80, 103, 1, NOW(), 1, NOW(), 0),
(100331, '000000', 1003, 10033, 'SC-006', 'PO-20260503-003', 'MARK-C2', 'SKU-C002', 'Y002FNSKU2', 'Tripod Stand', 250, 50, 103, 1, NOW(), 1, NOW(), 0),
-- 订单4 SKU
(100411, '000000', 1004, 10041, 'SC-007', 'PO-20260504-001', 'MARK-D', 'SKU-D001', 'Z003FNSKU1', 'Smart Watch Band', 1000, 50, 103, 1, NOW(), 1, NOW(), 0),
-- 订单5 SKU
(100511, '000000', 1005, 10051, 'SC-008', 'PO-20260420-001', 'MARK-E', 'SKU-E001', NULL, 'Yoga Mat Premium', 60, 15, 103, 1, NOW(), 1, NOW(), 0),
(100521, '000000', 1005, 10052, 'SC-009', 'PO-20260420-001', 'MARK-E', 'SKU-E001', NULL, 'Yoga Mat Premium', 60, 15, 103, 1, NOW(), 1, NOW(), 0);


-- ----------------------------
-- 4. 节点轨迹表
-- ----------------------------
INSERT INTO `oms_cargo_order_node_trace` (
  `id`, `tenant_id`, `cargo_order_id`, `biz_root_id`,
  `node_code`, `node_name`, `node_status`,
  `status_from`, `status_to`, `action`,
  `actual_time`, `source_type`, `operator_id`, `operator_name`, `remark`, `create_time`
) VALUES
-- 订单1 轨迹
(200011, '000000', 1001, 10001, 'PENDING_ACCEPT', '待受理',   'DONE', NULL,           'PENDING_ACCEPT', 'create',        '2026-05-01 09:00:00', 'MANUAL', 1, '系统管理员', '订单创建',   '2026-05-01 09:00:00'),
(200012, '000000', 1001, 10001, 'ACCEPTED',       '已受理',   'DONE', 'PENDING_ACCEPT','ACCEPTED',       'accept',        '2026-05-02 10:00:00', 'MANUAL', 1, '系统管理员', '已受理确认', '2026-05-02 10:00:00'),
(200013, '000000', 1001, 10001, 'IN_TRANSIT',     '在途',     'DONE', 'ACCEPTED',      'IN_TRANSIT',     'markInTransit', '2026-05-05 11:00:00', 'MANUAL', 1, '张客服',     '船已开航',   '2026-05-05 11:00:00'),
-- 订单3 轨迹（有HOLD和异常）
(200031, '000000', 1003, 10003, 'PENDING_ACCEPT', '待受理',   'DONE', NULL,           'PENDING_ACCEPT', 'create',        '2026-05-01 08:00:00', 'MANUAL', 1, '系统管理员', '订单创建',   '2026-05-01 08:00:00'),
(200032, '000000', 1003, 10003, 'ACCEPTED',       '已受理',   'DONE', 'PENDING_ACCEPT','ACCEPTED',       'accept',        '2026-05-01 10:00:00', 'MANUAL', 1, '系统管理员', NULL,         '2026-05-01 10:00:00'),
(200033, '000000', 1003, 10003, 'IN_TRANSIT',     '在途',     'DONE', 'ACCEPTED',      'IN_TRANSIT',     'markInTransit', '2026-05-03 09:00:00', 'MANUAL', 1, '李客服',     NULL,         '2026-05-03 09:00:00'),
(200034, '000000', 1003, 10003, 'ARRIVED_PORT',   '已到港',   'DONE', 'IN_TRANSIT',    'ARRIVED_PORT',   'confirmArrivedPort', '2026-05-13 09:00:00', 'OMS', 1, '李客服', NULL, '2026-05-13 09:00:00'),
(200035, '000000', 1003, 10003, 'INBOUNDED',      '已入库',   'DONE', 'DEVANNED',      'INBOUNDED',      'confirmInbounded',   '2026-05-16 10:00:00', 'WMS', 1, '系统',   '入库完成，等待出单', '2026-05-16 10:00:00'),
-- 订单4 轨迹
(200041, '000000', 1004, 10004, 'INBOUNDED',      '已入库',   'DONE', 'DEVANNED',      'INBOUNDED',      'confirmInbounded',   '2026-05-12 09:00:00', 'WMS', 1, '系统',       NULL,         '2026-05-12 09:00:00'),
(200042, '000000', 1004, 10004, 'OUTBOUND_ORDERED','已出单',  'DONE', 'INBOUNDED',     'OUTBOUND_ORDERED','convertPreOutbound', '2026-05-15 14:00:00', 'OMS', 1, '张客服',     '转正式出单', '2026-05-15 14:00:00'),
(200043, '000000', 1004, 10004, 'DELIVERY_APPOINTED','已预约','DONE', 'OUTBOUND_ORDERED','DELIVERY_APPOINTED','appointDelivery', '2026-05-17 10:00:00', 'OMS', 1, '张客服',   '预约5月18日派送', '2026-05-17 10:00:00'),
(200044, '000000', 1004, 10004, 'OUTBOUNDED',     '已出库',   'DONE', 'DELIVERY_APPOINTED','OUTBOUNDED', 'confirmOutbounded',  '2026-05-18 14:00:00', 'WMS', 1, '系统',       NULL,         '2026-05-18 14:00:00'),
(200045, '000000', 1004, 10004, 'DELIVERING',     '派送中',   'DONE', 'OUTBOUNDED',    'DELIVERING',     'markDelivering',     '2026-05-18 16:00:00', 'TMS', 1, '系统',       '快递已揽收', '2026-05-18 16:00:00'),
-- 订单5 轨迹（完整链路）
(200051, '000000', 1005, 10005, 'DELIVERED',      '已签收',   'DONE', 'DELIVERING',    'DELIVERED',      'confirmDelivered',   '2026-05-04 11:00:00', 'TMS', 1, '系统',       '签收成功',   '2026-05-04 11:00:00'),
(200052, '000000', 1005, 10005, 'POD_UPLOADED',   'POD已回传','DONE', 'DELIVERED',     'POD_UPLOADED',   'uploadPod',          '2026-05-05 09:00:00', 'OMS', 1, '李客服',     'POD已上传',  '2026-05-05 09:00:00'),
(200053, '000000', 1005, 10005, 'BILLED',         '已出账单', 'DONE', 'POD_UPLOADED',  'BILLED',         'confirmBilled',      '2026-05-06 15:00:00', 'BMS', 1, '财务',       '账单已确认', '2026-05-06 15:00:00'),
(200054, '000000', 1005, 10005, 'COMPLETED',      '已完成',   'DONE', 'BILLED',        'COMPLETED',      'complete',           '2026-05-07 10:00:00', 'OMS', 1, '系统管理员', NULL,         '2026-05-07 10:00:00');


-- ----------------------------
-- 5. 关联真实海柜订单（必须执行，否则海柜详情查不到关联货物订单）
-- 取数据库中前5条真实海柜订单，按序分配给模拟货物订单
-- 若海柜订单不足5条，多余的货物订单 container_order_id 保持 NULL
-- ----------------------------
SET @co1 = (SELECT id FROM oms_container_order WHERE deleted = 0 ORDER BY create_time DESC LIMIT 1 OFFSET 0);
SET @co2 = (SELECT id FROM oms_container_order WHERE deleted = 0 ORDER BY create_time DESC LIMIT 1 OFFSET 1);
SET @co3 = (SELECT id FROM oms_container_order WHERE deleted = 0 ORDER BY create_time DESC LIMIT 1 OFFSET 2);
SET @co4 = (SELECT id FROM oms_container_order WHERE deleted = 0 ORDER BY create_time DESC LIMIT 1 OFFSET 3);
SET @co5 = (SELECT id FROM oms_container_order WHERE deleted = 0 ORDER BY create_time DESC LIMIT 1 OFFSET 4);

UPDATE `oms_cargo_order` SET `container_order_id` = @co1 WHERE `id` = 1001 AND @co1 IS NOT NULL;
UPDATE `oms_cargo_order` SET `container_order_id` = @co1 WHERE `id` = 1002 AND @co1 IS NOT NULL;
UPDATE `oms_cargo_order` SET `container_order_id` = @co2 WHERE `id` = 1003 AND @co2 IS NOT NULL;
UPDATE `oms_cargo_order` SET `container_order_id` = @co3 WHERE `id` = 1004 AND @co3 IS NOT NULL;
UPDATE `oms_cargo_order` SET `container_order_id` = @co4 WHERE `id` = 1005 AND @co4 IS NOT NULL;

-- 同步更新 container_no（冗余字段）
UPDATE `oms_cargo_order` co
  INNER JOIN `oms_container_order` cto ON cto.id = co.container_order_id
SET co.container_no = cto.container_no
WHERE co.id IN (1001, 1002, 1003, 1004, 1005);
