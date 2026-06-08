/**
 * 将 RuoYi-Vue-Plus ruoyi-oms 全量移植到 yudao-module-oms
 * 用法: node scripts/port-oms-module.mjs
 */
import fs from 'node:fs';
import path from 'node:path';

const root = path.resolve(import.meta.dirname, '..');
const refRoot = path.resolve(root, '../../WMSProject/overallSystem/WMSRuoYi-Vue-Plus/ruoyi-modules/ruoyi-oms');
const refJava = path.join(refRoot, 'src/main/java/org/dromara/oms');
const refMapper = path.join(refRoot, 'src/main/resources/mapper/oms');
const refSql = path.join(refRoot, 'src/main/resources/sql');
const refWmsJava = path.resolve(root, '../../WMSProject/overallSystem/WMSRuoYi-Vue-Plus/ruoyi-modules/ruoyi-wms/src/main/java/org/dromara/wms');
const refWmsInv = path.join(refWmsJava, 'service/impl/WmsInventoryServiceImpl.java');
const refWmsDev = path.join(refWmsJava, 'service/impl/WmsDevanningOrderServiceImpl.java');
const refWmsBridge = path.join(refWmsJava, 'integration/WmsDevanningOrderBridgeImpl.java');

const outJava = path.join(root, 'yudao-module-oms/src/main/java/cn/iocoder/yudao/module/oms');
const outMapper = path.join(root, 'yudao-module-oms/src/main/resources/mapper/oms');
const outWmsJava = path.join(root, 'yudao-module-wms/src/main/java/cn/iocoder/yudao/module/wms');
const PKG = 'cn.iocoder.yudao.module.oms';
const WMS_PKG = 'cn.iocoder.yudao.module.wms';

const created = [];

function wr(rel, content, base = outJava) {
  const normRel = rel.replace(/\\/g, '/');
  const p = path.join(base, ...normRel.split('/'));
  fs.mkdirSync(path.dirname(p), { recursive: true });
  fs.writeFileSync(p, content, 'utf8');
  created.push(path.relative(root, p).replace(/\\/g, '/'));
}

function kebab(name) {
  return name.replace(/([a-z])([A-Z])/g, '$1-$2').replace(/_/g, '-').toLowerCase();
}

const ENTITIES = {
  PreOutbound: 'preoutbound',
  PreOutboundItem: 'preoutbound',
  InboundPlan: 'inboundplan',
  InboundPlanItem: 'inboundplan',
  InboundPlanChangeLog: 'inboundplan',
  OutboundOrder: 'outboundorder',
  OutboundOrderItem: 'outboundorder',
  CargoOrder: 'cargoorder',
  CargoOrderShipment: 'cargoorder',
  CargoOrderSkuItem: 'cargoorder',
  CargoOrderNodeTrace: 'cargoorder',
  CargoOrderHoldRecord: 'cargoorder',
  ContainerOrder: 'containerorder',
  ContainerOrderTrace: 'containerorder',
  ContainerCargoOrderRel: 'containerorder',
  CargoGroupingRule: 'cargogroupingrule',
  CargoGroupingFieldMeta: 'cargogroupingfieldmeta',
  BizRoot: 'biz',
  BizAttachment: 'biz',
};

/** 长实体名优先，避免 OutboundOrder 误匹配 OutboundOrderItem */
const ENTITY_ENTRIES = Object.entries(ENTITIES).sort((a, b) => b[0].length - a[0].length);

const CTRL_FOLDER = {
  ContainerOrder: 'containerorder',
  CargoOrder: 'cargoorder',
  InboundPlan: 'inboundplan',
  PreOutbound: 'preoutbound',
  OutboundPool: 'outboundpool',
  OutboundOrder: 'outboundorder',
  CargoGroupingRule: 'cargogroupingrule',
  CargoGroupingFieldMeta: 'cargogroupingfieldmeta',
  BizAttachment: 'bizattachment',
  OmsBizLifecycle: 'omsbizlifecycle',
};

const BO_RENAMES = [
  ['OmsDevanningPushBo', 'OmsDevanningPushDTO'],
  ['ContainerOrderQueryBo', 'ContainerOrderPageReqVO'],
  ['ContainerOrderBo', 'ContainerOrderSaveReqVO'],
  ['ContainerOrderStatusBo', 'ContainerOrderStatusReqVO'],
  ['ContainerCargoOrderBatchBo', 'ContainerCargoOrderBatchReqVO'],
  ['CargoOrderQueryBo', 'CargoOrderPageReqVO'],
  ['CargoOrderBo', 'CargoOrderSaveReqVO'],
  ['CargoOrderStatusBo', 'CargoOrderStatusReqVO'],
  ['CargoOrderHoldBo', 'CargoOrderHoldReqVO'],
  ['CargoOrderReleaseBo', 'CargoOrderReleaseReqVO'],
  ['CargoOrderSplitBo', 'CargoOrderSplitReqVO'],
  ['CargoOrderMergeBackBo', 'CargoOrderMergeBackReqVO'],
  ['CargoOrderTransferBo', 'CargoOrderTransferReqVO'],
  ['CargoOrderShipmentBo', 'CargoOrderShipmentSaveReqVO'],
  ['CargoOrderSkuItemBo', 'CargoOrderSkuItemSaveReqVO'],
  ['InboundPlanQueryBo', 'InboundPlanPageReqVO'],
  ['InboundPlanBo', 'InboundPlanSaveReqVO'],
  ['InboundPlanItemUpdateBo', 'InboundPlanItemUpdateReqVO'],
  ['InboundPlanSaveGroupBo', 'InboundPlanSaveGroupReqVO'],
  ['InboundPlanApplyRuleBo', 'InboundPlanApplyRuleReqVO'],
  ['PreOutboundQueryBo', 'PreOutboundPageReqVO'],
  ['PreOutboundUpdateBo', 'PreOutboundUpdateReqVO'],
  ['PreOutboundItemsBo', 'PreOutboundItemsReqVO'],
  ['OutboundPoolQueryBo', 'OutboundPoolQueryReqVO'],
  ['OutboundCreateBo', 'OutboundCreateReqVO'],
  ['OutboundOrderQueryBo', 'OutboundOrderPageReqVO'],
  ['CargoGroupingRuleQueryBo', 'CargoGroupingRulePageReqVO'],
  ['CargoGroupingRuleBo', 'CargoGroupingRuleSaveReqVO'],
  ['CargoGroupingRulePriorityBo', 'CargoGroupingRulePriorityReqVO'],
  ['CargoGroupingRuleTestBo', 'CargoGroupingRuleTestReqVO'],
  ['CargoGroupingFieldMetaQueryBo', 'CargoGroupingFieldMetaPageReqVO'],
  ['CargoGroupingFieldMetaBo', 'CargoGroupingFieldMetaSaveReqVO'],
  ['BizAttachmentBo', 'BizAttachmentSaveReqVO'],
];

const VO_RENAMES = [
  ['ContainerCargoOrderImportVo', 'ContainerCargoOrderImportExcelVO'],
  ['InboundPlanItemPreviewVo', 'InboundPlanItemPreviewRespVO'],
  ['CargoGroupingRuleTestVo', 'CargoGroupingRuleTestRespVO'],
  ['OutboundPoolStatsVo', 'OutboundPoolStatsRespVO'],
  ['InboundPlanGroupVo', 'InboundPlanGroupRespVO'],
  ['PreOutboundItemVo', 'PreOutboundItemRespVO'],
  ['PreOutboundVo', 'PreOutboundRespVO'],
  ['InboundPlanItemVo', 'InboundPlanItemRespVO'],
  ['InboundPlanVo', 'InboundPlanRespVO'],
  ['OutboundOrderItemVo', 'OutboundOrderItemRespVO'],
  ['OutboundOrderVo', 'OutboundOrderRespVO'],
  ['ContainerOrderTraceVo', 'ContainerOrderTraceRespVO'],
  ['ContainerOrderVo', 'ContainerOrderRespVO'],
  ['CargoGroupingRuleVo', 'CargoGroupingRuleRespVO'],
  ['CargoOrderNodeTraceVo', 'CargoOrderNodeTraceRespVO'],
  ['CargoOrderShipmentVo', 'CargoOrderShipmentRespVO'],
  ['CargoOrderSkuItemVo', 'CargoOrderSkuItemRespVO'],
  ['CargoOrderVo', 'CargoOrderRespVO'],
  ['BizAttachmentVo', 'BizAttachmentRespVO'],
  ['CargoGroupingFieldMetaVo', 'CargoGroupingFieldMetaRespVO'],
];

