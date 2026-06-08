-- ----------------------------
-- BASE-019 费项管理
-- ----------------------------
CREATE TABLE `mdm_fee_item` (
  `id`              bigint         NOT NULL                     COMMENT '主键（雪花ID）',
  `tenant_id`       varchar(20)    NOT NULL                     COMMENT '租户ID',
  `fee_code`        varchar(50)    NOT NULL                     COMMENT '费项编码（租户内唯一，新增后不可修改）',
  `fee_name`        varchar(100)   NOT NULL                     COMMENT '费项名称',
  `fee_category`    varchar(30)    NOT NULL                     COMMENT '费项类别（字典：FEE_CATEGORY）',
  `business_stage`  varchar(30)    NOT NULL                     COMMENT '业务阶段（字典：FEE_BUSINESS_STAGE）',
  `business_type`   varchar(30)    DEFAULT NULL                 COMMENT '业务类型（字典：FULFILLMENT_TYPE，NULL=通用）',
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

-- ----------------------------
-- 字典：FEE_CATEGORY（费项类别）
-- ----------------------------
INSERT INTO sys_dict_type (dict_id, tenant_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, del_flag, remark)
VALUES (next_val('sys_dict_type'), '000000', '费项类别', 'fee_category', '0', 1, NOW(), 1, NOW(), 0, NULL);

INSERT INTO sys_dict_data (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, del_flag, remark)
VALUES
  (next_val('sys_dict_data'), '000000', 10, '入库', 'INBOUND',  'fee_category', NULL, 'info',    'N', '0', 1, NOW(), 1, NOW(), 0, NULL),
  (next_val('sys_dict_data'), '000000', 20, '出库', 'OUTBOUND', 'fee_category', NULL, 'success', 'N', '0', 1, NOW(), 1, NOW(), 0, NULL),
  (next_val('sys_dict_data'), '000000', 30, '仓储', 'STORAGE',  'fee_category', NULL, 'warning', 'N', '0', 1, NOW(), 1, NOW(), 0, NULL),
  (next_val('sys_dict_data'), '000000', 40, '退货', 'RETURN',   'fee_category', NULL, 'error',   'N', '0', 1, NOW(), 1, NOW(), 0, NULL),
  (next_val('sys_dict_data'), '000000', 50, '运输', 'TRANSPORT','fee_category', NULL, 'default', 'N', '0', 1, NOW(), 1, NOW(), 0, NULL),
  (next_val('sys_dict_data'), '000000', 60, '其他', 'OTHER',    'fee_category', NULL, 'default', 'N', '0', 1, NOW(), 1, NOW(), 0, NULL);

-- ----------------------------
-- 字典：FEE_BUSINESS_STAGE（业务阶段）
-- ----------------------------
INSERT INTO sys_dict_type (dict_id, tenant_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, del_flag, remark)
VALUES (next_val('sys_dict_type'), '000000', '业务阶段', 'fee_business_stage', '0', 1, NOW(), 1, NOW(), 0, NULL);

INSERT INTO sys_dict_data (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, del_flag, remark)
VALUES
  (next_val('sys_dict_data'), '000000', 10, '入库', 'INBOUND',  'fee_business_stage', NULL, 'info',    'N', '0', 1, NOW(), 1, NOW(), 0, NULL),
  (next_val('sys_dict_data'), '000000', 20, '出库', 'OUTBOUND', 'fee_business_stage', NULL, 'success', 'N', '0', 1, NOW(), 1, NOW(), 0, NULL),
  (next_val('sys_dict_data'), '000000', 30, '仓储', 'STORAGE',  'fee_business_stage', NULL, 'warning', 'N', '0', 1, NOW(), 1, NOW(), 0, NULL),
  (next_val('sys_dict_data'), '000000', 40, '退货', 'RETURN',   'fee_business_stage', NULL, 'error',   'N', '0', 1, NOW(), 1, NOW(), 0, NULL),
  (next_val('sys_dict_data'), '000000', 50, '运输', 'TRANSPORT','fee_business_stage', NULL, 'default', 'N', '0', 1, NOW(), 1, NOW(), 0, NULL);

-- ----------------------------
-- 字典：FULFILLMENT_TYPE（业务类型）
-- ----------------------------
INSERT INTO sys_dict_type (dict_id, tenant_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, del_flag, remark)
VALUES (next_val('sys_dict_type'), '000000', '业务类型', 'fulfillment_type', '0', 1, NOW(), 1, NOW(), 0, NULL);

INSERT INTO sys_dict_data (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, del_flag, remark)
VALUES
  (next_val('sys_dict_data'), '000000', 10, '一件代发', 'DROPSHIP',  'fulfillment_type', NULL, 'info',    'N', '0', 1, NOW(), 1, NOW(), 0, NULL),
  (next_val('sys_dict_data'), '000000', 20, 'FBA头程', 'FBA',        'fulfillment_type', NULL, 'success', 'N', '0', 1, NOW(), 1, NOW(), 0, NULL),
  (next_val('sys_dict_data'), '000000', 30, '自提',   'SELF_PICKUP', 'fulfillment_type', NULL, 'warning', 'N', '0', 1, NOW(), 1, NOW(), 0, NULL),
  (next_val('sys_dict_data'), '000000', 40, '转运',   'TRANSIT',     'fulfillment_type', NULL, 'default', 'N', '0', 1, NOW(), 1, NOW(), 0, NULL);

-- ----------------------------
-- 系统预设费项（tenant_id = '000000'，各租户可见）
-- 注意：生产环境 id 应使用雪花 ID，此处用占位符，实际应替换
-- ----------------------------
INSERT INTO `mdm_fee_item` (id, tenant_id, fee_code, fee_name, fee_category, business_stage, is_system, is_billable, status, sort_order, del_flag, create_by, create_time, update_by, update_time)
VALUES
  (1000001, '000000', 'PICKUP_CONTAINER',  '提柜费',     'INBOUND',  'INBOUND',  1, 1, '0', 10, 0, 1, NOW(), 1, NOW()),
  (1000002, '000000', 'INBOUND_HANDLING',  '入库操作费', 'INBOUND',  'INBOUND',  1, 1, '0', 20, 0, 1, NOW(), 1, NOW()),
  (1000003, '000000', 'STORAGE_FEE',       '仓储费',     'STORAGE',  'STORAGE',  1, 1, '0', 30, 0, 1, NOW(), 1, NOW()),
  (1000004, '000000', 'PICK_FEE',          '拣货费',     'OUTBOUND', 'OUTBOUND', 1, 1, '0', 40, 0, 1, NOW(), 1, NOW()),
  (1000005, '000000', 'LABEL_FEE',         '贴标费',     'OUTBOUND', 'OUTBOUND', 1, 1, '0', 50, 0, 1, NOW(), 1, NOW()),
  (1000006, '000000', 'QC_CHECK',          '质检费',     'INBOUND',  'INBOUND',  1, 1, '0', 60, 0, 1, NOW(), 1, NOW()),
  (1000007, '000000', 'DELIVERY_FEE',      '配送费',     'OUTBOUND', 'OUTBOUND', 1, 1, '0', 70, 0, 1, NOW(), 1, NOW()),
  (1000008, '000000', 'FUEL_SURCHARGE',    '燃油附加费', 'TRANSPORT','TRANSPORT',1, 1, '0', 80, 0, 1, NOW(), 1, NOW()),
  (1000009, '000000', 'RETURN_HANDLING',   '退货处理费', 'RETURN',   'RETURN',   1, 1, '0', 90, 0, 1, NOW(), 1, NOW());
