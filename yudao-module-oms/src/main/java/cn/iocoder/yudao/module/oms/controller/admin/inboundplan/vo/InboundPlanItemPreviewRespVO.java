package cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo;

import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanItemPreviewRespVO;

import lombok.Data;

import java.io.Serializable;

/**
 * 入库计划分组预览 Vo（自动分组/快速配置预览，不写库）
 */
@Data
public class InboundPlanItemPreviewRespVO implements Serializable {

    private Long itemId;
    private String cargoOrderNo;
    private String shipmentNo;
    /** 当前已保存的 group_code */
    private String currentGroupCode;
    /** 规则引擎计算出的拟分组 code；null 表示规则未命中（快速配置模式） */
    private String proposedGroupCode;
    /** 是否与当前值不同 */
    private Boolean changed;
}
