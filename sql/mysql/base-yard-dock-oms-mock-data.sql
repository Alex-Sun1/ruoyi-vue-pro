-- 基础资料「月台设置」(yard_zone / yard_dock) + OMS 海柜月台关联模拟数据
-- 前置（按顺序）：
--   1. base-tables.sql + sql/migration-overall/04-base-missing.sql（yard_zone / yard_dock 表）
--   2. base-mock-data.sql（仓库 9001/9002/9003、客户 1001）
--   3. oms-mock-data.sql（海柜 21001~21003，可选）
-- 默认租户 tenant_id = 1；可重复执行（固定 ID 段清理后 UPSERT）
SET NAMES utf8mb4;

SET @tenant_id = 1;
SET @creator = 'admin';
SET @now = NOW();

-- ========== 清理本租户模拟段 ==========
DELETE FROM `yard_dock` WHERE `tenant_id` = @tenant_id AND `id` BETWEEN 9201 AND 9399;
DELETE FROM `yard_zone` WHERE `tenant_id` = @tenant_id AND `id` BETWEEN 9101 AND 9110;
DELETE FROM `base_business_type` WHERE `tenant_id` = @tenant_id AND `id` BETWEEN 9051 AND 9055;

-- ========== 业务类型（月台可选关联，供卸柜/装车道口区分）==========
INSERT INTO `base_business_type` (
    `id`, `business_type_code`, `business_type_name`, `business_category`, `operation_flow_type`,
    `receive_required`, `inbound_required`, `putaway_required`, `storage_required`,
    `picking_required`, `outbound_required`, `delivery_required`, `appointment_required`, `vas_supported`,
    `sorting_strategy`, `sorting_field`, `sort_order`, `status`, `remark`,
    `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`
) VALUES
(9051, 'DEVANNING', '海柜拆柜', 'WAREHOUSE', 'INBOUND',
 b'1', b'1', b'1', b'1', b'0', b'0', b'0', b'1', b'0',
 'NONE', NULL, 1, 0, '卸柜道口默认业务类型',
 @creator, @now, @creator, @now, b'0', @tenant_id),
(9052, 'TRUCK_LOADING', '装车出库', 'TRANSPORT', 'OUTBOUND',
 b'0', b'0', b'0', b'0', b'1', b'1', b'1', b'1', b'0',
 'FIELD_BASED', 'warehouse_code', 2, 0, '装车道口默认业务类型',
 @creator, @now, @creator, @now, b'0', @tenant_id),
(9053, 'MIXED_DOCK', '混合道口', 'WAREHOUSE', 'MIXED',
 b'1', b'1', b'1', b'1', b'1', b'1', b'1', b'1', b'0',
 'NONE', NULL, 3, 0, '拆柜+装车混用道口',
 @creator, @now, @creator, @now, b'0', @tenant_id)
ON DUPLICATE KEY UPDATE
    `business_type_name` = VALUES(`business_type_name`),
    `updater` = VALUES(`updater`), `update_time` = VALUES(`update_time`);

-- ========== 堆场分区（关联 base-mock 仓库 9001 LA / 9002 NJ / 9003 SZ）==========
INSERT INTO `yard_zone` (
    `id`, `warehouse_id`, `zone_code`, `zone_name`, `zone_type`, `sort_order`, `remark`,
    `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`
) VALUES
(9101, 9001, 'ZONE-LA-CNT', '洛杉矶-海柜卸柜区', 'CONTAINER', 1, 'A/C 区卸柜道口', @creator, @now, @creator, @now, b'0', @tenant_id),
(9102, 9001, 'ZONE-LA-TRK', '洛杉矶-装车出库区', 'TRUCK', 2, 'B 区装车道口', @creator, @now, @creator, @now, b'0', @tenant_id),
(9103, 9001, 'ZONE-LA-PKG', '洛杉矶-前院停车区', 'PARKING', 3, '等待与调度', @creator, @now, @creator, @now, b'0', @tenant_id),
(9104, 9001, 'ZONE-LA-YRD', '洛杉矶-后院堆位区', 'CONTAINER', 4, '海柜/车厢堆位', @creator, @now, @creator, @now, b'0', @tenant_id),
(9105, 9002, 'ZONE-NJ-CNT', '新泽西-海柜卸柜区', 'CONTAINER', 1, '美东卸柜', @creator, @now, @creator, @now, b'0', @tenant_id),
(9106, 9002, 'ZONE-NJ-TRK', '新泽西-装车出库区', 'TRUCK', 2, '美东装车', @creator, @now, @creator, @now, b'0', @tenant_id),
(9107, 9002, 'ZONE-NJ-PKG', '新泽西-停车等待区', 'PARKING', 3, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9108, 9003, 'ZONE-SZ-CNT', '深圳-保税卸柜区', 'CONTAINER', 1, '国内集货仓', @creator, @now, @creator, @now, b'0', @tenant_id),
(9109, 9003, 'ZONE-SZ-PKG', '深圳-停车区', 'PARKING', 2, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9110, 9002, 'ZONE-NJ-YRD', '新泽西-堆位区', 'CONTAINER', 4, '海柜堆存', @creator, @now, @creator, @now, b'0', @tenant_id)
ON DUPLICATE KEY UPDATE
    `zone_name` = VALUES(`zone_name`), `zone_type` = VALUES(`zone_type`),
    `updater` = VALUES(`updater`), `update_time` = VALUES(`update_time`);

