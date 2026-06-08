/**
 * 从 source-copies 生成 oms-init-from-reference.sql（UTF-8）
 * 规则（手工核对后的合并策略，非无脑拼接）：
 * - 不含 cargo_order_ddl（与 fix_cargo_order_schema Part1 重复）
 * - 不含 oms_container_order_fields_patch（列已在 oms_container_order CREATE 中）
 * - oms_container_order_20260522 只保留 biz_root / 海柜 / rel / trace，去掉旧版 oms_cargo_order*
 * - 不含 sys_dict / sys_menu / mock 数据
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.join(path.dirname(fileURLToPath(import.meta.url)), '..');
const omsSrc = path.join(root, 'sql/migration-overall/source-copies/oms');

const SOURCE_FILES = [
  'fix_cargo_order_schema_20260522.sql',
  'fix_cargo_order_fields_20260523.sql',
  'oms_container_order_20260522.sql',
  // 跳过 oms_container_order_fields_patch_20260522.sql
  'oms_container_order_enhancement_20260525.sql',
  'oms_order_enhancement_20260523.sql',
  'oms_cargo_grouping_rule_20260527.sql',
  'oms_biz_root_lifecycle_20260527.sql',
  'oms_cargo_order_enhancement_20260524.sql',
  'oms_outbound_20260524.sql',
  'oms_pre_outbound_item_20260525.sql',
  // 跳过 oms_pre_outbound_fields：列已在 oms_outbound CREATE 中
  'oms_outbound_1ton_refactor_20260526.sql',
  'oms_outbound_cleanup_cancelled_20260526.sql',
  'oms_cargo_order_summary_backfill_20260527.sql',
  'oms_container_pre_plan_backfill_20260525.sql',
];

const MENU_FILES = [
  'sql/mysql/oms-menu.sql',
  'sql/migration-overall/03-oms-menu-ext.sql',
];

const SYS_START =
  /^(INSERT\s+(IGNORE\s+)?INTO\s+`?sys_(dict|menu|role_menu)|UPDATE\s+`?sys_(dict|menu)|INSERT\s+(IGNORE\s+)?INTO\s+`?sys_role_menu)/i;

function stripSysStatements(text) {
  const lines = text.split(/\r?\n/);
  const out = [];
  let skipping = false;
  for (const line of lines) {
    const trimmed = line.trim();
    if (SYS_START.test(trimmed)) {
      skipping = true;
      if (trimmed.endsWith(';')) skipping = false;
      continue;
    }
    if (skipping) {
      if (trimmed.endsWith(';')) skipping = false;
      continue;
    }
    out.push(line);
  }
  return out.join('\n');
}

function truncateAtMockPart(text, fileName) {
  if (fileName === 'fix_cargo_order_schema_20260522.sql') {
    const idx = text.indexOf('-- Part 2: 重新插入演示数据');
    if (idx >= 0) text = text.slice(0, idx);
    text = text.replace(
      /DELETE FROM `oms_container_cargo_order_rel`[^\n]*\n/g,
      '-- [跳过 mock DELETE：关联表在后文 CREATE]\n',
    );
  }
  if (fileName === 'oms_outbound_20260524.sql') {
    const idx = text.search(/INSERT INTO `sys_dict_type`/);
    if (idx >= 0) {
      text = `${text.slice(0, idx).trimEnd()}\n\n-- [跳过 sys_dict / sys_menu / outbound mock；字典见 oms-dict-yudao.sql]\n`;
    }
  }
  return text;
}

/** 海柜 SQL 里旧版 oms_cargo_order / shipment 与 fix_cargo_order_schema 冲突，整段去掉 */
function stripLegacyCargoTablesFromContainerSql(text) {
  const start = text.indexOf('CREATE TABLE IF NOT EXISTS `oms_cargo_order`');
  const end = text.indexOf('CREATE TABLE IF NOT EXISTS `oms_container_cargo_order_rel`');
  if (start >= 0 && end > start) {
    text =
      text.slice(0, start) +
      '-- [跳过旧版 oms_cargo_order / oms_cargo_order_shipment：货物订单表见 fix_cargo_order_schema]\n\n' +
      text.slice(end);
  }
  // 参考 sys_menu 段
  const menuIdx = text.indexOf('-- 菜单与权限');
  if (menuIdx >= 0) {
    const relIdx = text.indexOf('CREATE TABLE IF NOT EXISTS `oms_container_cargo_order_rel`');
    if (relIdx >= 0 && menuIdx > relIdx) {
      text = text.slice(0, menuIdx).trimEnd() + '\n';
    }
  }
  return text;
}

/** 预出单明细脚本里的 INSERT 回填仅用于升级存量库，全新 init 不需要 */
function stripPreOutboundItemBackfill(text) {
  return text.replace(
    /-- 历史数据回填[\s\S]*?(?=\n-- =====|\n-- =|$)/,
    '-- [跳过历史回填：全新库无 oms_pre_outbound 存量，明细随业务创建]\n',
  );
}

const header = `-- OMS init（Yudao 手工整理版：DDL + 可重复补丁 + system_menu 6900+）
-- 说明：参考系统「建表」与「ADD COLUMN 补丁」不可重复；本文件已去重。
-- 维护：改 sql/migration-overall/source-copies/oms 后运行 node scripts/rebuild-oms-init.mjs
-- 执行顺序:
--   1. sql/mysql/oms-teardown.sql
--   2. sql/mysql/oms-init-from-reference.sql
--   3. sql/mysql/oms-dict-yudao.sql
--   4. sql/mysql/oms-supplement.sql
SET NAMES utf8mb4;

`;

const chunks = [header];

for (const file of SOURCE_FILES) {
  const full = path.join(omsSrc, file);
  if (!fs.existsSync(full)) {
    console.warn('skip missing:', file);
    continue;
  }
  let content = fs.readFileSync(full, 'utf8');
  content = truncateAtMockPart(content, file);
  if (file === 'oms_container_order_20260522.sql') {
    content = stripLegacyCargoTablesFromContainerSql(content);
  }
  if (file === 'oms_pre_outbound_item_20260525.sql') {
    content = stripPreOutboundItemBackfill(content);
  }
  content = stripSysStatements(content);
  chunks.push(`\n-- ===== ${file} =====\n`);
  chunks.push(content.trim());
  chunks.push('\n');
}

for (const rel of MENU_FILES) {
  const full = path.join(root, rel);
  if (!fs.existsSync(full)) continue;
  chunks.push(`\n-- ===== ${rel} =====\n`);
  chunks.push(fs.readFileSync(full, 'utf8').trim());
  chunks.push('\n');
}

const outPath = path.join(root, 'sql/mysql/oms-init-from-reference.sql');
fs.writeFileSync(outPath, chunks.join('\n'), 'utf8');
console.log('Wrote', outPath);
