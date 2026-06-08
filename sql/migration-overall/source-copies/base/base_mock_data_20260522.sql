-- =============================================
-- 海外仓系统 — 基础资料模块 模拟数据
-- 生成日期：2026-05-22
-- 说明：仅用于开发/测试，生产环境请勿执行
-- tenant_id 统一使用 '000000'（系统默认租户）
-- 所有 INSERT 使用 INSERT IGNORE 保证幂等
-- =============================================

-- =============================================
-- 平台管理（platform）
-- 注意：platform.create_by 为 BIGINT，用 1（admin用户ID）
-- =============================================
INSERT IGNORE INTO `platform` (id, tenant_id, code, name_en, type_code, status, sort_order, remark, create_by, create_time, update_by, update_time, del_flag)
VALUES
(2000001, '000000', 'AMAZON',   'Amazon',          'ECOMMERCE',        '0', 1, '全球最大电商平台',   1, NOW(), NULL, NULL, 0),
(2000002, '000000', 'WALMART',  'Walmart',          'ECOMMERCE',        '0', 2, '美国本土零售巨头',   1, NOW(), NULL, NULL, 0),
(2000003, '000000', 'SHOPIFY',  'Shopify',          'INDEPENDENT_SITE', '0', 3, 'SaaS独立站平台',    1, NOW(), NULL, NULL, 0),
(2000004, '000000', 'TEMU',     'Temu',             'ECOMMERCE',        '0', 4, 'PDD旗下跨境电商',   1, NOW(), NULL, NULL, 0),
(2000005, '000000', 'SHEIN',    'Shein',            'INDEPENDENT_SITE', '0', 5, '快时尚跨境平台',    1, NOW(), NULL, NULL, 0);

-- =============================================
-- 平台地址（platform_address）
-- 注意：create_by 为 BIGINT，用 1
-- =============================================
INSERT IGNORE INTO `platform_address` (id, tenant_id, platform_id, address_code, address_type, name_en, country_code, state_code, city, address_line1, zip_code, unit_pallet_cbm, status, remark, create_by, update_by, del_flag)
VALUES
-- Amazon FBA 仓
(2001001, '000000', 2000001, 'ONT8',     1, 'Amazon FBA ONT8 - Ontario CA',          'US', 'CA', 'Ontario',      '2020 E Central Ave',         '91764', 2.000, '0', 'FBA仓库', 1, NULL, 0),
(2001002, '000000', 2000001, 'LAX9',     1, 'Amazon FBA LAX9 - Moreno Valley CA',    'US', 'CA', 'Moreno Valley','24208 San Michele Rd',        '92551', 2.000, '0', 'FBA仓库', 1, NULL, 0),
(2001003, '000000', 2000001, 'EWR4',     1, 'Amazon FBA EWR4 - Avenel NJ',           'US', 'NJ', 'Avenel',       '50 New Canton Way',           '07001', 2.000, '0', 'FBA仓库', 1, NULL, 0),
(2001004, '000000', 2000001, 'ORD2',     1, 'Amazon FBA ORD2 - Joliet IL',           'US', 'IL', 'Joliet',       '1 Centerpoint Blvd',          '60436', 2.000, '0', 'FBA仓库', 1, NULL, 0),
(2001005, '000000', 2000001, 'IAH1',     1, 'Amazon FBA IAH1 - Houston TX',          'US', 'TX', 'Houston',      '20900 Lucerne Dr',            '77049', 2.000, '0', 'FBA仓库', 1, NULL, 0),
-- Walmart 配送中心
(2001006, '000000', 2000002, 'WM-DC-CA', 3, 'Walmart Distribution Center - Chino CA','US', 'CA', 'Chino',        '14699 Central Ave',           '91710', 2.000, '0', '配送中心', 1, NULL, 0),
(2001007, '000000', 2000002, 'WM-DC-NJ', 3, 'Walmart Distribution Center - Secaucus','US', 'NJ', 'Secaucus',     '300 Meadowlands Pkwy',        '07094', 2.000, '0', '配送中心', 1, NULL, 0);