-- ========== 月台 / 堆位（共 44 条：LA 20 + NJ 16 + SZ 8）==========
-- location_type: DOCK / PARKING / CONTAINER_SLOT / TRAILER_SLOT / WAITING_SLOT
-- dock_status: IDLE / RESERVED / OCCUPIED / MAINTENANCE / CLOSED（与 YMS 字典一致）
-- dock_location: yard_dock_location 字典 FRONT_YARD_DOCK / BACK_YARD_DOCK / FRONT_YARD_PARKING / BACK_YARD_PARKING
INSERT INTO `yard_dock` (
    `id`, `dock_code`, `dock_name`, `location_type`,
    `warehouse_id`, `warehouse_code`, `warehouse_name`,
    `zone_id`, `zone_code`, `business_type_id`, `business_type_code`, `business_type_name`,
    `dock_location`, `grid_row`, `grid_col`,
    `allowed_vehicle_types`, `appointment_supported`, `max_concurrent`,
    `dock_status`, `occupied_object_type`, `occupied_object_id`, `occupied_object_no`, `occupied_since`,
    `enabled_flag`, `sort_order`, `dispatch_priority`, `dock_type`, `enable_queue`, `max_queue_count`,
    `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`
) VALUES
-- ── 洛杉矶 9001 US-LA-01：卸柜 A 区 6 个道口 ──
(9201, 'DOC-LA-A01', 'LA A区1号卸柜道口', 'DOCK', 9001, 'US-LA-01', '洛杉矶一号仓',
 9101, 'ZONE-LA-CNT', 9051, 'DEVANNING', '海柜拆柜', 'FRONT_YARD_DOCK', 1, 1,
 '53FT,40HQ,45HQ', 1, 1, 'IDLE', NULL, NULL, NULL, NULL, 1, 1, 1, 'DEVANNING', 1, 3, 'A区主力卸柜', @creator, @now, @creator, @now, b'0', @tenant_id),
(9202, 'DOC-LA-A02', 'LA A区2号卸柜道口', 'DOCK', 9001, 'US-LA-01', '洛杉矶一号仓',
 9101, 'ZONE-LA-CNT', 9051, 'DEVANNING', '海柜拆柜', 'FRONT_YARD_DOCK', 1, 2,
 '53FT,40HQ', 1, 1, 'OCCUPIED', 'CONTAINER', 21002, 'MSCU7654321', DATE_SUB(@now, INTERVAL 2 HOUR),
 1, 2, 1, 'DEVANNING', 1, 2, '拆柜中-关联海柜21002', @creator, @now, @creator, @now, b'0', @tenant_id),
(9203, 'DOC-LA-A03', 'LA A区3号卸柜道口', 'DOCK', 9001, 'US-LA-01', '洛杉矶一号仓',
 9101, 'ZONE-LA-CNT', 9051, 'DEVANNING', '海柜拆柜', 'FRONT_YARD_DOCK', 1, 3,
 '53FT,40HQ', 1, 1, 'IDLE', NULL, NULL, NULL, NULL, 1, 3, 1, 'DEVANNING', 1, 3, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9204, 'DOC-LA-A04', 'LA A区4号卸柜道口', 'DOCK', 9001, 'US-LA-01', '洛杉矶一号仓',
 9101, 'ZONE-LA-CNT', 9051, 'DEVANNING', '海柜拆柜', 'FRONT_YARD_DOCK', 1, 4,
 '40HQ,20GP', 1, 1, 'RESERVED', 'CONTAINER', 21003, 'MSCU9876543', DATE_SUB(@now, INTERVAL 30 MINUTE),
 1, 4, 2, 'DEVANNING', 0, NULL, '已预占-海柜21003', @creator, @now, @creator, @now, b'0', @tenant_id),
