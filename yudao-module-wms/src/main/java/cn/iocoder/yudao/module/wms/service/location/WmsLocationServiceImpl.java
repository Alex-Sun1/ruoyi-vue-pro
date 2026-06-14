package cn.iocoder.yudao.module.wms.service.location;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.wms.controller.admin.location.vo.WmsLocationBatchStatusReqVO;
import cn.iocoder.yudao.module.wms.controller.admin.location.vo.WmsLocationImportExcelVO;
import cn.iocoder.yudao.module.wms.controller.admin.location.vo.WmsLocationPageReqVO;
import cn.iocoder.yudao.module.wms.controller.admin.location.vo.WmsLocationRespVO;
import cn.iocoder.yudao.module.wms.controller.admin.location.vo.WmsLocationSaveReqVO;
import cn.iocoder.yudao.module.wms.dal.dataobject.location.WmsLocationDO;
import cn.iocoder.yudao.module.wms.dal.dataobject.pallet.WmsPalletDO;
import cn.iocoder.yudao.module.wms.dal.dataobject.zone.WmsZoneDO;
import cn.iocoder.yudao.module.wms.dal.mysql.location.WmsLocationMapper;
import cn.iocoder.yudao.module.wms.dal.mysql.pallet.WmsPalletMapper;
import cn.iocoder.yudao.module.wms.dal.mysql.zone.WmsZoneMapper;
import cn.iocoder.yudao.module.org.framework.datapermission.annotation.OrgDataScope;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.wms.enums.ErrorCodeConstants.*;

@Service
@Validated
public class WmsLocationServiceImpl implements WmsLocationService {

    private static final Set<String> LOCATION_STATUS = Set.of("NORMAL", "DISABLED", "LOCKED");
    private static final List<String> ACTIVE_PALLET_STATUS = Arrays.asList("IN_STOCK", "PRE_OUTBOUND", "HOLD");

    @Resource
    private WmsLocationMapper locationMapper;
    @Resource
    private WmsZoneMapper zoneMapper;
    @Resource
    private WmsPalletMapper palletMapper;

    @Override
    @OrgDataScope(tableClass = WmsLocationDO.class, warehouseColumn = "warehouse_id")
    public PageResult<WmsLocationRespVO> getLocationPage(WmsLocationPageReqVO pageReqVO) {
        PageResult<WmsLocationDO> page = locationMapper.selectPage(pageReqVO);
        List<WmsLocationRespVO> list = toRespList(page.getList());
        enrichInventory(list);
        return new PageResult<>(list, page.getTotal());
    }

    @Override
    @OrgDataScope(tableClass = WmsLocationDO.class, warehouseColumn = "warehouse_id")
    public List<WmsLocationRespVO> getLocationList(WmsLocationPageReqVO pageReqVO) {
        List<WmsLocationRespVO> list = toRespList(locationMapper.selectList(locationMapper.buildWrapper(pageReqVO)));
        enrichInventory(list);
        return list;
    }