-- =============================================
-- 国家（country）
-- create_by 为 varchar(64)，用 1
-- =============================================
INSERT IGNORE INTO `country` (id, tenant_id, code, name_en, phone_code, currency_code, timezone_default, is_active, sort_order, create_by, create_time, update_by, update_time, del_flag)
VALUES
(3000001, '000000', 'US', 'United States',    '+1',   'USD', 'America/New_York',      1,  1, 1, NOW(), NULL, NULL, 0),
(3000002, '000000', 'CN', 'China',            '+86',  'CNY', 'Asia/Shanghai',         1,  2, 1, NOW(), NULL, NULL, 0),
(3000003, '000000', 'DE', 'Germany',          '+49',  'EUR', 'Europe/Berlin',         1,  3, 1, NOW(), NULL, NULL, 0),
(3000004, '000000', 'GB', 'United Kingdom',   '+44',  'GBP', 'Europe/London',         1,  4, 1, NOW(), NULL, NULL, 0),
(3000005, '000000', 'JP', 'Japan',            '+81',  'JPY', 'Asia/Tokyo',            1,  5, 1, NOW(), NULL, NULL, 0),
(3000006, '000000', 'CA', 'Canada',           '+1',   'CAD', 'America/Toronto',       1,  6, 1, NOW(), NULL, NULL, 0),
(3000007, '000000', 'AU', 'Australia',        '+61',  'AUD', 'Australia/Sydney',      1,  7, 1, NOW(), NULL, NULL, 0),
(3000008, '000000', 'MX', 'Mexico',           '+52',  'MXN', 'America/Mexico_City',   1,  8, 1, NOW(), NULL, NULL, 0),
(3000009, '000000', 'FR', 'France',           '+33',  'EUR', 'Europe/Paris',          1,  9, 1, NOW(), NULL, NULL, 0),
(3000010, '000000', 'NL', 'Netherlands',      '+31',  'EUR', 'Europe/Amsterdam',      1, 10, 1, NOW(), NULL, NULL, 0);

-- =============================================
-- 州/省（state_province）
-- =============================================
INSERT IGNORE INTO `state_province` (id, tenant_id, country_code, code, name_en, sort_order, status, create_by, create_time, update_by, update_time, del_flag)
VALUES
-- 美国主要州
(3001001, '000000', 'US', 'CA', 'California',    1,  '0', 1, NOW(), NULL, NULL, 0),
(3001002, '000000', 'US', 'NY', 'New York',      2,  '0', 1, NOW(), NULL, NULL, 0),
(3001003, '000000', 'US', 'TX', 'Texas',         3,  '0', 1, NOW(), NULL, NULL, 0),
(3001004, '000000', 'US', 'FL', 'Florida',       4,  '0', 1, NOW(), NULL, NULL, 0),
(3001005, '000000', 'US', 'IL', 'Illinois',      5,  '0', 1, NOW(), NULL, NULL, 0),
(3001006, '000000', 'US', 'NJ', 'New Jersey',    6,  '0', 1, NOW(), NULL, NULL, 0),
(3001007, '000000', 'US', 'WA', 'Washington',    7,  '0', 1, NOW(), NULL, NULL, 0),
(3001008, '000000', 'US', 'GA', 'Georgia',       8,  '0', 1, NOW(), NULL, NULL, 0),
(3001009, '000000', 'US', 'PA', 'Pennsylvania',  9,  '0', 1, NOW(), NULL, NULL, 0),
(3001010, '000000', 'US', 'OH', 'Ohio',          10, '0', 1, NOW(), NULL, NULL, 0),
-- 中国主要省市
(3001011, '000000', 'CN', 'GD', 'Guangdong',     1,  '0', 1, NOW(), NULL, NULL, 0),
(3001012, '000000', 'CN', 'ZJ', 'Zhejiang',      2,  '0', 1, NOW(), NULL, NULL, 0),
(3001013, '000000', 'CN', 'JS', 'Jiangsu',       3,  '0', 1, NOW(), NULL, NULL, 0),
(3001014, '000000', 'CN', 'SH', 'Shanghai',      4,  '0', 1, NOW(), NULL, NULL, 0),
(3001015, '000000', 'CN', 'BJ', 'Beijing',       5,  '0', 1, NOW(), NULL, NULL, 0);

