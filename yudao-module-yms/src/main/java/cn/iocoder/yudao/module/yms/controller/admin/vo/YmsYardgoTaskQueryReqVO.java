package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.common.pojo.PageParam;

@Data
@EqualsAndHashCode(callSuper = true)
public class YmsYardgoTaskQueryReqVO extends PageParam {
    private Long warehouseId;
    private Long yardTaskId;
    private Long dockId;
    private String robotStatus;
    private String taskType;
}
