-- 将 oms_route_node 数据迁移到 oms_order_route_node（对接手册表名）
-- 前置：已执行 oms-tables-v11-alter.sql
SET NAMES utf8mb4;

INSERT INTO `oms_order_route_node` (`cargo_order_id`, `node_code`, `node_name`, `node_time`, `sort_order`, `status`,
                                    `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`)
SELECT `cargo_order_id`, `node_code`, `node_name`, `node_time`, `sort_order`, 'pending',
       `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`
FROM `oms_route_node` r
WHERE NOT EXISTS (
    SELECT 1 FROM `oms_order_route_node` n
    WHERE n.`cargo_order_id` = r.`cargo_order_id` AND n.`node_code` = r.`node_code` AND n.`deleted` = r.`deleted`
);