-- =============================================
-- 城市（city）
-- =============================================
INSERT IGNORE INTO `city` (id, tenant_id, country_code, state_code, name_en, status, create_by, create_time, update_by, update_time, del_flag)
VALUES
-- 美国加州
(3002001, '000000', 'US', 'CA', 'Los Angeles',    '0', 1, NOW(), NULL, NULL, 0),
(3002002, '000000', 'US', 'CA', 'San Francisco',  '0', 1, NOW(), NULL, NULL, 0),
(3002003, '000000', 'US', 'CA', 'San Diego',      '0', 1, NOW(), NULL, NULL, 0),
(3002004, '000000', 'US', 'CA', 'Ontario',        '0', 1, NOW(), NULL, NULL, 0),
(3002005, '000000', 'US', 'CA', 'Long Beach',     '0', 1, NOW(), NULL, NULL, 0),
-- 美国纽约
(3002006, '000000', 'US', 'NY', 'New York City',  '0', 1, NOW(), NULL, NULL, 0),
(3002007, '000000', 'US', 'NY', 'Buffalo',        '0', 1, NOW(), NULL, NULL, 0),
-- 美国德州
(3002008, '000000', 'US', 'TX', 'Houston',        '0', 1, NOW(), NULL, NULL, 0),
(3002009, '000000', 'US', 'TX', 'Dallas',         '0', 1, NOW(), NULL, NULL, 0),
-- 美国佛州
(3002010, '000000', 'US', 'FL', 'Miami',          '0', 1, NOW(), NULL, NULL, 0),
(3002011, '000000', 'US', 'FL', 'Orlando',        '0', 1, NOW(), NULL, NULL, 0),
-- 美国新泽西
(3002012, '000000', 'US', 'NJ', 'Newark',         '0', 1, NOW(), NULL, NULL, 0),
(3002013, '000000', 'US', 'NJ', 'Jersey City',    '0', 1, NOW(), NULL, NULL, 0),
-- 中国广东
(3002014, '000000', 'CN', 'GD', 'Guangzhou',      '0', 1, NOW(), NULL, NULL, 0),
(3002015, '000000', 'CN', 'GD', 'Shenzhen',       '0', 1, NOW(), NULL, NULL, 0),
(3002016, '000000', 'CN', 'GD', 'Dongguan',       '0', 1, NOW(), NULL, NULL, 0),
-- 中国上海
(3002017, '000000', 'CN', 'SH', 'Shanghai',       '0', 1, NOW(), NULL, NULL, 0),
-- 中国浙江
(3002018, '000000', 'CN', 'ZJ', 'Hangzhou',       '0', 1, NOW(), NULL, NULL, 0),
(3002019, '000000', 'CN', 'ZJ', 'Ningbo',         '0', 1, NOW(), NULL, NULL, 0);

-- =============================================
-- 时区（timezone）
-- =============================================
INSERT IGNORE INTO `timezone` (id, tenant_id, tz_code, name_en, utc_offset, country_code, is_dst, status, sort_order, create_by, create_time, update_by, update_time, del_flag)
VALUES
(3003001, '000000', 'UTC',                  'Coordinated Universal Time', 'UTC+0',   NULL, 0, '0',  1, 1, NOW(), NULL, NULL, 0),
(3003002, '000000', 'America/Los_Angeles',  'Pacific Time',               'UTC-8',   'US', 1, '0',  2, 1, NOW(), NULL, NULL, 0),
(3003003, '000000', 'America/Denver',       'Mountain Time',              'UTC-7',   'US', 1, '0',  3, 1, NOW(), NULL, NULL, 0),
(3003004, '000000', 'America/Chicago',      'Central Time',               'UTC-6',   'US', 1, '0',  4, 1, NOW(), NULL, NULL, 0),
(3003005, '000000', 'America/New_York',     'Eastern Time',               'UTC-5',   'US', 1, '0',  5, 1, NOW(), NULL, NULL, 0),
(3003006, '000000', 'America/Toronto',      'Eastern Time (Canada)',       'UTC-5',   'CA', 1, '0',  6, 1, NOW(), NULL, NULL, 0),
(3003007, '000000', 'America/Mexico_City',  'Central Time (Mexico)',       'UTC-6',   'MX', 1, '0',  7, 1, NOW(), NULL, NULL, 0),
(3003008, '000000', 'Europe/London',        'Greenwich Mean Time',         'UTC+0',   'GB', 1, '0',  8, 1, NOW(), NULL, NULL, 0),
(3003009, '000000', 'Europe/Berlin',        'Central European Time',       'UTC+1',   'DE', 1, '0',  9, 1, NOW(), NULL, NULL, 0),
(3003010, '000000', 'Europe/Amsterdam',     'Central European Time',       'UTC+1',   'NL', 1, '0', 10, 1, NOW(), NULL, NULL, 0),
(3003011, '000000', 'Europe/Paris',         'Central European Time',       'UTC+1',   'FR', 1, '0', 11, 1, NOW(), NULL, NULL, 0),
(3003012, '000000', 'Asia/Shanghai',        'China Standard Time',         'UTC+8',   'CN', 0, '0', 12, 1, NOW(), NULL, NULL, 0),
(3003013, '000000', 'Asia/Tokyo',           'Japan Standard Time',         'UTC+9',   'JP', 0, '0', 13, 1, NOW(), NULL, NULL, 0),
(3003014, '000000', 'Australia/Sydney',     'Australian Eastern Time',     'UTC+10',  'AU', 1, '0', 14, 1, NOW(), NULL, NULL, 0);

