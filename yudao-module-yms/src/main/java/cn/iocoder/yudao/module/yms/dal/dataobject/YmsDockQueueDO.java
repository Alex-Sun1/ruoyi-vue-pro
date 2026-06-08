package cn.iocoder.yudao.module.yms.dal.dataobject;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;
import java.util.Date;

@Data
@EqualsAndHashCode(callSuper = false)
@TableName("yms_dock_queue")
public class YmsDockQueueDO implements Serializable {

        @TableId(value = "id")
    private Long id;
    private String tenantId;
    private Long dockId;
    private Long yardTaskId;
    private String containerNo;
    private Integer queueNo;
    private String queueStatus;
    private Date queuedTime;
    private Date enterDockTime;
    private Date cancelTime;
    private Date createTime;
    private Date updateTime;
}
