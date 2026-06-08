-- =============================================
-- YMS 模拟数据 — LA Dock + OMS海柜补充 + 园区任务
-- Date: 2026-05-28
-- 说明：全部使用 INSERT IGNORE 保证幂等；warehouse_id=4001001 为 LA01
-- =============================================

-- ─────────────────────────────────────────────────────────
-- Part 1: 更新现有 LA Dock 分区标识（A-01/A-02 → A区）
-- ─────────────────────────────────────────────────────────
UPDATE yard_dock SET dock_location = 'A区' WHERE id IN (3010001, 3010002);

-- ─────────────────────────────────────────────────────────
-- Part 2: 补充 LA 仓库 Dock（A区+B区+C区，共8个）
-- ─────────────────────────────────────────────────────────
INSERT IGNORE INTO yard_dock
  (id, tenant_id, dock_code, dock_name, location_type,
   warehouse_id, warehouse_code, warehouse_name,
   dock_location, grid_row, grid_col,
   allowed_vehicle_types, appointment_supported, max_concurrent,
   dock_status, enabled_flag, sort_order, dispatch_priority,
   dock_type, enable_queue, max_queue_count,
   remark, create_by, create_time, update_by, update_time, del_flag)
VALUES
-- A区 第3个（卸柜，启用排队）
(3010004,'000000','DOC-LA-A03','LA A区3号','DOCK',4001001,'LA01','Los Angeles Central Warehouse',
 'A区',1,3,'53FT,40HQ',1,1,'IDLE',1,3,1,'DEVANNING',1,3,'A区卸柜道口，支持排队',1,NOW(),1,NOW(),0),
-- B区 装车专区
(3010005,'000000','DOC-LA-B01','LA B区1号','DOCK',4001001,'LA01','Los Angeles Central Warehouse',
 'B区',2,1,'53FT,40HQ,20GP',1,1,'IDLE',1,4,1,'LOADING',0,NULL,'B区装车道口',1,NOW(),1,NOW(),0),
(3010006,'000000','DOC-LA-B02','LA B区2号','DOCK',4001001,'LA01','Los Angeles Central Warehouse',
 'B区',2,2,'53FT,40HQ',1,1,'IDLE',1,5,1,'LOADING',1,2,'B区装车，启用排队',1,NOW(),1,NOW(),0),
(3010007,'000000','DOC-LA-B03','LA B区3号','DOCK',4001001,'LA01','Los Angeles Central Warehouse',
 'B区',2,3,'53FT',1,1,'MAINTENANCE',1,6,2,'LOADING',0,NULL,'B区3号维护中',1,NOW(),1,NOW(),0),
-- C区 混用
(3010008,'000000','DOC-LA-C01','LA C区1号','DOCK',4001001,'LA01','Los Angeles Central Warehouse',
 'C区',3,1,'53FT,40HQ',1,1,'IDLE',1,7,3,NULL,1,2,'C区混合道口，启用排队',1,NOW(),1,NOW(),0),
(3010009,'000000','DOC-LA-C02','LA C区2号','DOCK',4001001,'LA01','Los Angeles Central Warehouse',
 'C区',3,2,'40HQ,20GP',1,1,'IDLE',1,8,3,NULL,0,NULL,'C区混合道口',1,NOW(),1,NOW(),0);

