-- 基础资料（BASE）系统字典
-- 执行前请确认 ID 不冲突：
--   SELECT MAX(id) FROM system_dict_type;
--   SELECT MAX(id) FROM system_dict_data;
-- 本脚本 dict_type.id 7100~7113；dict_data.id 71001~71099
-- 若 type 已存在会主键/唯一键冲突，可先：DELETE FROM system_dict_data WHERE dict_type LIKE 'BASE_%' OR dict_type IN (...);
-- 状态类字段请继续用芋道内置 common_status（0 开启 / 1 关闭），本脚本不重复创建

SET NAMES utf8mb4;

-- ========== 字典类型 ==========
INSERT INTO `system_dict_type` (`id`, `name`, `type`, `status`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `deleted_time`) VALUES
(7100, '国家是否开通', 'BASE_COUNTRY_ACTIVE', 0, '国家 BASE-001，字段 is_active', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7101, '平台类型', 'PLATFORM_TYPE', 0, '平台 BASE-010，字段 type_code', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7102, '费用分类', 'FEE_CATEGORY', 0, '费项 BASE-019，字段 fee_category', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7103, '费项业务阶段', 'FEE_BUSINESS_STAGE', 0, '费项，字段 business_stage', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7104, '履约业务类型', 'FULFILLMENT_TYPE', 0, '费项，字段 business_type；空=通用', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7105, '平台地址仓库属性', 'MDM_WH_PROPERTY', 0, '平台地址 BASE-011，字段 wh_property', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7106, '港口类型', 'BASE_PORT_TYPE', 0, '港口 BASE-012，字段 port_type', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7107, '平台地址类型', 'BASE_PLATFORM_ADDRESS_TYPE', 0, '平台地址，字段 address_type', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7108, '包装类型', 'MDM_PACKAGING_TYPE', 0, '包装 BASE-018，字段 pkg_type', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7109, '包装来源', 'MDM_PACKAGING_SOURCE_TYPE', 0, '包装，字段 source_type', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7110, '尺寸单位', 'MDM_DIMENSION_UNIT', 0, '包装，字段 dimension_unit', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7111, '重量单位', 'MDM_WEIGHT_UNIT', 0, '包装，字段 weight_unit', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7112, '平台地址变更类型', 'BASE_PLATFORM_ADDRESS_CHANGE_TYPE', 0, '变更日志 change_type', 'admin', NOW(), 'admin', NOW(), b'0', NULL),
(7113, '是否(0/1)', 'BASE_YES_NO', 0, '0否1是：过磅站/系统费项/汇率当前等', 'admin', NOW(), 'admin', NOW(), b'0', NULL);

-- ========== 字典数据 ==========

-- BASE_COUNTRY_ACTIVE（勿与 common_status 混用）
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(71001, 1, '未开通', '0', 'BASE_COUNTRY_ACTIVE', 0, 'info', '', '国家未开通', 'admin', NOW(), 'admin', NOW(), b'0'),
(71002, 2, '已开通', '1', 'BASE_COUNTRY_ACTIVE', 0, 'success', '', '国家已开通', 'admin', NOW(), 'admin', NOW(), b'0');

