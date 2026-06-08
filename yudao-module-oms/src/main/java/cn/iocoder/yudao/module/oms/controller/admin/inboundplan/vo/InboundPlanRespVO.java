package cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo;

import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanRespVO;

import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanGroupRespVO;

import lombok.Data;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * 入库计划 Vo（含分组汇总列表）
 */
@Data
public class InboundPlanRespVO implements Serializable {

    private Long id;
    private String planNo;
    private String status;
    private Long warehouseId;
    private Long containerOrderId;
    private String containerOrderNo;

    // 海柜头部信息（JOIN oms_container_order）
    private String channelName;
    private String customerName;
    private Date eta;
    private BigDecimal totalCbm;
    private BigDecimal totalCartonQty;
    private BigDecimal totalWeight;

    private String remark;
    private Date createTime;
    private Date updateTime;

    /** 分组汇总列表（每个 group 一条，含该组所有 items） */
    private List<InboundPlanGroupRespVO> groups;
}
