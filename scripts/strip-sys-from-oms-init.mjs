/**
 * Remove RuoYi-Vue-Plus sys_dict_* / sys_menu / sys_role_menu from oms-init SQL.
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const input = path.join(__dirname, '../sql/mysql/oms-init-from-reference.sql');

const lines = fs.readFileSync(input, 'utf8').split(/\r?\n/);

const SYS_START =
  /^(INSERT\s+(IGNORE\s+)?INTO\s+`?sys_(dict|menu|role_menu)|UPDATE\s+`?sys_(dict|menu)|INSERT\s+(IGNORE\s+)?INTO\s+`?sys_role_menu)/i;

function isSysDataTuple(line) {
  const t = line.trim();
  if (!t.startsWith('(')) return false;
  return (
    t.includes("'oms_") ||
    t.includes("'sys_") ||
    /^\(\d+,\s*'000000'/.test(t) ||
    (t.includes(", '#',") && t.includes("'oms:"))
  );
}

const out = [];
let skipUntilSemicolon = false;
let skipBlankSection = false;

for (let i = 0; i < lines.length; i++) {
  let line = lines[i];
  const trimmed = line.trim();

  // cleanup artifacts from previous partial run
  if (trimmed.startsWith('-- [skipped RuoYi-Vue-Plus sys_*')) continue;
  if (trimmed === 'VALUES') continue;
  if (/^VALUES\s*\(/.test(trimmed) && trimmed.includes("'oms_")) continue;
  if (/^FROM\s+`sys_menu`/i.test(trimmed)) continue;
  if (/^JOIN\s+`sys_(menu|role)/i.test(trimmed)) continue;
  if (/^SELECT\s+(1|r\.`role_id`)/i.test(trimmed) && i + 1 < lines.length && /sys_menu|sys_role/.test(lines[i + 1])) {
    skipUntilSemicolon = true;
    continue;
  }
  if (/^WHERE\s+`menu_id`\s+BETWEEN/i.test(trimmed)) continue;
  if (/^WHERE\s+r\.`role_key`/i.test(trimmed)) continue;

  if (skipUntilSemicolon) {
    if (trimmed.endsWith(';')) skipUntilSemicolon = false;
    continue;
  }

  if (SYS_START.test(trimmed)) {
    skipUntilSemicolon = !trimmed.endsWith(';');
    skipBlankSection = true;
    continue;
  }

  if (skipBlankSection) {
    if (
      trimmed === '' ||
      trimmed.startsWith('--') ||
      trimmed.startsWith('ON DUPLICATE KEY UPDATE') ||
      isSysDataTuple(line) ||
      /^VALUES\s*\(?/.test(trimmed) ||
      /^\s*`(?:menu_name|parent_id|order_num|path|component|perms|icon|dict_name|dict_label|dict_type|list_class|menu_type|visible|status)`\s*=/.test(line)
    ) {
      if (trimmed.startsWith('ON DUPLICATE KEY UPDATE')) {
        skipUntilSemicolon = true;
      }
      if (trimmed.endsWith(';')) {
        skipUntilSemicolon = false;
        skipBlankSection = false;
      }
      continue;
    }
    skipBlankSection = false;
  }

  if (isSysDataTuple(line)) continue;

  out.push(line);
}

// collapse excessive blank lines
const collapsed = [];
for (const line of out) {
  if (line.trim() === '' && collapsed.length > 0 && collapsed[collapsed.length - 1].trim() === '') continue;
  collapsed.push(line);
}

const header = `-- OMS init from reference (Yudao: DDL + patches + system_menu 6900+)
-- 执行顺序:
--   1. sql/mysql/oms-teardown.sql          (重建时)
--   2. sql/mysql/oms-init-from-reference.sql  (本文件，已剔除 sys_dict_*/sys_menu)
--   3. sql/mysql/oms-dict-yudao.sql        (OMS 业务字典 → system_dict_*)
--   4. sql/mysql/oms-supplement.sql        (入库计划表 + 菜单权限对齐)
SET NAMES utf8mb4;

`;

let body = collapsed.join('\n');
body = body.replace(/^-- OMS init from reference[^\n]*\n(?:(?:--[^\n]*\n)*?)SET NAMES utf8mb4;\s*\n/s, '');

fs.writeFileSync(input, header + body, 'utf8');
console.log(`Cleaned ${input}, ${lines.length} -> ${collapsed.length + 8} lines`);