-- ─────────────────────────────────────────────────────────
-- Part 3: 补充 OMS 海柜订单（10条，全部指向 LA 仓库）
-- ─────────────────────────────────────────────────────────
INSERT IGNORE INTO oms_container_order (
  id, tenant_id, company_id, customer_id, customer_name, channel_id, business_type_id,
  owner_user_id, owner_user_name, customer_service_id, customer_service_name,
  warehouse_id, inbound_warehouse_name, container_order_no, order_source,
  container_no, container_type, seal_no, shipping_line_id, shipping_line_name,
  vessel_name, voyage_no, route_code, mbl_no, hbl_no,
  discharge_port_id, discharge_port_name, terminal_id, terminal_name,
  eta, ata, pickup_lfd, empty_return_lfd,
  terminal_release_status, hold_flag, hold_types, hold_remark,
  exam_flag, exam_type, exam_remark,
  drayage_vendor_id, drayage_vendor_name,
  pickup_appointment_no, pickup_appointment_time, actual_pickup_time, pickup_remark,
  expected_arrival_time, actual_arrival_time,
  container_location, arrival_remark,
  devanning_no, expected_devanning_time, devanning_method, loading_type, sorting_method,
  devanning_start_time, devanning_finish_time, devanning_remark,
  empty_return_location, empty_return_time, empty_return_remark,
  pre_plan_truck_qty, pre_plan_pallet_qty, pre_plan_cbm,
  total_carton_qty, total_pallet_qty, total_weight, total_cbm,
  container_exception_flag, container_exception_type, container_exception_count,
  downstream_exception_flag, downstream_exception_count,
  container_status, internal_remark,
  status, remark, create_by, create_time, update_by, update_time, deleted
) VALUES
-- 9100004: 在途 ETA 6/1
(9100004,'000000',4000001,8001001,'Pacific Home Goods LLC',5001001,5002001,
 1,'Lily Chen',1,'Amy',
 4001001,'Los Angeles Central Warehouse','SO202605280004','IMPORT',
 'HLCU9876543','40HQ','SEAL11001',230201,'MAERSK',
 'MAERSK SENTOSA','521E','TP1','MAEU556677889','HBL-LAX-004',
 230101,'USLAX',230501,'Fenix Marine Services',
 '2026-06-01 07:00:00',NULL,'2026-06-05','2026-06-12',
 'UNKNOWN',0,NULL,NULL,0,NULL,NULL,
 7001001,'LAX Drayage Express',
 NULL,NULL,NULL,NULL,
 '2026-06-02 14:00:00',NULL,
 NULL,NULL,NULL,'2026-06-03 09:00:00','MANUAL','FLOOR','BY_ORDER',
 NULL,NULL,NULL,
 'FMS Empty Return',NULL,NULL,
 2,20,58.5,1050,20,13800.0,58.5,
 0,NULL,0,0,0,
 'IN_TRANSIT','在途，ETA 6/1',
 '0','演示数据',1,NOW(),1,NOW(),0),

-- 9100005: 在途 ETA 5/31，有Hold
(9100005,'000000',4000001,8001002,'Northstar Outdoor Inc.',5001002,5002001,
 1,'Kevin Zhang',1,'Mia',
 4001001,'Los Angeles Central Warehouse','SO202605280005','IMPORT',
 'EVYU1122334','40GP','SEAL11002',230202,'MSC',
 'MSC MAGNIFICA','339W','AAS2','MSCU223344556','HBL-LAX-005',
 230101,'USLAX',230502,'Yusen Terminal',
 '2026-05-31 06:00:00',NULL,'2026-06-03','2026-06-10',
 'HOLDING',1,'Customs','等待海关放行',0,NULL,NULL,
 7001001,'LAX Drayage Express',
 NULL,NULL,NULL,NULL,
 '2026-06-01 10:00:00',NULL,
 NULL,NULL,NULL,'2026-06-02 09:00:00','MIXED','PALLET','BY_WAREHOUSE_CODE',
 NULL,NULL,NULL,
 'YTI Empty Return',NULL,NULL,
 3,25,70.2,1280,25,16500.0,70.2,
 1,'CUSTOMS_HOLD',1,0,0,
 'IN_TRANSIT','在途有Hold，ETA 5/31',
 '0','演示数据',1,NOW(),1,NOW(),0),

-- 9100006: 已到仓 5/26，等待拆柜
(9100006,'000000',4000001,8001001,'Pacific Home Goods LLC',5001001,5002002,
 1,'Nina Wang',1,'Tom',
 4001001,'Los Angeles Central Warehouse','SO202605260006','IMPORT',
 'KMTU5566778','45HQ','SEAL11003',230203,'OOCL',
 'OOCL MALAYSIA','045E','EC2','OOLU334455667','HBL-LAX-006',
 230101,'USLAX',230501,'Fenix Marine Services',
 '2026-05-24 10:00:00','2026-05-24 13:30:00','2026-05-28','2026-06-04',
 'RELEASED',0,NULL,NULL,0,NULL,NULL,
 7001001,'LAX Drayage Express',
 'PU-LAX-20260524-06','2026-05-25 10:00:00','2026-05-25 15:40:00','已提柜',
 '2026-05-26 08:00:00','2026-05-26 09:15:00',
 'YARD-A-03','已到仓等待拆柜',
 NULL,'2026-05-27 08:00:00','MANUAL','FLOOR','BY_ORDER',
 NULL,NULL,NULL,
 'FMS Empty Return',NULL,NULL,
 2,18,54.6,920,18,12100.0,54.6,
 0,NULL,0,0,0,
 'ARRIVED_WAREHOUSE','已到仓待拆柜',
 '0','演示数据',1,NOW(),1,NOW(),0),

