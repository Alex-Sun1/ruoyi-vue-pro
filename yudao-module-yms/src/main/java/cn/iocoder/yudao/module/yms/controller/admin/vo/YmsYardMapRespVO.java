package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Data
public class YmsYardMapRespVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private Long warehouseId;
    private String warehouseName;

    private int totalPositions;
    private int occupiedPositions;
    private int freePositions;
    private int reservedPositions;
    private int disabledPositions;

    private List<YmsYardMapZoneRespVO> zones;
}
