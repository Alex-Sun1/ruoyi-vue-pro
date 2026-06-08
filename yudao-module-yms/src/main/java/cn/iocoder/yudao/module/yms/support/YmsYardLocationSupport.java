package cn.iocoder.yudao.module.yms.support;

import cn.iocoder.yudao.framework.common.exception.ServiceException;
import cn.iocoder.yudao.module.base.dal.dataobject.yarddock.YardDockDO;
import cn.iocoder.yudao.module.base.dal.dataobject.yardzone.YardZoneDO;
import cn.iocoder.yudao.module.base.dal.mysql.yarddock.YardDockMapper;
import cn.iocoder.yudao.module.base.dal.mysql.yardzone.YardZoneMapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * YMS 堆场位读写统一入口（底层 yard_dock + yard_zone）。
 */
@Component
public class YmsYardLocationSupport {

    @Resource
    private YardDockMapper yardDockMapper;
    @Resource
    private YardZoneMapper yardZoneMapper;

    public YardDockDO requireSlot(Long id) {
        YardDockDO dock = yardDockMapper.selectById(id);
        if (dock == null || !YmsYardLocationTypes.isSlot(dock.getLocationType())) {
            throw new ServiceException(500, "堆场位不存在");
        }
        return dock;
    }

    public YardZoneDO requireZone(Long zoneId) {
        YardZoneDO zone = yardZoneMapper.selectById(zoneId);
        if (zone == null) {
            throw new ServiceException(500, "堆场分区不存在");
        }
        return zone;
    }

    public void releaseSlot(Long slotId) {
        YardDockDO patch = new YardDockDO();
        patch.setId(slotId);
        YmsYardLocationConverter.applyRelease(patch);
        yardDockMapper.updateById(patch);
    }

    public void occupySlot(Long slotId, String objectType, Long objectId, String objectNo) {
        YardDockDO patch = new YardDockDO();
        patch.setId(slotId);
        YmsYardLocationConverter.applyOccupy(patch, objectType, objectId, objectNo);
        yardDockMapper.updateById(patch);
    }

    public List<YardDockDO> listFreeSlots(Long warehouseId, String locationType) {
        return yardDockMapper.selectList(
                Wrappers.<YardDockDO>lambdaQuery()
                        .eq(YardDockDO::getWarehouseId, warehouseId)
                        .eq(YardDockDO::getDockStatus, "IDLE")
                        .eq(YardDockDO::getEnabledFlag, 1)
                        .eq(locationType != null, YardDockDO::getLocationType, locationType)
                        .in(YardDockDO::getLocationType, YmsYardLocationTypes.SLOT_TYPES)
                        .orderByAsc(YardDockDO::getZoneCode, YardDockDO::getGridRow, YardDockDO::getGridCol));
    }

    public List<YardDockDO> listSlotsByWarehouse(Long warehouseId) {
        return yardDockMapper.selectList(
                Wrappers.<YardDockDO>lambdaQuery()
                        .eq(YardDockDO::getWarehouseId, warehouseId)
                        .in(YardDockDO::getLocationType, YmsYardLocationTypes.SLOT_TYPES)
                        .orderByAsc(YardDockDO::getZoneCode, YardDockDO::getGridRow, YardDockDO::getGridCol));
    }

    public List<YardDockDO> listSlotsByZone(Long zoneId) {
        return yardDockMapper.selectList(
                Wrappers.<YardDockDO>lambdaQuery()
                        .eq(YardDockDO::getZoneId, zoneId)
                        .in(YardDockDO::getLocationType, YmsYardLocationTypes.SLOT_TYPES)
                        .orderByAsc(YardDockDO::getGridRow, YardDockDO::getGridCol));
    }

}
