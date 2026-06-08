package cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo;

import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanSaveReqVO;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import cn.iocoder.yudao.module.oms.dal.dataobject.inboundplan.InboundPlanDO;

/**
 * 入库计划 创建Bo（从海柜订单创建）
 */
@Data
public class InboundPlanSaveReqVO {

    /** 编辑时必传 */
    private Long id;

    @NotNull(message = "海柜订单ID不能为空")
    private Long containerOrderId;

    @NotNull(message = "仓库ID不能为空")
    private Long warehouseId;

    private String remark;
}
