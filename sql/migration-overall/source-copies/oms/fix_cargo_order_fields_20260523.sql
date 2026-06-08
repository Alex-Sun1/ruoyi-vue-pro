-- ============================================================
-- Patch: oms_cargo_order 补充字段（可重复执行）
-- 日期: 2026-05-23
-- 说明: 新增 HOLD、派送LFD、跟进记录、货件汇总聚合字段
-- 执行前提: cargo_order_ddl.sql 已执行（oms_cargo_order 表存在）
-- ============================================================

-- 临时存储过程：列不存在才执行 ALTER（MySQL 兼容，可重复跑）
DROP PROCEDURE IF EXISTS `_add_col`;
DELIMITER $$
CREATE PROCEDURE `_add_col`(
  IN p_table  VARCHAR(64),
  IN p_col    VARCHAR(64),
  IN p_def    TEXT
)
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME   = p_table
      AND COLUMN_NAME  = p_col
  ) THEN
    SET @_ddl = CONCAT('ALTER TABLE `', p_table, '` ADD COLUMN ', p_def);
    PREPARE _s FROM @_ddl;
    EXECUTE _s;
    DEALLOCATE PREPARE _s;
  END IF;
END$$
DELIMITER ;

-- 1. 货件汇总聚合字段（服务层聚合回写，供列表展示）
CALL _add_col('oms_cargo_order', 'shipment_codes',
  '`shipment_codes` varchar(2000) DEFAULT NULL COMMENT ''货件编码汇总（逗号分隔，服务层聚合回写）'' AFTER `biz_root_id`');
CALL _add_col('oms_cargo_order', 'po_nos',
  '`po_nos` varchar(2000) DEFAULT NULL COMMENT ''PO号汇总（逗号分隔，服务层聚合回写）'' AFTER `shipment_codes`');
CALL _add_col('oms_cargo_order', 'marks',
  '`marks` varchar(2000) DEFAULT NULL COMMENT ''唛头汇总（逗号分隔，服务层聚合回写）'' AFTER `po_nos`');

-- 2. HOLD 标志（货物订单维度，区别于海柜 Hold）
CALL _add_col('oms_cargo_order', 'hold_flag',
  '`hold_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT ''HOLD标志（0正常/1HOLD中）'' AFTER `exception_count`');
CALL _add_col('oms_cargo_order', 'hold_status',
  '`hold_status` varchar(32) NOT NULL DEFAULT ''NORMAL'' COMMENT ''NORMAL/HOLDING/RELEASED'' AFTER `hold_flag`');
CALL _add_col('oms_cargo_order', 'hold_type',
  '`hold_type` varchar(64) DEFAULT NULL COMMENT ''暂扣类型'' AFTER `hold_status`');
CALL _add_col('oms_cargo_order', 'hold_reason',
  '`hold_reason` varchar(500) DEFAULT NULL COMMENT ''当前暂扣原因'' AFTER `hold_type`');
CALL _add_col('oms_cargo_order', 'hold_time',
  '`hold_time` datetime DEFAULT NULL COMMENT ''暂扣时间'' AFTER `hold_reason`');
CALL _add_col('oms_cargo_order', 'hold_user_id',
  '`hold_user_id` bigint DEFAULT NULL COMMENT ''暂扣人ID'' AFTER `hold_time`');
CALL _add_col('oms_cargo_order', 'hold_user_name',
  '`hold_user_name` varchar(128) DEFAULT NULL COMMENT ''暂扣人名称'' AFTER `hold_user_id`');
CALL _add_col('oms_cargo_order', 'release_time',
  '`release_time` datetime DEFAULT NULL COMMENT ''最近放行时间'' AFTER `hold_user_name`');
CALL _add_col('oms_cargo_order', 'hold_remark',
  '`hold_remark` varchar(500) DEFAULT NULL COMMENT ''HOLD原因/说明'' AFTER `hold_reason`');

-- 3. 派送LFD（最晚完成派送日期）
CALL _add_col('oms_cargo_order', 'delivery_lfd',
  '`delivery_lfd` datetime DEFAULT NULL COMMENT ''派送LFD（最晚完成派送日期）'' AFTER `actual_inbound_time`');

-- 4. 跟进记录
CALL _add_col('oms_cargo_order', 'follow_up_remark',
  '`follow_up_remark` text DEFAULT NULL COMMENT ''跟进记录（客服/运营跟进内容）'' AFTER `operation_remark`');

-- 5. oms_cargo_order_shipment 补充 create_dept
CALL _add_col('oms_cargo_order_shipment', 'create_dept',
  '`create_dept` bigint DEFAULT NULL COMMENT ''创建部门'' AFTER `deleted`');

-- 6. oms_cargo_order_sku_item 补充 create_dept
CALL _add_col('oms_cargo_order_sku_item', 'create_dept',
  '`create_dept` bigint DEFAULT NULL COMMENT ''创建部门'' AFTER `deleted`');

-- 清理临时存储过程
DROP PROCEDURE IF EXISTS `_add_col`;
