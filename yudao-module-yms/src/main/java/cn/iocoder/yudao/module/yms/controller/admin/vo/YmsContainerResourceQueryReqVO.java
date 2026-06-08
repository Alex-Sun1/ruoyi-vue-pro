package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.common.pojo.PageParam;

@Data
@EqualsAndHashCode(callSuper = true)
public class YmsContainerResourceQueryReqVO extends PageParam {

    private Long warehouseId;
    private Long companyId;
    private String containerNo;
    private String containerType;
    private String containerStatus;
    private String emptyStatus;
    private String plateNo;
    /** 即将到期还柜：LFD在N天内 */
    private Integer lfdWithinDays;
}
