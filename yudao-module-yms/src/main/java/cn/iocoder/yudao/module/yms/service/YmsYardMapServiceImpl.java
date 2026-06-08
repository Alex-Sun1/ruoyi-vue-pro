package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.framework.common.exception.ServiceException;
import cn.iocoder.yudao.module.base.controller.admin.yardzone.vo.YardZoneRespVO;
import cn.iocoder.yudao.module.base.dal.dataobject.yarddock.YardDockDO;
import cn.iocoder.yudao.module.base.service.yardzone.YardZoneService;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardMapPositionRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardMapRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardMapZoneRespVO;
import cn.iocoder.yudao.module.yms.support.YmsYardLocationConverter;
import cn.iocoder.yudao.module.yms.support.YmsYardLocationSupport;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class YmsYardMapServiceImpl implements YmsYardMapService {

    @Resource
    private YardZoneService yardZoneService;
    @Resource
    private YmsYardLocationSupport locationSupport;

    @Override
    public YmsYardMapRespVO queryMap(Long warehouseId) {
        if (warehouseId == null) {
            throw new ServiceException(500, "请选择仓库");
        }

        List<YardZoneRespVO> zones = yardZoneService.getYardZoneListByWarehouse(warehouseId);
        List<YardDockDO> allSlots = locationSupport.listSlotsByWarehouse(warehouseId);
        Map<Long, List<YardDockDO>> slotsByZone = allSlots.stream()
                .collect(Collectors.groupingBy(d -> d.getZoneId() != null ? d.getZoneId() : 0L));

        YmsYardMapRespVO mapVo = new YmsYardMapRespVO();
        mapVo.setWarehouseId(warehouseId);

        int total = 0;
        int occupied = 0;
        int free = 0;

        List<YmsYardMapZoneRespVO> zoneVos = new ArrayList<>();
        for (YardZoneRespVO zone : zones) {
            List<YardDockDO> zoneSlots = slotsByZone.getOrDefault(zone.getId(), List.of());
            YmsYardMapZoneRespVO zoneVo = buildZoneVo(zone, zoneSlots);
            zoneVos.add(zoneVo);
            total += zoneVo.getTotalPositions();
            occupied += zoneVo.getOccupiedPositions();
            free += zoneVo.getFreePositions();
        }

        mapVo.setZones(zoneVos);
        mapVo.setTotalPositions(total);
        mapVo.setOccupiedPositions(occupied);
        mapVo.setFreePositions(free);
        mapVo.setReservedPositions(0);
        mapVo.setDisabledPositions(0);
        return mapVo;
    }

    private YmsYardMapZoneRespVO buildZoneVo(YardZoneRespVO zone, List<YardDockDO> slots) {
        YmsYardMapZoneRespVO vo = new YmsYardMapZoneRespVO();
        vo.setId(zone.getId());
        vo.setZoneCode(zone.getZoneCode());
        vo.setZoneName(zone.getZoneName());
        vo.setZoneType(zone.getZoneType());
        vo.setTotalPositions(slots.size());

        int occ = 0;
        List<YmsYardMapPositionRespVO> positions = new ArrayList<>();
        for (YardDockDO slot : slots) {
            String status = YmsYardLocationConverter.toPositionStatus(slot.getDockStatus());
            if ("OCCUPIED".equals(status) || "RESERVED".equals(status)) {
                occ++;
            }
            positions.add(toPositionVo(slot));
        }
        vo.setOccupiedPositions(occ);
        vo.setFreePositions(slots.size() - occ);
        vo.setOccupancyRate(slots.isEmpty() ? 0 : (occ * 100 / slots.size()));
        vo.setPositions(positions);
        return vo;
    }

    private YmsYardMapPositionRespVO toPositionVo(YardDockDO slot) {
        YmsYardMapPositionRespVO vo = new YmsYardMapPositionRespVO();
        vo.setId(slot.getId());
        vo.setPositionCode(slot.getDockCode());
        vo.setPositionName(slot.getDockName());
        vo.setPositionStatus(YmsYardLocationConverter.toPositionStatus(slot.getDockStatus()));
        vo.setOccupiedObjectNo(slot.getOccupiedObjectNo());
        vo.setOccupiedObjectType(slot.getOccupiedObjectType());
        return vo;
    }

}
