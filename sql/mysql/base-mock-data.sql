-- 基础资料模块 — 模拟数据（演示 / 联调）
-- 前置：已执行 base-tables.sql（含 base_entity_translation、base_language）
-- 若缺多语言表：先执行 sql/mysql/base-i18n-tables.sql
-- 默认租户 tenant_id = 1（与芋道默认租户一致；多租户请按需改 WHERE 条件）
-- 可重复执行：先按租户清理再插入

SET NAMES utf8mb4;

SET @tenant_id = 1;
SET @creator = 'admin';
SET @now = NOW();

-- ========== 清理（仅本租户模拟数据，按 code 前缀/固定 id 范围）==========
DELETE FROM `base_platform_address` WHERE `tenant_id` = @tenant_id AND `id` BETWEEN 9001 AND 9099;
DELETE FROM `base_platform` WHERE `tenant_id` = @tenant_id AND `id` BETWEEN 9001 AND 9099;
DELETE FROM `base_exchange_rate` WHERE `tenant_id` = @tenant_id AND `id` BETWEEN 9001 AND 9099;
DELETE FROM `base_zip_code` WHERE `tenant_id` = @tenant_id AND `id` BETWEEN 9001 AND 9099;
DELETE FROM `base_city` WHERE `tenant_id` = @tenant_id AND `id` BETWEEN 9001 AND 9099;
DELETE FROM `base_state_province` WHERE `tenant_id` = @tenant_id AND `id` BETWEEN 9001 AND 9099;
DELETE FROM `base_timezone` WHERE `tenant_id` = @tenant_id AND `id` BETWEEN 9001 AND 9099;
DELETE FROM `base_currency` WHERE `tenant_id` = @tenant_id AND `id` BETWEEN 9001 AND 9099;
DELETE FROM `base_entity_translation` WHERE `tenant_id` = @tenant_id AND `id` BETWEEN 9101 AND 9299;
DELETE FROM `base_country` WHERE `tenant_id` = @tenant_id AND `id` BETWEEN 9001 AND 9099;
DELETE FROM `base_port` WHERE `tenant_id` = @tenant_id AND `id` BETWEEN 9001 AND 9099;
DELETE FROM `base_shipping_line` WHERE `tenant_id` = @tenant_id AND `id` BETWEEN 9001 AND 9099;
DELETE FROM `mdm_fee_item` WHERE `tenant_id` = @tenant_id AND `id` BETWEEN 9001 AND 9099;
DELETE FROM `mdm_sku_default_fee` WHERE `tenant_id` = @tenant_id AND `sku_id` BETWEEN 9001 AND 9099;
DELETE FROM `mdm_sku_inventory` WHERE `tenant_id` = @tenant_id AND `sku_id` BETWEEN 9001 AND 9099;
DELETE FROM `mdm_sku` WHERE `tenant_id` = @tenant_id AND `id` BETWEEN 9001 AND 9099;
DELETE FROM `mdm_packaging` WHERE `tenant_id` = @tenant_id AND `id` BETWEEN 9001 AND 9099;
DELETE FROM `mdm_client` WHERE `tenant_id` = @tenant_id AND `id` BETWEEN 1001 AND 1099;
DELETE FROM `mdm_warehouse` WHERE `tenant_id` = @tenant_id AND `id` BETWEEN 9001 AND 9099;
DELETE FROM `mdm_company` WHERE `tenant_id` = @tenant_id AND `id` BETWEEN 9001 AND 9099;