(9205, 'DOC-LA-A05', 'LA A区5号卸柜道口', 'DOCK', 9001, 'US-LA-01', '洛杉矶一号仓',
 9101, 'ZONE-LA-CNT', 9051, 'DEVANNING', '海柜拆柜', 'FRONT_YARD_DOCK', 1, 5,
 '53FT,40HQ', 1, 1, 'MAINTENANCE', NULL, NULL, NULL, NULL, 1, 5, 3, 'DEVANNING', 0, NULL, '液压平台维修', @creator, @now, @creator, @now, b'0', @tenant_id),
(9206, 'DOC-LA-A06', 'LA A区6号卸柜道口', 'DOCK', 9001, 'US-LA-01', '洛杉矶一号仓',
 9101, 'ZONE-LA-CNT', 9053, 'MIXED_DOCK', '混合道口', 'BACK_YARD_DOCK', 1, 6,
 '53FT,40HQ,20GP', 1, 1, 'IDLE', NULL, NULL, NULL, NULL, 1, 6, 2, NULL, 1, 2, '拆柜/装车混用', @creator, @now, @creator, @now, b'0', @tenant_id),
-- LA 装车 B 区 4 个
(9207, 'DOC-LA-B01', 'LA B区1号装车道口', 'DOCK', 9001, 'US-LA-01', '洛杉矶一号仓',
 9102, 'ZONE-LA-TRK', 9052, 'TRUCK_LOADING', '装车出库', 'BACK_YARD_DOCK', 2, 1,
 '53FT,40HQ', 1, 1, 'IDLE', NULL, NULL, NULL, NULL, 1, 7, 1, 'LOADING', 0, NULL, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9208, 'DOC-LA-B02', 'LA B区2号装车道口', 'DOCK', 9001, 'US-LA-01', '洛杉矶一号仓',
 9102, 'ZONE-LA-TRK', 9052, 'TRUCK_LOADING', '装车出库', 'BACK_YARD_DOCK', 2, 2,
 '53FT,40HQ', 1, 1, 'OCCUPIED', 'TRAILER', NULL, 'TRL-LA-8821', DATE_SUB(@now, INTERVAL 45 MINUTE),
 1, 8, 1, 'LOADING', 1, 2, '装车作业中', @creator, @now, @creator, @now, b'0', @tenant_id),
(9209, 'DOC-LA-B03', 'LA B区3号装车道口', 'DOCK', 9001, 'US-LA-01', '洛杉矶一号仓',
 9102, 'ZONE-LA-TRK', 9052, 'TRUCK_LOADING', '装车出库', 'BACK_YARD_DOCK', 2, 3,
 '53FT', 1, 1, 'IDLE', NULL, NULL, NULL, NULL, 1, 9, 2, 'LOADING', 1, 3, '支持排队', @creator, @now, @creator, @now, b'0', @tenant_id),
(9210, 'DOC-LA-B04', 'LA B区4号装车道口', 'DOCK', 9001, 'US-LA-01', '洛杉矶一号仓',
 9102, 'ZONE-LA-TRK', 9052, 'TRUCK_LOADING', '装车出库', 'BACK_YARD_DOCK', 2, 4,
 '40HQ,20GP', 1, 1, 'CLOSED', NULL, NULL, NULL, NULL, 0, 10, 9, 'LOADING', 0, NULL, '淡季停用', @creator, @now, @creator, @now, b'0', @tenant_id),
-- LA 堆位 / 停车 10 个
(9211, 'PKG-LA-F01', 'LA 前院等待位1', 'WAITING_SLOT', 9001, 'US-LA-01', '洛杉矶一号仓',
 9103, 'ZONE-LA-PKG', NULL, NULL, NULL, 'FRONT_YARD_PARKING', 3, 1,
 '53FT,40HQ', 0, 1, 'IDLE', NULL, NULL, NULL, NULL, 1, 11, 5, NULL, 0, NULL, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9212, 'PKG-LA-F02', 'LA 前院等待位2', 'WAITING_SLOT', 9001, 'US-LA-01', '洛杉矶一号仓',
 9103, 'ZONE-LA-PKG', NULL, NULL, NULL, 'FRONT_YARD_PARKING', 3, 2,
 '53FT', 0, 1, 'OCCUPIED', 'TRAILER', NULL, 'TRL-LA-9902', DATE_SUB(@now, INTERVAL 20 MINUTE),
 1, 12, 5, NULL, 0, NULL, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9213, 'PKG-LA-F03', 'LA 前院停车位1', 'PARKING', 9001, 'US-LA-01', '洛杉矶一号仓',
 9103, 'ZONE-LA-PKG', NULL, NULL, NULL, 'FRONT_YARD_PARKING', 3, 3,
 '53FT,40HQ,20GP', 0, 2, 'IDLE', NULL, NULL, NULL, NULL, 1, 13, 6, NULL, 0, NULL, '双车位', @creator, @now, @creator, @now, b'0', @tenant_id),
