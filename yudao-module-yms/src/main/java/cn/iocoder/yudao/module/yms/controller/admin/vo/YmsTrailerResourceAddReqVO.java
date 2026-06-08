package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsTrailerResourceDO;

@Data
public class YmsTrailerResourceAddReqVO {

    @NotNull(message = "仓库ID不能为空")
    private Long warehouseId;

    private Long companyId;

    /** 车厢号（租赁/自有车厢必填；供应商车辆可不填） */
    private String trailerNo;
    private String tractorNo;
    private String plateNo;
    private String driverName;
    private String driverPhone;
    private String driverIdNo;

    @NotBlank(message = "车辆来源不能为空")
    private String vehicleSource;

    private Long supplierId;
    private String supplierName;
    private Long relatedLoadingTaskId;
    private String relatedOrderNo;
    private Long bizRootId;
    private String remark;
}
