package cn.iocoder.yudao.module.wms.service.inventory;

import cn.hutool.core.util.IdUtil;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.wms.controller.admin.inventory.vo.*;
import cn.iocoder.yudao.module.wms.dal.dataobject.inventory.WmsInventoryDO;
import cn.iocoder.yudao.module.wms.dal.dataobject.inventorylock.WmsInventoryLockDO;
import cn.iocoder.yudao.module.wms.dal.dataobject.inventorytransaction.WmsInventoryTransactionDO;
import cn.iocoder.yudao.module.wms.dal.dataobject.location.WmsLocationDO;
import cn.iocoder.yudao.module.wms.dal.dataobject.pallet.WmsPalletDO;
import cn.iocoder.yudao.module.wms.dal.dataobject.zone.WmsZoneDO;
import cn.iocoder.yudao.module.wms.dal.dataobject.palletitem.WmsPalletItemDO;
import cn.iocoder.yudao.module.wms.controller.admin.inventory.vo.WmsInventoryAdjustReqVO;
import cn.iocoder.yudao.module.wms.controller.admin.inventory.vo.WmsInventoryLockReqVO;
import cn.iocoder.yudao.module.wms.controller.admin.inventory.vo.WmsInventoryLockPageReqVO;
import cn.iocoder.yudao.module.wms.controller.admin.inventory.vo.WmsInventoryPageReqVO;
import cn.iocoder.yudao.module.wms.controller.admin.inventory.vo.WmsInventoryReceiveReqVO;
import cn.iocoder.yudao.module.wms.controller.admin.inventory.vo.WmsInventoryVisualizationReqVO;
import cn.iocoder.yudao.module.wms.controller.admin.inventory.vo.WmsInventoryTransactionPageReqVO;
import cn.iocoder.yudao.module.wms.controller.admin.inventory.vo.WmsPalletMoveReqVO;
import cn.iocoder.yudao.module.wms.controller.admin.inventory.vo.WmsPalletOutboundReqVO;
import cn.iocoder.yudao.module.wms.controller.admin.inventory.vo.WmsPalletPageReqVO;
import cn.iocoder.yudao.module.wms.dal.mysql.location.WmsLocationMapper;
import cn.iocoder.yudao.module.wms.controller.admin.inventory.vo.WmsInventoryLockRespVO;
import cn.iocoder.yudao.module.wms.controller.admin.inventory.vo.WmsInventoryStatsRespVO;
import cn.iocoder.yudao.module.wms.controller.admin.inventory.vo.WmsInventoryTransactionRespVO;
import cn.iocoder.yudao.module.wms.controller.admin.inventory.vo.WmsInventoryVisualizationRespVO;
import cn.iocoder.yudao.module.wms.controller.admin.inventory.vo.WmsInventoryRespVO;
import cn.iocoder.yudao.module.wms.controller.admin.inventory.vo.WmsLocationDestinationStatRespVO;
import cn.iocoder.yudao.module.wms.controller.admin.inventory.vo.WmsLocationVisualizationRespVO;
import cn.iocoder.yudao.module.wms.controller.admin.inventory.vo.WmsZoneVisualizationRespVO;
import cn.iocoder.yudao.module.wms.controller.admin.inventory.vo.WmsPalletItemRespVO;
import cn.iocoder.yudao.module.wms.controller.admin.inventory.vo.WmsPalletRespVO;
import cn.iocoder.yudao.module.wms.dal.mysql.inventorylock.WmsInventoryLockMapper;
import cn.iocoder.yudao.module.wms.dal.mysql.inventory.WmsInventoryMapper;
import cn.iocoder.yudao.module.wms.dal.mysql.inventorytransaction.WmsInventoryTransactionMapper;
import cn.iocoder.yudao.module.wms.dal.mysql.palletitem.WmsPalletItemMapper;
import cn.iocoder.yudao.module.wms.dal.mysql.pallet.WmsPalletMapper;
import cn.iocoder.yudao.module.wms.dal.mysql.zone.WmsZoneMapper;
import cn.iocoder.yudao.module.wms.service.inventory.WmsInventoryService;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder.CargoOrderDO;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder.CargoOrderShipmentDO;
import cn.iocoder.yudao.module.oms.dal.mysql.cargoorder.CargoOrderMapper;
import cn.iocoder.yudao.module.oms.dal.mysql.cargoorder.CargoOrderShipmentMapper;
import cn.iocoder.yudao.module.org.framework.datapermission.annotation.OrgDataScope;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.wms.enums.ErrorCodeConstants.*;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Date;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@Validated
public class WmsInventoryServiceImpl implements WmsInventoryService {

    private static final String STATUS_IN_STOCK = "IN_STOCK";
    private static final String STATUS_DEPLETED = "DEPLETED";
    private static final String PALLET_IN_STOCK = "IN_STOCK";
    private static final String PALLET_PRE_OUTBOUND = "PRE_OUTBOUND";
    private static final String PALLET_HOLD = "HOLD";
    private static final String PALLET_OUTBOUND = "OUTBOUND";
    private static final String PALLET_TYPE_NORMAL = "NORMAL";
    private static final String LOCKED = "LOCKED";

    @Resource
    private WmsInventoryMapper inventoryMapper;
    @Resource
    private WmsPalletMapper palletMapper;
    @Resource
    private WmsPalletItemMapper palletItemMapper;
    @Resource
    private WmsLocationMapper locationMapper;
    @Resource
    private WmsZoneMapper zoneMapper;
    @Resource
    private WmsInventoryLockMapper lockMapper;
    @Resource
    private WmsInventoryTransactionMapper transactionMapper;
    @Resource
    private CargoOrderMapper cargoOrderMapper;
    @Resource
    private CargoOrderShipmentMapper cargoOrderShipmentMapper;

