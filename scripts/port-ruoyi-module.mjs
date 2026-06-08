/**
 * 将 RuoYi-Vue-Plus 参考模块批量移植到 Yudao (ruoyi-vue-pro) 结构
 * 用法: node scripts/port-ruoyi-module.mjs wms|yms
 */
import fs from 'node:fs';
import path from 'node:path';

const moduleName = process.argv[2];
if (!moduleName || !['wms', 'yms'].includes(moduleName)) {
  console.error('Usage: node scripts/port-ruoyi-module.mjs wms|yms');
  process.exit(1);
}

const root = path.resolve(import.meta.dirname, '..');
const refRoot = path.resolve(root, '../../WMSProject/overallSystem/WMSRuoYi-Vue-Plus/ruoyi-modules');
const refModule = path.join(refRoot, `ruoyi-${moduleName}/src/main/java/org/dromara/${moduleName}`);
const targetRoot = path.join(root, `yudao-module-${moduleName}/src/main/java/cn/iocoder/yudao/module/${moduleName}`);

const pkgFrom = `org.dromara.${moduleName}`;
const pkgTo = `cn.iocoder.yudao.module.${moduleName}`;

function kebabCase(name) {
  return name.replace(/([a-z])([A-Z])/g, '$1-$2').replace(/_/g, '-').toLowerCase();
}

function toSnake(name) {
  return name.replace(/([a-z])([A-Z])/g, '$1_$2').replace(/-/g, '_').toLowerCase();
}

function transformContent(content, filePath) {
  let c = content;

  // package & imports
  c = c.replaceAll(pkgFrom, pkgTo);
  c = c.replaceAll('org.dromara.common.core.exception.ServiceException',
    'cn.iocoder.yudao.framework.common.exception.ServiceException');
  c = c.replaceAll('org.dromara.common.core.utils.StringUtils', 'cn.hutool.core.util.StrUtil');
  c = c.replaceAll('org.dromara.common.core.utils.MapstructUtils', 'cn.iocoder.yudao.framework.common.util.object.BeanUtils');
  c = c.replaceAll('org.dromara.common.mybatis.core.page.PageQuery', 'cn.iocoder.yudao.framework.common.pojo.PageParam');
  c = c.replaceAll('org.dromara.common.mybatis.core.page.TableDataInfo', 'cn.iocoder.yudao.framework.common.pojo.PageResult');
  c = c.replaceAll('org.dromara.common.tenant.core.TenantEntity', 'cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO');
  c = c.replaceAll('org.dromara.common.core.domain.R', 'cn.iocoder.yudao.framework.common.pojo.CommonResult');
  c = c.replaceAll('org.dromara.common.mybatis.core.mapper.BaseMapperPlus', 'cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX');
  c = c.replaceAll('org.dromara.common.redis.utils.SequenceUtils', 'cn.iocoder.yudao.module.system.api.no.SystemNoApi');
  c = c.replaceAll('org.dromara.common.satoken.utils.LoginHelper', 'cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils');
  c = c.replaceAll('org.dromara.common.tenant.helper.TenantHelper', 'cn.iocoder.yudao.framework.tenant.core.context.TenantContextHolder');
  c = c.replaceAll('org.dromara.oms.', 'cn.iocoder.yudao.module.oms.');
  c = c.replaceAll('org.dromara.wms.', 'cn.iocoder.yudao.module.wms.');
  c = c.replaceAll('org.dromara.yms.', 'cn.iocoder.yudao.module.yms.');
  c = c.replaceAll('org.dromara.base.', 'cn.iocoder.yudao.module.base.');

  // StringUtils -> StrUtil
  c = c.replace(/\bStringUtils\./g, 'StrUtil.');
  c = c.replace(/\bMapstructUtils\.convert\b/g, 'BeanUtils.toBean');

  // Service interface naming IWmsXxxService -> WmsXxxService
  c = c.replace(new RegExp(`I(Wms|Yms)(\\w+)Service`, 'g'), '$1$2Service');

  // Entity -> DO in domain files
  if (filePath.includes(`${path.sep}domain${path.sep}`) && !filePath.includes(`${path.sep}bo${path.sep}`) && !filePath.includes(`${path.sep}vo${path.sep}`)) {
    c = c.replace(/public class (Wms|Yms)(\w+) extends TenantBaseDO/g, 'public class $1$2DO extends TenantBaseDO');
    c = c.replace(/@AutoMapper\([^)]+\)\s*\n/g, '');
    c = c.replace(/import io\.github\.linpeilie\.annotations\.AutoMapper;\s*\n/g, '');
    c = c.replace(/@TableLogic\s*\n\s*private Integer deleted;\s*\n/g, '');
    c = c.replace(/@TableId\(value = "id", type = IdType\.ASSIGN_ID\)/g, '@TableId');
    c = c.replace(/import com\.baomidou\.mybatisplus\.annotation\.TableLogic;\s*\n/g, '');
    c = c.replace(/import com\.baomidou\.mybatisplus\.annotation\.IdType;\s*\n/g, '');
  }

  // Mapper extends BaseMapperX
  if (filePath.includes(`${path.sep}mapper${path.sep}`)) {
    c = c.replace(/extends BaseMapperPlus<(\w+), (\w+Vo)>/g, 'extends BaseMapperX<$1DO>');
    c = c.replace(/(\w+)Mapper extends BaseMapperX<(\w+)>/g, (m, name, entity) => {
      const doName = entity.endsWith('DO') ? entity : entity + 'DO';
      return `${name}Mapper extends BaseMapperX<${doName}>`;
    });
  }

  return c;
}

