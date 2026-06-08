package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;
import java.util.Map;

@Data
public class YmsDispatchStatsRespVO {
    private int totalTasks;
    private int waitingTasks;
    private int workingTasks;
    private int devanningTasks;
    private int loadingTasks;
    private int finishedTasks;
    private int inYardVehicles;
    private int totalDocks;
    private int occupiedDocks;
    /** 各状态任务数量，key=yardStatus，value=count */
    private Map<String, Integer> statusCounts;
}
