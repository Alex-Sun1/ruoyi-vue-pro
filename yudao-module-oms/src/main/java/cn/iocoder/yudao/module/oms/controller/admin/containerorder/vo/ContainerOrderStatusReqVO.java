package cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo;

import cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerOrderStatusReqVO;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.util.Date;

/**
 * 海柜订单状态动作对象
 */
@Data
public class ContainerOrderStatusReqVO {

    @NotBlank(message = "目标状态不能为空")
    private String targetStatus;

    private String remark;

    /** 实际到仓时间（YMS Check-in 时回写） */
    private Date actualArrivalTime;

    /** 拆柜开始时间（YMS 开始作业时回写） */
    private Date devanningStartTime;

    /** 拆柜完成时间（YMS 完成作业时回写） */
    private Date devanningFinishTime;

    /** 停车位/位置（YMS Check-in 时回写） */
    private String containerLocation;
}