function mapTargetPath(relPath) {
  const parts = relPath.split(/[/\\]/);
  const fileName = parts.pop();

  if (parts.includes('controller')) {
    const ctrlName = fileName.replace('.java', '');
    const domain = ctrlName.replace(/^(Wms|Yms)/, '').replace(/Controller$/, '');
    const sub = domain.charAt(0).toLowerCase() + domain.slice(1);
    return path.join('controller', 'admin', kebabCase(sub).replace(/^wms-|^yms-/, ''), fileName);
  }
  if (parts.includes('service') && parts.includes('impl')) {
    const svcName = fileName.replace('.java', '').replace(/^I/, '');
    const domain = svcName.replace(/ServiceImpl$/, '');
    const sub = domain.charAt(0).toLowerCase() + domain.slice(1);
    return path.join('service', kebabCase(sub).replace(/^wms-|^yms-/, ''), fileName.replace(/^I/, ''));
  }
  if (parts.includes('service') && !parts.includes('impl')) {
    const svcName = fileName.replace('.java', '').replace(/^I/, '');
    const domain = svcName.replace(/Service$/, '');
    const sub = domain.charAt(0).toLowerCase() + domain.slice(1);
    return path.join('service', kebabCase(sub).replace(/^wms-|^yms-/, ''), fileName.replace(/^I/, ''));
  }
  if (parts.includes('domain') && parts.includes('bo')) {
    return path.join('controller', 'admin', '_bo', fileName);
  }
  if (parts.includes('domain') && parts.includes('vo')) {
    return path.join('controller', 'admin', '_vo', fileName);
  }
  if (parts.includes('domain')) {
    const entityName = fileName.replace('.java', '');
    const sub = entityName.replace(/^(Wms|Yms)/, '').replace(/DO$/, '');
    const sub2 = sub.charAt(0).toLowerCase() + sub.slice(1);
    return path.join('dal', 'dataobject', kebabCase(sub2).replace(/^wms-|^yms-/, ''), entityName.replace(/^(Wms|Yms)(\w+)$/, '$1$2DO') + (entityName.endsWith('DO') ? '' : '.java').replace('.java.java', '.java'));
  }
  if (parts.includes('mapper')) {
    const mapperName = fileName.replace('.java', '');
    const entity = mapperName.replace(/Mapper$/, '').replace(/^(Wms|Yms)/, '');
    const sub = entity.charAt(0).toLowerCase() + entity.slice(1);
    return path.join('dal', 'mysql', kebabCase(sub).replace(/^wms-|^yms-/, ''), fileName);
  }
  if (parts.includes('integration')) {
    return path.join('integration', fileName);
  }
  return path.join('_raw', relPath);
}

function walkDir(dir, base = dir, files = []) {
  if (!fs.existsSync(dir)) return files;
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) walkDir(full, base, files);
    else if (entry.name.endsWith('.java')) files.push(path.relative(base, full));
  }
  return files;
}

const files = walkDir(refModule);
let count = 0;
for (const rel of files) {
  const src = path.join(refModule, rel);
  const mapped = mapTargetPath(rel);
  const dest = path.join(targetRoot, mapped);
  fs.mkdirSync(path.dirname(dest), { recursive: true });
  const raw = fs.readFileSync(src, 'utf8');
  const transformed = transformContent(raw, mapped);
  fs.writeFileSync(dest, transformed, 'utf8');
  count++;
}
console.log(`Ported ${count} Java files for module ${moduleName} -> ${targetRoot}`);