-- 9100007: 已到仓 5/27，已分配Dock A03
(9100007,'000000',4000001,8001003,'East Market Supply Co.',5001001,5002001,
 1,'Lily Chen',1,'Amy',
 4001001,'Los Angeles Central Warehouse','SO202605270007','IMPORT',
 'APLU2233445','40HQ','SEAL11004',230201,'MAERSK',
 'MAERSK CHICAGO','428E','TP1','MAEU778899001','HBL-LAX-007',
 230101,'USLAX',230502,'Yusen Terminal',
 '2026-05-25 08:00:00','2026-05-25 10:20:00','2026-05-29','2026-06-05',
 'RELEASED',0,NULL,NULL,0,NULL,NULL,
 7001001,'LAX Drayage Express',
 'PU-LAX-20260526-07','2026-05-26 14:00:00','2026-05-26 16:30:00','已提柜',
 '2026-05-27 07:30:00','2026-05-27 08:45:00',
 'YARD-A-01','已到仓，已分配Dock',
 NULL,'2026-05-28 09:00:00','MANUAL','FLOOR','BY_ORDER',
 NULL,NULL,NULL,
 'YTI Empty Return',NULL,NULL,
 2,22,62.8,1100,22,14500.0,62.8,
 0,NULL,0,0,0,
 'ARRIVED_WAREHOUSE','已到仓，已分配Dock A03',
 '0','演示数据',1,NOW(),1,NOW(),0),

-- 9100008: 拆柜中 DOC-LA-001（进度45%）
(9100008,'000000',4000001,8001001,'Pacific Home Goods LLC',5001002,5002001,
 1,'Kevin Zhang',1,'Mia',
 4001001,'Los Angeles Central Warehouse','SO202605270008','IMPORT',
 'TCKU8899001','40HQ','SEAL11005',230202,'MSC',
 'MSC ANNA','219W','SEA','MSCU889900123','HBL-LAX-008',
 230101,'USLAX',230501,'Fenix Marine Services',
 '2026-05-23 09:00:00','2026-05-23 11:45:00','2026-05-27','2026-06-02',
 'RELEASED',0,NULL,NULL,0,NULL,NULL,
 7001001,'LAX Drayage Express',
 'PU-LAX-20260524-08','2026-05-24 09:00:00','2026-05-24 15:10:00','已提柜',
 '2026-05-25 14:00:00','2026-05-25 15:20:00',
 'DOCK-LA-001','拆柜进行中',
 'DEV202605270008','2026-05-27 09:00:00','MANUAL','FLOOR','BY_ORDER',
 '2026-05-27 09:15:00',NULL,'拆柜进行中，进度约45%',
 'FMS Empty Return',NULL,NULL,
 3,28,76.4,1450,28,19200.0,76.4,
 0,NULL,0,0,0,
 'DEVANNING','拆柜中，进度45%',
 '0','演示数据',1,NOW(),1,NOW(),0),

-- 9100009: 拆柜中 DOC-LA-002（进度20%）
(9100009,'000000',4000001,8001002,'Northstar Outdoor Inc.',5001001,5002002,
 1,'Nina Wang',1,'Tom',
 4001001,'Los Angeles Central Warehouse','SO202605270009','IMPORT',
 'HJCU4455667','40GP','SEAL11006',230203,'OOCL',
 'OOCL TIANJIN','096W','EC2','OOLU556677889','HBL-LAX-009',
 230101,'USLAX',230502,'Yusen Terminal',
 '2026-05-22 07:00:00','2026-05-22 09:30:00','2026-05-26','2026-06-01',
 'RELEASED',0,NULL,NULL,0,NULL,NULL,
 7001001,'LAX Drayage Express',
 'PU-LAX-20260523-09','2026-05-23 10:00:00','2026-05-23 14:45:00','已提柜',
 '2026-05-24 10:00:00','2026-05-24 11:35:00',
 'DOCK-LA-002','拆柜进行中',
 'DEV202605270009','2026-05-27 13:00:00','MIXED','PALLET','BY_WAREHOUSE_CODE',
 '2026-05-27 13:10:00',NULL,'拆柜进行中，进度约20%',
 'YTI Empty Return',NULL,NULL,
 3,26,68.0,1340,26,17800.0,68.0,
 0,NULL,0,0,0,
 'DEVANNING','拆柜中，进度20%',
 '0','演示数据',1,NOW(),1,NOW(),0),

