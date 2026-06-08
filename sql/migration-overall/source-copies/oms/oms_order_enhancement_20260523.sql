-- 海柜订单 & 货物订单附件、HOLD、拆单回并增强

CREATE TABLE IF NOT EXISTS `biz_attachment` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `biz_root_id` bigint DEFAULT NULL COMMENT '业务主线ID，海柜附件可为空',
  `target_type` varchar(64) NOT NULL COMMENT '目标类型：CARGO_ORDER/CARGO_SHIPMENT/CONTAINER_ORDER/POD/EXCEPTION',
  `target_id` bigint NOT NULL COMMENT '目标对象ID',
  `target_no` varchar(64) NOT NULL COMMENT '目标对象编号',
  `attachment_type` varchar(64) NOT NULL COMMENT '附件类型：DO/BOL/POD/INVOICE/EXCEPTION_IMAGE/CUSTOMER_FILE/OTHER',
  `file_name` varchar(255) NOT NULL COMMENT '文件名',
  `file_url` varchar(500) NOT NULL COMMENT '文件URL',
  `file_size` bigint DEFAULT NULL COMMENT '文件大小',
  `file_ext` varchar(32) DEFAULT NULL COMMENT '文件后缀',
  `mime_type` varchar(128) DEFAULT NULL COMMENT 'MIME类型',
  `customer_visible_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT '客户是否可见',
  `internal_visible_flag` tinyint(1) NOT NULL DEFAULT 1 COMMENT '内部是否可见',
  `upload_user_id` bigint DEFAULT NULL COMMENT '上传人ID',
  `upload_user_name` varchar(128) DEFAULT NULL COMMENT '上传人名称',
  `upload_time` datetime NOT NULL COMMENT '上传时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  KEY `idx_target` (`target_type`, `target_id`),
  KEY `idx_biz_root_id` (`biz_root_id`),
  KEY `idx_attachment_type` (`attachment_type`),
  KEY `idx_upload_time` (`upload_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='业务附件表';

CREATE TABLE IF NOT EXISTS `oms_cargo_order_hold_record` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `cargo_order_id` bigint NOT NULL COMMENT '货物订单ID',
  `cargo_order_no` varchar(64) NOT NULL COMMENT '货物订单号',
  `biz_root_id` bigint DEFAULT NULL COMMENT '业务主线ID',
  `hold_type` varchar(64) NOT NULL COMMENT '暂扣类型',
  `hold_reason` varchar(500) NOT NULL COMMENT '暂扣原因',
  `hold_status` varchar(32) NOT NULL COMMENT 'HOLDING/RELEASED',
  `hold_time` datetime NOT NULL COMMENT '暂扣时间',
  `hold_user_id` bigint DEFAULT NULL COMMENT '暂扣人ID',
  `hold_user_name` varchar(128) DEFAULT NULL COMMENT '暂扣人名称',
  `release_reason` varchar(500) DEFAULT NULL COMMENT '放行原因',
  `release_time` datetime DEFAULT NULL COMMENT '放行时间',
  `release_user_id` bigint DEFAULT NULL COMMENT '放行人ID',
  `release_user_name` varchar(128) DEFAULT NULL COMMENT '放行人名称',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`),
  KEY `idx_biz_root_id` (`biz_root_id`),
  KEY `idx_hold_status` (`hold_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='货物订单HOLD记录';

SET @schema_name = DATABASE();

SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_container_order' AND column_name = 'attachment_count') = 0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `attachment_count` int NOT NULL DEFAULT 0 COMMENT ''海柜附件总数'' AFTER `downstream_exception_count`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_container_order' AND column_name = 'do_attachment_count') = 0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `do_attachment_count` int NOT NULL DEFAULT 0 COMMENT ''DO附件数量'' AFTER `attachment_count`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_container_order' AND column_name = 'latest_attachment_time') = 0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `latest_attachment_time` datetime DEFAULT NULL COMMENT ''最近附件上传时间'' AFTER `do_attachment_count`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_container_order' AND column_name = 'latest_do_upload_time') = 0,
  'ALTER TABLE `oms_container_order` ADD COLUMN `latest_do_upload_time` datetime DEFAULT NULL COMMENT ''最近DO上传时间'' AFTER `latest_attachment_time`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'attachment_count') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `attachment_count` int NOT NULL DEFAULT 0 COMMENT ''本单附件数量'' AFTER `parent_order_id`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'pod_attachment_count') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `pod_attachment_count` int NOT NULL DEFAULT 0 COMMENT ''POD附件数量'' AFTER `attachment_count`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'exception_attachment_count') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `exception_attachment_count` int NOT NULL DEFAULT 0 COMMENT ''异常附件数量'' AFTER `pod_attachment_count`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'latest_attachment_time') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `latest_attachment_time` datetime DEFAULT NULL COMMENT ''最近附件上传时间'' AFTER `exception_attachment_count`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'hold_status') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `hold_status` varchar(32) NOT NULL DEFAULT ''NORMAL'' COMMENT ''NORMAL/HOLDING/RELEASED'' AFTER `hold_flag`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'hold_type') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `hold_type` varchar(64) DEFAULT NULL COMMENT ''暂扣类型'' AFTER `hold_status`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'hold_reason') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `hold_reason` varchar(500) DEFAULT NULL COMMENT ''当前暂扣原因'' AFTER `hold_type`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'hold_time') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `hold_time` datetime DEFAULT NULL COMMENT ''暂扣时间'' AFTER `hold_reason`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'hold_user_id') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `hold_user_id` bigint DEFAULT NULL COMMENT ''暂扣人ID'' AFTER `hold_time`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'hold_user_name') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `hold_user_name` varchar(128) DEFAULT NULL COMMENT ''暂扣人名称'' AFTER `hold_user_id`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'release_time') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `release_time` datetime DEFAULT NULL COMMENT ''最近放行时间'' AFTER `hold_user_name`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'parent_order_no') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `parent_order_no` varchar(64) DEFAULT NULL COMMENT ''父级货物订单号'' AFTER `parent_order_id`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'root_order_id') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `root_order_id` bigint DEFAULT NULL COMMENT ''最初原单ID'' AFTER `parent_order_no`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'root_order_no') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `root_order_no` varchar(64) DEFAULT NULL COMMENT ''最初原单号'' AFTER `root_order_id`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'split_flag') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `split_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT ''是否参与拆单'' AFTER `root_order_no`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'split_role') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `split_role` varchar(32) NOT NULL DEFAULT ''NORMAL'' COMMENT ''NORMAL/SPLIT_PARENT/SPLIT_CHILD'' AFTER `split_flag`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'split_status') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `split_status` varchar(32) NOT NULL DEFAULT ''NONE'' COMMENT ''NONE/SPLIT_ACTIVE/MERGED_BACK/PARTIAL_MERGED_BACK'' AFTER `split_role`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'split_group_no') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `split_group_no` varchar(64) DEFAULT NULL COMMENT ''拆单批次号'' AFTER `split_status`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'child_order_count') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `child_order_count` int NOT NULL DEFAULT 0 COMMENT ''子单数量'' AFTER `split_group_no`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'merged_back_time') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `merged_back_time` datetime DEFAULT NULL COMMENT ''回并时间'' AFTER `child_order_count`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'merged_back_by') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `merged_back_by` bigint DEFAULT NULL COMMENT ''回并人'' AFTER `merged_back_time`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'split_source') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `split_source` varchar(32) DEFAULT NULL COMMENT ''CUSTOMER/INTERNAL'' AFTER `merged_back_by`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'customer_visible_flag') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `customer_visible_flag` tinyint(1) NOT NULL DEFAULT 1 COMMENT ''客户是否可见'' AFTER `split_source`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'customer_split_reason') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `customer_split_reason` varchar(500) DEFAULT NULL COMMENT ''客户拆单原因'' AFTER `customer_visible_flag`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'internal_split_reason') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `internal_split_reason` varchar(500) DEFAULT NULL COMMENT ''内部拆单原因'' AFTER `customer_split_reason`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'split_requested_by') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `split_requested_by` varchar(32) DEFAULT NULL COMMENT ''发起来源'' AFTER `internal_split_reason`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'split_requested_user_id') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `split_requested_user_id` bigint DEFAULT NULL COMMENT ''发起人ID'' AFTER `split_requested_by`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'split_requested_user_name') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `split_requested_user_name` varchar(128) DEFAULT NULL COMMENT ''发起人名称'' AFTER `split_requested_user_id`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'split_time') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `split_time` datetime DEFAULT NULL COMMENT ''拆单时间'' AFTER `split_requested_user_name`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'split_fee_flag') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `split_fee_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT ''是否可能产生拆单费用'' AFTER `split_time`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'split_fee_amount') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `split_fee_amount` decimal(10,2) DEFAULT NULL COMMENT ''拆单费用'' AFTER `split_fee_flag`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = @schema_name AND table_name = 'oms_cargo_order' AND column_name = 'split_fee_remark') = 0,
  'ALTER TABLE `oms_cargo_order` ADD COLUMN `split_fee_remark` varchar(500) DEFAULT NULL COMMENT ''拆单费用备注'' AFTER `split_fee_amount`',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

INSERT IGNORE INTO sys_menu VALUES(3016, '上传DO', 3001, 7, '#', '', '', 1, 0, 'F', '0', '0', 'oms:containerOrder:uploadDo', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3017, '上传海柜附件', 3001, 8, '#', '', '', 1, 0, 'F', '0', '0', 'oms:containerOrder:attachmentUpload', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3018, '删除海柜附件', 3001, 9, '#', '', '', 1, 0, 'F', '0', '0', 'oms:containerOrder:attachmentRemove', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3019, '入库计划', 3001, 10, '#', '', '', 1, 0, 'F', '0', '0', 'oms:containerOrder:inboundPlan', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3046, '上传货物附件', 3002, 41, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:attachmentUpload', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3047, '删除货物附件', 3002, 42, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:attachmentRemove', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3048, '货物暂扣', 3002, 43, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:hold', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3049, '货物放行', 3002, 44, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:releaseHold', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3050, '货物拆单', 3002, 45, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:split', '#', 103, 1, NOW(), NULL, NULL, '');
INSERT IGNORE INTO sys_menu VALUES(3051, '回并原单', 3002, 46, '#', '', '', 1, 0, 'F', '0', '0', 'oms:cargoOrder:mergeBack', '#', 103, 1, NOW(), NULL, NULL, '');
