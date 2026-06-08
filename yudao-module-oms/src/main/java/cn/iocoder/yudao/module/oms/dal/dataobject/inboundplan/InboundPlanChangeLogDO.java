package cn.iocoder.yudao.module.oms.dal.dataobject.inboundplan;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.util.Date;

/**
 * 入库计划分组变更日志
 */
@Data
@TableName("wms_inbound_plan_change_log")
public class InboundPlanChangeLogDO {

    @TableId
    private Long id;    private Long planId;
    private Long planItemId;
    private Long shipmentId;

    private String oldGroupCode;
    private String newGroupCode;

    /** 变更类型：auto_group / quick_config / manual */
    private String changeType;

    private Long changeBy;
    private Date changeTime;
}
