package cn.iocoder.yudao.module.base.controller.admin.businesstype.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class BusinessTypeRespVO {

    private Long id;
    private String businessTypeCode;
    private String businessTypeName;
    private String businessCategory;
    private String operationFlowType;
    private Boolean receiveRequired;
    private Boolean inboundRequired;
    private Boolean putawayRequired;
    private Boolean storageRequired;
    private Boolean pickingRequired;
    private Boolean outboundRequired;
    private Boolean deliveryRequired;
    private Boolean appointmentRequired;
    private Boolean vasSupported;
    private String sortingStrategy;
    private String sortingField;
    private Integer sortOrder;
    private Integer status;
    private String remark;
    private LocalDateTime createTime;

}
