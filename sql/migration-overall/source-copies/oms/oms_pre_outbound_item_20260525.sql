-- 预出单明细行（关联货物订单，卡板维度展示由前端/后续打板功能扩展）

CREATE TABLE IF NOT EXISTS `oms_pre_outbound_item` (
  `id` bigint NOT NULL COMMENT 'ID',
  `tenant_id` varchar(20) NOT NULL DEFAULT '000000' COMMENT '租户ID',
  `pre_outbound_id` bigint NOT NULL COMMENT '预出单ID',
  `pre_outbound_no` varchar(64) NOT NULL COMMENT '预出单号',
  `cargo_order_id` bigint NOT NULL COMMENT '货物订单ID',
  `cargo_order_no` varchar(64) NOT NULL COMMENT '货物订单号',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_pre_outbound_cargo_tenant` (`pre_outbound_id`, `cargo_order_id`, `tenant_id`),
  KEY `idx_pre_outbound_id` (`pre_outbound_id`),
  KEY `idx_cargo_order_id` (`cargo_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='OMS预出单明细';

-- 历史数据回填
INSERT INTO `oms_pre_outbound_item` (
  `id`, `tenant_id`, `pre_outbound_id`, `pre_outbound_no`, `cargo_order_id`, `cargo_order_no`, `create_time`, `deleted`
)
SELECT
  `id` + 9000000000,
  `tenant_id`,
  `id`,
  `pre_outbound_no`,
  `cargo_order_id`,
  `cargo_order_no`,
  NOW(),
  0
FROM `oms_pre_outbound`
WHERE `deleted` = 0
  AND NOT EXISTS (
    SELECT 1 FROM `oms_pre_outbound_item` i
    WHERE i.`pre_outbound_id` = `oms_pre_outbound`.`id`
      AND i.`cargo_order_id` = `oms_pre_outbound`.`cargo_order_id`
      AND i.`deleted` = 0
  );
