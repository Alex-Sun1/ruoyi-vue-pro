package cn.iocoder.yudao.module.base.controller.admin.businesstype.vo;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class BusinessTypeSaveReqVO {

    private Long id;
    @NotBlank(message = "businessTypeCode cannot be blank")
    private String businessTypeCode;
    @NotBlank(message = "businessTypeName cannot be blank")
    private String businessTypeName;
    @NotBlank(message = "businessCategory cannot be blank")
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

}