-- PLATFORM_TYPE（与 base-mock-data type_code=ECOM 对齐）
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(71011, 1, '电商平台', 'ECOM', 'PLATFORM_TYPE', 0, 'primary', '', 'Amazon/Shopify 等', 'admin', NOW(), 'admin', NOW(), b'0'),
(71012, 2, '卖场平台', 'MARKETPLACE', 'PLATFORM_TYPE', 0, 'success', '', 'Walmart 等', 'admin', NOW(), 'admin', NOW(), b'0'),
(71013, 3, '零售渠道', 'RETAIL', 'PLATFORM_TYPE', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(71014, 4, '其他', 'OTHER', 'PLATFORM_TYPE', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0');

-- FEE_CATEGORY
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(71021, 1, '仓储费', 'WAREHOUSE', 'FEE_CATEGORY', 0, 'primary', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(71022, 2, '物流费', 'LOGISTICS', 'FEE_CATEGORY', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(71023, 3, '关务费', 'CUSTOMS', 'FEE_CATEGORY', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(71024, 4, '增值服务费', 'VAS', 'FEE_CATEGORY', 0, 'info', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(71025, 5, '其他', 'OTHER', 'FEE_CATEGORY', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0');

-- FEE_BUSINESS_STAGE
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(71031, 1, '入库', 'INBOUND', 'FEE_BUSINESS_STAGE', 0, 'primary', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(71032, 2, '仓储', 'STORAGE', 'FEE_BUSINESS_STAGE', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(71033, 3, '出库', 'OUTBOUND', 'FEE_BUSINESS_STAGE', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(71034, 4, '运输', 'TRANSPORT', 'FEE_BUSINESS_STAGE', 0, 'info', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(71035, 5, '其他', 'OTHER', 'FEE_BUSINESS_STAGE', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0');

-- FULFILLMENT_TYPE（business_type 为空表示通用，前端自行加「通用」选项）
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(71041, 1, 'B2C', 'B2C', 'FULFILLMENT_TYPE', 0, 'primary', '', 'mock 已用', 'admin', NOW(), 'admin', NOW(), b'0'),
(71042, 2, 'B2B', 'B2B', 'FULFILLMENT_TYPE', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(71043, 3, 'FBM', 'FBM', 'FULFILLMENT_TYPE', 0, 'warning', '', '卖家自发货', 'admin', NOW(), 'admin', NOW(), b'0'),
(71044, 4, 'FBA', 'FBA', 'FULFILLMENT_TYPE', 0, 'info', '', '平台仓发货', 'admin', NOW(), 'admin', NOW(), b'0');

-- MDM_WH_PROPERTY（与 mock LARGE/SMALL 对齐）
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(71051, 1, '大件仓', 'LARGE', 'MDM_WH_PROPERTY', 0, 'primary', '', 'mock 已用', 'admin', NOW(), 'admin', NOW(), b'0'),
(71052, 2, '小件仓', 'SMALL', 'MDM_WH_PROPERTY', 0, 'success', '', 'mock 已用', 'admin', NOW(), 'admin', NOW(), b'0'),
(71053, 3, '标准仓', 'STANDARD', 'MDM_WH_PROPERTY', 0, 'info', '', '', 'admin', NOW(), 'admin', NOW(), b'0');

-- BASE_PORT_TYPE（port_type 1~3，与 PortServiceImpl 校验一致）
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(71061, 1, '海港', '1', 'BASE_PORT_TYPE', 0, 'primary', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(71062, 2, '空港', '2', 'BASE_PORT_TYPE', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(71063, 3, '内陆港', '3', 'BASE_PORT_TYPE', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0');

-- BASE_PLATFORM_ADDRESS_TYPE（address_type 1~4）
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(71071, 1, 'FBA', '1', 'BASE_PLATFORM_ADDRESS_TYPE', 0, 'primary', '', 'mock 已用', 'admin', NOW(), 'admin', NOW(), b'0'),
(71072, 2, '门店', '2', 'BASE_PLATFORM_ADDRESS_TYPE', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(71073, 3, '配送中心', '3', 'BASE_PLATFORM_ADDRESS_TYPE', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(71074, 4, '其他', '4', 'BASE_PLATFORM_ADDRESS_TYPE', 0, 'default', '', 'mock 已用', 'admin', NOW(), 'admin', NOW(), b'0');

-- MDM_PACKAGING_TYPE（pkg_type 1~5）
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(71081, 1, '纸箱', '1', 'MDM_PACKAGING_TYPE', 0, 'primary', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(71082, 2, '气泡袋', '2', 'MDM_PACKAGING_TYPE', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(71083, 3, '塑料袋', '3', 'MDM_PACKAGING_TYPE', 0, 'info', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(71084, 4, '木箱', '4', 'MDM_PACKAGING_TYPE', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(71085, 5, '其他', '5', 'MDM_PACKAGING_TYPE', 0, 'default', '', '', 'admin', NOW(), 'admin', NOW(), b'0');

-- MDM_PACKAGING_SOURCE_TYPE（source_type 1~3）
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(71091, 1, '仓库自有', '1', 'MDM_PACKAGING_SOURCE_TYPE', 0, 'primary', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(71092, 2, '客户提供', '2', 'MDM_PACKAGING_SOURCE_TYPE', 0, 'success', '', 'mock 已用', 'admin', NOW(), 'admin', NOW(), b'0'),
(71093, 3, '供应商采购', '3', 'MDM_PACKAGING_SOURCE_TYPE', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0');

-- MDM_DIMENSION_UNIT
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(71101, 1, '厘米 CM', 'CM', 'MDM_DIMENSION_UNIT', 0, 'primary', '', '默认', 'admin', NOW(), 'admin', NOW(), b'0'),
(71102, 2, '英寸 IN', 'IN', 'MDM_DIMENSION_UNIT', 0, 'info', '', '', 'admin', NOW(), 'admin', NOW(), b'0');

-- MDM_WEIGHT_UNIT
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(71111, 1, '千克 KG', 'KG', 'MDM_WEIGHT_UNIT', 0, 'primary', '', '默认', 'admin', NOW(), 'admin', NOW(), b'0'),
(71112, 2, '磅 LB', 'LB', 'MDM_WEIGHT_UNIT', 0, 'info', '', '', 'admin', NOW(), 'admin', NOW(), b'0');

-- BASE_PLATFORM_ADDRESS_CHANGE_TYPE
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(71121, 1, '新建', 'CREATE', 'BASE_PLATFORM_ADDRESS_CHANGE_TYPE', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(71122, 2, '修改', 'UPDATE', 'BASE_PLATFORM_ADDRESS_CHANGE_TYPE', 0, 'primary', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(71123, 3, '状态变更', 'STATUS_CHANGE', 'BASE_PLATFORM_ADDRESS_CHANGE_TYPE', 0, 'warning', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(71124, 4, '导入', 'IMPORT', 'BASE_PLATFORM_ADDRESS_CHANGE_TYPE', 0, 'info', '', '', 'admin', NOW(), 'admin', NOW(), b'0');

-- BASE_YES_NO（整型 0/1，用于 is_weigh_station、is_system、is_current 等）
INSERT INTO `system_dict_data` (`id`, `sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(71131, 1, '否', '0', 'BASE_YES_NO', 0, 'info', '', '', 'admin', NOW(), 'admin', NOW(), b'0'),
(71132, 2, '是', '1', 'BASE_YES_NO', 0, 'success', '', '', 'admin', NOW(), 'admin', NOW(), b'0');
