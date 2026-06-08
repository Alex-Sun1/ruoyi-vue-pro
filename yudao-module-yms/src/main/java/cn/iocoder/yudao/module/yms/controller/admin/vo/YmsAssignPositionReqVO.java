package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class YmsAssignPositionReqVO {

    @NotNull(message = "资源ID不能为空")
    private Long resourceId;

    /** 资源类型：CONTAINER / TRAILER */
    @NotNull(message = "资源类型不能为空")
    private String resourceType;

    @NotNull(message = "堆场位ID不能为空")
    private Long positionId;
}
