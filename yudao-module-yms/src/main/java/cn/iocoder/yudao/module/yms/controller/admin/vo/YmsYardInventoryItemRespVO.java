package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.util.Date;

@Data
public class YmsYardInventoryItemRespVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long inventoryId;
    private String objectType;
    private String objectNo;
    private Long systemPositionId;
    private String systemPositionCode;
    private Long actualPositionId;
    private String actualPositionCode;
    private String scanStatus;
    private String diffType;
    private String photoUrls;
    private String remark;
    private Date scanTime;
    private Date createTime;
}
