package cn.iocoder.yudao.module.yms.service;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsCheckInDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsContainerResourceDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsTrailerResourceDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsYardTaskDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsYardTaskLogDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsDispatchStatsRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsOverviewEventRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsOverviewTrendRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsOverviewRespVO;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsCheckInMapper;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsContainerResourceMapper;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsTrailerResourceMapper;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsYardTaskLogMapper;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsYardTaskMapper;
import cn.iocoder.yudao.module.yms.service.YmsDispatchService;
import cn.iocoder.yudao.module.yms.service.YmsOverviewService;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;


@Service
public class YmsOverviewServiceImpl implements YmsOverviewService {

    private static final Set<String> WAIT_DEVANNING_STATUS = Set.of(
        "ARRIVED", "YARD_ASSIGNED", "DROPPED", "WAIT_DEVANNING", "CALLED");
    private static final Set<String> WAIT_LOADING_STATUS = Set.of("ARRIVED_EMPTY", "WAIT_LOADING");

    @Resource
    private YmsCheckInMapper checkInMapper;
    @Resource
    private YmsContainerResourceMapper containerResourceMapper;
    @Resource
    private YmsTrailerResourceMapper trailerResourceMapper;
    @Resource
    private YmsYardTaskMapper yardTaskMapper;
    @Resource
    private YmsYardTaskLogMapper taskLogMapper;
    @Resource
    private YmsDispatchService dispatchService;

    @Override
    public YmsOverviewRespVO queryOverview(Long warehouseId) {
        YmsOverviewRespVO vo = new YmsOverviewRespVO();
        String today = LocalDate.now().format(DateTimeFormatter.ISO_DATE);

        
        vo.setTodayCheckIns(checkInMapper.selectCount(
            Wrappers.<YmsCheckInDO>lambdaQuery()
                .eq(warehouseId != null, YmsCheckInDO::getWarehouseId, warehouseId)
                .eq(YmsCheckInDO::getCheckResult, "PASSED")
                .apply("date(check_in_time) = curdate()")).intValue());

        vo.setInYardCount(countInYard(warehouseId));
        vo.setWaitDevanningCount(countContainers(warehouseId, WAIT_DEVANNING_STATUS));
        vo.setWaitLoadingCount(countTrailers(warehouseId, WAIT_LOADING_STATUS));
        vo.setExceptionCount(countExceptions(warehouseId));

        YmsDispatchStatsRespVO dispatchStats = dispatchService.queryStats(warehouseId, null);
        vo.setDispatchStats(dispatchStats);
        vo.setTotalDocks(dispatchStats.getTotalDocks());
        vo.setOccupiedDocks(dispatchStats.getOccupiedDocks());
        vo.setFreeDocks(Math.max(dispatchStats.getTotalDocks() - dispatchStats.getOccupiedDocks(), 0));

        vo.setRecentEvents(buildRecentEvents(warehouseId, 50));
        vo.setHourlyTrends(buildHourlyTrends(warehouseId));
        vo.setTimeoutWaitingCount(countTimeoutWaiting(warehouseId));
        return vo;
    }

    private List<YmsOverviewTrendRespVO> buildHourlyTrends(Long warehouseId) {
        List<YmsCheckInDO> checkIns = checkInMapper.selectList(
            Wrappers.<YmsCheckInDO>lambdaQuery()
                .eq(warehouseId != null, YmsCheckInDO::getWarehouseId, warehouseId)
                .eq(YmsCheckInDO::getCheckResult, "PASSED")
                .apply("date(check_in_time) = curdate()"));
        Map<Integer, Integer> hourMap = new HashMap<>();
        for (YmsCheckInDO c : checkIns) {
            if (c.getCheckInTime() == null) continue;
            int h = c.getCheckInTime().toInstant().atZone(java.time.ZoneId.systemDefault()).getHour();
            hourMap.merge(h, 1, Integer::sum);
        }
        List<YmsOverviewTrendRespVO> trends = new ArrayList<>();
        for (int h = 0; h < 24; h++) {
            YmsOverviewTrendRespVO t = new YmsOverviewTrendRespVO();
            t.setHour(h);
            t.setCheckInCount(hourMap.getOrDefault(h, 0));
            trends.add(t);
        }
        return trends;
    }

