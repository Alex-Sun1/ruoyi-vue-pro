import fs from 'node:fs';
import path from 'node:path';

const oms = path.join(path.resolve(import.meta.dirname, '..'), 'yudao-module-oms/src/main/java/cn/iocoder/yudao/module/oms');

function patch(rel, pairs) {
  const p = path.join(oms, rel);
  if (!fs.existsSync(p)) return;
  let c = fs.readFileSync(p, 'utf8');
  let changed = false;
  for (const [from, to] of pairs) {
    if (c.includes(from)) {
      c = c.replace(from, to);
      changed = true;
    }
  }
  if (changed) {
    fs.writeFileSync(p, c, 'utf8');
    console.log('Fixed', rel);
  }
}

function ensureImport(rel, imp) {
  const p = path.join(oms, rel);
  if (!fs.existsSync(p)) return;
  let c = fs.readFileSync(p, 'utf8');
  if (c.includes(imp)) return;
  c = c.replace(/(package [^;]+;\r?\n)/, `$1\n${imp}\n`);
  fs.writeFileSync(p, c, 'utf8');
}

function fixServiceExceptions(rel) {
  const p = path.join(oms, rel);
  if (!fs.existsSync(p)) return;
  let c = fs.readFileSync(p, 'utf8');
  if (!c.includes('ServiceException')) return;
  c = c.replace(/throw new ServiceException\("([^"]*)"\)/g, 'throw exception(OMS_BIZ_ERROR, "$1")');
  c = c.replace(/throw new ServiceException\(([^)]+)\)/g, 'throw exception(OMS_BIZ_ERROR, String.valueOf($1))');
  if (!c.includes('ServiceExceptionUtil')) {
    c = c.replace(/(package [^;]+;\r?\n)/,
      `$1\nimport static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;\nimport static cn.iocoder.yudao.module.oms.enums.ErrorCodeConstants.*;\n`);
  }
  fs.writeFileSync(p, c, 'utf8');
  console.log('Fixed ServiceException in', rel);
}

const voPageFix = (doType, voType, wrapperArg) =>
  `PageResult<${doType}> page = baseMapper.selectPage(pageQuery, ${wrapperArg});
        return new PageResult<>(BeanUtils.toBean(page.getList(), ${voType}.class), page.getTotal());`;

patch('service/cargoorder/CargoOrderServiceImpl.java', [
  ['return PageResult.build(baseMapper.selectPageList(new Page<>(pageQuery.getPageNo(), pageQuery.getPageSize()), bo));',
    `IPage<CargoOrderRespVO> pg = baseMapper.selectPageList(new Page<>(pageQuery.getPageNo(), pageQuery.getPageSize()), bo);
        return new PageResult<>(pg.getRecords(), pg.getTotal());`],
  ['return baseMapper.selectPageList(new PageParam(Integer.MAX_VALUE, 1).build(), bo).getRecords();',
    'return baseMapper.selectPageList(new Page<>(1, Integer.MAX_VALUE), bo).getRecords();'],
  ['CargoOrderRespVO vo = baseMapper.selectById(id);',
    'CargoOrderRespVO vo = BeanUtils.toBean(baseMapper.selectById(id), CargoOrderRespVO.class);'],
  ['List<BizAttachmentRespVO> result = new ArrayList<>(attachmentMapper.selectList(new LambdaQueryWrapper<BizAttachmentDO>()',
    'List<BizAttachmentRespVO> result = new ArrayList<>(BeanUtils.toBean(attachmentMapper.selectList(new LambdaQueryWrapper<BizAttachmentDO>()'],
  ['result.addAll(attachmentMapper.selectList(new LambdaQueryWrapper<BizAttachmentDO>()',
    'result.addAll(BeanUtils.toBean(attachmentMapper.selectList(new LambdaQueryWrapper<BizAttachmentDO>()'],
]);
// fix missing BizAttachmentRespVO.class on attachment queries (only when broken)
for (const rel of ['service/cargoorder/CargoOrderServiceImpl.java', 'service/containerorder/ContainerOrderServiceImpl.java', 'service/outboundorder/OutboundOrderServiceImpl.java']) {
  const p = path.join(oms, rel);
  if (!fs.existsSync(p)) continue;
  let c = fs.readFileSync(p, 'utf8');
  const broken = /\.orderByDesc\(BizAttachmentDO::getUploadTime\)\)\);/g;
  if (broken.test(c) && c.includes('BeanUtils.toBean(attachmentMapper.selectList')) {
    c = c.replace(/BeanUtils\.toBean\(attachmentMapper\.selectList\(([\s\S]*?)\.orderByDesc\(BizAttachmentDO::getUploadTime\)\)\);/g,
      'BeanUtils.toBean(attachmentMapper.selectList($1.orderByDesc(BizAttachmentDO::getUploadTime)), BizAttachmentRespVO.class);');
    c = c.replace(/new ArrayList<>\(BeanUtils\.toBean\(attachmentMapper\.selectList\(([\s\S]*?)\.orderByDesc\(BizAttachmentDO::getUploadTime\)\)\)\);/g,
      'new ArrayList<>(BeanUtils.toBean(attachmentMapper.selectList($1.orderByDesc(BizAttachmentDO::getUploadTime)), BizAttachmentRespVO.class));');
    c = c.replace(/result\.addAll\(BeanUtils\.toBean\(attachmentMapper\.selectList\(([\s\S]*?)\.orderByDesc\(BizAttachmentDO::getUploadTime\)\)\)\);/g,
      'result.addAll(BeanUtils.toBean(attachmentMapper.selectList($1.orderByDesc(BizAttachmentDO::getUploadTime)), BizAttachmentRespVO.class));');
    fs.writeFileSync(p, c, 'utf8');
    console.log('Fixed attachment BeanUtils in', rel);
  }
}

