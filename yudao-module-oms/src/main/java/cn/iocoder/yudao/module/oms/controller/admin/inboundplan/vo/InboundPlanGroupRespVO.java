package cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo;

import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanItemRespVO;

import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanGroupRespVO;

import lombok.Data;
import java.io.Serializable;

import java.math.BigDecimal;
import java.util.List;

/**
 * 入库计划分组汇总 Vo（表格折叠行）
 */
@Data
public class InboundPlanGroupRespVO implements Serializable {

    /** 分组值，null 时为"未分组" */
    private String groupCode;

    /** 该分组总CBM */
    private BigDecimal totalCbm;

    /** 该分组总箱数 */
    private BigDecimal totalCartonQty;

    /** 该分组总重量 */
    private BigDecimal totalWeight;

    /** 该分组货件数 */
    private Integer itemCount;

    /**
     * 预计打板数 = CEIL(totalCbm / unitPalletCbm)
     * 由服务层根据目的仓 platform_address.unit_pallet_cbm 计算后填入
     */
    private Integer expectedPalletQty;

    /** 该分组下的货件明细 */
    private List<InboundPlanItemRespVO> items;
}