-- =============================================
-- 币种（currency）
-- =============================================
INSERT IGNORE INTO `currency` (id, tenant_id, code, name_en, symbol, decimal_places, is_base, status, sort_order, create_by, create_time, update_by, update_time, del_flag)
VALUES
(3004001, '000000', 'USD', 'US Dollar',          '$',   2, 1, '0', 1, 1, NOW(), NULL, NULL, 0),
(3004002, '000000', 'CNY', 'Chinese Yuan',        '¥',   2, 0, '0', 2, 1, NOW(), NULL, NULL, 0),
(3004003, '000000', 'EUR', 'Euro',                '€',   2, 0, '0', 3, 1, NOW(), NULL, NULL, 0),
(3004004, '000000', 'GBP', 'British Pound',       '£',   2, 0, '0', 4, 1, NOW(), NULL, NULL, 0),
(3004005, '000000', 'JPY', 'Japanese Yen',        '¥',   0, 0, '0', 5, 1, NOW(), NULL, NULL, 0),
(3004006, '000000', 'CAD', 'Canadian Dollar',     'CA$', 2, 0, '0', 6, 1, NOW(), NULL, NULL, 0),
(3004007, '000000', 'AUD', 'Australian Dollar',   'A$',  2, 0, '0', 7, 1, NOW(), NULL, NULL, 0),
(3004008, '000000', 'MXN', 'Mexican Peso',        '$',   2, 0, '0', 8, 1, NOW(), NULL, NULL, 0);

-- =============================================
-- 汇率（exchange_rate）
-- 基准货币 USD，记录 USD 兑各币种当前汇率
-- exchange_rate 表无 del_flag（实体无 @TableLogic）
-- =============================================
INSERT IGNORE INTO `exchange_rate` (id, tenant_id, from_currency, to_currency, rate, effective_date, expired_date, is_current, remark, create_by, create_time, update_by, update_time)
VALUES
(3005001, '000000', 'USD', 'CNY', 7.25000000,  '2026-01-01', NULL, 1, '参考汇率（非实时）', 1, NOW(), NULL, NULL),
(3005002, '000000', 'USD', 'EUR', 0.92000000,  '2026-01-01', NULL, 1, '参考汇率（非实时）', 1, NOW(), NULL, NULL),
(3005003, '000000', 'USD', 'GBP', 0.79000000,  '2026-01-01', NULL, 1, '参考汇率（非实时）', 1, NOW(), NULL, NULL),
(3005004, '000000', 'USD', 'JPY', 151.50000000,'2026-01-01', NULL, 1, '参考汇率（非实时）', 1, NOW(), NULL, NULL),
(3005005, '000000', 'USD', 'CAD', 1.36000000,  '2026-01-01', NULL, 1, '参考汇率（非实时）', 1, NOW(), NULL, NULL),
(3005006, '000000', 'USD', 'AUD', 1.52000000,  '2026-01-01', NULL, 1, '参考汇率（非实时）', 1, NOW(), NULL, NULL),
(3005007, '000000', 'USD', 'MXN', 17.15000000, '2026-01-01', NULL, 1, '参考汇率（非实时）', 1, NOW(), NULL, NULL);

