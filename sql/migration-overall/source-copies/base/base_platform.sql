-- =============================================
-- BASE-010  平台管理
-- BASE-011  平台地址库
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
-- ECOMMERCE      → 电商平台
-- INDEPENDENT_SITE → 独立站
-- STORE          → 门店

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