-- ========== 国家 ==========
INSERT INTO `base_country` (`id`, `code`, `name_en`, `phone_code`, `currency_code`, `timezone_default`, `is_active`, `sort_order`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`) VALUES
(9001, 'US', 'United States', '+1', 'USD', 'America/Los_Angeles', 1, 1, @creator, @now, @creator, @now, b'0', @tenant_id),
(9002, 'CN', 'China', '+86', 'CNY', 'Asia/Shanghai', 1, 2, @creator, @now, @creator, @now, b'0', @tenant_id),
(9003, 'DE', 'Germany', '+49', 'EUR', 'Europe/Berlin', 1, 3, @creator, @now, @creator, @now, b'0', @tenant_id),
(9004, 'GB', 'United Kingdom', '+44', 'GBP', 'Europe/London', 1, 4, @creator, @now, @creator, @now, b'0', @tenant_id),
(9005, 'CA', 'Canada', '+1', 'CAD', 'America/Toronto', 1, 5, @creator, @now, @creator, @now, b'0', @tenant_id);

-- ========== 时区（status 0=正常）==========
INSERT INTO `base_timezone` (`id`, `tz_code`, `name_en`, `utc_offset`, `country_code`, `is_dst`, `status`, `sort_order`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`) VALUES
(9001, 'America/Los_Angeles', 'US Pacific', 'UTC-08:00', 'US', 1, 0, 1, @creator, @now, @creator, @now, b'0', @tenant_id),
(9002, 'America/New_York', 'US Eastern', 'UTC-05:00', 'US', 1, 0, 2, @creator, @now, @creator, @now, b'0', @tenant_id),
(9003, 'Asia/Shanghai', 'China Standard', 'UTC+08:00', 'CN', 0, 0, 3, @creator, @now, @creator, @now, b'0', @tenant_id),
(9004, 'Europe/Berlin', 'Central Europe', 'UTC+01:00', 'DE', 1, 0, 4, @creator, @now, @creator, @now, b'0', @tenant_id),
(9005, 'Europe/London', 'UK', 'UTC+00:00', 'GB', 1, 0, 5, @creator, @now, @creator, @now, b'0', @tenant_id);

-- ========== 币种（is_base：USD=1）==========
INSERT INTO `base_currency` (`id`, `code`, `name_en`, `symbol`, `decimal_places`, `is_base`, `status`, `sort_order`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`) VALUES
(9001, 'USD', 'US Dollar', '$', 2, 1, 0, 1, @creator, @now, @creator, @now, b'0', @tenant_id),
(9002, 'CNY', 'Chinese Yuan', '¥', 2, 0, 0, 2, @creator, @now, @creator, @now, b'0', @tenant_id),
(9003, 'EUR', 'Euro', '€', 2, 0, 0, 3, @creator, @now, @creator, @now, b'0', @tenant_id),
(9004, 'GBP', 'British Pound', '£', 2, 0, 0, 4, @creator, @now, @creator, @now, b'0', @tenant_id),
(9005, 'CAD', 'Canadian Dollar', 'C$', 2, 0, 0, 5, @creator, @now, @creator, @now, b'0', @tenant_id);

-- ========== 州/省 ==========
INSERT INTO `base_state_province` (`id`, `country_code`, `code`, `name_en`, `sort_order`, `status`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`) VALUES
(9001, 'US', 'CA', 'California', 1, 0, @creator, @now, @creator, @now, b'0', @tenant_id),
(9002, 'US', 'NY', 'New York', 2, 0, @creator, @now, @creator, @now, b'0', @tenant_id),
(9003, 'US', 'TX', 'Texas', 3, 0, @creator, @now, @creator, @now, b'0', @tenant_id),
(9004, 'US', 'NJ', 'New Jersey', 4, 0, @creator, @now, @creator, @now, b'0', @tenant_id),
(9005, 'CN', 'GD', 'Guangdong', 1, 0, @creator, @now, @creator, @now, b'0', @tenant_id),
(9006, 'CN', 'SH', 'Shanghai', 2, 0, @creator, @now, @creator, @now, b'0', @tenant_id),
(9007, 'DE', 'HH', 'Hamburg', 1, 0, @creator, @now, @creator, @now, b'0', @tenant_id);