-- 9100010: 拆柜完成（5/26完成）
(9100010,'000000',4000001,8001003,'East Market Supply Co.',5001002,5002002,
 1,'Lily Chen',1,'Amy',
 4001001,'Los Angeles Central Warehouse','SO202605260010','IMPORT',
 'SEGU3344556','45HQ','SEAL11007',230201,'MAERSK',
 'MAERSK NORFOLK','427E','TP1','MAEU334455667','HBL-LAX-010',
 230101,'USLAX',230501,'Fenix Marine Services',
 '2026-05-20 08:00:00','2026-05-20 10:15:00','2026-05-24','2026-05-31',
 'RELEASED',0,NULL,NULL,0,NULL,NULL,
 7001001,'LAX Drayage Express',
 'PU-LAX-20260521-10','2026-05-21 08:00:00','2026-05-21 14:20:00','已提柜',
 '2026-05-22 08:00:00','2026-05-22 09:00:00',
 'DONE','已完成拆柜',
 'DEV202605260010','2026-05-24 10:00:00','MANUAL','FLOOR','BY_ORDER',
 '2026-05-24 10:20:00','2026-05-26 17:30:00','拆柜已完成',
 'FMS Empty Return','2026-05-28 11:00:00','已归还空柜',
 4,32,88.2,1680,32,22400.0,88.2,
 0,NULL,0,0,0,
 'DEVANNING_FINISHED','拆柜完成，已放行',
 '0','演示数据',1,NOW(),1,NOW(),0),

-- 9100011: 在途 ETA 6/5
(9100011,'000000',4000001,8001001,'Pacific Home Goods LLC',5001001,5002001,
 1,'Kevin Zhang',1,'Mia',
 4001001,'Los Angeles Central Warehouse','SO202605280011','IMPORT',
 'GLDU7788990','40HQ','SEAL11008',230202,'MSC',
 'MSC CELESTINA','340W','AAS2','MSCU990011223','HBL-LAX-011',
 230101,'USLAX',230502,'Yusen Terminal',
 '2026-06-05 08:00:00',NULL,'2026-06-09','2026-06-16',
 'UNKNOWN',0,NULL,NULL,0,NULL,NULL,
 7001001,'LAX Drayage Express',
 NULL,NULL,NULL,NULL,
 '2026-06-06 10:00:00',NULL,
 NULL,NULL,NULL,'2026-06-07 09:00:00','MANUAL','PALLET','BY_ORDER',
 NULL,NULL,NULL,
 'YTI Empty Return',NULL,NULL,
 2,20,56.8,1020,20,13400.0,56.8,
 0,NULL,0,0,0,
 'IN_TRANSIT','在途，ETA 6/5',
 '0','演示数据',1,NOW(),1,NOW(),0),

-- 9100012: 已到港待提柜
(9100012,'000000',4000001,8001002,'Northstar Outdoor Inc.',5001002,5002002,
 1,'Nina Wang',1,'Tom',
 4001001,'Los Angeles Central Warehouse','SO202605280012','IMPORT',
 'CAIU9900123','40GP','SEAL11009',230203,'OOCL',
 'OOCL RICHMOND','097E','EC2','OOLU112233445','HBL-LAX-012',
 230101,'USLAX',230501,'Fenix Marine Services',
 '2026-05-26 09:00:00','2026-05-26 11:00:00','2026-05-30','2026-06-06',
 'RELEASED',0,NULL,NULL,0,NULL,NULL,
 7001001,'LAX Drayage Express',
 'PU-LAX-20260527-12','2026-05-27 14:00:00',NULL,'已预约提柜',
 '2026-05-28 16:00:00',NULL,
 NULL,NULL,NULL,'2026-05-29 09:00:00','MANUAL','FLOOR','BY_ORDER',
 NULL,NULL,NULL,
 'FMS Empty Return',NULL,NULL,
 3,24,66.4,1220,24,16100.0,66.4,
 0,NULL,0,0,0,
 'AT_PORT','已到港待提柜',
 '0','演示数据',1,NOW(),1,NOW(),0),

