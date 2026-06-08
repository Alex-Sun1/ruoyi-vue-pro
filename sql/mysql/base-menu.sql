-- 基础资料（BASE）菜单与权限
-- 库：overseas（或你的业务库）
-- 执行前请确认 ID 不冲突：SELECT MAX(id) FROM system_menu;
-- 本脚本菜单 ID 从 6700 起；若库中已有更大 ID，请整体偏移后再执行
-- 执行后：系统管理 → 角色管理 → 为角色勾选「基础资料」菜单（超级管理员 tenant_id=1 通常 role_id=1）

SET NAMES utf8mb4;

-- ========== 一级：基础资料 ==========
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
VALUES (6700, '基础资料', '', 1, 50, 0, '/base', 'ep:collection', NULL, NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');

-- ========== 二级：分组目录 ==========
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(6710, '地理资料', '', 1, 1, 6700, 'geo', 'ep:location', NULL, NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6720, '时区资料', '', 1, 2, 6700, 'tz', 'ep:clock', NULL, NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6730, '币种资料', '', 1, 3, 6700, 'currency-group', 'ep:money', NULL, NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6740, '平台资料', '', 1, 4, 6700, 'platform-group', 'ep:shop', NULL, NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6750, '运输资料', '', 1, 5, 6700, 'transport', 'ep:ship', NULL, NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6760, '组织资料', '', 1, 6, 6700, 'org', 'ep:office-building', NULL, NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6770, '商品资料', '', 1, 7, 6700, 'product', 'ep:goods', NULL, NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6780, '财务资料', '', 1, 8, 6700, 'finance', 'ep:wallet', NULL, NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');

-- ========== 三级：页面菜单（type=2）==========
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(6711, '国家管理', 'base:data:view', 2, 1, 6710, 'country', 'ep:flag', 'base/country/index', 'BaseCountry', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6712, '州/省管理', 'base:data:view', 2, 2, 6710, 'state', 'ep:map-location', 'base/state/index', 'BaseState', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6713, '城市管理', 'base:data:view', 2, 3, 6710, 'city', 'ep:place', 'base/city/index', 'BaseCity', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6714, '邮编库', 'base:data:view', 2, 4, 6710, 'zipcode', 'ep:postcard', 'base/zipcode/index', 'BaseZipcode', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6721, '时区管理', 'base:data:view', 2, 1, 6720, 'timezone', 'ep:clock', 'base/timezone/index', 'BaseTimezone', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6731, '币种管理', 'base:data:view', 2, 1, 6730, 'currency', 'ep:money', 'base/currency/index', 'BaseCurrency', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6732, '汇率配置', 'base:exchange-rate:manage', 2, 2, 6730, 'exchange-rate', 'ep:trend-charts', 'base/exchange-rate/index', 'BaseExchangeRate', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6741, '平台管理', 'base:data:view', 2, 1, 6740, 'platform', 'ep:platform', 'base/platform/index', 'BasePlatform', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6742, '平台地址库', 'base:data:view', 2, 2, 6740, 'platform-address', 'ep:location-information', 'base/platform-address/index', 'BasePlatformAddress', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6751, '港口管理', 'base:data:view', 2, 1, 6750, 'port', 'ep:ship', 'base/port/index', 'BasePort', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6752, '船司管理', 'base:data:view', 2, 2, 6750, 'shipping-line', 'ep:van', 'base/shipping-line/index', 'BaseShippingLine', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6761, '主体管理', 'base:company:query', 2, 1, 6760, 'company', 'ep:office-building', 'base/company/index', 'BaseCompany', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6762, '仓库管理', 'base:warehouse:query', 2, 2, 6760, 'warehouse', 'ep:house', 'base/warehouse/index', 'BaseWarehouse', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6771, 'SKU 管理', 'base:data:view', 2, 1, 6770, 'sku', 'ep:box', 'base/sku/index', 'BaseSku', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6781, '费项管理', 'base:data:view', 2, 1, 6780, 'fee-item', 'ep:coin', 'base/fee-item/index', 'BaseFeeItem', 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');

-- ========== 四级：通用按钮（挂在「国家管理」下，全模块共用 base:data:*）==========
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(6791, '基础资料-查看', 'base:data:view', 3, 1, 6711, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6792, '基础资料-编辑', 'base:data:edit', 3, 2, 6711, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6793, '基础资料-删除', 'base:data:delete', 3, 3, 6711, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6794, '基础资料-导入', 'base:data:import', 3, 4, 6711, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6795, '基础资料-导出', 'base:data:export', 3, 5, 6711, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');

-- ========== 主体 / 仓库 / 汇率 专用按钮 ==========
INSERT INTO `system_menu` (`id`, `name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`, `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
(6796, '汇率管理', 'base:exchange-rate:manage', 3, 1, 6732, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6797, '主体新增', 'base:company:create', 3, 1, 6761, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6798, '主体修改', 'base:company:update', 3, 2, 6761, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6799, '主体删除', 'base:company:delete', 3, 3, 6761, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6800, '主体导出', 'base:company:export', 3, 4, 6761, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6801, '仓库新增', 'base:warehouse:create', 3, 1, 6762, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6802, '仓库修改', 'base:warehouse:update', 3, 2, 6762, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6803, '仓库删除', 'base:warehouse:delete', 3, 3, 6762, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0'),
(6804, '仓库导出', 'base:warehouse:export', 3, 4, 6762, '', '', '', NULL, 0, b'1', b'1', b'1', 'admin', NOW(), 'admin', NOW(), b'0');

-- ========== 可选：为超级管理员角色（role_id=1）授权全部基础资料菜单 ==========
-- INSERT INTO `system_role_menu` (`role_id`, `menu_id`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`)
-- SELECT 1, id, 'admin', NOW(), 'admin', NOW(), b'0', 1 FROM `system_menu` WHERE id BETWEEN 6700 AND 6804;