-- ========== 城市 ==========
INSERT INTO `base_city` (`id`, `country_code`, `state_code`, `name_en`, `status`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`) VALUES
(9001, 'US', 'CA', 'Los Angeles', 0, @creator, @now, @creator, @now, b'0', @tenant_id),
(9002, 'US', 'CA', 'Ontario', 0, @creator, @now, @creator, @now, b'0', @tenant_id),
(9003, 'US', 'NY', 'New York', 0, @creator, @now, @creator, @now, b'0', @tenant_id),
(9004, 'US', 'TX', 'Houston', 0, @creator, @now, @creator, @now, b'0', @tenant_id),
(9005, 'US', 'NJ', 'Edison', 0, @creator, @now, @creator, @now, b'0', @tenant_id),
(9006, 'CN', 'GD', 'Shenzhen', 0, @creator, @now, @creator, @now, b'0', @tenant_id),
(9007, 'CN', 'SH', 'Shanghai', 0, @creator, @now, @creator, @now, b'0', @tenant_id),
(9008, 'DE', 'HH', 'Hamburg', 0, @creator, @now, @creator, @now, b'0', @tenant_id);

-- ========== 邮编 ==========
INSERT INTO `base_zip_code` (`id`, `country_code`, `state_code`, `city_name`, `zip`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`) VALUES
(9001, 'US', 'CA', 'Los Angeles', '90001', @creator, @now, @creator, @now, b'0', @tenant_id),
(9002, 'US', 'CA', 'Ontario', '91761', @creator, @now, @creator, @now, b'0', @tenant_id),
(9003, 'US', 'NY', 'New York', '10001', @creator, @now, @creator, @now, b'0', @tenant_id),
(9004, 'US', 'TX', 'Houston', '77001', @creator, @now, @creator, @now, b'0', @tenant_id),
(9005, 'US', 'NJ', 'Edison', '08817', @creator, @now, @creator, @now, b'0', @tenant_id),
(9006, 'CN', 'GD', 'Shenzhen', '518000', @creator, @now, @creator, @now, b'0', @tenant_id),
(9007, 'CN', 'SH', 'Shanghai', '200000', @creator, @now, @creator, @now, b'0', @tenant_id);

-- ========== 汇率（基准 USD）==========
INSERT INTO `base_exchange_rate` (`id`, `from_currency`, `to_currency`, `rate`, `effective_date`, `expired_date`, `is_current`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`) VALUES
(9001, 'USD', 'CNY', 7.250000, '2026-05-01', NULL, 1, 'Mock rate', @creator, @now, @creator, @now, b'0', @tenant_id),
(9002, 'USD', 'EUR', 0.920000, '2026-05-01', NULL, 1, 'Mock rate', @creator, @now, @creator, @now, b'0', @tenant_id),
(9003, 'USD', 'GBP', 0.790000, '2026-05-01', NULL, 1, 'Mock rate', @creator, @now, @creator, @now, b'0', @tenant_id),
(9004, 'USD', 'CAD', 1.360000, '2026-05-01', NULL, 1, 'Mock rate', @creator, @now, @creator, @now, b'0', @tenant_id),
(9005, 'CNY', 'USD', 0.137931, '2026-05-01', NULL, 1, 'Mock rate', @creator, @now, @creator, @now, b'0', @tenant_id);

-- ========== 平台（type_code 需与字典 PLATFORM_TYPE 一致时可再改）==========
INSERT INTO `base_platform` (`id`, `code`, `name_en`, `type_code`, `logo_oss_id`, `logo_url`, `status`, `sort_order`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`) VALUES
(9001, 'AMAZON', 'Amazon', 'ECOM', NULL, NULL, 0, 1, @creator, @now, @creator, @now, b'0', @tenant_id),
(9002, 'SHOPIFY', 'Shopify', 'ECOM', NULL, NULL, 0, 2, @creator, @now, @creator, @now, b'0', @tenant_id),
(9003, 'TEMU', 'Temu', 'ECOM', NULL, NULL, 0, 3, @creator, @now, @creator, @now, b'0', @tenant_id),
(9004, 'TIKTOK', 'TikTok Shop', 'ECOM', NULL, NULL, 0, 4, @creator, @now, @creator, @now, b'0', @tenant_id);