    @Override
    @OrgDataScope(tableClass = WmsLocationDO.class, warehouseColumn = "warehouse_id")
    public WmsLocationRespVO getLocation(Long id) {
        WmsLocationDO row = locationMapper.selectById(id);
        if (row == null) {
            return null;
        }
        WmsLocationRespVO vo = BeanUtils.toBean(row, WmsLocationRespVO.class);
        enrichInventory(List.of(vo));
        return vo;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createLocation(WmsLocationSaveReqVO createReqVO) {
        WmsLocationDO entity = BeanUtils.toBean(createReqVO, WmsLocationDO.class);
        fillZoneSnapshot(entity);
        validateLocation(entity, null);
        if (StrUtil.isBlank(entity.getStatus())) {
            entity.setStatus("NORMAL");
        }
        entity.setCurrentQty(0);
        entity.setRemainingCapacity(calcRemaining(entity.getCapacity(), 0));
        locationMapper.insert(entity);
        return entity.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    @OrgDataScope(tableClass = WmsLocationDO.class, warehouseColumn = "warehouse_id")
    public void updateLocation(WmsLocationSaveReqVO updateReqVO) {
        WmsLocationDO entity = BeanUtils.toBean(updateReqVO, WmsLocationDO.class);
        fillZoneSnapshot(entity);
        validateLocation(entity, entity.getId());
        entity.setCurrentQty(null);
        entity.setRemainingCapacity(null);
        locationMapper.updateById(entity);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    @OrgDataScope(tableClass = WmsLocationDO.class, warehouseColumn = "warehouse_id")
    public void changeLocationStatus(WmsLocationBatchStatusReqVO reqVO) {
        if (!LOCATION_STATUS.contains(reqVO.getStatus())) {
            throw exception(WMS_LOCATION_STATUS_INVALID);
        }
        for (Long id : reqVO.getIds()) {
            WmsLocationDO entity = new WmsLocationDO();
            entity.setId(id);
            entity.setStatus(reqVO.getStatus());
            locationMapper.updateById(entity);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    @OrgDataScope(tableClass = WmsLocationDO.class, warehouseColumn = "warehouse_id")
    public void deleteLocationList(List<Long> ids) {
        for (Long id : ids) {
            long count = palletMapper.selectCount(Wrappers.<WmsPalletDO>lambdaQuery()
                    .eq(WmsPalletDO::getLocationId, id)
                    .in(WmsPalletDO::getPalletStatus, ACTIVE_PALLET_STATUS));
            if (count > 0) {
                throw exception(WMS_LOCATION_HAS_INVENTORY);
            }
        }
        locationMapper.deleteByIds(ids);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public String importLocationData(List<WmsLocationImportExcelVO> list, Long warehouseId, Long companyId) {
        if (list == null || list.isEmpty()) {
            throw exception(WMS_BIZ_ERROR, "导入数据为空");
        }
        if (warehouseId == null) {
            throw exception(WMS_BIZ_ERROR, "请先选择仓库");
        }
        int success = 0;
        StringBuilder failure = new StringBuilder();
        Map<String, WmsZoneDO> zoneCache = new HashMap<>();
        for (int i = 0; i < list.size(); i++) {
            WmsLocationImportExcelVO row = list.get(i);
            int rowNum = i + 2;
            try {
                if (StrUtil.isBlank(row.getZoneName()) || StrUtil.isBlank(row.getLocationCode())) {
                    throw exception(WMS_BIZ_ERROR, "所属库区与库位编码不能为空");
                }
                WmsZoneDO zone = zoneCache.computeIfAbsent(row.getZoneName(), name -> zoneMapper.selectOne(
                        Wrappers.<WmsZoneDO>lambdaQuery()
                                .eq(WmsZoneDO::getWarehouseId, warehouseId)
                                .eq(WmsZoneDO::getZoneName, name)
                                .last("LIMIT 1")));
                if (zone == null) {
                    throw exception(WMS_BIZ_ERROR, "库区不存在");
                }
                WmsLocationSaveReqVO save = new WmsLocationSaveReqVO();
                save.setCompanyId(companyId);
                save.setWarehouseId(warehouseId);
                save.setZoneId(zone.getId());
                save.setZoneName(zone.getZoneName());
                save.setLocationCode(row.getLocationCode().trim());
                save.setRowNo(row.getRowNo());
                save.setColumnNo(row.getColumnNo());
                save.setCapacity(row.getCapacity());
                save.setStatus(normalizeStatus(row.getStatus()));
                createLocation(save);
                success++;
            } catch (Exception e) {
                failure.append("<br/>第").append(rowNum).append("行：").append(e.getMessage());
            }
        }
        if (failure.length() > 0) {
            failure.insert(0, "成功导入 " + success + " 条，失败如下：");
            return failure.toString();
        }
        return "成功导入 " + success + " 条";
    }

    private List<WmsLocationRespVO> toRespList(List<WmsLocationDO> list) {
        return list.stream().map(r -> BeanUtils.toBean(r, WmsLocationRespVO.class)).collect(Collectors.toList());
    }

    private void enrichInventory(List<WmsLocationRespVO> records) {
        if (records == null || records.isEmpty()) {
            return;
        }
        List<Long> locationIds = records.stream().map(WmsLocationRespVO::getId).collect(Collectors.toList());
        List<WmsPalletDO> pallets = palletMapper.selectList(Wrappers.<WmsPalletDO>lambdaQuery()
                .in(WmsPalletDO::getLocationId, locationIds)
                .in(WmsPalletDO::getPalletStatus, ACTIVE_PALLET_STATUS));
        Map<Long, Long> qtyMap = pallets.stream()
                .collect(Collectors.groupingBy(WmsPalletDO::getLocationId, Collectors.counting()));
        for (WmsLocationRespVO vo : records) {
            int currentQty = qtyMap.getOrDefault(vo.getId(), 0L).intValue();
            vo.setCurrentQty(currentQty);
            vo.setRemainingCapacity(calcRemaining(vo.getCapacity(), currentQty));
        }
    }

    private Integer calcRemaining(Integer capacity, int currentQty) {
        if (capacity == null) {
            return null;
        }
        return Math.max(capacity - currentQty, 0);
    }

    private void fillZoneSnapshot(WmsLocationDO entity) {
        if (entity.getZoneId() == null) {
            throw exception(WMS_BIZ_ERROR, "所属库区不能为空");
        }
        WmsZoneDO zone = zoneMapper.selectById(entity.getZoneId());
        if (zone == null) {
            throw exception(WMS_BIZ_ERROR, "库区不存在");
        }
        entity.setZoneName(zone.getZoneName());
        if (entity.getWarehouseId() == null) {
            entity.setWarehouseId(zone.getWarehouseId());
        }
        if (StrUtil.isBlank(entity.getWarehouseCode())) {
            entity.setWarehouseCode(zone.getWarehouseCode());
        }
        if (StrUtil.isBlank(entity.getWarehouseName())) {
            entity.setWarehouseName(zone.getWarehouseName());
        }
    }

    private void validateLocation(WmsLocationDO entity, Long excludeId) {
        if (entity.getWarehouseId() == null || StrUtil.isBlank(entity.getLocationCode())) {
            throw exception(WMS_PARAM_INVALID, "仓库与库位编码不能为空");
        }
        if (StrUtil.isNotBlank(entity.getStatus()) && !LOCATION_STATUS.contains(entity.getStatus())) {
            throw exception(WMS_LOCATION_STATUS_INVALID);
        }
        long count = locationMapper.selectCount(Wrappers.<WmsLocationDO>lambdaQuery()
                .eq(WmsLocationDO::getWarehouseId, entity.getWarehouseId())
                .eq(WmsLocationDO::getLocationCode, entity.getLocationCode())
                .ne(excludeId != null, WmsLocationDO::getId, excludeId));
        if (count > 0) {
            throw exception(WMS_LOCATION_CODE_DUPLICATE);
        }
    }

    private String normalizeStatus(String status) {
        if (StrUtil.isBlank(status)) {
            return "NORMAL";
        }
        String value = status.trim().toUpperCase();
        if ("正常".equals(status)) {
            return "NORMAL";
        }
        if ("停用".equals(status)) {
            return "DISABLED";
        }
        if ("锁定".equals(status)) {
            return "LOCKED";
        }
        return LOCATION_STATUS.contains(value) ? value : "NORMAL";
    }

}
