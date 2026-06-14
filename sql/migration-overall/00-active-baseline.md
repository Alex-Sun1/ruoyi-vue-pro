# Active BASE/OMS/WMS/YMS SQL Baseline

This directory is the active baseline for the current codebase.

Run order for a clean or rebuilt business schema:

1. `01-wms-tables.sql`
2. `01-wms-dict.sql`
3. `01-wms-menu.sql`
4. `02-yms-tables.sql`
5. `02-yms-dict.sql`
6. `02-yms-menu.sql`
7. `02-yms-menu-batch2.sql`
8. `03-oms-patch.sql`
9. `03-oms-menu-ext.sql`
10. `04-base-missing.sql`
11. `05-schema-audit-fix.sql`
12. `06-oms-container-order-ext.sql`
13. `06-oms-container-order-menu.sql`
14. `07-core-baseline-guard.sql`

Legacy notes:

- `sql/mysql/oms-tables.sql` contains the old `cargo_order/cargo_order_item`
  schema and is not the active OMS baseline.
- The active OMS schema uses `oms_cargo_order`,
  `oms_cargo_order_shipment`, `oms_cargo_order_sku_item`,
  `oms_container_order`, `oms_pre_outbound`, and `oms_outbound_order`.
- `source-copies/` is reference material only. Do not use it as the release
  baseline unless a file is manually promoted into the ordered list above.
- New business tables should use Yudao audit fields:
  `creator`, `create_time`, `updater`, `update_time`, `deleted`, `tenant_id`.
- New business tables should use `utf8mb4_unicode_ci` unless the whole product
  baseline is intentionally moved to another collation.