-- ========== 平台地址（address_type 1=FBA 2=门店 3=配送中心 4=其他）==========
INSERT INTO `base_platform_address` (`id`, `platform_id`, `address_code`, `address_type`, `name_en`, `country_code`, `state_code`, `city`, `address_line1`, `address_line2`, `zip_code`, `contact_name`, `contact_phone`, `last_verified_at`, `wh_property`, `pallet_cbm`, `is_weigh_station`, `max_weight_ton`, `status`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`) VALUES
(9001, 9001, 'ONT8', 1, 'Amazon ONT8 - Ontario', 'US', 'CA', 'Ontario', '1910 E Central Ave', NULL, '91761', 'Receiving', '+1-909-000-0001', @now, 'LARGE', 1.80, 1, 20.500, 0, 'FBA US West', @creator, @now, @creator, @now, b'0', @tenant_id),
(9002, 9001, 'LAX9', 1, 'Amazon LAX9 - Los Angeles', 'US', 'CA', 'Los Angeles', '6750 Kimball Ave', NULL, '90805', 'Receiving', '+1-562-000-0002', @now, 'LARGE', 1.75, 0, NULL, 0, 'FBA US West', @creator, @now, @creator, @now, b'0', @tenant_id),
(9003, 9001, 'EWR4', 1, 'Amazon EWR4 - New Jersey', 'US', 'NJ', 'Edison', '50 New Canton Way', NULL, '08817', 'Receiving', '+1-732-000-0003', @now, 'LARGE', 1.70, 0, NULL, 0, 'FBA US East', @creator, @now, @creator, @now, b'0', @tenant_id),
(9004, 9001, 'FTW1', 1, 'Amazon FTW1 - Texas', 'US', 'TX', 'Houston', '3351 S Houston Ave', NULL, '77001', 'Receiving', '+1-713-000-0004', @now, 'LARGE', 1.85, 1, 22.000, 0, 'FBA US South', @creator, @now, @creator, @now, b'0', @tenant_id),
(9005, 9002, 'SHOP-US-DEFAULT', 4, 'Shopify Default Ship From', 'US', 'CA', 'Los Angeles', '123 Commerce St', 'Suite 100', '90001', 'Ops', '+1-213-000-0005', @now, 'SMALL', 0.50, 0, NULL, 0, NULL, @creator, @now, @creator, @now, b'0', @tenant_id);

-- ========== 港口（port_type 1海港 2空港 3内陆港）==========
INSERT INTO `base_port` (`id`, `port_code`, `name_en`, `country_code`, `state_code`, `city`, `port_type`, `timezone`, `container_query_url`, `status`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`) VALUES
(9001, 'USLAX', 'Port of Los Angeles', 'US', 'CA', 'Los Angeles', 1, 'America/Los_Angeles', 'https://example.com/track?no={container_no}', 0, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9002, 'USNYC', 'Port of New York/New Jersey', 'US', 'NY', 'New York', 1, 'America/New_York', NULL, 0, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9003, 'CNSHA', 'Port of Shanghai', 'CN', 'SH', 'Shanghai', 1, 'Asia/Shanghai', NULL, 0, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9004, 'CNYTN', 'Port of Yantian', 'CN', 'GD', 'Shenzhen', 1, 'Asia/Shanghai', NULL, 0, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9005, 'DEHAM', 'Port of Hamburg', 'DE', 'HH', 'Hamburg', 1, 'Europe/Berlin', NULL, 0, NULL, @creator, @now, @creator, @now, b'0', @tenant_id);

