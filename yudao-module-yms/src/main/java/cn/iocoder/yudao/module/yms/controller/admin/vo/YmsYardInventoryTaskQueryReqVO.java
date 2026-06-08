package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.common.pojo.PageParam;

@Data
@EqualsAndHashCode(callSuper = true)
public class YmsYardInventoryTaskQueryReqVO extends PageParam {

    private Long warehouseId;
    private String inventoryNo;
    private String inventoryType;
    private String status;
    private Long zoneId;
}
