package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.io.Serializable;
import java.util.Date;

@Data
public class YmsOverviewEventRespVO implements Serializable {

    private Date eventTime;
    /** CHECK_IN / CHECK_OUT / TASK / EXCEPTION */
    private String eventType;
    private String message;
    private Long refId;
}
