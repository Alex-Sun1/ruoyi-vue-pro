-- 【已过时】本文件使用旧表名 cargo_order / biz_relation，与当前 Java 代码不一致。
-- 请改用：sql/mysql/oms-business-mock-data.sql（海柜+货物订单+出单工作台+预出单+出库单）
--
-- OMS 最小联调数据（tenant_id=1，可重复执行）
-- 前置：base-mock-data.sql（客户/仓库）、oms-tables.sql、oms-tables-v11-alter.sql、
--       oms-container-create-alter.sql、oms-container-lifecycle-alter.sql、oms-cargo-order-transfer-platform-alter.sql
-- 检查：SELECT id, lifecycle_phase, accepted_at FROM oms_container_order WHERE id BETWEEN 21001 AND 21003;

SET NAMES utf8mb4;

INSERT INTO biz_root (id, root_no, biz_type, status, creator, create_time, updater, update_time, deleted, tenant_id)
VALUES
    (20001, 'BR-20260518-100001', 'CARGO_ORDER', 'ACTIVE', '1', NOW(), '1', NOW(), b'0', 1),
    (20002, 'BR-20260518-100002', 'CARGO_ORDER', 'ACTIVE', '1', NOW(), '1', NOW(), b'0', 1),
    (20003, 'BR-20260518-100003', 'CARGO_ORDER', 'ACTIVE', '1', NOW(), '1', NOW(), b'0', 1)
ON DUPLICATE KEY UPDATE
    root_no = VALUES(root_no), biz_type = VALUES(biz_type), status = VALUES(status),
    updater = VALUES(updater), update_time = NOW(), deleted = VALUES(deleted);

INSERT INTO oms_container_order (id, work_order_no, container_no, bl_no, customer_id, warehouse_id, container_type, transport_mode, eta,
                                 pickup_lfd, return_lfd, container_status, lifecycle_phase, lifecycle_phase_override,
                                 accepted_at, accepted_by, unstuff_status, exam_status, is_on_hold, calc_risk_level,
                                 order_total_count, order_completed_count, creator, create_time, updater, update_time,
                                 deleted, tenant_id)
VALUES
    -- 待受理：可测 POST /oms/container/accept → 柜内 PENDING_UNSTUFF → PENDING_DISPATCH
    (21001, 'WKSC-20260518-100001', 'MSCU1234567', 'BL-OMS-001', 1001, 9001, '40HQ', 'SEA_FCL',
     DATE_ADD(NOW(), INTERVAL 7 DAY), DATE_ADD(NOW(), INTERVAL 10 DAY), DATE_ADD(NOW(), INTERVAL 14 DAY),
     'SAILING', 'PENDING_ACCEPT', NULL, NULL, NULL,
     'NOT_CREATED', 'NONE', b'0', 'LOW', 1, 0, '1', NOW(), '1', NOW(), b'0', 1),
    -- 已受理、拆柜中：phase-counts unstuffing / 柜内已 PENDING_DISPATCH
    (21002, 'WKSC-20260518-100002', 'MSCU7654321', 'BL-OMS-002', 1001, 9002, '20GP', 'SEA_FCL',
     DATE_ADD(NOW(), INTERVAL 3 DAY), DATE_ADD(NOW(), INTERVAL 1 DAY), DATE_ADD(NOW(), INTERVAL 7 DAY),
     'UNSTUFFING', 'UNSTUFFING', NULL, DATE_SUB(NOW(), INTERVAL 1 DAY), 1,
     'PROCESSING', 'NONE', b'0', 'MEDIUM', 1, 0, '1', NOW(), '1', NOW(), b'0', 1),
    -- 提柜紧急 + 在途：phase-counts pickup_urgent / sailing（已受理）
    (21003, 'WKSC-20260518-100003', 'MSCU9876543', 'BL-OMS-003', 1001, 9001, '40HQ', 'SEA_FCL',
     DATE_ADD(NOW(), INTERVAL 5 DAY), DATE_ADD(NOW(), INTERVAL 1 DAY), DATE_ADD(NOW(), INTERVAL 10 DAY),
     'ARRIVED', 'PICKUP_URGENT', NULL, DATE_SUB(NOW(), INTERVAL 2 HOUR), 1,
     'NOT_CREATED', 'NONE', b'0', 'HIGH', 1, 0, '1', NOW(), '1', NOW(), b'0', 1)
