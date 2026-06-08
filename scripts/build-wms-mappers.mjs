import fs from 'node:fs';
import path from 'node:path';

const root = path.resolve(import.meta.dirname, '..');
const out = path.join(root, 'yudao-module-wms/src/main/java/cn/iocoder/yudao/module/wms');
const PKG = 'cn.iocoder.yudao.module.wms';

const mappers = [
  { pkg: 'zone', entity: 'WmsZoneDO', pageVo: 'WmsZonePageReqVO', wrapper: `
        wrapper.eq(pageReqVO.getWarehouseId() != null, WmsZoneDO::getWarehouseId, pageReqVO.getWarehouseId());
        wrapper.like(StrUtil.isNotBlank(pageReqVO.getZoneName()), WmsZoneDO::getZoneName, pageReqVO.getZoneName());
        wrapper.eq(StrUtil.isNotBlank(pageReqVO.getZoneType()), WmsZoneDO::getZoneType, pageReqVO.getZoneType());
        wrapper.eq(StrUtil.isNotBlank(pageReqVO.getStorageMethod()), WmsZoneDO::getStorageMethod, pageReqVO.getStorageMethod());
        wrapper.eq(StrUtil.isNotBlank(pageReqVO.getStatus()), WmsZoneDO::getStatus, pageReqVO.getStatus());
        wrapper.orderByDesc(WmsZoneDO::getCreateTime);` },
  { pkg: 'location', entity: 'WmsLocationDO', pageVo: 'WmsLocationPageReqVO', wrapper: `
        wrapper.eq(pageReqVO.getWarehouseId() != null, WmsLocationDO::getWarehouseId, pageReqVO.getWarehouseId());
        wrapper.eq(pageReqVO.getZoneId() != null, WmsLocationDO::getZoneId, pageReqVO.getZoneId());
        wrapper.like(StrUtil.isNotBlank(pageReqVO.getZoneName()), WmsLocationDO::getZoneName, pageReqVO.getZoneName());
        wrapper.like(StrUtil.isNotBlank(pageReqVO.getLocationCode()), WmsLocationDO::getLocationCode, pageReqVO.getLocationCode());
        wrapper.eq(StrUtil.isNotBlank(pageReqVO.getStatus()), WmsLocationDO::getStatus, pageReqVO.getStatus());
        wrapper.orderByAsc(WmsLocationDO::getZoneName).orderByAsc(WmsLocationDO::getLocationCode);` },
  { pkg: 'inventory', entity: 'WmsInventoryDO', pageVo: 'WmsInventoryPageReqVO', wrapper: `
        wrapper.eq(pageReqVO.getWarehouseId() != null, WmsInventoryDO::getWarehouseId, pageReqVO.getWarehouseId());
        wrapper.eq(pageReqVO.getCustomerId() != null, WmsInventoryDO::getCustomerId, pageReqVO.getCustomerId());
        wrapper.eq(pageReqVO.getCargoOrderId() != null, WmsInventoryDO::getCargoOrderId, pageReqVO.getCargoOrderId());
        wrapper.eq(pageReqVO.getShipmentId() != null, WmsInventoryDO::getShipmentId, pageReqVO.getShipmentId());
        wrapper.eq(StrUtil.isNotBlank(pageReqVO.getInventoryStatus()), WmsInventoryDO::getInventoryStatus, pageReqVO.getInventoryStatus());
        if (!Boolean.TRUE.equals(pageReqVO.getIncludeDepleted())) {
            wrapper.gt(WmsInventoryDO::getTotalBoxQty, 0);
        }
        wrapper.and(StrUtil.isNotBlank(pageReqVO.getKeyword()), w -> w
            .like(WmsInventoryDO::getCargoOrderNo, pageReqVO.getKeyword())
            .or().like(WmsInventoryDO::getShipmentCode, pageReqVO.getKeyword())
            .or().like(WmsInventoryDO::getCustomerName, pageReqVO.getKeyword()));
        wrapper.orderByDesc(WmsInventoryDO::getUpdateTime);` },
  { pkg: 'pallet', entity: 'WmsPalletDO', pageVo: 'WmsPalletPageReqVO', wrapper: `
        wrapper.eq(pageReqVO.getWarehouseId() != null, WmsPalletDO::getWarehouseId, pageReqVO.getWarehouseId());
        wrapper.eq(pageReqVO.getLocationId() != null, WmsPalletDO::getLocationId, pageReqVO.getLocationId());
        wrapper.eq(pageReqVO.getCargoOrderId() != null, WmsPalletDO::getCargoOrderId, pageReqVO.getCargoOrderId());
        wrapper.eq(pageReqVO.getShipmentId() != null, WmsPalletDO::getShipmentId, pageReqVO.getShipmentId());
        wrapper.eq(StrUtil.isNotBlank(pageReqVO.getPalletStatus()), WmsPalletDO::getPalletStatus, pageReqVO.getPalletStatus());
        wrapper.and(StrUtil.isNotBlank(pageReqVO.getKeyword()), w -> w
            .like(WmsPalletDO::getPalletNo, pageReqVO.getKeyword())
            .or().like(WmsPalletDO::getCargoOrderNo, pageReqVO.getKeyword())
            .or().like(WmsPalletDO::getShipmentCode, pageReqVO.getKeyword()));
        wrapper.orderByDesc(WmsPalletDO::getUpdateTime);` },
  { pkg: 'inventorylock', entity: 'WmsInventoryLockDO', pageVo: 'WmsInventoryLockPageReqVO', wrapper: `
        wrapper.eq(pageReqVO.getWarehouseId() != null, WmsInventoryLockDO::getWarehouseId, pageReqVO.getWarehouseId());
        wrapper.eq(pageReqVO.getShipmentId() != null, WmsInventoryLockDO::getShipmentId, pageReqVO.getShipmentId());
        wrapper.eq(pageReqVO.getPalletId() != null, WmsInventoryLockDO::getPalletId, pageReqVO.getPalletId());
        wrapper.eq(StrUtil.isNotBlank(pageReqVO.getBizDocType()), WmsInventoryLockDO::getBizDocType, pageReqVO.getBizDocType());
        wrapper.eq(StrUtil.isNotBlank(pageReqVO.getLockStatus()), WmsInventoryLockDO::getLockStatus, pageReqVO.getLockStatus());
        wrapper.and(StrUtil.isNotBlank(pageReqVO.getKeyword()), w -> w
            .like(WmsInventoryLockDO::getPalletNo, pageReqVO.getKeyword())
            .or().like(WmsInventoryLockDO::getShipmentCode, pageReqVO.getKeyword()));
        wrapper.orderByDesc(WmsInventoryLockDO::getLockTime);` },
  { pkg: 'inventorytransaction', entity: 'WmsInventoryTransactionDO', pageVo: 'WmsInventoryTransactionPageReqVO', wrapper: `
        wrapper.eq(pageReqVO.getWarehouseId() != null, WmsInventoryTransactionDO::getWarehouseId, pageReqVO.getWarehouseId());
        wrapper.eq(pageReqVO.getShipmentId() != null, WmsInventoryTransactionDO::getShipmentId, pageReqVO.getShipmentId());
        wrapper.eq(pageReqVO.getPalletId() != null, WmsInventoryTransactionDO::getPalletId, pageReqVO.getPalletId());
        wrapper.eq(StrUtil.isNotBlank(pageReqVO.getTransactionType()), WmsInventoryTransactionDO::getTransactionType, pageReqVO.getTransactionType());
        wrapper.eq(StrUtil.isNotBlank(pageReqVO.getBizDocType()), WmsInventoryTransactionDO::getBizDocType, pageReqVO.getBizDocType());
        wrapper.and(StrUtil.isNotBlank(pageReqVO.getKeyword()), w -> w
            .like(WmsInventoryTransactionDO::getTransactionNo, pageReqVO.getKeyword())
            .or().like(WmsInventoryTransactionDO::getPalletNo, pageReqVO.getKeyword())
            .or().like(WmsInventoryTransactionDO::getShipmentCode, pageReqVO.getKeyword()));
        wrapper.orderByDesc(WmsInventoryTransactionDO::getOperateTime);` },
  { pkg: 'devanningorder', entity: 'WmsDevanningOrderDO', pageVo: 'WmsDevanningOrderPageReqVO', wrapper: `
        if (StrUtil.isNotBlank(pageReqVO.getKeyword())) {
            wrapper.and(w -> w.like(WmsDevanningOrderDO::getDevanningNo, pageReqVO.getKeyword())
                .or().like(WmsDevanningOrderDO::getContainerNo, pageReqVO.getKeyword())
                .or().like(WmsDevanningOrderDO::getSourceOrderNo, pageReqVO.getKeyword())
                .or().like(WmsDevanningOrderDO::getCustomerName, pageReqVO.getKeyword()));
        }
        wrapper.like(StrUtil.isNotBlank(pageReqVO.getDevanningNo()), WmsDevanningOrderDO::getDevanningNo, pageReqVO.getDevanningNo());
        wrapper.like(StrUtil.isNotBlank(pageReqVO.getContainerNo()), WmsDevanningOrderDO::getContainerNo, pageReqVO.getContainerNo());
        wrapper.eq(StrUtil.isNotBlank(pageReqVO.getStatus()), WmsDevanningOrderDO::getStatus, pageReqVO.getStatus());
        wrapper.eq(pageReqVO.getWarehouseId() != null, WmsDevanningOrderDO::getWarehouseId, pageReqVO.getWarehouseId());
        wrapper.eq(pageReqVO.getChannelId() != null, WmsDevanningOrderDO::getChannelId, pageReqVO.getChannelId());
        wrapper.eq(pageReqVO.getCustomerServiceId() != null, WmsDevanningOrderDO::getCustomerServiceId, pageReqVO.getCustomerServiceId());
        wrapper.ge(pageReqVO.getEtaBegin() != null, WmsDevanningOrderDO::getEtaWarehouseTime, pageReqVO.getEtaBegin());
        wrapper.le(pageReqVO.getEtaEnd() != null, WmsDevanningOrderDO::getEtaWarehouseTime, pageReqVO.getEtaEnd());
        wrapper.ge(pageReqVO.getArrivalBegin() != null, WmsDevanningOrderDO::getActualArrivalTime, pageReqVO.getArrivalBegin());
        wrapper.le(pageReqVO.getArrivalEnd() != null, WmsDevanningOrderDO::getActualArrivalTime, pageReqVO.getArrivalEnd());
        wrapper.ge(pageReqVO.getFinishBegin() != null, WmsDevanningOrderDO::getDevanningFinishTime, pageReqVO.getFinishBegin());
        wrapper.le(pageReqVO.getFinishEnd() != null, WmsDevanningOrderDO::getDevanningFinishTime, pageReqVO.getFinishEnd());
        wrapper.orderByDesc(WmsDevanningOrderDO::getCreateTime);` },
];

