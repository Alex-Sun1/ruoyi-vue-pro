package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

@Data
public class YmsYardgoTaskRespVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long yardTaskId;
    private String yardTaskNo;
    private Long warehouseId;
    private Long dockId;
    private String dockCode;
    private String robotTaskId;
    private String robotStatus;
    private String taskType;
    private BigDecimal progress;
    private Date startTime;
    private Date finishTime;
    private String callbackPayload;
    private String remark;
    private Date createTime;
}
