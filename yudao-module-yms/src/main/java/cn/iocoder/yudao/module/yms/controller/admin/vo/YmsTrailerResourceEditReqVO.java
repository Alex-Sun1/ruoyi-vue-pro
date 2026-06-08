package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsTrailerResourceDO;

@Data
public class YmsTrailerResourceEditReqVO {

    @NotNull(message = "ID不能为空")
    private Long id;

    private String trailerNo;
    private String tractorNo;
    private String plateNo;
    private String driverName;
    private String driverPhone;
    private Long relatedLoadingTaskId;
    private String relatedOrderNo;
    private String remark;
}