-- ========== 船司 ==========
INSERT INTO `base_shipping_line` (`id`, `code`, `name_en`, `name_abbr`, `country_code`, `contact_email`, `contact_phone`, `website`, `tracking_url`, `status`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`) VALUES
(9001, 'MSCU', 'Mediterranean Shipping Company', 'MSC', 'CH', 'booking@msc.com', NULL, 'https://www.msc.com', 'https://www.msc.com/track?cntr={container_no}', 0, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9002, 'MAEU', 'Maersk Line', 'Maersk', 'DK', NULL, NULL, 'https://www.maersk.com', 'https://www.maersk.com/tracking/{container_no}', 0, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9003, 'COSU', 'COSCO Shipping', 'COSCO', 'CN', NULL, NULL, 'https://www.coscoshipping.com', NULL, 0, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9004, 'EGLV', 'Evergreen Line', 'Evergreen', 'TW', NULL, NULL, 'https://www.evergreen-line.com', NULL, 0, NULL, @creator, @now, @creator, @now, b'0', @tenant_id);

-- ========== 主体 ==========
INSERT INTO `mdm_company` (`id`, `company_code`, `company_name`, `company_name_en`, `tax_no`, `status`, `sort`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`) VALUES
(9001, 'OW-US-01', '海外仓美国主体', 'Overseas Warehouse US LLC', 'US-TAX-9001', 0, 1, '签约/计费主体', @creator, @now, @creator, @now, b'0', @tenant_id),
(9002, 'OW-CN-01', '海外仓中国主体', 'Overseas Warehouse CN Co., Ltd.', 'CN-TAX-9002', 0, 2, NULL, @creator, @now, @creator, @now, b'0', @tenant_id);

-- ========== 仓库 ==========
INSERT INTO `mdm_warehouse` (`id`, `warehouse_code`, `warehouse_name`, `company_id`, `timezone_code`, `country_code`, `address`, `status`, `sort`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`) VALUES
(9001, 'US-LA-01', '洛杉矶一号仓', 9001, 'America/Los_Angeles', 'US', '1234 Warehouse Blvd, Los Angeles, CA 90001', 0, 1, '美西主仓', @creator, @now, @creator, @now, b'0', @tenant_id),
(9002, 'US-NJ-01', '新泽西一号仓', 9001, 'America/New_York', 'US', '567 Logistics Pkwy, Edison, NJ 08817', 0, 2, '美东仓', @creator, @now, @creator, @now, b'0', @tenant_id),
(9003, 'CN-SZ-01', '深圳保税仓', 9002, 'Asia/Shanghai', 'CN', '深圳市宝安区示例物流园 A 栋', 0, 3, '国内集货', @creator, @now, @creator, @now, b'0', @tenant_id);

-- ========== 费项（fee_category / business_stage 与字典一致时可再改）==========
INSERT INTO `mdm_fee_item` (`id`, `fee_code`, `fee_name`, `fee_category`, `business_stage`, `business_type`, `is_system`, `is_billable`, `description`, `status`, `sort_order`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`) VALUES
(9001, 'INBOUND_HANDLING', '入库操作费', 'WAREHOUSE', 'INBOUND', NULL, 1, 1, '按件/按箱', 0, 1, '系统预置', @creator, @now, @creator, @now, b'0', @tenant_id),
(9002, 'STORAGE_FEE', '仓储费', 'WAREHOUSE', 'STORAGE', NULL, 1, 1, '按体积/天', 0, 2, '系统预置', @creator, @now, @creator, @now, b'0', @tenant_id),
(9003, 'PICK_FEE', '拣货费', 'WAREHOUSE', 'OUTBOUND', 'B2C', 1, 1, '按订单行', 0, 3, '系统预置', @creator, @now, @creator, @now, b'0', @tenant_id),
(9004, 'PACK_FEE', '包装费', 'WAREHOUSE', 'OUTBOUND', NULL, 1, 1, NULL, 0, 4, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9005, 'LABEL_FEE', '面单费', 'LOGISTICS', 'OUTBOUND', NULL, 0, 1, '尾程面单', 0, 5, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9006, 'CUSTOMS_CLEARANCE', '清关服务费', 'CUSTOMS', 'INBOUND', NULL, 0, 1, NULL, 0, 6, NULL, @creator, @now, @creator, @now, b'0', @tenant_id);

