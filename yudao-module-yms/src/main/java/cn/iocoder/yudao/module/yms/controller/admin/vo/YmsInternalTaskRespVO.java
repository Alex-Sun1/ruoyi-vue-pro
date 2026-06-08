package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.util.Date;

@Data
public class YmsInternalTaskRespVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private Long id;
    private String tenantId;
    private Long warehouseId;
    private String taskNo;

    private Long parentYardTaskId;
    private String parentYardTaskNo;

    private String internalTaskType;
    private String objectType;
    private Long objectId;
    private String objectNo;

    private Long fromPositionId;
    private String fromPositionCode;
    private Long toPositionId;
    private String toPositionCode;
    private Long toDockId;
    private String toDockCode;

    private String executorType;
    private Long executorId;
    private String executorName;

    private String taskStatus;
    private Integer priority;

    private Date assignTime;
    private Date acceptTime;
    private Date startTime;
    private Date finishTime;
    private Date deadlineTime;

    private String failReason;
    private String photoUrls;
    private String remark;
    private Date createTime;
}