patch('service/containerorder/ContainerOrderServiceImpl.java', [
  [`Page<ContainerOrderRespVO> result = baseMapper.selectVoPage(new Page<>(pageQuery.getPageNo(), pageQuery.getPageSize()), buildQueryWrapper(bo));
        fillNames(result.getRecords());
        return result;`,
    `PageResult<ContainerOrderDO> page = baseMapper.selectPage(pageQuery, buildQueryWrapper(bo));
        List<ContainerOrderRespVO> records = BeanUtils.toBean(page.getList(), ContainerOrderRespVO.class);
        fillNames(records);
        return new PageResult<>(records, page.getTotal());`],
  ['List<ContainerOrderRespVO> list = baseMapper.selectList(buildQueryWrapper(bo));',
    'List<ContainerOrderRespVO> list = BeanUtils.toBean(baseMapper.selectList(buildQueryWrapper(bo)), ContainerOrderRespVO.class);'],
  ['ContainerOrderRespVO vo = baseMapper.selectById(id);',
    'ContainerOrderRespVO vo = BeanUtils.toBean(baseMapper.selectById(id), ContainerOrderRespVO.class);'],
  ['List<CargoOrderRespVO> cargoOrders = cargoOrderMapper.selectList(new LambdaQueryWrapper<CargoOrderDO>()',
    'List<CargoOrderRespVO> cargoOrders = BeanUtils.toBean(cargoOrderMapper.selectList(new LambdaQueryWrapper<CargoOrderDO>()'],
  ['.orderByAsc(CargoOrderDO::getCreateTime));',
    '.orderByAsc(CargoOrderDO::getCreateTime)), CargoOrderRespVO.class);'],
  ['Map<Long, List<CargoOrderShipmentRespVO>> shipmentMap = shipmentMapper.selectList(new LambdaQueryWrapper<CargoOrderShipmentDO>()',
    'Map<Long, List<CargoOrderShipmentRespVO>> shipmentMap = BeanUtils.toBean(shipmentMapper.selectList(new LambdaQueryWrapper<CargoOrderShipmentDO>()'],
  ['.orderByAsc(CargoOrderShipmentDO::getCreateTime))\n                .stream().collect(Collectors.groupingBy(CargoOrderShipmentRespVO::getCargoOrderId));',
    '.orderByAsc(CargoOrderShipmentDO::getCreateTime)), CargoOrderShipmentRespVO.class)\n                .stream().collect(Collectors.groupingBy(CargoOrderShipmentRespVO::getCargoOrderId));'],
  ['vo.setTraces(traceMapper.selectList(new LambdaQueryWrapper<ContainerOrderTraceDO>()',
    'vo.setTraces(BeanUtils.toBean(traceMapper.selectList(new LambdaQueryWrapper<ContainerOrderTraceDO>()'],
  ['.orderByDesc(ContainerOrderTraceDO::getCreateTime)));',
    '.orderByDesc(ContainerOrderTraceDO::getCreateTime)), ContainerOrderTraceRespVO.class));'],
  ['return attachmentMapper.selectList(new LambdaQueryWrapper<BizAttachmentDO>()',
    'return BeanUtils.toBean(attachmentMapper.selectList(new LambdaQueryWrapper<BizAttachmentDO>()'],
  ['throw exception(OMS_BIZ_ERROR, String.valueOf("货物订单[" + StrUtil.blankToDefault(cargoOrder.getCargoOrderNo()), "未生成编号") + "]至少需要一条货件");',
    'throw exception(OMS_BIZ_ERROR, "货物订单[" + StrUtil.blankToDefault(cargoOrder.getCargoOrderNo(), "未生成编号") + "]至少需要一条货件");'],
]);

