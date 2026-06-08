package cn.iocoder.yudao.module.yms.dal.dataobject;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCallRuleRespVO;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("yms_call_rule")
public class YmsCallRuleDO extends TenantBaseDO {

        @TableId(value = "id")
    private Long id;

    private String ruleName;
    private Long warehouseId;
    private String taskType;
    private String dockType;

    private Integer wmsReadyRequired;
    private Integer appointmentRequired;
    private Integer allowManualInsert;
    private Integer autoCallEnabled;
    private Integer requireDispatchConfirm;
    private Integer maxCallCount;
    private Integer callTimeoutMinutes;

    private Integer enabled;
    private Integer sortOrder;
    private String remark;

    }
