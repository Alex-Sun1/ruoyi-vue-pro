package cn.iocoder.yudao.module.yms.dal.dataobject;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardTaskRespVO;

import java.math.BigDecimal;
import java.util.Date;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("yms_yard_task")
public class YmsYardTaskDO extends TenantBaseDO {

        @TableId(value = "id")
    private Long id;

    private String yardTaskNo;
    private String taskType;
    private Long warehouseId;

    private String sourceOrderType;
    private Long sourceOrderId;
    private String sourceOrderNo;
    private String containerNo;

    private Long containerResourceId;
    private Long trailerResourceId;
    /** WMS备货状态：NOT_REQUIRED/PENDING/READY */
    private String wmsReadyStatus;
    private Date wmsReadyTime;
    private Long appointmentId;
    private Date dockAssignTime;
    private Date callTime;
    /** 优先级 1-10，越小越高 */
    private Integer priority;

    private String truckNo;
    private String driverName;
    private String driverPhone;
    /** 司机驾照号码（装车司机 H5 预登记时补录） */
    private String driverLicenseNo;

    private Date etaYardTime;
    private Date gateInTime;
    private Date dockStartTime;
    private Date dockFinishTime;
    private Date releaseTime;
    private Date gateOutTime;

    private Long dockId;
    private String dockCode;

    private Long operationTaskId;
    private String operationStatus;
    private BigDecimal operationProgress;
    private Date operationStartTime;
    private Date operationFinishTime;
    private Date estimatedFinishTime;

    private BigDecimal loadedQty;
    private BigDecimal totalQty;
    private BigDecimal loadedPalletQty;
    private BigDecimal totalPalletQty;

    private String yardStatus;

    private Integer visitNo;
    private Integer unloadRoundNo;
    private String activeTaskKey;
    private Integer isReentry;
    private String reentryReason;
    private Long parentTaskId;

    private Integer exceptionFlag;
    private String exceptionReason;
    private String source;
    private String remark;

    }
