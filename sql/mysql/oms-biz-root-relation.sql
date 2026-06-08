-- OMS biz root relation table.
-- Cargo order owns biz_root_id. Aggregate/execution documents link to biz roots through this table.

CREATE TABLE IF NOT EXISTS `oms_biz_root_relation` (
  `id` bigint NOT NULL COMMENT 'ID',
  `tenant_id` bigint NOT NULL DEFAULT 1 COMMENT 'Tenant ID',
  `biz_root_id` bigint NOT NULL COMMENT 'Biz root ID',
  `cargo_order_id` bigint NOT NULL COMMENT 'Cargo order ID',
  `cargo_order_no` varchar(64) NOT NULL COMMENT 'Cargo order no',
  `target_module` varchar(32) NOT NULL DEFAULT 'OMS' COMMENT 'Target module',
  `target_type` varchar(64) NOT NULL COMMENT 'PRE_OUTBOUND/OUTBOUND_ORDER/INBOUND_PLAN/YARD_TASK',
  `target_id` bigint NOT NULL COMMENT 'Target document ID',
  `target_no` varchar(64) NOT NULL COMMENT 'Target document no',
  `relation_type` varchar(32) NOT NULL COMMENT 'AGGREGATED/EXECUTION/GENERATED',
  `relation_status` varchar(32) NOT NULL DEFAULT 'ACTIVE' COMMENT 'ACTIVE/INACTIVE',
  `creator` varchar(64) DEFAULT NULL COMMENT 'Creator',
  `create_time` datetime DEFAULT NULL COMMENT 'Create time',
  `updater` varchar(64) DEFAULT NULL COMMENT 'Updater',
  `update_time` datetime DEFAULT NULL COMMENT 'Update time',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT 'Deleted',
  PRIMARY KEY (`id`),
  KEY `idx_biz_root_id` (`biz_root_id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`),
  KEY `idx_target` (`target_type`, `target_id`),
  KEY `idx_target_no` (`target_type`, `target_no`),
  KEY `idx_relation_status` (`relation_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='OMS biz root relation';

INSERT INTO `oms_biz_root_relation` (
  `id`, `tenant_id`, `biz_root_id`, `cargo_order_id`, `cargo_order_no`,
  `target_module`, `target_type`, `target_id`, `target_no`,
  `relation_type`, `relation_status`, `create_time`, `update_time`, `deleted`
)
SELECT ABS(CAST(CRC32(CONCAT('PRE_OUTBOUND:', i.pre_outbound_id, ':', i.cargo_order_id)) AS SIGNED)) + 3000000000000000000,
       COALESCE(p.tenant_id, c.tenant_id), c.biz_root_id, c.id, c.cargo_order_no,
       'OMS', 'PRE_OUTBOUND', p.id, p.pre_outbound_no,
       'AGGREGATED',
       CASE WHEN p.deleted = 0 AND i.deleted = 0 THEN 'ACTIVE' ELSE 'INACTIVE' END,
       COALESCE(i.create_time, p.create_time, NOW()),
       NOW(),
       CASE WHEN p.deleted = 0 AND i.deleted = 0 THEN b'0' ELSE b'1' END
  FROM `oms_pre_outbound_item` i
  JOIN `oms_pre_outbound` p ON p.id = i.pre_outbound_id
  JOIN `oms_cargo_order` c ON c.id = i.cargo_order_id
 WHERE c.biz_root_id IS NOT NULL
   AND NOT EXISTS (
       SELECT 1 FROM `oms_biz_root_relation` r
        WHERE r.target_type = 'PRE_OUTBOUND'
          AND r.target_id = p.id
          AND r.cargo_order_id = c.id
   );

INSERT INTO `oms_biz_root_relation` (
  `id`, `tenant_id`, `biz_root_id`, `cargo_order_id`, `cargo_order_no`,
  `target_module`, `target_type`, `target_id`, `target_no`,
  `relation_type`, `relation_status`, `create_time`, `update_time`, `deleted`
)
SELECT ABS(CAST(CRC32(CONCAT('OUTBOUND_ORDER:', i.outbound_order_id, ':', i.cargo_order_id)) AS SIGNED)) + 4000000000000000000,
       COALESCE(o.tenant_id, c.tenant_id), c.biz_root_id, c.id, c.cargo_order_no,
       'OMS', 'OUTBOUND_ORDER', o.id, o.outbound_order_no,
       'EXECUTION',
       CASE WHEN o.deleted = 0 AND i.deleted = 0 THEN 'ACTIVE' ELSE 'INACTIVE' END,
       COALESCE(i.create_time, o.create_time, NOW()),
       NOW(),
       CASE WHEN o.deleted = 0 AND i.deleted = 0 THEN b'0' ELSE b'1' END
  FROM `oms_outbound_order_item` i
  JOIN `oms_outbound_order` o ON o.id = i.outbound_order_id
  JOIN `oms_cargo_order` c ON c.id = i.cargo_order_id
 WHERE c.biz_root_id IS NOT NULL
   AND NOT EXISTS (
       SELECT 1 FROM `oms_biz_root_relation` r
        WHERE r.target_type = 'OUTBOUND_ORDER'
          AND r.target_id = o.id
          AND r.cargo_order_id = c.id
   );

UPDATE `oms_pre_outbound`
   SET `biz_root_id` = NULL
 WHERE `biz_root_id` IS NOT NULL;

UPDATE `oms_outbound_order`
   SET `biz_root_id` = NULL
 WHERE `biz_root_id` IS NOT NULL;
