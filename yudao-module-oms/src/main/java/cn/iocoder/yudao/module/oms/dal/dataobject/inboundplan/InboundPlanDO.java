package cn.iocoder.yudao.module.oms.dal.dataobject.inboundplan;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanRespVO;

/**
 * 入库计划主表
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("wms_inbound_plan")
public class InboundPlanDO extends TenantBaseDO {

    @TableId
    private Long id;

    /** 仓库ID */
    private Long warehouseId;

    /** 海柜订单ID */
    private Long containerOrderId;

    /** 海柜订单编号（冗余） */
    private String containerOrderNo;

    /** 入库计划编号（系统生成） */
    private String planNo;

    /** 状态：draft/in_progress/completed/cancelled */
    private String status;

    private String remark;}
