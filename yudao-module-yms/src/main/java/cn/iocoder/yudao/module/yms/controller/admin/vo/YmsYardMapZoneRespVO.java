package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.util.List;

@Data
public class YmsYardMapZoneRespVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long warehouseId;
    private String zoneCode;
    private String zoneName;
    private String zoneType;
    private Integer sortOrder;

    private int totalPositions;
    private int occupiedPositions;
    private int freePositions;
    /** 占用率 0~100 */
    private int occupancyRate;

    private List<YmsYardMapPositionRespVO> positions;
}
