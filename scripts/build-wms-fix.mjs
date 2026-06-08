import fs from 'node:fs';
import path from 'node:path';

const root = path.resolve(import.meta.dirname, '..');
const ref = path.resolve(root, '../../WMSProject/overallSystem/WMSRuoYi-Vue-Plus/ruoyi-modules/ruoyi-wms/src/main/java/org/dromara/wms');
const out = path.join(root, 'yudao-module-wms/src/main/java/cn/iocoder/yudao/module/wms');
const PKG = 'cn.iocoder.yudao.module.wms';

const ENTITIES = {
  WmsZone: { pkg: 'zone', mapper: 'WmsZoneMapper' },
  WmsLocation: { pkg: 'location', mapper: 'WmsLocationMapper' },
  WmsInventory: { pkg: 'inventory', mapper: 'WmsInventoryMapper' },
  WmsPallet: { pkg: 'pallet', mapper: 'WmsPalletMapper' },
  WmsPalletItem: { pkg: 'palletitem', mapper: 'WmsPalletItemMapper' },
  WmsInventoryLock: { pkg: 'inventorylock', mapper: 'WmsInventoryLockMapper' },
  WmsInventoryTransaction: { pkg: 'inventorytransaction', mapper: 'WmsInventoryTransactionMapper' },
  WmsDevanningOrder: { pkg: 'devanningorder', mapper: 'WmsDevanningOrderMapper' },
  WmsDevanningOrderTrace: { pkg: 'devanningorder', mapper: 'WmsDevanningOrderTraceMapper' },
};

function wr(rel, c) {
  const p = path.join(out, rel);
  fs.mkdirSync(path.dirname(p), { recursive: true });
  fs.writeFileSync(p, c, 'utf8');
}

function ent(name) { return name + 'DO'; }

function fixImports(c) {
  c = c.replaceAll('org.dromara.wms.', `${PKG}.`);
  c = c.replaceAll('org.dromara.oms.', 'cn.iocoder.yudao.module.oms.');
  for (const [e, meta] of Object.entries(ENTITIES)) {
    c = c.replaceAll(`org.dromara.wms.domain.${e}`, `${PKG}.dal.dataobject.${meta.pkg}.${ent(e)}`);
    c = c.replaceAll(`org.dromara.wms.mapper.${e}Mapper`, `${PKG}.dal.mysql.${meta.pkg}.${meta.mapper}`);
  }
  c = c.replaceAll('org.dromara.wms.domain.bo.', `${PKG}.controller.admin._bo_.`);
  c = c.replaceAll('org.dromara.wms.domain.vo.', `${PKG}.controller.admin._vo_.`);
  c = c.replaceAll('org.dromara.wms.service.IWms', `${PKG}.service._svc_.Wms`);
  c = c.replaceAll('org.dromara.wms.service.IWms', `${PKG}.service.`);
  return c;
}