-- 9100013: 已提柜在途到仓
(9100013,'000000',4000001,8001003,'East Market Supply Co.',5001001,5002001,
 1,'Lily Chen',1,'Amy',
 4001001,'Los Angeles Central Warehouse','SO202605280013','IMPORT',
 'YMLU6677889','45HQ','SEAL11010',230201,'MAERSK',
 'MAERSK COLUMBIA','429E','TP1','MAEU667788990','HBL-LAX-013',
 230101,'USLAX',230502,'Yusen Terminal',
 '2026-05-27 07:00:00','2026-05-27 09:30:00','2026-05-31','2026-06-07',
 'RELEASED',0,NULL,NULL,0,NULL,NULL,
 7001001,'LAX Drayage Express',
 'PU-LAX-20260527-13','2026-05-27 13:00:00','2026-05-27 16:50:00','已提柜在途',
 '2026-05-28 16:00:00',NULL,
 NULL,NULL,NULL,'2026-05-29 08:00:00','MANUAL','PALLET','BY_ORDER',
 NULL,NULL,NULL,
 'YTI Empty Return',NULL,NULL,
 2,24,66.0,1200,24,15900.0,66.0,
 0,NULL,0,0,0,
 'AT_PORT','已提柜，在途到仓',
 '0','演示数据',1,NOW(),1,NOW(),0);

-- ─────────────────────────────────────────────────────────
-- Part 4: YMS 园区任务（从OMS迁移 + 手动任务）
-- ─────────────────────────────────────────────────────────
INSERT IGNORE INTO yms_yard_task (
  id, tenant_id, yard_task_no, task_type, warehouse_id,
  source_order_type, source_order_id, source_order_no,
  container_no, truck_no, driver_name, driver_phone,
  eta_yard_time, gate_in_time, dock_start_time, dock_finish_time, release_time, gate_out_time,
  dock_id, dock_code,
  operation_status, operation_progress,
  operation_start_time, operation_finish_time,
  loaded_qty, total_qty,
  yard_status, visit_no, unload_round_no,
  active_task_key, is_reentry, exception_flag,
  source, remark,
  create_by, create_time, update_by, update_time, deleted
) VALUES
-- 1. PRE_ARRIVAL：OMS 9100001 (TGHU1234567，在途)
(9200001,'000000','YT20260524001','DEVANNING',4001001,
 'CONTAINER_ORDER',9100001,'SO202605220001',
 'TGHU1234567','CA-TRK-001','张伟','310-555-0101',
 '2026-05-28 16:00:00',NULL,NULL,NULL,NULL,NULL,
 NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
 'PRE_ARRIVAL',1,1,
 'CONTAINER_ORDER:9100001',0,0,
 'OMS_PUSH','ETA 5/28 到仓',
 1,'2026-05-24 09:00:00',1,'2026-05-24 09:00:00',0),

-- 2. CREATED：OMS 9100002 (MSCU7654321，Hold中)
(9200002,'000000','YT20260524002','DEVANNING',4001001,
 'CONTAINER_ORDER',9100002,'SO202605220002',
 'MSCU7654321',NULL,NULL,NULL,
 '2026-05-23 10:30:00',NULL,NULL,NULL,NULL,NULL,
 NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
 'CREATED',1,1,
 'CONTAINER_ORDER:9100002',0,0,
 'OMS_PUSH','Hold中，等待码头放行',
 1,'2026-05-24 10:00:00',1,'2026-05-24 10:00:00',0),

-- 3. PRE_ARRIVAL：OMS 9100004 (HLCU9876543，ETA 6/1)
(9200003,'000000','YT20260525001','DEVANNING',4001001,
 'CONTAINER_ORDER',9100004,'SO202605280004',
 'HLCU9876543',NULL,NULL,NULL,
 '2026-06-02 14:00:00',NULL,NULL,NULL,NULL,NULL,
 NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
 'PRE_ARRIVAL',1,1,
 'CONTAINER_ORDER:9100004',0,0,
 'OMS_PUSH','ETA 6/1 到仓',
 1,'2026-05-25 08:00:00',1,'2026-05-25 08:00:00',0),

-- 4. PRE_ARRIVAL：OMS 9100005 (EVYU1122334，ETA 5/31，Hold)
(9200004,'000000','YT20260525002','DEVANNING',4001001,
 'CONTAINER_ORDER',9100005,'SO202605280005',
 'EVYU1122334',NULL,NULL,NULL,
 '2026-06-01 10:00:00',NULL,NULL,NULL,NULL,NULL,
 NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
 'PRE_ARRIVAL',1,1,
 'CONTAINER_ORDER:9100005',0,1,
 'OMS_PUSH','有Hold，等待海关放行',
 1,'2026-05-25 09:00:00',1,'2026-05-25 09:00:00',0),