    private int countTimeoutWaiting(Long warehouseId) {
        int timeoutMinutes = 120;
        int containers = containerResourceMapper.selectCount(
            Wrappers.<YmsContainerResourceDO>lambdaQuery()
                .eq(warehouseId != null, YmsContainerResourceDO::getWarehouseId, warehouseId)
                .in(YmsContainerResourceDO::getContainerStatus, WAIT_DEVANNING_STATUS)
                .apply("arrived_time IS NOT NULL AND TIMESTAMPDIFF(MINUTE, arrived_time, NOW()) > " + timeoutMinutes))
            .intValue();
        int trailers = trailerResourceMapper.selectCount(
            Wrappers.<YmsTrailerResourceDO>lambdaQuery()
                .eq(warehouseId != null, YmsTrailerResourceDO::getWarehouseId, warehouseId)
                .in(YmsTrailerResourceDO::getTrailerStatus, WAIT_LOADING_STATUS)
                .apply("arrive_time IS NOT NULL AND TIMESTAMPDIFF(MINUTE, arrive_time, NOW()) > " + timeoutMinutes))
            .intValue();
        return containers + trailers;
    }

    private int countInYard(Long warehouseId) {
        int containers = containerResourceMapper.selectCount(
            Wrappers.<YmsContainerResourceDO>lambdaQuery()
                .eq(warehouseId != null, YmsContainerResourceDO::getWarehouseId, warehouseId)
                .notIn(YmsContainerResourceDO::getContainerStatus, "LEFT_YARD", "RETURNED", "EXPECTED_ARRIVAL"))
            .intValue();
        int trailers = trailerResourceMapper.selectCount(
            Wrappers.<YmsTrailerResourceDO>lambdaQuery()
                .eq(warehouseId != null, YmsTrailerResourceDO::getWarehouseId, warehouseId)
                .notIn(YmsTrailerResourceDO::getTrailerStatus, "LEFT_YARD", "EXPECTED_ARRIVAL"))
            .intValue();
        return containers + trailers;
    }

    private int countContainers(Long warehouseId, Set<String> statuses) {
        return containerResourceMapper.selectCount(
            Wrappers.<YmsContainerResourceDO>lambdaQuery()
                .eq(warehouseId != null, YmsContainerResourceDO::getWarehouseId, warehouseId)
                .in(YmsContainerResourceDO::getContainerStatus, statuses))
            .intValue();
    }

    private int countTrailers(Long warehouseId, Set<String> statuses) {
        return trailerResourceMapper.selectCount(
            Wrappers.<YmsTrailerResourceDO>lambdaQuery()
                .eq(warehouseId != null, YmsTrailerResourceDO::getWarehouseId, warehouseId)
                .in(YmsTrailerResourceDO::getTrailerStatus, statuses))
            .intValue();
    }

    private int countExceptions(Long warehouseId) {
        int tasks = yardTaskMapper.selectCount(
            Wrappers.<YmsYardTaskDO>lambdaQuery()
                .eq(warehouseId != null, YmsYardTaskDO::getWarehouseId, warehouseId)
                .and(w -> w.eq(YmsYardTaskDO::getExceptionFlag, 1)
                    .or().eq(YmsYardTaskDO::getYardStatus, "EXCEPTION_PROCESSING")))
            .intValue();
        int containers = containerResourceMapper.selectCount(
            Wrappers.<YmsContainerResourceDO>lambdaQuery()
                .eq(warehouseId != null, YmsContainerResourceDO::getWarehouseId, warehouseId)
                .eq(YmsContainerResourceDO::getContainerStatus, "EXCEPTION"))
            .intValue();
        int trailers = trailerResourceMapper.selectCount(
            Wrappers.<YmsTrailerResourceDO>lambdaQuery()
                .eq(warehouseId != null, YmsTrailerResourceDO::getWarehouseId, warehouseId)
                .eq(YmsTrailerResourceDO::getTrailerStatus, "EXCEPTION"))
            .intValue();
        return tasks + containers + trailers;
    }

