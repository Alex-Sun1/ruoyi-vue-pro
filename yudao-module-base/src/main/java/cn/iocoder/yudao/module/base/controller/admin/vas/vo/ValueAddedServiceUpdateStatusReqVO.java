package cn.iocoder.yudao.module.base.controller.admin.vas.vo;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class ValueAddedServiceUpdateStatusReqVO {

    @NotNull(message = "id cannot be null")
    private Long id;

    @NotNull(message = "status cannot be null")
    private Integer status;

}
