package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.common.pojo.PageParam;

@Data
@EqualsAndHashCode(callSuper = true)
public class YmsInternalTaskQueryReqVO extends PageParam {

    private Long warehouseId;
    private String internalTaskType;
    private String taskStatus;
    private String objectNo;
    private String executorName;
    private Long parentYardTaskId;
}