patch('service/inboundplan/InboundPlanServiceImpl.java', [
  [`Page<InboundPlanRespVO> result = baseMapper.selectPageList(new Page<>(pageQuery.getPageNo(), pageQuery.getPageSize()), bo);
        return result;`,
    `Page<InboundPlanRespVO> result = baseMapper.selectPageList(new Page<>(pageQuery.getPageNo(), pageQuery.getPageSize()), bo);
        return new PageResult<>(result.getRecords(), result.getTotal());`],
]);

patch('service/outboundorder/OutboundOrderServiceImpl.java', [
  [`Page<OutboundOrderRespVO> result = baseMapper.selectVoPage(new Page<>(pageQuery.getPageNo(), pageQuery.getPageSize()), buildQueryWrapper(bo));
        return new PageResult<>(result.getRecords(), result.getTotal());`, voPageFix('OutboundOrderDO', 'OutboundOrderRespVO', 'buildQueryWrapper(bo)')],
  [`Page<OutboundOrderRespVO> result = baseMapper.selectPageList(new Page<>(pageQuery.getPageNo(), pageQuery.getPageSize()),  buildQueryWrapper(bo));
        return new PageResult<>(result.getRecords(), result.getTotal());`, voPageFix('OutboundOrderDO', 'OutboundOrderRespVO', 'buildQueryWrapper(bo)')],
  ['return baseMapper.selectList(buildQueryWrapper(bo));',
    'return BeanUtils.toBean(baseMapper.selectList(buildQueryWrapper(bo)), OutboundOrderRespVO.class);'],
  [`return BeanUtils.toBean(baseMapper.selectList(buildQueryWrapper(bo)).stream()
                .filter(item -> StrUtil.isNotBlank(item.getOutboundStatus()))
                .collect(Collectors.groupingBy(OutboundOrderDO::getOutboundStatus, Collectors.counting())), OutboundOrderRespVO.class);`,
    `return baseMapper.selectList(buildQueryWrapper(bo)).stream()
                .filter(item -> StrUtil.isNotBlank(item.getOutboundStatus()))
                .collect(Collectors.groupingBy(OutboundOrderDO::getOutboundStatus, Collectors.counting()));`],
  [`return outboundOrderItemMapper.selectList(
            Wrappers.<OutboundOrderItemDO>lambdaQuery()
                .eq(OutboundOrderItemDO::getOutboundOrderId, id));`,
    `return BeanUtils.toBean(outboundOrderItemMapper.selectList(
            Wrappers.<OutboundOrderItemDO>lambdaQuery()
                .eq(OutboundOrderItemDO::getOutboundOrderId, id)), OutboundOrderItemRespVO.class);`],
  ['return attachmentMapper.selectList(new LambdaQueryWrapper<BizAttachmentDO>()',
    'return BeanUtils.toBean(attachmentMapper.selectList(new LambdaQueryWrapper<BizAttachmentDO>()'],
]);

patch('service/outboundpool/OutboundPoolServiceImpl.java', [
  [`Page<CargoOrderRespVO> result = cargoOrderMapper.selectVoPage(new Page<>(pageQuery.getPageNo(), pageQuery.getPageSize()), buildPoolWrapper(bo));
        return new PageResult<>(result.getRecords(), result.getTotal());`,
    `PageResult<CargoOrderDO> page = cargoOrderMapper.selectPage(pageQuery, buildPoolWrapper(bo));
        return new PageResult<>(BeanUtils.toBean(page.getList(), CargoOrderRespVO.class), page.getTotal());`],
  [`Page<CargoOrderRespVO> result = cargoOrderMapper.selectPageList(new Page<>(pageQuery.getPageNo(), pageQuery.getPageSize()),  buildPoolWrapper(bo));
        return new PageResult<>(result.getRecords(), result.getTotal());`,
    `PageResult<CargoOrderDO> page = cargoOrderMapper.selectPage(pageQuery, buildPoolWrapper(bo));
        return new PageResult<>(BeanUtils.toBean(page.getList(), CargoOrderRespVO.class), page.getTotal());`],
  ['return preOutboundMapper.selectById(preOutbound.getId());',
    'return BeanUtils.toBean(preOutboundMapper.selectById(preOutbound.getId()), PreOutboundRespVO.class);'],
  ['return outboundOrderMapper.selectById(outboundOrder.getId());',
    'return BeanUtils.toBean(outboundOrderMapper.selectById(outboundOrder.getId()), OutboundOrderRespVO.class);'],
]);