function xform(content, opts = {}) {
  let c = fixImports(content);
  c = c.replace(/import org\.dromara\.common\.core\.exception\.ServiceException;\n/g, '');
  c = c.replaceAll('org.dromara.common.core.utils.StringUtils', 'cn.hutool.core.util.StrUtil');
  c = c.replaceAll('org.dromara.common.core.utils.MapstructUtils', 'cn.iocoder.yudao.framework.common.util.object.BeanUtils');
  c = c.replaceAll('org.dromara.common.mybatis.core.page.PageQuery', 'cn.iocoder.yudao.framework.common.pojo.PageParam');
  c = c.replaceAll('org.dromara.common.mybatis.core.page.TableDataInfo', 'cn.iocoder.yudao.framework.common.pojo.PageResult');
  c = c.replaceAll('org.dromara.common.redis.utils.SequenceUtils', 'SEQ');
  c = c.replaceAll('org.dromara.common.satoken.utils.LoginHelper', 'cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils');
  c = c.replaceAll('org.dromara.common.tenant.helper.TenantHelper', 'cn.iocoder.yudao.framework.tenant.core.context.TenantContextHolder');
  c = c.replaceAll(/\bStringUtils\./g, 'StrUtil.');
  c = c.replaceAll(/\bMapstructUtils\.convert\b/g, 'BeanUtils.toBean');

  // rename BO/VO before entity
  const renames = [
    ['WmsInventoryTransactionQueryBo', 'WmsInventoryTransactionPageReqVO'],
    ['WmsInventoryLockQueryBo', 'WmsInventoryLockPageReqVO'],
    ['WmsInventoryVisualizationQueryBo', 'WmsInventoryVisualizationReqVO'],
    ['WmsZoneQueryBo', 'WmsZonePageReqVO'], ['WmsLocationQueryBo', 'WmsLocationPageReqVO'],
    ['WmsInventoryQueryBo', 'WmsInventoryPageReqVO'], ['WmsPalletQueryBo', 'WmsPalletPageReqVO'],
    ['WmsDevanningOrderQueryBo', 'WmsDevanningOrderPageReqVO'],
    ['WmsZoneBo', 'WmsZoneSaveReqVO'], ['WmsLocationBo', 'WmsLocationSaveReqVO'],
    ['WmsLocationBatchStatusBo', 'WmsLocationBatchStatusReqVO'],
    ['WmsInventoryReceiveBo', 'WmsInventoryReceiveReqVO'], ['WmsInventoryLockBo', 'WmsInventoryLockReqVO'],
    ['WmsInventoryAdjustBo', 'WmsInventoryAdjustReqVO'], ['WmsPalletMoveBo', 'WmsPalletMoveReqVO'],
    ['WmsPalletOutboundBo', 'WmsPalletOutboundReqVO'],
    ['WmsDevanningOrderBo', 'WmsDevanningOrderSaveReqVO'], ['WmsDevanningOrderPushBo', 'WmsDevanningOrderPushReqVO'],
    ['WmsDevanningOrderSyncDockBo', 'WmsDevanningOrderSyncDockReqVO'], ['WmsDevanningOrderActionBo', 'WmsDevanningOrderActionReqVO'],
    ['WmsZoneVo', 'WmsZoneRespVO'], ['WmsLocationVo', 'WmsLocationRespVO'], ['WmsLocationImportVo', 'WmsLocationImportExcelVO'],
    ['WmsInventoryVo', 'WmsInventoryRespVO'], ['WmsInventoryStatsVo', 'WmsInventoryStatsRespVO'],
    ['WmsInventoryLockVo', 'WmsInventoryLockRespVO'], ['WmsInventoryTransactionVo', 'WmsInventoryTransactionRespVO'],
    ['WmsInventoryVisualizationVo', 'WmsInventoryVisualizationRespVO'], ['WmsZoneVisualizationVo', 'WmsZoneVisualizationRespVO'],
    ['WmsLocationVisualizationVo', 'WmsLocationVisualizationRespVO'], ['WmsLocationDestinationStatVo', 'WmsLocationDestinationStatRespVO'],
    ['WmsPalletVo', 'WmsPalletRespVO'], ['WmsPalletItemVo', 'WmsPalletItemRespVO'],
    ['WmsDevanningOrderVo', 'WmsDevanningOrderRespVO'], ['WmsDevanningOrderTraceVo', 'WmsDevanningOrderTraceRespVO'],
    ['IWmsZoneService', 'WmsZoneService'], ['IWmsLocationService', 'WmsLocationService'],
    ['IWmsInventoryService', 'WmsInventoryService'], ['IWmsDevanningOrderService', 'WmsDevanningOrderService'],
    ['IOmsContainerDevanningSyncService', 'OmsContainerDevanningSyncService'],
    ['CargoOrderShipment', 'ShipmentDO'], ['CargoOrderShipmentMapper', 'ShipmentMapper'],
  ];
  for (const [a, b] of renames) c = c.replaceAll(a, b);

  for (const e of Object.keys(ENTITIES)) {
    const re = new RegExp(`(?<![A-Za-z])${e}(?!DO|Mapper|Service|Controller|Resp|Save|Page|Req|Excel)`, 'g');
    c = c.replace(re, ent(e));
  }

  if (opts.impl) {
    c = c.replace(/package org\.dromara\.wms\.service\.impl;/, 'PACKAGE_PLACEHOLDER');
    c = c.replace(/throw new ServiceException\("([^"]+)"\)/g, 'throw exception(WMS_BIZ_ERROR, "$1")');
    if (!c.includes('ServiceExceptionUtil')) {
      c = c.replace(/(package [^;]+;\n)/, `$1\nimport static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;\nimport static ${PKG}.enums.ErrorCodeConstants.*;\nimport cn.iocoder.yudao.framework.common.util.object.BeanUtils;\nimport jakarta.annotation.Resource;\n`);
    }
    c = c.replace(/@RequiredArgsConstructor\n@Service/g, '@Service');
    c = c.replace(/private final /g, '@Resource\n    private ');
    c = c.replace(/SEQ\.getDateId\("DN", true, 6\)/g, 'wmsNoGenerateService.nextDevanningNo()');
    if (c.includes('wmsNoGenerateService')) {
      c = c.replace(/(@Service\npublic class WmsDevanningOrderServiceImpl)/, `$1\n\n    @Resource\n    private ${PKG}.service.no.WmsNoGenerateService wmsNoGenerateService;`);
    }
    c = c.replace(/Page<(\w+)> page = (\w+)Mapper\.selectVoPage\(pageReqVO\.build\(\),/g,
      'PageResult<$1DO> pageResult = $2Mapper.selectPage(pageReqVO,');
    c = c.replace(/return TableDataInfo\.build\(page\);/g,
      (m, i) => 'return new PageResult<>(BeanUtils.toBean(pageResult.getList(), RESP_PLACEHOLDER.class), pageResult.getTotal());');
    c = c.replace(/\.selectVoById\(/g, '.selectById(');
    c = c.replace(/\.selectVoList\(/g, '.selectList(');
    c = c.replace(/\.deleteBatchIds\(/g, '.deleteByIds(');
    c = c.replace(/entity\.setDeleted\(0\);\n/g, '');
    c = c.replace(/LoginHelper\./g, 'SecurityFrameworkUtils.');
    c = c.replace(/TenantHelper\.getTenantId\(\)/g, 'String.valueOf(TenantContextHolder.getTenantId())');
    c = c.replace(/trace\.setTenantId\(TenantContextHolder\.getTenantId\(\)\)/g, '/* tenant on TenantBaseDO */');
    c = c.replace(/order\.getBusinessTypeName\(\)/g, 'order.getBizType()');
    c = c.replace(/order\.getContainerNo\(\)/g, 'null');
    c = c.replace(/order\.getGroupCode\(\)/g, 'order.getTransferPlatformAddressCode()');
    c = c.replace(/order\.getPlatformName\(\)/g, 'order.getPlatform()');
    c = c.replace(/order\.getPlatformWarehouseCode\(\)/g, 'order.getPlatformAddressCode()');
    c = c.replace(/Integer\.valueOf\(1\)\.equals\(order\.getHoldFlag\(\)\)/g, 'Boolean.TRUE.equals(order.getOnHold())');
    c = c.replace(/shipment\.getShippingMark\(\)/g, 'shipment.getGoodsName()');
    c = c.replace(/shipment\.getGroupCode\(\)/g, 'shipment.getShipmentCode()');
    c = c.replace(/import org\.dromara\.oms\.domain\.CargoOrderDO;/g, `import cn.iocoder.yudao.module.oms.dal.dataobject.core.CargoOrderDO;`);
    c = c.replace(/import org\.dromara\.oms\.mapper\.CargoOrderMapper;/g, `import cn.iocoder.yudao.module.oms.dal.mysql.core.CargoOrderMapper;`);
    c = c.replace(/import org\.dromara\.oms\.integration\.OmsContainerDevanningSyncService;/g,
      `import cn.iocoder.yudao.module.oms.api.devanning.OmsContainerDevanningSyncService;`);
  }
  return c;
}

// BO -> VO files
const boMap = {
  WmsZoneBo: ['zone', 'WmsZoneSaveReqVO'], WmsZoneQueryBo: ['zone', 'WmsZonePageReqVO'],
  WmsLocationBo: ['location', 'WmsLocationSaveReqVO'], WmsLocationQueryBo: ['location', 'WmsLocationPageReqVO'],
  WmsLocationBatchStatusBo: ['location', 'WmsLocationBatchStatusReqVO'],
  WmsInventoryQueryBo: ['inventory', 'WmsInventoryPageReqVO'], WmsInventoryReceiveBo: ['inventory', 'WmsInventoryReceiveReqVO'],
  WmsInventoryLockBo: ['inventory', 'WmsInventoryLockReqVO'], WmsInventoryLockQueryBo: ['inventory', 'WmsInventoryLockPageReqVO'],
  WmsInventoryAdjustBo: ['inventory', 'WmsInventoryAdjustReqVO'],
  WmsInventoryTransactionQueryBo: ['inventory', 'WmsInventoryTransactionPageReqVO'],
  WmsInventoryVisualizationQueryBo: ['inventory', 'WmsInventoryVisualizationReqVO'],
  WmsPalletQueryBo: ['inventory', 'WmsPalletPageReqVO'], WmsPalletMoveBo: ['inventory', 'WmsPalletMoveReqVO'],
  WmsPalletOutboundBo: ['inventory', 'WmsPalletOutboundReqVO'],
  WmsDevanningOrderBo: ['devanningorder', 'WmsDevanningOrderSaveReqVO'],
  WmsDevanningOrderQueryBo: ['devanningorder', 'WmsDevanningOrderPageReqVO'],
  WmsDevanningOrderPushBo: ['devanningorder', 'WmsDevanningOrderPushReqVO'],
  WmsDevanningOrderSyncDockBo: ['devanningorder', 'WmsDevanningOrderSyncDockReqVO'],
  WmsDevanningOrderActionBo: ['devanningorder', 'WmsDevanningOrderActionReqVO'],
};
for (const [src, [folder, cls]] of Object.entries(boMap)) {
  let c = xform(fs.readFileSync(path.join(ref, 'domain/bo', src + '.java'), 'utf8'));
  c = c.replace(/package [^;]+;/, `package ${PKG}.controller.admin.${folder}.vo;`);
  c = c.replace(/@AutoMapper[\s\S]*?\)\n/g, '').replace(/import io\.github[^;]+;\n/g, '');
  c = c.replace(/extends BaseEntity/g, '').replace(/import org\.dromara\.common\.mybatis[^;]+;\n/g, '');
  c = c.replace(/import org\.dromara\.common\.core\.validate[^;]+;\n/g, '');
  c = c.replace(/, groups = \{[^}]+\}/g, '').replace(/groups = \{[^}]+\},? ?/g, '');
  c = c.replace(/public class \w+/, `import lombok.Data;\n\n@Data\npublic class ${cls}`);
  if (cls.includes('PageReqVO')) {
    c = c.replace('public class ' + cls, `import cn.iocoder.yudao.framework.common.pojo.PageParam;\nimport lombok.EqualsAndHashCode;\nimport lombok.ToString;\n\n@Data\n@EqualsAndHashCode(callSuper = true)\n@ToString(callSuper = true)\npublic class ${cls} extends PageParam`);
  }
  wr(`controller/admin/${folder}/vo/${cls}.java`, c);
}

const voMap = {
  WmsZoneVo: ['zone', 'WmsZoneRespVO'], WmsLocationVo: ['location', 'WmsLocationRespVO'],
  WmsLocationImportVo: ['location', 'WmsLocationImportExcelVO'],
  WmsInventoryVo: ['inventory', 'WmsInventoryRespVO'], WmsInventoryStatsVo: ['inventory', 'WmsInventoryStatsRespVO'],
  WmsInventoryLockVo: ['inventory', 'WmsInventoryLockRespVO'], WmsInventoryTransactionVo: ['inventory', 'WmsInventoryTransactionRespVO'],
  WmsInventoryVisualizationVo: ['inventory', 'WmsInventoryVisualizationRespVO'],
  WmsZoneVisualizationVo: ['inventory', 'WmsZoneVisualizationRespVO'],
  WmsLocationVisualizationVo: ['inventory', 'WmsLocationVisualizationRespVO'],
  WmsLocationDestinationStatVo: ['inventory', 'WmsLocationDestinationStatRespVO'],
  WmsPalletVo: ['inventory', 'WmsPalletRespVO'], WmsPalletItemVo: ['inventory', 'WmsPalletItemRespVO'],
  WmsDevanningOrderVo: ['devanningorder', 'WmsDevanningOrderRespVO'],
  WmsDevanningOrderTraceVo: ['devanningorder', 'WmsDevanningOrderTraceRespVO'],
};
for (const [src, [folder, cls]] of Object.entries(voMap)) {
  let c = xform(fs.readFileSync(path.join(ref, 'domain/vo', src + '.java'), 'utf8'));
  c = c.replace(/package [^;]+;/, `package ${PKG}.controller.admin.${folder}.vo;`);
  c = c.replace(/@AutoMapper[\s\S]*?\)\n/g, '').replace(/import io\.github[^;]+;\n/g, '');
  c = c.replace(/public class \w+/, `import lombok.Data;\nimport java.io.Serializable;\n\n@Data\npublic class ${cls} implements Serializable`);
  wr(`controller/admin/${folder}/vo/${cls}.java`, c);
}

