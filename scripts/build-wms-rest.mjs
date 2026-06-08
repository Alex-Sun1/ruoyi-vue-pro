import fs from 'node:fs';
import path from 'node:path';

const root = path.resolve(import.meta.dirname, '..');
const ref = path.resolve(root, '../../WMSProject/overallSystem/WMSRuoYi-Vue-Plus/ruoyi-modules/ruoyi-wms/src/main/java/org/dromara/wms');
const out = path.join(root, 'yudao-module-wms/src/main/java/cn/iocoder/yudao/module/wms');
const PKG = 'cn.iocoder.yudao.module.wms';
const created = [];

function wr(rel, c) {
  const p = path.join(out, rel);
  fs.mkdirSync(path.dirname(p), { recursive: true });
  fs.writeFileSync(p, c, 'utf8');
  created.push(rel);
}

function commonImports() {
  return `import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;\nimport static cn.iocoder.yudao.module.wms.enums.ErrorCodeConstants.*;\n`;
}

function xform(content, opts = {}) {
  let c = content;
  c = c.replaceAll('org.dromara.wms.', `${PKG}.`);
  c = c.replaceAll('org.dromara.oms.', 'cn.iocoder.yudao.module.oms.');
  c = c.replaceAll('org.dromara.common.core.exception.ServiceException', 'REMOVED_ServiceException');
  c = c.replace(/import REMOVED_ServiceException;\n/g, '');
  c = c.replaceAll('org.dromara.common.core.utils.StringUtils', 'cn.hutool.core.util.StrUtil');
  c = c.replaceAll('org.dromara.common.core.utils.MapstructUtils', 'cn.iocoder.yudao.framework.common.util.object.BeanUtils');
  c = c.replaceAll('org.dromara.common.mybatis.core.page.PageQuery', 'cn.iocoder.yudao.framework.common.pojo.PageParam');
  c = c.replaceAll('org.dromara.common.mybatis.core.page.TableDataInfo', 'cn.iocoder.yudao.framework.common.pojo.PageResult');
  c = c.replaceAll('org.dromara.common.redis.utils.SequenceUtils', 'SEQ_REMOVED');
  c = c.replaceAll('org.dromara.common.satoken.utils.LoginHelper', 'cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils');
  c = c.replaceAll('org.dromara.common.tenant.helper.TenantHelper', 'cn.iocoder.yudao.framework.tenant.core.context.TenantContextHolder');
  c = c.replaceAll('org.dromara.common.core.domain.R', 'cn.iocoder.yudao.framework.common.pojo.CommonResult');
  c = c.replaceAll('org.dromara.common.web.core.BaseController', 'REMOVED_BaseController');
  c = c.replaceAll('org.dromara.common.idempotent.annotation.RepeatSubmit', 'cn.iocoder.yudao.framework.idempotent.core.annotation.Idempotent');
  c = c.replaceAll('org.dromara.common.log.annotation.Log', 'cn.iocoder.yudao.framework.apilog.core.annotation.ApiAccessLog');
  c = c.replaceAll('org.dromara.common.log.enums.BusinessType', 'cn.iocoder.yudao.framework.apilog.core.enums.OperateTypeEnum');
  c = c.replaceAll('cn.dev33.satoken.annotation.SaCheckPermission', 'org.springframework.security.access.prepost.PreAuthorize');
  c = c.replaceAll('BusinessType.', 'OperateTypeEnum.');
  c = c.replaceAll(/\bStringUtils\./g, 'StrUtil.');
  c = c.replaceAll(/\bMapstructUtils\.convert\b/g, 'BeanUtils.toBean');
  c = c.replaceAll(/IWms(\w+)Service/g, 'Wms$1Service');
  c = c.replaceAll(/IOmsContainerDevanningSyncService/g, 'OmsContainerDevanningSyncService');
  c = c.replaceAll(/IWmsDevanningOrderBridge/g, 'WmsDevanningOrderBridge');
  c = c.replaceAll(/OmsDevanningPushBo/g, 'OmsDevanningPushDTO');
  c = c.replaceAll(/import org\.dromara\.oms\.domain\.bo\.OmsDevanningPushDTO/g,
    `import cn.iocoder.yudao.module.oms.api.devanning.dto.OmsDevanningPushDTO`);
  c = c.replaceAll(/import org\.dromara\.oms\.integration\.IWmsDevanningOrderBridge/g,
    `import cn.iocoder.yudao.module.oms.api.devanning.WmsDevanningOrderBridge`);
  c = c.replaceAll(/import org\.dromara\.oms\.integration\.IOmsContainerDevanningSyncService/g,
    `import cn.iocoder.yudao.module.oms.api.devanning.OmsContainerDevanningSyncService`);
  c = c.replaceAll(/import org\.dromara\.oms\.domain\.CargoOrder;/g,
    `import cn.iocoder.yudao.module.oms.dal.dataobject.core.CargoOrderDO;`);
  c = c.replaceAll(/import org\.dromara\.oms\.domain\.CargoOrderShipment;/g,
    `import cn.iocoder.yudao.module.oms.dal.dataobject.core.ShipmentDO;`);
  c = c.replaceAll(/import org\.dromara\.oms\.mapper\.CargoOrderMapper;/g,
    `import cn.iocoder.yudao.module.oms.dal.mysql.core.CargoOrderMapper;`);
  c = c.replaceAll(/import org\.dromara\.oms\.mapper\.CargoOrderShipmentMapper;/g,
    `import cn.iocoder.yudao.module.oms.dal.mysql.core.ShipmentMapper;`);
  c = c.replaceAll(/\bCargoOrderShipment\b/g, 'ShipmentDO');
  c = c.replaceAll(/\bCargoOrder\b/g, 'CargoOrderDO');
  c = c.replaceAll(/CargoOrderShipmentMapper/g, 'ShipmentMapper');

  const entityToDo = [
    ['WmsZone', 'zone'], ['WmsLocation', 'location'], ['WmsInventory', 'inventory'],
    ['WmsPallet', 'pallet'], ['WmsPalletItem', 'palletitem'], ['WmsInventoryLock', 'inventorylock'],
    ['WmsInventoryTransaction', 'inventorytransaction'], ['WmsDevanningOrder', 'devanningorder'],
    ['WmsDevanningOrderTrace', 'devanningorder'],
  ];
  for (const [ent] of entityToDo) {
    const re = new RegExp(`\\b${ent}\\b(?!DO|Vo|Bo|Service|Controller|Mapper|Resp|Save|Page|Req)`, 'g');
    c = c.replace(re, `${ent}DO`);
  }
  c = c.replace(/DO DO/g, 'DO');

  // BO/VO renames
  const boMap = [
    ['WmsZoneBo', 'WmsZoneSaveReqVO'], ['WmsZoneQueryBo', 'WmsZonePageReqVO'],
    ['WmsLocationBo', 'WmsLocationSaveReqVO'], ['WmsLocationQueryBo', 'WmsLocationPageReqVO'],
    ['WmsLocationBatchStatusBo', 'WmsLocationBatchStatusReqVO'],
    ['WmsInventoryQueryBo', 'WmsInventoryPageReqVO'], ['WmsInventoryReceiveBo', 'WmsInventoryReceiveReqVO'],
    ['WmsInventoryLockBo', 'WmsInventoryLockReqVO'], ['WmsInventoryLockQueryBo', 'WmsInventoryLockPageReqVO'],
    ['WmsInventoryAdjustBo', 'WmsInventoryAdjustReqVO'], ['WmsInventoryTransactionQueryBo', 'WmsInventoryTransactionPageReqVO'],
    ['WmsInventoryVisualizationQueryBo', 'WmsInventoryVisualizationReqVO'],
    ['WmsPalletQueryBo', 'WmsPalletPageReqVO'], ['WmsPalletMoveBo', 'WmsPalletMoveReqVO'],
    ['WmsPalletOutboundBo', 'WmsPalletOutboundReqVO'],
    ['WmsDevanningOrderBo', 'WmsDevanningOrderSaveReqVO'], ['WmsDevanningOrderQueryBo', 'WmsDevanningOrderPageReqVO'],
    ['WmsDevanningOrderPushBo', 'WmsDevanningOrderPushReqVO'], ['WmsDevanningOrderSyncDockBo', 'WmsDevanningOrderSyncDockReqVO'],
    ['WmsDevanningOrderActionBo', 'WmsDevanningOrderActionReqVO'],
  ];
  const voMap = [
    ['WmsZoneVo', 'WmsZoneRespVO'], ['WmsLocationVo', 'WmsLocationRespVO'], ['WmsLocationImportVo', 'WmsLocationImportExcelVO'],
    ['WmsInventoryVo', 'WmsInventoryRespVO'], ['WmsInventoryStatsVo', 'WmsInventoryStatsRespVO'],
    ['WmsInventoryLockVo', 'WmsInventoryLockRespVO'], ['WmsInventoryTransactionVo', 'WmsInventoryTransactionRespVO'],
    ['WmsInventoryVisualizationVo', 'WmsInventoryVisualizationRespVO'], ['WmsZoneVisualizationVo', 'WmsZoneVisualizationRespVO'],
    ['WmsLocationVisualizationVo', 'WmsLocationVisualizationRespVO'], ['WmsLocationDestinationStatVo', 'WmsLocationDestinationStatRespVO'],
    ['WmsPalletVo', 'WmsPalletRespVO'], ['WmsPalletItemVo', 'WmsPalletItemRespVO'],
    ['WmsDevanningOrderVo', 'WmsDevanningOrderRespVO'], ['WmsDevanningOrderTraceVo', 'WmsDevanningOrderTraceRespVO'],
  ];
  for (const [a, b] of [...boMap, ...voMap]) c = c.replaceAll(a, b);

  if (opts.serviceImpl) {
    c = c.replace(/throw new REMOVED_ServiceException\("([^"]*)"\)/g, 'throw exception(WMS_BIZ_ERROR, "$1")');
    c = c.replace(/throw new REMOVED_ServiceException\(([^)]+)\)/g, 'throw exception(WMS_BIZ_ERROR, String.valueOf($1))');
    if (!c.includes('ServiceExceptionUtil')) {
      c = c.replace(/(package [^;]+;\n)/, `$1\n${commonImports()}`);
    }
    c = c.replace(/SEQ_REMOVED\.getDateId\("DN", true, 6\)/g, 'wmsNoGenerateService.nextDevanningNo()');
    c = c.replace(/@RequiredArgsConstructor\n@Service/g, '@Service');
    c = c.replace(/@Service\npublic class WmsDevanningOrderServiceImpl/, `@Service\npublic class WmsDevanningOrderServiceImpl`);
    c = c.replace(/private final /g, '@Resource\n    private ');
    c = c.replace(/import lombok.RequiredArgsConstructor;\n/g, 'import jakarta.annotation.Resource;\n');
    if (c.includes('wmsNoGenerateService') && !c.includes('WmsNoGenerateService')) {
      c = c.replace(/import jakarta.annotation.Resource;/, `import jakarta.annotation.Resource;\nimport ${PKG}.service.no.WmsNoGenerateService;`);
      c = c.replace(/(@Service[\s\S]*?public class WmsDevanningOrderServiceImpl \{)/, `$1\n\n    @Resource\n    private WmsNoGenerateService wmsNoGenerateService;`);
    }
    // PageResult returns
    c = c.replace(/PageResult<(\w+)> (\w+) = (\w+)Mapper\.selectVoPage\(pageReqVO\.build\(\),/g,
      'PageResult<$1DO> pageResult = $3Mapper.selectPage(pageReqVO,');
    c = c.replace(/PageResult<(\w+)> page = (\w+)Mapper\.selectVoPage\(pageReqVO\.build\(\),/g,
      'PageResult<$1DO> pageResult = $2Mapper.selectPage(pageReqVO,');
    c = c.replace(/return TableDataInfo\.build\(page\);/g,
      'return new PageResult<>(BeanUtils.toBean(pageResult.getList(), $1RespVO.class), pageResult.getTotal());');
    c = c.replace(/return TableDataInfo\.build\(pageResult\);/g,
      'return new PageResult<>(BeanUtils.toBean(pageResult.getList(), WmsInventoryRespVO.class), pageResult.getTotal());');
    c = c.replace(/(\w+)Mapper\.selectVoById/g, '$1Mapper.selectById');
    c = c.replace(/(\w+)Mapper\.selectVoList/g, '$1Mapper.selectList');
    c = c.replace(/\.deleteBatchIds\(/g, '.deleteByIds(');
    c = c.replace(/entity\.setDeleted\(0\);\s*\n/g, '');
    c = c.replace(/LoginHelper\.getUserId\(\)/g, 'SecurityFrameworkUtils.getLoginUserId()');
    c = c.replace(/LoginHelper\.getUsername\(\)/g, 'SecurityFrameworkUtils.getLoginUserNickname()');
    c = c.replace(/TenantHelper\.getTenantId\(\)/g, 'TenantContextHolder.getTenantId()');
    // OMS field mapping in sync
    c = c.replace(/order\.getBusinessTypeName\(\)/g, 'order.getBizType()');
    c = c.replace(/order\.getContainerNo\(\)/g, 'null /* containerNo on cargo order N/A in Yudao schema */');
    c = c.replace(/order\.getGroupCode\(\)/g, 'order.getTransferPlatformAddressCode()');
    c = c.replace(/order\.getPlatformName\(\)/g, 'order.getPlatform()');
    c = c.replace(/order\.getPlatformWarehouseCode\(\)/g, 'order.getPlatformAddressCode()');
    c = c.replace(/Integer\.valueOf\(1\)\.equals\(order\.getHoldFlag\(\)\)/g, 'Boolean.TRUE.equals(order.getOnHold())');
    c = c.replace(/shipment\.getShipmentNo\(\)/g, 'shipment.getShipmentNo()');
    c = c.replace(/shipment\.getGroupCode\(\)/g, 'shipment.getShipmentCode()');
    c = c.replace(/shipment\.getShippingMark\(\)/g, 'shipment.getGoodsName()');
  }

  if (opts.controller) {
    c = c.replace(/extends REMOVED_BaseController/g, '');
    c = c.replace(/import REMOVED_BaseController;\n/g, '');
    c = c.replace(/@SaCheckPermission/g, '@PreAuthorize');
    c = c.replace(/@SaCheckPermission\("([^"]+)"\)/g, '@PreAuthorize("@ss.hasPermission(\'$1\')")');
    c = c.replace(/@PreAuthorize\("([^"]+)"\)/g, (m, p) => `@PreAuthorize("@ss.hasPermission('${p}')")`);
    c = c.replace(/@Log\(title = "([^"]+)", businessType = OperateTypeEnum\.(\w+)\)/g,
      '@ApiAccessLog(operateType = $2)');
    c = c.replace(/@RepeatSubmit/g, '@Idempotent');
    c = c.replace(/return toAjax\(([^)]+)\);/g, 'return success($1);');
    c = c.replace(/return R\.ok\(([^)]+)\);/g, 'return success($1);');
    c = c.replace(/TableDataInfo/g, 'CommonResult<PageResult');
    c = c.replace(/public CommonResult<PageResult<(\w+)>> list\(/g, 'public CommonResult<PageResult<$1>> getPage(');
    c = c.replace(/PageQuery pageQuery/g, '@Valid PageParam pageReqVO');
    c = c.replace(/, PageParam pageReqVO\)/g, ')');
    c = c.replace(/pageReqVO\.build\(\)/g, 'pageReqVO');
    c = c.replace(/@GetMapping\("\/list"\)/g, '@GetMapping("/page")');
    c = c.replace(/@RequestMapping\("\/wms\//g, '@RequestMapping("/wms/');
    c = c.replace(/@RequiredArgsConstructor/g, '');
    c = c.replace(/private final /g, '@Resource\n    private ');
    c = c.replace(/import lombok.RequiredArgsConstructor;\n/g, 'import jakarta.annotation.Resource;\n');
    c = c.replace(/import org\.dromara\.common\.excel\.utils\.ExcelUtil/g,
      'import cn.iocoder.yudao.framework.excel.core.util.ExcelUtils');
    c = c.replace(/ExcelUtil\.exportExcel/g, 'ExcelUtils.write');
    if (!c.includes('CommonResult.success')) {
      c = c.replace(/(package [^;]+;\n)/, `$1\nimport static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;\n`);
    }
    c = c.replace(/@Validated\(AddGroup\.class\)/g, '@Valid');
    c = c.replace(/@Validated\(EditGroup\.class\)/g, '@Valid');
    c = c.replace(/import org\.dromara\.common\.core\.validate\.[^;]+;\n/g, '');
  }

  if (opts.bo || opts.vo) {
    c = c.replace(/@AutoMapper[\s\S]*?\)\s*\n/g, '');
    c = c.replace(/import io\.github\.linpeilie\.annotations\.AutoMapper;\s*\n/g, '');
    c = c.replace(/extends BaseEntity/g, '');
    c = c.replace(/import org\.dromara\.common\.mybatis\.core\.domain\.BaseEntity;\s*\n/g, '');
    c = c.replace(/groups = \{AddGroup\.class, EditGroup\.class\}/g, '');
    c = c.replace(/groups = \{EditGroup\.class\}/g, '');
    c = c.replace(/groups = \{AddGroup\.class\}/g, '');
    c = c.replace(/import org\.dromara\.common\.core\.validate\.[^;]+;\s*\n/g, '');
    if (opts.vo && c.includes('ExcelProperty')) {
      c = c.replace(/import cn\.idev\.excel\.annotation\./g, 'import cn.idev.excel.annotation.');
    }
    if (opts.bo && c.includes('PageReqVO')) {
      if (!c.includes('PageParam')) {
        c = c.replace(/public class/, `import cn.iocoder.yudao.framework.common.pojo.PageParam;\nimport lombok.EqualsAndHashCode;\nimport lombok.ToString;\n\n@Data\n@EqualsAndHashCode(callSuper = true)\n@ToString(callSuper = true)\npublic class`.replace('public class', ''));
      }
    }
  }

  return c;
}

const voFolder = {
  zone: 'zone', location: 'location', inventory: 'inventory', pallet: 'inventory',
  inventorylock: 'inventory', inventorytransaction: 'inventory',
  devanningorder: 'devanningorder', devanningordertrace: 'devanningorder',
  locationdestinationstat: 'inventory', locationimport: 'location',
  zonevisualization: 'inventory', inventoryvisualization: 'inventory', inventorystats: 'inventory',
};

function boTarget(name) {
  const base = name.replace(/^Wms/, '').replace(/Bo\.java$/, '');
  let folder = 'inventory';
  if (base.startsWith('Zone')) folder = 'zone';
  else if (base.startsWith('Location')) folder = 'location';
  else if (base.startsWith('Devanning')) folder = 'devanningorder';
  let file = name.replace('Bo.java', 'SaveReqVO.java').replace('QueryBo', 'PageReqVO')
    .replace('PushBo', 'PushReqVO').replace('SyncDockBo', 'SyncDockReqVO').replace('ActionBo', 'ActionReqVO')
    .replace('BatchStatusBo', 'BatchStatusReqVO').replace('MoveBo', 'MoveReqVO').replace('OutboundBo', 'OutboundReqVO')
    .replace('ReceiveBo', 'ReceiveReqVO').replace('LockBo', 'LockReqVO').replace('AdjustBo', 'AdjustReqVO')
    .replace('VisualizationQueryBo', 'VisualizationReqVO').replace('TransactionQueryBo', 'TransactionPageReqVO')
    .replace('LockQueryBo', 'LockPageReqVO');
  return `controller/admin/${folder}/vo/${file}`;
}

function voTarget(name) {
  const base = name.replace(/^Wms/, '').replace(/Vo\.java$/, '');
  let folder = 'inventory';
  if (base.startsWith('Zone') && !base.includes('Visualization')) folder = 'zone';
  else if (base.startsWith('Location') && !base.includes('Visualization') && !base.includes('Destination')) folder = 'location';
  else if (base.startsWith('Devanning')) folder = 'devanningorder';
  const file = name.replace('Vo.java', 'RespVO.java').replace('ImportVo', 'ImportExcelVO');
  return `controller/admin/${folder}/vo/${file}`;
}

function walk(d, b = d) {
  return fs.readdirSync(d, { withFileTypes: true }).flatMap(e => {
    const p = path.join(d, e.name);
    return e.isDirectory() ? walk(p, b) : e.name.endsWith('.java') ? [path.relative(b, p)] : [];
  });
}

for (const rel of walk(path.join(ref, 'domain/bo'))) {
  let c = xform(fs.readFileSync(path.join(ref, 'domain/bo', rel), 'utf8'), { bo: true });
  const tgt = boTarget(rel);
  const pkg = tgt.split('/').slice(0, -1).join('.').replace('controller.admin', 'controller.admin');
  const cls = path.basename(tgt, '.java');
  c = c.replace(/package [^;]+;/, `package ${PKG}.${pkg.replace(/\//g, '.')};`);
  if (cls.includes('PageReqVO') && !c.includes('extends PageParam')) {
    c = c.replace(`public class ${cls}`, `import cn.iocoder.yudao.framework.common.pojo.PageParam;\nimport lombok.EqualsAndHashCode;\nimport lombok.ToString;\n\n@Data\n@EqualsAndHashCode(callSuper = true)\n@ToString(callSuper = true)\npublic class ${cls} extends PageParam`);
  }
  wr(tgt, c);
}

for (const rel of walk(path.join(ref, 'domain/vo'))) {
  let c = xform(fs.readFileSync(path.join(ref, 'domain/vo', rel), 'utf8'), { vo: true });
  const tgt = voTarget(rel);
  const pkg = tgt.split('/').slice(0, -1).join('.');
  const cls = path.basename(tgt, '.java');
  c = c.replace(/package [^;]+;/, `package ${PKG}.${pkg.replace(/\//g, '.')};`);
  wr(tgt, c);
}

// Services
const svcMap = {
  'service/IWmsZoneService.java': ['service/zone/WmsZoneService.java', 'zone'],
  'service/IWmsLocationService.java': ['service/location/WmsLocationService.java', 'location'],
  'service/IWmsInventoryService.java': ['service/inventory/WmsInventoryService.java', 'inventory'],
  'service/IWmsDevanningOrderService.java': ['service/devanningorder/WmsDevanningOrderService.java', 'devanningorder'],
};
for (const [src, [dest]] of Object.entries(svcMap)) {
  let c = xform(fs.readFileSync(path.join(ref, src), 'utf8'));
  const pkg = dest.replace(/\//g, '.').replace('.java', '').replace(/\//g, '.');
  c = c.replace(/package [^;]+;/, `package ${PKG}.${dest.replace(/\//g, '.').replace('.java', '')};`);
  c = c.replace(/PageQuery pageQuery/g, 'PageParam pageReqVO');
  c = c.replace(/TableDataInfo/g, 'PageResult');
  c = c.replace(/Boolean /g, 'void ');
  c = c.replace(/void insertByBo/g, 'Long create');
  c = c.replace(/void updateByBo/g, 'void update');
  c = c.replace(/void deleteByIds/g, 'void deleteList');
  wr(dest, c);
}

// Service impls
const implMap = {
  'service/impl/WmsZoneServiceImpl.java': 'service/zone/WmsZoneServiceImpl.java',
  'service/impl/WmsLocationServiceImpl.java': 'service/location/WmsLocationServiceImpl.java',
  'service/impl/WmsInventoryServiceImpl.java': 'service/inventory/WmsInventoryServiceImpl.java',
  'service/impl/WmsDevanningOrderServiceImpl.java': 'service/devanningorder/WmsDevanningOrderServiceImpl.java',
};
for (const [src, dest] of Object.entries(implMap)) {
  let c = xform(fs.readFileSync(path.join(ref, src), 'utf8'), { serviceImpl: true });
  c = c.replace(/package [^;]+;/, `package ${PKG}.${dest.replace(/\//g, '.').replace('.java', '')};`);
  c = c.replace(/implements IWms/g, 'implements Wms');
  c = c.replace(/Boolean insertByBo/g, 'Long create');
  c = c.replace(/Boolean updateByBo/g, 'void update');
  c = c.replace(/Boolean deleteByIds/g, 'void deleteList');
  c = c.replace(/return baseMapper\.insert\(entity\) > 0;/g, 'baseMapper.insert(entity); return entity.getId();');
  c = c.replace(/return baseMapper\.updateById\(entity\) > 0;/g, 'baseMapper.updateById(entity);');
  c = c.replace(/return baseMapper\.deleteByIds\(ids\) > 0;/g, 'baseMapper.deleteByIds(ids);');
  c = c.replace(/return Boolean\.TRUE;/g, 'return;');
  c = c.replace(/return Boolean\.FALSE;/g, 'return null;');
  wr(dest, c);
}

// Controllers
const ctrlMap = {
  'controller/WmsZoneController.java': 'controller/admin/zone/WmsZoneController.java',
  'controller/WmsLocationController.java': 'controller/admin/location/WmsLocationController.java',
  'controller/WmsInventoryController.java': 'controller/admin/inventory/WmsInventoryController.java',
  'controller/WmsDevanningOrderController.java': 'controller/admin/devanningorder/WmsDevanningOrderController.java',
};
for (const [src, dest] of Object.entries(ctrlMap)) {
  let c = xform(fs.readFileSync(path.join(ref, src), 'utf8'), { controller: true });
  c = c.replace(/package [^;]+;/, `package ${PKG}.${dest.replace(/\//g, '.').replace('.java', '')};`);
  wr(dest, c);
}

// Bridge
let bridge = xform(fs.readFileSync(path.join(ref, 'integration/WmsDevanningOrderBridgeImpl.java'), 'utf8'));
bridge = bridge.replace(/package [^;]+;/, `package ${PKG}.integration;`);
bridge = bridge.replace(/WmsDevanningOrderPushBo/g, 'WmsDevanningOrderPushReqVO');
wr('integration/WmsDevanningOrderBridgeImpl.java', bridge);

console.log('Created', created.length, 'files');
