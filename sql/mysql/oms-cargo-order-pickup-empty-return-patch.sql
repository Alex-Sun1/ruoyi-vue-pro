-- ============================================================
-- Patch: add pickup / devanning / empty-return columns to cargo_order
-- ============================================================

ALTER TABLE cargo_order ADD COLUMN IF NOT EXISTS pickup_appointment_no   VARCHAR(100)  DEFAULT NULL COMMENT '提柜预约单号';
ALTER TABLE cargo_order ADD COLUMN IF NOT EXISTS pickup_appointment_time  DATETIME      DEFAULT NULL COMMENT '提柜预约时间';
ALTER TABLE cargo_order ADD COLUMN IF NOT EXISTS pickup_remark            VARCHAR(500)  DEFAULT NULL COMMENT '提柜备注';
ALTER TABLE cargo_order ADD COLUMN IF NOT EXISTS arrival_remark           VARCHAR(500)  DEFAULT NULL COMMENT '到港备注';
ALTER TABLE cargo_order ADD COLUMN IF NOT EXISTS devanning_remark         VARCHAR(500)  DEFAULT NULL COMMENT '拆柜备注';
ALTER TABLE cargo_order ADD COLUMN IF NOT EXISTS empty_return_location    VARCHAR(200)  DEFAULT NULL COMMENT '还柜地点';
ALTER TABLE cargo_order ADD COLUMN IF NOT EXISTS empty_return_appointment_no VARCHAR(100) DEFAULT NULL COMMENT '还柜预约单号';
ALTER TABLE cargo_order ADD COLUMN IF NOT EXISTS empty_return_time        DATETIME      DEFAULT NULL COMMENT '还柜时间';
ALTER TABLE cargo_order ADD COLUMN IF NOT EXISTS empty_return_status      VARCHAR(50)   DEFAULT NULL COMMENT '还柜状态';
ALTER TABLE cargo_order ADD COLUMN IF NOT EXISTS empty_return_remark      VARCHAR(500)  DEFAULT NULL COMMENT '还柜备注';
