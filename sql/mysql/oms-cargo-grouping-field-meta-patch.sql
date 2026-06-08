-- 分组规则 field_meta 补全（对齐参考系统 UI fallback 字段）
-- 可重复执行

INSERT INTO `oms_cargo_grouping_field_meta`
(`id`, `table_alias`, `field_name`, `display_name`, `data_type`, `enum_code`, `ref_type`, `can_be_condition`, `can_be_group_key`, `sort_order`, `enabled`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`)
SELECT 9301012, 'order', 'hold_flag', '是否暂扣', 'BOOLEAN', NULL, NULL, 1, 0, 95, 1, '货物订单 HOLD 标志', 'admin', NOW(), 'admin', NOW(), b'0', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `oms_cargo_grouping_field_meta` WHERE `id` = 9301012);

INSERT INTO `oms_cargo_grouping_field_meta`
(`id`, `table_alias`, `field_name`, `display_name`, `data_type`, `enum_code`, `ref_type`, `can_be_condition`, `can_be_group_key`, `sort_order`, `enabled`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`)
SELECT 9301013, 'order', 'transfer_flag', '是否转仓', 'BOOLEAN', NULL, NULL, 1, 0, 96, 1, '货物订单转仓标志', 'admin', NOW(), 'admin', NOW(), b'0', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `oms_cargo_grouping_field_meta` WHERE `id` = 9301013);

INSERT INTO `oms_cargo_grouping_field_meta`
(`id`, `table_alias`, `field_name`, `display_name`, `data_type`, `enum_code`, `ref_type`, `can_be_condition`, `can_be_group_key`, `sort_order`, `enabled`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`)
SELECT 9301014, 'order', 'transfer_warehouse_code', '转仓仓库', 'STRING', NULL, NULL, 1, 1, 97, 1, '转仓目标仓库代码', 'admin', NOW(), 'admin', NOW(), b'0', 0
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `oms_cargo_grouping_field_meta` WHERE `id` = 9301014);
