package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsDockQueueDO;

import java.io.Serial;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@Data
public class YmsYardTaskRespVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

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
    private String wmsReadyStatus;
    private Date wmsReadyTime;
    private Long appointmentId;
    private Date dockAssignTime;
    private Date callTime;
    private Integer priority;

    private String truckNo;
    private String driverName;
    private String driverPhone;

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

    /** 当前打开的院内任务ID（DOCK_IN/DOCK_OUT，未完成时返回） */
    private Long openInternalTaskId;
    /** 当前打开的院内任务号 */
    private String openInternalTaskNo;
    /** 当前打开的院内任务类型：DOCK_IN / DOCK_OUT */
    private String openInternalTaskType;
    /** 当前打开的院内任务状态：PENDING / ACCEPTED / IN_PROGRESS */
    private String openInternalTaskStatus;
    /** 当前院内任务目标位置编码 */
    private String openInternalTaskTargetCode;

    private Integer visitNo;
    private Integer unloadRoundNo;
    private Integer isReentry;
    private String reentryReason;
    private Long parentTaskId;

    private Integer exceptionFlag;
    private String exceptionReason;
    private String source;
    private String remark;

    private Date createTime;

    /** 排队列表（Dock看板用） */
    private List<YmsDockQueueDO> queueList;
}