for (const m of mappers) {
  const name = m.entity.replace('DO', 'Mapper');
  const content = `package ${PKG}.dal.mysql.${m.pkg};

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import ${PKG}.controller.admin.${m.pkg === 'inventorylock' || m.pkg === 'inventorytransaction' || m.pkg === 'pallet' ? 'inventory' : m.pkg}.vo.${m.pageVo};
import ${PKG}.dal.dataobject.${m.pkg}.${m.entity};
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ${name} extends BaseMapperX<${m.entity}> {

    default PageResult<${m.entity}> selectPage(${m.pageVo} pageReqVO) {
        LambdaQueryWrapperX<${m.entity}> wrapper = new LambdaQueryWrapperX<>();
        ${m.wrapper}
        return selectPage(pageReqVO, wrapper);
    }

}
`;
  const p = path.join(out, `dal/mysql/${m.pkg}/${name}.java`);
  fs.mkdirSync(path.dirname(p), { recursive: true });
  fs.writeFileSync(p, content, 'utf8');
}

// Simple mappers without page
for (const [pkg, entity] of [['palletitem', 'WmsPalletItemDO'], ['devanningorder', 'WmsDevanningOrderTraceDO']]) {
  const name = entity.replace('DO', 'Mapper');
  const content = `package ${PKG}.dal.mysql.${pkg};

import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import ${PKG}.dal.dataobject.${pkg}.${entity};
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ${name} extends BaseMapperX<${entity}> {
}
`;
  const p = path.join(out, `dal/mysql/${pkg}/${name}.java`);
  fs.mkdirSync(path.dirname(p), { recursive: true });
  fs.writeFileSync(p, content, 'utf8');
}

console.log('Mappers done');