function voFolder(name) {
  if (name.startsWith('Container')) return 'containerorder';
  if (name.startsWith('CargoOrder')) return 'cargoorder';
  if (name.startsWith('InboundPlan')) return 'inboundplan';
  if (name.startsWith('PreOutbound')) return 'preoutbound';
  if (name.startsWith('OutboundPool')) return 'outboundpool';
  if (name.startsWith('Outbound')) return 'outboundorder';
  if (name.startsWith('CargoGroupingRule')) return 'cargogroupingrule';
  if (name.startsWith('CargoGroupingFieldMeta')) return 'cargogroupingfieldmeta';
  if (name.startsWith('BizAttachment')) return 'bizattachment';
  return 'common';
}

function inferVoName(fileName) {
  let n = fileName.replace('.java', '');
  for (const [a, b] of VO_RENAMES) n = n.replace(a, b);
  if (n.endsWith('Vo')) n = n.replace(/Vo$/, 'RespVO');
  return n;
}

function inferBoName(fileName) {
  let n = fileName.replace('.java', '');
  for (const [a, b] of BO_RENAMES) {
    if (n === a) return b;
  }
  return n;
}

function serviceBaseName(name) {
  let n = name.replace(/ServiceImpl$/, '').replace(/Service$/, '');
  if (n.startsWith('I') && n.length > 1 && /[A-Z]/.test(n.charAt(1))) {
    n = n.slice(1);
  }
  return n;
}

function mapTargetPath(relPath) {
  const parts = relPath.split(/[/\\]/);
  const fileName = parts.pop();

  if (parts.includes('controller')) {
    const ctrl = fileName.replace('.java', '').replace(/Controller$/, '');
    const folder = CTRL_FOLDER[ctrl] || kebab(ctrl);
    return `controller/admin/${folder}/${fileName}`;
  }
  if (parts.includes('service') && parts.includes('impl')) {
    const implName = fileName.replace('.java', '');
    const svcKey = serviceBaseName(implName);
    const folder = CTRL_FOLDER[svcKey] || kebab(svcKey);
    return `service/${folder}/${implName.replace(/^I(?=[A-Z])/, '')}.java`;
  }
  if (parts.includes('service') && !parts.includes('impl')) {
    const svcName = fileName.replace('.java', '');
    const svcKey = serviceBaseName(svcName);
    const folder = CTRL_FOLDER[svcKey] || kebab(svcKey);
    return `service/${folder}/${svcName.replace(/^I(?=[A-Z])/, '')}.java`;
  }
  if (parts.includes('integration')) {
    if (fileName === 'IOmsContainerDevanningSyncService.java') {
      return 'api/devanning/OmsContainerDevanningSyncService.java';
    }
    if (fileName === 'IWmsDevanningOrderBridge.java') {
      return 'api/devanning/WmsDevanningOrderBridge.java';
    }
    return `integration/${fileName}`;
  }
  if (parts.includes('domain') && parts.includes('bo')) {
    const boName = inferBoName(fileName);
    if (boName === 'OmsDevanningPushDTO') {
      return 'api/devanning/dto/OmsDevanningPushDTO.java';
    }
    const base = fileName.replace('.java', '').replace(/Bo$/, '').replace(/QueryBo$/, '').replace(/UpdateBo$/, '').replace(/ItemsBo$/, '');
    const folder = voFolder(base + 'Vo');
    return `controller/admin/${folder}/vo/${boName}.java`;
  }
  if (parts.includes('domain') && parts.includes('vo')) {
    const voName = inferVoName(fileName);
    const base = fileName.replace('.java', '');
    const folder = voFolder(base);
    return `controller/admin/${folder}/vo/${voName}.java`;
  }
  if (parts.includes('domain')) {
    const entity = fileName.replace('.java', '');
    const sub = ENTITIES[entity] || kebab(entity);
    return `dal/dataobject/${sub}/${entity}DO.java`;
  }
  if (parts.includes('mapper')) {
    const mapper = fileName.replace('.java', '').replace(/Mapper$/, '');
    const sub = ENTITIES[mapper] || kebab(mapper);
    return `dal/mysql/${sub}/${fileName}`;
  }
  if (parts.includes('support')) {
    const sub = parts.slice(parts.indexOf('support') + 1);
    return `support/${[...sub, fileName].join('/')}`;
  }
  return ['_raw', ...parts].join('/');
}

function fixPackage(c, mappedPath) {
  const norm = mappedPath.replace(/\\/g, '/');
  const slash = norm.lastIndexOf('/');
  const dir = slash >= 0 ? norm.substring(0, slash) : '';
  const pkg = dir ? `${PKG}.${dir.replace(/\//g, '.')}` : PKG;
  return c.replace(/package [^;]+;/, `package ${pkg};`);
}

function applyRenames(c) {
  for (const [a, b] of BO_RENAMES) c = c.replaceAll(a, b);
  for (const [a, b] of VO_RENAMES) c = c.replaceAll(a, b);
  c = c.replace(/\b(\w+)Vo\b/g, (m, p1) => {
    if (p1.endsWith('Resp') || p1.endsWith('Excel') || p1.endsWith('Preview') || p1.endsWith('Stats') || p1.endsWith('Group') || p1.endsWith('Test')) return m;
    return p1 + 'RespVO';
  });
  return c;
}

function expandWildcardImports(c) {
  if (c.includes(`import ${PKG}.domain.*`)) {
    const imports = [];
    for (const [ent, sub] of ENTITY_ENTRIES) {
      if (new RegExp(`\\b${ent}DO\\b`).test(c)) {
        imports.push(`import ${PKG}.dal.dataobject.${sub}.${ent}DO;`);
      }
    }
    c = c.replace(new RegExp(`import ${PKG.replace(/\./g, '\\.')}\\.domain\\.\\*;\\s*\\r?\\n`), imports.join('\n') + (imports.length ? '\n' : ''));
  }
  if (c.includes(`import ${PKG}.mapper.*`)) {
    const imports = [];
    for (const [ent, sub] of ENTITY_ENTRIES) {
      if (new RegExp(`\\b${ent}Mapper\\b`).test(c)) {
        imports.push(`import ${PKG}.dal.mysql.${sub}.${ent}Mapper;`);
      }
    }
    c = c.replace(new RegExp(`import ${PKG.replace(/\./g, '\\.')}\\.mapper\\.\\*;\\s*\\r?\\n`), imports.join('\n') + (imports.length ? '\n' : ''));
  }
  c = c.replace(/CompanyDOMapper/g, 'CompanyMapper');
  c = c.replace(/WarehouseDOMapper/g, 'BaseWarehouseMapper');
  c = c.replace(/BusinessTypeDOMapper/g, 'BusinessTypeMapper');
  c = c.replace(/ChannelDOMapper/g, 'ChannelMapper');
  return c;
}

function ensureCrossVoImports(c) {
  const voNames = new Set();
  for (const [, b] of VO_RENAMES) voNames.add(b);
  for (const [, b] of BO_RENAMES) voNames.add(b);
  voNames.add('CargoOrderRespVO');
  voNames.add('CargoOrderSaveReqVO');
  for (const vo of voNames) {
    if (!(vo.endsWith('RespVO') || vo.endsWith('ReqVO') || vo.endsWith('ExcelVO'))) continue;
    if (!new RegExp(`\\b${vo}\\b`).test(c)) continue;
    if (new RegExp(`import ${PKG.replace(/\./g, '\\.')}\\.[\\w.]+\\.${vo};`).test(c)) continue;
    c = c.replace(/(package [^;]+;\r?\n)/, `$1\nimport ${PKG}.controller.admin.${inferFolderFromClass(vo)}.vo.${vo};\n`);
  }
  return c;
}

