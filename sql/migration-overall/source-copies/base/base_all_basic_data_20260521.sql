-- =============================================
-- 海外仓系统 — 基础资料模块 全量 SQL
-- 生成日期：2026-05-21
-- 包含模块：
--   BASE-010  平台管理
--   BASE-011  平台地址库
--   BASE-019  费项管理（含字典 + 系统预设）
--   SYS-002   主体管理
--   SYS-003   仓库管理（含字典）
--   BASE-022  SKU 管理
--   GEO-001   国家/州省/城市/时区管理
--   FIN-001   币种/汇率管理
--   LOG-001   港口/船司/邮编库管理
-- 执行顺序：按依赖关系排列，直接执行即可
-- =============================================

-- =============================================
-- BASE-010  平台管理
-- =============================================

-- 平台配置主表
CREATE TABLE IF NOT EXISTS `platform`
(
    `id`             BIGINT(20)   NOT NULL                              COMMENT '主键ID（雪花）',
    `tenant_id`      VARCHAR(20)  NOT NULL                              COMMENT '租户ID',
    `code`           VARCHAR(50)  NOT NULL                              COMMENT '平台代码（如 AMAZON/WALMART/SHOPIFY）',
    `name_en`        VARCHAR(100) NOT NULL                              COMMENT '平台英文名称',
    `type_code`      VARCHAR(50)  NOT NULL                              COMMENT '平台类型（字典：PLATFORM_TYPE）',
    `logo_oss_id`    BIGINT(20)                                         COMMENT 'Logo 图片 sys_oss.oss_id',
    `logo_url`       VARCHAR(500)                                       COMMENT 'Logo 图片访问 URL（冗余存储）',
    `address_format` JSON                                               COMMENT '地址格式配置（预留）',
    `api_config`     JSON                                               COMMENT 'API 对接参数（预留）',
    `status`         CHAR(1)      NOT NULL DEFAULT '0'                  COMMENT '状态（0=正常，1=禁用）',
    `sort_order`     INT(11)      NOT NULL DEFAULT 0                    COMMENT '排序',
    `remark`         VARCHAR(500)                                       COMMENT '备注',
    `create_dept`     bigint         DEFAULT NULL                 COMMENT '创建部门',
    `create_by`      BIGINT(20)                                         COMMENT '创建人',
    `create_time`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP    COMMENT '创建时间',
    `update_by`      BIGINT(20)                                         COMMENT '更新人',
    `update_time`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `del_flag`       BIGINT(20)   NOT NULL DEFAULT 0                    COMMENT '删除标志（0=存在，1=删除）',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_code` (`tenant_id`, `code`),
    KEY `idx_type_code` (`tenant_id`, `type_code`),
    KEY `idx_status` (`tenant_id`, `status`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COMMENT = '电商平台配置（BASE-010）';

-- 初始化字典项：平台类型（在 BASE-014 字典管理中维护，此处仅备注）
-- dict_type: PLATFORM_TYPE
-- ECOMMERCE        → 电商平台
-- INDEPENDENT_SITE → 独立站
-- STORE            → 门店

-- =============================================
-- BASE-011  平台地址库
-- =============================================

-- 平台地址库
CREATE TABLE IF NOT EXISTS `platform_address`
(
    `id`               BIGINT(20)   NOT NULL                              COMMENT '主键ID（雪花）',
    `tenant_id`        VARCHAR(20)  NOT NULL                              COMMENT '租户ID',
    `platform_id`      BIGINT(20)   NOT NULL                              COMMENT '所属平台ID',
    `address_code`     VARCHAR(100) NOT NULL                              COMMENT '地址编码（如 FBA 仓库代码 ONT8/LAX9）',
    `address_type`     TINYINT(4)   NOT NULL                              COMMENT '地址类型（1=FBA仓库，2=门店，3=配送中心，4=其他）',
    `name_en`          VARCHAR(200) NOT NULL                              COMMENT '地址名称英文',
    `country_code`     VARCHAR(10)  NOT NULL                              COMMENT '国家代码',
    `state_code`       VARCHAR(20)                                        COMMENT '州/省代码',
    `city`             VARCHAR(100)                                       COMMENT '城市',
    `address_line1`    VARCHAR(255) NOT NULL                              COMMENT '地址行1',
    `address_line2`    VARCHAR(255)                                       COMMENT '地址行2',
    `zip_code`         VARCHAR(20)                                        COMMENT '邮编',
    `unit_pallet_cbm`  DECIMAL(10,3) DEFAULT 2.000                        COMMENT '单板CBM，用于按目的仓预估卡板体积',
    `contact_name`     VARCHAR(100)                                       COMMENT '联系人',
    `contact_phone`    VARCHAR(50)                                        COMMENT '联系电话',
    `last_verified_at` DATETIME                                           COMMENT '最后核验时间',
    `status`           CHAR(1)      NOT NULL DEFAULT '0'                  COMMENT '状态（0=正常，1=禁用）',
    `remark`           VARCHAR(500)                                       COMMENT '备注',
    `create_dept`     bigint         DEFAULT NULL                 COMMENT '创建部门',
    `create_by`        BIGINT(20)                                         COMMENT '创建人',
    `create_time`      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP    COMMENT '创建时间',
    `update_by`        BIGINT(20)                                         COMMENT '更新人',
    `update_time`      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `del_flag`         BIGINT(20)   NOT NULL DEFAULT 0                    COMMENT '删除标志（0=存在，1=删除）',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_address_code` (`tenant_id`, `platform_id`, `address_code`),
    KEY `idx_platform_id` (`tenant_id`, `platform_id`),
    KEY `idx_country_state` (`country_code`, `state_code`),
    KEY `idx_status` (`tenant_id`, `status`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COMMENT = '平台地址库（FBA仓库/门店/配送中心等，BASE-011）';

-- 平台地址变更记录（只增不删）
CREATE TABLE IF NOT EXISTS `platform_address_change_log`
(
    `id`                  BIGINT(20)   NOT NULL AUTO_INCREMENT              COMMENT '主键',
    `tenant_id`           VARCHAR(20)  NOT NULL                              COMMENT '租户ID',
    `platform_address_id` BIGINT(20)   NOT NULL                              COMMENT '地址ID',
    `change_type`         VARCHAR(30)  NOT NULL                              COMMENT '变更类型（CREATE/UPDATE/DISABLE）',
    `before_value`        JSON                                               COMMENT '变更前值（JSON 快照）',
    `after_value`         JSON                                               COMMENT '变更后值（JSON 快照）',
    `change_reason`       VARCHAR(255)                                       COMMENT '变更原因',
    `operator_id`         BIGINT(20)   NOT NULL                              COMMENT '操作人ID（关联 sys_user）',
    `operator_name`       VARCHAR(50)  NOT NULL                              COMMENT '操作人姓名（快照）',
    `create_time`         DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP    COMMENT '记录时间',
    PRIMARY KEY (`id`),
    KEY `idx_address_id` (`platform_address_id`),
    KEY `idx_create_time` (`create_time`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COMMENT = '平台地址变更记录（不可删除，BASE-011）';

-- =============================================
-- BASE-019  费项管理
-- =============================================

DROP TABLE IF EXISTS `mdm_fee_item`;
CREATE TABLE `mdm_fee_item` (
  `id`              bigint         NOT NULL                     COMMENT '主键（雪花ID）',
  `tenant_id`       varchar(20)    NOT NULL                     COMMENT '租户ID',
  `fee_code`        varchar(50)    NOT NULL                     COMMENT '费项编码（租户内唯一，新增后不可修改）',
  `fee_name`        varchar(100)   NOT NULL                     COMMENT '费项名称',
  `fee_category`    varchar(30)    NOT NULL                     COMMENT '费项类别（字典：fee_category）',
  `business_stage`  varchar(30)    NOT NULL                     COMMENT '业务阶段（字典：fee_business_stage）',
  `business_type`   varchar(30)    DEFAULT NULL                 COMMENT '业务类型（字典：fulfillment_type，NULL=通用）',
  `is_system`       tinyint        NOT NULL DEFAULT 0           COMMENT '是否系统预设（0=否，1=是，不可删除）',
  `is_billable`     tinyint        NOT NULL DEFAULT 1           COMMENT '是否出账单（0=否，1=是）',
  `description`     varchar(500)   DEFAULT NULL                 COMMENT '费项说明',
  `status`          char(1)        NOT NULL DEFAULT '0'         COMMENT '状态（0=正常，1=禁用）',
  `sort_order`      int            NOT NULL DEFAULT 0           COMMENT '排序',
  `remark`          varchar(255)   DEFAULT NULL                 COMMENT '备注',
  `create_dept`     bigint         DEFAULT NULL                 COMMENT '创建部门',
  `create_by`       bigint         DEFAULT NULL                 COMMENT '创建者',
  `create_time`     datetime       DEFAULT NULL                 COMMENT '创建时间',
  `update_by`       bigint         DEFAULT NULL                 COMMENT '更新者',
  `update_time`     datetime       DEFAULT NULL                 COMMENT '更新时间',
  `del_flag`        bigint         DEFAULT 0                    COMMENT '逻辑删除（0=存在，1=删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_fee_code` (`tenant_id`, `fee_code`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='费项管理';

-- 字典：fee_category（费项类别）  dict_id=100
INSERT IGNORE INTO sys_dict_type (dict_id, tenant_id, dict_name, dict_type, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES (100, '000000', '费项类别', 'fee_category', 103, 1, NOW(), NULL, NULL, NULL);

INSERT IGNORE INTO sys_dict_data (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (100, '000000', 10, '入库', 'INBOUND',  'fee_category', NULL, 'info',    'N', 103, 1, NOW(), NULL, NULL, NULL),
  (101, '000000', 20, '出库', 'OUTBOUND', 'fee_category', NULL, 'success', 'N', 103, 1, NOW(), NULL, NULL, NULL),
  (102, '000000', 30, '仓储', 'STORAGE',  'fee_category', NULL, 'warning', 'N', 103, 1, NOW(), NULL, NULL, NULL),
  (103, '000000', 40, '退货', 'RETURN',   'fee_category', NULL, 'error',   'N', 103, 1, NOW(), NULL, NULL, NULL),
  (104, '000000', 50, '运输', 'TRANSPORT','fee_category', NULL, 'default', 'N', 103, 1, NOW(), NULL, NULL, NULL),
  (105, '000000', 60, '其他', 'OTHER',    'fee_category', NULL, 'default', 'N', 103, 1, NOW(), NULL, NULL, NULL);

-- 字典：fee_business_stage（业务阶段）  dict_id=101
INSERT IGNORE INTO sys_dict_type (dict_id, tenant_id, dict_name, dict_type, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES (101, '000000', '业务阶段', 'fee_business_stage', 103, 1, NOW(), NULL, NULL, NULL);

INSERT IGNORE INTO sys_dict_data (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (106, '000000', 10, '入库', 'INBOUND',  'fee_business_stage', NULL, 'info',    'N', 103, 1, NOW(), NULL, NULL, NULL),
  (107, '000000', 20, '出库', 'OUTBOUND', 'fee_business_stage', NULL, 'success', 'N', 103, 1, NOW(), NULL, NULL, NULL),
  (108, '000000', 30, '仓储', 'STORAGE',  'fee_business_stage', NULL, 'warning', 'N', 103, 1, NOW(), NULL, NULL, NULL),
  (109, '000000', 40, '退货', 'RETURN',   'fee_business_stage', NULL, 'error',   'N', 103, 1, NOW(), NULL, NULL, NULL),
  (110, '000000', 50, '运输', 'TRANSPORT','fee_business_stage', NULL, 'default', 'N', 103, 1, NOW(), NULL, NULL, NULL);

-- 字典：fulfillment_type（业务类型）  dict_id=102
INSERT IGNORE INTO sys_dict_type (dict_id, tenant_id, dict_name, dict_type, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES (102, '000000', '业务类型', 'fulfillment_type', 103, 1, NOW(), NULL, NULL, NULL);

INSERT IGNORE INTO sys_dict_data (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (111, '000000', 10, '一件代发', 'DROPSHIP',  'fulfillment_type', NULL, 'info',    'N', 103, 1, NOW(), NULL, NULL, NULL),
  (112, '000000', 20, 'FBA头程', 'FBA',        'fulfillment_type', NULL, 'success', 'N', 103, 1, NOW(), NULL, NULL, NULL),
  (113, '000000', 30, '自提',   'SELF_PICKUP', 'fulfillment_type', NULL, 'warning', 'N', 103, 1, NOW(), NULL, NULL, NULL),
  (114, '000000', 40, '转运',   'TRANSIT',     'fulfillment_type', NULL, 'default', 'N', 103, 1, NOW(), NULL, NULL, NULL);

-- 系统预设费项（is_system=1，不可删除）
-- 注意：生产环境 id 应使用雪花 ID，此处使用固定值便于幂等重跑
INSERT INTO `mdm_fee_item` (id, tenant_id, fee_code, fee_name, fee_category, business_stage, is_system, is_billable, status, sort_order, del_flag, create_by, create_time, update_by, update_time)
VALUES
  (1000001, '000000', 'PICKUP_CONTAINER',  '提柜费',     'INBOUND',   'INBOUND',   1, 1, '0', 10, 0, 1, NOW(), 1, NOW()),
  (1000002, '000000', 'INBOUND_HANDLING',  '入库操作费', 'INBOUND',   'INBOUND',   1, 1, '0', 20, 0, 1, NOW(), 1, NOW()),
  (1000003, '000000', 'STORAGE_FEE',       '仓储费',     'STORAGE',   'STORAGE',   1, 1, '0', 30, 0, 1, NOW(), 1, NOW()),
  (1000004, '000000', 'PICK_FEE',          '拣货费',     'OUTBOUND',  'OUTBOUND',  1, 1, '0', 40, 0, 1, NOW(), 1, NOW()),
  (1000005, '000000', 'LABEL_FEE',         '贴标费',     'OUTBOUND',  'OUTBOUND',  1, 1, '0', 50, 0, 1, NOW(), 1, NOW()),
  (1000006, '000000', 'QC_CHECK',          '质检费',     'INBOUND',   'INBOUND',   1, 1, '0', 60, 0, 1, NOW(), 1, NOW()),
  (1000007, '000000', 'DELIVERY_FEE',      '配送费',     'OUTBOUND',  'OUTBOUND',  1, 1, '0', 70, 0, 1, NOW(), 1, NOW()),
  (1000008, '000000', 'FUEL_SURCHARGE',    '燃油附加费', 'TRANSPORT', 'TRANSPORT', 1, 1, '0', 80, 0, 1, NOW(), 1, NOW()),
  (1000009, '000000', 'RETURN_HANDLING',   '退货处理费', 'RETURN',    'RETURN',    1, 1, '0', 90, 0, 1, NOW(), 1, NOW());

-- =============================================
-- SYS-002  主体管理
-- =============================================

DROP TABLE IF EXISTS `mdm_company`;
CREATE TABLE `mdm_company` (
  `id`                  bigint         NOT NULL                   COMMENT '主键（雪花ID）',
  `tenant_id`           varchar(20)    NOT NULL                   COMMENT '租户ID',
  `company_code`        varchar(50)    NOT NULL                   COMMENT '主体编码（租户内唯一，新增后不可修改）',
  `company_name`        varchar(100)   NOT NULL                   COMMENT '主体名称',
  `country_code`        varchar(10)    NOT NULL                   COMMENT '国家代码（ISO 3166-1 alpha-2）',
  `registered_addr`     varchar(255)   DEFAULT NULL               COMMENT '注册地址',
  `tax_no`              varchar(100)   DEFAULT NULL               COMMENT '税号（EIN/注册号）',
  `vat_registered`      tinyint        NOT NULL DEFAULT 0         COMMENT '是否VAT注册（0=否，1=是）',
  `invoice_title`       varchar(200)   DEFAULT NULL               COMMENT '开票抬头',
  `invoice_tax_no`      varchar(100)   DEFAULT NULL               COMMENT '开票税号',
  `invoice_bank_name`   varchar(100)   DEFAULT NULL               COMMENT '开票银行',
  `bank_account_masked` varchar(100)   DEFAULT NULL               COMMENT '银行账号（脱敏展示）',
  `bank_name`           varchar(100)   DEFAULT NULL               COMMENT '银行名称',
  `bank_account_no`     varchar(255)   DEFAULT NULL               COMMENT '银行账号（加密存储）',
  `swift_code`          varchar(50)    DEFAULT NULL               COMMENT 'SWIFT/BIC代码',
  `beneficiary`         varchar(100)   DEFAULT NULL               COMMENT '收款人',
  `currency_code`       varchar(10)    NOT NULL DEFAULT 'USD'     COMMENT '结算货币代码',
  `timezone`            varchar(50)    NOT NULL DEFAULT 'UTC'     COMMENT '时区（IANA标准）',
  `license_files`       json           DEFAULT NULL               COMMENT '营业执照等附件（JSON数组，存OSS URL）',
  `status`              char(1)        NOT NULL DEFAULT '0'       COMMENT '状态（0=启用，1=停用）',
  `remark`              varchar(255)   DEFAULT NULL               COMMENT '备注',
  `create_dept`     bigint         DEFAULT NULL                 COMMENT '创建部门',
  `create_by`           bigint         DEFAULT NULL               COMMENT '创建者',
  `create_time`         datetime       DEFAULT NULL               COMMENT '创建时间',
  `update_by`           bigint         DEFAULT NULL               COMMENT '更新者',
  `update_time`         datetime       DEFAULT NULL               COMMENT '更新时间',
  `del_flag`            bigint         DEFAULT 0                  COMMENT '逻辑删除（0=存在，1=删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_company_code` (`tenant_id`, `company_code`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='主体管理';

-- =============================================
-- SYS-003  仓库管理
-- =============================================

DROP TABLE IF EXISTS `mdm_warehouse`;
CREATE TABLE `mdm_warehouse` (
  `id`                   bigint        NOT NULL                  COMMENT '主键（雪花ID）',
  `tenant_id`            varchar(20)   NOT NULL                  COMMENT '租户ID',
  `company_id`           bigint        NOT NULL                  COMMENT '所属主体ID（mdm_company.id）',
  `warehouse_code`       varchar(50)   NOT NULL                  COMMENT '仓库编码（租户内唯一，如 LA01/NJ01）',
  `warehouse_name`       varchar(100)  NOT NULL                  COMMENT '仓库名称',
  `warehouse_type`       varchar(20)   NOT NULL                  COMMENT '仓库类型（字典：warehouse_type）',
  `country_code`         varchar(10)   NOT NULL                  COMMENT '国家代码',
  `state_code`           varchar(10)   DEFAULT NULL              COMMENT '州/省代码',
  `city`                 varchar(100)  DEFAULT NULL              COMMENT '城市',
  `address`              varchar(255)  DEFAULT NULL              COMMENT '详细地址',
  `zip_code`             varchar(20)   DEFAULT NULL              COMMENT '邮编',
  `timezone`             varchar(50)   DEFAULT NULL              COMMENT '时区（IANA标准）',
  `currency_code`        varchar(10)   DEFAULT NULL              COMMENT '结算货币代码',
  `contact_name`         varchar(100)  DEFAULT NULL              COMMENT '联系人',
  `contact_phone`        varchar(50)   DEFAULT NULL              COMMENT '联系电话',
  `is_bonded`            tinyint       NOT NULL DEFAULT 0        COMMENT '是否保税仓（0=否，1=是）',
  `operation_start_time` varchar(10)   DEFAULT NULL              COMMENT '运营开始时间（HH:mm）',
  `operation_end_time`   varchar(10)   DEFAULT NULL              COMMENT '运营结束时间（HH:mm）',
  `support_unloading`    tinyint       NOT NULL DEFAULT 0        COMMENT '支持卸柜',
  `support_dropship`     tinyint       NOT NULL DEFAULT 0        COMMENT '支持一件代发',
  `support_transit`      tinyint       NOT NULL DEFAULT 0        COMMENT '支持转运',
  `support_transfer`     tinyint       NOT NULL DEFAULT 0        COMMENT '支持调拨',
  `support_fba`          tinyint       NOT NULL DEFAULT 0        COMMENT '支持FBA头程',
  `support_self_pickup`  tinyint       NOT NULL DEFAULT 0        COMMENT '支持自提',
  `support_appointment`  tinyint       NOT NULL DEFAULT 0        COMMENT '支持预约',
  `max_capacity_cbm`     decimal(10,2) DEFAULT NULL              COMMENT '最大容量(CBM)',
  `daily_unloading_cap`  int           DEFAULT NULL              COMMENT '日卸柜量(柜)',
  `daily_outbound_cap`   int           DEFAULT NULL              COMMENT '日出库量(单)',
  `dock_count`           int           DEFAULT 0                 COMMENT '月台数',
  `door_count`           int           DEFAULT 0                 COMMENT '仓门数',
  `forklift_count`       int           DEFAULT 0                 COMMENT '叉车数',
  `pda_enabled`          tinyint       NOT NULL DEFAULT 0        COMMENT '启用PDA（0=否，1=是）',
  `api_enabled`          tinyint       NOT NULL DEFAULT 0        COMMENT '启用API对接',
  `api_config`           json          DEFAULT NULL              COMMENT 'API配置（JSON，预留）',
  `status`               char(1)       NOT NULL DEFAULT '0'      COMMENT '状态（0=启用，1=停用）',
  `remark`               varchar(255)  DEFAULT NULL              COMMENT '备注',
  `create_dept`     bigint         DEFAULT NULL                 COMMENT '创建部门',
  `create_by`            bigint        DEFAULT NULL              COMMENT '创建者',
  `create_time`          datetime      DEFAULT NULL              COMMENT '创建时间',
  `update_by`            bigint        DEFAULT NULL              COMMENT '更新者',
  `update_time`          datetime      DEFAULT NULL              COMMENT '更新时间',
  `del_flag`             bigint        DEFAULT 0                 COMMENT '逻辑删除（0=存在，1=删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_warehouse_code` (`tenant_id`, `warehouse_code`),
  KEY `idx_company_id` (`company_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='仓库管理';

-- 字典：warehouse_type（仓库类型）  dict_id=103
INSERT IGNORE INTO sys_dict_type (dict_id, tenant_id, dict_name, dict_type, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES (103, '000000', '仓库类型', 'warehouse_type', 103, 1, NOW(), NULL, NULL, NULL);

INSERT IGNORE INTO sys_dict_data (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_dept, create_by, create_time, update_by, update_time, remark)
VALUES
  (115, '000000', 10, '自营仓',    'SELF_OP',  'warehouse_type', NULL, 'success', 'N', 103, 1, NOW(), NULL, NULL, NULL),
  (116, '000000', 20, '合作仓',    'PARTNER',  'warehouse_type', NULL, 'info',    'N', 103, 1, NOW(), NULL, NULL, NULL),
  (117, '000000', 30, '中转仓',    'TRANSIT',  'warehouse_type', NULL, 'warning', 'N', 103, 1, NOW(), NULL, NULL, NULL),
  (118, '000000', 40, '客户指定仓','CUSTOMER', 'warehouse_type', NULL, 'default', 'N', 103, 1, NOW(), NULL, NULL, NULL);

-- =============================================
-- BASE-022  SKU 管理
-- =============================================

DROP TABLE IF EXISTS `mdm_sku`;
CREATE TABLE `mdm_sku` (
  `id`                  bigint         NOT NULL                  COMMENT '主键（雪花ID）',
  `tenant_id`           varchar(20)    NOT NULL                  COMMENT '租户ID',
  `client_id`           bigint         NOT NULL                  COMMENT '所属客户ID（mdm_client.id）',
  `sku_code`            varchar(100)   NOT NULL                  COMMENT 'SKU编码（客户内唯一）',
  `sku_name`            varchar(200)   NOT NULL                  COMMENT 'SKU名称（中文）',
  `sku_name_en`         varchar(200)   DEFAULT NULL              COMMENT 'SKU名称（英文）',
  `barcode`             varchar(100)   DEFAULT NULL              COMMENT '条形码/UPC/EAN',
  `category_id`         bigint         DEFAULT NULL              COMMENT '品类ID（BASE-020，暂预留）',
  `brand`               varchar(100)   DEFAULT NULL              COMMENT '品牌',
  `model`               varchar(100)   DEFAULT NULL              COMMENT '型号',
  `color`               varchar(50)    DEFAULT NULL              COMMENT '颜色',
  `size_spec`           varchar(100)   DEFAULT NULL              COMMENT '尺寸规格',
  `unit`                varchar(20)    NOT NULL DEFAULT 'pcs'    COMMENT '计量单位',
  `length_cm`           decimal(8,2)   DEFAULT NULL              COMMENT '长(cm)',
  `width_cm`            decimal(8,2)   DEFAULT NULL              COMMENT '宽(cm)',
  `height_cm`           decimal(8,2)   DEFAULT NULL              COMMENT '高(cm)',
  `weight_kg`           decimal(8,3)   DEFAULT NULL              COMMENT '重量(kg)',
  `volume_cbm`          decimal(12,6)  DEFAULT NULL              COMMENT '体积(CBM，系统自动计算)',
  `package_length_cm`   decimal(8,2)   DEFAULT NULL              COMMENT '外箱长(cm)',
  `package_width_cm`    decimal(8,2)   DEFAULT NULL              COMMENT '外箱宽(cm)',
  `package_height_cm`   decimal(8,2)   DEFAULT NULL              COMMENT '外箱高(cm)',
  `package_weight_kg`   decimal(8,3)   DEFAULT NULL              COMMENT '外箱重(kg)',
  `is_fragile`          tinyint        NOT NULL DEFAULT 0        COMMENT '易碎（0=否，1=是）',
  `is_liquid`           tinyint        NOT NULL DEFAULT 0        COMMENT '液体',
  `is_battery`          tinyint        NOT NULL DEFAULT 0        COMMENT '含电池',
  `is_magnetic`         tinyint        NOT NULL DEFAULT 0        COMMENT '带磁',
  `is_dangerous`        tinyint        NOT NULL DEFAULT 0        COMMENT '危险品',
  `is_oversize`         tinyint        NOT NULL DEFAULT 0        COMMENT '超大件',
  `default_pkg_id`      bigint         DEFAULT NULL              COMMENT '默认包装规格ID（mdm_packaging.id）',
  `default_fee_codes`   json           DEFAULT NULL              COMMENT '默认作业费项（JSON数组，如["LABEL_FEE","QC_CHECK"]）',
  `declared_name_cn`    varchar(200)   DEFAULT NULL              COMMENT '申报品名（中文）',
  `declared_name_en`    varchar(200)   DEFAULT NULL              COMMENT '申报品名（英文）',
  `hs_code`             varchar(30)    DEFAULT NULL              COMMENT 'HS编码',
  `declared_value`      decimal(12,2)  DEFAULT NULL              COMMENT '申报价值',
  `declared_currency`   varchar(10)    DEFAULT NULL              COMMENT '申报货币代码',
  `origin_country_code` varchar(10)    DEFAULT NULL              COMMENT '原产国代码',
  `image_url`           varchar(500)   DEFAULT NULL              COMMENT '商品主图URL',
  `status`              char(1)        NOT NULL DEFAULT '0'      COMMENT '状态（0=正常，1=禁用）',
  `remark`              varchar(500)   DEFAULT NULL              COMMENT '备注',
  `create_dept`     bigint         DEFAULT NULL                 COMMENT '创建部门',
  `create_by`           bigint         DEFAULT NULL              COMMENT '创建者',
  `create_time`         datetime       DEFAULT NULL              COMMENT '创建时间',
  `update_by`           bigint         DEFAULT NULL              COMMENT '更新者',
  `update_time`         datetime       DEFAULT NULL              COMMENT '更新时间',
  `del_flag`            bigint         DEFAULT 0                 COMMENT '逻辑删除（0=存在，1=删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_client_sku` (`tenant_id`, `client_id`, `sku_code`),
  KEY `idx_client_id` (`client_id`),
  KEY `idx_barcode` (`barcode`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='SKU管理';

-- =============================================
-- 菜单数据（sys_menu）
-- ID 规划：2000-2999（现有系统最大 ID=1615）
-- 结构：
--   2000  基础数据（目录）
--   ├── 2001  主体管理（菜单）  2010-2014 按钮
--   ├── 2002  仓库管理（菜单）  2020-2024 按钮
--   ├── 2003  费项管理（菜单）  2030-2034 按钮
--   ├── 2004  商品资料（目录）
--   │   └── 2005  SKU管理（菜单）  2050-2054 按钮
--   └── 2006  平台管理（菜单）  2060-2064 按钮
-- =============================================

-- 一级目录：基础数据
INSERT IGNORE INTO sys_menu VALUES(2000, '基础数据', 0,    10, 'base',      NULL,                    '', 1, 0, 'M', '0', '0', '',                    'server',   103, 1, NOW(), NULL, NULL, '基础数据目录');

-- 二级目录：组织资料
INSERT IGNORE INTO sys_menu VALUES(2400, '组织资料', 2000,  1, 'organization', NULL,                  '', 1, 0, 'M', '0', '0', '',                    'tree-table', 103, 1, NOW(), NULL, NULL, '组织资料目录');

-- 三级菜单：主体管理
INSERT IGNORE INTO sys_menu VALUES(2001, '主体管理', 2400,  1, 'company',   'base/company/index',    '', 1, 0, 'C', '0', '0', 'base:company:list',   'dict',     103, 1, NOW(), NULL, NULL, '主体管理菜单');
INSERT IGNORE INTO sys_menu VALUES(2010, '主体查询', 2001,  1, '#', '', '', 1, 0, 'F', '0', '0', 'base:company:query',  '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2011, '主体新增', 2001,  2, '#', '', '', 1, 0, 'F', '0', '0', 'base:company:add',    '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2012, '主体修改', 2001,  3, '#', '', '', 1, 0, 'F', '0', '0', 'base:company:edit',   '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2013, '主体删除', 2001,  4, '#', '', '', 1, 0, 'F', '0', '0', 'base:company:remove', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2014, '主体导出', 2001,  5, '#', '', '', 1, 0, 'F', '0', '0', 'base:company:export', '#', 103, 1, NOW(), NULL, NULL, '');

-- 三级菜单：仓库管理
INSERT IGNORE INTO sys_menu VALUES(2002, '仓库管理', 2400,  2, 'warehouse', 'base/warehouse/index',  '', 1, 0, 'C', '0', '0', 'base:warehouse:list', 'logininfor',103, 1, NOW(), NULL, NULL, '仓库管理菜单');
INSERT IGNORE INTO sys_menu VALUES(2020, '仓库查询', 2002,  1, '#', '', '', 1, 0, 'F', '0', '0', 'base:warehouse:query',  '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2021, '仓库新增', 2002,  2, '#', '', '', 1, 0, 'F', '0', '0', 'base:warehouse:add',    '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2022, '仓库修改', 2002,  3, '#', '', '', 1, 0, 'F', '0', '0', 'base:warehouse:edit',   '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2023, '仓库删除', 2002,  4, '#', '', '', 1, 0, 'F', '0', '0', 'base:warehouse:remove', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2024, '仓库导出', 2002,  5, '#', '', '', 1, 0, 'F', '0', '0', 'base:warehouse:export', '#', 103, 1, NOW(), NULL, NULL, '');

-- 三级菜单：费项管理（归属财务资料）
INSERT IGNORE INTO sys_menu VALUES(2003, '费项管理', 2008,  3, 'fee-item',  'base/fee-item/index',   '', 1, 0, 'C', '0', '0', 'base:feeItem:list',   'money',    103, 1, NOW(), NULL, NULL, '费项管理菜单');
INSERT IGNORE INTO sys_menu VALUES(2030, '费项查询', 2003,  1, '#', '', '', 1, 0, 'F', '0', '0', 'base:feeItem:query',  '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2031, '费项新增', 2003,  2, '#', '', '', 1, 0, 'F', '0', '0', 'base:feeItem:add',    '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2032, '费项修改', 2003,  3, '#', '', '', 1, 0, 'F', '0', '0', 'base:feeItem:edit',   '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2033, '费项删除', 2003,  4, '#', '', '', 1, 0, 'F', '0', '0', 'base:feeItem:remove', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2034, '费项导出', 2003,  5, '#', '', '', 1, 0, 'F', '0', '0', 'base:feeItem:export', '#', 103, 1, NOW(), NULL, NULL, '');

-- 二级目录：商品资料
INSERT IGNORE INTO sys_menu VALUES(2004, '商品资料', 2000,  2, 'goods',     NULL,                    '', 1, 0, 'M', '0', '0', '',                    'form',     103, 1, NOW(), NULL, NULL, '商品资料目录');

-- 三级菜单：SKU管理
INSERT IGNORE INTO sys_menu VALUES(2005, 'SKU管理',  2004,  1, 'sku',       'base/sku/index',        '', 1, 0, 'C', '0', '0', 'base:sku:list',       'list',     103, 1, NOW(), NULL, NULL, 'SKU管理菜单');
INSERT IGNORE INTO sys_menu VALUES(2050, 'SKU查询',  2005,  1, '#', '', '', 1, 0, 'F', '0', '0', 'base:sku:query',  '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2051, 'SKU新增',  2005,  2, '#', '', '', 1, 0, 'F', '0', '0', 'base:sku:add',    '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2052, 'SKU修改',  2005,  3, '#', '', '', 1, 0, 'F', '0', '0', 'base:sku:edit',   '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2053, 'SKU删除',  2005,  4, '#', '', '', 1, 0, 'F', '0', '0', 'base:sku:remove', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2054, 'SKU导出',  2005,  5, '#', '', '', 1, 0, 'F', '0', '0', 'base:sku:export', '#', 103, 1, NOW(), NULL, NULL, '');

-- 二级菜单：平台管理
INSERT IGNORE INTO sys_menu VALUES(2006, '平台管理', 2000,  3, 'platform',  'base/platform/index',   '', 1, 0, 'C', '0', '0', 'base:platform:list', 'international',103, 1, NOW(), NULL, NULL, '平台管理菜单');
INSERT IGNORE INTO sys_menu VALUES(2060, '平台查询', 2006,  1, '#', '', '', 1, 0, 'F', '0', '0', 'base:platform:query',  '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2061, '平台新增', 2006,  2, '#', '', '', 1, 0, 'F', '0', '0', 'base:platform:add',    '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2062, '平台修改', 2006,  3, '#', '', '', 1, 0, 'F', '0', '0', 'base:platform:edit',   '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2063, '平台删除', 2006,  4, '#', '', '', 1, 0, 'F', '0', '0', 'base:platform:remove', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2064, '平台导出', 2006,  5, '#', '', '', 1, 0, 'F', '0', '0', 'base:platform:export', '#', 103, 1, NOW(), NULL, NULL, '');

-- =============================================
-- GEO-001  国家/州省/城市/时区管理
-- =============================================

DROP TABLE IF EXISTS `country`;
CREATE TABLE `country` (
  `id`               bigint        NOT NULL                   COMMENT '主键（雪花ID）',
  `tenant_id`        varchar(20)   NOT NULL                   COMMENT '租户ID',
  `code`             varchar(10)   NOT NULL                   COMMENT '国家代码（ISO 3166-1 alpha-2，如US/DE/JP）',
  `name_en`          varchar(100)  NOT NULL                   COMMENT '英文名称',
  `phone_code`       varchar(20)   DEFAULT NULL               COMMENT '国际电话区号（如+1/+49）',
  `currency_code`    varchar(10)   DEFAULT NULL               COMMENT '默认货币代码',
  `timezone_default` varchar(50)   DEFAULT NULL               COMMENT '默认时区',
  `is_active`        tinyint       NOT NULL DEFAULT 1         COMMENT '是否已开通（1=是，0=否）',
  `sort_order`       int           NOT NULL DEFAULT 0         COMMENT '排序',
  `create_dept`     bigint         DEFAULT NULL                 COMMENT '创建部门',
  `create_by`        bigint        DEFAULT NULL               COMMENT '创建者',
  `create_time`      datetime      DEFAULT NULL               COMMENT '创建时间',
  `update_by`        bigint        DEFAULT NULL               COMMENT '更新者',
  `update_time`      datetime      DEFAULT NULL               COMMENT '更新时间',
  `del_flag`         bigint        DEFAULT 0                  COMMENT '逻辑删除（0=存在，1=删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_code` (`tenant_id`, `code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='国家管理（GEO-001）';

DROP TABLE IF EXISTS `state_province`;
CREATE TABLE `state_province` (
  `id`           bigint        NOT NULL                   COMMENT '主键（雪花ID）',
  `tenant_id`    varchar(20)   NOT NULL                   COMMENT '租户ID',
  `country_code` varchar(10)   NOT NULL                   COMMENT '所属国家代码',
  `code`         varchar(20)   NOT NULL                   COMMENT '州/省代码（如CA/NY）',
  `name_en`      varchar(100)  NOT NULL                   COMMENT '英文名称',
  `sort_order`   int           NOT NULL DEFAULT 0         COMMENT '排序',
  `status`       char(1)       NOT NULL DEFAULT '0'       COMMENT '状态（0=正常，1=停用）',
  `create_dept`     bigint         DEFAULT NULL                 COMMENT '创建部门',
  `create_by`    bigint        DEFAULT NULL               COMMENT '创建者',
  `create_time`  datetime      DEFAULT NULL               COMMENT '创建时间',
  `update_by`    bigint        DEFAULT NULL               COMMENT '更新者',
  `update_time`  datetime      DEFAULT NULL               COMMENT '更新时间',
  `del_flag`     bigint        DEFAULT 0                  COMMENT '逻辑删除（0=存在，1=删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_country_code` (`tenant_id`, `country_code`, `code`),
  KEY `idx_country_code` (`tenant_id`, `country_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='州/省管理（GEO-001）';

DROP TABLE IF EXISTS `city`;
CREATE TABLE `city` (
  `id`           bigint        NOT NULL                   COMMENT '主键（雪花ID）',
  `tenant_id`    varchar(20)   NOT NULL                   COMMENT '租户ID',
  `country_code` varchar(10)   NOT NULL                   COMMENT '所属国家代码',
  `state_code`   varchar(20)   DEFAULT NULL               COMMENT '所属州/省代码',
  `name_en`      varchar(100)  NOT NULL                   COMMENT '英文名称',
  `status`       char(1)       NOT NULL DEFAULT '0'       COMMENT '状态（0=正常，1=停用）',
  `create_dept`     bigint         DEFAULT NULL                 COMMENT '创建部门',
  `create_by`    bigint        DEFAULT NULL               COMMENT '创建者',
  `create_time`  datetime      DEFAULT NULL               COMMENT '创建时间',
  `update_by`    bigint        DEFAULT NULL               COMMENT '更新者',
  `update_time`  datetime      DEFAULT NULL               COMMENT '更新时间',
  `del_flag`     bigint        DEFAULT 0                  COMMENT '逻辑删除（0=存在，1=删除）',
  PRIMARY KEY (`id`),
  KEY `idx_country_state` (`tenant_id`, `country_code`, `state_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='城市管理（GEO-001）';

DROP TABLE IF EXISTS `timezone`;
CREATE TABLE `timezone` (
  `id`           bigint        NOT NULL                   COMMENT '主键（雪花ID）',
  `tenant_id`    varchar(20)   NOT NULL                   COMMENT '租户ID',
  `tz_code`      varchar(100)  NOT NULL                   COMMENT '时区代码（如America/Los_Angeles）',
  `name_en`      varchar(100)  NOT NULL                   COMMENT '英文名称（如Pacific Time）',
  `utc_offset`   varchar(20)   NOT NULL                   COMMENT 'UTC偏移（如UTC-8）',
  `country_code` varchar(10)   DEFAULT NULL               COMMENT '所属国家代码（NULL=全球，如UTC）',
  `is_dst`       tinyint       NOT NULL DEFAULT 0         COMMENT '是否有夏令时（1=有，0=无）',
  `status`       char(1)       NOT NULL DEFAULT '0'       COMMENT '状态（0=正常，1=停用）',
  `sort_order`   int           NOT NULL DEFAULT 0         COMMENT '排序',
  `create_dept`     bigint         DEFAULT NULL                 COMMENT '创建部门',
  `create_by`    bigint        DEFAULT NULL               COMMENT '创建者',
  `create_time`  datetime      DEFAULT NULL               COMMENT '创建时间',
  `update_by`    bigint        DEFAULT NULL               COMMENT '更新者',
  `update_time`  datetime      DEFAULT NULL               COMMENT '更新时间',
  `del_flag`     bigint        DEFAULT 0                  COMMENT '逻辑删除（0=存在，1=删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_tz_code` (`tenant_id`, `tz_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='时区管理（GEO-001）';

-- =============================================
-- FIN-001  币种/汇率管理
-- =============================================

DROP TABLE IF EXISTS `currency`;
CREATE TABLE `currency` (
  `id`             bigint        NOT NULL                   COMMENT '主键（雪花ID）',
  `tenant_id`      varchar(20)   NOT NULL                   COMMENT '租户ID',
  `code`           varchar(10)   NOT NULL                   COMMENT 'ISO 4217货币代码（如USD/EUR/JPY）',
  `name_en`        varchar(100)  NOT NULL                   COMMENT '货币英文名称',
  `symbol`         varchar(10)   DEFAULT NULL               COMMENT '货币符号（如$/€/¥）',
  `decimal_places` int           NOT NULL DEFAULT 2         COMMENT '小数位数（日元=0，美元=2）',
  `is_base`        tinyint       NOT NULL DEFAULT 0         COMMENT '是否基准货币（1=是，全局唯一）',
  `status`         char(1)       NOT NULL DEFAULT '0'       COMMENT '状态（0=正常，1=停用）',
  `sort_order`     int           NOT NULL DEFAULT 0         COMMENT '排序',
  `create_dept`     bigint         DEFAULT NULL                 COMMENT '创建部门',
  `create_by`      bigint        DEFAULT NULL               COMMENT '创建者',
  `create_time`    datetime      DEFAULT NULL               COMMENT '创建时间',
  `update_by`      bigint        DEFAULT NULL               COMMENT '更新者',
  `update_time`    datetime      DEFAULT NULL               COMMENT '更新时间',
  `del_flag`       bigint        DEFAULT 0                  COMMENT '逻辑删除（0=存在，1=删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_code` (`tenant_id`, `code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='币种管理（FIN-001）';

DROP TABLE IF EXISTS `exchange_rate`;
CREATE TABLE `exchange_rate` (
  `id`             bigint         NOT NULL                  COMMENT '主键（雪花ID）',
  `tenant_id`      varchar(20)    NOT NULL                  COMMENT '租户ID',
  `from_currency`  varchar(10)    NOT NULL                  COMMENT '源货币代码',
  `to_currency`    varchar(10)    NOT NULL                  COMMENT '目标货币代码',
  `rate`           decimal(18,8)  NOT NULL                  COMMENT '汇率（1单位源货币=rate单位目标货币）',
  `effective_date` date           NOT NULL                  COMMENT '生效日期',
  `expired_date`   date           DEFAULT NULL              COMMENT '失效日期（NULL=当前有效）',
  `is_current`     tinyint        NOT NULL DEFAULT 1        COMMENT '是否当前有效（1=是，0=历史）',
  `remark`         varchar(255)   DEFAULT NULL              COMMENT '备注',
  `create_dept`     bigint         DEFAULT NULL                 COMMENT '创建部门',
  `create_by`      bigint         DEFAULT NULL              COMMENT '创建者',
  `create_time`    datetime       DEFAULT NULL              COMMENT '创建时间',
  `update_by`      bigint         DEFAULT NULL              COMMENT '更新者',
  `update_time`    datetime       DEFAULT NULL              COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_from_to_current` (`tenant_id`, `from_currency`, `to_currency`, `is_current`),
  KEY `idx_effective_date` (`tenant_id`, `effective_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='汇率管理（FIN-001）';

-- =============================================
-- LOG-001  港口/船司/邮编库管理
-- =============================================

DROP TABLE IF EXISTS `port`;
CREATE TABLE `port` (
  `id`                  bigint        NOT NULL                 COMMENT '主键（雪花ID）',
  `tenant_id`           varchar(20)   NOT NULL                 COMMENT '租户ID',
  `port_code`           varchar(20)   NOT NULL                 COMMENT '港口代码（UN/LOCODE，如USLAX/DEHAM）',
  `name_en`             varchar(100)  NOT NULL                 COMMENT '港口英文名称',
  `country_code`        varchar(10)   NOT NULL                 COMMENT '所属国家代码',
  `state_code`          varchar(20)   DEFAULT NULL             COMMENT '所属州/省代码',
  `city`                varchar(100)  DEFAULT NULL             COMMENT '所在城市',
  `port_type`           int           NOT NULL DEFAULT 1       COMMENT '港口类型（1=海港，2=空港，3=内陆港）',
  `timezone`            varchar(50)   DEFAULT NULL             COMMENT '港口时区',
  `container_query_url` varchar(500)  DEFAULT NULL             COMMENT '海柜状态查询URL模板（含{container_no}占位符）',
  `status`              char(1)       NOT NULL DEFAULT '0'     COMMENT '状态（0=正常，1=停用）',
  `sort_order`          int           NOT NULL DEFAULT 0       COMMENT '排序',
  `remark`              varchar(255)  DEFAULT NULL             COMMENT '备注',
  `create_dept`     bigint         DEFAULT NULL                 COMMENT '创建部门',
  `create_by`           bigint        DEFAULT NULL             COMMENT '创建者',
  `create_time`         datetime      DEFAULT NULL             COMMENT '创建时间',
  `update_by`           bigint        DEFAULT NULL             COMMENT '更新者',
  `update_time`         datetime      DEFAULT NULL             COMMENT '更新时间',
  `del_flag`            bigint        DEFAULT 0                COMMENT '逻辑删除（0=存在，1=删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_port_code` (`tenant_id`, `port_code`),
  KEY `idx_country_code` (`tenant_id`, `country_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='港口管理（LOG-001）';

DROP TABLE IF EXISTS `shipping_line`;
CREATE TABLE `shipping_line` (
  `id`            bigint        NOT NULL                 COMMENT '主键（雪花ID）',
  `tenant_id`     varchar(20)   NOT NULL                 COMMENT '租户ID',
  `code`          varchar(20)   NOT NULL                 COMMENT '船司代码（SCAC代码，如MSCU/COSU/EGLV）',
  `name_en`       varchar(100)  NOT NULL                 COMMENT '船司英文名称',
  `name_abbr`     varchar(50)   DEFAULT NULL             COMMENT '常用简称（如MSC/COSCO/Evergreen）',
  `country_code`  varchar(10)   DEFAULT NULL             COMMENT '注册国家代码',
  `contact_email` varchar(100)  DEFAULT NULL             COMMENT '联系邮箱',
  `contact_phone` varchar(50)   DEFAULT NULL             COMMENT '联系电话',
  `website`       varchar(255)  DEFAULT NULL             COMMENT '官网地址',
  `tracking_url`  varchar(500)  DEFAULT NULL             COMMENT '货物追踪URL模板（含{container_no}占位符）',
  `status`        char(1)       NOT NULL DEFAULT '0'     COMMENT '状态（0=正常，1=停用）',
  `sort_order`    int           NOT NULL DEFAULT 0       COMMENT '排序',
  `remark`        varchar(255)  DEFAULT NULL             COMMENT '备注',
  `create_dept`     bigint         DEFAULT NULL                 COMMENT '创建部门',
  `create_by`     bigint        DEFAULT NULL             COMMENT '创建者',
  `create_time`   datetime      DEFAULT NULL             COMMENT '创建时间',
  `update_by`     bigint        DEFAULT NULL             COMMENT '更新者',
  `update_time`   datetime      DEFAULT NULL             COMMENT '更新时间',
  `del_flag`      bigint        DEFAULT 0                COMMENT '逻辑删除（0=存在，1=删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_code` (`tenant_id`, `code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='船司管理（LOG-001）';

DROP TABLE IF EXISTS `zip_code`;
CREATE TABLE `zip_code` (
  `id`           bigint        NOT NULL                 COMMENT '主键（雪花ID）',
  `tenant_id`    varchar(20)   NOT NULL                 COMMENT '租户ID',
  `country_code` varchar(10)   NOT NULL                 COMMENT '国家代码',
  `state_code`   varchar(20)   DEFAULT NULL             COMMENT '州/省代码',
  `city_name`    varchar(100)  DEFAULT NULL             COMMENT '城市名称',
  `zip`          varchar(20)   NOT NULL                 COMMENT '邮政编码',
  `create_dept`     bigint         DEFAULT NULL                 COMMENT '创建部门',
  `create_by`    bigint        DEFAULT NULL             COMMENT '创建者',
  `create_time`  datetime      DEFAULT NULL             COMMENT '创建时间',
  `update_by`    bigint        DEFAULT NULL             COMMENT '更新者',
  `update_time`  datetime      DEFAULT NULL             COMMENT '更新时间',
  `del_flag`     bigint        DEFAULT 0                COMMENT '逻辑删除（0=存在，1=删除）',
  PRIMARY KEY (`id`),
  KEY `idx_country_state` (`tenant_id`, `country_code`, `state_code`),
  KEY `idx_zip` (`tenant_id`, `zip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='邮编库（LOG-001）';

-- =============================================
-- 系统菜单：地理资料 / 币种汇率 / 物流基础
-- =============================================
-- 结构（续前 2000 基础数据目录）：
--   ├── 2007  地理资料（目录）
--   │   ├── 2101  国家管理   2110-2114 按钮
--   │   ├── 2102  州省管理   2120-2124 按钮
--   │   ├── 2103  城市管理   2130-2134 按钮
--   │   └── 2104  时区管理   2140-2144 按钮
--   ├── 2008  币种汇率（目录）
--   │   ├── 2201  币种管理   2210-2214 按钮
--   │   └── 2202  汇率管理   2220-2224 按钮
--   └── 2009  物流基础（目录）
--       ├── 2301  港口管理   2310-2314 按钮
--       ├── 2302  船司管理   2320-2324 按钮
--       └── 2303  邮编库管理  2330-2334 按钮
-- =============================================

-- 二级目录：地理资料
INSERT IGNORE INTO sys_menu VALUES(2007, '地理资料', 2000,  4, 'geo',           NULL,                         '', 1, 0, 'M', '0', '0', '',                          'earth',       103, 1, NOW(), NULL, NULL, '地理资料目录');

-- 三级菜单：国家管理
INSERT IGNORE INTO sys_menu VALUES(2101, '国家管理', 2007,  1, 'country',       'base/country/index',         '', 1, 0, 'C', '0', '0', 'base:country:list',         'flag',        103, 1, NOW(), NULL, NULL, '国家管理菜单');
INSERT IGNORE INTO sys_menu VALUES(2110, '国家查询', 2101,  1, '#', '', '', 1, 0, 'F', '0', '0', 'base:country:query',  '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2111, '国家新增', 2101,  2, '#', '', '', 1, 0, 'F', '0', '0', 'base:country:add',    '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2112, '国家修改', 2101,  3, '#', '', '', 1, 0, 'F', '0', '0', 'base:country:edit',   '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2113, '国家删除', 2101,  4, '#', '', '', 1, 0, 'F', '0', '0', 'base:country:remove', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2114, '国家导出', 2101,  5, '#', '', '', 1, 0, 'F', '0', '0', 'base:country:export', '#', 103, 1, NOW(), NULL, NULL, '');

-- 三级菜单：州省管理
INSERT IGNORE INTO sys_menu VALUES(2102, '州省管理', 2007,  2, 'state-province','base/state-province/index',  '', 1, 0, 'C', '0', '0', 'base:stateProvince:list',   'tree',        103, 1, NOW(), NULL, NULL, '州省管理菜单');
INSERT IGNORE INTO sys_menu VALUES(2120, '州省查询', 2102,  1, '#', '', '', 1, 0, 'F', '0', '0', 'base:stateProvince:query',  '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2121, '州省新增', 2102,  2, '#', '', '', 1, 0, 'F', '0', '0', 'base:stateProvince:add',    '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2122, '州省修改', 2102,  3, '#', '', '', 1, 0, 'F', '0', '0', 'base:stateProvince:edit',   '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2123, '州省删除', 2102,  4, '#', '', '', 1, 0, 'F', '0', '0', 'base:stateProvince:remove', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2124, '州省导出', 2102,  5, '#', '', '', 1, 0, 'F', '0', '0', 'base:stateProvince:export', '#', 103, 1, NOW(), NULL, NULL, '');

-- 三级菜单：城市管理
INSERT IGNORE INTO sys_menu VALUES(2103, '城市管理', 2007,  3, 'city',          'base/city/index',            '', 1, 0, 'C', '0', '0', 'base:city:list',            'city',        103, 1, NOW(), NULL, NULL, '城市管理菜单');
INSERT IGNORE INTO sys_menu VALUES(2130, '城市查询', 2103,  1, '#', '', '', 1, 0, 'F', '0', '0', 'base:city:query',  '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2131, '城市新增', 2103,  2, '#', '', '', 1, 0, 'F', '0', '0', 'base:city:add',    '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2132, '城市修改', 2103,  3, '#', '', '', 1, 0, 'F', '0', '0', 'base:city:edit',   '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2133, '城市删除', 2103,  4, '#', '', '', 1, 0, 'F', '0', '0', 'base:city:remove', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2134, '城市导出', 2103,  5, '#', '', '', 1, 0, 'F', '0', '0', 'base:city:export', '#', 103, 1, NOW(), NULL, NULL, '');

-- 三级菜单：时区管理
INSERT IGNORE INTO sys_menu VALUES(2104, '时区管理', 2007,  4, 'timezone',      'base/timezone/index',        '', 1, 0, 'C', '0', '0', 'base:timezone:list',        'time-circle', 103, 1, NOW(), NULL, NULL, '时区管理菜单');
INSERT IGNORE INTO sys_menu VALUES(2140, '时区查询', 2104,  1, '#', '', '', 1, 0, 'F', '0', '0', 'base:timezone:query',  '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2141, '时区新增', 2104,  2, '#', '', '', 1, 0, 'F', '0', '0', 'base:timezone:add',    '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2142, '时区修改', 2104,  3, '#', '', '', 1, 0, 'F', '0', '0', 'base:timezone:edit',   '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2143, '时区删除', 2104,  4, '#', '', '', 1, 0, 'F', '0', '0', 'base:timezone:remove', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2144, '时区导出', 2104,  5, '#', '', '', 1, 0, 'F', '0', '0', 'base:timezone:export', '#', 103, 1, NOW(), NULL, NULL, '');

-- 二级目录：财务资料
INSERT IGNORE INTO sys_menu VALUES(2008, '财务资料', 2000,  5, 'finance',       NULL,                         '', 1, 0, 'M', '0', '0', '',                          'dollar',      103, 1, NOW(), NULL, NULL, '财务资料目录');

-- 三级菜单：币种管理
INSERT IGNORE INTO sys_menu VALUES(2201, '币种管理', 2008,  1, 'currency',      'base/currency/index',        '', 1, 0, 'C', '0', '0', 'base:currency:list',        'money',       103, 1, NOW(), NULL, NULL, '币种管理菜单');
INSERT IGNORE INTO sys_menu VALUES(2210, '币种查询', 2201,  1, '#', '', '', 1, 0, 'F', '0', '0', 'base:currency:query',  '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2211, '币种新增', 2201,  2, '#', '', '', 1, 0, 'F', '0', '0', 'base:currency:add',    '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2212, '币种修改', 2201,  3, '#', '', '', 1, 0, 'F', '0', '0', 'base:currency:edit',   '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2213, '币种删除', 2201,  4, '#', '', '', 1, 0, 'F', '0', '0', 'base:currency:remove', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2214, '币种导出', 2201,  5, '#', '', '', 1, 0, 'F', '0', '0', 'base:currency:export', '#', 103, 1, NOW(), NULL, NULL, '');

-- 三级菜单：汇率管理
INSERT IGNORE INTO sys_menu VALUES(2202, '汇率管理', 2008,  2, 'exchange-rate', 'base/exchange-rate/index',   '', 1, 0, 'C', '0', '0', 'base:exchangeRate:list',    'swap',        103, 1, NOW(), NULL, NULL, '汇率管理菜单');
INSERT IGNORE INTO sys_menu VALUES(2220, '汇率查询', 2202,  1, '#', '', '', 1, 0, 'F', '0', '0', 'base:exchangeRate:query',  '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2221, '汇率新增', 2202,  2, '#', '', '', 1, 0, 'F', '0', '0', 'base:exchangeRate:add',    '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2222, '汇率修改', 2202,  3, '#', '', '', 1, 0, 'F', '0', '0', 'base:exchangeRate:edit',   '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2223, '汇率删除', 2202,  4, '#', '', '', 1, 0, 'F', '0', '0', 'base:exchangeRate:remove', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2224, '汇率导出', 2202,  5, '#', '', '', 1, 0, 'F', '0', '0', 'base:exchangeRate:export', '#', 103, 1, NOW(), NULL, NULL, '');

-- 二级目录：物流基础
INSERT IGNORE INTO sys_menu VALUES(2009, '物流基础', 2000,  6, 'logistics',     NULL,                         '', 1, 0, 'M', '0', '0', '',                          'car',         103, 1, NOW(), NULL, NULL, '物流基础目录');

-- 三级菜单：港口管理
INSERT IGNORE INTO sys_menu VALUES(2301, '港口管理', 2009,  1, 'port',          'base/port/index',            '', 1, 0, 'C', '0', '0', 'base:port:list',            'environment', 103, 1, NOW(), NULL, NULL, '港口管理菜单');
INSERT IGNORE INTO sys_menu VALUES(2310, '港口查询', 2301,  1, '#', '', '', 1, 0, 'F', '0', '0', 'base:port:query',  '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2311, '港口新增', 2301,  2, '#', '', '', 1, 0, 'F', '0', '0', 'base:port:add',    '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2312, '港口修改', 2301,  3, '#', '', '', 1, 0, 'F', '0', '0', 'base:port:edit',   '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2313, '港口删除', 2301,  4, '#', '', '', 1, 0, 'F', '0', '0', 'base:port:remove', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2314, '港口导出', 2301,  5, '#', '', '', 1, 0, 'F', '0', '0', 'base:port:export', '#', 103, 1, NOW(), NULL, NULL, '');

-- 三级菜单：船司管理
INSERT IGNORE INTO sys_menu VALUES(2302, '船司管理', 2009,  2, 'shipping-line', 'base/shipping-line/index',   '', 1, 0, 'C', '0', '0', 'base:shippingLine:list',    'deployment-unit', 103, 1, NOW(), NULL, NULL, '船司管理菜单');
INSERT IGNORE INTO sys_menu VALUES(2320, '船司查询', 2302,  1, '#', '', '', 1, 0, 'F', '0', '0', 'base:shippingLine:query',  '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2321, '船司新增', 2302,  2, '#', '', '', 1, 0, 'F', '0', '0', 'base:shippingLine:add',    '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2322, '船司修改', 2302,  3, '#', '', '', 1, 0, 'F', '0', '0', 'base:shippingLine:edit',   '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2323, '船司删除', 2302,  4, '#', '', '', 1, 0, 'F', '0', '0', 'base:shippingLine:remove', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2324, '船司导出', 2302,  5, '#', '', '', 1, 0, 'F', '0', '0', 'base:shippingLine:export', '#', 103, 1, NOW(), NULL, NULL, '');

-- 三级菜单：邮编库管理
INSERT IGNORE INTO sys_menu VALUES(2303, '邮编库管理', 2007, 5, 'zip-code',    'base/zip-code/index',        '', 1, 0, 'C', '0', '0', 'base:zipCode:list',         'mail',        103, 1, NOW(), NULL, NULL, '邮编库管理菜单');
INSERT IGNORE INTO sys_menu VALUES(2330, '邮编查询',  2303,  1, '#', '', '', 1, 0, 'F', '0', '0', 'base:zipCode:query',  '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2331, '邮编新增',  2303,  2, '#', '', '', 1, 0, 'F', '0', '0', 'base:zipCode:add',    '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2332, '邮编修改',  2303,  3, '#', '', '', 1, 0, 'F', '0', '0', 'base:zipCode:edit',   '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2333, '邮编删除',  2303,  4, '#', '', '', 1, 0, 'F', '0', '0', 'base:zipCode:remove', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2334, '邮编导出',  2303,  5, '#', '', '', 1, 0, 'F', '0', '0', 'base:zipCode:export', '#', 103, 1, NOW(), NULL, NULL, '');

-- =============================================
-- 平台管理升级为目录，下挂平台配置 + 平台地址
-- =============================================
-- 1. 将 2006 从 C 型菜单升级为 M 型目录
UPDATE sys_menu SET menu_type='M', component='', perms='', query_param=''
WHERE menu_id = 2006;

-- 2. 将已有平台管理按钮（2060-2064）的父节点改到新的平台配置菜单（2067）
UPDATE sys_menu SET parent_id = 2067
WHERE menu_id IN (2060, 2061, 2062, 2063, 2064);

-- 3. 新增三级菜单：平台配置（原平台管理页面）
INSERT IGNORE INTO sys_menu VALUES(2067, '平台配置', 2006,  1, 'config',  'base/platform/index',         '', 1, 0, 'C', '0', '0', 'base:platform:list',        'setting',     103, 1, NOW(), NULL, NULL, '平台配置菜单');

-- 4. 新增三级菜单：平台地址
INSERT IGNORE INTO sys_menu VALUES(2068, '平台地址', 2006,  2, 'address', 'base/platform-address/index', '', 1, 0, 'C', '0', '0', 'base:platformAddress:list', 'environment', 103, 1, NOW(), NULL, NULL, '平台地址菜单');
INSERT IGNORE INTO sys_menu VALUES(2080, '平台地址查询', 2068,  1, '#', '', '', 1, 0, 'F', '0', '0', 'base:platformAddress:query',  '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2081, '平台地址新增', 2068,  2, '#', '', '', 1, 0, 'F', '0', '0', 'base:platformAddress:add',    '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2082, '平台地址修改', 2068,  3, '#', '', '', 1, 0, 'F', '0', '0', 'base:platformAddress:edit',   '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2083, '平台地址删除', 2068,  4, '#', '', '', 1, 0, 'F', '0', '0', 'base:platformAddress:remove', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2084, '平台地址导出', 2068,  5, '#', '', '', 1, 0, 'F', '0', '0', 'base:platformAddress:export', '#', 103, 1, NOW(), NULL, NULL, '');
