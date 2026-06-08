package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.util.Date;

@Data
public class YmsYardMapPositionRespVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private Long id;
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

    /** 占用对象扩展信息 */
    private String objectStatus;
    private String relatedOrderNo;
}
