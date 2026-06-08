-- 业务类型 + 分组规则字段元数据 + 分组规则（来源：overallSystem/docs/prd/all.sql）
-- 适配当前 yudao 库：tenant_id=1，仓库 9001=洛杉矶一号仓 / 9002=新泽西一号仓
-- 可重复执行（UPSERT / NOT EXISTS）
SET NAMES utf8mb4;

SET @tenant_id = 1;
SET @creator = 'admin';
SET @now = NOW();
SET @wh_la = 9001;
SET @wh_nj = 9002;

-- =============================================================================
-- 0. 修复历史误导入（参考库 tenant_id='000000' 写入 bigint 列会变成 0，登录租户 1 查不到）
-- =============================================================================
UPDATE `base_business_type`
SET `tenant_id` = @tenant_id,
    `deleted` = b'0',
    `status` = 0,
    `updater` = @creator,
    `update_time` = @now
WHERE `id` BETWEEN 5002001 AND 5002007
  AND (`tenant_id` = 0 OR `tenant_id` IS NULL);

-- =============================================================================
-- 1. 业务类型 base_business_type（7 条标准数据）
-- =============================================================================
INSERT INTO `base_business_type` (
    `id`, `business_type_code`, `business_type_name`, `business_category`, `operation_flow_type`,
    `receive_required`, `inbound_required`, `putaway_required`, `storage_required`,
    `picking_required`, `outbound_required`, `delivery_required`, `appointment_required`, `vas_supported`,
    `sorting_strategy`, `sorting_field`, `sort_order`, `status`, `remark`,
    `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`
) VALUES
(5002001, 'TRUCK_DELIVERY', '卡车派送', 'TRANSPORT', 'OUTBOUND',
 b'1', b'0', b'0', b'0', b'1', b'1', b'1', b'1', b'0', 'FIELD_BASED', 'warehouse_code', 1, 0,
 '需要维护详细派送地址，可按平台仓/私仓/商业地址区分', @creator, @now, @creator, @now, b'0', @tenant_id),
(5002002, 'EXPRESS_DELIVERY', '快递派送', 'TRANSPORT', 'OUTBOUND',
 b'1', b'0', b'0', b'0', b'1', b'1', b'1', b'0', b'0', 'NONE', NULL, 2, 0,
 '快递商必填，追踪号可后补', @creator, @now, @creator, @now, b'0', @tenant_id),
(5002003, 'CUSTOMER_PICKUP', '客户自提', 'TRANSPORT', 'OUTBOUND',
 b'1', b'0', b'0', b'0', b'1', b'1', b'0', b'0', b'0', 'NONE', NULL, 3, 0,
 '客户自行提货，地址非必填', @creator, @now, @creator, @now, b'0', @tenant_id),
(5002004, 'LTL', 'LTL', 'TRANSPORT', 'OUTBOUND',
 b'1', b'0', b'0', b'0', b'1', b'1', b'1', b'0', b'0', 'NONE', NULL, 4, 0,
 '零担派送，地址信息可后续由调度补充', @creator, @now, @creator, @now, b'0', @tenant_id),
