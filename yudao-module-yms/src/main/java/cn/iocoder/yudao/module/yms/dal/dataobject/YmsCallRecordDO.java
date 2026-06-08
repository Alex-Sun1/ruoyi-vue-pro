package cn.iocoder.yudao.module.yms.dal.dataobject;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;
import java.util.Date;

@Data
@EqualsAndHashCode(callSuper = false)
@TableName("yms_call_record")
public class YmsCallRecordDO implements Serializable {

        @TableId(value = "id")
    private Long id;

    private String tenantId;
    private Long warehouseId;
    private Long yardTaskId;
    private String yardTaskNo;
    private Long callRuleId;
    private Integer callNo;
    private String callStatus;
    private String callType;
    private Long callerId;
    private String callerName;
    private Long dockId;
    private String dockCode;
    private Date callTime;
    private Date respondTime;
    private Date timeoutTime;
    private Date cancelTime;
    private Date createTime;
}
