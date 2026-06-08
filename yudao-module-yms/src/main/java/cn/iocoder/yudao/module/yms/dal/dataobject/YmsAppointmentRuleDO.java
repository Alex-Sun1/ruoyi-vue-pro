package cn.iocoder.yudao.module.yms.dal.dataobject;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentRuleRespVO;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("yms_appointment_rule")
public class YmsAppointmentRuleDO extends TenantBaseDO {

        @TableId(value = "id")
    private Long id;

    private String ruleName;
    private Long warehouseId;

    /** 业务类型（NULL=全部） */
    private String businessType;
    /** 车辆来源（NULL=全部） */
    private String vehicleSource;
    private String dockType;
    private String customerLevel;

    private Integer advanceDaysMin;
    private Integer advanceDaysMax;
    private Integer cancelDeadlineMinutes;
    private Integer lateGraceMinutes;
    private Integer noShowMinutes;
    private Integer autoConfirm;
    private Integer holidayFlag;

    private Integer enabled;
    private Integer sortOrder;
    private String remark;

    }
