package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.Date;

@Data
public class YmsYardTaskCreateReqVO {

    @NotBlank(message = "任务类型不能为空")
    private String taskType;

    @NotNull(message = "仓库不能为空")
    private Long warehouseId;

    @NotBlank(message = "来源单据类型不能为空")
    private String sourceOrderType;

    private Long sourceOrderId;

    private String sourceOrderNo;
    private String containerNo;
    private String truckNo;
    private String driverName;
    private String driverPhone;
    private Date etaYardTime;
    private String remark;
}