(9214, 'PKG-LA-F04', 'LA 前院停车位2', 'PARKING', 9001, 'US-LA-01', '洛杉矶一号仓',
 9103, 'ZONE-LA-PKG', NULL, NULL, NULL, 'FRONT_YARD_PARKING', 3, 4,
 '53FT', 0, 1, 'IDLE', NULL, NULL, NULL, NULL, 1, 14, 6, NULL, 0, NULL, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9215, 'CNT-LA-Y01', 'LA 海柜堆位Y01', 'CONTAINER_SLOT', 9001, 'US-LA-01', '洛杉矶一号仓',
 9104, 'ZONE-LA-YRD', NULL, NULL, NULL, 'BACK_YARD_PARKING', 4, 1,
 '40HQ,45HQ', 0, 1, 'OCCUPIED', 'CONTAINER', 21001, 'MSCU1234567', DATE_SUB(@now, INTERVAL 6 HOUR),
 1, 15, 4, NULL, 0, NULL, '待卸柜海柜21001', @creator, @now, @creator, @now, b'0', @tenant_id),
(9216, 'CNT-LA-Y02', 'LA 海柜堆位Y02', 'CONTAINER_SLOT', 9001, 'US-LA-01', '洛杉矶一号仓',
 9104, 'ZONE-LA-YRD', NULL, NULL, NULL, 'BACK_YARD_PARKING', 4, 2,
 '40HQ', 0, 1, 'IDLE', NULL, NULL, NULL, NULL, 1, 16, 4, NULL, 0, NULL, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9217, 'CNT-LA-Y03', 'LA 海柜堆位Y03', 'CONTAINER_SLOT', 9001, 'US-LA-01', '洛杉矶一号仓',
 9104, 'ZONE-LA-YRD', NULL, NULL, NULL, 'BACK_YARD_PARKING', 4, 3,
 '20GP,40HQ', 0, 1, 'IDLE', NULL, NULL, NULL, NULL, 1, 17, 4, NULL, 0, NULL, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9218, 'TRL-LA-Y01', 'LA 车厢堆位T01', 'TRAILER_SLOT', 9001, 'US-LA-01', '洛杉矶一号仓',
 9104, 'ZONE-LA-YRD', NULL, NULL, NULL, 'BACK_YARD_PARKING', 4, 4,
 '53FT', 0, 1, 'IDLE', NULL, NULL, NULL, NULL, 1, 18, 4, NULL, 0, NULL, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9219, 'TRL-LA-Y02', 'LA 车厢堆位T02', 'TRAILER_SLOT', 9001, 'US-LA-01', '洛杉矶一号仓',
 9104, 'ZONE-LA-YRD', NULL, NULL, NULL, 'BACK_YARD_PARKING', 4, 5,
 '53FT,40HQ', 0, 1, 'RESERVED', 'TRAILER', NULL, 'TRL-LA-7733', DATE_SUB(@now, INTERVAL 10 MINUTE),
 1, 19, 4, NULL, 0, NULL, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9220, 'BLK-LA-Y01', 'LA 禁入位X01', 'BLOCKED_SLOT', 9001, 'US-LA-01', '洛杉矶一号仓',
 9104, 'ZONE-LA-YRD', NULL, NULL, NULL, 'BACK_YARD_PARKING', 4, 6,
 NULL, 0, 0, 'CLOSED', NULL, NULL, NULL, NULL, 0, 20, 9, NULL, 0, NULL, '施工禁入', @creator, @now, @creator, @now, b'0', @tenant_id),

