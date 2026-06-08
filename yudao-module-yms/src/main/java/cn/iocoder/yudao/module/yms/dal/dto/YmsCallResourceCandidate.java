package cn.iocoder.yudao.module.yms.dal.dto;

import lombok.Builder;
import lombok.Data;

import java.util.Date;

/** 叫号候选资源（海柜/车厢统一排序载体） */
@Data
@Builder
public class YmsCallResourceCandidate {

    private String resourceType;
    private Long resourceId;
    private String resourceNo;
    private Long warehouseId;
    private Long yardTaskId;
    private String yardTaskNo;

    private Date appointmentTime;
    private Date arriveTime;
    private Date wmsReadyTime;
    private Date lfdReturn;
    private Integer customerLevel;
    private Integer priority;
    private Long waitingMinutes;

    private String containerStatus;
    private String trailerStatus;
    private String wmsReadyStatus;
    private Long yardPositionId;
    private Long appointmentId;

}
