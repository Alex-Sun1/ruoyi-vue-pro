package cn.iocoder.yudao.module.base.controller.admin.vas.vo;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class ValueAddedServiceSaveReqVO {

    private Long id;
    @NotBlank(message = "serviceCode cannot be blank")
    private String serviceCode;
    @NotBlank(message = "serviceName cannot be blank")
    private String serviceName;
    @NotBlank(message = "serviceCategory cannot be blank")
    private String serviceCategory;
    private String billingMode;
    private Boolean chargeableFlag;
    private Boolean operationRequired;
    private Boolean pdaOperationFlag;
    private Boolean photoRequired;
    private Boolean qcRequired;
    private Boolean supportBatchOperation;
    private Boolean defaultSelected;
    private Integer priority;
    private Integer sortOrder;
    private Integer status;
    private String remark;

}
