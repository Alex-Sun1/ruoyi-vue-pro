package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class YmsRobotCallbackReqVO {
    private String robotTaskId;
    /** RUNNING / PAUSED / COMPLETED / FAILED */
    private String status;
    private BigDecimal progress;
    private String payload;
}
