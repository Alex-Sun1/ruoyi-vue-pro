-- 平台地址单板CBM、月台位置字典与快递商字典补丁

DROP PROCEDURE IF EXISTS add_platform_address_unit_pallet_cbm;
DELIMITER $$
CREATE PROCEDURE add_platform_address_unit_pallet_cbm()
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'platform_address'
      AND COLUMN_NAME = 'unit_pallet_cbm'
  ) THEN
    ALTER TABLE `platform_address`
      ADD COLUMN `unit_pallet_cbm` DECIMAL(10,3) DEFAULT 2.000 COMMENT '单板CBM，用于按目的仓预估卡板体积' AFTER `zip_code`;
  END IF;
END$$
DELIMITER ;
CALL add_platform_address_unit_pallet_cbm();
DROP PROCEDURE IF EXISTS add_platform_address_unit_pallet_cbm;

UPDATE `platform_address`
SET `unit_pallet_cbm` = 2.000
WHERE `unit_pallet_cbm` IS NULL;

INSERT INTO `sys_dict_type`
  (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `create_time`, `remark`)
VALUES
  (9005100, '000000', '月台位置类型', 'yard_location_type', NOW(), 'Dock location type'),
  (9005101, '000000', '月台位置', 'yard_dock_location', NOW(), 'Dock yard position'),
  (6000003004, '000000', 'OMS快递商', 'oms_parcel_carrier', NOW(), 'OMS快递派送承运商')
ON DUPLICATE KEY UPDATE
  `dict_name` = VALUES(`dict_name`),
  `remark` = VALUES(`remark`);

INSERT INTO `sys_dict_data`
  (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `list_class`, `is_default`, `create_time`, `remark`)
VALUES
  (9005200, '000000', 1, '道口', 'DOCK', 'yard_location_type', 'info', 'Y', NOW(), 'Dock'),
  (9005201, '000000', 2, '停车位', 'PARKING', 'yard_location_type', 'default', 'N', NOW(), 'Parking space'),
  (9005210, '000000', 1, '前院道口', 'FRONT_YARD_DOCK', 'yard_dock_location', 'success', 'N', NOW(), 'Front yard dock'),
  (9005211, '000000', 2, '后院道口', 'BACK_YARD_DOCK', 'yard_dock_location', 'info', 'Y', NOW(), 'Back yard dock'),
  (9005212, '000000', 3, '前院停车位', 'FRONT_YARD_PARKING', 'yard_dock_location', 'warning', 'N', NOW(), 'Front yard parking'),
  (9005213, '000000', 4, '后院停车位', 'BACK_YARD_PARKING', 'yard_dock_location', 'default', 'N', NOW(), 'Back yard parking'),
  (6000003401, '000000', 1, 'UPS', 'UPS', 'oms_parcel_carrier', 'primary', 'Y', NOW(), NULL),
  (6000003402, '000000', 2, 'FedEx', 'FedEx', 'oms_parcel_carrier', 'info', 'N', NOW(), NULL),
  (6000003403, '000000', 3, 'USPS', 'USPS', 'oms_parcel_carrier', 'success', 'N', NOW(), NULL),
  (6000003404, '000000', 4, 'DHL', 'DHL', 'oms_parcel_carrier', 'warning', 'N', NOW(), NULL),
  (6000003405, '000000', 5, 'OnTrac', 'OnTrac', 'oms_parcel_carrier', 'default', 'N', NOW(), NULL),
  (6000003406, '000000', 6, 'LaserShip', 'LaserShip', 'oms_parcel_carrier', 'default', 'N', NOW(), NULL),
  (6000003407, '000000', 7, 'Amazon Shipping', 'Amazon Shipping', 'oms_parcel_carrier', 'default', 'N', NOW(), NULL)
ON DUPLICATE KEY UPDATE
  `dict_label` = VALUES(`dict_label`),
  `dict_value` = VALUES(`dict_value`),
  `dict_type` = VALUES(`dict_type`),
  `dict_sort` = VALUES(`dict_sort`),
  `list_class` = VALUES(`list_class`),
  `is_default` = VALUES(`is_default`),
  `remark` = VALUES(`remark`);

UPDATE `oms_cargo_grouping_field_meta`
SET `data_type` = 'ENUM',
    `enum_code` = 'oms_parcel_carrier',
    `ref_type` = NULL,
    `can_be_condition` = 1,
    `can_be_group_key` = 1,
    `display_name` = '快递商'
WHERE `table_alias` = 'order'
  AND `field_name` = 'parcel_carrier_name';