-- =============================================
-- 港口（port）
-- =============================================
INSERT IGNORE INTO `port` (id, tenant_id, port_code, name_en, country_code, state_code, city, port_type, timezone, status, sort_order, remark, create_by, create_time, update_by, update_time, del_flag)
VALUES
-- 美国港口
(3006001, '000000', 'USLAX', 'Port of Los Angeles',          'US', 'CA', 'Los Angeles',   1, 'America/Los_Angeles', '0',  1, '全美最大集装箱港', 1, NOW(), NULL, NULL, 0),
(3006002, '000000', 'USLGB', 'Port of Long Beach',           'US', 'CA', 'Long Beach',    1, 'America/Los_Angeles', '0',  2, NULL,              1, NOW(), NULL, NULL, 0),
(3006003, '000000', 'USNYC', 'Port of New York & New Jersey','US', 'NJ', 'Newark',         1, 'America/New_York',    '0',  3, '东海岸最大港', 1, NOW(), NULL, NULL, 0),
(3006004, '000000', 'USSEA', 'Port of Seattle',              'US', 'WA', 'Seattle',        1, 'America/Los_Angeles', '0',  4, NULL,              1, NOW(), NULL, NULL, 0),
(3006005, '000000', 'USHOU', 'Port of Houston',              'US', 'TX', 'Houston',        1, 'America/Chicago',     '0',  5, NULL,              1, NOW(), NULL, NULL, 0),
-- 中国港口
(3006006, '000000', 'CNSHA', 'Port of Shanghai',             'CN', 'SH', 'Shanghai',      1, 'Asia/Shanghai',       '0',  6, '全球最大集装箱港',   1, NOW(), NULL, NULL, 0),
(3006007, '000000', 'CNSZX', 'Port of Shenzhen (Yantian)',   'CN', 'GD', 'Shenzhen',      1, 'Asia/Shanghai',       '0',  7, NULL,              1, NOW(), NULL, NULL, 0),
(3006008, '000000', 'CNGZU', 'Port of Guangzhou (Nansha)',   'CN', 'GD', 'Guangzhou',     1, 'Asia/Shanghai',       '0',  8, NULL,              1, NOW(), NULL, NULL, 0),
(3006009, '000000', 'CNNBO', 'Port of Ningbo-Zhoushan',      'CN', 'ZJ', 'Ningbo',        1, 'Asia/Shanghai',       '0',  9, '全球第一吞吐量港口', 1, NOW(), NULL, NULL, 0),
-- 欧洲港口
(3006010, '000000', 'DEHAM', 'Port of Hamburg',              'DE', NULL, 'Hamburg',       1, 'Europe/Berlin',       '0', 10, '欧洲最大港', 1, NOW(), NULL, NULL, 0),
(3006011, '000000', 'NLRTM', 'Port of Rotterdam',            'NL', NULL, 'Rotterdam',     1, 'Europe/Amsterdam',    '0', 11, '欧洲最繁忙港口', 1, NOW(), NULL, NULL, 0),
(3006012, '000000', 'GBSOU', 'Port of Southampton',          'GB', NULL, 'Southampton',   1, 'Europe/London',       '0', 12, NULL,              1, NOW(), NULL, NULL, 0);

-- =============================================
-- 船司（shipping_line）
-- =============================================
INSERT IGNORE INTO `shipping_line` (id, tenant_id, code, name_en, name_abbr, country_code, website, tracking_url, status, sort_order, create_by, create_time, update_by, update_time, del_flag)
VALUES
(3007001, '000000', 'MSCU', 'Mediterranean Shipping Company',   'MSC',       'CH', 'https://www.msc.com',             'https://www.msc.com/en/track-a-shipment?searchValue={container_no}',                                                             '0', 1, 1, NOW(), NULL, NULL, 0),
(3007002, '000000', 'MAEU', 'Maersk Line',                      'Maersk',    'DK', 'https://www.maersk.com',          'https://www.maersk.com/tracking/{container_no}',                                                                               '0', 2, 1, NOW(), NULL, NULL, 0),
(3007003, '000000', 'COSU', 'COSCO Shipping Lines',             'COSCO',     'CN', 'https://www.cosco.com',           'https://elines.coscoshipping.com/ebusiness/cargoTracking?trackingType=CONTAINER&number={container_no}',                         '0', 3, 1, NOW(), NULL, NULL, 0),
(3007004, '000000', 'EGLV', 'Evergreen Marine Corporation',     'Evergreen', 'TW', 'https://www.evergreen-marine.com','https://www.evergreen-marine.com/ct/lns0120F.do?shpbkgNo={container_no}',                                                      '0', 4, 1, NOW(), NULL, NULL, 0),
(3007005, '000000', 'HLCU', 'Hapag-Lloyd AG',                   'Hapag',     'DE', 'https://www.hapag-lloyd.com',     'https://www.hapag-lloyd.com/en/online-business/tracing/tracing-by-container.html?container={container_no}',                     '0', 5, 1, NOW(), NULL, NULL, 0),
(3007006, '000000', 'OOLU', 'Orient Overseas Container Line',   'OOCL',      'HK', 'https://www.oocl.com',            'https://www.oocl.com/eng/ourservices/eservices/cargotracking/Pages/cargotracking.aspx',                                         '0', 6, 1, NOW(), NULL, NULL, 0),
(3007007, '000000', 'YMLU', 'Yang Ming Marine Transport Corp',  'Yang Ming', 'TW', 'https://www.yangming.com',        'https://www.yangming.com/e-service/schedule_inquiry/cargo_tracking.aspx',                                                       '0', 7, 1, NOW(), NULL, NULL, 0),
(3007008, '000000', 'ZIMU', 'Zim Integrated Shipping Services', 'Zim',       'IL', 'https://www.zim.com',             'https://www.zim.com/tools/track-a-shipment?consnumber={container_no}',                                                          '0', 8, 1, NOW(), NULL, NULL, 0);