function transformContent(content, relPath, mappedPath) {
  let c = content;
  // 先精确替换，再 generic 前缀替换（避免 org.dromara.yms.* 被提前改写）
  c = c.replaceAll('org.dromara.base.domain.MdmCompany', 'cn.iocoder.yudao.module.base.dal.dataobject.company.CompanyDO');
  c = c.replaceAll('org.dromara.base.mapper.MdmCompanyMapper', 'cn.iocoder.yudao.module.base.dal.mysql.company.CompanyMapper');
  c = c.replaceAll('org.dromara.base.domain.MdmWarehouse', 'cn.iocoder.yudao.module.base.dal.dataobject.warehouse.WarehouseDO');
  c = c.replaceAll('org.dromara.base.mapper.MdmWarehouseMapper', 'cn.iocoder.yudao.module.base.dal.mysql.warehouse.BaseWarehouseMapper');
  c = c.replaceAll('org.dromara.base.domain.BaseBusinessType', 'cn.iocoder.yudao.module.base.dal.dataobject.businesstype.BusinessTypeDO');
  c = c.replaceAll('org.dromara.base.mapper.BaseBusinessTypeMapper', 'cn.iocoder.yudao.module.base.dal.mysql.businesstype.BusinessTypeMapper');
  c = c.replaceAll('org.dromara.base.domain.BaseChannel', 'cn.iocoder.yudao.module.base.dal.dataobject.channel.ChannelDO');
  c = c.replaceAll('org.dromara.base.mapper.BaseChannelMapper', 'cn.iocoder.yudao.module.base.dal.mysql.channel.ChannelMapper');
  c = c.replaceAll('org.dromara.yms.service.IYmsDispatchService', 'cn.iocoder.yudao.module.yms.service.YmsDispatchService');
  c = c.replaceAll('org.dromara.yms.integration.IYmsSourceOrderSyncHandler', 'cn.iocoder.yudao.module.yms.integration.YmsSourceOrderSyncHandler');
  c = c.replaceAll('org.dromara.yms.domain.bo.YmsPushTaskBo', 'cn.iocoder.yudao.module.yms.controller.admin.vo.YmsPushTaskReqVO');
  c = c.replaceAll('org.dromara.yms.domain.vo.YmsYardTaskVo', 'cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardTaskRespVO');

  c = c.replaceAll('org.dromara.oms.', `${PKG}.`);
  c = c.replaceAll('org.dromara.wms.', `${WMS_PKG}.`);
  c = c.replaceAll('org.dromara.yms.', 'cn.iocoder.yudao.module.yms.');
  c = c.replaceAll('org.dromara.base.', 'cn.iocoder.yudao.module.base.');

  // yms/base 前缀替换后的兜底
  c = c.replaceAll('cn.iocoder.yudao.module.yms.domain.bo.YmsPushTaskBo', 'cn.iocoder.yudao.module.yms.controller.admin.vo.YmsPushTaskReqVO');
  c = c.replaceAll('cn.iocoder.yudao.module.yms.domain.vo.YmsYardTaskVo', 'cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardTaskRespVO');
  c = c.replaceAll('cn.iocoder.yudao.module.yms.service.IYmsDispatchService', 'cn.iocoder.yudao.module.yms.service.YmsDispatchService');
  c = c.replace(/\bIYmsDispatchService\b/g, 'YmsDispatchService');
  c = c.replace(/\bIYmsSourceOrderSyncHandler\b/g, 'YmsSourceOrderSyncHandler');
  c = c.replace(/\bYmsPushTaskBo\b/g, 'YmsPushTaskReqVO');
  c = c.replace(/\bYmsYardTaskVo\b/g, 'YmsYardTaskRespVO');

  c = c.replaceAll('org.dromara.common.mybatis.annotation.OrgDataScope', 'cn.iocoder.yudao.module.org.framework.datapermission.annotation.OrgDataScope');
  c = c.replace(/@OrgDataScope\(companyAlias = "([^"]+)", warehouseAlias = "([^"]+)"\)/g,
    '@OrgDataScope(tableClass = ContainerOrderDO.class, tableAlias = "$2", warehouseColumn = "warehouse_id")');

  c = c.replaceAll('org.dromara.common.core.exception.ServiceException', 'REMOVED_ServiceException');
  c = c.replace(/import REMOVED_ServiceException;\s*\r?\n/g, '');
  c = c.replaceAll('org.dromara.common.core.utils.StringUtils', 'cn.hutool.core.util.StrUtil');
  c = c.replaceAll('org.dromara.common.core.utils.MapstructUtils', 'cn.iocoder.yudao.framework.common.util.object.BeanUtils');
  c = c.replaceAll('org.dromara.common.mybatis.core.page.PageQuery', 'cn.iocoder.yudao.framework.common.pojo.PageParam');
  c = c.replaceAll('org.dromara.common.mybatis.core.page.TableDataInfo', 'cn.iocoder.yudao.framework.common.pojo.PageResult');
  c = c.replaceAll('org.dromara.common.tenant.core.TenantEntity', 'cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO');
  c = c.replaceAll('org.dromara.common.mybatis.core.domain.BaseEntity', 'cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO');
  c = c.replace(/\bTenantEntity\b/g, 'TenantBaseDO');
  c = c.replace(/\bBaseEntity\b/g, 'TenantBaseDO');
  c = c.replaceAll('org.dromara.common.core.domain.R', 'cn.iocoder.yudao.framework.common.pojo.CommonResult');
  c = c.replaceAll('org.dromara.common.mybatis.core.mapper.BaseMapperPlus', 'cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX');
  c = c.replace(/\bBaseMapperPlus\b/g, 'BaseMapperX');
  c = c.replaceAll('com.baomidou.mybatisplus.core.mapper.BaseMapper<', 'cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX<');
  c = c.replaceAll('org.dromara.common.satoken.utils.LoginHelper', 'cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils');
  c = c.replaceAll('org.dromara.common.tenant.helper.TenantHelper', 'cn.iocoder.yudao.framework.tenant.core.context.TenantContextHolder');
  c = c.replaceAll('org.dromara.common.web.core.BaseController', 'REMOVED_BaseController');
  c = c.replaceAll('org.dromara.common.idempotent.annotation.RepeatSubmit', 'REMOVED_RepeatSubmit');
  c = c.replaceAll('org.dromara.common.log.annotation.Log', 'cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog');
  c = c.replaceAll('org.dromara.common.log.enums.BusinessType', 'cn.iocoder.yudao.framework.apilog.core.enums.OperateTypeEnum');
  c = c.replaceAll('cn.dev33.satoken.annotation.SaCheckPermission', 'org.springframework.security.access.prepost.PreAuthorize');
  c = c.replace(/businessType = BusinessType\./g, 'businessType = OperateTypeEnum.');
  c = c.replaceAll('org.dromara.common.excel.utils.ExcelUtil', 'cn.iocoder.yudao.framework.excel.core.util.ExcelUtils');
  c = c.replaceAll('org.dromara.common.excel.core.ExcelResult', 'REMOVED_ExcelResult');
  c = c.replaceAll('org.dromara.common.json.utils.JsonUtils', 'cn.iocoder.yudao.framework.common.util.json.JsonUtils');
  c = c.replaceAll(/\bStringUtils\./g, 'StrUtil.');
  c = c.replaceAll(/\bMapstructUtils\.convertList\b/g, 'BeanUtils.toBean');
  c = c.replaceAll(/\bMapstructUtils\.convert\b/g, 'BeanUtils.toBean');
  c = c.replace(/\bStringUtils::isNotBlank\b/g, 'StrUtil::isNotBlank');

  c = c.replaceAll(/\bI(ContainerOrder|CargoOrder|CargoGroupingRule|CargoGroupingFieldMeta|InboundPlan|OutboundOrder|OutboundPool|PreOutbound|OmsBizLifecycle)Service\b/g, '$1Service');
  c = c.replaceAll(/IOmsContainerDevanningSyncService/g, 'OmsContainerDevanningSyncService');
  c = c.replaceAll(/IWmsDevanningOrderBridge/g, 'WmsDevanningOrderBridge');

  c = applyRenames(c);

  for (const [ent, sub] of ENTITY_ENTRIES) {
    c = c.replaceAll(`${PKG}.domain.${ent}`, `${PKG}.dal.dataobject.${sub}.${ent}DO`);
    c = c.replaceAll(`${PKG}.mapper.${ent}Mapper`, `${PKG}.dal.mysql.${sub}.${ent}Mapper`);
    const re = new RegExp(`(?<![A-Za-z.])${ent}(?!DO|Mapper|Service|Controller|[A-Za-z])`, 'g');
    c = c.replace(re, `${ent}DO`);
  }
  c = c.replace(/(\w+)DO(Item|Shipment|SkuItem|ChangeLog|NodeTrace|HoldRecord|Trace)/g, '$1$2DO');
  c = c.replace(/DODO/g, 'DO');
  c = c.replace(/DO DO/g, 'DO');

  const normMapped = mappedPath.replace(/\\/g, '/');
  const isEntity = /(?:^|\/)dal\/dataobject\//.test(normMapped);
  const isMapper = /(?:^|\/)dal\/mysql\//.test(normMapped);
  const isImpl = /(?:^|\/)service\//.test(normMapped) && normMapped.endsWith('ServiceImpl.java');
  const isCtrl = /(?:^|\/)controller\//.test(normMapped);
  const isBoVo = /(?:^|\/)vo\//.test(normMapped) || /(?:^|\/)dto\//.test(normMapped);

  if (isEntity) {
    c = c.replace(/@AutoMapper\([^)]*\)\s*\r?\n/g, '');
    c = c.replace(/import io\.github\.linpeilie\.annotations\.AutoMapper;\s*\r?\n/g, '');
    c = c.replace(/@TableLogic\s*\r?\n/g, '');
    c = c.replace(/import com\.baomidou\.mybatisplus\.annotation\.TableLogic;\s*\r?\n/g, '');
    c = c.replace(/^\s+private Integer deleted;\s*\r?\n/gm, '');
    c = c.replace(/^\s+\/\*\* 租户ID \*\/\s*\r?\n\s+private String tenantId;\s*\r?\n/gm, '');
    c = c.replace(/^\s+private String tenantId;\s*\r?\n/gm, '');
    c = c.replace(/^\s+\/\*\* 租户ID \*\/\s*\r?\n\s+private String tenantId;\s*\r?\n/gm, '');
    c = c.replace(/^\s+private String tenantId;\s*\r?\n/gm, '');
    c = c.replace(/@TableId\(value = "id", type = IdType\.ASSIGN_ID\)/g, '@TableId');
    c = c.replace(/import com\.baomidou\.mybatisplus\.annotation\.IdType;\s*\r?\n/g, '');
    c = c.replace(/import org\.dromara\.common\.mybatis\.core\.domain\.TenantBaseDO;\s*\r?\n/g,
      'import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;\r\n');
    c = c.replace(/public class (\w+) extends TenantBaseDO/g, (m, n) => `public class ${n.endsWith('DO') ? n : n + 'DO'} extends TenantBaseDO`);
    c = c.replace(/public class (\w+) \{/g, (m, n) => n.endsWith('DO') ? m : `public class ${n}DO {`);
  }

  if (isMapper) {
    c = c.replace(/@DataPermission\(\{[\s\S]*?\}\)\s*\r?\n/g, '');
    c = c.replace(/import org\.dromara\.common\.mybatis\.annotation\.Data(Column|Permission);\s*\r?\n/g, '');
    c = c.replace(/extends BaseMapperX<(\w+), (\w+)>/g, 'extends BaseMapperX<$1>');
    c = c.replace(/extends BaseMapperX<(\w+)DO, (\w+)>/g, 'extends BaseMapperX<$1DO>');
    c = c.replace(/extends BaseMapperX<(\w+)DO>/g, 'extends BaseMapperX<$1DO>');
  }

  if (isImpl) {
    c = c.replace(/import REMOVED_ServiceException;\s*\r?\n/g, '');
    c = c.replace(/throw new REMOVED_ServiceException\("([^"]*)"\)/g, 'throw exception(OMS_BIZ_ERROR, "$1")');
    c = c.replace(/throw new REMOVED_ServiceException\(([^)]+)\)/g, 'throw exception(OMS_BIZ_ERROR, String.valueOf($1))');
    c = c.replace(/throw new ServiceException\("([^"]*)"\)/g, 'throw exception(OMS_BIZ_ERROR, "$1")');
    if (!c.includes('ServiceExceptionUtil')) {
      c = c.replace(/(package [^;]+;\r?\n)/, `$1\nimport static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;\nimport static ${PKG}.enums.ErrorCodeConstants.*;\n`);
    }
    c = c.replace(/@RequiredArgsConstructor\n/g, '');
    c = c.replace(/private final /g, '@Resource\n    private ');
    c = c.replace(/import lombok.RequiredArgsConstructor;\n/g, 'import jakarta.annotation.Resource;\n');
    c = c.replace(/PageResult<(\w+)> (\w+) = (\w+)Mapper\.selectVoPage\(pageReqVO\.build\(\),/g, 'PageResult<$1RespVO> $2 = queryPageViaMapper($3Mapper, pageReqVO,');
    c = c.replace(/return TableDataInfo\.build\(([^)]+)\);/g, 'return new PageResult<>($1.getRecords(), $1.getTotal());');
    c = c.replace(/return TableDataInfo\.build\(baseMapper\.selectPageList\(([^)]+)\)\);/g,
      'Page<CargoOrderRespVO> pg = baseMapper.selectPageList($1);\n        return new PageResult<>(pg.getRecords(), pg.getTotal());');
    c = c.replace(/\.selectVoById\(/g, '.selectById(');
    c = c.replace(/\.selectVoList\(/g, '.selectList(');
    c = c.replace(/\.deleteBatchIds\(/g, '.deleteByIds(');
    c = c.replace(/^\s+entity\.setDeleted\(0\);\s*\r?\n/gm, '');
    c = c.replace(/^\s+trace\.setDeleted\(0\);\s*\r?\n/gm, '');
    c = c.replace(/LoginHelper\.getUserId\(\)/g, 'SecurityFrameworkUtils.getLoginUserId()');
    c = c.replace(/LoginHelper\.getUsername\(\)/g, 'SecurityFrameworkUtils.getLoginUserNickname()');
    c = c.replace(/TenantHelper\.getTenantId\(\)/g, 'TenantContextHolder.getTenantId()');
    c = c.replace(/MdmCompanyMapper/g, 'CompanyMapper');
    c = c.replace(/MdmWarehouseMapper/g, 'BaseWarehouseMapper');
    c = c.replace(/BaseBusinessTypeMapper/g, 'BusinessTypeMapper');
    c = c.replace(/BaseChannelMapper/g, 'ChannelMapper');
    c = c.replace(/MdmCompany/g, 'CompanyDO');
    c = c.replace(/MdmWarehouse/g, 'WarehouseDO');
    c = c.replace(/BaseBusinessType/g, 'BusinessTypeDO');
    c = c.replace(/BaseChannel/g, 'ChannelDO');
    const implMatch = normMapped.match(/\/(\w+)ServiceImpl\.java$/);
    if (implMatch) {
      const respVo = implMatch[1].replace(/ServiceImpl$/, '') + 'RespVO';
      c = c.replace(new RegExp(`public ${respVo} queryById\\(Long id\\) \\{\\s*\\r?\\n\\s*return baseMapper\\.selectById\\(id\\);`),
        `public ${respVo} queryById(Long id) {\n        return BeanUtils.toBean(baseMapper.selectById(id), ${respVo}.class);`);
    }
    c = c.replace(/Page<(\w+RespVO)> result = (\w+)\.selectVoPage\(new Page<>(pageQuery\.getPageNo\(\), pageQuery\.getPageSize\(\)),([^;]+)\);\s*\r?\n\s*return TableDataInfo\.build\(result\);/g,
      'PageResult<$1DO> page = $2.selectPage(pageQuery,$3);\n        return new PageResult<>(BeanUtils.toBean(page.getList(), $1.class), page.getTotal());');
    c = c.replace(/Page<(\w+RespVO)> result = (\w+)\.selectVoPage\(pageQuery\.build\(\),([^;]+)\);\s*\r?\n\s*return TableDataInfo\.build\(result\);/g,
      'PageResult<$1DO> page = $2.selectPage(pageQuery,$3);\n        return new PageResult<>(BeanUtils.toBean(page.getList(), $1.class), page.getTotal());');
  }

  if (isCtrl) {
    c = c.replace(/extends REMOVED_BaseController/g, '');
    c = c.replace(/extends BaseController/g, '');
    c = c.replace(/import REMOVED_BaseController;\s*\r?\n/g, '');
    c = c.replace(/@SaCheckPermission\(value = \{([^}]+)\}, mode = SaMode\.OR\)/g, (m, perms) => {
      const list = perms.split(',').map(p => p.trim().replace(/"/g, '')).join("','");
      return `@PreAuthorize("@ss.hasAnyPermissions('${list}')")`;
    });
    c = c.replace(/@SaCheckPermission/g, '@PreAuthorize');
    c = c.replace(/@PreAuthorize\("(?!@ss\.)([^"]+)"\)/g, '@PreAuthorize("@ss.hasPermission(\'$1\')")');
    c = c.replace(/\bR</g, 'CommonResult<');
    c = c.replace(/\bR\.ok\(/g, 'success(');
    c = c.replace(/@Log\(title = "([^"]+)", businessType = OperateTypeEnum\.(\w+)\)/g, (m, title, op) => {
      const mapped = op === 'INSERT' ? 'CREATE' : op;
      return `@ApiAccessLog(operateType = ${mapped})`;
    });
    c = c.replace(/@RepeatSubmit(\(\))?\s*\r?\n/g, '');
    c = c.replace(/return R\.ok\(([^)]+)\);/g, 'return success($1);');
    c = c.replace(/public TableDataInfo<([^>]+)>/g, 'public CommonResult<PageResult<$1>>');
    c = c.replace(/public CommonResult<PageResult<([^>]+)>\s+(\w+)\(/g, 'public CommonResult<PageResult<$1>> $2(');
    c = c.replace(/return (\w+)\.queryPageList\(([^,]+),\s*pageQuery\);/g, 'return success($1.queryPageList($2, pageReqVO));');
    c = c.replace(/return (\w+)\.queryPageList\(([^,]+),\s*pageReqVO\);/g, 'return success($1.queryPageList($2, pageReqVO));');
    c = c.replace(/PageQuery pageQuery/g, '@Valid PageParam pageReqVO');
    c = c.replace(/, PageParam pageReqVO\)/g, ')');
    c = c.replace(/pageReqVO\.build\(\)/g, 'pageReqVO');
    c = c.replace(/@GetMapping\("\/list"\)/g, '@GetMapping("/page")');
    c = c.replace(/@RequiredArgsConstructor\n/g, '');
    c = c.replace(/private final /g, '@Resource\n    private ');
    c = c.replace(/import lombok.RequiredArgsConstructor;\n/g, 'import jakarta.annotation.Resource;\n');
    c = c.replace(/ExcelUtil\.exportExcel/g, 'ExcelUtils.write');
    if (!c.includes('import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success')) {
      c = c.replace(/(package [^;]+;\r?\n)/, `$1\nimport static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;\n`);
    }
    if (c.includes('@ApiAccessLog') && !c.includes('import static cn.iocoder.yudao.framework.apilog.core.enums.OperateTypeEnum')) {
      c = c.replace(/(package [^;]+;\r?\n)/, `$1\nimport static cn.iocoder.yudao.framework.apilog.core.enums.OperateTypeEnum.*;\n`);
    }
    if (c.includes('@Valid') && !c.includes('import jakarta.validation.Valid')) {
      c = c.replace(/(package [^;]+;\r?\n)/, `$1\nimport jakarta.validation.Valid;\n`);
    }
    c = c.replace(/@Validated\(AddGroup\.class\)/g, '@Valid');
    c = c.replace(/@Validated\(EditGroup\.class\)/g, '@Valid');
    c = c.replace(/import org\.dromara\.common\.core\.validate\.[^;]+;\n/g, '');
  }

  if (isBoVo) {
    c = c.replace(/@AutoMapper[\s\S]*?\)\s*\r?\n/g, '');
    c = c.replace(/import io\.github\.linpeilie\.annotations\.AutoMapper;\s*\r?\n/g, '');
    c = c.replace(/extends TenantBaseDO/g, '');
    c = c.replace(/import cn\.iocoder\.yudao\.framework\.tenant\.core\.db\.TenantBaseDO;\s*\r?\n/g, '');
    c = c.replace(/import org\.dromara\.common\.mybatis\.core\.domain\.BaseEntity;\s*\r?\n/g, '');
    c = c.replace(/@EqualsAndHashCode\(callSuper = true\)\s*\r?\n/g, '');
    c = c.replace(/, groups = \{[^}]+\}/g, '');
    c = c.replace(/groups = \{[^}]+\}, ?/g, '');
    c = c.replace(/,\s*\)/g, ')');
    c = c.replace(/import org\.dromara\.common\.core\.validate\.[^;]+;\s*\r?\n/g, '');
    c = c.replace(/import static cn\.iocoder\.yudao\.framework\.common\.pojo\.CommonResult\.success;\s*\r?\n/g, '');
    if (!c.includes('import lombok.Data;')) {
      c = c.replace(/(package [^;]+;\r?\n)/, '$1\nimport lombok.Data;\n');
    }
    if (normMapped.endsWith('PageReqVO.java')) {
      if (!c.includes('import cn.iocoder.yudao.framework.common.pojo.PageParam;')) {
        c = c.replace(/(import lombok\.Data;\r?\n)/,
          '$1import cn.iocoder.yudao.framework.common.pojo.PageParam;\nimport lombok.EqualsAndHashCode;\nimport lombok.ToString;\n');
      }
      c = c.replace(/public class (\w+)( extends \w+)? \{/,
        '@EqualsAndHashCode(callSuper = true)\n@ToString(callSuper = true)\npublic class $1 extends PageParam {');
    }
    if (c.includes('@Valid') && !c.includes('import jakarta.validation.Valid')) {
      c = c.replace(/(package [^;]+;\r?\n)/, `$1\nimport jakarta.validation.Valid;\n`);
    }
    if (normMapped.endsWith('RespVO.java')) {
      if (!c.includes('import java.io.Serializable;')) {
        c = c.replace(/(import lombok\.Data;\r?\n)/, '$1import java.io.Serializable;\n');
      }
      if (!c.includes('implements Serializable')) {
        c = c.replace(/public class (\w+) \{/, 'public class $1 implements Serializable {');
      }
    }
  }

  // fix integration imports
  c = c.replaceAll(`${PKG}.domain.bo.OmsDevanningPushDTO`, `${PKG}.api.devanning.dto.OmsDevanningPushDTO`);
  c = c.replaceAll(`${PKG}.integration.OmsContainerDevanningSyncService`, `${PKG}.api.devanning.OmsContainerDevanningSyncService`);
  c = c.replaceAll(`${PKG}.integration.WmsDevanningOrderBridge`, `${PKG}.api.devanning.WmsDevanningOrderBridge`);

  c = c.replace(/import REMOVED_BaseEntity;\s*\r?\n/g, '');
  c = c.replace(/import REMOVED_BaseController;\s*\r?\n/g, '');
  c = c.replace(/import REMOVED_ServiceException;\s*\r?\n/g, '');
  c = c.replace(/extends REMOVED_BaseEntity/g, '');
  c = c.replace(/@AutoMapper\([^)]*\)\s*\r?\n/g, '');
  c = c.replace(/import io\.github\.linpeilie\.annotations\.AutoMapper;\s*\r?\n/g, '');
  c = c.replace(/import org\.dromara\.common\.mybatis\.core\.domain\.TenantBaseDO;\s*\r?\n/g,
    'import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;\r\n');
  c = c.replace(/@DataPermission\(\{[\s\S]*?\}\)\s*\r?\n/g, '');
  c = c.replace(/import org\.dromara\.common\.mybatis\.annotation\.Data(Column|Permission);\s*\r?\n/g, '');
  c = c.replace(/\bBaseMapperPlus\b/g, 'BaseMapperX');
  c = c.replace(/extends BaseMapperX<(\w+DO), (\w+)>/g, 'extends BaseMapperX<$1>');
  if (c.includes('implements OmsContainerDevanningSyncService') && !c.includes(`${PKG}.api.devanning.OmsContainerDevanningSyncService`)) {
    c = c.replace(/(package [^;]+;\r?\n)/, `$1\nimport ${PKG}.api.devanning.OmsContainerDevanningSyncService;\n`);
  }
  c = c.replace(/@Log\(title = "([^"]+)", businessType = OperateTypeEnum\.(\w+)\)/g, (m, title, op) => {
    const mapped = op === 'INSERT' ? 'CREATE' : op;
    return `@ApiAccessLog(operateType = ${mapped})`;
  });
  c = c.replace(/@RepeatSubmit(\(\))?\s*\r?\n/g, '');
  c = c.replace(/@Idempotent\s*\r?\n/g, '');
  c = c.replace(/import cn\.iocoder\.yudao\.framework\.idempotent\.core\.annotation\.Idempotent;\s*\r?\n/g, '');
  c = c.replace(/@SaCheckPermission\(value = \{([^}]+)\}, mode = SaMode\.OR\)/g, (m, perms) => {
    const list = perms.split(',').map(p => p.trim().replace(/"/g, '')).join("','");
    return `@PreAuthorize("@ss.hasAnyPermissions('${list}')")`;
  });
  c = c.replace(/import cn\.dev33\.satoken\.annotation\.SaMode;\s*\r?\n/g, '');
  c = c.replace(/cn\.iocoder\.yudao\.module\.oms\.domain\.vo\.(\w+)/g,
    (m, cls) => `${PKG}.controller.admin.${inferFolderFromClass(cls)}.vo.${cls}`);
  c = c.replace(/import cn\.iocoder\.yudao\.module\.oms\.controller\.admin\.[\w]+\.vo\.(\w+);/g,
    (m, cls) => `import ${PKG}.controller.admin.${inferFolderFromClass(cls)}.vo.${cls};`);
  c = c.replace(/import REMOVED_RepeatSubmit;\s*\r?\n/g, '');
  c = c.replace(/^\s+private Integer deleted;\s*\r?\n/gm, '');
  c = c.replace(/^\s+\w+\.setDeleted\(0\);\s*\r?\n/gm, '');
  c = c.replace(/return success\(\);/g, 'return success(null);');
  c = c.replace(/ExcelUtils\.write\((\w+),\s*"([^"]+)",\s*(\w+\.class),\s*(\w+)\);/g,
    'ExcelUtils.write($4, "$2.xls", "数据", $3, $1);');
  c = c.replace(/return toAjax\((.+)\);/g, '$1;\n        return success(null);');
  c = c.replace(/return success\((\w+Service\.\w+\(.+\))\);/g, (match, call) => {
    if (/query|get|list|test|parse|Stats|Count|export|import|uploadAttachment|attachments/i.test(call)) return match;
    return `${call};\n        return success(null);`;
  });
  c = c.replace(/ExcelUtil\.exportExcel\((.+),\s*"([^"]+)",\s*(\w+\.class),\s*(\w+)\);/g,
    'ExcelUtils.write($4, "$2.xls", "数据", $3, $1);');
  c = c.replace(/ExcelUtils\.write\((new ArrayList<[^>]+>\(\)),\s*"([^"]+)",\s*(\w+\.class),\s*(\w+)\);/g,
    'ExcelUtils.write($4, "$2.xls", "数据", $3, $1);');
  c = c.replace(/ExcelResult<(\w+)>\s+(\w+)\s*=\s*\r?\n\s*ExcelUtil\.importExcel\([^,]+,\s*(\w+)\.class,\s*true\);/g,
    'List<$1> $2 = ExcelUtils.read(file, $3.class);');
  c = c.replace(/import REMOVED_ExcelResult;\s*\r?\n/g, '');
  c = c.replace(/import cn\.iocoder\.yudao\.framework\.excel\.core\.util\.ExcelResult;\s*\r?\n/g, '');
  c = c.replace(/@PreAuthorize\("@ss\.hasPermission\('@ss\.hasAnyPermissions\(([^)]+)\)'\)"\)/g,
    '@PreAuthorize("@ss.hasAnyPermissions($1)")');
  c = c.replace(/import org\.dromara\.common\.core\.validate\.[^;]+;\s*\r?\n/g, '');
  c = c.replace(/@Validated\(AddGroup\.class\)/g, '@Valid');
  c = c.replace(/@Validated\(EditGroup\.class\)/g, '@Valid');
  c = c.replace(/public CommonResult<PageResult<([^>]+)>\s+(\w+)\(/g, 'public CommonResult<PageResult<$1>> $2(');
  c = c.replace(/return (\w+)\.queryPageList\(([^,]+),\s*pageQuery\);/g, 'return success($1.queryPageList($2, pageReqVO));');
  c = c.replace(/public void export\(([^)]+)\) \{/g, 'public void export($1) throws java.io.IOException {');
  c = c.replace(/public void importTemplate\(([^)]+)\) \{/g, 'public void importTemplate($1) throws java.io.IOException {');
  c = c.replace(/excelResult\.getList\(\)/g, 'excelResult');
  c = c.replace(/\bStringUtils::isNotBlank\b/g, 'StrUtil::isNotBlank');
  c = c.replace(/pageQuery\.build\(\)/g, 'new Page<>(pageQuery.getPageNo(), pageQuery.getPageSize())');
  c = c.replace(/pageReqVO\.build\(\)/g, 'new Page<>(pageReqVO.getPageNo(), pageReqVO.getPageSize())');
  c = c.replace(/new PageParam\(Integer\.MAX_VALUE, 1\)\.build\(\)/g, 'new Page<>(1, Integer.MAX_VALUE)');
  c = c.replace(/return PageResult\.build\(baseMapper\.selectPageList\(new Page<>(pageQuery\.getPageNo\(\), pageQuery\.getPageSize\(\)), bo\)\);/g,
    'Page<CargoOrderRespVO> pg = baseMapper.selectPageList(new Page<>(pageQuery.getPageNo(), pageQuery.getPageSize()), bo);\n        return new PageResult<>(pg.getRecords(), pg.getTotal());');
  c = c.replace(/Page<CargoGroupingRuleRespVO> result = baseMapper\.selectPageList\([^;]+;\s*\r?\n\s*return new PageResult<>\(result\.getRecords\(\), result\.getTotal\(\)\);/g,
    'PageResult<CargoGroupingRuleDO> page = baseMapper.selectPage(pageQuery, buildQueryWrapper(bo));\n        return new PageResult<>(BeanUtils.toBean(page.getList(), CargoGroupingRuleRespVO.class), page.getTotal());');
  c = c.replace(/Page<(\w+RespVO)> result = baseMapper\.selectPageList\(new Page<>(pageQuery\.getPageNo\(\), pageQuery\.getPageSize\(\)), ([^)]+)\);\s*\r?\n\s*return result;/g,
    'Page<$1> result = baseMapper.selectPageList(new Page<>(pageQuery.getPageNo(), pageQuery.getPageSize()), $2);\n        return new PageResult<>(result.getRecords(), result.getTotal());');
  c = c.replace(/Page<ContainerOrderRespVO> result = baseMapper\.selectVoPage\(new Page<>(pageQuery\.getPageNo\(\), pageQuery\.getPageSize\(\)), buildQueryWrapper\(bo\)\);\s*\r?\n\s*fillNames\(result\.getRecords\(\)\);\s*\r?\n\s*return result;/g,
    'PageResult<ContainerOrderDO> page = baseMapper.selectPage(pageQuery, buildQueryWrapper(bo));\n        List<ContainerOrderRespVO> records = BeanUtils.toBean(page.getList(), ContainerOrderRespVO.class);\n        fillNames(records);\n        return new PageResult<>(records, page.getTotal());');
  c = expandWildcardImports(c);
  c = ensureCrossVoImports(c);

  c = fixImports(c, mappedPath);

  return fixPackage(c, mappedPath);
}