-- ── 新泽西 9002 US-NJ-01：16 条 ──
(9221, 'DOC-NJ-A01', 'NJ A区1号卸柜道口', 'DOCK', 9002, 'US-NJ-01', '新泽西一号仓',
 9105, 'ZONE-NJ-CNT', 9051, 'DEVANNING', '海柜拆柜', 'FRONT_YARD_DOCK', 1, 1,
 '53FT,40HQ', 1, 1, 'IDLE', NULL, NULL, NULL, NULL, 1, 1, 1, 'DEVANNING', 1, 2, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9222, 'DOC-NJ-A02', 'NJ A区2号卸柜道口', 'DOCK', 9002, 'US-NJ-01', '新泽西一号仓',
 9105, 'ZONE-NJ-CNT', 9051, 'DEVANNING', '海柜拆柜', 'FRONT_YARD_DOCK', 1, 2,
 '53FT,40HQ', 1, 1, 'OCCUPIED', 'CONTAINER', NULL, 'HLCU5566778', DATE_SUB(@now, INTERVAL 90 MINUTE),
 1, 2, 1, 'DEVANNING', 0, NULL, '演示占用', @creator, @now, @creator, @now, b'0', @tenant_id),
(9223, 'DOC-NJ-A03', 'NJ A区3号卸柜道口', 'DOCK', 9002, 'US-NJ-01', '新泽西一号仓',
 9105, 'ZONE-NJ-CNT', 9051, 'DEVANNING', '海柜拆柜', 'FRONT_YARD_DOCK', 1, 3,
 '40HQ,20GP', 1, 1, 'IDLE', NULL, NULL, NULL, NULL, 1, 3, 2, 'DEVANNING', 1, 3, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9224, 'DOC-NJ-A04', 'NJ A区4号卸柜道口', 'DOCK', 9002, 'US-NJ-01', '新泽西一号仓',
 9105, 'ZONE-NJ-CNT', 9053, 'MIXED_DOCK', '混合道口', 'BACK_YARD_DOCK', 1, 4,
 '53FT', 1, 1, 'MAINTENANCE', NULL, NULL, NULL, NULL, 1, 4, 3, NULL, 0, NULL, '月台保养', @creator, @now, @creator, @now, b'0', @tenant_id),
