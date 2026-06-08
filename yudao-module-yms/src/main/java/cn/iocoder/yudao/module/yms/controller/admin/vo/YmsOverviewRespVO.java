package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.util.List;

@Data
public class YmsOverviewRespVO {

    /** 今日 Check-in 成功数 */
    private int todayCheckIns;
    /** 当前在场（海柜+车厢资源） */
    private int inYardCount;
    /** 等待拆柜海柜数 */
    private int waitDevanningCount;
    /** 等待装车车厢数 */
    private int waitLoadingCount;
    /** Dock 总数 */
    private int totalDocks;
    /** Dock 占用数 */
    private int occupiedDocks;
    /** 空闲 Dock 数 */
    private int freeDocks;
    /** 异常任务/资源数 */
    private int exceptionCount;

    /** 调度统计（复用现有结构） */
    private YmsDispatchStatsRespVO dispatchStats;

    /** 最近事件流 */
    private List<YmsOverviewEventRespVO> recentEvents;

    /** 今日按小时 Check-in 趋势 */
    private List<YmsOverviewTrendRespVO> hourlyTrends;
    /** 等待超时数量（>120分钟） */
    private int timeoutWaitingCount;
}