-- ========== 客户（SKU 货主）==========
INSERT INTO `mdm_client` (`id`, `client_code`, `client_name`, `status`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`) VALUES
(1001, 'CLIENT-A', '演示货主 A', 0, '联调货主', @creator, @now, @creator, @now, b'0', @tenant_id),
(1002, 'CLIENT-B', '演示货主 B', 0, NULL, @creator, @now, @creator, @now, b'0', @tenant_id);

-- ========== 包装 ==========
INSERT INTO `mdm_packaging` (`id`, `pkg_code`, `pkg_name`, `pkg_type`, `source_type`, `client_id`, `warehouse_ids`, `pkg_length`, `pkg_width`, `pkg_height`, `dimension_unit`, `tare_weight`, `weight_unit`, `max_load_weight`, `material`, `is_custom`, `is_default`, `scan_required`, `status`, `sort_order`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`) VALUES
(9001, 'BOX-S', '小纸箱', 1, 1, NULL, NULL, 30.00, 20.00, 15.00, 'CM', 0.200, 'KG', 5.000, '瓦楞纸', 0, 1, 0, 0, 1, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9002, 'BOX-M', '中纸箱', 1, 1, NULL, '[9001,9002]', 40.00, 30.00, 25.00, 'CM', 0.350, 'KG', 10.000, '瓦楞纸', 0, 0, 0, 0, 2, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9003, 'BOX-L', '大纸箱', 1, 1, NULL, NULL, 50.00, 40.00, 35.00, 'CM', 0.500, 'KG', 20.000, '瓦楞纸', 0, 0, 1, 0, 3, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9004, 'BAG-BUBBLE', '气泡袋', 2, 2, 1001, NULL, NULL, NULL, NULL, 'CM', 0.050, 'KG', NULL, 'PE', 1, 0, 0, 0, 4, '客户提供', @creator, @now, @creator, @now, b'0', @tenant_id);