ON DUPLICATE KEY UPDATE
    work_order_no = VALUES(work_order_no), container_no = VALUES(container_no), container_status = VALUES(container_status),
    lifecycle_phase = VALUES(lifecycle_phase), lifecycle_phase_override = VALUES(lifecycle_phase_override),
    accepted_at = VALUES(accepted_at), accepted_by = VALUES(accepted_by),
    pickup_lfd = VALUES(pickup_lfd), unstuff_status = VALUES(unstuff_status),
    transport_mode = VALUES(transport_mode), exam_status = VALUES(exam_status),
    updater = VALUES(updater), update_time = NOW();

INSERT INTO cargo_order (id, order_no, biz_root_id, warehouse_id, warehouse_code, customer_id, platform, biz_type,
                         lfd, dw_date, dw_start, dw_end, wms_actual_ctns, gross_weight_lbs, gross_weight_kg, cbm,
                         is_transfer, transfer_platform_address_id, transfer_platform_address_code, transfer_platform_address_name,
                         fulfillment_status, calc_risk_level, current_route_node, remark,
                         creator, create_time, updater, update_time, deleted, tenant_id)
VALUES
    (22001, 'CO-20260518-100001', 20001, 9001, 'LAX01', 1001, 'AMAZON_FBA', 'TRUCK_DELIVERY',
     DATE_ADD(CURDATE(), INTERVAL 5 DAY), DATE_ADD(CURDATE(), INTERVAL 3 DAY), '08:00', '14:00',
     48, 2646.00, 1200.00, 8.50, b'0', NULL, NULL, NULL,
     'PENDING_UNSTUFF', 'LOW', 'UNSTUFF', 'mock-1',
     '1', NOW(), '1', NOW(), b'0', 1),
    (22002, 'CO-20260518-100002', 20002, 9002, 'NYC01', 1001, 'AMAZON_FBA', 'TRUCK_DELIVERY',
     DATE_ADD(CURDATE(), INTERVAL 2 DAY), DATE_ADD(CURDATE(), INTERVAL 1 DAY), '09:00', '17:00',
     24, 1320.00, 600.00, 4.20, b'1', 9001, 'ONT8', 'Amazon ONT8 - Ontario',
     'PENDING_DISPATCH', 'HIGH', 'PENDING_DISPATCH', 'mock-2 转仓联调',
     '1', NOW(), '1', NOW(), b'0', 1),
    (22003, 'CO-20260518-100003', 20003, 9001, 'LAX01', 1001, 'AMAZON_FBA', 'TRUCK_DELIVERY',
     DATE_ADD(CURDATE(), INTERVAL 4 DAY), DATE_ADD(CURDATE(), INTERVAL 2 DAY), '10:00', '16:00',
     36, 1980.00, 900.00, 6.00, b'0', NULL, NULL, NULL,
     'PENDING_DISPATCH', 'MEDIUM', 'PENDING_DISPATCH', 'mock-3',
     '1', NOW(), '1', NOW(), b'0', 1)
ON DUPLICATE KEY UPDATE
    warehouse_code = VALUES(warehouse_code), platform = VALUES(platform), biz_type = VALUES(biz_type),
    is_transfer = VALUES(is_transfer), transfer_platform_address_id = VALUES(transfer_platform_address_id),
    transfer_platform_address_code = VALUES(transfer_platform_address_code),
    transfer_platform_address_name = VALUES(transfer_platform_address_name),
    lfd = VALUES(lfd), dw_date = VALUES(dw_date), dw_start = VALUES(dw_start), dw_end = VALUES(dw_end),
    wms_actual_ctns = VALUES(wms_actual_ctns), gross_weight_lbs = VALUES(gross_weight_lbs),
    fulfillment_status = VALUES(fulfillment_status), calc_risk_level = VALUES(calc_risk_level),
    current_route_node = VALUES(current_route_node), updater = VALUES(updater), update_time = NOW();

