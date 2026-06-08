package cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo;

import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanSaveGroupReqVO;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 入库计划分组保存 Bo（前端确认后批量提交）
 */
@Data
public class InboundPlanSaveGroupReqVO {

    @NotNull(message = "明细ID不能为空")
    private Long itemId;

    /** 拟写入的 group_code；null 表示清空 */
    private String groupCode;
}