    private List<YmsOverviewEventRespVO> buildRecentEvents(Long warehouseId, int limit) {
        List<YmsOverviewEventRespVO> events = new ArrayList<>();

        List<YmsCheckInDO> checkIns = checkInMapper.selectList(
            Wrappers.<YmsCheckInDO>lambdaQuery()
                .eq(warehouseId != null, YmsCheckInDO::getWarehouseId, warehouseId)
                .in(YmsCheckInDO::getCheckResult, "PASSED", "PENDING", "REJECTED", "BLACKLISTED")
                .orderByDesc(YmsCheckInDO::getCheckInTime)
                .last("LIMIT 20"));
        for (YmsCheckInDO c : checkIns) {
            YmsOverviewEventRespVO e = new YmsOverviewEventRespVO();
            e.setEventTime(c.getCheckInTime());
            e.setEventType("CHECK_IN");
            e.setRefId(c.getId());
            String plate = StrUtil.blankToDefault(c.getPlateNo(), "—");
            e.setMessage("车牌 " + plate + " Check-in " + formatCheckResult(c.getCheckResult()));
            events.add(e);
        }

        List<YmsCheckInDO> checkOuts = checkInMapper.selectList(
            Wrappers.<YmsCheckInDO>lambdaQuery()
                .eq(warehouseId != null, YmsCheckInDO::getWarehouseId, warehouseId)
                .isNotNull(YmsCheckInDO::getCheckOutTime)
                .orderByDesc(YmsCheckInDO::getCheckOutTime)
                .last("LIMIT 20"));
        for (YmsCheckInDO c : checkOuts) {
            YmsOverviewEventRespVO e = new YmsOverviewEventRespVO();
            e.setEventTime(c.getCheckOutTime());
            e.setEventType("CHECK_OUT");
            e.setRefId(c.getId());
            String plate = StrUtil.blankToDefault(c.getPlateNo(), "—");
            e.setMessage("车牌 " + plate + " 离场");
            events.add(e);
        }

        List<Long> taskIds = yardTaskMapper.selectList(
                Wrappers.<YmsYardTaskDO>lambdaQuery()
                    .eq(warehouseId != null, YmsYardTaskDO::getWarehouseId, warehouseId)
                    .select(YmsYardTaskDO::getId))
            .stream().map(YmsYardTaskDO::getId).collect(Collectors.toList());

        if (!taskIds.isEmpty()) {
            List<YmsYardTaskLogDO> logs = taskLogMapper.selectList(
                Wrappers.<YmsYardTaskLogDO>lambdaQuery()
                    .in(YmsYardTaskLogDO::getYardTaskId, taskIds)
                    .orderByDesc(YmsYardTaskLogDO::getActionTime)
                    .last("LIMIT 30"));
            for (YmsYardTaskLogDO log : logs) {
                YmsOverviewEventRespVO e = new YmsOverviewEventRespVO();
                e.setEventTime(log.getActionTime());
                e.setEventType("TASK");
                e.setRefId(log.getYardTaskId());
                e.setMessage(StrUtil.blankToDefault(log.getActionContent(),
                    log.getActionType() + " " + StrUtil.blankToDefault(log.getAfterStatus(), "")));
                events.add(e);
            }
        }

        return events.stream()
            .filter(e -> e.getEventTime() != null)
            .sorted(Comparator.comparing(YmsOverviewEventRespVO::getEventTime).reversed())
            .limit(limit)
            .collect(Collectors.toList());
    }

    private String formatCheckResult(String result) {
        return switch (result) {
            case "PASSED" -> "通过";
            case "PENDING" -> "待确认";
            case "REJECTED" -> "拦截";
            case "BLACKLISTED" -> "黑名单";
            default -> result;
        };
    }
}
