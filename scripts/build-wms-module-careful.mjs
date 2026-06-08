/** Careful WMS module builder: maps each reference file to Yudao path with controlled transforms. */
import fs from 'node:fs';
import path from 'node:path';

const root = path.resolve(import.meta.dirname, '..');
const ref = path.resolve(root, '../../WMSProject/overallSystem/WMSRuoYi-Vue-Plus/ruoyi-modules/ruoyi-wms/src/main/java/org/dromara/wms');
const out = path.join(root, 'yudao-module-wms/src/main/java/cn/iocoder/yudao/module/wms');

const PKG = 'cn.iocoder.yudao.module.wms';

function wr(rel, content) {
  const p = path.join(out, rel);
  fs.mkdirSync(path.dirname(p), { recursive: true });
  fs.writeFileSync(p, content, 'utf8');
  return rel;
}

function doTpl(table, seq, cls, fields) {
  return `package ${PKG}.dal.dataobject.${table};

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;

${fields.includes('Version') ? "import com.baomidou.mybatisplus.annotation.Version;\n" : ''}${fields.includes('Date') ? 'import java.util.Date;\n' : ''}${fields.includes('BigDecimal') ? 'import java.math.BigDecimal;\n' : ''}
@TableName("${table.replace(/([A-Z])/g, m => '_' + m.toLowerCase()).replace(/^_/, 'wms_')}")
@KeySequence("${seq}")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ${cls} extends TenantBaseDO {
${fields}
}
`;
}

// --- DO entities (from reference fields) ---
const dos = [
  ['zone', 'WmsZoneDO', 'wms_zone_seq', `    @TableId\n    private Long id;\n    private Long companyId;\n    private Long warehouseId;\n    private String warehouseCode;\n    private String warehouseName;\n    private String zoneName;\n    private String storageMethod;\n    private String zoneType;\n    private Integer allowMixedStorage;\n    private Integer maxMixedQty;\n    private String status;\n    private String remark;\n`],
  ['location', 'WmsLocationDO', 'wms_location_seq', `    @TableId\n    private Long id;\n    private Long companyId;\n    private Long warehouseId;\n    private String warehouseCode;\n    private String warehouseName;\n    private Long zoneId;\n    private String zoneName;\n    private String locationCode;\n    private String rowNo;\n    private String columnNo;\n    private Integer capacity;\n    private Integer currentQty;\n    private Integer remainingCapacity;\n    private String status;\n    private String remark;\n`],
  ['inventory', 'WmsInventoryDO', 'wms_inventory_seq', `    @TableId\n    private Long id;\n    private Long companyId;\n    private Long warehouseId;\n    private String warehouseCode;\n    private String warehouseName;\n    private Long customerId;\n    private String customerName;\n    private Long cargoOrderId;\n    private String cargoOrderNo;\n    private Long shipmentId;\n    private String shipmentCode;\n    private Integer totalBoxQty;\n    private Integer availableBoxQty;\n    private Integer lockedBoxQty;\n    private Integer exceptionBoxQty;\n    private BigDecimal totalWeight;\n    private BigDecimal totalCbm;\n    private String inventoryStatus;\n    private String remark;\n    @Version\n    private Integer version;\n`, 'BigDecimal'],
  ['pallet', 'WmsPalletDO', 'wms_pallet_seq', `    @TableId\n    private Long id;\n    private Long companyId;\n    private Long warehouseId;\n    private String warehouseCode;\n    private String warehouseName;\n    private String palletNo;\n    private String palletType;\n    private String businessTypeName;\n    private String containerNo;\n    private String groupDestination;\n    private Long cargoOrderId;\n    private String cargoOrderNo;\n    private Long shipmentId;\n    private String shipmentCode;\n    private Long zoneId;\n    private String zoneCode;\n    private String zoneName;\n    private Long locationId;\n    private String locationCode;\n    private Integer totalBoxQty;\n    private Integer availableBoxQty;\n    private Integer lockedBoxQty;\n    private Integer exceptionBoxQty;\n    private BigDecimal weight;\n    private BigDecimal cbm;\n    private String palletStatus;\n    private Date inboundTime;\n    private String remark;\n    @Version\n    private Integer version;\n`, 'BigDecimal,Date'],
  ['palletitem', 'WmsPalletItemDO', 'wms_pallet_item_seq', `    @TableId\n    private Long id;\n    private Long companyId;\n    private Long warehouseId;\n    private Long palletId;\n    private String palletNo;\n    private Long cargoOrderId;\n    private String cargoOrderNo;\n    private String businessTypeName;\n    private String containerNo;\n    private String groupDestination;\n    private String platformName;\n    private String platformWarehouseCode;\n    private String addressType;\n    private Integer holdFlag;\n    private Long shipmentId;\n    private String shipmentCode;\n    private String poNo;\n    private String shippingMark;\n    private Integer boxQty;\n    private Integer availableBoxQty;\n    private Integer lockedBoxQty;\n    private Integer exceptionBoxQty;\n    private BigDecimal weight;\n    private BigDecimal cbm;\n    private String remark;\n`, 'BigDecimal'],
  ['inventorylock', 'WmsInventoryLockDO', 'wms_inventory_lock_seq', `    @TableId\n    private Long id;\n    private Long companyId;\n    private Long warehouseId;\n    private String bizDocType;\n    private Long bizDocId;\n    private Long bizDocLineId;\n    private Long shipmentId;\n    private String shipmentCode;\n    private Long palletId;\n    private String palletNo;\n    private Long palletItemId;\n    private Integer lockedBoxQty;\n    private String lockStatus;\n    private Date lockTime;\n    private Date releaseTime;\n    private String remark;\n`, 'Date'],
  ['inventorytransaction', 'WmsInventoryTransactionDO', 'wms_inventory_transaction_seq', `    @TableId\n    private Long id;\n    private Long companyId;\n    private Long warehouseId;\n    private String transactionNo;\n    private String transactionType;\n    private Long customerId;\n    private String customerName;\n    private Long cargoOrderId;\n    private String cargoOrderNo;\n    private Long shipmentId;\n    private String shipmentCode;\n    private Long palletId;\n    private String palletNo;\n    private Long palletItemId;\n    private Long fromLocationId;\n    private String fromLocationCode;\n    private Long toLocationId;\n    private String toLocationCode;\n    private Integer changeTotal;\n    private Integer changeAvailable;\n    private Integer changeLocked;\n    private Integer changeException;\n    private String bizDocType;\n    private Long bizDocId;\n    private Long bizDocLineId;\n    private Long operatorId;\n    private String operatorName;\n    private Date operateTime;\n    private String remark;\n`, 'Date'],
  ['devanningorder', 'WmsDevanningOrderDO', 'wms_devanning_order_seq', `    @TableId\n    private Long id;\n    private Long companyId;\n    private Long warehouseId;\n    private Long bizRootId;\n    private String devanningNo;\n    private Long sourceOrderId;\n    private String sourceOrderNo;\n    private String sourceOrderType;\n    private String containerNo;\n    private Long customerId;\n    private String customerName;\n    private Long channelId;\n    private String channelName;\n    private Long customerServiceId;\n    private String customerServiceName;\n    private Date etaWarehouseTime;\n    private Date pickupTime;\n    private Date actualArrivalTime;\n    private Date plannedDevanningTime;\n    private Date devanningStartTime;\n    private Date devanningFinishTime;\n    private Long dockId;\n    private String dockCode;\n    private Date dockAssignTime;\n    private String devanningMethod;\n    private String devanningRemark;\n    private Integer plannedTruckQty;\n    private BigDecimal plannedCbm;\n    private BigDecimal totalBoxQty;\n    private BigDecimal totalWeight;\n    private BigDecimal totalCbm;\n    private BigDecimal inboundedBoxQty;\n    private Integer exceptionFlag;\n    private Integer exceptionCount;\n    private String attachmentUrls;\n    private String status;\n    @Version\n    private Integer version;\n    private String remark;\n`, 'BigDecimal,Date'],
];

