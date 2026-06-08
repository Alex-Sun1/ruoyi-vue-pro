package cn.iocoder.yudao.module.yms.dal.dataobject;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentRespVO;

import java.util.Date;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("yms_appointment")
public class YmsAppointmentDO extends TenantBaseDO {

        @TableId(value = "id")
    private Long id;

    private String aptNo;
    private Long warehouseId;
    private Long slotTemplateId;
    /** 预约日期 yyyy-MM-dd */
    private String aptDate;
    /** 预约时段 HH:mm-HH:mm */
    private String aptSlot;
    private String taskType;
    /** 业务类型 */
    private String businessType;
    /** 车辆来源 */
    private String vehicleSource;

    private String plateNo;
    private String driverName;
    private String driverPhone;
    private String containerNo;
    private String sourceOrderNo;

    /** PENDING / CONFIRMED / CANCELLED / COMPLETED / NO_SHOW */
    private String status;
    private Long yardTaskId;
    private String cancelReason;
    private String remark;

    }