(5002005, 'BULK_TRANSFER', '大货中转', 'WAREHOUSE', 'INBOUND_OUTBOUND',
 b'0', b'1', b'1', b'1', b'1', b'1', b'0', b'0', b'0', 'FIELD_BASED', 'warehouse_code', 5, 0,
 NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(5002006, 'DROPSHIP', '一件代发', 'WAREHOUSE', 'OUTBOUND',
 b'1', b'0', b'0', b'1', b'1', b'1', b'1', b'0', b'1', 'FIELD_BASED', 'sku', 6, 0,
 NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(5002007, 'WAREHOUSE_SUPPLIES', '仓库物资', 'WAREHOUSE', 'SERVICE',
 b'0', b'1', b'1', b'1', b'0', b'0', b'0', b'0', b'0', 'NONE', NULL, 7, 0,
 '仓库耗材、物资类内部业务', @creator, @now, @creator, @now, b'0', @tenant_id)
ON DUPLICATE KEY UPDATE
    `business_type_name` = VALUES(`business_type_name`),
    `business_category` = VALUES(`business_category`),
    `operation_flow_type` = VALUES(`operation_flow_type`),
    `receive_required` = VALUES(`receive_required`),
    `inbound_required` = VALUES(`inbound_required`),
    `putaway_required` = VALUES(`putaway_required`),
    `storage_required` = VALUES(`storage_required`),
    `picking_required` = VALUES(`picking_required`),
    `outbound_required` = VALUES(`outbound_required`),
    `delivery_required` = VALUES(`delivery_required`),
    `appointment_required` = VALUES(`appointment_required`),
    `vas_supported` = VALUES(`vas_supported`),
    `sorting_strategy` = VALUES(`sorting_strategy`),
    `sorting_field` = VALUES(`sorting_field`),
    `sort_order` = VALUES(`sort_order`),
    `status` = VALUES(`status`),
    `remark` = VALUES(`remark`),
    `updater` = VALUES(`updater`),
    `update_time` = VALUES(`update_time`),
    `deleted` = b'0';

-- =============================================================================
-- 2. 分组字段元数据 oms_cargo_grouping_field_meta（14 条）
-- =============================================================================
INSERT INTO `oms_cargo_grouping_field_meta` (
    `id`, `table_alias`, `field_name`, `display_name`, `data_type`, `enum_code`, `ref_type`,
    `can_be_condition`, `can_be_group_key`, `sort_order`, `enabled`, `remark`,
    `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`
) VALUES
(9301001, 'order', 'order_no', '订单号', 'STRING', NULL, NULL, 0, 1, 10, 1, '货物订单号', @creator, @now, @creator, @now, b'0', @tenant_id),
(9301002, 'order', 'order_type', '业务类型/派送方式', 'ENUM', 'base_business_type', NULL, 1, 1, 20, 1, '货物订单业务类型/派送方式', @creator, @now, @creator, @now, b'0', @tenant_id),
(9301003, 'order', 'address_type', '地址类型', 'ENUM', 'oms_address_type', NULL, 1, 1, 30, 1, '平台仓、私仓、商业地址', @creator, @now, @creator, @now, b'0', @tenant_id),
(9301010, 'order', 'platform_id', '平台', 'REF', NULL, 'base_platform', 1, 1, 40, 1, '目的地平台基础资料', @creator, @now, @creator, @now, b'0', @tenant_id),
(9301004, 'order', 'platform_code', '仓库代码', 'REF', NULL, 'base_platform_address', 1, 1, 45, 1, '目的地平台仓代码', @creator, @now, @creator, @now, b'0', @tenant_id),
(9301011, 'order', 'parcel_carrier_name', '快递商', 'ENUM', 'oms_parcel_carrier', NULL, 1, 1, 47, 1, '快递派送承运商字典', @creator, @now, @creator, @now, b'0', @tenant_id),
(9301005, 'order', 'customer_id', '客户', 'REF', NULL, 'base_customer', 1, 0, 50, 1, '客户ID', @creator, @now, @creator, @now, b'0', @tenant_id),
(9301006, 'order', 'channel_id', '渠道', 'REF', NULL, 'base_channel', 1, 0, 60, 1, '业务渠道', @creator, @now, @creator, @now, b'0', @tenant_id),
(9301007, 'shipment', 'shipment_no', '货件编号', 'STRING', NULL, NULL, 0, 1, 70, 1, '货件编号', @creator, @now, @creator, @now, b'0', @tenant_id),
(9301008, 'shipment', 'warehouse_code', '货件仓库代码', 'STRING', NULL, NULL, 0, 1, 80, 1, '货件分组仓库代码，当前从订单仓库代码兜底', @creator, @now, @creator, @now, b'0', @tenant_id),
(9301009, 'shipment', 'shipment_type', '货件类型', 'ENUM', 'oms_shipment_type', NULL, 0, 1, 90, 1, '预留货件类型', @creator, @now, @creator, @now, b'0', @tenant_id),
(9301012, 'order', 'hold_flag', 'HOLD标记', 'ENUM', 'yes_no_int', NULL, 1, 1, 90, 1, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9301013, 'order', 'transfer_flag', '是否转仓', 'ENUM', 'yes_no_int', NULL, 1, 0, 91, 1, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9301014, 'order', 'transfer_warehouse_code', '转仓地址', 'STRING', NULL, NULL, 0, 1, 92, 1, NULL, @creator, @now, @creator, @now, b'0', @tenant_id)
ON DUPLICATE KEY UPDATE
    `display_name` = VALUES(`display_name`),
    `data_type` = VALUES(`data_type`),
    `enum_code` = VALUES(`enum_code`),
    `ref_type` = VALUES(`ref_type`),
    `can_be_condition` = VALUES(`can_be_condition`),
    `can_be_group_key` = VALUES(`can_be_group_key`),
    `sort_order` = VALUES(`sort_order`),
    `enabled` = VALUES(`enabled`),
    `remark` = VALUES(`remark`),
    `updater` = VALUES(`updater`),
    `update_time` = VALUES(`update_time`),
    `deleted` = b'0';

-- yes_no_int 字典（hold_flag / transfer_flag 条件用）
INSERT INTO `system_dict_type` (`id`, `name`, `type`, `status`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
SELECT 7229, '是否(整型)', 'yes_no_int', 0, '0=否 1=是', @creator, @now, @creator, @now, b'0'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `system_dict_type` WHERE `type` = 'yes_no_int' AND `deleted` = b'0');

INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
SELECT 721261, 1, '否', '0', 'yes_no_int', 0, 'default', @creator, @now, @creator, @now, b'0'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `system_dict_data` WHERE `dict_type` = 'yes_no_int' AND `value` = '0' AND `deleted` = b'0');

INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
SELECT 721262, 2, '是', '1', 'yes_no_int', 0, 'success', @creator, @now, @creator, @now, b'0'
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `system_dict_data` WHERE `dict_type` = 'yes_no_int' AND `value` = '1' AND `deleted` = b'0');