(9225, 'DOC-NJ-B01', 'NJ B区1号装车道口', 'DOCK', 9002, 'US-NJ-01', '新泽西一号仓',
 9106, 'ZONE-NJ-TRK', 9052, 'TRUCK_LOADING', '装车出库', 'BACK_YARD_DOCK', 2, 1,
 '53FT,40HQ', 1, 1, 'IDLE', NULL, NULL, NULL, NULL, 1, 5, 1, 'LOADING', 0, NULL, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9226, 'DOC-NJ-B02', 'NJ B区2号装车道口', 'DOCK', 9002, 'US-NJ-01', '新泽西一号仓',
 9106, 'ZONE-NJ-TRK', 9052, 'TRUCK_LOADING', '装车出库', 'BACK_YARD_DOCK', 2, 2,
 '53FT', 1, 1, 'RESERVED', 'TRAILER', NULL, 'TRL-NJ-2201', DATE_SUB(@now, INTERVAL 15 MINUTE),
 1, 6, 1, 'LOADING', 1, 2, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9227, 'DOC-NJ-B03', 'NJ B区3号装车道口', 'DOCK', 9002, 'US-NJ-01', '新泽西一号仓',
 9106, 'ZONE-NJ-TRK', 9052, 'TRUCK_LOADING', '装车出库', 'BACK_YARD_DOCK', 2, 3,
 '40HQ', 1, 1, 'IDLE', NULL, NULL, NULL, NULL, 1, 7, 2, 'LOADING', 0, NULL, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9228, 'PKG-NJ-F01', 'NJ 前院等待位1', 'WAITING_SLOT', 9002, 'US-NJ-01', '新泽西一号仓',
 9107, 'ZONE-NJ-PKG', NULL, NULL, NULL, 'FRONT_YARD_PARKING', 3, 1,
 '53FT', 0, 1, 'IDLE', NULL, NULL, NULL, NULL, 1, 8, 5, NULL, 0, NULL, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9229, 'PKG-NJ-F02', 'NJ 前院停车位1', 'PARKING', 9002, 'US-NJ-01', '新泽西一号仓',
 9107, 'ZONE-NJ-PKG', NULL, NULL, NULL, 'FRONT_YARD_PARKING', 3, 2,
 '53FT,40HQ', 0, 2, 'IDLE', NULL, NULL, NULL, NULL, 1, 9, 6, NULL, 0, NULL, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9230, 'CNT-NJ-Y01', 'NJ 海柜堆位Y01', 'CONTAINER_SLOT', 9002, 'US-NJ-01', '新泽西一号仓',
 9110, 'ZONE-NJ-YRD', NULL, NULL, NULL, 'BACK_YARD_PARKING', 4, 1,
 '40HQ', 0, 1, 'IDLE', NULL, NULL, NULL, NULL, 1, 10, 4, NULL, 0, NULL, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9231, 'CNT-NJ-Y02', 'NJ 海柜堆位Y02', 'CONTAINER_SLOT', 9002, 'US-NJ-01', '新泽西一号仓',
 9110, 'ZONE-NJ-YRD', NULL, NULL, NULL, 'BACK_YARD_PARKING', 4, 2,
 '40HQ,45HQ', 0, 1, 'OCCUPIED', 'CONTAINER', NULL, 'EGSU3344556', DATE_SUB(@now, INTERVAL 3 HOUR),
 1, 11, 4, NULL, 0, NULL, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9232, 'CNT-NJ-Y03', 'NJ 海柜堆位Y03', 'CONTAINER_SLOT', 9002, 'US-NJ-01', '新泽西一号仓',
 9110, 'ZONE-NJ-YRD', NULL, NULL, NULL, 'BACK_YARD_PARKING', 4, 3,
 '20GP', 0, 1, 'IDLE', NULL, NULL, NULL, NULL, 1, 12, 4, NULL, 0, NULL, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9233, 'TRL-NJ-Y01', 'NJ 车厢堆位T01', 'TRAILER_SLOT', 9002, 'US-NJ-01', '新泽西一号仓',
 9110, 'ZONE-NJ-YRD', NULL, NULL, NULL, 'BACK_YARD_PARKING', 4, 4,
 '53FT', 0, 1, 'IDLE', NULL, NULL, NULL, NULL, 1, 13, 4, NULL, 0, NULL, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9234, 'TRL-NJ-Y02', 'NJ 车厢堆位T02', 'TRAILER_SLOT', 9002, 'US-NJ-01', '新泽西一号仓',
 9110, 'ZONE-NJ-YRD', NULL, NULL, NULL, 'BACK_YARD_PARKING', 4, 5,
 '53FT,40HQ', 0, 1, 'IDLE', NULL, NULL, NULL, NULL, 1, 14, 4, NULL, 0, NULL, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9235, 'DOC-NJ-C01', 'NJ C区混合道口', 'DOCK', 9002, 'US-NJ-01', '新泽西一号仓',
 9105, 'ZONE-NJ-CNT', 9053, 'MIXED_DOCK', '混合道口', 'BACK_YARD_DOCK', 1, 5,
 '53FT,40HQ,20GP', 1, 1, 'IDLE', NULL, NULL, NULL, NULL, 1, 15, 2, NULL, 1, 2, 'NJ备用道口', @creator, @now, @creator, @now, b'0', @tenant_id),
(9236, 'PKG-NJ-F03', 'NJ 后院停车位', 'PARKING', 9002, 'US-NJ-01', '新泽西一号仓',
 9107, 'ZONE-NJ-PKG', NULL, NULL, NULL, 'BACK_YARD_PARKING', 3, 3,
 '53FT', 0, 1, 'CLOSED', NULL, NULL, NULL, NULL, 0, 16, 9, NULL, 0, NULL, '冬季关闭', @creator, @now, @creator, @now, b'0', @tenant_id),

