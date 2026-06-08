# 海外仓系统迁移 SQL 执行指南

> 来源：`e:\WMSProject\overallSystem`（RuoYi-Vue-Plus 参考系统）  
> 目标：`e:\wms\ruoyi-vue-pro`（Yudao / ruoyi-vue-pro）

## 执行前准备

1. **备份数据库**（必须）
2. 确认当前库已执行过项目自带脚本：`sql/mysql/base-*.sql`、`oms-*.sql`
3. 建议在测试库先完整跑一遍

## 推荐执行顺序

| 序号 | 文件/目录 | 说明 |
|------|-----------|------|
| 1 | `00-all-reference.sql` | 参考系统全量 DDL+种子（新库可直接用；已有库请跳过或按需抽取） |
| 2 | `source-copies/base/` | 基础资料增量脚本，按文件名日期顺序执行 |
| 3 | `source-copies/wms/` | WMS 表结构+菜单+字典 |
| 4 | `source-copies/yms/` | YMS 表结构+菜单+字典（先 `yms_m1_m7_migration_20260529.sql`） |
| 5 | `source-copies/oms/` | OMS 增量（出库/预出单/分组规则/生命周期等） |
| 6 | `source-copies/wms_inbound_plan.sql` | 入库计划表 |
| 7 | `source-copies/yms_m1_m7_migration.sql` | docs 目录 YMS 迁移补丁 |
| 8 | `01-wms-tables.sql` | WMS 表结构+字段补丁（**不含**字典/菜单） |
| 9 | `01-wms-dict.sql` | WMS 字典（芋道 `system_dict_type` / `system_dict_data` 格式） |
| 10 | `02-yms-tables.sql` | YMS 表结构+字段补丁（**不含**字典/菜单） |
| 10 | `02-yms-dict.sql` | YMS 字典（芋道 `system_dict_type` / `system_dict_data` 格式） |
| 11 | `03-oms-patch.sql` | OMS 缺失字段/表补丁 |
| 12 | `04-base-missing.sql` | 基础资料缺失表（航线/码头/船舶/堆场） |
| 13 | **`05-schema-audit-fix.sql`** | **WMS/YMS 审计字段修复（已跑旧迁移必执行）** |
| 14 | **`06-oms-container-order-ext.sql`** | **柜单管理：附件表 + 海柜扩展字段** |
| 15 | **`06-oms-container-order-menu.sql`** | **柜单管理菜单（6901 切到 container-order）** |
| 16 | `sql/mysql/oms-menu.sql` | OMS 根菜单（6900，若已执行可跳过） |
| 15 | `03-oms-menu-ext.sql` | OMS 增量菜单（入库计划/预出单/出单池/出库单/分组规则/事件日志） |
| 16 | `01-wms-menu.sql` | WMS 菜单与按钮（7100~7162） |
| 17 | `02-yms-menu.sql` | YMS 菜单与按钮（7500~7599） |
| 18 | `02-yms-menu-batch2.sql` | YMS 第二批菜单（7600~7643） |

## 各模块 source-copies 关键文件

### BASE（`source-copies/base/`）
- `base_all_basic_data_20260521.sql` — 全量基础资料
- `base_business_master_data_20260522.sql` — 渠道/业务类型/VAS
- `base_shipping_route_yard_dock_20260523.sql` — 航线+堆位
- `base_terminal_20260523.sql` — 码头
- `base_vessel_20260524.sql` — 船舶
- `yard_zone_slot_converge_20260529.sql` — 堆场收敛

### WMS（`source-copies/wms/`）
- `wms_inventory_base_20260601.sql` — 库存底座核心表
- `wms_zone_location_prd_20260601.sql` — 库区库位
- `wms_devanning_order_20260603.sql` — 拆柜单

### YMS（`source-copies/yms/`）
- `yms_m1_m7_migration_20260529.sql` — M1-M7 主迁移
- `yms_phase1_redesign_20260529.sql` — Phase1 重设计
- `yms_dock_converge_base_20260529.sql` — 月台收敛到 base

### OMS（`source-copies/oms/`）
- `cargo_order_ddl.sql` — 货物订单
- `oms_container_order_20260522.sql` — 海柜订单
- `oms_outbound_20260524.sql` — 出库单
- `oms_biz_root_lifecycle_20260527.sql` — 生命周期
- `oms_cargo_grouping_rule_20260527.sql` — 分组规则

## 注意事项

- 参考系统 `tenant_id` 为 `varchar(20)`，Yudao 默认为 `bigint`；若冲突需 ALTER
- 参考系统 `create_by/update_by` 为 `bigint`，Yudao 为 `varchar`；已有 base/oms 表以 Yudao 为准
- **字典**：参考系统用 `sys_dict_type`/`sys_dict_data`，芋道用 `system_dict_type`/`system_dict_data`；YMS 字典请执行 `02-yms-dict.sql`，勿执行 `02-yms-tables.sql` 中已注释的 sys_dict 段
- **菜单**：参考系统用 `sys_menu`，芋道用 `system_menu`；执行 `01-wms-menu.sql`、`02-yms-menu.sql`、`03-oms-menu-ext.sql` 后，在 **系统管理 → 角色管理** 勾选对应菜单，或取消脚本末尾 `system_role_menu` 注释一键授权超级管理员
- 字典类型前缀：`wms_*`、`yms_*`、`oms_*`

## 验证清单

- [ ] `wms_zone`、`wms_location`、`wms_inventory`、`wms_pallet` 表存在
- [ ] `wms_devanning_order` 表存在
- [ ] `yms_yard_task`、`yms_container_resource`、`yms_trailer_resource` 表存在
- [ ] `oms_pre_outbound`、`oms_outbound_order` 表存在
- [ ] `wms_inbound_plan` 表存在
- [ ] `base_shipping_route`、`base_terminal`、`base_vessel` 表存在
- [ ] 菜单 WMS/YMS/OMS 可见