-- 5. ARRIVED：OMS 9100006 (KMTU5566778，已到仓)
(9200005,'000000','YT20260526001','DEVANNING',4001001,
 'CONTAINER_ORDER',9100006,'SO202605260006',
 'KMTU5566778','CA-TRK-006','李刚','310-555-0106',
 '2026-05-26 08:00:00','2026-05-26 09:15:00',NULL,NULL,NULL,NULL,
 NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
 'ARRIVED',1,1,
 'CONTAINER_ORDER:9100006',0,0,
 'OMS_PUSH','已到仓，等待分配Dock',
 1,'2026-05-26 09:00:00',1,'2026-05-26 09:15:00',0),

-- 6. DOCK_ASSIGNED：OMS 9100007 (APLU2233445，已分配 DOC-LA-A03)
(9200006,'000000','YT20260526002','DEVANNING',4001001,
 'CONTAINER_ORDER',9100007,'SO202605270007',
 'APLU2233445','CA-TRK-007','王五','310-555-0107',
 '2026-05-27 07:30:00','2026-05-27 08:45:00',NULL,NULL,NULL,NULL,
 3010004,'DOC-LA-A03',NULL,NULL,NULL,NULL,NULL,NULL,
 'DOCK_ASSIGNED',1,1,
 'CONTAINER_ORDER:9100007',0,0,
 'OMS_PUSH','已分配 A区3号 Dock',
 1,'2026-05-26 10:00:00',1,'2026-05-27 08:50:00',0),

-- 7. DEVANNING：OMS 9100008 (TCKU8899001，拆柜中45%，DOC-LA-001)
(9200007,'000000','YT20260527001','DEVANNING',4001001,
 'CONTAINER_ORDER',9100008,'SO202605270008',
 'TCKU8899001','CA-TRK-008','陈三','310-555-0108',
 '2026-05-25 14:00:00','2026-05-25 15:20:00','2026-05-27 09:15:00',NULL,NULL,NULL,
 3010001,'DOC-LA-001','IN_PROGRESS',45.00,
 '2026-05-27 09:15:00',NULL,NULL,NULL,
 'DEVANNING',1,1,
 'CONTAINER_ORDER:9100008',0,0,
 'OMS_PUSH','拆柜中，进度45%',
 1,'2026-05-27 08:00:00',1,'2026-05-27 09:15:00',0),

-- 8. DOCK_WORKING：OMS 9100009 (HJCU4455667，作业中20%，DOC-LA-002)
(9200008,'000000','YT20260527002','DEVANNING',4001001,
 'CONTAINER_ORDER',9100009,'SO202605270009',
 'HJCU4455667','CA-TRK-009','赵六','310-555-0109',
 '2026-05-24 10:00:00','2026-05-24 11:35:00','2026-05-27 13:10:00',NULL,NULL,NULL,
 3010002,'DOC-LA-002','IN_PROGRESS',20.00,
 '2026-05-27 13:10:00',NULL,NULL,NULL,
 'DOCK_WORKING',1,1,
 'CONTAINER_ORDER:9100009',0,0,
 'OMS_PUSH','Dock作业中，进度20%',
 1,'2026-05-27 12:00:00',1,'2026-05-27 13:10:00',0),

-- 9. OPERATION_FINISHED：OMS 9100010 (SEGU3344556，拆柜完成)
(9200009,'000000','YT20260527003','DEVANNING',4001001,
 'CONTAINER_ORDER',9100010,'SO202605260010',
 'SEGU3344556','CA-TRK-010','孙七','310-555-0110',
 '2026-05-22 08:00:00','2026-05-22 09:00:00','2026-05-24 10:20:00','2026-05-26 17:30:00',NULL,NULL,
 NULL,NULL,'FINISHED',100.00,
 '2026-05-24 10:20:00','2026-05-26 17:30:00',1680,1680,
 'OPERATION_FINISHED',1,1,
 NULL,0,0,
 'OMS_PUSH','拆柜完成100%，待放行',
 1,'2026-05-26 08:00:00',1,'2026-05-26 17:30:00',0),