-- =============================================================================
-- 2b. 分组规则表结构兼容（旧版 warehouse_id NOT NULL）
-- =============================================================================
SET @schema_name := DATABASE();

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_cargo_grouping_rule' AND COLUMN_NAME = 'warehouse_ids') = 0,
  'ALTER TABLE `oms_cargo_grouping_rule` ADD COLUMN `warehouse_ids` json NULL COMMENT ''仓库ID列表JSON'' AFTER `warehouse_name`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @schema_name AND TABLE_NAME = 'oms_cargo_grouping_rule' AND COLUMN_NAME = 'warehouse_id') > 0,
  'ALTER TABLE `oms_cargo_grouping_rule` MODIFY COLUMN `warehouse_id` bigint NULL DEFAULT NULL COMMENT ''仓库ID(legacy)''',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- =============================================================================
-- 3. 分组规则 oms_cargo_grouping_rule（对齐 all.sql 8 条 LA 规则 + 美东仓镜像）
--    参考库仓库 4001001 → 当前库 9001（洛杉矶一号仓）、9002（新泽西一号仓）
-- =============================================================================
INSERT INTO `oms_cargo_grouping_rule` (
    `id`, `warehouse_id`, `warehouse_name`, `warehouse_ids`, `rule_name`,
    `condition_config`, `group_key_config`,
    `priority`, `is_default`, `status`, `version`, `remark`,
    `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`
) VALUES
-- 洛杉矶 9001
(9303001, @wh_la, '洛杉矶一号仓', '["9001"]', 'LA-平台仓分组',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[{"op":"EQ","field":"order.order_type","value":"卡车派送"},{"op":"EQ","field":"order.address_type","value":"PLATFORM_WH"}]}',
 '{"fields":[{"field":"order.platform_id"},{"field":"order.platform_code"}],"separator":"-"}',
 10, 0, 'enabled', 1, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9303002, @wh_la, '洛杉矶一号仓', '["9001"]', 'LA仓-商业地址',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[{"op":"EQ","field":"order.order_type","value":"卡车派送"},{"op":"EQ","field":"order.address_type","value":"COMMERCIAL"}]}',
 '{"fields":[{"field":"order.address_type"},{"field":"order.order_no"}],"separator":"-"}',
 9, 0, 'enabled', 0, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9303003, @wh_la, '洛杉矶一号仓', '["9001"]', 'LA仓-私人地址',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[{"op":"EQ","field":"order.order_type","value":"卡车派送"},{"op":"EQ","field":"order.address_type","value":"PRIVATE"}]}',
 '{"fields":[{"field":"order.address_type"},{"field":"order.order_no"}],"separator":"-"}',
 9, 0, 'enabled', 0, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9303004, @wh_la, '洛杉矶一号仓', '["9001"]', 'LA仓-快递派送',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[{"op":"EQ","field":"order.order_type","value":"快递派送"}]}',
 '{"fields":[{"field":"order.parcel_carrier_name"}],"separator":"-"}',
 8, 0, 'enabled', 0, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9303005, @wh_la, '洛杉矶一号仓', '["9001"]', 'LA仓-客户自提',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[{"op":"EQ","field":"order.order_type","value":"客户自提"}]}',
 '{"fields":[{"field":"order.order_type"},{"field":"order.order_no"}],"separator":"-"}',
 7, 0, 'enabled', 0, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9303006, @wh_la, '洛杉矶一号仓', '["9001"]', 'LA-大货中转',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[{"op":"EQ","field":"order.order_type","value":"大货中转"}]}',
 '{"fields":[{"field":"order.order_type"},{"field":"order.order_no"}],"separator":"-"}',
 6, 0, 'enabled', 1, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9303007, @wh_la, '洛杉矶一号仓', '["9001"]', 'LA-一件代发',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[{"op":"EQ","field":"order.order_type","value":"一件代发"}]}',
 '{"fields":[{"field":"order.order_type"},{"field":"shipment.shipment_no"}],"separator":"-"}',
 6, 0, 'enabled', 1, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9303008, @wh_la, '洛杉矶一号仓', '["9001"]', 'LA仓-默认规则',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[]}',
 '{"fields":[{"field":"order.customer_id"},{"field":"order.order_type"}],"separator":"-"}',
 0, 1, 'enabled', 0, '兜底规则', @creator, @now, @creator, @now, b'0', @tenant_id),
