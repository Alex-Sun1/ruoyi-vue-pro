package cn.iocoder.yudao.module.oms.dal.dataobject.inboundplan;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanItemRespVO;

/**
 * 入库计划明细（货件维度）
 * 只存计划决策字段，展示数据全部实时 JOIN 原表
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("wms_inbound_plan_item")
public class InboundPlanItemDO extends TenantBaseDO {

    @TableId
    private Long id;    /** 入库计划ID */
    private Long planId;

    /** 货物订单ID */
    private Long cargoOrderId;

    /** 货件ID */
    private Long shipmentId;

    /** 分组（核心字段，auto_group/quick_config/manual 三种方式写入） */
    private String groupCode;

    /** 系统预库位 */
    private String preLocation;}