INSERT INTO biz_relation (id, relation_type, cargo_order_id, container_order_id, creator, create_time, updater, update_time, deleted, tenant_id)
VALUES
    (23001, 'LOADED_IN', 22001, 21001, '1', NOW(), '1', NOW(), b'0', 1),
    (23002, 'LOADED_IN', 22002, 21002, '1', NOW(), '1', NOW(), b'0', 1),
    (23003, 'LOADED_IN', 22003, 21003, '1', NOW(), '1', NOW(), b'0', 1)
ON DUPLICATE KEY UPDATE
    relation_type = VALUES(relation_type), updater = VALUES(updater), update_time = NOW();

INSERT INTO biz_event (id, event_id, event_code, biz_root_id, container_order_id, payload, status, retry_count, error_message,
                       creator, create_time, updater, update_time, deleted, tenant_id)
VALUES
    (24001, 'EVT-OMS-001', 'CONTAINER_CREATED', 20001, 21001, '{"source":"mock"}', 'SUCCESS', 0, NULL,
     '1', NOW(), '1', NOW(), b'0', 1),
    (24002, 'EVT-OMS-002', 'CONTAINER_ACCEPTED', 20002, 21002, '{"source":"mock"}', 'SUCCESS', 0, NULL,
     '1', NOW(), '1', NOW(), b'0', 1),
    (24003, 'EVT-OMS-003', 'UNSTUFF_ORDER_COMPLETED', 20002, 21002, '{"cargoOrderId":22002}', 'FAILED', 1, 'mock failed',
     '1', NOW(), '1', NOW(), b'0', 1)
ON DUPLICATE KEY UPDATE
    status = VALUES(status), payload = VALUES(payload), retry_count = VALUES(retry_count),
    error_message = VALUES(error_message), updater = VALUES(updater), update_time = NOW();

INSERT INTO biz_timeline (id, biz_root_id, event_code, event_time, title, content, operator_id, operator_name, creator, create_time,
                          updater, update_time, deleted, tenant_id)
VALUES
    (25001, 20001, 'CONTAINER_CREATED', NOW(), '创建海柜', 'mock timeline', 1, 'admin', '1', NOW(), '1', NOW(), b'0', 1),
    (25002, 20002, 'CONTAINER_ACCEPTED', DATE_SUB(NOW(), INTERVAL 1 DAY), '海柜受理', 'mock accept', 1, 'admin', '1', NOW(), '1', NOW(), b'0', 1),
    (25003, 20002, 'UNSTUFF_ORDER_COMPLETED', NOW(), '拆柜完成', 'mock timeline', 1, 'admin', '1', NOW(), '1', NOW(), b'0', 1)
ON DUPLICATE KEY UPDATE
    title = VALUES(title), content = VALUES(content), updater = VALUES(updater), update_time = NOW();

INSERT INTO oms_alert_rule (id, rule_code, rule_name, enabled, config_json, creator, create_time, updater, update_time, deleted, tenant_id)
VALUES
    (26001, 'ETA_DELAY', 'ETA 延迟预警', b'1', '{"hours":24}', '1', NOW(), '1', NOW(), b'0', 1)
ON DUPLICATE KEY UPDATE
    rule_name = VALUES(rule_name), enabled = VALUES(enabled), config_json = VALUES(config_json), update_time = NOW();

INSERT INTO oms_alert_instance (id, rule_code, object_type, object_id, warehouse_id, severity, status, message, snooze_until, resolved_time,
                                creator, create_time, updater, update_time, deleted, tenant_id)
VALUES
    (26101, 'ETA_DELAY', 'CONTAINER', 21002, 9002, 'WARN', 'OPEN', 'ETA 超时', NULL, NULL, '1', NOW(), '1', NOW(), b'0', 1)
ON DUPLICATE KEY UPDATE
    status = VALUES(status), message = VALUES(message), updater = VALUES(updater), update_time = NOW();