-- 新泽西 9002（演示数据主仓，规则与 LA 镜像）
(9303101, @wh_nj, '新泽西一号仓', '["9002"]', 'NJ-平台仓分组',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[{"op":"EQ","field":"order.order_type","value":"卡车派送"},{"op":"EQ","field":"order.address_type","value":"PLATFORM_WH"}]}',
 '{"fields":[{"field":"order.platform_id"},{"field":"order.platform_code"}],"separator":"-"}',
 10, 0, 'enabled', 1, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9303102, @wh_nj, '新泽西一号仓', '["9002"]', 'NJ仓-商业地址',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[{"op":"EQ","field":"order.order_type","value":"卡车派送"},{"op":"EQ","field":"order.address_type","value":"COMMERCIAL"}]}',
 '{"fields":[{"field":"order.address_type"},{"field":"order.order_no"}],"separator":"-"}',
 9, 0, 'enabled', 0, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9303103, @wh_nj, '新泽西一号仓', '["9002"]', 'NJ仓-私人地址',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[{"op":"EQ","field":"order.order_type","value":"卡车派送"},{"op":"EQ","field":"order.address_type","value":"PRIVATE"}]}',
 '{"fields":[{"field":"order.address_type"},{"field":"order.order_no"}],"separator":"-"}',
 9, 0, 'enabled', 0, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9303104, @wh_nj, '新泽西一号仓', '["9002"]', 'NJ仓-快递派送',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[{"op":"EQ","field":"order.order_type","value":"快递派送"}]}',
 '{"fields":[{"field":"order.parcel_carrier_name"}],"separator":"-"}',
 8, 0, 'enabled', 0, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9303105, @wh_nj, '新泽西一号仓', '["9002"]', 'NJ仓-客户自提',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[{"op":"EQ","field":"order.order_type","value":"客户自提"}]}',
 '{"fields":[{"field":"order.order_type"},{"field":"order.order_no"}],"separator":"-"}',
 7, 0, 'enabled', 0, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9303106, @wh_nj, '新泽西一号仓', '["9002"]', 'NJ-大货中转',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[{"op":"EQ","field":"order.order_type","value":"大货中转"}]}',
 '{"fields":[{"field":"order.order_type"},{"field":"order.order_no"}],"separator":"-"}',
 6, 0, 'enabled', 1, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9303107, @wh_nj, '新泽西一号仓', '["9002"]', 'NJ-一件代发',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[{"op":"EQ","field":"order.order_type","value":"一件代发"}]}',
 '{"fields":[{"field":"order.order_type"},{"field":"shipment.shipment_no"}],"separator":"-"}',
 6, 0, 'enabled', 1, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9303108, @wh_nj, '新泽西一号仓', '["9002"]', 'NJ仓-默认规则',
 '{"mode":"VALUE_MATCH","logic":"AND","conditions":[]}',
 '{"fields":[{"field":"order.customer_id"},{"field":"order.order_type"}],"separator":"-"}',
 0, 1, 'enabled', 0, '兜底规则', @creator, @now, @creator, @now, b'0', @tenant_id)
ON DUPLICATE KEY UPDATE
    `warehouse_id` = VALUES(`warehouse_id`),
    `warehouse_name` = VALUES(`warehouse_name`),
    `warehouse_ids` = VALUES(`warehouse_ids`),
    `rule_name` = VALUES(`rule_name`),
    `condition_config` = VALUES(`condition_config`),
    `group_key_config` = VALUES(`group_key_config`),
    `priority` = VALUES(`priority`),
    `is_default` = VALUES(`is_default`),
    `status` = VALUES(`status`),
    `remark` = VALUES(`remark`),
    `updater` = VALUES(`updater`),
    `update_time` = VALUES(`update_time`),
    `deleted` = b'0';

-- 同步已有货物订单的业务类型名称（若已引用标准 ID）
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
WHERE `id` > 0
  AND `business_type_id` IN (5002001, 5002002, 5002003, 5002004, 5002005, 5002006, 5002007)
  AND `deleted` = b'0';