patch('service/preoutbound/PreOutboundServiceImpl.java', [
  [`Page<PreOutboundRespVO> result = baseMapper.selectVoPage(new Page<>(pageQuery.getPageNo(), pageQuery.getPageSize()), buildQueryWrapper(bo));
        return new PageResult<>(result.getRecords(), result.getTotal());`, voPageFix('PreOutboundDO', 'PreOutboundRespVO', 'buildQueryWrapper(bo)')],
  [`Page<PreOutboundRespVO> result = baseMapper.selectPageList(new Page<>(pageQuery.getPageNo(), pageQuery.getPageSize()),  buildQueryWrapper(bo));
        return new PageResult<>(result.getRecords(), result.getTotal());`, voPageFix('PreOutboundDO', 'PreOutboundRespVO', 'buildQueryWrapper(bo)')],
  ['return baseMapper.selectList(buildQueryWrapper(bo));',
    'return BeanUtils.toBean(baseMapper.selectList(buildQueryWrapper(bo)), PreOutboundRespVO.class);'],
  ['return outboundOrderMapper.selectById(outboundOrder.getId());',
    'return BeanUtils.toBean(outboundOrderMapper.selectById(outboundOrder.getId()), OutboundOrderRespVO.class);'],
]);

patch('service/cargogroupingrule/CargoGroupingRuleServiceImpl.java', [
  [`Page<CargoGroupingRuleRespVO> result = baseMapper.selectVoPage(new Page<>(pageQuery.getPageNo(), pageQuery.getPageSize()), buildQueryWrapper(bo));
        return new PageResult<>(result.getRecords(), result.getTotal());`, voPageFix('CargoGroupingRuleDO', 'CargoGroupingRuleRespVO', 'buildQueryWrapper(bo)')],
  [`Page<CargoGroupingRuleRespVO> result = baseMapper.selectPageList(new Page<>(pageQuery.getPageNo(), pageQuery.getPageSize()), buildQueryWrapper(bo));
        return new PageResult<>(result.getRecords(), result.getTotal());`, voPageFix('CargoGroupingRuleDO', 'CargoGroupingRuleRespVO', 'buildQueryWrapper(bo)')],
  ['return baseMapper.selectList(buildQueryWrapper(bo));',
    'return BeanUtils.toBean(baseMapper.selectList(buildQueryWrapper(bo)), CargoGroupingRuleRespVO.class);'],
  ['return baseMapper.selectById(id);',
    'return BeanUtils.toBean(baseMapper.selectById(id), CargoGroupingRuleRespVO.class);'],
]);

patch('service/cargogroupingfieldmeta/CargoGroupingFieldMetaServiceImpl.java', [
  ['return baseMapper.selectList(buildQueryWrapper(bo));',
    'return BeanUtils.toBean(baseMapper.selectList(buildQueryWrapper(bo)), CargoGroupingFieldMetaRespVO.class);'],
  ['return baseMapper.selectById(id);',
    'return BeanUtils.toBean(baseMapper.selectById(id), CargoGroupingFieldMetaRespVO.class);'],
]);

for (const rel of [
  'service/cargoorder/CargoOrderServiceImpl.java',
  'service/containerorder/ContainerOrderServiceImpl.java',
  'service/preoutbound/PreOutboundServiceImpl.java',
  'service/cargogroupingrule/CargoGroupingRuleServiceImpl.java',
  'service/cargogroupingfieldmeta/CargoGroupingFieldMetaServiceImpl.java',
  'service/outboundorder/OutboundOrderServiceImpl.java',
  'service/outboundpool/OutboundPoolServiceImpl.java',
]) {
  fixServiceExceptions(rel);
  ensureImport(rel, 'import cn.iocoder.yudao.framework.common.util.object.BeanUtils;');
}

ensureImport('service/cargoorder/CargoOrderServiceImpl.java', 'import com.baomidou.mybatisplus.core.metadata.IPage;');
ensureImport('service/outboundpool/OutboundPoolServiceImpl.java', 'import cn.iocoder.yudao.framework.common.util.object.BeanUtils;');
ensureImport('service/preoutbound/PreOutboundServiceImpl.java', 'import cn.iocoder.yudao.framework.common.util.object.BeanUtils;');

console.log('OMS service fixes applied');