-- ── 深圳 9003 CN-SZ-01：8 条 ──
(9237, 'DOC-SZ-A01', 'SZ 1号卸柜道口', 'DOCK', 9003, 'CN-SZ-01', '深圳保税仓',
 9108, 'ZONE-SZ-CNT', 9051, 'DEVANNING', '海柜拆柜', 'FRONT_YARD_DOCK', 1, 1,
 '40HQ,20GP', 1, 1, 'IDLE', NULL, NULL, NULL, NULL, 1, 1, 1, 'DEVANNING', 0, NULL, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9238, 'DOC-SZ-A02', 'SZ 2号卸柜道口', 'DOCK', 9003, 'CN-SZ-01', '深圳保税仓',
 9108, 'ZONE-SZ-CNT', 9051, 'DEVANNING', '海柜拆柜', 'FRONT_YARD_DOCK', 1, 2,
 '40HQ', 1, 1, 'OCCUPIED', 'CONTAINER', NULL, 'CMAU7788990', DATE_SUB(@now, INTERVAL 4 HOUR),
 1, 2, 1, 'DEVANNING', 0, NULL, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9239, 'DOC-SZ-A03', 'SZ 3号卸柜道口', 'DOCK', 9003, 'CN-SZ-01', '深圳保税仓',
 9108, 'ZONE-SZ-CNT', 9053, 'MIXED_DOCK', '混合道口', 'BACK_YARD_DOCK', 1, 3,
 '40HQ,20GP', 1, 1, 'IDLE', NULL, NULL, NULL, NULL, 1, 3, 2, NULL, 1, 2, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9240, 'DOC-SZ-B01', 'SZ 1号装车道口', 'DOCK', 9003, 'CN-SZ-01', '深圳保税仓',
 9108, 'ZONE-SZ-CNT', 9052, 'TRUCK_LOADING', '装车出库', 'BACK_YARD_DOCK', 2, 1,
 '40HQ', 1, 1, 'IDLE', NULL, NULL, NULL, NULL, 1, 4, 1, 'LOADING', 0, NULL, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9241, 'PKG-SZ-F01', 'SZ 前院等待位', 'WAITING_SLOT', 9003, 'CN-SZ-01', '深圳保税仓',
 9109, 'ZONE-SZ-PKG', NULL, NULL, NULL, 'FRONT_YARD_PARKING', 3, 1,
 '40HQ', 0, 1, 'IDLE', NULL, NULL, NULL, NULL, 1, 5, 5, NULL, 0, NULL, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9242, 'PKG-SZ-F02', 'SZ 前院停车位', 'PARKING', 9003, 'CN-SZ-01', '深圳保税仓',
 9109, 'ZONE-SZ-PKG', NULL, NULL, NULL, 'FRONT_YARD_PARKING', 3, 2,
 '40HQ,20GP', 0, 2, 'IDLE', NULL, NULL, NULL, NULL, 1, 6, 6, NULL, 0, NULL, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9243, 'CNT-SZ-Y01', 'SZ 海柜堆位Y01', 'CONTAINER_SLOT', 9003, 'CN-SZ-01', '深圳保税仓',
 9108, 'ZONE-SZ-CNT', NULL, NULL, NULL, 'BACK_YARD_PARKING', 4, 1,
 '40HQ', 0, 1, 'IDLE', NULL, NULL, NULL, NULL, 1, 7, 4, NULL, 0, NULL, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9244, 'CNT-SZ-Y02', 'SZ 海柜堆位Y02', 'CONTAINER_SLOT', 9003, 'CN-SZ-01', '深圳保税仓',
 9108, 'ZONE-SZ-CNT', NULL, NULL, NULL, 'BACK_YARD_PARKING', 4, 2,
 '20GP', 0, 1, 'RESERVED', 'CONTAINER', NULL, 'OOLU1122334', DATE_SUB(@now, INTERVAL 5 MINUTE),
 1, 8, 4, NULL, 0, NULL, NULL, @creator, @now, @creator, @now, b'0', @tenant_id)
ON DUPLICATE KEY UPDATE
    `dock_name` = VALUES(`dock_name`), `dock_status` = VALUES(`dock_status`),
    `occupied_object_type` = VALUES(`occupied_object_type`),
    `occupied_object_id` = VALUES(`occupied_object_id`),
    `occupied_object_no` = VALUES(`occupied_object_no`),
    `occupied_since` = VALUES(`occupied_since`),
    `enabled_flag` = VALUES(`enabled_flag`),
    `updater` = VALUES(`updater`), `update_time` = VALUES(`update_time`);

-- 回写仓库月台数量（mdm_warehouse.dock_count 字段存在时生效）
UPDATE `mdm_warehouse` w
SET w.`dock_count` = (
    SELECT COUNT(*) FROM `yard_dock` d
    WHERE d.`warehouse_id` = w.`id` AND d.`tenant_id` = @tenant_id
      AND d.`location_type` = 'DOCK' AND d.`deleted` = b'0' AND d.`enabled_flag` = 1
)
WHERE w.`id` IN (9001, 9002, 9003) AND w.`tenant_id` = @tenant_id;

-- ========== OMS：海柜与月台关联（依赖 oms-mock-data 海柜 21001~21003）==========
-- 1) 主表 Location（仅当存在 container_location 列时执行；legacy 全量表结构）
SET @has_container_location := (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_container_order' AND COLUMN_NAME = 'container_location'
);
SET @sql := IF(@has_container_location > 0,
    'UPDATE `oms_container_order` SET `container_location` = CASE `id`
        WHEN 21001 THEN ''CNT-LA-Y01''
        WHEN 21002 THEN ''DOC-LA-A02''
        WHEN 21003 THEN ''DOC-LA-A04''
        ELSE `container_location` END,
     `updater` = ''admin'', `update_time` = NOW()
     WHERE `id` IN (21001, 21002, 21003) AND `tenant_id` = 1',
    'SELECT ''skip container_location: column not exists'' AS msg'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 2) 运输子表 oms_container_transport_info（表存在时写入 dock_no 等）
