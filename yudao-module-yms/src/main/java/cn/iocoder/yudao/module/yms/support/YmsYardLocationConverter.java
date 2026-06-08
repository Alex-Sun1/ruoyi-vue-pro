package cn.iocoder.yudao.module.yms.support;

import cn.iocoder.yudao.module.base.dal.dataobject.yarddock.YardDockDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardPositionRespVO;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

/** yard_dock ↔ YMS 堆场位 VO 转换 */
public final class YmsYardLocationConverter {

    private YmsYardLocationConverter() {
    }

    public static String toPositionStatus(String dockStatus) {
        if (dockStatus == null) return "FREE";
        return switch (dockStatus) {
            case "IDLE" -> "FREE";
            case "OCCUPIED" -> "OCCUPIED";
            case "RESERVED" -> "RESERVED";
            case "MAINTENANCE", "DISABLED" -> "DISABLED";
            default -> "FREE";
        };
    }

    public static String toDockStatus(String positionStatus) {
        if (positionStatus == null) return "IDLE";
        return switch (positionStatus) {
            case "FREE" -> "IDLE";
            case "OCCUPIED" -> "OCCUPIED";
            case "RESERVED" -> "RESERVED";
            default -> "DISABLED";
        };
    }

    public static YmsYardPositionRespVO toPositionVo(YardDockDO dock) {
        if (dock == null) return null;
        YmsYardPositionRespVO vo = new YmsYardPositionRespVO();
        vo.setId(dock.getId());
        vo.setWarehouseId(dock.getWarehouseId());
        vo.setZoneId(dock.getZoneId());
        vo.setZoneCode(dock.getZoneCode());
        vo.setPositionCode(dock.getDockCode());
        vo.setPositionName(dock.getDockName());
        vo.setPositionType(dock.getLocationType());
        vo.setPositionStatus(toPositionStatus(dock.getDockStatus()));
        vo.setGridRow(dock.getGridRow());
        vo.setGridCol(dock.getGridCol());
        vo.setOccupiedObjectType(dock.getOccupiedObjectType());
        vo.setOccupiedObjectId(dock.getOccupiedObjectId());
        vo.setOccupiedObjectNo(dock.getOccupiedObjectNo());
        vo.setOccupiedSince(toDate(dock.getOccupiedSince()));
        vo.setRemark(dock.getRemark());
        vo.setCreateTime(toDate(dock.getCreateTime()));
        vo.setWarehouseName(dock.getWarehouseName());
        return vo;
    }

    public static void applyOccupy(YardDockDO dock, String objectType, Long objectId, String objectNo) {
        dock.setDockStatus("OCCUPIED");
        dock.setOccupiedObjectType(objectType);
        dock.setOccupiedObjectId(objectId);
        dock.setOccupiedObjectNo(objectNo);
        dock.setOccupiedSince(LocalDateTime.now());
    }

    public static void applyRelease(YardDockDO dock) {
        dock.setDockStatus("IDLE");
        dock.setOccupiedObjectType(null);
        dock.setOccupiedObjectId(null);
        dock.setOccupiedObjectNo(null);
        dock.setOccupiedSince(null);
    }

    public static boolean isFree(YardDockDO dock) {
        return dock != null && ("IDLE".equals(dock.getDockStatus()) || "FREE".equals(dock.getDockStatus()));
    }

    private static Date toDate(LocalDateTime time) {
        if (time == null) {
            return null;
        }
        return Date.from(time.atZone(ZoneId.systemDefault()).toInstant());
    }
}
