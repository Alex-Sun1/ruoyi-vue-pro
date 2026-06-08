-- OMS 模块清库脚本（删除表 + 菜单 + 字典）
-- 用途：OMS 整模块重做前，清空现有 OMS 数据与权限配置
-- 注意：不删除 BASE / WMS / YMS 模块表；wms_inbound_plan 保留（属 WMS，仅菜单挂在 OMS 下会被一并删除）
-- 执行前请备份数据库

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ========== 1. 删除 OMS 业务表（先子表后主表） ==========

-- 参考系统 oms_* 表
DROP TABLE IF EXISTS `oms_outbound_order_item`;
DROP TABLE IF EXISTS `oms_outbound_order`;
DROP TABLE IF EXISTS `oms_pre_outbound_item`;
DROP TABLE IF EXISTS `oms_pre_outbound`;
DROP TABLE IF EXISTS `oms_cargo_grouping_rule`;
DROP TABLE IF EXISTS `oms_cargo_grouping_field_meta`;
DROP TABLE IF EXISTS `oms_container_order_trace`;
DROP TABLE IF EXISTS `oms_container_cargo_order_rel`;
DROP TABLE IF EXISTS `oms_cargo_order_sku_item`;
DROP TABLE IF EXISTS `oms_cargo_order_shipment`;
DROP TABLE IF EXISTS `oms_cargo_order_node_trace`;
DROP TABLE IF EXISTS `oms_cargo_order_hold_record`;
DROP TABLE IF EXISTS `oms_cargo_order`;
DROP TABLE IF EXISTS `oms_order_route_node`;
DROP TABLE IF EXISTS `oms_container_unstuff_info`;

-- Yudao 版海柜扩展子表
DROP TABLE IF EXISTS `oms_container_remark`;
DROP TABLE IF EXISTS `oms_container_fee_snapshot`;
DROP TABLE IF EXISTS `oms_container_wms_snapshot`;
DROP TABLE IF EXISTS `oms_container_transport_info`;
DROP TABLE IF EXISTS `oms_container_terminal_info`;
DROP TABLE IF EXISTS `oms_container_order`;

-- 预警 / 费用 / 路由
DROP TABLE IF EXISTS `oms_alert_instance`;
DROP TABLE IF EXISTS `oms_alert_rule`;
DROP TABLE IF EXISTS `oms_fee`;
DROP TABLE IF EXISTS `oms_freeze_request`;
DROP TABLE IF EXISTS `oms_route_node`;
DROP TABLE IF EXISTS `oms_route_template`;

-- CORE 共享表（OMS 域）
DROP TABLE IF EXISTS `biz_attachment`;
DROP TABLE IF EXISTS `biz_timeline`;
DROP TABLE IF EXISTS `biz_event`;
DROP TABLE IF EXISTS `biz_relation`;
DROP TABLE IF EXISTS `cargo_order_node_trace`;
DROP TABLE IF EXISTS `cargo_order_item`;
DROP TABLE IF EXISTS `shipment`;
DROP TABLE IF EXISTS `cargo_order`;
DROP TABLE IF EXISTS `biz_root`;

SET FOREIGN_KEY_CHECKS = 1;

-- ========== 2. 删除 OMS 菜单与角色授权 ==========
-- 菜单 ID：6900 为 OMS 根目录；6901~6999 为子菜单与按钮（含挂在 OMS 下的入库计划 6950）

DELETE FROM `system_role_menu` WHERE `menu_id` BETWEEN 6900 AND 7100;
DELETE FROM `system_menu` WHERE `id` BETWEEN 6900 AND 7100;

-- 兼容：按权限码清理可能遗漏的 OMS 菜单
DELETE FROM `system_role_menu`
WHERE `menu_id` IN (
    SELECT `id` FROM `system_menu`
    WHERE `permission` LIKE 'oms:%' OR `path` LIKE '/oms%'
);
DELETE FROM `system_menu`
WHERE `permission` LIKE 'oms:%' OR `path` LIKE '/oms%';

-- ========== 3. 删除 OMS 字典 ==========

DELETE FROM `system_dict_data` WHERE `dict_type` LIKE 'oms\_%' ESCAPE '\\';
DELETE FROM `system_dict_type` WHERE `type` LIKE 'oms\_%' ESCAPE '\\';

-- 已知固定 ID（来自 oms-dict.sql，可重复执行）
DELETE FROM `system_dict_data` WHERE `id` BETWEEN 72001 AND 72099;
DELETE FROM `system_dict_type` WHERE `id` BETWEEN 7200 AND 7299;

-- ========== 4. 验证（可选） ==========
-- SELECT TABLE_NAME FROM information_schema.TABLES
--   WHERE TABLE_SCHEMA = DATABASE() AND (TABLE_NAME LIKE 'oms\_%' OR TABLE_NAME IN (
--     'biz_root','biz_event','biz_relation','biz_timeline','biz_attachment',
--     'cargo_order','cargo_order_item','cargo_order_node_trace','shipment'
--   ));
-- SELECT id, name, permission FROM system_menu WHERE permission LIKE 'oms:%' OR id BETWEEN 6900 AND 6999;
