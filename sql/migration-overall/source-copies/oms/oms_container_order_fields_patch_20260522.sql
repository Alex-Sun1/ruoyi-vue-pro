-- 海柜订单字段补齐补丁，对齐《海柜订单页面字段设计_v1.2》

ALTER TABLE `oms_container_order`
  ADD COLUMN `inbound_warehouse_name` varchar(128) DEFAULT NULL COMMENT '入库仓库名称' AFTER `warehouse_id`,
  ADD COLUMN `order_source` varchar(32) NOT NULL DEFAULT 'MANUAL' COMMENT '订单来源' AFTER `container_order_no`,
  ADD COLUMN `hold_remark` varchar(500) DEFAULT NULL COMMENT 'Hold备注' AFTER `hold_types`,
  ADD COLUMN `exam_type` varchar(64) DEFAULT NULL COMMENT '查验类型' AFTER `exam_types`,
  ADD COLUMN `exam_remark` varchar(500) DEFAULT NULL COMMENT '查验备注' AFTER `exam_type`,
  ADD COLUMN `pickup_remark` text DEFAULT NULL COMMENT '提柜备注' AFTER `actual_pickup_time`,
  ADD COLUMN `arrival_remark` text DEFAULT NULL COMMENT '到仓备注' AFTER `container_location`,
  ADD COLUMN `devanning_no` varchar(64) DEFAULT NULL COMMENT '拆柜单号' AFTER `arrival_remark`,
  ADD COLUMN `expected_devanning_time` datetime DEFAULT NULL COMMENT '预计拆柜时间' AFTER `devanning_warehouse_id`,
  ADD COLUMN `loading_type` varchar(32) DEFAULT NULL COMMENT '装载类型' AFTER `devanning_method`,
  ADD COLUMN `sorting_method` varchar(32) DEFAULT NULL COMMENT '分货方式' AFTER `loading_type`,
  ADD COLUMN `devanning_remark` text DEFAULT NULL COMMENT '拆柜备注' AFTER `devanning_finish_time`,
  ADD COLUMN `empty_return_remark` text DEFAULT NULL COMMENT '还柜备注' AFTER `empty_return_status`;
