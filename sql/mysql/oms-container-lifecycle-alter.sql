-- 海柜生命周期 / 受理字段（在 oms-tables.sql + v11 + create-alter 之后执行）
SET NAMES utf8mb4;

ALTER TABLE `oms_container_order`
    ADD COLUMN `lifecycle_phase` varchar(32) DEFAULT 'PENDING_ACCEPT' COMMENT '列表生命周期阶段（缓存）' AFTER `container_status`,
    ADD COLUMN `lifecycle_phase_override` varchar(32) DEFAULT NULL COMMENT '生命周期手工覆盖' AFTER `lifecycle_phase`,
    ADD COLUMN `accepted_at` datetime DEFAULT NULL COMMENT '受理时间' AFTER `lifecycle_phase_override`,
    ADD COLUMN `accepted_by` bigint DEFAULT NULL COMMENT '受理人用户ID' AFTER `accepted_at`,
    ADD KEY `idx_lifecycle_phase` (`lifecycle_phase`),
    ADD KEY `idx_accepted_at` (`accepted_at`);
