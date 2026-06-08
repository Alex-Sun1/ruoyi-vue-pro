package cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo;

import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanItemUpdateReqVO;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 入库计划明细 更新Bo（分组/预库位）
 */
@Data
public class InboundPlanItemUpdateReqVO {

    @NotNull(message = "明细ID不能为空")
    private Long id;

    /** 分组（手动编辑时传入） */
    private String groupCode;

    /** 系统预库位 */
    private String preLocation;
}