-- ========== SKU ==========
INSERT INTO `mdm_sku` (`id`, `client_id`, `sku_code`, `sku_name`, `sku_name_en`, `barcode`, `unit`, `length_cm`, `width_cm`, `height_cm`, `weight_kg`, `volume_cbm`, `default_pkg_id`, `status`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`) VALUES
(9001, 1001, 'SKU-PHONE-001', '蓝牙耳机 Pro', 'Bluetooth Earbuds Pro', '6901234567890', 'pcs', 15.00, 10.00, 5.00, 0.200, 0.000750, 9001, 0, 'Demo client A', @creator, @now, @creator, @now, b'0', @tenant_id),
(9002, 1001, 'SKU-PHONE-002', '手机支架', 'Phone Stand', '6901234567891', 'pcs', 12.00, 8.00, 3.00, 0.150, NULL, 9001, 0, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9003, 1001, 'SKU-CASE-001', '硅胶手机壳', 'Silicone Phone Case', '6901234567892', 'pcs', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, @creator, @now, @creator, @now, b'0', @tenant_id),
(9004, 1002, 'SKU-HOME-001', 'LED 台灯', 'LED Desk Lamp', '6902234567890', 'pcs', 30.00, 20.00, 15.00, 0.800, NULL, 9002, 0, 'Demo client B', @creator, @now, @creator, @now, b'0', @tenant_id),
(9005, 1002, 'SKU-HOME-002', '收纳盒套装', 'Storage Box Set', '6902234567891', 'set', 35.00, 25.00, 18.00, 1.200, NULL, 9003, 0, NULL, @creator, @now, @creator, @now, b'0', @tenant_id);

INSERT INTO `mdm_sku_default_fee` (`id`, `sku_id`, `fee_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`) VALUES
(9001, 9001, 'PICK_FEE', @creator, @now, @creator, @now, b'0', @tenant_id),
(9002, 9001, 'PACK_FEE', @creator, @now, @creator, @now, b'0', @tenant_id);

-- ========== 多语言示例（需先执行 base-i18n-tables.sql）==========
INSERT INTO `base_entity_translation` (`id`, `entity_type`, `entity_id`, `field_name`, `lang_code`, `value`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`) VALUES
(9101, 'country', 9001, 'name', 'zh', '美国', @creator, @now, @creator, @now, b'0', @tenant_id),
(9102, 'country', 9001, 'name', 'de', 'Vereinigte Staaten', @creator, @now, @creator, @now, b'0', @tenant_id),
(9103, 'country', 9002, 'name', 'zh', '中国', @creator, @now, @creator, @now, b'0', @tenant_id),
(9104, 'country', 9003, 'name', 'zh', '德国', @creator, @now, @creator, @now, b'0', @tenant_id),
(9105, 'country', 9004, 'name', 'zh', '英国', @creator, @now, @creator, @now, b'0', @tenant_id),
(9201, 'state_province', 9001, 'name', 'zh', '加利福尼亚', @creator, @now, @creator, @now, b'0', @tenant_id),
(9202, 'state_province', 9002, 'name', 'zh', '纽约', @creator, @now, @creator, @now, b'0', @tenant_id),
(9203, 'state_province', 9005, 'name', 'zh', '广东', @creator, @now, @creator, @now, b'0', @tenant_id),
(9204, 'state_province', 9006, 'name', 'zh', '上海', @creator, @now, @creator, @now, b'0', @tenant_id),
(9301, 'city', 9001, 'name', 'zh', '洛杉矶', @creator, @now, @creator, @now, b'0', @tenant_id),
(9302, 'city', 9003, 'name', 'zh', '纽约', @creator, @now, @creator, @now, b'0', @tenant_id),
(9303, 'city', 9006, 'name', 'zh', '深圳', @creator, @now, @creator, @now, b'0', @tenant_id),
(9304, 'city', 9007, 'name', 'zh', '上海', @creator, @now, @creator, @now, b'0', @tenant_id),
(9401, 'currency', 9001, 'name', 'zh', '美元', @creator, @now, @creator, @now, b'0', @tenant_id),
(9402, 'currency', 9002, 'name', 'zh', '人民币', @creator, @now, @creator, @now, b'0', @tenant_id),
(9403, 'currency', 9003, 'name', 'zh', '欧元', @creator, @now, @creator, @now, b'0', @tenant_id),
(9501, 'platform', 9001, 'name', 'zh', '亚马逊', @creator, @now, @creator, @now, b'0', @tenant_id),
(9502, 'platform', 9002, 'name', 'zh', 'Shopify', @creator, @now, @creator, @now, b'0', @tenant_id),
(9503, 'platform', 9003, 'name', 'zh', 'Temu', @creator, @now, @creator, @now, b'0', @tenant_id),
(9601, 'platform_address', 9001, 'name', 'zh', 'ONT8 仓', @creator, @now, @creator, @now, b'0', @tenant_id),
(9602, 'platform_address', 9002, 'name', 'zh', 'LAX9 仓', @creator, @now, @creator, @now, b'0', @tenant_id),
(9701, 'port', 9001, 'name', 'zh', '洛杉矶港', @creator, @now, @creator, @now, b'0', @tenant_id),
(9702, 'port', 9002, 'name', 'zh', '纽约/新泽西港', @creator, @now, @creator, @now, b'0', @tenant_id),
(9703, 'port', 9003, 'name', 'zh', '上海港', @creator, @now, @creator, @now, b'0', @tenant_id),
(9704, 'port', 9004, 'name', 'zh', '盐田港', @creator, @now, @creator, @now, b'0', @tenant_id),
(9705, 'port', 9005, 'name', 'zh', '汉堡港', @creator, @now, @creator, @now, b'0', @tenant_id),
(9801, 'shipping_line', 9001, 'name', 'zh', '地中海航运', @creator, @now, @creator, @now, b'0', @tenant_id),
(9802, 'shipping_line', 9002, 'name', 'zh', '马士基', @creator, @now, @creator, @now, b'0', @tenant_id),
(9803, 'shipping_line', 9003, 'name', 'zh', '中远海运', @creator, @now, @creator, @now, b'0', @tenant_id),
(9804, 'shipping_line', 9004, 'name', 'zh', '长荣海运', @creator, @now, @creator, @now, b'0', @tenant_id)
ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);

-- 完成
SELECT 'base mock data loaded for tenant_id=' AS msg, @tenant_id AS tenant_id;