    @Override
    @OrgDataScope(tableClass = WmsInventoryDO.class, warehouseColumn = "warehouse_id")
    public PageResult<WmsInventoryRespVO> getInventoryPage(WmsInventoryPageReqVO pageReqVO) {
        PageResult<WmsInventoryDO> page = inventoryMapper.selectPage(pageReqVO);
        return new PageResult<>(BeanUtils.toBean(page.getList(), WmsInventoryRespVO.class), page.getTotal());
    }

    @Override
    @OrgDataScope(tableClass = WmsInventoryDO.class, warehouseColumn = "warehouse_id")
    public WmsInventoryRespVO getInventory(Long id) {
        WmsInventoryDO row = inventoryMapper.selectById(id);
        return row == null ? null : BeanUtils.toBean(row, WmsInventoryRespVO.class);
    }

    @Override
    @OrgDataScope(tableClass = WmsInventoryDO.class, warehouseColumn = "warehouse_id")
    public WmsInventoryStatsRespVO getInventoryStats(WmsInventoryPageReqVO pageReqVO) {
        List<WmsInventoryDO> inventories = inventoryMapper.selectList(inventoryMapper.buildWrapper(pageReqVO));
        WmsInventoryStatsRespVO stats = new WmsInventoryStatsRespVO();
        stats.setInventoryCount((long) inventories.size());
        stats.setTotalBoxQty(sumInt(inventories.stream().map(WmsInventoryDO::getTotalBoxQty).toList()));
        stats.setAvailableBoxQty(sumInt(inventories.stream().map(WmsInventoryDO::getAvailableBoxQty).toList()));
        stats.setLockedBoxQty(sumInt(inventories.stream().map(WmsInventoryDO::getLockedBoxQty).toList()));
        stats.setExceptionBoxQty(sumInt(inventories.stream().map(WmsInventoryDO::getExceptionBoxQty).toList()));
        stats.setTotalWeight(sumDecimal(inventories.stream().map(WmsInventoryDO::getTotalWeight).toList()));
        stats.setTotalCbm(sumDecimal(inventories.stream().map(WmsInventoryDO::getTotalCbm).toList()));
        LambdaQueryWrapperX<WmsPalletDO> palletCountLqw = new LambdaQueryWrapperX<WmsPalletDO>()
                .eqIfPresent(WmsPalletDO::getWarehouseId, pageReqVO.getWarehouseId());
        if (!Boolean.TRUE.equals(pageReqVO.getIncludeDepleted())) {
            palletCountLqw.gt(WmsPalletDO::getTotalBoxQty, 0)
                .ne(WmsPalletDO::getPalletStatus, PALLET_OUTBOUND);
        }
        Long palletCount = palletMapper.selectCount(palletCountLqw);
        stats.setPalletCount(palletCount == null ? 0L : palletCount);
        return stats;
    }

    @Override
    @OrgDataScope(tableClass = WmsPalletDO.class, warehouseColumn = "warehouse_id")
    public PageResult<WmsPalletRespVO> getPalletPage(WmsPalletPageReqVO pageReqVO) {
        PageResult<WmsPalletDO> page = palletMapper.selectPage(pageReqVO);
        List<WmsPalletRespVO> list = BeanUtils.toBean(page.getList(), WmsPalletRespVO.class);
        enrichPalletList(list);
        return new PageResult<>(list, page.getTotal());
    }

    private void enrichPalletList(List<WmsPalletRespVO> records) {
        if (records == null || records.isEmpty()) {
            return;
        }
        List<Long> palletIds = records.stream().map(WmsPalletRespVO::getId).toList();
        List<WmsPalletItemDO> items = palletItemMapper.selectList(Wrappers.<WmsPalletItemDO>lambdaQuery()
            .in(WmsPalletItemDO::getPalletId, palletIds));
        syncOmsFieldsToItems(items);
        Map<Long, List<WmsPalletItemDO>> itemMap = items.stream().collect(Collectors.groupingBy(WmsPalletItemDO::getPalletId));
        for (WmsPalletRespVO vo : records) {
            List<WmsPalletItemDO> palletItems = itemMap.getOrDefault(vo.getId(), List.of());
            vo.setOrderCount((int) palletItems.stream().map(WmsPalletItemDO::getCargoOrderId).filter(Objects::nonNull).distinct().count());
            vo.setShipmentCount((int) palletItems.stream().map(WmsPalletItemDO::getShipmentId).filter(Objects::nonNull).distinct().count());
            vo.setBusinessTypeName(joinDistinct(palletItems.stream().map(WmsPalletItemDO::getBusinessTypeName).toList()));
            vo.setContainerNo(joinDistinct(palletItems.stream().map(WmsPalletItemDO::getContainerNo).toList()));
            vo.setGroupDestination(joinDistinct(palletItems.stream().map(WmsPalletItemDO::getGroupDestination).toList()));
            if (StrUtil.isBlank(vo.getPalletType())) {
                vo.setPalletType(PALLET_TYPE_NORMAL);
            }
            String resolved = resolvePalletStatus(vo.getPalletStatus(), palletItems);
            if (!Objects.equals(resolved, vo.getPalletStatus())) {
                WmsPalletDO statusUpdate = new WmsPalletDO();
                statusUpdate.setId(vo.getId());
                statusUpdate.setPalletStatus(resolved);
                palletMapper.updateById(statusUpdate);
                vo.setPalletStatus(resolved);
            }
        }
    }

