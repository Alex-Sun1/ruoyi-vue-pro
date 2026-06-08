package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.Date;

/** OMS/TMS推送园区任务（幂等接口） */
@Data
public class YmsPushTaskReqVO {

    @NotBlank(message = "任务类型不能为空")
    private String taskType;

    @NotNull(message = "仓库ID不能为空")
    private Long warehouseId;

    @NotBlank(message = "来源单据类型不能为空")
    private String sourceOrderType;

    @NotNull(message = "来源单据ID不能为空")
    private Long sourceOrderId;

    private String sourceOrderNo;
    private String containerNo;
    private String truckNo;
    private String driverName;
    private String driverPhone;
    private Date etaYardTime;
}