// Services + impls
const services = [
  ['zone', 'WmsZone', 'service/IWmsZoneService.java', 'service/impl/WmsZoneServiceImpl.java', 'WmsZoneRespVO'],
  ['location', 'WmsLocation', 'service/IWmsLocationService.java', 'service/impl/WmsLocationServiceImpl.java', 'WmsLocationRespVO'],
  ['inventory', 'WmsInventory', 'service/IWmsInventoryService.java', 'service/impl/WmsInventoryServiceImpl.java', 'WmsInventoryRespVO'],
  ['devanningorder', 'WmsDevanningOrder', 'service/IWmsDevanningOrderService.java', 'service/impl/WmsDevanningOrderServiceImpl.java', 'WmsDevanningOrderRespVO'],
];
for (const [folder, name, si, impl, resp] of services) {
  let siC = xform(fs.readFileSync(path.join(ref, si), 'utf8'));
  siC = siC.replace(/package [^;]+;/, `package ${PKG}.service.${folder};`);
  siC = siC.replace(/PageQuery/g, 'PageParam').replace(/TableDataInfo/g, 'PageResult');
  wr(`service/${folder}/${name}Service.java`, siC);

  let implC = xform(fs.readFileSync(path.join(ref, impl), 'utf8'), { impl: true });
  implC = implC.replace(/PACKAGE_PLACEHOLDER/, `package ${PKG}.service.${folder};`);
  implC = implC.replace(/RESP_PLACEHOLDER/g, resp);
  implC = implC.replace(/implements IWms/g, 'implements Wms');
  for (const [e, meta] of Object.entries(ENTITIES)) {
    implC = implC.replaceAll(`${PKG}.controller.admin._bo_.`, `${PKG}.controller.admin.${folder}.vo.`);
    implC = implC.replaceAll(`${PKG}.controller.admin._vo_.`, `${PKG}.controller.admin.${folder}.vo.`);
  }
  // fix cross-folder vo imports for inventory
  if (folder === 'inventory') {
    implC = implC.replaceAll(`${PKG}.controller.admin.inventory.vo.WmsZone`, `${PKG}.controller.admin.inventory.vo.WmsZone`);
  }
  if (folder === 'zone') {
    implC = implC.replaceAll(`${PKG}.controller.admin.zone.vo.WmsLocation`, `${PKG}.dal.dataobject.location.WmsLocation`);
    implC = implC.replaceAll(`${PKG}.dal.mysql.zone.WmsLocationMapper`, `${PKG}.dal.mysql.location.WmsLocationMapper`);
  }
  wr(`service/${folder}/${name}ServiceImpl.java`, implC);
}

console.log('fix done');