-- 10. ARRIVED：OMS 9100013 (YMLU6677889，在途到仓)
(9200010,'000000','YT20260528001','DEVANNING',4001001,
 'CONTAINER_ORDER',9100013,'SO202605280013',
 'YMLU6677889',NULL,NULL,NULL,
 '2026-05-28 16:00:00',NULL,NULL,NULL,NULL,NULL,
 NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
 'CREATED',1,1,
 'CONTAINER_ORDER:9100013',0,0,
 'OMS_PUSH','已提柜，预计今日到仓',
 1,'2026-05-28 07:00:00',1,'2026-05-28 07:00:00',0),

-- 11. 手动任务：装车任务，已到仓，分配 DOC-LA-B01
(9200011,'000000','YT20260528002','DELIVERY_LOADING',4001001,
 'MANUAL',NULL,NULL,
 NULL,'CA-TRK-201','周八','310-555-0201',
 '2026-05-28 07:00:00','2026-05-28 07:30:00',NULL,NULL,NULL,NULL,
 3010005,'DOC-LA-B01',NULL,NULL,NULL,NULL,NULL,NULL,
 'DOCK_ASSIGNED',1,1,
 NULL,0,0,
 'MANUAL','FBA派送装车，分配B区1号',
 1,'2026-05-28 06:00:00',1,'2026-05-28 07:35:00',0),

-- 12. 手动任务：调拨装车，排队中 DOC-LA-B02
(9200012,'000000','YT20260528003','TRANSFER_LOADING',4001001,
 'MANUAL',NULL,NULL,
 NULL,'CA-TRK-202','吴九','310-555-0202',
 '2026-05-28 09:00:00','2026-05-28 09:15:00',NULL,NULL,NULL,NULL,
 3010006,'DOC-LA-B02',NULL,NULL,NULL,NULL,NULL,NULL,
 'QUEUED',1,1,
 NULL,0,0,
 'MANUAL','调拨装车，B区2号排队等待',
 1,'2026-05-28 08:30:00',1,'2026-05-28 09:16:00',0),

-- 13. RELEASED（历史任务，已放行）
(9200013,'000000','YT20260522001','DEVANNING',4001001,
 'CONTAINER_ORDER',NULL,'SO202605220003',
 'OOLU4567890',NULL,NULL,NULL,
 '2026-05-21 09:00:00','2026-05-21 09:35:00','2026-05-22 10:15:00','2026-05-23 16:00:00','2026-05-23 17:00:00',NULL,
 NULL,NULL,'FINISHED',100.00,
 '2026-05-22 10:15:00','2026-05-23 16:00:00',1420,1420,
 'RELEASED',1,1,
 NULL,0,0,
 'OMS_PUSH','已放行',
 1,'2026-05-21 08:00:00',1,'2026-05-23 17:00:00',0),

-- 14. LEFT_YARD（历史任务，已离园）
(9200014,'000000','YT20260520001','DEVANNING',4001001,
 'CONTAINER_ORDER',NULL,'SO202605200001',
 'MSCU1234001',NULL,NULL,NULL,
 '2026-05-19 14:00:00','2026-05-19 14:30:00','2026-05-20 09:00:00','2026-05-21 15:00:00','2026-05-21 16:00:00','2026-05-21 16:45:00',
 NULL,NULL,'FINISHED',100.00,
 '2026-05-20 09:00:00','2026-05-21 15:00:00',980,980,
 'LEFT_YARD',1,1,
 NULL,0,0,
 'OMS_PUSH','已离园（历史）',
 1,'2026-05-19 13:00:00',1,'2026-05-21 16:45:00',0);

-- ─────────────────────────────────────────────────────────
-- Part 5: 园区任务操作日志
-- ─────────────────────────────────────────────────────────
INSERT IGNORE INTO yms_yard_task_log
  (id, tenant_id, yard_task_id, action_type, before_status, after_status,
   action_content, operator_id, operator_name, action_time)
