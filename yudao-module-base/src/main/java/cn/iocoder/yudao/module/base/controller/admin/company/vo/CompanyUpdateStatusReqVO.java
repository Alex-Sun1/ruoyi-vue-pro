package cn.iocoder.yudao.module.base.controller.admin.company.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Schema(description = "管理后台 - 主体启用/停用 Request VO")
@Data
public class CompanyUpdateStatusReqVO {

    @NotNull(message = "id 不能为空")
    private Long id;

    @NotNull(message = "status 不能为空")
    private Integer status;

}
