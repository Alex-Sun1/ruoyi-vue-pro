-- ============================================================
-- Patch: add address / transfer / carrier columns to oms_outbound_order
-- ============================================================

ALTER TABLE oms_outbound_order ADD COLUMN IF NOT EXISTS transfer_out_warehouse_id  BIGINT        DEFAULT NULL COMMENT '转出仓库ID';
ALTER TABLE oms_outbound_order ADD COLUMN IF NOT EXISTS estimated_transfer_time    DATETIME      DEFAULT NULL COMMENT '预计转仓时间';
ALTER TABLE oms_outbound_order ADD COLUMN IF NOT EXISTS address_line1              VARCHAR(255)  DEFAULT NULL COMMENT '地址行1';
ALTER TABLE oms_outbound_order ADD COLUMN IF NOT EXISTS address_line2              VARCHAR(255)  DEFAULT NULL COMMENT '地址行2';
ALTER TABLE oms_outbound_order ADD COLUMN IF NOT EXISTS city                       VARCHAR(100)  DEFAULT NULL COMMENT '城市';
ALTER TABLE oms_outbound_order ADD COLUMN IF NOT EXISTS state                      VARCHAR(100)  DEFAULT NULL COMMENT '州/省';
ALTER TABLE oms_outbound_order ADD COLUMN IF NOT EXISTS zip_code                   VARCHAR(20)   DEFAULT NULL COMMENT '邮编';
ALTER TABLE oms_outbound_order ADD COLUMN IF NOT EXISTS country                    VARCHAR(50)   DEFAULT NULL COMMENT '国家';
ALTER TABLE oms_outbound_order ADD COLUMN IF NOT EXISTS carrier                    VARCHAR(100)  DEFAULT NULL COMMENT '承运商';
ALTER TABLE oms_outbound_order ADD COLUMN IF NOT EXISTS tracking_no                VARCHAR(100)  DEFAULT NULL COMMENT '追踪单号';
ALTER TABLE oms_outbound_order ADD COLUMN IF NOT EXISTS actual_signed_time         DATETIME      DEFAULT NULL COMMENT '实际签收时间';
ALTER TABLE oms_outbound_order ADD COLUMN IF NOT EXISTS dispatch_remark            VARCHAR(500)  DEFAULT NULL COMMENT '派送备注';
ALTER TABLE oms_outbound_order ADD COLUMN IF NOT EXISTS operation_remark           VARCHAR(500)  DEFAULT NULL COMMENT '操作备注';
