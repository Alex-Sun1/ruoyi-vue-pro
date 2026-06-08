package cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo;

import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanPageReqVO;

import lombok.Data;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import lombok.EqualsAndHashCode;
import lombok.ToString;
import lombok.EqualsAndHashCode;
/**
 * 入库计划 查询Bo
 */
@Data
public class InboundPlanPageReqVO  {

    private Long warehouseId;
    private Long containerOrderId;
    private String planNo;
    private String status;
}
