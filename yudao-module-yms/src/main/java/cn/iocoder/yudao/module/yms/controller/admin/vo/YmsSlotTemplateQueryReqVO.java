package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.common.pojo.PageParam;

@Data
@EqualsAndHashCode(callSuper = true)
public class YmsSlotTemplateQueryReqVO extends PageParam {
    private Long warehouseId;
    private String taskType;
    private Integer enabled;
}