VALUES
-- 任务1 日志
(9201001,'000000',9200001,'TASK_CREATED',NULL,'PRE_ARRIVAL','OMS推送创建任务',1,'系统','2026-05-24 09:00:00'),
-- 任务2 日志
(9201002,'000000',9200002,'TASK_CREATED',NULL,'CREATED','OMS推送创建任务（Hold中）',1,'系统','2026-05-24 10:00:00'),
-- 任务5 日志
(9201003,'000000',9200005,'TASK_CREATED',NULL,'PRE_ARRIVAL','OMS推送创建任务',1,'系统','2026-05-26 09:00:00'),
(9201004,'000000',9200005,'CHECK_IN','PRE_ARRIVAL','ARRIVED','车辆签到到仓',1,'admin','2026-05-26 09:15:00'),
-- 任务6 日志
(9201005,'000000',9200006,'TASK_CREATED',NULL,'PRE_ARRIVAL','OMS推送创建任务',1,'系统','2026-05-26 10:00:00'),
(9201006,'000000',9200006,'CHECK_IN','PRE_ARRIVAL','ARRIVED','车辆签到',1,'admin','2026-05-27 08:45:00'),
(9201007,'000000',9200006,'ASSIGN_DOCK','ARRIVED','DOCK_ASSIGNED','分配至 DOC-LA-A03',1,'admin','2026-05-27 08:50:00'),
-- 任务7 日志
(9201008,'000000',9200007,'TASK_CREATED',NULL,'PRE_ARRIVAL','OMS推送创建任务',1,'系统','2026-05-27 08:00:00'),
(9201009,'000000',9200007,'CHECK_IN','PRE_ARRIVAL','ARRIVED','车辆签到',1,'admin','2026-05-25 15:20:00'),
(9201010,'000000',9200007,'ASSIGN_DOCK','ARRIVED','DOCK_ASSIGNED','分配至 DOC-LA-001',1,'admin','2026-05-27 09:00:00'),
(9201011,'000000',9200007,'START_WORK','DOCK_ASSIGNED','DEVANNING','开始卸柜作业',1,'admin','2026-05-27 09:15:00'),
-- 任务8 日志
(9201012,'000000',9200008,'TASK_CREATED',NULL,'PRE_ARRIVAL','OMS推送创建任务',1,'系统','2026-05-27 12:00:00'),
(9201013,'000000',9200008,'CHECK_IN','PRE_ARRIVAL','ARRIVED','车辆签到',1,'admin','2026-05-24 11:35:00'),
(9201014,'000000',9200008,'ASSIGN_DOCK','ARRIVED','DOCK_ASSIGNED','分配至 DOC-LA-002',1,'admin','2026-05-27 13:00:00'),
(9201015,'000000',9200008,'START_WORK','DOCK_ASSIGNED','DOCK_WORKING','开始作业',1,'admin','2026-05-27 13:10:00'),
-- 任务9 日志
(9201016,'000000',9200009,'TASK_CREATED',NULL,'PRE_ARRIVAL','OMS推送创建任务',1,'系统','2026-05-26 08:00:00'),
(9201017,'000000',9200009,'CHECK_IN','PRE_ARRIVAL','ARRIVED','车辆签到',1,'admin','2026-05-22 09:00:00'),
(9201018,'000000',9200009,'FINISH_WORK','DOCK_WORKING','OPERATION_FINISHED','作业完成100%',1,'admin','2026-05-26 17:30:00'),
-- 任务11 日志
(9201019,'000000',9200011,'TASK_CREATED',NULL,'CREATED','手动创建装车任务',1,'admin','2026-05-28 06:00:00'),
(9201020,'000000',9200011,'CHECK_IN','CREATED','ARRIVED','车辆签到',1,'admin','2026-05-28 07:30:00'),
(9201021,'000000',9200011,'ASSIGN_DOCK','ARRIVED','DOCK_ASSIGNED','分配至 DOC-LA-B01',1,'admin','2026-05-28 07:35:00'),
-- 历史任务13 日志
(9201022,'000000',9200013,'TASK_CREATED',NULL,'PRE_ARRIVAL','创建任务',1,'系统','2026-05-21 08:00:00'),
(9201023,'000000',9200013,'FINISH_WORK','DOCK_WORKING','OPERATION_FINISHED','拆柜完成',1,'admin','2026-05-23 16:00:00'),
(9201024,'000000',9200013,'RELEASE','OPERATION_FINISHED','RELEASED','放行',1,'admin','2026-05-23 17:00:00');

-- ─────────────────────────────────────────────────────────
-- Part 6: 排队记录（任务12在DOC-LA-B02排队）
-- ─────────────────────────────────────────────────────────
INSERT IGNORE INTO yms_dock_queue
  (id, tenant_id, dock_id, yard_task_id, container_no, queue_no, queue_status, queued_time)
VALUES
(9202001,'000000',3010006,9200012,'CA-TRK-202',1,'WAITING','2026-05-28 09:16:00');
