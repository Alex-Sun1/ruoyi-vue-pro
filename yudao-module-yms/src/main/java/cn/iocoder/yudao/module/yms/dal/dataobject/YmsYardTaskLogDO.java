package cn.iocoder.yudao.module.yms.dal.dataobject;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;
import java.util.Date;

@Data
@EqualsAndHashCode(callSuper = false)
@TableName("yms_yard_task_log")
public class YmsYardTaskLogDO implements Serializable {

        @TableId(value = "id")
    private Long id;
    private String tenantId;
    private Long yardTaskId;
    private String actionType;
    private String beforeStatus;
    private String afterStatus;
    private String actionContent;
    private Long operatorId;
    private String operatorName;
    private Date actionTime;
}
