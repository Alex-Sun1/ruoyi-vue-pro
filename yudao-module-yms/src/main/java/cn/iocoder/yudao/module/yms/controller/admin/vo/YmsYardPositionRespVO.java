package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.util.Date;

@Data
public class YmsYardPositionRespVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long warehouseId;
    private Long zoneId;
    private String zoneCode;

    private String positionCode;
    private String positionName;
    private String positionType;
    private String positionStatus;

    private Integer gridRow;
    private Integer gridCol;

    private String occupiedObjectType;
    private Long occupiedObjectId;
    private String occupiedObjectNo;
    private Date occupiedSince;

    private String remark;
    private Date createTime;

    /** 关联查询 */
    private String zoneName;
    private String warehouseName;
}