    @Override
    public List<WmsPalletItemRespVO> getPalletItems(Long palletId) {
        List<WmsPalletItemDO> items = palletItemMapper.selectList(Wrappers.<WmsPalletItemDO>lambdaQuery()
                .eq(WmsPalletItemDO::getPalletId, palletId)
                .orderByAsc(WmsPalletItemDO::getCargoOrderNo)
                .orderByAsc(WmsPalletItemDO::getShipmentCode));
        syncOmsFieldsToItems(items);
        refreshPalletStatusAfterSync(palletId);
        return BeanUtils.toBean(items, WmsPalletItemRespVO.class);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void movePalletLocation(WmsPalletMoveReqVO reqVO) {
        WmsPalletDO pallet = palletMapper.selectById(reqVO.getPalletId());
        if (pallet == null) {
            throw exception(WMS_PALLET_NOT_EXISTS);
        }
        if (PALLET_OUTBOUND.equals(pallet.getPalletStatus())) {
            throw exception(WMS_BIZ_ERROR, "???????????????????");
        }
        if (PALLET_HOLD.equals(pallet.getPalletStatus())) {
            throw exception(WMS_BIZ_ERROR, "?????? HOLD ??????????????");
        }
        WmsLocationDO location = locationMapper.selectById(reqVO.getLocationId());
        if (location == null) {
            throw exception(WMS_BIZ_ERROR, "???????????");
        }
        Long fromLocationId = pallet.getLocationId();
        String fromLocationCode = pallet.getLocationCode();
        WmsPalletDO update = new WmsPalletDO();
        update.setId(pallet.getId());
        update.setLocationId(location.getId());
        update.setLocationCode(location.getLocationCode());
        update.setZoneId(location.getZoneId());
        update.setZoneName(location.getZoneName());
        if (StrUtil.isBlank(pallet.getPalletStatus()) || "CREATED".equals(pallet.getPalletStatus()) || "PUTAWAY".equals(pallet.getPalletStatus())) {
            update.setPalletStatus(PALLET_IN_STOCK);
        }
        palletMapper.updateById(update);
        refreshPalletStatusAfterSync(pallet.getId());

        List<WmsPalletItemDO> items = palletItemMapper.selectList(Wrappers.<WmsPalletItemDO>lambdaQuery().eq(WmsPalletItemDO::getPalletId, pallet.getId()));
        if (!items.isEmpty()) {
            WmsPalletItemDO first = items.get(0);
            WmsInventoryTransactionDO tx = baseTransaction("MOVE", first);
            tx.setFromLocationId(fromLocationId);
            tx.setFromLocationCode(fromLocationCode);
            tx.setToLocationId(location.getId());
            tx.setToLocationCode(location.getLocationCode());
            tx.setRemark(reqVO.getRemark());
            transactionMapper.insert(tx);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void outboundPallet(WmsPalletOutboundReqVO reqVO) {
        WmsPalletDO pallet = palletMapper.selectById(reqVO.getPalletId());
        if (pallet == null) {
            throw exception(WMS_PALLET_NOT_EXISTS);
        }
        if (PALLET_OUTBOUND.equals(pallet.getPalletStatus())) {
            throw exception(WMS_BIZ_ERROR, "?????????");
        }
        if (PALLET_HOLD.equals(pallet.getPalletStatus())) {
            throw exception(WMS_BIZ_ERROR, "?????? HOLD ???????????");
        }
        if (nvl(pallet.getLockedBoxQty()) > 0) {
            throw exception(WMS_BIZ_ERROR, "?????????????????????");
        }
        WmsPalletDO statusUpdate = new WmsPalletDO();
        statusUpdate.setId(pallet.getId());
        statusUpdate.setPalletStatus(PALLET_OUTBOUND);
        palletMapper.updateById(statusUpdate);

        List<WmsPalletItemDO> items = palletItemMapper.selectList(Wrappers.<WmsPalletItemDO>lambdaQuery().eq(WmsPalletItemDO::getPalletId, pallet.getId()));
        for (WmsPalletItemDO item : items) {
            int available = nvl(item.getAvailableBoxQty());
            if (available <= 0) {
                continue;
            }
            item.setAvailableBoxQty(0);
            palletItemMapper.updateById(item);
            WmsInventoryTransactionDO tx = baseTransaction("OUTBOUND", item);
            tx.setFromLocationId(pallet.getLocationId());
            tx.setFromLocationCode(pallet.getLocationCode());
            tx.setChangeTotal(-available);
            tx.setChangeAvailable(-available);
            tx.setRemark(reqVO.getRemark());
            transactionMapper.insert(tx);
            rollupInventory(item.getWarehouseId(), item.getShipmentId());
        }
        rollupPallet(pallet.getId());
    }

    @Override
    public PageResult<WmsInventoryLockRespVO> getLockPage(WmsInventoryLockPageReqVO pageReqVO) {
        PageResult<WmsInventoryLockDO> page = lockMapper.selectPage(pageReqVO);
        return new PageResult<>(BeanUtils.toBean(page.getList(), WmsInventoryLockRespVO.class), page.getTotal());
    }

    @Override
    public PageResult<WmsInventoryTransactionRespVO> getTransactionPage(WmsInventoryTransactionPageReqVO pageReqVO) {
        PageResult<WmsInventoryTransactionDO> page = transactionMapper.selectPage(pageReqVO);
        return new PageResult<>(BeanUtils.toBean(page.getList(), WmsInventoryTransactionRespVO.class), page.getTotal());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void receive(WmsInventoryReceiveReqVO reqVO) {
        WmsPalletDO pallet = palletMapper.selectOne(Wrappers.<WmsPalletDO>lambdaQuery()
            .eq(WmsPalletDO::getWarehouseId, reqVO.getWarehouseId())
            .eq(WmsPalletDO::getPalletNo, reqVO.getPalletNo())
            .last("limit 1"));
        if (pallet == null) {
            pallet = new WmsPalletDO();
            pallet.setCompanyId(reqVO.getCompanyId());
            pallet.setWarehouseId(reqVO.getWarehouseId());
            pallet.setWarehouseCode(reqVO.getWarehouseCode());
            pallet.setWarehouseName(reqVO.getWarehouseName());
            pallet.setPalletNo(reqVO.getPalletNo());
            pallet.setCargoOrderId(reqVO.getCargoOrderId());
            pallet.setCargoOrderNo(reqVO.getCargoOrderNo());
            pallet.setShipmentId(reqVO.getShipmentId());
            pallet.setShipmentCode(reqVO.getShipmentCode());
            pallet.setZoneId(reqVO.getZoneId());
            pallet.setZoneCode(reqVO.getZoneCode());
            pallet.setZoneName(reqVO.getZoneName());
            pallet.setLocationId(reqVO.getLocationId());
            pallet.setLocationCode(reqVO.getLocationCode());
            pallet.setPalletType(PALLET_TYPE_NORMAL);
            pallet.setPalletStatus(PALLET_IN_STOCK);
            pallet.setInboundTime(new Date());
            pallet.setVersion(0);
            palletMapper.insert(pallet);
        }

        WmsPalletItemDO item = palletItemMapper.selectOne(Wrappers.<WmsPalletItemDO>lambdaQuery()
            .eq(WmsPalletItemDO::getPalletId, pallet.getId())
            .eq(WmsPalletItemDO::getCargoOrderId, reqVO.getCargoOrderId())
            .eq(WmsPalletItemDO::getShipmentId, reqVO.getShipmentId())
            .last("limit 1"));
        if (item == null) {
            item = new WmsPalletItemDO();
            item.setCompanyId(reqVO.getCompanyId());
            item.setWarehouseId(reqVO.getWarehouseId());
            item.setPalletId(pallet.getId());
            item.setPalletNo(pallet.getPalletNo());
            item.setCargoOrderId(reqVO.getCargoOrderId());
            item.setCargoOrderNo(reqVO.getCargoOrderNo());
            item.setShipmentId(reqVO.getShipmentId());
            item.setShipmentCode(reqVO.getShipmentCode());
            item.setBoxQty(0);
            item.setAvailableBoxQty(0);
            item.setLockedBoxQty(0);
            item.setExceptionBoxQty(0);
            item.setWeight(BigDecimal.ZERO);
            item.setCbm(BigDecimal.ZERO);
            palletItemMapper.insert(item);
        }
        syncOmsFieldsToItem(item);
        item.setBoxQty(nvl(item.getBoxQty()) + reqVO.getBoxQty());
        item.setAvailableBoxQty(nvl(item.getAvailableBoxQty()) + reqVO.getBoxQty());
        item.setWeight(nvl(item.getWeight()).add(nvl(reqVO.getWeight())));
        item.setCbm(nvl(item.getCbm()).add(nvl(reqVO.getCbm())));
        palletItemMapper.updateById(item);

        saveTransaction("RECEIVE", reqVO, pallet, item, reqVO.getBoxQty(), reqVO.getBoxQty(), 0, 0);
        rollupPallet(pallet.getId());
        rollupInventory(reqVO.getWarehouseId(), reqVO.getShipmentId());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void lock(WmsInventoryLockReqVO reqVO) {
        List<WmsPalletItemDO> items = palletItemMapper.selectList(Wrappers.<WmsPalletItemDO>lambdaQuery()
            .eq(WmsPalletItemDO::getWarehouseId, reqVO.getWarehouseId())
            .eq(WmsPalletItemDO::getShipmentId, reqVO.getShipmentId())
            .gt(WmsPalletItemDO::getAvailableBoxQty, 0)
            .orderByAsc(WmsPalletItemDO::getCreateTime));
        int remain = reqVO.getBoxQty();
        Set<Long> palletIds = new HashSet<>();
        for (WmsPalletItemDO item : items) {
            if (remain <= 0) break;
            int allocate = Math.min(remain, nvl(item.getAvailableBoxQty()));
            item.setAvailableBoxQty(nvl(item.getAvailableBoxQty()) - allocate);
            item.setLockedBoxQty(nvl(item.getLockedBoxQty()) + allocate);
            palletItemMapper.updateById(item);

            WmsInventoryLockDO lock = new WmsInventoryLockDO();
            lock.setCompanyId(item.getCompanyId());
            lock.setWarehouseId(item.getWarehouseId());
            lock.setBizDocType(reqVO.getBizDocType());
            lock.setBizDocId(reqVO.getBizDocId());
            lock.setBizDocLineId(reqVO.getBizDocLineId());
            lock.setShipmentId(item.getShipmentId());
            lock.setShipmentCode(item.getShipmentCode());
            lock.setPalletId(item.getPalletId());
            lock.setPalletNo(item.getPalletNo());
            lock.setPalletItemId(item.getId());
            lock.setLockedBoxQty(allocate);
            lock.setLockStatus(LOCKED);
            lock.setLockTime(new Date());
            lock.setRemark(reqVO.getRemark());
            lockMapper.insert(lock);

            saveTransaction("LOCK", item, reqVO, allocate);
            palletIds.add(item.getPalletId());
            remain -= allocate;
        }
        if (remain > 0) {
            throw exception(WMS_INVENTORY_INSUFFICIENT, "????????" + remain);
        }
        for (Long palletId : palletIds) {
            rollupPallet(palletId);
        }
        rollupInventory(reqVO.getWarehouseId(), reqVO.getShipmentId());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void adjust(WmsInventoryAdjustReqVO reqVO) {
        WmsInventoryDO inventory = inventoryMapper.selectById(reqVO.getInventoryId());
        if (inventory == null) {
            throw exception(WMS_INVENTORY_NOT_EXISTS);
        }
        int deltaAvailable = reqVO.getDeltaAvailableBoxQty() == null ? 0 : reqVO.getDeltaAvailableBoxQty();
        int deltaLocked = reqVO.getDeltaLockedBoxQty() == null ? 0 : reqVO.getDeltaLockedBoxQty();
        int deltaException = reqVO.getDeltaExceptionBoxQty() == null ? 0 : reqVO.getDeltaExceptionBoxQty();
        if (deltaAvailable == 0 && deltaLocked == 0 && deltaException == 0) {
            throw exception(WMS_BIZ_ERROR, "???????????????????");
        }
        if (nvl(inventory.getAvailableBoxQty()) + deltaAvailable < 0) {
            throw exception(WMS_BIZ_ERROR, "???????????????????0");
        }
        if (nvl(inventory.getLockedBoxQty()) + deltaLocked < 0) {
            throw exception(WMS_BIZ_ERROR, "???????????????????0");
        }
        if (nvl(inventory.getExceptionBoxQty()) + deltaException < 0) {
            throw exception(WMS_BIZ_ERROR, "?????????????????0");
        }
        List<WmsPalletItemDO> items = palletItemMapper.selectList(Wrappers.<WmsPalletItemDO>lambdaQuery()
            .eq(WmsPalletItemDO::getWarehouseId, inventory.getWarehouseId())
            .eq(WmsPalletItemDO::getShipmentId, inventory.getShipmentId())
            .orderByAsc(WmsPalletItemDO::getCreateTime));
        if (items.isEmpty()) {
            throw exception(WMS_BIZ_ERROR, "??????????????????????");
        }
        Set<Long> palletIds = new HashSet<>();
        applyItemDelta(items, deltaAvailable, "available", palletIds);
        applyItemDelta(items, deltaLocked, "locked", palletIds);
        applyItemDelta(items, deltaException, "exception", palletIds);
        for (Long palletId : palletIds) {
            rollupPallet(palletId);
        }
        rollupInventory(inventory.getWarehouseId(), inventory.getShipmentId());
        WmsPalletItemDO ref = items.get(0);
        WmsInventoryTransactionDO tx = baseTransaction("ADJUST", ref);
        tx.setChangeTotal(deltaAvailable + deltaLocked + deltaException);
        tx.setChangeAvailable(deltaAvailable);
        tx.setChangeLocked(deltaLocked);
        tx.setChangeException(deltaException);
        tx.setBizDocType("ADJUST");
        tx.setRemark(reqVO.getRemark());
        transactionMapper.insert(tx);
    }

    private void applyItemDelta(List<WmsPalletItemDO> items, int delta, String field, Set<Long> palletIds) {
        if (delta == 0) {
            return;
        }
        int remain = delta;
        if (delta > 0) {
            WmsPalletItemDO item = items.get(0);
            applyFieldChange(item, field, nvl(getFieldValue(item, field)) + remain);
            palletItemMapper.updateById(item);
            palletIds.add(item.getPalletId());
            return;
        }
        for (WmsPalletItemDO item : items) {
            if (remain >= 0) {
                break;
            }
            int current = nvl(getFieldValue(item, field));
            int reduce = Math.min(current, -remain);
            if (reduce <= 0) {
                continue;
            }
            applyFieldChange(item, field, current - reduce);
            palletItemMapper.updateById(item);
            palletIds.add(item.getPalletId());
            remain += reduce;
        }
        if (remain < 0) {
            throw exception(WMS_BIZ_ERROR, "???????" + fieldLabel(field) + "?????????????");
        }
    }

    private int getFieldValue(WmsPalletItemDO item, String field) {
        return switch (field) {
            case "locked" -> item.getLockedBoxQty();
            case "exception" -> item.getExceptionBoxQty();
            default -> item.getAvailableBoxQty();
        };
    }

    private void applyFieldChange(WmsPalletItemDO item, String field, int value) {
        switch (field) {
            case "locked" -> item.setLockedBoxQty(value);
            case "exception" -> item.setExceptionBoxQty(value);
            default -> item.setAvailableBoxQty(value);
        }
        item.setBoxQty(nvl(item.getAvailableBoxQty()) + nvl(item.getLockedBoxQty()) + nvl(item.getExceptionBoxQty()));
    }

    private String fieldLabel(String field) {
        return switch (field) {
            case "locked" -> "????????";
            case "exception" -> "??????";
            default -> "????????";
        };
    }

    private void rollupPallet(Long palletId) {
        List<WmsPalletItemDO> items = palletItemMapper.selectList(Wrappers.<WmsPalletItemDO>lambdaQuery()
            .eq(WmsPalletItemDO::getPalletId, palletId));
        WmsPalletDO pallet = palletMapper.selectById(palletId);
        WmsPalletDO update = new WmsPalletDO();
        update.setId(palletId);
        update.setTotalBoxQty(sumInt(items.stream().map(WmsPalletItemDO::getBoxQty).toList()).intValue());
        update.setAvailableBoxQty(sumInt(items.stream().map(WmsPalletItemDO::getAvailableBoxQty).toList()).intValue());
        update.setLockedBoxQty(sumInt(items.stream().map(WmsPalletItemDO::getLockedBoxQty).toList()).intValue());
        update.setExceptionBoxQty(sumInt(items.stream().map(WmsPalletItemDO::getExceptionBoxQty).toList()).intValue());
        update.setWeight(sumDecimal(items.stream().map(WmsPalletItemDO::getWeight).toList()));
        update.setCbm(sumDecimal(items.stream().map(WmsPalletItemDO::getCbm).toList()));
        update.setBusinessTypeName(joinDistinct(items.stream().map(WmsPalletItemDO::getBusinessTypeName).toList()));
        update.setContainerNo(joinDistinct(items.stream().map(WmsPalletItemDO::getContainerNo).toList()));
        update.setGroupDestination(joinDistinct(items.stream().map(WmsPalletItemDO::getGroupDestination).toList()));
        if (pallet != null) {
            update.setPalletStatus(resolvePalletStatus(pallet.getPalletStatus(), items));
        }
        palletMapper.updateById(update);
    }

    private void refreshPalletStatusAfterSync(Long palletId) {
        WmsPalletDO pallet = palletMapper.selectById(palletId);
        if (pallet == null) {
            return;
        }
        List<WmsPalletItemDO> items = palletItemMapper.selectList(Wrappers.<WmsPalletItemDO>lambdaQuery()
            .eq(WmsPalletItemDO::getPalletId, palletId));
        String resolved = resolvePalletStatus(pallet.getPalletStatus(), items);
        if (!Objects.equals(resolved, pallet.getPalletStatus())) {
            WmsPalletDO statusUpdate = new WmsPalletDO();
            statusUpdate.setId(palletId);
            statusUpdate.setPalletStatus(resolved);
            palletMapper.updateById(statusUpdate);
        }
    }

    private String resolvePalletStatus(String currentStatus, List<WmsPalletItemDO> items) {
        if (PALLET_OUTBOUND.equals(currentStatus)) {
            return PALLET_OUTBOUND;
        }
        boolean anyHold = items != null && items.stream().anyMatch(i -> Integer.valueOf(1).equals(i.getHoldFlag()));
        if (anyHold) {
            return PALLET_HOLD;
        }
        if (PALLET_PRE_OUTBOUND.equals(currentStatus)) {
            return PALLET_PRE_OUTBOUND;
        }
        return PALLET_IN_STOCK;
    }

    private void syncOmsFieldsToItems(List<WmsPalletItemDO> items) {
        if (items == null || items.isEmpty()) {
            return;
        }
        for (WmsPalletItemDO item : items) {
            syncOmsFieldsToItem(item);
        }
    }

    private void syncOmsFieldsToItem(WmsPalletItemDO item) {
        if (item == null || item.getCargoOrderId() == null) {
            return;
        }
        CargoOrderDO order = cargoOrderMapper.selectById(item.getCargoOrderId());
        if (order != null) {
            item.setBusinessTypeName(order.getBusinessTypeName());
            item.setContainerNo(order.getContainerNo());
            item.setGroupDestination(order.getGroupCode());
            item.setPlatformName(order.getPlatformName());
            item.setPlatformWarehouseCode(order.getPlatformWarehouseCode());
            item.setAddressType(order.getAddressType());
            item.setHoldFlag(Integer.valueOf(1).equals(order.getHoldFlag()) ? 1 : 0);
        }
        if (item.getShipmentId() != null) {
            CargoOrderShipmentDO shipment = cargoOrderShipmentMapper.selectById(item.getShipmentId());
            if (shipment != null) {
                item.setPoNo(shipment.getPoNo());
                item.setShippingMark(shipment.getShippingMark());
                if (StrUtil.isNotBlank(shipment.getShipmentNo())) {
                    item.setShipmentCode(shipment.getShipmentNo());
                }
                if (StrUtil.isBlank(item.getGroupDestination())) {
                    item.setGroupDestination(shipment.getGroupCode());
                }
            }
        }
        palletItemMapper.updateById(item);
    }


    private String joinDistinct(List<String> values) {
        LinkedHashSet<String> set = new LinkedHashSet<>();
        for (String value : values) {
            if (StrUtil.isNotBlank(value)) {
                set.add(value.trim());
            }
        }
        return set.isEmpty() ? null : String.join("??", set);
    }

    private void rollupInventory(Long warehouseId, Long shipmentId) {
        List<WmsPalletItemDO> items = palletItemMapper.selectList(Wrappers.<WmsPalletItemDO>lambdaQuery()
            .eq(WmsPalletItemDO::getWarehouseId, warehouseId)
            .eq(WmsPalletItemDO::getShipmentId, shipmentId));
        if (items.isEmpty()) return;
        WmsPalletItemDO first = items.get(0);
        WmsInventoryDO inventory = inventoryMapper.selectOne(Wrappers.<WmsInventoryDO>lambdaQuery()
            .eq(WmsInventoryDO::getWarehouseId, warehouseId)
            .eq(WmsInventoryDO::getShipmentId, shipmentId)
            .last("limit 1"));
        if (inventory == null) {
            inventory = new WmsInventoryDO();
            inventory.setCompanyId(first.getCompanyId());
            inventory.setWarehouseId(first.getWarehouseId());
            inventory.setCargoOrderId(first.getCargoOrderId());
            inventory.setCargoOrderNo(first.getCargoOrderNo());
            inventory.setShipmentId(first.getShipmentId());
            inventory.setShipmentCode(first.getShipmentCode());
            inventory.setVersion(0);
        }
        Integer total = sumInt(items.stream().map(WmsPalletItemDO::getBoxQty).toList()).intValue();
        inventory.setTotalBoxQty(total);
        inventory.setAvailableBoxQty(sumInt(items.stream().map(WmsPalletItemDO::getAvailableBoxQty).toList()).intValue());
        inventory.setLockedBoxQty(sumInt(items.stream().map(WmsPalletItemDO::getLockedBoxQty).toList()).intValue());
        inventory.setExceptionBoxQty(sumInt(items.stream().map(WmsPalletItemDO::getExceptionBoxQty).toList()).intValue());
        inventory.setTotalWeight(sumDecimal(items.stream().map(WmsPalletItemDO::getWeight).toList()));
        inventory.setTotalCbm(sumDecimal(items.stream().map(WmsPalletItemDO::getCbm).toList()));
        inventory.setInventoryStatus(total > 0 ? STATUS_IN_STOCK : STATUS_DEPLETED);
        if (inventory.getId() == null) inventoryMapper.insert(inventory);
        else inventoryMapper.updateById(inventory);
    }

    private void saveTransaction(String type, WmsInventoryReceiveReqVO reqVO, WmsPalletDO pallet, WmsPalletItemDO item,
                                 Integer total, Integer available, Integer locked, Integer exception) {
        WmsInventoryTransactionDO tx = baseTransaction(type, item);
        tx.setWarehouseId(reqVO.getWarehouseId());
        tx.setCustomerId(reqVO.getCustomerId());
        tx.setCustomerName(reqVO.getCustomerName());
        tx.setToLocationId(reqVO.getLocationId());
        tx.setToLocationCode(reqVO.getLocationCode());
        tx.setBizDocType(StrUtil.isBlank(reqVO.getBizDocType()) ? "RECEIVE" : reqVO.getBizDocType());
        tx.setBizDocId(reqVO.getBizDocId());
        tx.setBizDocLineId(reqVO.getBizDocLineId());
        tx.setPalletId(pallet.getId());
        tx.setPalletNo(pallet.getPalletNo());
        tx.setChangeTotal(total);
        tx.setChangeAvailable(available);
        tx.setChangeLocked(locked);
        tx.setChangeException(exception);
        tx.setRemark(reqVO.getRemark());
        transactionMapper.insert(tx);
    }

    private void saveTransaction(String type, WmsPalletItemDO item, WmsInventoryLockReqVO reqVO, Integer qty) {
        WmsInventoryTransactionDO tx = baseTransaction(type, item);
        tx.setBizDocType(reqVO.getBizDocType());
        tx.setBizDocId(reqVO.getBizDocId());
        tx.setBizDocLineId(reqVO.getBizDocLineId());
        tx.setChangeTotal(0);
        tx.setChangeAvailable(-qty);
        tx.setChangeLocked(qty);
        tx.setChangeException(0);
        tx.setRemark(reqVO.getRemark());
        transactionMapper.insert(tx);
    }

    private WmsInventoryTransactionDO baseTransaction(String type, WmsPalletItemDO item) {
        WmsInventoryTransactionDO tx = new WmsInventoryTransactionDO();
        tx.setCompanyId(item.getCompanyId());
        tx.setWarehouseId(item.getWarehouseId());
        tx.setTransactionNo("WMT" + IdUtil.getSnowflakeNextIdStr());
        tx.setTransactionType(type);
        tx.setCargoOrderId(item.getCargoOrderId());
        tx.setCargoOrderNo(item.getCargoOrderNo());
        tx.setShipmentId(item.getShipmentId());
        tx.setShipmentCode(item.getShipmentCode());
        tx.setPalletId(item.getPalletId());
        tx.setPalletNo(item.getPalletNo());
        tx.setPalletItemId(item.getId());
        tx.setOperateTime(new Date());
        return tx;
    }






    @Override
    public WmsInventoryVisualizationRespVO getVisualization(WmsInventoryVisualizationReqVO reqVO) {
        List<WmsZoneDO> zones = zoneMapper.selectList(Wrappers.<WmsZoneDO>lambdaQuery()
            .eq(WmsZoneDO::getWarehouseId, reqVO.getWarehouseId())
            .eq(WmsZoneDO::getStatus, "ENABLED")
            .eq(reqVO.getZoneId() != null, WmsZoneDO::getId, reqVO.getZoneId())
            .like(StrUtil.isNotBlank(reqVO.getZoneKeyword()), WmsZoneDO::getZoneName, reqVO.getZoneKeyword())
            .orderByAsc(WmsZoneDO::getZoneName));
        if (zones.isEmpty()) {
            WmsInventoryVisualizationRespVO empty = new WmsInventoryVisualizationRespVO();
            empty.setWarehouseId(reqVO.getWarehouseId());
            empty.setUsedPalletCount(0);
            empty.setTotalCapacity(0);
            empty.setLocationCount(0);
            empty.setOccupancyPercent(0);
            return empty;
        }
        List<Long> zoneIds = zones.stream().map(WmsZoneDO::getId).toList();
        List<WmsLocationDO> locations = locationMapper.selectList(Wrappers.<WmsLocationDO>lambdaQuery()
            .eq(WmsLocationDO::getWarehouseId, reqVO.getWarehouseId())
            .in(WmsLocationDO::getZoneId, zoneIds)
            .orderByAsc(WmsLocationDO::getZoneName)
            .orderByAsc(WmsLocationDO::getLocationCode));
        List<WmsPalletDO> pallets = palletMapper.selectList(Wrappers.<WmsPalletDO>lambdaQuery()
            .eq(WmsPalletDO::getWarehouseId, reqVO.getWarehouseId())
            .in(WmsPalletDO::getPalletStatus, PALLET_IN_STOCK, PALLET_PRE_OUTBOUND, PALLET_HOLD)
            .isNotNull(WmsPalletDO::getLocationId));
        Map<Long, Long> palletCountMap = pallets.stream()
            .collect(Collectors.groupingBy(WmsPalletDO::getLocationId, Collectors.counting()));
        Map<Long, Map<String, Long>> destinationCountByLocation = buildDestinationCountByLocation(pallets);

        Map<Long, List<WmsLocationVisualizationRespVO>> locationByZone = new LinkedHashMap<>();
        int totalUsed = 0;
        int totalCapacity = 0;
        for (WmsLocationDO loc : locations) {
            int currentQty = palletCountMap.getOrDefault(loc.getId(), 0L).intValue();
            totalUsed += currentQty;
            int cap = loc.getCapacity() == null || loc.getCapacity() <= 0 ? 1 : loc.getCapacity();
            totalCapacity += cap;
            WmsLocationVisualizationRespVO locVo = buildLocationVisualization(loc, currentQty,
                destinationCountByLocation.getOrDefault(loc.getId(), Map.of()));
            locationByZone.computeIfAbsent(loc.getZoneId(), k -> new ArrayList<>()).add(locVo);
        }

        WmsInventoryVisualizationRespVO result = new WmsInventoryVisualizationRespVO();
        WmsZoneDO firstZone = zones.get(0);
        result.setWarehouseId(reqVO.getWarehouseId());
        result.setWarehouseCode(firstZone.getWarehouseCode());
        result.setWarehouseName(firstZone.getWarehouseName());
        result.setUsedPalletCount(totalUsed);
        result.setTotalCapacity(totalCapacity);
        result.setLocationCount(locations.size());
        result.setOccupancyPercent(calcPercent(totalUsed, totalCapacity));

        List<WmsZoneVisualizationRespVO> zoneVos = new ArrayList<>();
        for (WmsZoneDO zone : zones) {
            List<WmsLocationVisualizationRespVO> zoneLocations = locationByZone.getOrDefault(zone.getId(), List.of());
            int zoneUsed = zoneLocations.stream().mapToInt(l -> nvl(l.getCurrentQty())).sum();
            int zoneCap = zoneLocations.stream()
                .mapToInt(l -> l.getCapacity() == null || l.getCapacity() <= 0 ? 1 : l.getCapacity())
                .sum();
            WmsZoneVisualizationRespVO zoneVo = new WmsZoneVisualizationRespVO();
            zoneVo.setZoneId(zone.getId());
            zoneVo.setZoneName(zone.getZoneName());
            zoneVo.setZoneType(zone.getZoneType());
            zoneVo.setStorageMethod(zone.getStorageMethod());
            zoneVo.setStatus(zone.getStatus());
            zoneVo.setUsedPalletCount(zoneUsed);
            zoneVo.setTotalCapacity(zoneCap);
            zoneVo.setLocationCount(zoneLocations.size());
            zoneVo.setOccupancyPercent(calcPercent(zoneUsed, zoneCap));
            zoneVo.setLocations(zoneLocations);
            zoneVos.add(zoneVo);
        }
        result.setZones(zoneVos);
        return result;
    }

    private Map<Long, Map<String, Long>> buildDestinationCountByLocation(List<WmsPalletDO> pallets) {
        Map<Long, Map<String, Long>> result = new LinkedHashMap<>();
        if (pallets.isEmpty()) {
            return result;
        }
        List<Long> blankDestPalletIds = pallets.stream()
            .filter(p -> StrUtil.isBlank(p.getGroupDestination()))
            .map(WmsPalletDO::getId)
            .toList();
        Map<Long, String> destFromItems = new LinkedHashMap<>();
        if (!blankDestPalletIds.isEmpty()) {
            List<WmsPalletItemDO> items = palletItemMapper.selectList(Wrappers.<WmsPalletItemDO>lambdaQuery()
                .in(WmsPalletItemDO::getPalletId, blankDestPalletIds));
            Map<Long, List<WmsPalletItemDO>> itemByPallet = items.stream().collect(Collectors.groupingBy(WmsPalletItemDO::getPalletId));
            for (Map.Entry<Long, List<WmsPalletItemDO>> entry : itemByPallet.entrySet()) {
                String joined = joinDistinct(entry.getValue().stream().map(WmsPalletItemDO::getGroupDestination).toList());
                if (StrUtil.isNotBlank(joined)) {
                    destFromItems.put(entry.getKey(), joined);
                }
            }
        }
        for (WmsPalletDO pallet : pallets) {
            if (pallet.getLocationId() == null) {
                continue;
            }
            String dest = StrUtil.isNotBlank(pallet.getGroupDestination())
                ? pallet.getGroupDestination().trim()
                : destFromItems.getOrDefault(pallet.getId(), "????????");
            result.computeIfAbsent(pallet.getLocationId(), k -> new LinkedHashMap<>())
                .merge(dest, 1L, Long::sum);
        }
        return result;
    }

    private List<WmsLocationDestinationStatRespVO> toDestinationStats(Map<String, Long> countMap) {
        if (countMap == null || countMap.isEmpty()) {
            return List.of();
        }
        return countMap.entrySet().stream()
            .sorted((a, b) -> Long.compare(b.getValue(), a.getValue()))
            .map(e -> {
                WmsLocationDestinationStatRespVO stat = new WmsLocationDestinationStatRespVO();
                stat.setGroupDestination(e.getKey());
                stat.setPalletCount(e.getValue().intValue());
                return stat;
            })
            .toList();
    }

    private WmsLocationVisualizationRespVO buildLocationVisualization(WmsLocationDO loc, int currentQty,
                                                                Map<String, Long> destinationCounts) {
        WmsLocationVisualizationRespVO vo = new WmsLocationVisualizationRespVO();
        vo.setId(loc.getId());
        vo.setZoneId(loc.getZoneId());
        vo.setZoneName(loc.getZoneName());
        vo.setLocationCode(loc.getLocationCode());
        vo.setRowNo(loc.getRowNo());
        vo.setColumnNo(loc.getColumnNo());
        vo.setCapacity(loc.getCapacity());
        vo.setCurrentQty(currentQty);
        vo.setRemainingCapacity(loc.getCapacity() == null ? null : Math.max(loc.getCapacity() - currentQty, 0));
        vo.setStatus(loc.getStatus());
        vo.setDestinationStats(toDestinationStats(destinationCounts));
        if (!"NORMAL".equals(loc.getStatus())) {
            vo.setOccupancyPercent(0);
            vo.setOccupancyLevel("INVALID");
            return vo;
        }
        int cap = loc.getCapacity() == null || loc.getCapacity() <= 0 ? 1 : loc.getCapacity();
        int percent = Math.min(100, (int) Math.round(currentQty * 100.0 / cap));
        vo.setOccupancyPercent(percent);
        vo.setOccupancyLevel(resolveOccupancyLevel(percent, currentQty));
        return vo;
    }

    private String resolveOccupancyLevel(int percent, int currentQty) {
        if (currentQty <= 0) {
            return "EMPTY";
        }
        if (percent >= 95) {
            return "CRITICAL";
        }
        if (percent >= 80) {
            return "HIGH";
        }
        if (percent >= 50) {
            return "MEDIUM";
        }
        return "LOW";
    }

    private int calcPercent(int used, int capacity) {
        if (capacity <= 0) {
            return 0;
        }
        return Math.min(100, (int) Math.round(used * 100.0 / capacity));
    }

    private Integer nvl(Integer value) {
        return value == null ? 0 : value;
    }

    private BigDecimal nvl(BigDecimal value) {
        return value == null ? BigDecimal.ZERO : value;
    }

    private Long sumInt(List<Integer> values) {
        return values.stream().mapToLong(v -> v == null ? 0L : v).sum();
    }

    private BigDecimal sumDecimal(List<BigDecimal> values) {
        return values.stream().reduce(BigDecimal.ZERO, (sum, value) -> sum.add(nvl(value)));
    }
}