INSERT INTO oms_fee (id, container_order_id, warehouse_id, fee_type, amount, currency, fee_status, creator, create_time, updater, update_time, deleted, tenant_id)
VALUES
    (27001, 21001, 9001, 'UNSTUFF', 100.00, 'USD', 'PENDING', '1', NOW(), '1', NOW(), b'0', 1)
ON DUPLICATE KEY UPDATE
    amount = VALUES(amount), fee_status = VALUES(fee_status), updater = VALUES(updater), update_time = NOW();

INSERT INTO oms_freeze_request (id, container_order_id, warehouse_id, reason, status, creator, create_time, updater, update_time, deleted, tenant_id)
VALUES
    (27101, 21001, 9001, 'mock freeze request', 'PENDING', '1', NOW(), '1', NOW(), b'0', 1)
ON DUPLICATE KEY UPDATE
    reason = VALUES(reason), status = VALUES(status), updater = VALUES(updater), update_time = NOW();

INSERT INTO shipment (id, cargo_order_id, shipment_no, carrier, creator, create_time, updater, update_time, deleted, tenant_id)
VALUES
    (28001, 22001, 'SHP-22001-01', 'UPS', '1', NOW(), '1', NOW(), b'0', 1),
    (28002, 22002, 'SHP-22002-01', 'FEDEX', '1', NOW(), '1', NOW(), b'0', 1),
    (28003, 22003, 'SHP-22003-01', 'UPS', '1', NOW(), '1', NOW(), b'0', 1)
ON DUPLICATE KEY UPDATE
    shipment_no = VALUES(shipment_no), carrier = VALUES(carrier), updater = VALUES(updater), update_time = NOW();

INSERT INTO cargo_order_item (id, cargo_order_id, sku_code, qty, creator, create_time, updater, update_time, deleted, tenant_id)
VALUES
    (29001, 22001, 'SKU-PHONE-001', 48, '1', NOW(), '1', NOW(), b'0', 1),
    (29002, 22001, 'SKU-PHONE-002', 12, '1', NOW(), '1', NOW(), b'0', 1),
    (29003, 22002, 'SKU-HOME-001', 24, '1', NOW(), '1', NOW(), b'0', 1)
ON DUPLICATE KEY UPDATE
    sku_code = VALUES(sku_code), qty = VALUES(qty), updater = VALUES(updater), update_time = NOW();

INSERT INTO oms_order_route_node (id, cargo_order_id, node_code, node_name, node_time, sort_order, status,
                                  creator, create_time, updater, update_time, deleted, tenant_id)
VALUES
    (30001, 22001, 'ORDER_CREATED', '订单创建', NOW(), 10, 'done', '1', NOW(), '1', NOW(), b'0', 1),
    (30002, 22001, 'UNSTUFF', '拆柜', NULL, 20, 'current', '1', NOW(), '1', NOW(), b'0', 1),
    (30003, 22001, 'PENDING_DISPATCH', '待出单', NULL, 30, 'pending', '1', NOW(), '1', NOW(), b'0', 1),
    (30011, 22002, 'ORDER_CREATED', '订单创建', NOW(), 10, 'done', '1', NOW(), '1', NOW(), b'0', 1),
    (30012, 22002, 'UNSTUFF', '拆柜', NOW(), 20, 'done', '1', NOW(), '1', NOW(), b'0', 1),
    (30013, 22002, 'PENDING_DISPATCH', '待出单', NOW(), 30, 'current', '1', NOW(), '1', NOW(), b'0', 1),
    (30021, 22003, 'ORDER_CREATED', '订单创建', NOW(), 10, 'done', '1', NOW(), '1', NOW(), b'0', 1),
    (30022, 22003, 'PENDING_DISPATCH', '待出单', NOW(), 30, 'current', '1', NOW(), '1', NOW(), b'0', 1)
ON DUPLICATE KEY UPDATE
    node_name = VALUES(node_name), node_time = VALUES(node_time), status = VALUES(status),
    sort_order = VALUES(sort_order), updater = VALUES(updater), update_time = NOW();
