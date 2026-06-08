-- 业务类型标准数据：卡车派送 / 客户自提 / 快递派送 / LTL / 大货中转 / 一件代发 / 仓库物资
-- 可重复执行；旧 FBA/FBM 快递口径统一收敛到当前 7 类。

INSERT INTO `base_business_type`
(id, tenant_id, business_type_code, business_type_name, business_category, operation_flow_type,
 receive_required, inbound_required, putaway_required, storage_required, picking_required, outbound_required,
 delivery_required, appointment_required, vas_supported, sorting_strategy, sorting_field,
 sort_order, status, remark, create_dept, create_by, create_time, update_by, update_time, del_flag)
VALUES
(5002001, '000000', 'TRUCK_DELIVERY', '卡车派送', 'TRANSPORT', 'OUTBOUND',
 '1','0','0','0','1','1','1','1','0','FIELD_BASED','warehouse_code',
 1, '0', '需要维护详细派送地址，可按平台仓/私仓/商业地址区分', 103, 1, NOW(), 1, NOW(), 0),
(5002002, '000000', 'EXPRESS_DELIVERY', '快递派送', 'TRANSPORT', 'OUTBOUND',
 '1','0','0','0','1','1','1','0','0','NONE',NULL,
 2, '0', '快递商必填，追踪号可后补', 103, 1, NOW(), 1, NOW(), 0),
(5002003, '000000', 'CUSTOMER_PICKUP', '客户自提', 'TRANSPORT', 'OUTBOUND',
 '1','0','0','0','1','1','0','0','0','NONE',NULL,
 3, '0', '客户自行提货，地址非必填', 103, 1, NOW(), 1, NOW(), 0),
(5002004, '000000', 'LTL', 'LTL', 'TRANSPORT', 'OUTBOUND',
 '1','0','0','0','1','1','1','0','0','NONE',NULL,
 4, '0', '零担派送，地址信息可后续由调度补充', 103, 1, NOW(), 1, NOW(), 0),
(5002005, '000000', 'BULK_TRANSFER', '大货中转', 'WAREHOUSE', 'INBOUND_OUTBOUND',
 '0','1','1','1','1','1','0','0','0','FIELD_BASED','warehouse_code',
 5, '0', NULL, 103, 1, NOW(), 1, NOW(), 0),
(5002006, '000000', 'DROPSHIP', '一件代发', 'WAREHOUSE', 'OUTBOUND',
 '1','0','0','1','1','1','1','0','1','FIELD_BASED','sku',
 6, '0', NULL, 103, 1, NOW(), 1, NOW(), 0),
(5002007, '000000', 'WAREHOUSE_SUPPLIES', '仓库物资', 'WAREHOUSE', 'SERVICE',
 '0','1','1','1','0','0','0','0','0','NONE',NULL,
 7, '0', '仓库耗材、物资类内部业务', 103, 1, NOW(), 1, NOW(), 0)
ON DUPLICATE KEY UPDATE
  business_type_code = VALUES(business_type_code),
  business_type_name = VALUES(business_type_name),
  business_category = VALUES(business_category),
  operation_flow_type = VALUES(operation_flow_type),
  receive_required = VALUES(receive_required),
  inbound_required = VALUES(inbound_required),
  putaway_required = VALUES(putaway_required),
  storage_required = VALUES(storage_required),
  picking_required = VALUES(picking_required),
  outbound_required = VALUES(outbound_required),
  delivery_required = VALUES(delivery_required),
  appointment_required = VALUES(appointment_required),
  vas_supported = VALUES(vas_supported),
  sorting_strategy = VALUES(sorting_strategy),
  sorting_field = VALUES(sorting_field),
  sort_order = VALUES(sort_order),
  status = VALUES(status),
  remark = VALUES(remark),
  update_by = 1,
  update_time = NOW(),
  del_flag = 0;

UPDATE `oms_cargo_order`
SET `business_type_name` = CASE `business_type_id`
  WHEN 5002001 THEN '卡车派送'
  WHEN 5002002 THEN '快递派送'
  WHEN 5002003 THEN '客户自提'
  WHEN 5002004 THEN 'LTL'
  WHEN 5002005 THEN '大货中转'
  WHEN 5002006 THEN '一件代发'
  WHEN 5002007 THEN '仓库物资'
  ELSE `business_type_name`
END
WHERE `business_type_id` IN (5002001,5002002,5002003,5002004,5002005,5002006,5002007);

-- oms_container_order 当前仅维护 business_type_id，页面展示通过业务类型基础资料映射名称。