-- =============================================
-- 邮编库（zip_code）— 常用美国邮编样本
-- =============================================
INSERT IGNORE INTO `zip_code` (id, tenant_id, country_code, state_code, city_name, zip, create_by, create_time, update_by, update_time, del_flag)
VALUES
(3008001, '000000', 'US', 'CA', 'Los Angeles',       '90001', 1, NOW(), NULL, NULL, 0),
(3008002, '000000', 'US', 'CA', 'Los Angeles',       '90011', 1, NOW(), NULL, NULL, 0),
(3008003, '000000', 'US', 'CA', 'Compton',           '90220', 1, NOW(), NULL, NULL, 0),
(3008004, '000000', 'US', 'CA', 'Ontario',           '91764', 1, NOW(), NULL, NULL, 0),
(3008005, '000000', 'US', 'CA', 'Moreno Valley',     '92551', 1, NOW(), NULL, NULL, 0),
(3008006, '000000', 'US', 'CA', 'San Francisco',     '94102', 1, NOW(), NULL, NULL, 0),
(3008007, '000000', 'US', 'NY', 'New York',          '10001', 1, NOW(), NULL, NULL, 0),
(3008008, '000000', 'US', 'NY', 'New York',          '10019', 1, NOW(), NULL, NULL, 0),
(3008009, '000000', 'US', 'TX', 'Houston',           '77001', 1, NOW(), NULL, NULL, 0),
(3008010, '000000', 'US', 'TX', 'Houston',           '77049', 1, NOW(), NULL, NULL, 0),
(3008011, '000000', 'US', 'TX', 'Dallas',            '75201', 1, NOW(), NULL, NULL, 0),
(3008012, '000000', 'US', 'FL', 'Miami',             '33101', 1, NOW(), NULL, NULL, 0),
(3008013, '000000', 'US', 'FL', 'Orlando',           '32801', 1, NOW(), NULL, NULL, 0),
(3008014, '000000', 'US', 'NJ', 'Newark',            '07102', 1, NOW(), NULL, NULL, 0),
(3008015, '000000', 'US', 'NJ', 'Avenel',            '07001', 1, NOW(), NULL, NULL, 0),
(3008016, '000000', 'US', 'NJ', 'Jersey City',       '07302', 1, NOW(), NULL, NULL, 0),
(3008017, '000000', 'US', 'NJ', 'Secaucus',          '07094', 1, NOW(), NULL, NULL, 0),
(3008018, '000000', 'US', 'IL', 'Chicago',           '60601', 1, NOW(), NULL, NULL, 0),
(3008019, '000000', 'US', 'IL', 'Joliet',            '60436', 1, NOW(), NULL, NULL, 0),
(3008020, '000000', 'US', 'WA', 'Seattle',           '98101', 1, NOW(), NULL, NULL, 0);