function inferFolderFromClass(cls) {
  if (cls.startsWith('Container')) return 'containerorder';
  if (cls.startsWith('CargoOrder')) return 'cargoorder';
  if (cls.startsWith('InboundPlan')) return 'inboundplan';
  if (cls.startsWith('PreOutbound')) return 'preoutbound';
  if (cls.startsWith('OutboundPool')) return 'outboundpool';
  if (cls.startsWith('Outbound')) return 'outboundorder';
  if (cls.startsWith('CargoGroupingRule')) return 'cargogroupingrule';
  if (cls.startsWith('CargoGroupingFieldMeta')) return 'cargogroupingfieldmeta';
  if (cls.startsWith('BizAttachment')) return 'bizattachment';
  if (cls.startsWith('OmsDevanning')) return 'api/devanning/dto';
  return 'common';
}

function fixImports(c, mappedPath = '') {
  const norm = mappedPath.replace(/\\/g, '/');
  const isCtrlFile = /(?:^|\/)controller\//.test(norm) && !/(?:^|\/)vo\//.test(norm);
  c = c.replace(/import cn\.iocoder\.yudao\.module\.oms\.domain\.bo\.([\w]+);/g,
    (m, cls) => `import ${PKG}.controller.admin.${inferFolderFromClass(cls)}.vo.${cls};`);
  c = c.replace(/import cn\.iocoder\.yudao\.module\.oms\.domain\.vo\.([\w]+);/g,
    (m, cls) => `import ${PKG}.controller.admin.${inferFolderFromClass(cls)}.vo.${cls};`);
  for (const [svc, folder] of Object.entries(CTRL_FOLDER)) {
    c = c.replaceAll(`import ${PKG}.service.${svc}Service;`, `import ${PKG}.service.${folder}.${svc}Service;`);
    c = c.replaceAll(`import ${PKG}.service.I${svc}Service;`, `import ${PKG}.service.${folder}.${svc}Service;`);
  }
  c = c.replaceAll(`import ${PKG}.service.impl.`, `import ${PKG}.service.`);
  c = c.replace(/import org\.dromara\.common\.core\.validate\.[^;]+;\n/g, '');
  c = c.replace(/@RequiredArgsConstructor\r?\n/g, '');
  c = c.replace(/import lombok\.RequiredArgsConstructor;\r?\n/g, 'import jakarta.annotation.Resource;\r\n');
  c = c.replace(/private final /g, '@Resource\n    private ');
  c = c.replace(/extends BaseController/g, '');
  c = c.replace(/\bPageQuery\b/g, 'PageParam');
  c = c.replace(/\bTableDataInfo/g, 'PageResult');
  c = c.replace(/\bR</g, 'CommonResult<');
  c = c.replace(/\bR\.ok\(/g, 'success(');
  c = c.replace(/@SaCheckPermission/g, '@PreAuthorize');
  c = c.replace(/ExcelResult<(\w+)>\s+(\w+)\s*=\s*\r?\n\s*ExcelUtil\.importExcel\([^,]+,\s*(\w+)\.class,\s*true\);/g,
    'List<$1> $2 = ExcelUtils.read(file, $3.class);');
  c = c.replace(/import REMOVED_ExcelResult;\s*\r?\n/g, '');
  c = c.replace(/import cn\.iocoder\.yudao\.framework\.excel\.core\.util\.ExcelResult;\s*\r?\n/g, '');
  c = c.replace(/@PreAuthorize\("@ss\.hasPermission\('@ss\.hasAnyPermissions\(([^)]+)\)'\)"\)/g,
    '@PreAuthorize("@ss.hasAnyPermissions($1)")');
  c = c.replace(/@PreAuthorize\("(?!@ss\.)([^"]+)"\)/g, '@PreAuthorize("@ss.hasPermission(\'$1\')")');
  if (isCtrlFile && c.includes('success(') && !c.includes('import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success')) {
    c = c.replace(/(package [^;]+;\r?\n)/, `$1\nimport static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;\n`);
  }
  if (!isCtrlFile) {
    c = c.replace(/import static cn\.iocoder\.yudao\.framework\.common\.pojo\.CommonResult\.success;\s*\r?\n/g, '');
  }
  if (c.includes('@Resource') && !c.includes('import jakarta.annotation.Resource')) {
    c = c.replace(/(package [^;]+;\r?\n)/, `$1\nimport jakarta.annotation.Resource;\n`);
  }
  c = c.replace(/import REMOVED_ServiceException;\s*\r?\n/g, '');
  return c;
}

function fileNameEnds(p, suffix) {
  return p.replace(/\\/g, '/').endsWith(suffix);
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

// ─── Port OMS Java ───
let javaCount = 0;
for (const rel of walkDir(refJava)) {
  const src = path.join(refJava, rel);
  const mapped = mapTargetPath(rel);
  const raw = fs.readFileSync(src, 'utf8');
  const transformed = transformContent(raw, rel, mapped);
  wr(mapped, transformed);
  javaCount++;
}

// ─── ErrorCodeConstants ───
wr('enums/ErrorCodeConstants.java', `package ${PKG}.enums;

import cn.iocoder.yudao.framework.common.exception.ErrorCode;

public interface ErrorCodeConstants {

    ErrorCode OMS_BIZ_ERROR = new ErrorCode(1_020_001_400, "OMS 业务校验失败");
    ErrorCode OMS_NOT_EXISTS = new ErrorCode(1_020_002_404, "OMS 数据不存在");
    ErrorCode OMS_PARAM_INVALID = new ErrorCode(1_020_003_400, "OMS 参数不完整或无效");

}
`, outJava);

// ─── MyBatis XML ───
const XML_ENTITY_MAP = {
  CargoOrder: 'cargoorder',
  CargoOrderShipment: 'cargoorder',
  CargoOrderSkuItem: 'cargoorder',
  CargoOrderNodeTrace: 'cargoorder',
  InboundPlan: 'inboundplan',
  InboundPlanItem: 'inboundplan',
  OutboundOrder: 'outboundorder',
  PreOutbound: 'preoutbound',
};

if (fs.existsSync(refMapper)) {
  for (const xml of fs.readdirSync(refMapper).filter(f => f.endsWith('.xml'))) {
    let content = fs.readFileSync(path.join(refMapper, xml), 'utf8');
    for (const [ent, sub] of Object.entries(XML_ENTITY_MAP)) {
      content = content.replaceAll(`org.dromara.oms.mapper.${ent}Mapper`, `${PKG}.dal.mysql.${sub}.${ent}Mapper`);
      content = content.replaceAll(`org.dromara.oms.domain.vo.${ent}Vo`, `${PKG}.controller.admin.${voFolder(ent + 'Vo')}.vo.${ent}RespVO`);
    }
    content = applyRenames(content);
    content = content.replaceAll('org.dromara.oms.domain.vo.', `${PKG}.controller.admin.cargoorder.vo.`);
    const dest = path.join(outMapper, xml);
    fs.mkdirSync(outMapper, { recursive: true });
    fs.writeFileSync(dest, content, 'utf8');
    created.push(path.relative(root, dest).replace(/\\/g, '/'));
  }
}

// ─── WMS integration restore ───
function transformWms(content, opts = {}) {
  let c = content;
  c = c.replaceAll('org.dromara.wms.', `${WMS_PKG}.`);
  c = c.replaceAll('org.dromara.oms.', `${PKG}.`);
  c = c.replaceAll('org.dromara.common.core.exception.ServiceException', 'REMOVED_ServiceException');
  c = c.replace(/import REMOVED_ServiceException;\s*\r?\n/g, '');
  c = c.replaceAll('org.dromara.common.core.utils.StringUtils', 'cn.hutool.core.util.StrUtil');
  c = c.replaceAll(/\bStringUtils\./g, 'StrUtil.');
  c = c.replaceAll(/IWms(\w+)Service/g, 'Wms$1Service');
  c = c.replaceAll(/IOmsContainerDevanningSyncService/g, 'OmsContainerDevanningSyncService');
  c = c.replaceAll(/OmsDevanningPushBo/g, 'OmsDevanningPushDTO');
  c = c.replaceAll(/WmsDevanningOrderPushBo/g, 'WmsDevanningOrderPushReqVO');
  c = c.replaceAll(/WmsDevanningOrderSyncDockBo/g, 'WmsDevanningOrderSyncDockReqVO');
  c = c.replaceAll(/WmsDevanningOrderActionBo/g, 'WmsDevanningOrderActionReqVO');
  c = c.replaceAll(/WmsPalletItemVo/g, 'WmsPalletItemRespVO');
  c = c.replaceAll(/WmsPalletVo/g, 'WmsPalletRespVO');
  c = c.replaceAll(/WmsPalletItem\b/g, 'WmsPalletItemDO');
  c = c.replaceAll(/WmsPallet\b/g, 'WmsPalletDO');
  c = c.replaceAll(/WmsLocation\b/g, 'WmsLocationDO');
  c = c.replaceAll(/WmsInventoryLock\b/g, 'WmsInventoryLockDO');
  c = c.replaceAll(/WmsInventoryTransaction\b/g, 'WmsInventoryTransactionDO');
  c = c.replaceAll(/WmsInventory\b/g, 'WmsInventoryDO');
  c = c.replaceAll(/WmsDevanningOrder\b/g, 'WmsDevanningOrderDO');
  c = c.replaceAll(/CargoOrderShipment\b/g, 'CargoOrderShipmentDO');
  c = c.replaceAll(/CargoOrder\b/g, 'CargoOrderDO');
  c = c.replaceAll(/CargoOrderShipmentMapper/g, 'CargoOrderShipmentMapper');
  c = c.replaceAll(/CargoOrderMapper/g, 'CargoOrderMapper');
  c = c.replaceAll(`import org.dromara.oms.domain.CargoOrderDO;`, `import ${PKG}.dal.dataobject.cargoorder.CargoOrderDO;`);
  c = c.replaceAll(`import org.dromara.oms.domain.CargoOrderShipmentDO;`, `import ${PKG}.dal.dataobject.cargoorder.CargoOrderShipmentDO;`);
  c = c.replaceAll(`import org.dromara.oms.mapper.CargoOrderMapper;`, `import ${PKG}.dal.mysql.cargoorder.CargoOrderMapper;`);
  c = c.replaceAll(`import org.dromara.oms.mapper.CargoOrderShipmentMapper;`, `import ${PKG}.dal.mysql.cargoorder.CargoOrderShipmentMapper;`);
  c = c.replaceAll(`import org.dromara.oms.integration.IOmsContainerDevanningSyncService;`, `import ${PKG}.api.devanning.OmsContainerDevanningSyncService;`);
  c = c.replaceAll(`import org.dromara.oms.integration.IWmsDevanningOrderBridge;`, `import ${PKG}.api.devanning.WmsDevanningOrderBridge;`);
  c = c.replaceAll(`import org.dromara.oms.domain.bo.OmsDevanningPushDTO;`, `import ${PKG}.api.devanning.dto.OmsDevanningPushDTO;`);

  if (opts.impl) {
    c = c.replace(/throw new REMOVED_ServiceException\("([^"]*)"\)/g, 'throw exception(WMS_BIZ_ERROR, "$1")');
    if (!c.includes('ServiceExceptionUtil')) {
      c = c.replace(/(package [^;]+;\n)/, `$1\nimport static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;\nimport static ${WMS_PKG}.enums.ErrorCodeConstants.*;\n`);
    }
    c = c.replace(/@RequiredArgsConstructor\n/g, '');
    c = c.replace(/private final /g, '@Resource\n    private ');
    c = c.replace(/import lombok.RequiredArgsConstructor;\n/g, 'import jakarta.annotation.Resource;\n');
    c = c.replace(/return Boolean\.TRUE;/g, 'return true;');
    c = c.replace(/return Boolean\.FALSE;/g, 'return false;');
    c = c.replace(/return orderMapper\.deleteBatchIds\(ids\) > 0;/g, 'orderMapper.deleteByIds(ids); return true;');
    c = c.replace(/boolean ok = orderMapper\.updateById\(order\) > 0;/g, 'orderMapper.updateById(order); boolean ok = true;');
    c = c.replace(/return persistTransition\(order, "confirmArrival"/g, 'boolean ok = persistTransition(order, "confirmArrival"');
    // keep reference OMS sync calls as-is after field renames
  }
  return c;
}

// Bridge (correct yudao imports; do not overwrite if manually fixed)
const bridgeDest = path.join(outWmsJava, 'integration/WmsDevanningOrderBridgeImpl.java');
if (!fs.existsSync(bridgeDest)) {
  let bridge = transformWms(fs.readFileSync(refWmsBridge, 'utf8'));
  bridge = bridge.replace(/package [^;]+;/, `package ${WMS_PKG}.integration;`);
  bridge = bridge.replace(/@RequiredArgsConstructor\n@Service/g, '@Service');
  bridge = bridge.replace(/private final /g, '@Resource\n    private ');
  bridge = bridge.replace(/import lombok.RequiredArgsConstructor;\n/g, 'import jakarta.annotation.Resource;\n');
  bridge = bridge.replace(/org\.dromara\.oms\.domain\.bo\.OmsDevanningPushDTO/g, `${PKG}.api.devanning.dto.OmsDevanningPushDTO`);
  bridge = bridge.replace(/org\.dromara\.oms\.integration\.IWmsDevanningOrderBridge/g, `${PKG}.api.devanning.WmsDevanningOrderBridge`);
  bridge = bridge.replace(/org\.dromara\.wms\.domain\.bo\.WmsDevanningOrderPushBo/g, `${WMS_PKG}.controller.admin.devanningorder.vo.WmsDevanningOrderPushReqVO`);
  bridge = bridge.replace(/org\.dromara\.wms\.service\.IWmsDevanningOrderService/g, `${WMS_PKG}.service.devanningorder.WmsDevanningOrderService`);
  wr('integration/WmsDevanningOrderBridgeImpl.java', bridge, outWmsJava);
}

// ─── pom.xml ───
const omsPom = `<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <groupId>cn.iocoder.boot</groupId>
        <artifactId>yudao</artifactId>
        <version>\${revision}</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>
    <artifactId>yudao-module-oms</artifactId>
    <packaging>jar</packaging>
    <name>\${project.artifactId}</name>
    <description>OMS 订单管理模块（海柜/委托单/入库计划/出库）</description>
    <dependencies>
        <dependency>
            <groupId>cn.iocoder.boot</groupId>
            <artifactId>yudao-module-system</artifactId>
            <version>\${revision}</version>
        </dependency>
        <dependency>
            <groupId>cn.iocoder.boot</groupId>
            <artifactId>yudao-module-base</artifactId>
            <version>\${revision}</version>
        </dependency>
        <dependency>
            <groupId>cn.iocoder.boot</groupId>
            <artifactId>yudao-module-yms</artifactId>
            <version>\${revision}</version>
        </dependency>
        <dependency>
            <groupId>cn.iocoder.boot</groupId>
            <artifactId>yudao-module-org-permission</artifactId>
            <version>\${revision}</version>
        </dependency>
        <dependency>
            <groupId>cn.iocoder.boot</groupId>
            <artifactId>yudao-spring-boot-starter-biz-tenant</artifactId>
        </dependency>
        <dependency>
            <groupId>cn.iocoder.boot</groupId>
            <artifactId>yudao-spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>cn.iocoder.boot</groupId>
            <artifactId>yudao-spring-boot-starter-security</artifactId>
        </dependency>
        <dependency>
            <groupId>cn.iocoder.boot</groupId>
            <artifactId>yudao-spring-boot-starter-mybatis</artifactId>
        </dependency>
        <dependency>
            <groupId>cn.iocoder.boot</groupId>
            <artifactId>yudao-spring-boot-starter-excel</artifactId>
        </dependency>
        <dependency>
            <groupId>cn.iocoder.boot</groupId>
            <artifactId>yudao-spring-boot-starter-test</artifactId>
        </dependency>
    </dependencies>
</project>
`;
fs.writeFileSync(path.join(root, 'yudao-module-oms/pom.xml'), omsPom, 'utf8');
created.push('yudao-module-oms/pom.xml');

function patchPom(file, moduleArtifact) {
  let pom = fs.readFileSync(file, 'utf8');
  if (!pom.includes(moduleArtifact)) {
    if (file.endsWith('pom.xml') && pom.includes('<modules>')) {
      pom = pom.replace(
        '<module>yudao-module-base</module>',
        '<module>yudao-module-base</module>\n        <module>yudao-module-oms</module>'
      );
    }
    if (pom.includes('yudao-module-wms')) {
      pom = pom.replace(
        `<artifactId>yudao-module-base</artifactId>\n            <version>\${revision}</version>\n        </dependency>`,
        `<artifactId>yudao-module-base</artifactId>\n            <version>\${revision}</version>\n        </dependency>\n        <dependency>\n            <groupId>cn.iocoder.boot</groupId>\n            <artifactId>yudao-module-oms</artifactId>\n            <version>\${revision}</version>\n        </dependency>`
      );
    }
    if (pom.includes('yudao-module-yms') && pom.includes('yudao-module-base') && !pom.includes('yudao-module-oms')) {
      pom = pom.replace(
        `<artifactId>yudao-module-base</artifactId>\n            <version>\${revision}</version>\n        </dependency>\n        <dependency>\n            <groupId>cn.iocoder.boot</groupId>\n            <artifactId>yudao-spring-boot-starter-biz-tenant</artifactId>`,
        `<artifactId>yudao-module-base</artifactId>\n            <version>\${revision}</version>\n        </dependency>\n        <dependency>\n            <groupId>cn.iocoder.boot</groupId>\n            <artifactId>yudao-module-oms</artifactId>\n            <version>\${revision}</version>\n        </dependency>\n        <dependency>\n            <groupId>cn.iocoder.boot</groupId>\n            <artifactId>yudao-spring-boot-starter-biz-tenant</artifactId>`
      );
    }
    if (pom.includes('yudao-module-wms</artifactId>') && pom.includes('yudao-server')) {
      pom = pom.replace(
        `<artifactId>yudao-module-org-permission</artifactId>\n            <version>\${revision}</version>\n        </dependency>\n        <dependency>\n            <groupId>cn.iocoder.boot</groupId>\n            <artifactId>yudao-module-wms</artifactId>`,
        `<artifactId>yudao-module-org-permission</artifactId>\n            <version>\${revision}</version>\n        </dependency>\n        <dependency>\n            <groupId>cn.iocoder.boot</groupId>\n            <artifactId>yudao-module-oms</artifactId>\n            <version>\${revision}</version>\n        </dependency>\n        <dependency>\n            <groupId>cn.iocoder.boot</groupId>\n            <artifactId>yudao-module-wms</artifactId>`
      );
    }
  }
  fs.writeFileSync(file, pom, 'utf8');
}

patchPom(path.join(root, 'pom.xml'), 'yudao-module-oms');
patchPom(path.join(root, 'yudao-server/pom.xml'), 'yudao-module-oms');
patchPom(path.join(root, 'yudao-module-wms/pom.xml'), 'yudao-module-oms');
// YMS 通过 YmsSourceOrderSyncHandler 接口与 OMS 解耦，不可依赖 yudao-module-oms（会与 OMS→YMS 形成环）

// ─── SQL init ───
const sqlOrder = [
  'cargo_order_ddl.sql',
  'fix_cargo_order_schema_20260522.sql',
  'fix_cargo_order_fields_20260523.sql',
  'oms_order_enhancement_20260523.sql',
  'oms_cargo_order_enhancement_20260524.sql',
  'oms_biz_root_lifecycle_20260527.sql',
  'oms_cargo_grouping_rule_20260527.sql',
  'oms_container_order_20260522.sql',
  'oms_container_order_fields_patch_20260522.sql',
  'oms_container_order_enhancement_20260525.sql',
  'oms_attachment_type_dict_20260525.sql',
  'oms_pre_outbound_fields_20260525.sql',
  'oms_pre_outbound_item_20260525.sql',
  'oms_outbound_20260524.sql',
  'oms_outbound_1ton_refactor_20260526.sql',
  'oms_outbound_cleanup_cancelled_20260526.sql',
  'oms_cargo_order_summary_backfill_20260527.sql',
];
let sqlOut = `-- OMS init from reference (menu IDs 6900+)\n-- Run after teardown if rebuilding: sql/mysql/oms-teardown.sql\nSET NAMES utf8mb4;\n\n`;
for (const f of sqlOrder) {
  const p = path.join(refSql, f);
  if (fs.existsSync(p)) {
    sqlOut += `\n-- ===== ${f} =====\n`;
    sqlOut += fs.readFileSync(p, 'utf8') + '\n';
  }
}
for (const extra of ['sql/mysql/oms-menu.sql', 'sql/migration-overall/03-oms-menu-ext.sql']) {
  const p = path.join(root, extra);
  if (fs.existsSync(p)) {
    sqlOut += `\n-- ===== ${extra} =====\n`;
    sqlOut += fs.readFileSync(p, 'utf8') + '\n';
  }
}
const sqlDest = path.join(root, 'sql/mysql/oms-init-from-reference.sql');
fs.mkdirSync(path.dirname(sqlDest), { recursive: true });
fs.writeFileSync(sqlDest, sqlOut, 'utf8');
created.push('sql/mysql/oms-init-from-reference.sql');

console.log(`Ported ${javaCount} OMS Java files`);
console.log(`Created/updated ${created.length} artifacts`);
console.log('SQL:', sqlDest);

await import('./build-oms-fix.mjs');
