-- ============================================================
-- 06-oms-container-order-ext.sql
-- OMS 海柜订单兼容扩展（对齐参考 ContainerOrder）
-- 目标库：Yudao ruoyi-vue-pro（bigint tenant_id, creator/updater）
-- 可重复执行（条件 DDL）
-- ============================================================
SET NAMES utf8mb4;

DELIMITER $$

DROP PROCEDURE IF EXISTS `migration_add_column_if_missing`$$
CREATE PROCEDURE `migration_add_column_if_missing`(
    IN p_table VARCHAR(128), IN p_column VARCHAR(128), IN p_ddl TEXT)
BEGIN
    IF (SELECT COUNT(*) FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table AND COLUMN_NAME = p_column) = 0 THEN
        SET @sql = CONCAT('ALTER TABLE `', p_table, '` ADD COLUMN ', p_ddl);
        PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
    END IF;
END$$

DELIMITER ;

-- ===================== 1) 附件表 =====================
CREATE TABLE IF NOT EXISTS `biz_attachment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `biz_root_id` bigint DEFAULT NULL COMMENT '业务主线ID',
  `target_type` varchar(64) NOT NULL DEFAULT 'CONTAINER_ORDER' COMMENT '目标类型',
  `target_id` bigint NOT NULL COMMENT '目标ID',
  `target_no` varchar(64) DEFAULT NULL COMMENT '目标编号',
  `attachment_type` varchar(32) NOT NULL DEFAULT 'OTHER' COMMENT '附件类型',
  `file_name` varchar(255) NOT NULL COMMENT '文件名',
  `file_url` varchar(512) NOT NULL COMMENT '文件URL',
  `file_size` bigint DEFAULT NULL COMMENT '文件大小',
  `file_ext` varchar(32) DEFAULT NULL COMMENT '扩展名',
  `mime_type` varchar(128) DEFAULT NULL COMMENT 'MIME类型',
  `customer_visible_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT '客户可见',
  `internal_visible_flag` tinyint(1) NOT NULL DEFAULT 1 COMMENT '内部可见',
  `upload_user_id` bigint DEFAULT NULL COMMENT '上传人ID',
  `upload_user_name` varchar(64) DEFAULT NULL COMMENT '上传人',
  `upload_time` datetime DEFAULT NULL COMMENT '上传时间',
  `remark` varchar(512) DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (`id`),
  KEY `idx_target` (`target_type`, `target_id`),
  KEY `idx_upload_time` (`upload_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='业务附件';

-- ===================== 2) oms_container_order 字段补全 =====================
CALL migration_add_column_if_missing('oms_container_order', 'company_id',
    '`company_id` bigint DEFAULT NULL COMMENT ''主体公司ID'' AFTER `id`');
CALL migration_add_column_if_missing('oms_container_order', 'owner_user_id',
    '`owner_user_id` bigint DEFAULT NULL COMMENT ''货主/Owner用户ID'' AFTER `channel_id`');
CALL migration_add_column_if_missing('oms_container_order', 'seal_no',
    '`seal_no` varchar(64) DEFAULT NULL COMMENT ''封条号'' AFTER `container_type`');
CALL migration_add_column_if_missing('oms_container_order', 'mbl_no',
    '`mbl_no` varchar(64) DEFAULT NULL COMMENT ''MBL号'' AFTER `voyage_no`');
CALL migration_add_column_if_missing('oms_container_order', 'hbl_no',
    '`hbl_no` varchar(64) DEFAULT NULL COMMENT ''HBL号'' AFTER `mbl_no`');
CALL migration_add_column_if_missing('oms_container_order', 'terminal_release_status',
    '`terminal_release_status` varchar(32) DEFAULT ''UNKNOWN'' COMMENT ''码头放行状态'' AFTER `return_lfd`');
CALL migration_add_column_if_missing('oms_container_order', 'container_location',
    '`container_location` varchar(255) DEFAULT NULL COMMENT ''柜当前位置'' AFTER `actual_arrival_time`');
CALL migration_add_column_if_missing('oms_container_order', 'devanning_method',
    '`devanning_method` varchar(32) DEFAULT NULL COMMENT ''拆柜方式'' AFTER `devanning_appointment_time`');
CALL migration_add_column_if_missing('oms_container_order', 'loading_type',
    '`loading_type` varchar(32) DEFAULT NULL COMMENT ''装卸类型'' AFTER `devanning_method`');
CALL migration_add_column_if_missing('oms_container_order', 'sorting_method',
    '`sorting_method` varchar(32) DEFAULT NULL COMMENT ''分拣方式'' AFTER `loading_type`');
CALL migration_add_column_if_missing('oms_container_order', 'container_order_no',
    '`container_order_no` varchar(64) DEFAULT NULL COMMENT ''兼容单号别名'' AFTER `work_order_no`');
CALL migration_add_column_if_missing('oms_container_order', 'attachment_count',
    '`attachment_count` int NOT NULL DEFAULT 0 COMMENT ''附件总数'' AFTER `downstream_exception_flag`');
CALL migration_add_column_if_missing('oms_container_order', 'do_attachment_count',
    '`do_attachment_count` int NOT NULL DEFAULT 0 COMMENT ''DO附件数'' AFTER `attachment_count`');
CALL migration_add_column_if_missing('oms_container_order', 'latest_attachment_time',
    '`latest_attachment_time` datetime DEFAULT NULL COMMENT ''最新附件时间'' AFTER `do_attachment_count`');
CALL migration_add_column_if_missing('oms_container_order', 'latest_do_upload_time',
    '`latest_do_upload_time` datetime DEFAULT NULL COMMENT ''最新DO上传时间'' AFTER `latest_attachment_time`');

-- container_order_no 回填（仅空值）
UPDATE `oms_container_order`
SET `container_order_no` = `work_order_no`
WHERE `id` > 0 AND (`container_order_no` IS NULL OR `container_order_no` = '');

DROP PROCEDURE IF EXISTS `migration_add_column_if_missing`;
-- ============================================================
-- 06-oms-container-order-ext.sql
-- 海柜订单（柜单管理）参考系统字段 + 业务附件表
-- 依赖：03-oms-patch.sql、05-schema-audit-fix.sql
-- ============================================================

SET NAMES utf8mb4;

-- ========== 业务附件表 ==========
CREATE TABLE IF NOT EXISTS `biz_attachment` (
  `id` bigint NOT NULL COMMENT '主键ID',
  `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  `biz_root_id` bigint DEFAULT NULL COMMENT '业务主线ID',
  `target_type` varchar(64) NOT NULL COMMENT 'CARGO_ORDER/CONTAINER_ORDER/POD/EXCEPTION',
  `target_id` bigint NOT NULL COMMENT '目标对象ID',
  `target_no` varchar(64) NOT NULL COMMENT '目标对象编号',
  `attachment_type` varchar(64) NOT NULL COMMENT 'DO/BOL/POD/INVOICE/EXCEPTION_IMAGE/CUSTOMER_FILE/OTHER',
  `file_name` varchar(255) NOT NULL COMMENT '文件名',
  `file_url` varchar(500) NOT NULL COMMENT '文件URL',
  `file_size` bigint DEFAULT NULL COMMENT '文件大小',
  `file_ext` varchar(32) DEFAULT NULL COMMENT '文件后缀',
  `mime_type` varchar(128) DEFAULT NULL COMMENT 'MIME类型',
  `customer_visible_flag` bit(1) NOT NULL DEFAULT b'0' COMMENT '客户可见',
  `internal_visible_flag` bit(1) NOT NULL DEFAULT b'1' COMMENT '内部可见',
  `upload_user_id` bigint DEFAULT NULL COMMENT '上传人ID',
  `upload_user_name` varchar(128) DEFAULT NULL COMMENT '上传人名称',
  `upload_time` datetime NOT NULL COMMENT '上传时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  PRIMARY KEY (`id`),
  KEY `idx_target` (`target_type`, `target_id`),
  KEY `idx_biz_root_id` (`biz_root_id`),
  KEY `idx_attachment_type` (`attachment_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='业务附件表';

DELIMITER $$

DROP PROCEDURE IF EXISTS `oms_add_column_if_missing`$$
CREATE PROCEDURE `oms_add_column_if_missing`(
    IN p_table VARCHAR(128), IN p_column VARCHAR(128), IN p_ddl TEXT)
BEGIN
    IF (SELECT COUNT(*) FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table AND COLUMN_NAME = p_column) = 0 THEN
        SET @sql = CONCAT('ALTER TABLE `', p_table, '` ADD COLUMN ', p_ddl);
        PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
    END IF;
END$$

DELIMITER ;

-- ========== oms_container_order 参考系统扩展字段 ==========
CALL oms_add_column_if_missing('oms_container_order', 'company_id',
    '`company_id` bigint DEFAULT NULL COMMENT ''主体公司ID'' AFTER `tenant_id`');
CALL oms_add_column_if_missing('oms_container_order', 'owner_user_id',
    '`owner_user_id` bigint DEFAULT NULL COMMENT ''负责人用户ID'' AFTER `cs_user_id`');
CALL oms_add_column_if_missing('oms_container_order', 'seal_no',
    '`seal_no` varchar(64) DEFAULT NULL COMMENT ''封条号'' AFTER `container_type`');
CALL oms_add_column_if_missing('oms_container_order', 'mbl_no',
    '`mbl_no` varchar(64) DEFAULT NULL COMMENT ''MBL提单号'' AFTER `bl_no`');
CALL oms_add_column_if_missing('oms_container_order', 'hbl_no',
    '`hbl_no` varchar(64) DEFAULT NULL COMMENT ''HBL提单号'' AFTER `mbl_no`');
CALL oms_add_column_if_missing('oms_container_order', 'terminal_release_status',
    '`terminal_release_status` varchar(32) DEFAULT NULL COMMENT ''码头释放状态'' AFTER `pod_code`');
CALL oms_add_column_if_missing('oms_container_order', 'container_location',
    '`container_location` varchar(64) DEFAULT NULL COMMENT ''海柜Location/月台'' AFTER `warehouse_id`');
CALL oms_add_column_if_missing('oms_container_order', 'devanning_method',
    '`devanning_method` varchar(32) DEFAULT NULL COMMENT ''拆柜方式'' AFTER `expected_devanning_time`');
CALL oms_add_column_if_missing('oms_container_order', 'loading_type',
    '`loading_type` varchar(32) DEFAULT NULL COMMENT ''装载类型'' AFTER `devanning_method`');
CALL oms_add_column_if_missing('oms_container_order', 'sorting_method',
    '`sorting_method` varchar(32) DEFAULT NULL COMMENT ''分货方式'' AFTER `loading_type`');
CALL oms_add_column_if_missing('oms_container_order', 'total_carton_qty',
    '`total_carton_qty` decimal(10,2) DEFAULT NULL COMMENT ''总箱数'' AFTER `pre_plan_cbm`');
CALL oms_add_column_if_missing('oms_container_order', 'total_pallet_qty',
    '`total_pallet_qty` decimal(10,2) DEFAULT NULL COMMENT ''总板数'' AFTER `total_carton_qty`');
CALL oms_add_column_if_missing('oms_container_order', 'container_exception_flag',
    '`container_exception_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT ''海柜异常标记'' AFTER `downstream_exception_flag`');
CALL oms_add_column_if_missing('oms_container_order', 'container_exception_reason',
    '`container_exception_reason` varchar(500) DEFAULT NULL COMMENT ''海柜异常原因'' AFTER `container_exception_flag`');
CALL oms_add_column_if_missing('oms_container_order', 'has_do_flag',
    '`has_do_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT ''是否已上传DO'' AFTER `container_exception_reason`');

DROP PROCEDURE IF EXISTS `oms_add_column_if_missing`;