-- =============================================
-- 主体（mdm_company）
-- =============================================
INSERT IGNORE INTO `mdm_company` (id, tenant_id, company_code, company_name, country_code, registered_addr, currency_code, timezone, status, remark, create_by, create_time, update_by, update_time, del_flag)
VALUES
(4000001, '000000', 'EXAMPLE-US', 'Example Overseas Logistics LLC', 'US', '2525 E Slauson Ave, Los Angeles, CA 90058', 'USD', 'America/Los_Angeles', '0', '自营美国主体', 1, NOW(), 1, NOW(), 0),
(4000002, '000000', 'EXAMPLE-CN', '示例供应链有限公司', 'CN', '广东省深圳市南山区科技园南路10号 518057', 'CNY', 'Asia/Shanghai', '0', '国内供应商主体', 1, NOW(), 1, NOW(), 0);

-- =============================================
-- 仓库（mdm_warehouse）
-- =============================================
INSERT IGNORE INTO `mdm_warehouse` (id, tenant_id, company_id, warehouse_code, warehouse_name, warehouse_type, country_code, state_code, city, address, zip_code, timezone, currency_code, contact_name, contact_phone, is_bonded, operation_start_time, operation_end_time, support_unloading, support_dropship, support_transit, support_transfer, support_fba, support_self_pickup, support_appointment, max_capacity_cbm, daily_unloading_cap, daily_outbound_cap, dock_count, door_count, forklift_count, pda_enabled, api_enabled, status, remark, create_by, create_time, update_by, update_time, del_flag)
VALUES
(4001001, '000000', 4000001, 'LA01', 'Los Angeles Central Warehouse',    'SELF_OP', 'US', 'CA', 'Los Angeles', '2525 E Slauson Ave',    '90058', 'America/Los_Angeles', 'USD', 'John Smith', '+1-310-555-0100', 0, '08:00', '18:00', 1, 1, 1, 1, 1, 1, 1, 5000.00, 20, 500, 8, 4, 6, 1, 0, '0', '洛杉矶中心仓，支持全品类', 1, NOW(), 1, NOW(), 0),
(4001002, '000000', 4000001, 'NJ01', 'New Jersey East Coast Warehouse',  'SELF_OP', 'US', 'NJ', 'Newark',      '50 Industrial Pkwy',    '07102', 'America/New_York',    'USD', 'Jane Doe',   '+1-973-555-0200', 0, '07:00', '19:00', 1, 1, 1, 1, 1, 0, 1, 3000.00, 15, 300, 6, 3, 4, 1, 0, '0', '新泽西东海岸仓',           1, NOW(), 1, NOW(), 0),
(4001003, '000000', 4000001, 'TX01', 'Texas Central Hub',                'PARTNER', 'US', 'TX', 'Houston',     '1234 Shipping Lane',    '77001', 'America/Chicago',     'USD', 'Bob Chen',   '+1-713-555-0300', 0, '08:00', '17:00', 0, 1, 1, 1, 0, 0, 0, 2000.00, 10, 200, 4, 2, 3, 0, 0, '0', '德克萨斯合作中转枢纽',      1, NOW(), 1, NOW(), 0);

