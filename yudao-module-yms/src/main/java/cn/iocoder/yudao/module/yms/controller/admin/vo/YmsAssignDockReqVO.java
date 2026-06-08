package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class YmsAssignDockReqVO {

    @NotNull(message = "任务ID不能为空")
    private Long yardTaskId;

    /** dockId为null时表示取消分配 */
    private Long dockId;
}
