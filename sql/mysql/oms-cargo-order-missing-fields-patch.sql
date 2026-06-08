-- ============================================================
-- Patch: cargo_order 补充缺失字段
-- 对应 CargoOrderDO 新增字段同步至数据库
-- 执行方式：可重复执行（使用存储过程检测列是否存在）
-- 前置：oms-tables.sql / oms-tables-v11-alter.sql 已执行
-- ============================================================
SET NAMES utf8mb4;

DROP PROCEDURE IF EXISTS `_cargo_add_col`;
DELIMITER $$
CREATE PROCEDURE `_cargo_add_col`(
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

-- ===== 1. 订单基础 =====
CALL _cargo_add_col('cargo_order', 'cargo_order_no',
  '`cargo_order_no` varchar(64) DEFAULT NULL COMMENT ''货物订单号（新编号体系）''');

CALL _cargo_add_col('cargo_order', 'external_order_no',
  '`external_order_no` varchar(128) DEFAULT NULL COMMENT ''外部订单号（客户/来源系统）''');

CALL _cargo_add_col('cargo_order', 'order_source',
  '`order_source` varchar(32) DEFAULT NULL COMMENT ''订单来源(MANUAL/IMPORT/API/PORTAL)''');

CALL _cargo_add_col('cargo_order', 'business_type_id',
  '`business_type_id` bigint DEFAULT NULL COMMENT ''业务类型ID''');

CALL _cargo_add_col('cargo_order', 'channel_id',
  '`channel_id` bigint DEFAULT NULL COMMENT ''渠道ID''');

CALL _cargo_add_col('cargo_order', 'platform_id',
  '`platform_id` bigint DEFAULT NULL COMMENT ''平台ID''');

CALL _cargo_add_col('cargo_order', 'customer_service_id',
  '`customer_service_id` bigint DEFAULT NULL COMMENT ''客服ID''');

CALL _cargo_add_col('cargo_order', 'customer_service_name',
  '`customer_service_name` varchar(128) DEFAULT NULL COMMENT ''客服名称（冗余）''');

-- ===== 2. 快递派送 =====
CALL _cargo_add_col('cargo_order', 'parcel_carrier_name',
  '`parcel_carrier_name` varchar(128) DEFAULT NULL COMMENT ''快递商名称''');

CALL _cargo_add_col('cargo_order', 'parcel_tracking_no',
  '`parcel_tracking_no` varchar(128) DEFAULT NULL COMMENT ''快递追踪号''');

-- ===== 3. 货量计量 =====
CALL _cargo_add_col('cargo_order', 'forecast_qty_unit',
  '`forecast_qty_unit` varchar(32) NOT NULL DEFAULT ''BY_CARTON'' COMMENT ''预报计量单位 BY_CARTON/BY_PALLET''');

CALL _cargo_add_col('cargo_order', 'declared_carton_qty',
  '`declared_carton_qty` decimal(10,2) DEFAULT NULL COMMENT ''预报箱数''');

CALL _cargo_add_col('cargo_order', 'declared_pallet_qty',
  '`declared_pallet_qty` decimal(10,2) DEFAULT NULL COMMENT ''预报托盘数''');

CALL _cargo_add_col('cargo_order', 'declared_piece_qty',
  '`declared_piece_qty` decimal(12,2) DEFAULT NULL COMMENT ''预报件数''');

CALL _cargo_add_col('cargo_order', 'actual_carton_qty',
  '`actual_carton_qty` decimal(10,2) DEFAULT NULL COMMENT ''实际箱数''');

CALL _cargo_add_col('cargo_order', 'actual_piece_qty',
  '`actual_piece_qty` decimal(12,2) DEFAULT NULL COMMENT ''实际件数''');

CALL _cargo_add_col('cargo_order', 'actual_pallet_qty',
  '`actual_pallet_qty` decimal(10,2) DEFAULT NULL COMMENT ''实际托盘数（WMS打板统计）''');

CALL _cargo_add_col('cargo_order', 'declared_cbm',
  '`declared_cbm` decimal(12,3) DEFAULT NULL COMMENT ''预报体积(m³)''');

CALL _cargo_add_col('cargo_order', 'actual_cbm',
  '`actual_cbm` decimal(12,3) DEFAULT NULL COMMENT ''实际体积(m³)''');

CALL _cargo_add_col('cargo_order', 'weight_unit',
  '`weight_unit` varchar(16) NOT NULL DEFAULT ''KG'' COMMENT ''重量单位(KG/LB)''');

CALL _cargo_add_col('cargo_order', 'volume_unit',
  '`volume_unit` varchar(16) NOT NULL DEFAULT ''CBM'' COMMENT ''体积单位''');

-- ===== 4. 主状态 =====
CALL _cargo_add_col('cargo_order', 'order_status',
  '`order_status` varchar(32) NOT NULL DEFAULT ''NORMAL'' COMMENT ''订单状态(NORMAL/CANCELLED/CLOSED)''');

-- ===== 5. 关键时间节点 =====
CALL _cargo_add_col('cargo_order', 'ata',
  '`ata` datetime DEFAULT NULL COMMENT ''ATA实际到港''');

CALL _cargo_add_col('cargo_order', 'actual_pickup_time',
  '`actual_pickup_time` datetime DEFAULT NULL COMMENT ''实际提柜时间''');

CALL _cargo_add_col('cargo_order', 'actual_arrival_time',
  '`actual_arrival_time` datetime DEFAULT NULL COMMENT ''实际到仓时间''');

CALL _cargo_add_col('cargo_order', 'devanning_finish_time',
  '`devanning_finish_time` datetime DEFAULT NULL COMMENT ''拆柜完成时间''');

CALL _cargo_add_col('cargo_order', 'actual_inbound_time',
  '`actual_inbound_time` datetime DEFAULT NULL COMMENT ''入库完成时间''');

CALL _cargo_add_col('cargo_order', 'delivery_appointment_time',
  '`delivery_appointment_time` datetime DEFAULT NULL COMMENT ''派送预约时间''');

CALL _cargo_add_col('cargo_order', 'actual_outbound_time',
  '`actual_outbound_time` datetime DEFAULT NULL COMMENT ''实际出库时间''');

CALL _cargo_add_col('cargo_order', 'signed_time',
  '`signed_time` datetime DEFAULT NULL COMMENT ''签收时间''');

CALL _cargo_add_col('cargo_order', 'pod_upload_time',
  '`pod_upload_time` datetime DEFAULT NULL COMMENT ''POD回传时间''');

CALL _cargo_add_col('cargo_order', 'billing_time',
  '`billing_time` datetime DEFAULT NULL COMMENT ''出账单时间''');

CALL _cargo_add_col('cargo_order', 'completed_time',
  '`completed_time` datetime DEFAULT NULL COMMENT ''全链路完成时间''');

-- ===== 6. 异常 =====
CALL _cargo_add_col('cargo_order', 'exception_flag',
  '`exception_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT ''是否有未关闭异常''');

CALL _cargo_add_col('cargo_order', 'exception_count',
  '`exception_count` int NOT NULL DEFAULT 0 COMMENT ''未关闭异常数量''');

-- ===== 7. HOLD =====
CALL _cargo_add_col('cargo_order', 'hold_status',
  '`hold_status` varchar(32) NOT NULL DEFAULT ''NORMAL'' COMMENT ''NORMAL/HOLDING/RELEASED''');

CALL _cargo_add_col('cargo_order', 'hold_type',
  '`hold_type` varchar(64) DEFAULT NULL COMMENT ''暂扣类型''');

CALL _cargo_add_col('cargo_order', 'hold_reason',
  '`hold_reason` varchar(500) DEFAULT NULL COMMENT ''当前暂扣原因''');

CALL _cargo_add_col('cargo_order', 'hold_time',
  '`hold_time` datetime DEFAULT NULL COMMENT ''暂扣时间''');

CALL _cargo_add_col('cargo_order', 'hold_user_id',
  '`hold_user_id` bigint DEFAULT NULL COMMENT ''暂扣人ID''');

CALL _cargo_add_col('cargo_order', 'hold_user_name',
  '`hold_user_name` varchar(128) DEFAULT NULL COMMENT ''暂扣人名称''');

CALL _cargo_add_col('cargo_order', 'release_time',
  '`release_time` datetime DEFAULT NULL COMMENT ''最近放行时间''');

CALL _cargo_add_col('cargo_order', 'hold_remark',
  '`hold_remark` varchar(500) DEFAULT NULL COMMENT ''HOLD原因/说明''');

-- ===== 8. 拆单 =====
CALL _cargo_add_col('cargo_order', 'parent_order_id',
  '`parent_order_id` bigint DEFAULT NULL COMMENT ''父订单ID（由拆单产生时填写）''');

CALL _cargo_add_col('cargo_order', 'parent_order_no',
  '`parent_order_no` varchar(64) DEFAULT NULL COMMENT ''父订单号''');

CALL _cargo_add_col('cargo_order', 'root_order_id',
  '`root_order_id` bigint DEFAULT NULL COMMENT ''根订单ID''');

CALL _cargo_add_col('cargo_order', 'root_order_no',
  '`root_order_no` varchar(64) DEFAULT NULL COMMENT ''根订单号''');

CALL _cargo_add_col('cargo_order', 'split_flag',
  '`split_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT ''是否参与拆单''');

CALL _cargo_add_col('cargo_order', 'split_role',
  '`split_role` varchar(32) NOT NULL DEFAULT ''NORMAL'' COMMENT ''NORMAL/SPLIT_PARENT/SPLIT_CHILD''');

CALL _cargo_add_col('cargo_order', 'split_status',
  '`split_status` varchar(32) NOT NULL DEFAULT ''NONE'' COMMENT ''NONE/SPLIT_ACTIVE/MERGED_BACK/PARTIAL_MERGED_BACK''');

CALL _cargo_add_col('cargo_order', 'split_group_no',
  '`split_group_no` varchar(64) DEFAULT NULL COMMENT ''拆单批次号''');

CALL _cargo_add_col('cargo_order', 'child_order_count',
  '`child_order_count` int NOT NULL DEFAULT 0 COMMENT ''子单数量''');

CALL _cargo_add_col('cargo_order', 'merged_back_time',
  '`merged_back_time` datetime DEFAULT NULL COMMENT ''回并时间''');

CALL _cargo_add_col('cargo_order', 'merged_back_by',
  '`merged_back_by` bigint DEFAULT NULL COMMENT ''回并人ID''');

CALL _cargo_add_col('cargo_order', 'split_source',
  '`split_source` varchar(32) DEFAULT NULL COMMENT ''CUSTOMER/INTERNAL''');

CALL _cargo_add_col('cargo_order', 'customer_visible_flag',
  '`customer_visible_flag` tinyint(1) NOT NULL DEFAULT 1 COMMENT ''客户是否可见''');

CALL _cargo_add_col('cargo_order', 'customer_split_reason',
  '`customer_split_reason` varchar(500) DEFAULT NULL COMMENT ''客户拆单原因''');

CALL _cargo_add_col('cargo_order', 'internal_split_reason',
  '`internal_split_reason` varchar(500) DEFAULT NULL COMMENT ''内部拆单原因''');

CALL _cargo_add_col('cargo_order', 'split_requested_by',
  '`split_requested_by` varchar(32) DEFAULT NULL COMMENT ''发起来源''');

CALL _cargo_add_col('cargo_order', 'split_requested_user_id',
  '`split_requested_user_id` bigint DEFAULT NULL COMMENT ''发起人ID''');

CALL _cargo_add_col('cargo_order', 'split_requested_user_name',
  '`split_requested_user_name` varchar(128) DEFAULT NULL COMMENT ''发起人名称''');

CALL _cargo_add_col('cargo_order', 'split_time',
  '`split_time` datetime DEFAULT NULL COMMENT ''拆单时间''');

CALL _cargo_add_col('cargo_order', 'split_fee_flag',
  '`split_fee_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT ''是否可能产生拆单费用''');

CALL _cargo_add_col('cargo_order', 'split_fee_amount',
  '`split_fee_amount` decimal(10,2) DEFAULT NULL COMMENT ''拆单费用''');

CALL _cargo_add_col('cargo_order', 'split_fee_remark',
  '`split_fee_remark` varchar(500) DEFAULT NULL COMMENT ''拆单费用备注''');

-- ===== 9. 附件统计 =====
CALL _cargo_add_col('cargo_order', 'attachment_count',
  '`attachment_count` int NOT NULL DEFAULT 0 COMMENT ''附件总数''');

CALL _cargo_add_col('cargo_order', 'pod_attachment_count',
  '`pod_attachment_count` int NOT NULL DEFAULT 0 COMMENT ''POD附件数量''');

CALL _cargo_add_col('cargo_order', 'exception_attachment_count',
  '`exception_attachment_count` int NOT NULL DEFAULT 0 COMMENT ''异常附件数量''');

CALL _cargo_add_col('cargo_order', 'latest_attachment_time',
  '`latest_attachment_time` datetime DEFAULT NULL COMMENT ''最近附件上传时间''');

-- ===== 10. 备注扩展 =====
CALL _cargo_add_col('cargo_order', 'customer_remark',
  '`customer_remark` text DEFAULT NULL COMMENT ''客户备注''');

CALL _cargo_add_col('cargo_order', 'operation_remark',
  '`operation_remark` text DEFAULT NULL COMMENT ''操作备注''');

CALL _cargo_add_col('cargo_order', 'follow_up_remark',
  '`follow_up_remark` text DEFAULT NULL COMMENT ''跟进记录（客服/运营跟进内容）''');

-- ===== 清理 =====
DROP PROCEDURE IF EXISTS `_cargo_add_col`;
