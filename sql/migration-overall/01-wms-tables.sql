-- WMS consolidated migration

-- ========== wms_inventory_base_20260601.sql ==========
-- WMS库存底座 V1.0
-- 说明：pallet_item 为库存真相源，inventory/pallet 为聚合视图，transaction 为追加式流水。

CREATE TABLE IF NOT EXISTS `wms_zone` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  `company_id` bigint DEFAULT NULL COMMENT '主体公司ID',
  `warehouse_id` bigint NOT NULL COMMENT '仓库ID',
  `warehouse_code` varchar(64) DEFAULT NULL COMMENT '仓库编码',
  `warehouse_name` varchar(128) DEFAULT NULL COMMENT '仓库名称',
  `zone_name` varchar(128) NOT NULL COMMENT '区域名称',
  `storage_method` varchar(32) NOT NULL COMMENT '存放方式 FLOOR/RACK',
  `zone_type` varchar(32) NOT NULL COMMENT '库区类型',
  `allow_mixed_storage` tinyint(1) NOT NULL DEFAULT 0 COMMENT '库位混合存储',
  `max_mixed_qty` int DEFAULT NULL COMMENT '最大混合数量',
  `status` varchar(32) NOT NULL DEFAULT 'ENABLED' COMMENT '状态',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_wms_zone_name` (`tenant_id`, `warehouse_id`, `zone_name`, `deleted`),
  KEY `idx_wms_zone_wh_type` (`tenant_id`, `warehouse_id`, `zone_type`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='WMS库区';

CREATE TABLE IF NOT EXISTS `wms_location` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  `company_id` bigint DEFAULT NULL COMMENT '主体公司ID',
  `warehouse_id` bigint NOT NULL COMMENT '仓库ID',
  `warehouse_code` varchar(64) DEFAULT NULL COMMENT '仓库编码',
  `warehouse_name` varchar(128) DEFAULT NULL COMMENT '仓库名称',
  `zone_id` bigint NOT NULL COMMENT '库区ID',
  `zone_name` varchar(128) DEFAULT NULL COMMENT '库区名称',
  `location_code` varchar(64) NOT NULL COMMENT '库位编码',
  `row_no` varchar(32) DEFAULT NULL COMMENT '行',
  `column_no` varchar(32) DEFAULT NULL COMMENT '列',
  `capacity` int DEFAULT NULL COMMENT '库位容量',
  `current_qty` int NOT NULL DEFAULT 0 COMMENT '现有库存(展示)',
  `remaining_capacity` int DEFAULT NULL COMMENT '剩余容量(展示)',
  `status` varchar(32) NOT NULL DEFAULT 'NORMAL' COMMENT '状态',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_wms_location_code` (`tenant_id`, `warehouse_id`, `location_code`, `deleted`),
  KEY `idx_wms_location_zone` (`tenant_id`, `warehouse_id`, `zone_id`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='WMS库位';

CREATE TABLE IF NOT EXISTS `wms_inventory` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  `company_id` bigint DEFAULT NULL COMMENT '主体公司ID',
  `warehouse_id` bigint NOT NULL COMMENT '仓库ID',
  `warehouse_code` varchar(64) DEFAULT NULL COMMENT '仓库编码',
  `warehouse_name` varchar(128) DEFAULT NULL COMMENT '仓库名称',
  `customer_id` bigint DEFAULT NULL COMMENT '客户ID',
  `customer_name` varchar(128) DEFAULT NULL COMMENT '客户名称',
  `cargo_order_id` bigint NOT NULL COMMENT '货物订单ID',
  `cargo_order_no` varchar(64) NOT NULL COMMENT '货物订单号',
  `shipment_id` bigint NOT NULL COMMENT '货件ID',
  `shipment_code` varchar(64) NOT NULL COMMENT '货件编码',
  `total_box_qty` int NOT NULL DEFAULT 0 COMMENT '总箱数',
  `available_box_qty` int NOT NULL DEFAULT 0 COMMENT '可用箱数',
  `locked_box_qty` int NOT NULL DEFAULT 0 COMMENT '锁定箱数',
  `exception_box_qty` int NOT NULL DEFAULT 0 COMMENT '异常箱数',
  `total_weight` decimal(12,3) NOT NULL DEFAULT 0 COMMENT '总重量',
  `total_cbm` decimal(12,4) NOT NULL DEFAULT 0 COMMENT '总体积',
  `inventory_status` varchar(32) NOT NULL DEFAULT 'IN_STOCK' COMMENT '库存状态',
  `version` int NOT NULL DEFAULT 0 COMMENT '乐观锁版本',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_wms_inventory_shipment` (`tenant_id`, `warehouse_id`, `shipment_id`, `deleted`),
  KEY `idx_wms_inventory_order` (`tenant_id`, `cargo_order_id`),
  KEY `idx_wms_inventory_customer` (`tenant_id`, `customer_id`, `inventory_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='WMS货件级库存聚合';

CREATE TABLE IF NOT EXISTS `wms_pallet` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  `company_id` bigint DEFAULT NULL COMMENT '主体公司ID',
  `warehouse_id` bigint NOT NULL COMMENT '仓库ID',
  `warehouse_code` varchar(64) DEFAULT NULL COMMENT '仓库编码',
  `warehouse_name` varchar(128) DEFAULT NULL COMMENT '仓库名称',
  `pallet_no` varchar(64) NOT NULL COMMENT '卡板号',
  `pallet_type` varchar(32) NOT NULL DEFAULT 'NORMAL' COMMENT '卡板类型 NORMAL/RETURN',
  `business_type_name` varchar(128) DEFAULT NULL COMMENT '业务类型(展示)',
  `container_no` varchar(64) DEFAULT NULL COMMENT '柜号(展示)',
  `group_destination` varchar(256) DEFAULT NULL COMMENT '分组/目的地(展示)',
  `cargo_order_id` bigint DEFAULT NULL COMMENT '货物订单ID',
  `cargo_order_no` varchar(64) DEFAULT NULL COMMENT '货物订单号',
  `shipment_id` bigint DEFAULT NULL COMMENT '货件ID',
  `shipment_code` varchar(64) DEFAULT NULL COMMENT '货件编码',
  `zone_id` bigint DEFAULT NULL COMMENT '库区ID',
  `zone_code` varchar(64) DEFAULT NULL COMMENT '库区编码',
  `zone_name` varchar(128) DEFAULT NULL COMMENT '库区名称',
  `location_id` bigint DEFAULT NULL COMMENT '库位ID',
  `location_code` varchar(64) DEFAULT NULL COMMENT '库位编码',
  `total_box_qty` int NOT NULL DEFAULT 0 COMMENT '总箱数',
  `available_box_qty` int NOT NULL DEFAULT 0 COMMENT '可用箱数',
  `locked_box_qty` int NOT NULL DEFAULT 0 COMMENT '锁定箱数',
  `exception_box_qty` int NOT NULL DEFAULT 0 COMMENT '异常箱数',
  `weight` decimal(12,3) NOT NULL DEFAULT 0 COMMENT '重量',
  `cbm` decimal(12,4) NOT NULL DEFAULT 0 COMMENT '体积',
  `pallet_status` varchar(32) NOT NULL DEFAULT 'IN_STOCK' COMMENT '卡板状态',
  `inbound_time` datetime DEFAULT NULL COMMENT '入库时间',
  `version` int NOT NULL DEFAULT 0 COMMENT '乐观锁版本',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_wms_pallet_no` (`tenant_id`, `warehouse_id`, `pallet_no`, `deleted`),
  KEY `idx_wms_pallet_location` (`tenant_id`, `warehouse_id`, `location_id`),
  KEY `idx_wms_pallet_order` (`tenant_id`, `cargo_order_id`, `shipment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='WMS卡板库存';

CREATE TABLE IF NOT EXISTS `wms_pallet_item` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  `company_id` bigint DEFAULT NULL COMMENT '主体公司ID',
  `warehouse_id` bigint NOT NULL COMMENT '仓库ID',
  `pallet_id` bigint NOT NULL COMMENT '卡板ID',
  `pallet_no` varchar(64) NOT NULL COMMENT '卡板号',
  `cargo_order_id` bigint NOT NULL COMMENT '货物订单ID',
  `cargo_order_no` varchar(64) NOT NULL COMMENT '货物订单号',
  `business_type_name` varchar(128) DEFAULT NULL COMMENT '业务类型',
  `container_no` varchar(64) DEFAULT NULL COMMENT '柜号',
  `group_destination` varchar(128) DEFAULT NULL COMMENT '分组/目的地',
  `platform_name` varchar(128) DEFAULT NULL COMMENT '平台',
  `platform_warehouse_code` varchar(64) DEFAULT NULL COMMENT '平台代码',
  `address_type` varchar(32) DEFAULT NULL COMMENT '地址类型',
  `shipment_id` bigint NOT NULL COMMENT '货件ID',
  `shipment_code` varchar(64) NOT NULL COMMENT '货件编码',
  `po_no` varchar(64) DEFAULT NULL COMMENT 'PO号',
  `shipping_mark` varchar(128) DEFAULT NULL COMMENT '唛头',
  `box_qty` int NOT NULL DEFAULT 0 COMMENT '总箱数',
  `available_box_qty` int NOT NULL DEFAULT 0 COMMENT '可用箱数',
  `locked_box_qty` int NOT NULL DEFAULT 0 COMMENT '锁定箱数',
  `exception_box_qty` int NOT NULL DEFAULT 0 COMMENT '异常箱数',
  `weight` decimal(12,3) NOT NULL DEFAULT 0 COMMENT '重量',
  `cbm` decimal(12,4) NOT NULL DEFAULT 0 COMMENT '体积',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_wms_pallet_item_biz` (`tenant_id`, `pallet_id`, `cargo_order_id`, `shipment_id`, `deleted`),
  KEY `idx_wms_pallet_item_shipment` (`tenant_id`, `warehouse_id`, `shipment_id`),
  KEY `idx_wms_pallet_item_order` (`tenant_id`, `cargo_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='WMS卡板明细库存真相源';

CREATE TABLE IF NOT EXISTS `wms_inventory_lock` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  `company_id` bigint DEFAULT NULL COMMENT '主体公司ID',
  `warehouse_id` bigint NOT NULL COMMENT '仓库ID',
  `biz_doc_type` varchar(64) NOT NULL COMMENT '业务单据类型',
  `biz_doc_id` bigint NOT NULL COMMENT '业务单据ID',
  `biz_doc_line_id` bigint NOT NULL COMMENT '业务单据行ID',
  `shipment_id` bigint NOT NULL COMMENT '货件ID',
  `shipment_code` varchar(64) DEFAULT NULL COMMENT '货件编码',
  `pallet_id` bigint NOT NULL COMMENT '卡板ID',
  `pallet_no` varchar(64) DEFAULT NULL COMMENT '卡板号',
  `pallet_item_id` bigint NOT NULL COMMENT '卡板明细ID',
  `locked_box_qty` int NOT NULL COMMENT '锁定箱数',
  `lock_status` varchar(32) NOT NULL DEFAULT 'LOCKED' COMMENT '锁定状态',
  `lock_time` datetime NOT NULL COMMENT '锁定时间',
  `release_time` datetime DEFAULT NULL COMMENT '释放时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_wms_lock_idempotent` (`tenant_id`, `biz_doc_type`, `biz_doc_line_id`, `pallet_item_id`, `deleted`),
  KEY `idx_wms_lock_shipment` (`tenant_id`, `warehouse_id`, `shipment_id`, `lock_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='WMS库存锁定记录';

CREATE TABLE IF NOT EXISTS `wms_inventory_transaction` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  `company_id` bigint DEFAULT NULL COMMENT '主体公司ID',
  `warehouse_id` bigint NOT NULL COMMENT '仓库ID',
  `transaction_no` varchar(64) NOT NULL COMMENT '库存流水号',
  `transaction_type` varchar(32) NOT NULL COMMENT '流水类型',
  `customer_id` bigint DEFAULT NULL COMMENT '客户ID',
  `customer_name` varchar(128) DEFAULT NULL COMMENT '客户名称',
  `cargo_order_id` bigint DEFAULT NULL COMMENT '货物订单ID',
  `cargo_order_no` varchar(64) DEFAULT NULL COMMENT '货物订单号',
  `shipment_id` bigint DEFAULT NULL COMMENT '货件ID',
  `shipment_code` varchar(64) DEFAULT NULL COMMENT '货件编码',
  `pallet_id` bigint DEFAULT NULL COMMENT '卡板ID',
  `pallet_no` varchar(64) DEFAULT NULL COMMENT '卡板号',
  `pallet_item_id` bigint DEFAULT NULL COMMENT '卡板明细ID',
  `from_location_id` bigint DEFAULT NULL COMMENT '来源库位ID',
  `from_location_code` varchar(64) DEFAULT NULL COMMENT '来源库位',
  `to_location_id` bigint DEFAULT NULL COMMENT '目标库位ID',
  `to_location_code` varchar(64) DEFAULT NULL COMMENT '目标库位',
  `change_total` int NOT NULL DEFAULT 0 COMMENT '总量变化',
  `change_available` int NOT NULL DEFAULT 0 COMMENT '可用变化',
  `change_locked` int NOT NULL DEFAULT 0 COMMENT '锁定变化',
  `change_exception` int NOT NULL DEFAULT 0 COMMENT '异常变化',
  `biz_doc_type` varchar(64) DEFAULT NULL COMMENT '来源单据类型',
  `biz_doc_id` bigint DEFAULT NULL COMMENT '来源单据ID',
  `biz_doc_line_id` bigint DEFAULT NULL COMMENT '来源单据行ID',
  `operator_id` bigint DEFAULT NULL COMMENT '操作人ID',
  `operator_name` varchar(128) DEFAULT NULL COMMENT '操作人',
  `operate_time` datetime NOT NULL COMMENT '操作时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_wms_transaction_no` (`tenant_id`, `transaction_no`),
  KEY `idx_wms_tx_shipment` (`tenant_id`, `warehouse_id`, `shipment_id`, `operate_time`),
  KEY `idx_wms_tx_biz` (`tenant_id`, `biz_doc_type`, `biz_doc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='WMS库存流水';

-- 字典/菜单（已迁移，请勿在此执行）
-- 字典：sql/migration-overall/01-wms-dict.sql（system_dict_type/system_dict_data）
-- 菜单：待转为 system_menu 格式后单独执行
-- =============================================
/*

-- 字典
INSERT IGNORE INTO sys_dict_type(dict_id, tenant_id, dict_name, dict_type, create_time, remark)
VALUES
(910100, '000000', 'WMS库区类型', 'wms_zone_type', NOW(), 'WMS库区业务类型'),
(910101, '000000', 'WMS库区状态', 'wms_zone_status', NOW(), 'WMS库区启停状态'),
(910108, '000000', 'WMS存放方式', 'wms_storage_method', NOW(), '库区存放方式'),
(910103, '000000', 'WMS库位状态', 'wms_location_status', NOW(), 'WMS库位状态'),
(910104, '000000', 'WMS库存状态', 'wms_inventory_status', NOW(), 'WMS货件级库存状态'),
(910105, '000000', 'WMS卡板状态', 'wms_pallet_status', NOW(), 'WMS卡板状态'),
(910106, '000000', 'WMS锁定状态', 'wms_inventory_lock_status', NOW(), 'WMS库存锁定状态'),
(910107, '000000', 'WMS库存流水类型', 'wms_inventory_transaction_type', NOW(), 'WMS库存流水类型'),
(910109, '000000', 'WMS卡板类型', 'wms_pallet_type', NOW(), '常规/退货');

INSERT IGNORE INTO sys_dict_data(dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, list_class, is_default, create_time, remark)
VALUES
(9101006,'000000',1,'快递区','EXPRESS','wms_zone_type','info','N',NOW(),''),
(9101007,'000000',2,'暂存区','TEMP','wms_zone_type','success','Y',NOW(),''),
(9101008,'000000',3,'私仓库区','PRIVATE','wms_zone_type','warning','N',NOW(),''),
(9101009,'000000',4,'异常区','EXCEPTION','wms_zone_type','error','N',NOW(),''),
(9101011,'000000',1,'启用','ENABLED','wms_zone_status','success','Y',NOW(),''),
(9101012,'000000',2,'停用','DISABLED','wms_zone_status','default','N',NOW(),''),
(9101081,'000000',1,'地堆','FLOOR','wms_storage_method','info','Y',NOW(),''),
(9101082,'000000',2,'货架','RACK','wms_storage_method','success','N',NOW(),''),
(9101035,'000000',1,'正常','NORMAL','wms_location_status','success','Y',NOW(),''),
(9101036,'000000',2,'停用','DISABLED','wms_location_status','default','N',NOW(),''),
(9101037,'000000',3,'锁定','LOCKED','wms_location_status','warning','N',NOW(),''),
(9101041,'000000',1,'在库','IN_STOCK','wms_inventory_status','success','Y',NOW(),''),
(9101042,'000000',2,'部分出库','PARTIAL_OUT','wms_inventory_status','warning','N',NOW(),''),
(9101043,'000000',3,'已清空','DEPLETED','wms_inventory_status','default','N',NOW(),''),
(9101044,'000000',4,'冻结','HOLD','wms_inventory_status','error','N',NOW(),''),
(9101056,'000000',1,'在库','IN_STOCK','wms_pallet_status','success','Y',NOW(),''),
(9101057,'000000',2,'已出单','PRE_OUTBOUND','wms_pallet_status','info','N',NOW(),''),
(9101058,'000000',3,'出库','OUTBOUND','wms_pallet_status','default','N',NOW(),''),
(9101091,'000000',1,'常规','NORMAL','wms_pallet_type','info','Y',NOW(),''),
(9101092,'000000',2,'退货','RETURN','wms_pallet_type','warning','N',NOW(),''),
(9101061,'000000',1,'锁定中','LOCKED','wms_inventory_lock_status','warning','Y',NOW(),''),
(9101062,'000000',2,'已释放','RELEASED','wms_inventory_lock_status','default','N',NOW(),''),
(9101063,'000000',3,'已消耗','CONSUMED','wms_inventory_lock_status','success','N',NOW(),''),
(9101071,'000000',1,'收货','RECEIVE','wms_inventory_transaction_type','success','Y',NOW(),''),
(9101072,'000000',2,'打板','PALLETIZE','wms_inventory_transaction_type','info','N',NOW(),''),
(9101073,'000000',3,'上架','PUTAWAY','wms_inventory_transaction_type','info','N',NOW(),''),
(9101074,'000000',4,'移库','MOVE','wms_inventory_transaction_type','info','N',NOW(),''),
(9101075,'000000',5,'锁定','LOCK','wms_inventory_transaction_type','warning','N',NOW(),''),
(9101076,'000000',6,'释放','UNLOCK','wms_inventory_transaction_type','default','N',NOW(),''),
(9101077,'000000',7,'出库','OUTBOUND','wms_inventory_transaction_type','success','N',NOW(),''),
(9101078,'000000',8,'盘点','COUNT','wms_inventory_transaction_type','warning','N',NOW(),''),
(9101079,'000000',9,'调整','ADJUST','wms_inventory_transaction_type','warning','N',NOW(),''),
(9101080,'000000',10,'异常','EXCEPTION','wms_inventory_transaction_type','error','N',NOW(),'');

-- 菜单
INSERT IGNORE INTO sys_menu VALUES(6000, 'WMS系统', 0, 30, 'wms', 'Layout', '', 1, 0, 'M', '0', '0', '', 'carbon:warehouse', 103, 1, NOW(), NULL, NULL, 'WMS仓储管理');
INSERT IGNORE INTO sys_menu VALUES(6001, '库存管理', 6000, 1, 'inventory-group', NULL, '', 1, 0, 'M', '0', '0', '', 'ep:box', 103, 1, NOW(), NULL, NULL, '库存底座');
INSERT IGNORE INTO sys_menu VALUES(6002, '库存查询', 6001, 1, 'inventory', 'wms/inventory/index', '', 1, 0, 'C', '0', '0', 'wms:inventory:list', 'ep:search', 103, 1, NOW(), NULL, NULL, '货件级库存聚合查询');
INSERT IGNORE INTO sys_menu VALUES(6003, '卡板库存', 6001, 2, 'pallet', 'wms/pallet/index', '', 1, 0, 'C', '0', '0', 'wms:pallet:list', 'ep:box', 103, 1, NOW(), NULL, NULL, '卡板库存查询');
INSERT IGNORE INTO sys_menu VALUES(6004, '锁定记录', 6001, 3, 'inventory-lock', 'wms/inventory-lock/index', '', 1, 0, 'C', '0', '0', 'wms:inventoryLock:list', 'ep:lock', 103, 1, NOW(), NULL, NULL, '库存锁定记录');
INSERT IGNORE INTO sys_menu VALUES(6005, '库存流水', 6001, 4, 'inventory-transaction', 'wms/inventory-transaction/index', '', 1, 0, 'C', '0', '0', 'wms:inventoryTransaction:list', 'ep:tickets', 103, 1, NOW(), NULL, NULL, '库存流水账本');
INSERT IGNORE INTO sys_menu VALUES(6006, '出库历史', 6001, 5, 'pallet-outbound', 'wms/pallet-outbound/index', '', 1, 0, 'C', '0', '0', 'wms:pallet:list', 'ep:document', 103, 1, NOW(), NULL, NULL, '已出库卡板只读查询');
INSERT IGNORE INTO sys_menu VALUES(6007, '库存可视化', 6001, 6, 'inventory-visualization', 'wms/inventory-visualization/index', '', 1, 0, 'C', '0', '0', 'wms:inventory:visualization', 'ep:data-analysis', 103, 1, NOW(), NULL, NULL, '仓库库位平面占用可视化');
INSERT IGNORE INTO sys_menu VALUES(6010, '仓库资料', 6000, 2, 'warehouse-data', NULL, '', 1, 0, 'M', '0', '0', '', 'ep:office-building', 103, 1, NOW(), NULL, NULL, 'WMS仓库资料');
INSERT IGNORE INTO sys_menu VALUES(6011, '库区管理', 6010, 1, 'zone', 'wms/zone/index', '', 1, 0, 'C', '0', '0', 'wms:zone:list', 'ep:grid', 103, 1, NOW(), NULL, NULL, 'WMS库区管理');
INSERT IGNORE INTO sys_menu VALUES(6012, '库位管理', 6010, 2, 'location', 'wms/location/index', '', 1, 0, 'C', '0', '0', 'wms:location:list', 'ep:location', 103, 1, NOW(), NULL, NULL, 'WMS库位管理');

INSERT IGNORE INTO sys_menu VALUES(6021, '库存详情', 6002, 1, '#', '', '', 1, 0, 'F', '0', '0', 'wms:inventory:query', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6022, '收货入账', 6002, 2, '#', '', '', 1, 0, 'F', '0', '0', 'wms:inventory:receive', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6023, '库存锁定', 6002, 3, '#', '', '', 1, 0, 'F', '0', '0', 'wms:inventory:lock', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6024, '库存调整', 6002, 4, '#', '', '', 1, 0, 'F', '0', '0', 'wms:inventory:adjust', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6031, '库区新增', 6011, 1, '#', '', '', 1, 0, 'F', '0', '0', 'wms:zone:add', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6032, '库区编辑', 6011, 2, '#', '', '', 1, 0, 'F', '0', '0', 'wms:zone:edit', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6033, '库区删除', 6011, 3, '#', '', '', 1, 0, 'F', '0', '0', 'wms:zone:remove', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6034, '库区导出', 6011, 4, '#', '', '', 1, 0, 'F', '0', '0', 'wms:zone:export', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6041, '库位新增', 6012, 1, '#', '', '', 1, 0, 'F', '0', '0', 'wms:location:add', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6042, '库位编辑', 6012, 2, '#', '', '', 1, 0, 'F', '0', '0', 'wms:location:edit', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6043, '库位删除', 6012, 3, '#', '', '', 1, 0, 'F', '0', '0', 'wms:location:remove', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6044, '库位导出', 6012, 4, '#', '', '', 1, 0, 'F', '0', '0', 'wms:location:export', '#', 103, 1, NOW(), NULL, NULL, '');

-- 超级管理员角色授权
INSERT IGNORE INTO sys_role_menu(role_id, menu_id)
SELECT 1, menu_id FROM sys_menu WHERE menu_id BETWEEN 6000 AND 6044;
*/

-- 基础模拟数据
INSERT IGNORE INTO wms_zone(id, tenant_id, company_id, warehouse_id, warehouse_code, warehouse_name, zone_name, storage_method, zone_type, allow_mixed_storage, max_mixed_qty, status, remark, create_by, create_time, update_by, update_time, deleted)
VALUES
(6100001,'000000',4000001,4001001,'LA01','Los Angeles Central Warehouse','FedEx区','FLOOR','EXPRESS',0,NULL,'ENABLED','快递区',1,NOW(),1,NOW(),0),
(6100002,'000000',4000001,4001001,'LA01','Los Angeles Central Warehouse','A区','RACK','TEMP',1,3,'ENABLED','暂存货架区',1,NOW(),1,NOW(),0),
(6100003,'000000',4000001,4001001,'LA01','Los Angeles Central Warehouse','异常区','FLOOR','EXCEPTION',0,NULL,'ENABLED','异常隔离区域',1,NOW(),1,NOW(),0);

INSERT IGNORE INTO wms_location(id, tenant_id, company_id, warehouse_id, warehouse_code, warehouse_name, zone_id, zone_name, location_code, row_no, column_no, capacity, current_qty, remaining_capacity, status, remark, create_by, create_time, update_by, update_time, deleted)
VALUES
(6101001,'000000',4000001,4001001,'LA01','Los Angeles Central Warehouse',6100001,'FedEx区','CD-A-01','1','E08',20,1,19,'NORMAL','地堆位',1,NOW(),1,NOW(),0),
(6101002,'000000',4000001,4001001,'LA01','Los Angeles Central Warehouse',6100002,'A区','A-01-01','10','F04',1,2,0,'NORMAL','货架位',1,NOW(),1,NOW(),0),
(6101003,'000000',4000001,4001001,'LA01','Los Angeles Central Warehouse',6100002,'A区','A-01-02',NULL,NULL,1,0,1,'NORMAL','货架位',1,NOW(),1,NOW(),0);

INSERT IGNORE INTO wms_pallet(id, tenant_id, company_id, warehouse_id, warehouse_code, warehouse_name, pallet_no, cargo_order_id, cargo_order_no, shipment_id, shipment_code, zone_id, zone_code, zone_name, location_id, location_code, total_box_qty, available_box_qty, locked_box_qty, exception_box_qty, weight, cbm, pallet_status, inbound_time, version, remark, create_by, create_time, update_by, update_time, deleted)
VALUES
(6102001,'000000',4000001,4001001,'LA01','Los Angeles Central Warehouse','PLT-LA-0001',5200001,'CO202605080001',5201001,'SC-001',6100002,'ST-LA-A','LA存储A区',6101002,'A-01-01',60,60,0,0,680.000,4.2000,'IN_STOCK',NOW(),0,'模拟库存',1,NOW(),1,NOW(),0),
(6102002,'000000',4000001,4001001,'LA01','Los Angeles Central Warehouse','PLT-LA-0002',5200001,'CO202605080001',5201002,'SC-002',6100002,'ST-LA-A','LA存储A区',6101002,'A-01-01',40,25,15,0,570.000,2.6000,'PRE_OUTBOUND',NOW(),0,'模拟锁定',1,NOW(),1,NOW(),0),
(6102003,'000000',4000001,4001001,'LA01','Los Angeles Central Warehouse','PLT-LA-0003',5200002,'CO-2026-000002',5201003,'SC-003',6100001,'CD-LA','LA快进快出区',6101001,'CD-A-01',30,30,0,0,360.000,2.1000,'IN_STOCK',NOW(),0,'快进快出库存',1,NOW(),1,NOW(),0);

INSERT IGNORE INTO wms_pallet_item(id, tenant_id, company_id, warehouse_id, pallet_id, pallet_no, cargo_order_id, cargo_order_no, shipment_id, shipment_code, box_qty, available_box_qty, locked_box_qty, exception_box_qty, weight, cbm, remark, create_by, create_time, update_by, update_time, deleted)
VALUES
(6103001,'000000',4000001,4001001,6102001,'PLT-LA-0001',5200001,'CO202605080001',5201001,'SC-001',60,60,0,0,680.000,4.2000,'模拟库存',1,NOW(),1,NOW(),0),
(6103002,'000000',4000001,4001001,6102002,'PLT-LA-0002',5200001,'CO202605080001',5201002,'SC-002',40,25,15,0,570.000,2.6000,'模拟锁定',1,NOW(),1,NOW(),0),
(6103003,'000000',4000001,4001001,6102003,'PLT-LA-0003',5200002,'CO-2026-000002',5201003,'SC-003',30,30,0,0,360.000,2.1000,'快进快出库存',1,NOW(),1,NOW(),0);

INSERT IGNORE INTO wms_inventory(id, tenant_id, company_id, warehouse_id, warehouse_code, warehouse_name, customer_id, customer_name, cargo_order_id, cargo_order_no, shipment_id, shipment_code, total_box_qty, available_box_qty, locked_box_qty, exception_box_qty, total_weight, total_cbm, inventory_status, version, remark, create_by, create_time, update_by, update_time, deleted)
VALUES
(6104001,'000000',4000001,4001001,'LA01','Los Angeles Central Warehouse',7000001,'Pacific Home Goods LLC',5200001,'CO202605080001',5201001,'SC-001',60,60,0,0,680.000,4.2000,'IN_STOCK',0,'模拟库存',1,NOW(),1,NOW(),0),
(6104002,'000000',4000001,4001001,'LA01','Los Angeles Central Warehouse',7000001,'Pacific Home Goods LLC',5200001,'CO202605080001',5201002,'SC-002',40,25,15,0,570.000,2.6000,'IN_STOCK',0,'部分锁定',1,NOW(),1,NOW(),0),
(6104003,'000000',4000001,4001001,'LA01','Los Angeles Central Warehouse',7000002,'East Market Supply Co.',5200002,'CO-2026-000002',5201003,'SC-003',30,30,0,0,360.000,2.1000,'IN_STOCK',0,'快进快出库存',1,NOW(),1,NOW(),0);

INSERT IGNORE INTO wms_inventory_lock(id, tenant_id, company_id, warehouse_id, biz_doc_type, biz_doc_id, biz_doc_line_id, shipment_id, shipment_code, pallet_id, pallet_no, pallet_item_id, locked_box_qty, lock_status, lock_time, remark, create_by, create_time, update_by, update_time, deleted)
VALUES
(6105001,'000000',4000001,4001001,'OUTBOUND',7100001,7101001,5201002,'SC-002',6102002,'PLT-LA-0002',6103002,15,'LOCKED',NOW(),'出库单锁定模拟',1,NOW(),1,NOW(),0);

INSERT IGNORE INTO wms_inventory_transaction(id, tenant_id, company_id, warehouse_id, transaction_no, transaction_type, customer_id, customer_name, cargo_order_id, cargo_order_no, shipment_id, shipment_code, pallet_id, pallet_no, pallet_item_id, to_location_id, to_location_code, change_total, change_available, change_locked, change_exception, biz_doc_type, biz_doc_id, biz_doc_line_id, operate_time, remark, create_by, create_time, update_by, update_time, deleted)
VALUES
(6106001,'000000',4000001,4001001,'WMT6106001','RECEIVE',7000001,'Pacific Home Goods LLC',5200001,'CO202605080001',5201001,'SC-001',6102001,'PLT-LA-0001',6103001,6101002,'A-01-01',60,60,0,0,'INBOUND',5200001,5201001,NOW(),'收货入账模拟',1,NOW(),1,NOW(),0),
(6106002,'000000',4000001,4001001,'WMT6106002','RECEIVE',7000001,'Pacific Home Goods LLC',5200001,'CO202605080001',5201002,'SC-002',6102002,'PLT-LA-0002',6103002,6101002,'A-01-01',40,40,0,0,'INBOUND',5200001,5201002,NOW(),'收货入账模拟',1,NOW(),1,NOW(),0),
(6106003,'000000',4000001,4001001,'WMT6106003','LOCK',7000001,'Pacific Home Goods LLC',5200001,'CO202605080001',5201002,'SC-002',6102002,'PLT-LA-0002',6103002,NULL,NULL,0,-15,15,0,'OUTBOUND',7100001,7101001,NOW(),'出库锁定模拟',1,NOW(),1,NOW(),0),
(6106004,'000000',4000001,4001001,'WMT6106004','RECEIVE',7000002,'East Market Supply Co.',5200002,'CO-2026-000002',5201003,'SC-003',6102003,'PLT-LA-0003',6103003,6101001,'CD-A-01',30,30,0,0,'INBOUND',5200002,5201003,NOW(),'快进快出收货模拟',1,NOW(),1,NOW(),0);


-- ========== wms_zone_location_prd_20260601.sql ==========
-- 库区与库位 PRD v1.0 结构迁移（在 wms_inventory_base_20260601.sql 之后执行）
-- 可重复执行：列/索引已存在则自动跳过
-- UPDATE/DELETE 带主键条件，兼容 MySQL Workbench 安全更新模式

-- ========== wms_zone：新增列 ==========
SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_zone' AND COLUMN_NAME = 'storage_method') = 0,
  'ALTER TABLE `wms_zone` ADD COLUMN `storage_method` varchar(32) DEFAULT NULL COMMENT ''存放方式 FLOOR/RACK'' AFTER `zone_name`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_zone' AND COLUMN_NAME = 'allow_mixed_storage') = 0,
  'ALTER TABLE `wms_zone` ADD COLUMN `allow_mixed_storage` tinyint(1) NOT NULL DEFAULT 0 COMMENT ''库位混合存储'' AFTER `zone_type`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_zone' AND COLUMN_NAME = 'max_mixed_qty') = 0,
  'ALTER TABLE `wms_zone` ADD COLUMN `max_mixed_qty` int DEFAULT NULL COMMENT ''最大混合数量'' AFTER `allow_mixed_storage`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

UPDATE `wms_zone` SET `storage_method` = 'FLOOR' WHERE `id` > 0 AND `storage_method` IS NULL;
UPDATE `wms_zone` SET `zone_type` = 'EXPRESS' WHERE `id` > 0 AND `zone_type` = 'CROSS_DOCK';
UPDATE `wms_zone` SET `zone_type` = 'TEMP' WHERE `id` > 0 AND `zone_type` IN ('STORAGE', 'STAGING');

-- 删除旧列/索引（存在才删）
SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_zone' AND INDEX_NAME = 'uk_wms_zone_code') > 0,
  'ALTER TABLE `wms_zone` DROP INDEX `uk_wms_zone_code`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_zone' AND COLUMN_NAME = 'zone_code') > 0,
  'ALTER TABLE `wms_zone` DROP COLUMN `zone_code`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_zone' AND COLUMN_NAME = 'allow_putaway') > 0,
  'ALTER TABLE `wms_zone` DROP COLUMN `allow_putaway`, DROP COLUMN `allow_pick`, DROP COLUMN `allow_count`, DROP COLUMN `allow_direct_outbound`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_zone' AND COLUMN_NAME = 'storage_method' AND IS_NULLABLE = 'YES') > 0,
  'ALTER TABLE `wms_zone` MODIFY COLUMN `storage_method` varchar(32) NOT NULL COMMENT ''存放方式 FLOOR/RACK''',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_zone' AND INDEX_NAME = 'uk_wms_zone_name') = 0,
  'ALTER TABLE `wms_zone` ADD UNIQUE KEY `uk_wms_zone_name` (`tenant_id`, `warehouse_id`, `zone_name`, `deleted`)',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ========== wms_location：新增列 ==========
SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_location' AND COLUMN_NAME = 'row_no') = 0,
  'ALTER TABLE `wms_location` ADD COLUMN `row_no` varchar(32) DEFAULT NULL COMMENT ''行'' AFTER `location_code`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_location' AND COLUMN_NAME = 'column_no') = 0,
  'ALTER TABLE `wms_location` ADD COLUMN `column_no` varchar(32) DEFAULT NULL COMMENT ''列'' AFTER `row_no`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_location' AND COLUMN_NAME = 'capacity') = 0,
  'ALTER TABLE `wms_location` ADD COLUMN `capacity` int DEFAULT NULL COMMENT ''库位容量'' AFTER `column_no`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_location' AND COLUMN_NAME = 'current_qty') = 0,
  'ALTER TABLE `wms_location` ADD COLUMN `current_qty` int NOT NULL DEFAULT 0 COMMENT ''现有库存(展示)'' AFTER `capacity`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_location' AND COLUMN_NAME = 'remaining_capacity') = 0,
  'ALTER TABLE `wms_location` ADD COLUMN `remaining_capacity` int DEFAULT NULL COMMENT ''剩余容量(展示)'' AFTER `current_qty`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

UPDATE `wms_location` SET `status` = 'NORMAL' WHERE `id` > 0 AND `status` IN ('FREE', 'OCCUPIED', 'FULL');

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_location' AND COLUMN_NAME = 'occupied_pallet_qty') > 0,
  'UPDATE `wms_location` SET `current_qty` = IFNULL(`occupied_pallet_qty`, 0) WHERE `id` > 0',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_location' AND COLUMN_NAME = 'zone_code') > 0,
  'ALTER TABLE `wms_location` DROP COLUMN `zone_code`, DROP COLUMN `location_type`, DROP COLUMN `capacity_pallet_qty`, DROP COLUMN `capacity_weight`, DROP COLUMN `capacity_cbm`, DROP COLUMN `occupied_pallet_qty`, DROP COLUMN `occupied_weight`, DROP COLUMN `occupied_cbm`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ========== 字典（已迁移至 01-wms-dict.sql） ==========
/*
DELETE FROM sys_dict_data WHERE dict_code > 0 AND dict_type = 'wms_zone_type' AND dict_value IN ('CROSS_DOCK', 'STORAGE', 'VAS', 'STAGING');
INSERT IGNORE INTO sys_dict_data(dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, list_class, is_default, create_time, remark)
VALUES
(9101006,'000000',1,'快递区','EXPRESS','wms_zone_type','info','N',NOW(),''),
(9101007,'000000',2,'暂存区','TEMP','wms_zone_type','success','Y',NOW(),''),
(9101008,'000000',3,'私仓库区','PRIVATE','wms_zone_type','warning','N',NOW(),''),
(9101009,'000000',4,'异常区','EXCEPTION','wms_zone_type','error','N',NOW(),'');

INSERT IGNORE INTO sys_dict_type(dict_id, tenant_id, dict_name, dict_type, create_time, remark)
VALUES (910108, '000000', 'WMS存放方式', 'wms_storage_method', NOW(), '库区存放方式');

INSERT IGNORE INTO sys_dict_data(dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, list_class, is_default, create_time, remark)
VALUES
(9101081,'000000',1,'地堆','FLOOR','wms_storage_method','info','Y',NOW(),''),
(9101082,'000000',2,'货架','RACK','wms_storage_method','success','N',NOW(),'');

DELETE FROM sys_dict_data WHERE dict_code > 0 AND dict_type = 'wms_location_type';
DELETE FROM sys_dict_type WHERE dict_id > 0 AND dict_type = 'wms_location_type';

DELETE FROM sys_dict_data WHERE dict_code > 0 AND dict_type = 'wms_location_status' AND dict_value IN ('FREE', 'OCCUPIED', 'FULL');
INSERT IGNORE INTO sys_dict_data(dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, list_class, is_default, create_time, remark)
VALUES
(9101035,'000000',1,'正常','NORMAL','wms_location_status','success','Y',NOW(),''),
(9101036,'000000',2,'停用','DISABLED','wms_location_status','default','N',NOW(),''),
(9101037,'000000',3,'锁定','LOCKED','wms_location_status','warning','N',NOW(),'');

INSERT IGNORE INTO sys_menu VALUES(6045, '库位导入', 6012, 5, '#', '', '', 1, 0, 'F', '0', '0', 'wms:location:import', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6046, '库位改状态', 6012, 6, '#', '', '', 1, 0, 'F', '0', '0', 'wms:location:changeStatus', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6035, '库区停用', 6011, 5, '#', '', '', 1, 0, 'F', '0', '0', 'wms:zone:changeStatus', '#', 103, 1, NOW(), NULL, NULL, '');

INSERT IGNORE INTO sys_role_menu(role_id, menu_id)
SELECT 1, menu_id FROM sys_menu WHERE menu_id IN (6035, 6045, 6046);
*/

-- 演示数据对齐 PRD（可按需注释）
UPDATE `wms_zone` SET
  `zone_name` = 'FedEx区',
  `storage_method` = 'FLOOR',
  `zone_type` = 'EXPRESS',
  `allow_mixed_storage` = 0,
  `max_mixed_qty` = NULL
WHERE `id` = 6100001;

UPDATE `wms_zone` SET
  `zone_name` = 'A区',
  `storage_method` = 'RACK',
  `zone_type` = 'TEMP',
  `allow_mixed_storage` = 1,
  `max_mixed_qty` = 3
WHERE `id` = 6100002;

UPDATE `wms_zone` SET
  `zone_name` = '异常区',
  `storage_method` = 'FLOOR',
  `zone_type` = 'EXCEPTION',
  `allow_mixed_storage` = 0
WHERE `id` = 6100003;

UPDATE `wms_location` SET
  `location_code` = 'CD-A-01',
  `row_no` = '1',
  `column_no` = 'E08',
  `capacity` = 20,
  `status` = 'NORMAL'
WHERE `id` = 6101001;

UPDATE `wms_location` SET
  `location_code` = 'A-01-01',
  `row_no` = '10',
  `column_no` = 'F04',
  `capacity` = 1,
  `status` = 'NORMAL'
WHERE `id` = 6101002;

UPDATE `wms_location` SET
  `location_code` = 'A-01-02',
  `capacity` = 1,
  `status` = 'NORMAL'
WHERE `id` = 6101003;


-- ========== wms_pallet_enhance_20260602.sql ==========
-- 卡板库存字段增强 + 状态/类型字典 + 业务动作权限

-- ========== wms_pallet ==========
SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_pallet' AND COLUMN_NAME = 'pallet_type') = 0,
  'ALTER TABLE `wms_pallet` ADD COLUMN `pallet_type` varchar(32) NOT NULL DEFAULT ''NORMAL'' COMMENT ''卡板类型 NORMAL/RETURN'' AFTER `pallet_no`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_pallet' AND COLUMN_NAME = 'business_type_name') = 0,
  'ALTER TABLE `wms_pallet` ADD COLUMN `business_type_name` varchar(128) DEFAULT NULL COMMENT ''业务类型(展示)'' AFTER `pallet_type`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_pallet' AND COLUMN_NAME = 'group_destination') = 0,
  'ALTER TABLE `wms_pallet` ADD COLUMN `group_destination` varchar(256) DEFAULT NULL COMMENT ''分组/目的地(展示)'' AFTER `business_type_name`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 状态迁移：在库 / 已出单 / 出库
UPDATE `wms_pallet` SET `pallet_status` = 'IN_STOCK' WHERE `id` > 0 AND `pallet_status` IN ('CREATED', 'PUTAWAY', 'PARTIAL_LOCKED', 'LOCKED');
UPDATE `wms_pallet` SET `pallet_status` = 'OUTBOUND' WHERE `id` > 0 AND `pallet_status` = 'SHIPPED';

-- ========== wms_pallet_item ==========
SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_pallet_item' AND COLUMN_NAME = 'business_type_name') = 0,
  'ALTER TABLE `wms_pallet_item` ADD COLUMN `business_type_name` varchar(128) DEFAULT NULL COMMENT ''业务类型'' AFTER `cargo_order_no`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_pallet_item' AND COLUMN_NAME = 'group_destination') = 0,
  'ALTER TABLE `wms_pallet_item` ADD COLUMN `group_destination` varchar(128) DEFAULT NULL COMMENT ''分组/目的地'' AFTER `business_type_name`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_pallet_item' AND COLUMN_NAME = 'platform_name') = 0,
  'ALTER TABLE `wms_pallet_item` ADD COLUMN `platform_name` varchar(128) DEFAULT NULL COMMENT ''平台'' AFTER `group_destination`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_pallet_item' AND COLUMN_NAME = 'platform_warehouse_code') = 0,
  'ALTER TABLE `wms_pallet_item` ADD COLUMN `platform_warehouse_code` varchar(64) DEFAULT NULL COMMENT ''平台代码'' AFTER `platform_name`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_pallet_item' AND COLUMN_NAME = 'address_type') = 0,
  'ALTER TABLE `wms_pallet_item` ADD COLUMN `address_type` varchar(32) DEFAULT NULL COMMENT ''地址类型'' AFTER `platform_warehouse_code`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_pallet_item' AND COLUMN_NAME = 'po_no') = 0,
  'ALTER TABLE `wms_pallet_item` ADD COLUMN `po_no` varchar(64) DEFAULT NULL COMMENT ''PO号'' AFTER `shipment_code`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_pallet_item' AND COLUMN_NAME = 'shipping_mark') = 0,
  'ALTER TABLE `wms_pallet_item` ADD COLUMN `shipping_mark` varchar(128) DEFAULT NULL COMMENT ''唛头'' AFTER `po_no`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 从 OMS 回填展示字段（字段名对齐芋道 cargo_order / shipment 表）
UPDATE wms_pallet_item pi
INNER JOIN cargo_order co ON co.id = pi.cargo_order_id AND co.deleted = 0
SET
  pi.business_type_name = COALESCE(co.business_type_name, co.biz_type),
  pi.container_no = co.container_no,
  pi.group_destination = co.group_code,
  pi.platform_name = co.platform,
  pi.platform_warehouse_code = co.platform_address_code,
  pi.address_type = co.address_type
WHERE pi.id > 0;

UPDATE wms_pallet_item pi
INNER JOIN shipment cs ON cs.id = pi.shipment_id AND cs.deleted = 0
SET
  pi.po_no = cs.po_no,
  pi.shipping_mark = cs.goods_name,
  pi.group_destination = COALESCE(pi.group_destination, cs.group_code)
WHERE pi.id > 0;

UPDATE wms_pallet p
INNER JOIN (
  SELECT pallet_id,
    GROUP_CONCAT(DISTINCT business_type_name ORDER BY business_type_name SEPARATOR '、') AS business_type_name,
    GROUP_CONCAT(DISTINCT container_no ORDER BY container_no SEPARATOR '、') AS container_no,
    GROUP_CONCAT(DISTINCT group_destination ORDER BY group_destination SEPARATOR '、') AS group_destination
  FROM wms_pallet_item WHERE deleted = 0
  GROUP BY pallet_id
) agg ON agg.pallet_id = p.id
SET p.business_type_name = agg.business_type_name, p.container_no = agg.container_no, p.group_destination = agg.group_destination
WHERE p.id > 0;

-- ========== 字典（已迁移至 01-wms-dict.sql） ==========
/*
INSERT IGNORE INTO sys_dict_type(dict_id, tenant_id, dict_name, dict_type, create_time, remark)
VALUES (910109, '000000', 'WMS卡板类型', 'wms_pallet_type', NOW(), '常规/退货');

INSERT IGNORE INTO sys_dict_data(dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, list_class, is_default, create_time, remark)
VALUES
(9101091,'000000',1,'常规','NORMAL','wms_pallet_type','info','Y',NOW(),''),
(9101092,'000000',2,'退货','RETURN','wms_pallet_type','warning','N',NOW(),'');

DELETE FROM sys_dict_data WHERE dict_code > 0 AND dict_type = 'wms_pallet_status' AND dict_value IN ('CREATED', 'PUTAWAY', 'PARTIAL_LOCKED', 'LOCKED', 'SHIPPED');
INSERT IGNORE INTO sys_dict_data(dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, list_class, is_default, create_time, remark)
VALUES
(9101056,'000000',1,'在库','IN_STOCK','wms_pallet_status','success','Y',NOW(),''),
(9101057,'000000',2,'已出单','PRE_OUTBOUND','wms_pallet_status','info','N',NOW(),''),
(9101058,'000000',3,'出库','OUTBOUND','wms_pallet_status','default','N',NOW(),''),
(9101059,'000000',4,'HOLD','HOLD','wms_pallet_status','warning','N',NOW(),'订单拦截');

-- ========== 菜单权限（待转为 system_menu） ==========
INSERT IGNORE INTO sys_menu VALUES(6047, '卡板移库位', 6003, 1, '#', '', '', 1, 0, 'F', '0', '0', 'wms:pallet:moveLocation', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6048, '卡板出库', 6003, 2, '#', '', '', 1, 0, 'F', '0', '0', 'wms:pallet:outbound', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_role_menu(role_id, menu_id)
SELECT 1, menu_id FROM sys_menu WHERE menu_id IN (6047, 6048);
*/


-- ========== wms_pallet_container_no_20260602.sql ==========
-- 卡板/明细增加柜号展示字段（从 OMS 订单同步）

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_pallet' AND COLUMN_NAME = 'container_no') = 0,
  'ALTER TABLE `wms_pallet` ADD COLUMN `container_no` varchar(64) DEFAULT NULL COMMENT ''柜号(展示)'' AFTER `business_type_name`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_pallet_item' AND COLUMN_NAME = 'container_no') = 0,
  'ALTER TABLE `wms_pallet_item` ADD COLUMN `container_no` varchar(64) DEFAULT NULL COMMENT ''柜号'' AFTER `business_type_name`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

UPDATE wms_pallet_item pi
INNER JOIN cargo_order co ON co.id = pi.cargo_order_id AND co.deleted = 0
SET pi.container_no = co.container_no
WHERE pi.id > 0 AND co.container_no IS NOT NULL AND co.container_no != '';

UPDATE wms_pallet p
INNER JOIN (
  SELECT pallet_id,
    GROUP_CONCAT(DISTINCT container_no ORDER BY container_no SEPARATOR '、') AS container_no
  FROM wms_pallet_item WHERE deleted = 0 AND container_no IS NOT NULL AND container_no != ''
  GROUP BY pallet_id
) agg ON agg.pallet_id = p.id
SET p.container_no = agg.container_no
WHERE p.id > 0;


-- ========== wms_pallet_hold_20260602.sql ==========
-- 卡板 HOLD：明细 hold_flag 来自 OMS 订单；任一订单 HOLD 则卡板状态 HOLD

SET @sql = IF(
  (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'wms_pallet_item' AND COLUMN_NAME = 'hold_flag') = 0,
  'ALTER TABLE `wms_pallet_item` ADD COLUMN `hold_flag` tinyint NOT NULL DEFAULT 0 COMMENT ''订单HOLD(1=是)'' AFTER `address_type`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

UPDATE wms_pallet_item pi
INNER JOIN cargo_order co ON co.id = pi.cargo_order_id AND co.deleted = 0
SET pi.hold_flag = IF(co.hold_flag = 1 OR co.on_hold = 1 OR co.on_hold = b'1', 1, 0)
WHERE pi.id > 0;

UPDATE wms_pallet p
INNER JOIN (
  SELECT pallet_id, MAX(hold_flag) AS max_hold
  FROM wms_pallet_item WHERE deleted = 0
  GROUP BY pallet_id
) agg ON agg.pallet_id = p.id
SET p.pallet_status = 'HOLD'
WHERE p.id > 0
  AND p.pallet_status NOT IN ('OUTBOUND')
  AND agg.max_hold = 1;

/*
INSERT IGNORE INTO sys_dict_data(dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, list_class, is_default, create_time, remark)
VALUES (9101059, '000000', 4, 'HOLD', 'HOLD', 'wms_pallet_status', 'warning', 'N', NOW(), '订单拦截');


-- ========== wms_inventory_adjust_menu_20260602.sql ==========
-- 库存调整按钮权限（已有库执行一次即可）
INSERT IGNORE INTO sys_menu VALUES(6024, '库存调整', 6002, 4, '#', '', '', 1, 0, 'F', '0', '0', 'wms:inventory:adjust', '#', 103, 1, NOW(), NULL, NULL, '');


-- ========== wms_pallet_outbound_menu_20260602.sql ==========
-- 出库历史菜单（已有库执行一次）
INSERT IGNORE INTO sys_menu VALUES(6006, '出库历史', 6001, 5, 'pallet-outbound', 'wms/pallet-outbound/index', '', 1, 0, 'C', '0', '0', 'wms:pallet:list', 'ep:document', 103, 1, NOW(), NULL, NULL, '已出库卡板只读查询');


-- ========== wms_inventory_visualization_menu_20260602.sql ==========
-- 库存可视化菜单
INSERT IGNORE INTO sys_menu VALUES(6007, '库存可视化', 6001, 6, 'inventory-visualization', 'wms/inventory-visualization/index', '', 1, 0, 'C', '0', '0', 'wms:inventory:visualization', 'ep:data-analysis', 103, 1, NOW(), NULL, NULL, '仓库库位平面占用可视化');
INSERT IGNORE INTO sys_menu VALUES(6025, '可视化查询', 6007, 1, '#', '', '', 1, 0, 'F', '0', '0', 'wms:inventory:visualization', '#', 103, 1, NOW(), NULL, NULL, '');
*/


-- ========== wms_devanning_order_20260603.sql ==========
-- WMS 拆柜订单 PRD v1.0

CREATE TABLE IF NOT EXISTS `wms_devanning_order` (
  `id`                      BIGINT          NOT NULL                        COMMENT '主键',
  `tenant_id`               VARCHAR(20)     NOT NULL DEFAULT '000000'       COMMENT '租户ID',
  `company_id`              BIGINT          DEFAULT NULL                    COMMENT '主体公司ID',
  `warehouse_id`            BIGINT          NOT NULL                        COMMENT '仓库ID',
  `biz_root_id`             BIGINT          DEFAULT NULL                    COMMENT '业务主线ID',
  `devanning_no`            VARCHAR(64)     NOT NULL                        COMMENT 'WMS工作单号',
  `source_order_id`         BIGINT          DEFAULT NULL                    COMMENT '来源单ID',
  `source_order_no`         VARCHAR(64)     DEFAULT NULL                    COMMENT '来源单号',
  `source_order_type`       VARCHAR(30)     DEFAULT NULL                    COMMENT '来源单类型',
  `container_no`            VARCHAR(64)     DEFAULT NULL                    COMMENT '柜号',
  `customer_id`             BIGINT          DEFAULT NULL                    COMMENT '客户ID',
  `customer_name`           VARCHAR(100)    DEFAULT NULL                    COMMENT '客户名称',
  `channel_id`              BIGINT          DEFAULT NULL                    COMMENT '渠道ID',
  `channel_name`            VARCHAR(100)    DEFAULT NULL                    COMMENT '渠道名称',
  `customer_service_id`     BIGINT          DEFAULT NULL                    COMMENT '客服ID',
  `customer_service_name`   VARCHAR(50)     DEFAULT NULL                    COMMENT '客服姓名',
  `eta_warehouse_time`      DATETIME        DEFAULT NULL                    COMMENT 'ETA预计到仓',
  `pickup_time`             DATETIME        DEFAULT NULL                    COMMENT '提柜时间',
  `actual_arrival_time`     DATETIME        DEFAULT NULL                    COMMENT '实际到仓时间',
  `planned_devanning_time`  DATETIME        DEFAULT NULL                    COMMENT '预计拆柜时间',
  `devanning_start_time`    DATETIME        DEFAULT NULL                    COMMENT '拆柜开始时间',
  `devanning_finish_time`   DATETIME        DEFAULT NULL                    COMMENT '拆柜完成时间',
  `dock_id`                 BIGINT          DEFAULT NULL                    COMMENT 'Dock ID',
  `dock_code`               VARCHAR(30)     DEFAULT NULL                    COMMENT 'Dock编号',
  `dock_assign_time`        DATETIME        DEFAULT NULL                    COMMENT 'Dock分配时间',
  `devanning_method`        VARCHAR(30)     NOT NULL DEFAULT 'MANUAL'       COMMENT '拆柜方式',
  `devanning_remark`        VARCHAR(500)    DEFAULT NULL                    COMMENT '拆柜备注',
  `planned_truck_qty`       INT             DEFAULT NULL                    COMMENT '预排车数',
  `planned_cbm`             DECIMAL(10,3)   DEFAULT NULL                    COMMENT '预排方数',
  `total_box_qty`           DECIMAL(10,0)   DEFAULT NULL                    COMMENT '总箱数',
  `total_weight`            DECIMAL(10,3)   DEFAULT NULL                    COMMENT '总重量kg',
  `total_cbm`               DECIMAL(10,3)   DEFAULT NULL                    COMMENT '总方数',
  `inbounded_box_qty`       DECIMAL(10,0)   NOT NULL DEFAULT 0              COMMENT '已入库箱数',
  `exception_flag`          TINYINT(1)      NOT NULL DEFAULT 0              COMMENT '异常标记',
  `exception_count`         INT             NOT NULL DEFAULT 0              COMMENT '异常次数',
  `attachment_urls`         TEXT            DEFAULT NULL                    COMMENT '附件JSON',
  `status`                  VARCHAR(30)     NOT NULL DEFAULT 'UNPICKEDUP'   COMMENT '状态',
  `version`                 INT             NOT NULL DEFAULT 0              COMMENT '乐观锁',
  `remark`                  VARCHAR(500)    DEFAULT NULL                    COMMENT '备注',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_devanning_no_tenant` (`devanning_no`, `tenant_id`),
  UNIQUE KEY `uk_source_order` (`source_order_id`, `source_order_type`, `deleted`),
  KEY `idx_tenant_status` (`tenant_id`, `status`),
  KEY `idx_warehouse_status` (`warehouse_id`, `status`),
  KEY `idx_container_no` (`container_no`),
  KEY `idx_biz_root_id` (`biz_root_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='WMS拆柜订单';

CREATE TABLE IF NOT EXISTS `wms_devanning_order_trace` (
  `id`                  BIGINT          NOT NULL                    COMMENT '主键',
  `tenant_id`           BIGINT          NOT NULL DEFAULT 0            COMMENT '租户编号',
  `devanning_order_id`  BIGINT          NOT NULL                    COMMENT '拆柜订单ID',
  `action_type`         VARCHAR(50)     NOT NULL                    COMMENT '动作类型',
  `before_status`       VARCHAR(30)     DEFAULT NULL                COMMENT '操作前状态',
  `after_status`        VARCHAR(30)     DEFAULT NULL                COMMENT '操作后状态',
  `action_content`      TEXT            DEFAULT NULL                COMMENT '描述',
  `operator_id`         BIGINT          DEFAULT NULL,
  `operator_name`       VARCHAR(50)     DEFAULT NULL,
  `action_time`         DATETIME        DEFAULT NULL,
  `creator`             VARCHAR(64)     DEFAULT ''                  COMMENT '创建者',
  `create_time`         DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater`             VARCHAR(64)     DEFAULT ''                  COMMENT '更新者',
  `update_time`         DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted`             BIT(1)          NOT NULL DEFAULT b'0'       COMMENT '是否删除',
  PRIMARY KEY (`id`),
  KEY `idx_devanning_order_id` (`devanning_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='WMS拆柜订单轨迹';

-- 拆柜字典/菜单（已迁移，字典见 01-wms-dict.sql）
/*
INSERT IGNORE INTO sys_dict_type(dict_id, tenant_id, dict_name, dict_type, create_dept, create_by, create_time, remark)
VALUES (7001001, '000000', 'WMS拆柜方式', 'wms_devanning_method', 103, 1, NOW(), '');
INSERT IGNORE INTO sys_dict_data(dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_dept, create_by, create_time)
VALUES
(70010011,'000000',1,'人工','MANUAL','wms_devanning_method','','default','Y',103,1,NOW()),
(70010012,'000000',2,'叉车','FORKLIFT','wms_devanning_method','','info','N',103,1,NOW()),
(70010013,'000000',3,'机械','MACHINE','wms_devanning_method','','primary','N',103,1,NOW());

INSERT IGNORE INTO sys_dict_type(dict_id, tenant_id, dict_name, dict_type, create_dept, create_by, create_time, remark)
VALUES (7001002, '000000', 'WMS来源单类型', 'wms_source_order_type', 103, 1, NOW(), '');
INSERT IGNORE INTO sys_dict_data(dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_dept, create_by, create_time)
VALUES
(70010021,'000000',1,'OMS海柜订单','CONTAINER_ORDER','wms_source_order_type','','info','Y',103,1,NOW()),
(70010022,'000000',2,'手动创建','MANUAL','wms_source_order_type','','default','N',103,1,NOW());

INSERT IGNORE INTO sys_dict_type(dict_id, tenant_id, dict_name, dict_type, create_dept, create_by, create_time, remark)
VALUES (7001003, '000000', 'WMS拆柜订单状态', 'wms_devanning_status', 103, 1, NOW(), '');
INSERT IGNORE INTO sys_dict_data(dict_code, tenant_id, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, create_dept, create_by, create_time)
VALUES
(70010031,'000000',1,'未提柜','UNPICKEDUP','wms_devanning_status','','default','N',103,1,NOW()),
(70010032,'000000',2,'已提柜','PICKEDUP','wms_devanning_status','','info','N',103,1,NOW()),
(70010033,'000000',3,'已到仓','ARRIVED','wms_devanning_status','','processing','N',103,1,NOW()),
(70010034,'000000',4,'拆柜中','DEVANNING','wms_devanning_status','','warning','N',103,1,NOW()),
(70010035,'000000',5,'拆柜完成','DEVANNED','wms_devanning_status','','success','N',103,1,NOW()),
(70010036,'000000',6,'异常','EXCEPTION','wms_devanning_status','','error','N',103,1,NOW()),
(70010037,'000000',7,'取消','CANCELLED','wms_devanning_status','','default','N',103,1,NOW());

INSERT IGNORE INTO sys_menu VALUES(6100, '订单管理', 6000, 3, 'order', NULL, '', 1, 0, 'M', '0', '0', '', 'ep:document', 103, 1, NOW(), NULL, NULL, 'WMS订单管理');
INSERT IGNORE INTO sys_menu VALUES(6101, '拆柜订单', 6100, 1, 'devanning-order', 'wms/devanning-order/index', '', 1, 0, 'C', '0', '0', 'wms:devanningOrder:list', 'ep:box', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6110, '拆柜订单详情', 6101, 1, '#', '', '', 1, 0, 'F', '0', '0', 'wms:devanningOrder:query', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6111, '拆柜订单新建', 6101, 2, '#', '', '', 1, 0, 'F', '0', '0', 'wms:devanningOrder:add', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6112, '拆柜订单编辑', 6101, 3, '#', '', '', 1, 0, 'F', '0', '0', 'wms:devanningOrder:edit', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6113, '确认提柜', 6101, 4, '#', '', '', 1, 0, 'F', '0', '0', 'wms:devanningOrder:confirmPickup', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6114, '到仓登记', 6101, 5, '#', '', '', 1, 0, 'F', '0', '0', 'wms:devanningOrder:confirmArrival', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6115, '开始拆柜', 6101, 6, '#', '', '', 1, 0, 'F', '0', '0', 'wms:devanningOrder:startDevanning', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6116, '完成拆柜', 6101, 7, '#', '', '', 1, 0, 'F', '0', '0', 'wms:devanningOrder:completeDevanning', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6117, '标记异常', 6101, 8, '#', '', '', 1, 0, 'F', '0', '0', 'wms:devanningOrder:markException', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6118, '解除异常', 6101, 9, '#', '', '', 1, 0, 'F', '0', '0', 'wms:devanningOrder:clearException', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6119, '取消拆柜', 6101, 10, '#', '', '', 1, 0, 'F', '0', '0', 'wms:devanningOrder:cancel', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6120, '入库计划', 6101, 11, '#', '', '', 1, 0, 'F', '0', '0', 'wms:devanningOrder:inboundPlan', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6121, '文件管理', 6101, 12, '#', '', '', 1, 0, 'F', '0', '0', 'wms:devanningOrder:attachment', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6122, '拆柜订单导出', 6101, 13, '#', '', '', 1, 0, 'F', '0', '0', 'wms:devanningOrder:export', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6123, 'OMS推单', 6101, 14, '#', '', '', 1, 0, 'F', '0', '0', 'wms:devanningOrder:push', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(6124, 'Dock同步', 6101, 15, '#', '', '', 1, 0, 'F', '0', '0', 'wms:devanningOrder:syncDock', '#', 103, 1, NOW(), NULL, NULL, '');

INSERT IGNORE INTO sys_role_menu(role_id, menu_id)
SELECT 1, menu_id FROM sys_menu WHERE menu_id BETWEEN 6100 AND 6124;
*/