SET @has_transport := (
    SELECT COUNT(*) FROM information_schema.TABLES
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_container_transport_info'
);
SET @sql := IF(@has_transport > 0,
    'INSERT INTO `oms_container_transport_info` (
        `container_order_id`, `vessel_name`, `voyage_no`,
        `appointment_time`, `eta_warehouse`, `required_warehouse_at`,
        `driver_name`, `truck_plate`, `chassis_no`, `dock_no`,
        `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`
    ) VALUES
    (21001, ''MSC OSCAR'', ''521W'', DATE_ADD(NOW(), INTERVAL 2 DAY), DATE_ADD(NOW(), INTERVAL 7 DAY), DATE_ADD(NOW(), INTERVAL 7 DAY),
     ''John Martinez'', ''CA-8K3921'', ''CHS-88210'', ''CNT-LA-Y01'', ''admin'', NOW(), ''admin'', NOW(), b''0'', 1),
    (21002, ''MAERSK SENTOSA'', ''339E'', DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY),
     ''Mike Chen'', ''CA-7H2109'', ''CHS-77102'', ''DOC-LA-A02'', ''admin'', NOW(), ''admin'', NOW(), b''0'', 1),
    (21003, ''EVER GOLDEN'', ''088E'', DATE_ADD(NOW(), INTERVAL 1 DAY), DATE_ADD(NOW(), INTERVAL 5 DAY), DATE_ADD(NOW(), INTERVAL 5 DAY),
     ''David Park'', ''CA-9M4455'', ''CHS-99331'', ''DOC-LA-A04'', ''admin'', NOW(), ''admin'', NOW(), b''0'', 1)
    ON DUPLICATE KEY UPDATE
        `dock_no` = VALUES(`dock_no`), `driver_name` = VALUES(`driver_name`),
        `truck_plate` = VALUES(`truck_plate`), `chassis_no` = VALUES(`chassis_no`),
        `updater` = VALUES(`updater`), `update_time` = NOW()',
    'SELECT ''skip oms_container_transport_info: table not exists'' AS msg'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @has_dock_id := (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_container_transport_info' AND COLUMN_NAME = 'dock_id'
);
SET @sql := IF(@has_transport > 0 AND @has_dock_id > 0,
    'UPDATE `oms_container_transport_info` SET `dock_id` = CASE `container_order_id`
        WHEN 21001 THEN 9215 WHEN 21002 THEN 9202 WHEN 21003 THEN 9204 ELSE `dock_id` END,
     `updater` = ''admin'', `update_time` = NOW()
     WHERE `container_order_id` IN (21001, 21002, 21003)',
    'SELECT ''skip dock_id: column not exists'' AS msg'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 3) v11 拆柜运输字段 dock_no（oms_container_transport_info 已含 dock_assigned_at 时补充）
SET @has_dock_assigned := (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'oms_container_transport_info' AND COLUMN_NAME = 'dock_assigned_at'
);
SET @sql := IF(@has_transport > 0 AND @has_dock_assigned > 0,
    'UPDATE `oms_container_transport_info` SET `dock_assigned_at` = CASE `container_order_id`
        WHEN 21002 THEN DATE_SUB(NOW(), INTERVAL 2 HOUR)
        WHEN 21003 THEN DATE_SUB(NOW(), INTERVAL 30 MINUTE)
        ELSE `dock_assigned_at` END
     WHERE `container_order_id` IN (21002, 21003)',
    'SELECT ''skip dock_assigned_at'' AS msg'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ========== 自检 ==========
SELECT 'yard_zone' AS tbl, COUNT(*) AS cnt FROM `yard_zone` WHERE `tenant_id` = @tenant_id AND `id` BETWEEN 9101 AND 9110
UNION ALL
SELECT 'yard_dock', COUNT(*) FROM `yard_dock` WHERE `tenant_id` = @tenant_id AND `id` BETWEEN 9201 AND 9399
UNION ALL
SELECT 'yard_dock DOCK', COUNT(*) FROM `yard_dock` WHERE `tenant_id` = @tenant_id AND `location_type` = 'DOCK' AND `id` BETWEEN 9201 AND 9399;