const created = [];
for (const row of dos) {
  const [pkg, cls, seq, body, extra = ''] = row;
  const table = pkg === 'palletitem' ? 'wms_pallet_item' : pkg === 'inventorylock' ? 'wms_inventory_lock' : pkg === 'inventorytransaction' ? 'wms_inventory_transaction' : pkg === 'devanningorder' ? 'wms_devanning_order' : `wms_${pkg}`;
  let imports = '';
  if (extra.includes('BigDecimal')) imports += 'import java.math.BigDecimal;\n';
  if (extra.includes('Date')) imports += 'import java.util.Date;\n';
  if (body.includes('@Version')) imports += 'import com.baomidou.mybatisplus.annotation.Version;\n';
  const content = `package ${PKG}.dal.dataobject.${pkg};\n\nimport cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;\nimport com.baomidou.mybatisplus.annotation.KeySequence;\nimport com.baomidou.mybatisplus.annotation.TableId;\nimport com.baomidou.mybatisplus.annotation.TableName;\nimport lombok.*;\n${imports}\n@TableName("${table}")\n@KeySequence("${seq}")\n@Data\n@EqualsAndHashCode(callSuper = true)\n@ToString(callSuper = true)\n@Builder\n@NoArgsConstructor\n@AllArgsConstructor\npublic class ${cls} extends TenantBaseDO {\n${body}}\n`;
  created.push(wr(`dal/dataobject/${pkg}/${cls}.java`, content));
}

created.push(wr('dal/dataobject/devanningorder/WmsDevanningOrderTraceDO.java', `package ${PKG}.dal.dataobject.devanningorder;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;
import java.util.Date;

@TableName("wms_devanning_order_trace")
@KeySequence("wms_devanning_order_trace_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WmsDevanningOrderTraceDO extends TenantBaseDO {
    @TableId
    private Long id;
    private Long devanningOrderId;
    private String actionType;
    private String beforeStatus;
    private String afterStatus;
    private String actionContent;
    private Long operatorId;
    private String operatorName;
    private Date actionTime;
}
`));

function transformImpl(src) {
  let c = fs.readFileSync(src, 'utf8');
  c = c.replace(/^package org\.dromara\.wms\.service\.impl;/m, `package ${PKG}.service.${path.basename(src).replace('Wms', '').replace('ServiceImpl.java', '').toLowerCase().replace('zone', 'zone').replace('inventory', 'inventory').replace('location', 'location').replace('devanningorder', 'devanningorder')};`);
  // fix package per file later
  return c;
}

console.log('Created', created.length, 'DO files');
