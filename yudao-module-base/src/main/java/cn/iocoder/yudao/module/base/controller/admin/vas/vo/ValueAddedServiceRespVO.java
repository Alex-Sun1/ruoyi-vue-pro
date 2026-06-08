package cn.iocoder.yudao.module.base.controller.admin.vas.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ValueAddedServiceRespVO {

    private Long id;
    private String serviceCode;
    private String serviceName;
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
    private LocalDateTime createTime;

}
