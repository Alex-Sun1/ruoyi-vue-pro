-- ----------------------------
-- SYS-003 仓库管理
-- ----------------------------
CREATE TABLE `mdm_warehouse` (
  `id`                    bigint        NOT NULL                  COMMENT '主键（雪花ID）',
  `tenant_id`             varchar(20)   NOT NULL                  COMMENT '租户ID',
  `company_id`            bigint        NOT NULL                  COMMENT '所属主体ID（mdm_company.id）',
  `warehouse_code`        varchar(50)   NOT NULL                  COMMENT '仓库编码（租户内唯一，如 LA01/NJ01）',
  `warehouse_name`        varchar(100)  NOT NULL                  COMMENT '仓库名称',
  `warehouse_type`        varchar(20)   NOT NULL                  COMMENT '仓库类型（字典：warehouse_type）',
  `country_code`          varchar(10)   NOT NULL                  COMMENT '国家代码',
  `state_code`            varchar(10)   DEFAULT NULL              COMMENT '州/省代码',
  `city`                  varchar(100)  DEFAULT NULL              COMMENT '城市',
  `address`               varchar(255)  DEFAULT NULL              COMMENT '详细地址',
  `zip_code`              varchar(20)   DEFAULT NULL              COMMENT '邮编',
  `timezone`              varchar(50)   DEFAULT NULL              COMMENT '时区（IANA标准）',
  `currency_code`         varchar(10)   DEFAULT NULL              COMMENT '结算货币代码',
  `contact_name`          varchar(100)  DEFAULT NULL              COMMENT '联系人',
  `contact_phone`         varchar(50)   DEFAULT NULL              COMMENT '联系电话',
  `is_bonded`             tinyint       NOT NULL DEFAULT 0        COMMENT '是否保税仓（0=否，1=是）',
  `operation_start_time`  varchar(10)   DEFAULT NULL              COMMENT '运营开始时间（HH:mm）',
  `operation_end_time`    varchar(10)   DEFAULT NULL              COMMENT '运营结束时间（HH:mm）',
  `support_unloading`     tinyint       NOT NULL DEFAULT 0        COMMENT '支持卸柜',
  `support_dropship`      tinyint       NOT NULL DEFAULT 0        COMMENT '支持一件代发',
  `support_transit`       tinyint       NOT NULL DEFAULT 0        COMMENT '支持转运',
  `support_transfer`      tinyint       NOT NULL DEFAULT 0        COMMENT '支持调拨',
  `support_fba`           tinyint       NOT NULL DEFAULT 0        COMMENT '支持FBA头程',
  `support_self_pickup`   tinyint       NOT NULL DEFAULT 0        COMMENT '支持自提',
  `support_appointment`   tinyint       NOT NULL DEFAULT 0        COMMENT '支持预约',
  `max_capacity_cbm`      decimal(10,2) DEFAULT NULL              COMMENT '最大容量(CBM)',
  `daily_unloading_cap`   int           DEFAULT NULL              COMMENT '日卸柜量(柜)',
  `daily_outbound_cap`    int           DEFAULT NULL              COMMENT '日出库量(单)',
  `dock_count`            int           DEFAULT 0                 COMMENT '月台数',
  `door_count`            int           DEFAULT 0                 COMMENT '仓门数',
  `forklift_count`        int           DEFAULT 0                 COMMENT '叉车数',
  `pda_enabled`           tinyint       NOT NULL DEFAULT 0        COMMENT '启用PDA（0=否，1=是）',
  `api_enabled`           tinyint       NOT NULL DEFAULT 0        COMMENT '启用API对接',
  `api_config`            json          DEFAULT NULL              COMMENT 'API配置（JSON，预留）',
  `status`                char(1)       NOT NULL DEFAULT '0'      COMMENT '状态（0=启用，1=停用）',
  `remark`                varchar(255)  DEFAULT NULL              COMMENT '备注',
  `create_dept`     bigint         DEFAULT NULL                 COMMENT '创建部门',
  `create_by`             bigint        DEFAULT NULL              COMMENT '创建者',
  `create_time`           datetime      DEFAULT NULL              COMMENT '创建时间',
  `update_by`             bigint        DEFAULT NULL              COMMENT '更新者',
  `update_time`           datetime      DEFAULT NULL              COMMENT '更新时间',
  `del_flag`              bigint        DEFAULT 0                 COMMENT '逻辑删除（0=存在，1=删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_warehouse_code` (`tenant_id`, `warehouse_code`),
  KEY `idx_company_id` (`company_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='仓库管理';

-- ----------------------------
-- 字典：warehouse_type（仓库类型）
-- ----------------------------
INSERT INTO sys_dict_type (dict_id, tenant_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, del_flag, remark)
VALUES (next_val('sys_dict_type'), '000000', '仓库类型', 'warehouse_type', '0', 1, NOW(), 1, NOW(), 0, NULL);

INSERT INTO sys_dict_data (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, del_flag, remark)
VALUES
  (next_val('sys_dict_data'), '000000', 10, '自营仓',   'SELF_OP',  'warehouse_type', NULL, 'success', 'N', '0', 1, NOW(), 1, NOW(), 0, NULL),
  (next_val('sys_dict_data'), '000000', 20, '合作仓',   'PARTNER',  'warehouse_type', NULL, 'info',    'N', '0', 1, NOW(), 1, NOW(), 0, NULL),
  (next_val('sys_dict_data'), '000000', 30, '中转仓',   'TRANSIT',  'warehouse_type', NULL, 'warning', 'N', '0', 1, NOW(), 1, NOW(), 0, NULL),
  (next_val('sys_dict_data'), '000000', 40, '客户指定仓','CUSTOMER', 'warehouse_type', NULL, 'default', 'N', '0', 1, NOW(), 1, NOW(), 0, NULL);
