-- 渠道 / 业务类型 / 增值服务基础资料
-- 建议菜单归类：基础数据 -> 业务资料 -> 渠道管理 / 业务类型管理 / 增值服务管理

DROP TABLE IF EXISTS `base_channel`;
CREATE TABLE `base_channel` (
  `id` bigint NOT NULL COMMENT '主键（雪花ID）',
  `tenant_id` varchar(20) NOT NULL COMMENT '租户ID',
  `channel_code` varchar(64) NOT NULL COMMENT '渠道编码（租户内唯一，创建后不可修改）',
  `channel_name` varchar(128) NOT NULL COMMENT '渠道名称',
  `channel_type` varchar(32) NOT NULL COMMENT '渠道类型',
  `container_mode` varchar(32) DEFAULT NULL COMMENT '装载模式',
  `priority` int NOT NULL DEFAULT 100 COMMENT '优先级',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序',
  `status` char(1) NOT NULL DEFAULT '0' COMMENT '状态（0=正常，1=禁用）',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` bigint DEFAULT 0 COMMENT '逻辑删除（0=存在，1=删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_base_channel_code` (`tenant_id`, `channel_code`),
  KEY `idx_base_channel_status` (`tenant_id`, `status`),
  KEY `idx_base_channel_type` (`tenant_id`, `channel_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='渠道基础资料';

DROP TABLE IF EXISTS `base_business_type`;
CREATE TABLE `base_business_type` (
  `id` bigint NOT NULL COMMENT '主键（雪花ID）',
  `tenant_id` varchar(20) NOT NULL COMMENT '租户ID',
  `business_type_code` varchar(64) NOT NULL COMMENT '业务类型编码（租户内唯一，创建后不可修改）',
  `business_type_name` varchar(128) NOT NULL COMMENT '业务类型名称',
  `business_category` varchar(32) NOT NULL COMMENT '业务大类',
  `operation_flow_type` varchar(32) DEFAULT NULL COMMENT '作业流程类型',
  `receive_required` char(1) NOT NULL DEFAULT '0' COMMENT '是否需要接单',
  `inbound_required` char(1) NOT NULL DEFAULT '0' COMMENT '是否需要入库',
  `putaway_required` char(1) NOT NULL DEFAULT '0' COMMENT '是否需要上架',
  `storage_required` char(1) NOT NULL DEFAULT '0' COMMENT '是否需要仓储',
  `picking_required` char(1) NOT NULL DEFAULT '0' COMMENT '是否需要拣货',
  `outbound_required` char(1) NOT NULL DEFAULT '0' COMMENT '是否需要出库',
  `delivery_required` char(1) NOT NULL DEFAULT '0' COMMENT '是否需要派送',
  `appointment_required` char(1) NOT NULL DEFAULT '0' COMMENT '是否需要预约',
  `vas_supported` char(1) NOT NULL DEFAULT '0' COMMENT '是否支持增值服务',
  `sorting_strategy` varchar(32) DEFAULT NULL COMMENT '分货策略',
  `sorting_field` varchar(64) DEFAULT NULL COMMENT '分货依据字段',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序',
  `status` char(1) NOT NULL DEFAULT '0' COMMENT '状态（0=正常，1=禁用）',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` bigint DEFAULT 0 COMMENT '逻辑删除（0=存在，1=删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_base_business_type_code` (`tenant_id`, `business_type_code`),
  KEY `idx_base_business_type_status` (`tenant_id`, `status`),
  KEY `idx_base_business_type_category` (`tenant_id`, `business_category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='业务类型基础资料';

DROP TABLE IF EXISTS `base_value_added_service`;
CREATE TABLE `base_value_added_service` (
  `id` bigint NOT NULL COMMENT '主键（雪花ID）',
  `tenant_id` varchar(20) NOT NULL COMMENT '租户ID',
  `service_code` varchar(64) NOT NULL COMMENT '服务编码（租户内唯一，创建后不可修改）',
  `service_name` varchar(128) NOT NULL COMMENT '服务名称',
  `service_category` varchar(32) NOT NULL COMMENT '服务分类',
  `billing_mode` varchar(32) DEFAULT NULL COMMENT '默认计费方式',
  `chargeable_flag` char(1) NOT NULL DEFAULT '1' COMMENT '是否参与计费',
  `operation_required` char(1) NOT NULL DEFAULT '1' COMMENT '是否需要仓库实际作业',
  `pda_operation_flag` char(1) NOT NULL DEFAULT '0' COMMENT '是否需要PDA操作',
  `photo_required` char(1) NOT NULL DEFAULT '0' COMMENT '是否需要拍照',
  `qc_required` char(1) NOT NULL DEFAULT '0' COMMENT '是否需要质检',
  `support_batch_operation` char(1) NOT NULL DEFAULT '1' COMMENT '是否支持批量作业',
  `default_selected` char(1) NOT NULL DEFAULT '0' COMMENT '是否默认勾选',
  `priority` int NOT NULL DEFAULT 100 COMMENT '优先级',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序',
  `status` char(1) NOT NULL DEFAULT '0' COMMENT '状态（0=正常，1=禁用）',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` bigint DEFAULT 0 COMMENT '逻辑删除（0=存在，1=删除）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_base_vas_code` (`tenant_id`, `service_code`),
  KEY `idx_base_vas_status` (`tenant_id`, `status`),
  KEY `idx_base_vas_category` (`tenant_id`, `service_category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='增值服务基础资料';

INSERT IGNORE INTO `base_channel` (id, tenant_id, channel_code, channel_name, channel_type, container_mode, priority, sort_order, status, remark, create_dept, create_by, create_time, update_by, update_time, del_flag) VALUES
(5001001, '000000', 'SEA_TRUCK', '海卡海派', 'SEA', 'LCL', 100, 1, '0', '海运到港后卡车派送', 103, 1, NOW(), 1, NOW(), 0),
(5001002, '000000', 'AIR_EXPRESS', '空派', 'AIR', 'BULK', 80, 2, '0', '空运加快递/卡派', 103, 1, NOW(), 1, NOW(), 0),
(5001003, '000000', 'FCL', '整柜', 'SEA', 'FCL', 60, 3, '0', '整柜运输渠道', 103, 1, NOW(), 1, NOW(), 0);

INSERT IGNORE INTO `base_business_type` (id, tenant_id, business_type_code, business_type_name, business_category, operation_flow_type, receive_required, inbound_required, putaway_required, storage_required, picking_required, outbound_required, delivery_required, appointment_required, vas_supported, sorting_strategy, sorting_field, sort_order, status, remark, create_dept, create_by, create_time, update_by, update_time, del_flag) VALUES
(5002001, '000000', 'TRUCK_DELIVERY', '卡车派送', 'TRANSPORT', 'OUTBOUND', '1','0','0','0','1','1','1','1','0','FIELD_BASED','warehouse_code', 1, '0', '需要维护详细派送地址，可按平台仓/私仓/商业地址区分', 103, 1, NOW(), 1, NOW(), 0),
(5002002, '000000', 'EXPRESS_DELIVERY', '快递派送', 'TRANSPORT', 'OUTBOUND', '1','0','0','0','1','1','1','0','0','NONE',NULL, 2, '0', '快递商必填，追踪号可后补', 103, 1, NOW(), 1, NOW(), 0),
(5002003, '000000', 'CUSTOMER_PICKUP', '客户自提', 'TRANSPORT', 'OUTBOUND', '1','0','0','0','1','1','0','0','0','NONE',NULL, 3, '0', '客户自行提货，地址非必填', 103, 1, NOW(), 1, NOW(), 0),
(5002004, '000000', 'LTL', 'LTL', 'TRANSPORT', 'OUTBOUND', '1','0','0','0','1','1','1','0','0','NONE',NULL, 4, '0', '零担派送，地址信息可后续由调度补充', 103, 1, NOW(), 1, NOW(), 0),
(5002005, '000000', 'BULK_TRANSFER', '大货中转', 'WAREHOUSE', 'INBOUND_OUTBOUND', '0','1','1','1','1','1','0','0','0','FIELD_BASED','warehouse_code', 5, '0', NULL, 103, 1, NOW(), 1, NOW(), 0),
(5002006, '000000', 'DROPSHIP', '一件代发', 'WAREHOUSE', 'OUTBOUND', '1','0','0','1','1','1','1','0','1','FIELD_BASED','sku', 6, '0', NULL, 103, 1, NOW(), 1, NOW(), 0),
(5002007, '000000', 'WAREHOUSE_SUPPLIES', '仓库物资', 'WAREHOUSE', 'SERVICE', '0','1','1','1','0','0','0','0','0','NONE',NULL, 7, '0', '仓库耗材、物资类内部业务', 103, 1, NOW(), 1, NOW(), 0);

INSERT IGNORE INTO `base_value_added_service` (id, tenant_id, service_code, service_name, service_category, billing_mode, chargeable_flag, operation_required, pda_operation_flag, photo_required, qc_required, support_batch_operation, default_selected, priority, sort_order, status, remark, create_dept, create_by, create_time, update_by, update_time, del_flag) VALUES
(5003001, '000000', 'LABELING', '贴标', 'LABEL', 'BY_ITEM', '1','1','1','0','0','1','0',100,1,'0',NULL,103,1,NOW(),1,NOW(),0),
(5003002, '000000', 'QC', '质检', 'QC', 'BY_ITEM', '1','1','1','1','1','1','0',80,2,'0',NULL,103,1,NOW(),1,NOW(),0),
(5003003, '000000', 'PALLETIZE', '打托', 'PALLET', 'BY_PALLET', '1','1','1','0','0','1','0',90,3,'0',NULL,103,1,NOW(),1,NOW(),0),
(5003004, '000000', 'BASIC_SCAN', '基础扫描', 'STORAGE', NULL, '0','1','1','0','0','1','0',10,4,'0',NULL,103,1,NOW(),1,NOW(),0);

INSERT IGNORE INTO sys_dict_type (dict_id, tenant_id, dict_name, dict_type, create_dept, create_by, create_time, update_by, update_time, remark) VALUES
(5000101, '000000', '渠道类型', 'channel_type', 103, 1, NOW(), NULL, NULL, '渠道基础资料'),
(5000102, '000000', '装载模式', 'container_mode', 103, 1, NOW(), NULL, NULL, '渠道基础资料'),
(5000103, '000000', '业务大类', 'business_category', 103, 1, NOW(), NULL, NULL, '业务类型基础资料'),
(5000104, '000000', '作业流程类型', 'operation_flow_type', 103, 1, NOW(), NULL, NULL, '业务类型基础资料'),
(5000106, '000000', '分货策略', 'sorting_strategy', 103, 1, NOW(), NULL, NULL, '业务类型基础资料'),
(5000107, '000000', '分货字段', 'sorting_field', 103, 1, NOW(), NULL, NULL, '业务类型基础资料'),
(5000108, '000000', '增值服务分类', 'service_category', 103, 1, NOW(), NULL, NULL, '增值服务基础资料'),
(5000109, '000000', '增值服务计费方式', 'billing_mode_vas', 103, 1, NOW(), NULL, NULL, '增值服务基础资料');

INSERT IGNORE INTO sys_dict_data (dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_dept, create_by, create_time, update_by, update_time, remark) VALUES
(5000201,'000000',1,'海运','SEA','channel_type','','default','N',103,1,NOW(),NULL,NULL,''),
(5000202,'000000',2,'空运','AIR','channel_type','','default','N',103,1,NOW(),NULL,NULL,''),
(5000203,'000000',3,'快递','EXPRESS','channel_type','','default','N',103,1,NOW(),NULL,NULL,''),
(5000204,'000000',4,'铁运','RAIL','channel_type','','default','N',103,1,NOW(),NULL,NULL,''),
(5000205,'000000',5,'整车','TRUCK','channel_type','','default','N',103,1,NOW(),NULL,NULL,''),
(5000206,'000000',6,'本土散板','LOCAL_BULK','channel_type','','default','N',103,1,NOW(),NULL,NULL,''),
(5000207,'000000',7,'同行散板','PEER_BULK','channel_type','','default','N',103,1,NOW(),NULL,NULL,''),
(5000211,'000000',1,'整柜','FCL','container_mode','','default','N',103,1,NOW(),NULL,NULL,''),
(5000212,'000000',2,'拼柜','LCL','container_mode','','default','N',103,1,NOW(),NULL,NULL,''),
(5000213,'000000',3,'散货','BULK','container_mode','','default','N',103,1,NOW(),NULL,NULL,''),
(5000221,'000000',1,'仓储业务','WAREHOUSE','business_category','','default','N',103,1,NOW(),NULL,NULL,''),
(5000222,'000000',2,'运输业务','TRANSPORT','business_category','','default','N',103,1,NOW(),NULL,NULL,''),
(5000223,'000000',3,'增值服务','VAS','business_category','','default','N',103,1,NOW(),NULL,NULL,''),
(5000224,'000000',4,'售后业务','AFTER_SALES','business_category','','default','N',103,1,NOW(),NULL,NULL,''),
(5000231,'000000',1,'入库型','INBOUND','operation_flow_type','','default','N',103,1,NOW(),NULL,NULL,''),
(5000232,'000000',2,'出库型','OUTBOUND','operation_flow_type','','default','N',103,1,NOW(),NULL,NULL,''),
(5000233,'000000',3,'入出库型','INBOUND_OUTBOUND','operation_flow_type','','default','N',103,1,NOW(),NULL,NULL,''),
(5000234,'000000',4,'服务型','SERVICE','operation_flow_type','','default','N',103,1,NOW(),NULL,NULL,''),
(5000251,'000000',1,'按字段分货','FIELD_BASED','sorting_strategy','','default','N',103,1,NOW(),NULL,NULL,''),
(5000252,'000000',2,'不分货','NONE','sorting_strategy','','default','Y',103,1,NOW(),NULL,NULL,''),
(5000261,'000000',1,'仓库代码','warehouse_code','sorting_field','','default','N',103,1,NOW(),NULL,NULL,''),
(5000262,'000000',2,'订单号','order_no','sorting_field','','default','N',103,1,NOW(),NULL,NULL,''),
(5000263,'000000',3,'SKU','sku','sorting_field','','default','N',103,1,NOW(),NULL,NULL,''),
(5000264,'000000',4,'PO号','po_no','sorting_field','','default','N',103,1,NOW(),NULL,NULL,''),
(5000265,'000000',5,'批次号','batch_no','sorting_field','','default','N',103,1,NOW(),NULL,NULL,''),
(5000266,'000000',6,'柜号','container_no','sorting_field','','default','N',103,1,NOW(),NULL,NULL,''),
(5000267,'000000',7,'目的仓代码','dest_warehouse','sorting_field','','default','N',103,1,NOW(),NULL,NULL,''),
(5000271,'000000',1,'标签类','LABEL','service_category','','default','N',103,1,NOW(),NULL,NULL,''),
(5000272,'000000',2,'包装类','PACKAGE','service_category','','default','N',103,1,NOW(),NULL,NULL,''),
(5000273,'000000',3,'质检类','QC','service_category','','default','N',103,1,NOW(),NULL,NULL,''),
(5000274,'000000',4,'拍照类','PHOTO','service_category','','default','N',103,1,NOW(),NULL,NULL,''),
(5000275,'000000',5,'打托类','PALLET','service_category','','default','N',103,1,NOW(),NULL,NULL,''),
(5000276,'000000',6,'销毁类','DESTROY','service_category','','default','N',103,1,NOW(),NULL,NULL,''),
(5000277,'000000',7,'暂存类','STORAGE','service_category','','default','N',103,1,NOW(),NULL,NULL,''),
(5000281,'000000',1,'按件','BY_ITEM','billing_mode_vas','','default','N',103,1,NOW(),NULL,NULL,''),
(5000282,'000000',2,'按箱','BY_CARTON','billing_mode_vas','','default','N',103,1,NOW(),NULL,NULL,''),
(5000283,'000000',3,'按板','BY_PALLET','billing_mode_vas','','default','N',103,1,NOW(),NULL,NULL,''),
(5000284,'000000',4,'按订单','BY_ORDER','billing_mode_vas','','default','N',103,1,NOW(),NULL,NULL,''),
(5000285,'000000',5,'按小时','BY_HOUR','billing_mode_vas','','default','N',103,1,NOW(),NULL,NULL,'');

INSERT IGNORE INTO sys_menu VALUES(2500, '业务资料', 2000,  4, 'business-data', NULL, '', 1, 0, 'M', '0', '0', '', 'tree-table', 103, 1, NOW(), NULL, NULL, '业务资料目录');
INSERT IGNORE INTO sys_menu VALUES(2501, '渠道管理', 2500,  1, 'channel', 'base/channel/index', '', 1, 0, 'C', '0', '0', 'base:channel:list', 'branches', 103, 1, NOW(), NULL, NULL, '渠道管理菜单');
INSERT IGNORE INTO sys_menu VALUES(2502, '业务类型管理', 2500,  2, 'business-type', 'base/business-type/index', '', 1, 0, 'C', '0', '0', 'base:businessType:list', 'list', 103, 1, NOW(), NULL, NULL, '业务类型管理菜单');
INSERT IGNORE INTO sys_menu VALUES(2503, '增值服务管理', 2500,  3, 'value-added-service', 'base/value-added-service/index', '', 1, 0, 'C', '0', '0', 'base:vas:list', 'form', 103, 1, NOW(), NULL, NULL, '增值服务管理菜单');

INSERT IGNORE INTO sys_menu VALUES(2510, '渠道查询', 2501, 1, '#', '', '', 1, 0, 'F', '0', '0', 'base:channel:query', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2511, '渠道新增', 2501, 2, '#', '', '', 1, 0, 'F', '0', '0', 'base:channel:add', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2512, '渠道修改', 2501, 3, '#', '', '', 1, 0, 'F', '0', '0', 'base:channel:edit', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2513, '渠道删除', 2501, 4, '#', '', '', 1, 0, 'F', '0', '0', 'base:channel:remove', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2514, '渠道导出', 2501, 5, '#', '', '', 1, 0, 'F', '0', '0', 'base:channel:export', '#', 103, 1, NOW(), NULL, NULL, '');

INSERT IGNORE INTO sys_menu VALUES(2520, '业务类型查询', 2502, 1, '#', '', '', 1, 0, 'F', '0', '0', 'base:businessType:query', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2521, '业务类型新增', 2502, 2, '#', '', '', 1, 0, 'F', '0', '0', 'base:businessType:add', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2522, '业务类型修改', 2502, 3, '#', '', '', 1, 0, 'F', '0', '0', 'base:businessType:edit', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2523, '业务类型删除', 2502, 4, '#', '', '', 1, 0, 'F', '0', '0', 'base:businessType:remove', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2524, '业务类型导出', 2502, 5, '#', '', '', 1, 0, 'F', '0', '0', 'base:businessType:export', '#', 103, 1, NOW(), NULL, NULL, '');

INSERT IGNORE INTO sys_menu VALUES(2530, '增值服务查询', 2503, 1, '#', '', '', 1, 0, 'F', '0', '0', 'base:vas:query', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2531, '增值服务新增', 2503, 2, '#', '', '', 1, 0, 'F', '0', '0', 'base:vas:add', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2532, '增值服务修改', 2503, 3, '#', '', '', 1, 0, 'F', '0', '0', 'base:vas:edit', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2533, '增值服务删除', 2503, 4, '#', '', '', 1, 0, 'F', '0', '0', 'base:vas:remove', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(2534, '增值服务导出', 2503, 5, '#', '', '', 1, 0, 'F', '0', '0', 'base:vas:export', '#', 103, 1, NOW(), NULL, NULL, '');

INSERT IGNORE INTO sys_role_menu (role_id, menu_id)
SELECT DISTINCT rm.role_id, m.menu_id
FROM sys_role_menu rm
CROSS JOIN (
  SELECT 2500 menu_id UNION ALL SELECT 2501 UNION ALL SELECT 2502 UNION ALL SELECT 2503
  UNION ALL SELECT 2510 UNION ALL SELECT 2511 UNION ALL SELECT 2512 UNION ALL SELECT 2513 UNION ALL SELECT 2514
  UNION ALL SELECT 2520 UNION ALL SELECT 2521 UNION ALL SELECT 2522 UNION ALL SELECT 2523 UNION ALL SELECT 2524
  UNION ALL SELECT 2530 UNION ALL SELECT 2531 UNION ALL SELECT 2532 UNION ALL SELECT 2533 UNION ALL SELECT 2534
) m
WHERE rm.role_id IN (SELECT DISTINCT role_id FROM sys_role_menu WHERE menu_id = 2000);
