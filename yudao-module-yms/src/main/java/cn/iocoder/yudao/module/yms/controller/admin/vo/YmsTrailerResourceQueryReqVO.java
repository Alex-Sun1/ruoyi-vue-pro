package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.common.pojo.PageParam;

@Data
@EqualsAndHashCode(callSuper = true)
public class YmsTrailerResourceQueryReqVO extends PageParam {

    private Long warehouseId;
    private Long companyId;
    private String trailerNo;
    private String plateNo;
    private String vehicleSource;
    private String trailerStatus;
    private String wmsReadyStatus;
}
