package cn.iocoder.yudao.module.base.controller.admin.businesstype.vo;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class BusinessTypeUpdateStatusReqVO {

    @NotNull(message = "id cannot be null")
    private Long id;

    @NotNull(message = "status cannot be null")
    private Integer status;

}
