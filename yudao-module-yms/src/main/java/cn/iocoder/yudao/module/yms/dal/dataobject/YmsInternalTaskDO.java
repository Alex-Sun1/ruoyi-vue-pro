package cn.iocoder.yudao.module.yms.dal.dataobject;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsInternalTaskRespVO;

import java.util.Date;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("yms_internal_task")
public class YmsInternalTaskDO extends TenantBaseDO {

        @TableId(value = "id")
    private Long id;

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

    }
