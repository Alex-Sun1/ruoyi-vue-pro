-- OMS 库结构自检（只读，用于判断还需执行哪份增量脚本）
-- 在目标库执行后看结果：有行=列已存在；无行=列缺失

SET NAMES utf8mb4;

SELECT 'v11 oms_container_order.transport_mode' AS check_item,
       COUNT(*) AS exists_flag
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'oms_container_order'
  AND COLUMN_NAME = 'transport_mode';

SELECT 'v11 cargo_order.goods_name' AS check_item,
       COUNT(*) AS exists_flag
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'cargo_order'
  AND COLUMN_NAME = 'goods_name';

SELECT 'create-alter oms_container_order.create_source' AS check_item,
       COUNT(*) AS exists_flag
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'oms_container_order'
  AND COLUMN_NAME = 'create_source';

SELECT 'create-alter cargo_order.delivery_method' AS check_item,
       COUNT(*) AS exists_flag
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'cargo_order'
  AND COLUMN_NAME = 'delivery_method';

SELECT 'create-alter shipment.shipment_code' AS check_item,
       COUNT(*) AS exists_flag
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'shipment'
  AND COLUMN_NAME = 'shipment_code';

SELECT 'create-alter shipment.goods_name' AS check_item,
       COUNT(*) AS exists_flag
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'shipment'
  AND COLUMN_NAME = 'goods_name';

SELECT 'create-alter cargo_order_item.shipment_id' AS check_item,
       COUNT(*) AS exists_flag
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'cargo_order_item'
  AND COLUMN_NAME = 'shipment_id';

SELECT 'create-alter base_sales_channel table' AS check_item,
       COUNT(*) AS exists_flag
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'base_sales_channel';

SELECT 'lifecycle-alter oms_container_order.lifecycle_phase' AS check_item,
       COUNT(*) AS exists_flag
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'oms_container_order'
  AND COLUMN_NAME = 'lifecycle_phase';

SELECT 'lifecycle-alter oms_container_order.accepted_at' AS check_item,
       COUNT(*) AS exists_flag
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'oms_container_order'
  AND COLUMN_NAME = 'accepted_at';

SELECT 'transfer-platform cargo_order.transfer_platform_address_id' AS check_item,
       COUNT(*) AS exists_flag
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'cargo_order'
  AND COLUMN_NAME = 'transfer_platform_address_id';

SELECT 'transfer-platform legacy cargo_order.transfer_warehouse_code' AS check_item,
       COUNT(*) AS exists_flag
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'cargo_order'
  AND COLUMN_NAME = 'transfer_warehouse_code';

SELECT 'express-carrier cargo_order.express_carrier' AS check_item,
       COUNT(*) AS exists_flag
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'cargo_order'
  AND COLUMN_NAME = 'express_carrier';
