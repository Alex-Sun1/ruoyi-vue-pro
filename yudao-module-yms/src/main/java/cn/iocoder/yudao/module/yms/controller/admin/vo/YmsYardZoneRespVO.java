package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

@Data
public class YmsYardZoneRespVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long warehouseId;
    private String warehouseName;
    private String zoneCode;
    private String zoneName;
    /** CONTAINER / TRUCK / SELF_PICKUP / PARKING */
    private String zoneType;
    private Integer sortOrder;
    private String remark;
}
