SET NAMES utf8mb4;

ALTER TABLE `cargo_order`
  ADD COLUMN `platform_address_id` bigint DEFAULT NULL COMMENT 'platform address id' AFTER `platform`,
  ADD COLUMN `platform_address_code` varchar(64) DEFAULT NULL COMMENT 'platform address code' AFTER `platform_address_id`,
  ADD COLUMN `platform_address_name` varchar(128) DEFAULT NULL COMMENT 'platform address name' AFTER `platform_address_code`,
  ADD COLUMN `platform_address_type` tinyint DEFAULT NULL COMMENT 'platform address type' AFTER `platform_address_name`,
  ADD COLUMN `delivery_country_code` varchar(8) DEFAULT NULL COMMENT 'delivery country code' AFTER `consignee_email`,
  ADD COLUMN `delivery_address2` varchar(255) DEFAULT NULL COMMENT 'delivery address line 2' AFTER `delivery_address`;

ALTER TABLE `oms_container_terminal_info`
  ADD COLUMN `pickup_lfd` datetime DEFAULT NULL COMMENT 'pickup lfd' AFTER `available_at`,
  ADD COLUMN `return_lfd` datetime DEFAULT NULL COMMENT 'return lfd' AFTER `pickup_lfd`,
  ADD COLUMN `chassis_free_until` datetime DEFAULT NULL COMMENT 'chassis free until' AFTER `return_lfd`;

ALTER TABLE `oms_container_transport_info`
  ADD COLUMN `appointment_time` datetime DEFAULT NULL COMMENT 'appointment time' AFTER `voyage_no`,
  ADD COLUMN `eta_warehouse` datetime DEFAULT NULL COMMENT 'eta warehouse' AFTER `appointment_time`,
  ADD COLUMN `required_warehouse_at` datetime DEFAULT NULL COMMENT 'required warehouse at' AFTER `eta_warehouse`,
  ADD COLUMN `driver_name` varchar(64) DEFAULT NULL COMMENT 'driver name' AFTER `required_warehouse_at`,
  ADD COLUMN `truck_plate` varchar(32) DEFAULT NULL COMMENT 'truck plate' AFTER `driver_name`,
  ADD COLUMN `chassis_no` varchar(64) DEFAULT NULL COMMENT 'chassis no' AFTER `truck_plate`,
  ADD COLUMN `dock_no` varchar(64) DEFAULT NULL COMMENT 'dock no' AFTER `chassis_no`;
