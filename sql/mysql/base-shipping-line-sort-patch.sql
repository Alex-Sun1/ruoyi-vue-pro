-- ============================================================
-- Patch: add sort column to base_shipping_line
-- ============================================================

ALTER TABLE base_shipping_line ADD COLUMN IF NOT EXISTS sort INT DEFAULT 0 COMMENT '排序';