-- =============================================
-- SKU（mdm_sku）
-- client_id 暂用主体ID，待 mdm_client 建成后更新
-- =============================================
INSERT IGNORE INTO `mdm_sku` (id, tenant_id, client_id, sku_code, sku_name, sku_name_en, barcode, brand, model, color, unit, length_cm, width_cm, height_cm, weight_kg, volume_cbm, is_fragile, is_liquid, is_battery, is_magnetic, is_dangerous, is_oversize, declared_name_cn, declared_name_en, hs_code, declared_value, declared_currency, origin_country_code, status, remark, create_by, create_time, update_by, update_time, del_flag)
VALUES
(4002001, '000000', 4000001, 'BT-ANC-001',    '蓝牙降噪耳机 Pro',         'Bluetooth ANC Headphone Pro',    '012345000001', 'SoundMax',   'SM-ANC01',  '黑色', 'pcs', 20.0, 18.0,  8.0, 0.350, 0.002880, 0, 0, 1, 0, 0, 0, '无线蓝牙耳机', 'Bluetooth Headphone',     '8518300000', 35.00, 'USD', 'CN', '0', '含锂电池，走纯电池渠道', 1, NOW(), 1, NOW(), 0),
(4002002, '000000', 4000001, 'PH-CASE-002',   '手机保护壳 iPhone 15 Pro', 'Phone Case for iPhone 15 Pro',   '012345000002', 'SafeGuard',  'SC-15P',    '透明', 'pcs', 15.0,  8.0,  1.5, 0.080, 0.000180, 0, 0, 0, 0, 0, 0, '手机保护壳',   'Phone Protective Case',   '3926909090',  5.00, 'USD', 'CN', '0', NULL, 1, NOW(), 1, NOW(), 0),
(4002003, '000000', 4000001, 'LED-STRIP-003', 'LED灯带 5米 RGB',          'LED Strip Light 5M RGB',          '012345000003', 'BrightTech', 'BT-LED5M',  NULL,   'pcs', 50.0,  5.0,  5.0, 0.200, 0.001250, 0, 0, 0, 1, 0, 0, 'LED灯带',      'LED Strip Light',         '8539500000', 12.00, 'USD', 'CN', '0', '带磁，部分渠道限制', 1, NOW(), 1, NOW(), 0),
(4002004, '000000', 4000001, 'USB-HUB-004',   'USB-C 集线器 7合1',        'USB-C Hub 7-in-1',                '012345000004', 'ConnectPro', 'CP-HUB7',   '深灰', 'pcs', 12.0,  6.0,  2.0, 0.150, 0.000144, 0, 0, 0, 0, 0, 0, 'USB集线器',    'USB Hub',                 '8473301000', 18.00, 'USD', 'CN', '0', NULL, 1, NOW(), 1, NOW(), 0),
(4002005, '000000', 4000001, 'WATCH-SW-005',  '智能运动手表',             'Smart Watch Sport Edition',       '012345000005', 'TimeTech',   'TT-SW01',   '黑色', 'pcs',  5.0,  5.0,  1.5, 0.070, 0.000038, 0, 0, 1, 0, 0, 0, '智能手表',     'Smart Watch',             '8541900000', 45.00, 'USD', 'CN', '0', '含电池，重量轻', 1, NOW(), 1, NOW(), 0),
(4002006, '000000', 4000001, 'YOGA-MAT-006',  '瑜伽垫 TPE 10mm 加厚',    'Yoga Mat TPE Extra Thick 10mm',   '012345000006', 'FitLife',    'FL-YM10',   '紫色', 'pcs', 61.0, 10.0, 10.0, 1.200, 0.006100, 0, 0, 0, 0, 0, 0, '瑜伽垫',       'Yoga Mat',                '3926909090', 15.00, 'USD', 'CN', '0', NULL, 1, NOW(), 1, NOW(), 0),
(4002007, '000000', 4000001, 'COFFEE-007',    '挂耳咖啡 精品单品 10包',   'Drip Coffee Premium 10-Pack',     '012345000007', 'BrewMaster', 'BM-DC10',   NULL,   'box', 12.0,  8.0,  5.0, 0.250, 0.000480, 0, 1, 0, 0, 0, 0, '咖啡',         'Coffee',                  '0901210000',  8.00, 'USD', 'CN', '0', '液体类商品', 1, NOW(), 1, NOW(), 0),
(4002008, '000000', 4000001, 'POWER-BANK-008','移动电源 20000mAh PD65W',  'Power Bank 20000mAh PD65W',       '012345000008', 'ChargePro',  'CP-PB20K',  '白色', 'pcs', 14.0,  7.0,  3.0, 0.450, 0.000294, 0, 0, 1, 0, 0, 0, '移动电源',     'Power Bank',              '8507600090', 25.00, 'USD', 'CN', '0', '含锂电池，大容量', 1, NOW(), 1, NOW(), 0),
(4002009, '000000', 4000001, 'STAND-DESK-009','升降电动站立办公桌',       'Electric Height Adjustable Desk', '012345000009', 'ErgoDesk',   'ED-1400',   '黑色', 'pcs',140.0, 70.0, 15.0,32.000, 0.147000, 0, 0, 0, 0, 0, 1, '办公桌',       'Office Desk',             '9403200000',180.00,'USD', 'CN', '0', '超大件，需专用物流', 1, NOW(), 1, NOW(), 0),
(4002010, '000000', 4000001, 'PERFUME-010',   '香水 EDT 50ml',            'Eau de Toilette 50ml',            '012345000010', 'ScentLux',   'SL-EDT50',  NULL,   'pcs', 5.0,   5.0,  9.0, 0.130, 0.000225, 1, 1, 0, 0, 1, 0, '香水',         'Perfume',                 '3303000000', 28.00, 'USD', 'FR', '0', '液体+危险品，限量渠道', 1, NOW(), 1, NOW(), 0);
