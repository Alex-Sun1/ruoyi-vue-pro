-- ============================================================
-- 补全 cargo_order 表字段（幂等，可重复执行）
-- 覆盖所有 CargoOrderDO 字段，与 OmsContainerCargoOrderRespVO 对齐
-- 执行顺序：此脚本在以下脚本之后执行
--   1. oms-cargo-order-missing-columns-patch.sql
--   2. oms-cargo-order-missing-fields-patch.sql
--   3. oms-cargo-order-express-carrier-alter.sql
--   4. oms-cargo-order-transfer-platform-alter.sql
--   5. oms-cargo-order-pickup-empty-return-patch.sql
-- ============================================================
SET NAMES utf8mb4;

DROP PROCEDURE IF EXISTS `_co_add`;
DELIMITER $$
CREATE PROCEDURE `_co_add`(IN p_col VARCHAR(64), IN p_def TEXT)
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME   = 'cargo_order'
      AND COLUMN_NAME  = p_col
  ) THEN
    SET @_sql = CONCAT('ALTER TABLE `cargo_order` ADD COLUMN ', p_def);
    PREPARE _st FROM @_sql;
    EXECUTE _st;
    DEALLOCATE PREPARE _st;
  END IF;
END$$
DELIMITER ;

-- ===== 收货地址补全 =====
CALL _co_add('delivery_address2',
  '`delivery_address2` varchar(512) DEFAULT NULL COMMENT ''地址 Line2''');

CALL _co_add('delivery_country_code',
  '`delivery_country_code` varchar(16) DEFAULT NULL COMMENT ''国家/地区代码''');

-- ===== 业务归属（冗余名称） =====
CALL _co_add('business_type_name',
  '`business_type_name` varchar(128) DEFAULT NULL COMMENT ''业务类型名称（冗余）''');

CALL _co_add('channel_name',
  '`channel_name` varchar(128) DEFAULT NULL COMMENT ''渠道名称（冗余）''');

-- ===== 重量 =====
CALL _co_add('gross_weight_kg',
  '`gross_weight_kg` decimal(12,3) DEFAULT NULL COMMENT ''货物总重量(kg)''');

-- ===== 内部备注 =====
CALL _co_add('internal_remark',
  '`internal_remark` text DEFAULT NULL COMMENT ''内部备注（不对客户展示）''');

-- ===== WMS 回写字段 =====
CALL _co_add('wms_exception_ctns',
  '`wms_exception_ctns` int DEFAULT 0 COMMENT ''WMS异常箱数''');

CALL _co_add('wms_storage_location',
  '`wms_storage_location` varchar(128) DEFAULT NULL COMMENT ''WMS库位''');

CALL _co_add('current_route_node',
  '`current_route_node` varchar(64) DEFAULT NULL COMMENT ''当前路由节点代码''');

CALL _co_add('calc_age_days',
  '`calc_age_days` int DEFAULT NULL COMMENT ''库龄（天，服务层计算回写）''');

CALL _co_add('calc_risk_level',
  '`calc_risk_level` varchar(32) DEFAULT NULL COMMENT ''风险等级（LOW/MEDIUM/HIGH，服务层评估）''');

-- ===== TMS 集成 =====
CALL _co_add('tms_order_id',
  '`tms_order_id` varchar(64) DEFAULT NULL COMMENT ''TMS订单ID''');

-- ===== 目的地城市（旧版冗余字段） =====
CALL _co_add('destination_city',
  '`destination_city` varchar(128) DEFAULT NULL COMMENT ''目的城市（兼容旧数据）''');

-- ===== 清理 =====
DROP PROCEDURE IF EXISTS `_co_add`;
