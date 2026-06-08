package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Data
public class YmsYardInventoryTaskRespVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long warehouseId;
    private String warehouseName;
    private String inventoryNo;
    private String inventoryType;
    private Long zoneId;
    private String zoneCode;
    private String zoneName;

    private Integer expectedCount;
    private Integer actualCount;
    private Integer diffCount;
    private String status;

    private Date startTime;
    private Date finishTime;
    private Long operatorId;
    private String operatorName;
    private String remark;
    private Date createTime;

    private List<YmsYardInventoryItemRespVO> items;
}
