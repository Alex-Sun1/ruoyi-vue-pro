package cn.iocoder.yudao.module.yms.dal.dataobject;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardgoTaskRespVO;

import java.math.BigDecimal;
import java.util.Date;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("yms_yardgo_task")
public class YmsYardgoTaskDO extends TenantBaseDO {

        @TableId(value = "id")
    private Long id;

    private Long yardTaskId;
    private String yardTaskNo;
    private Long warehouseId;
    private Long dockId;
    private String dockCode;

    /** 机器人系统任务ID（外部） */
    private String robotTaskId;
    /** PENDING / RUNNING / PAUSED / COMPLETED / FAILED / CANCELLED */
    private String robotStatus;

    private String taskType;
    private BigDecimal progress;
    private Date startTime;
    private Date finishTime;
    /** 机器人回调原始报文 */
    private String callbackPayload;
    private String remark;

    }
