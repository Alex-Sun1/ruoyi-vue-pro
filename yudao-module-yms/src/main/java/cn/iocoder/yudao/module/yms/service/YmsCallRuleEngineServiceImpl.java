package cn.iocoder.yudao.module.yms.service;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.IdUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsAppointmentDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsCallRecordDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsCallRuleDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsCheckInDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsContainerResourceDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsTrailerResourceDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsYardTaskDO;
import cn.iocoder.yudao.module.yms.dal.dto.YmsCallResourceCandidate;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCallRuleConditionRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCallRuleSortRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCallRuleRespVO;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsAppointmentMapper;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsCallRecordMapper;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsCallRuleMapper;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsCheckInMapper;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsContainerResourceMapper;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsTrailerResourceMapper;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsYardTaskMapper;
import cn.iocoder.yudao.module.yms.service.YmsCallRuleEngineService;
import cn.iocoder.yudao.module.yms.service.YmsCallRuleService;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Objects;


@Service
public class YmsCallRuleEngineServiceImpl implements YmsCallRuleEngineService {

    private static final String RESOURCE_CONTAINER = "CONTAINER";
    private static final String RESOURCE_TRAILER = "TRAILER";

    @Resource
    private YmsCallRuleMapper callRuleMapper;
    @Resource
    private YmsCallRecordMapper callRecordMapper;
    @Resource
    private YmsContainerResourceMapper containerMapper;
    @Resource
    private YmsTrailerResourceMapper trailerMapper;
    @Resource
    private YmsYardTaskMapper yardTaskMapper;
    @Resource
    private YmsCheckInMapper checkInMapper;
    @Resource
    private YmsAppointmentMapper appointmentMapper;
    @Resource
    private YmsCallRuleService callRuleService;

    @Override
    public YmsCallRuleRespVO resolveRule(Long warehouseId, String taskType) {
        YmsCallRuleDO rule = callRuleMapper.selectOne(
            Wrappers.<YmsCallRuleDO>lambdaQuery()
                .eq(YmsCallRuleDO::getWarehouseId, warehouseId)
                .eq(YmsCallRuleDO::getTaskType, taskType)
                .eq(YmsCallRuleDO::getEnabled, 1)
                .eq(YmsCallRuleDO::getDeleted, 0)
                .orderByAsc(YmsCallRuleDO::getSortOrder)
                .last("LIMIT 1")
        );
        if (rule == null) {
            return null;
        }
        return callRuleService.queryById(rule.getId());
    }

    @Override
    public YmsCallResourceCandidate findNextCandidate(YmsCallRuleRespVO rule, String resourceType) {
        if (rule == null) {
            return null;
        }
        List<YmsCallResourceCandidate> candidates = loadCandidates(rule.getWarehouseId(), resourceType);
        return candidates.stream()
            .filter(c -> validateConditions(rule, c))
            .min(buildComparator(rule.getSorts()))
            .orElse(null);
    }

    @Override
    public boolean validateConditions(YmsCallRuleRespVO rule, YmsCallResourceCandidate resource) {
        if (rule == null || resource == null) {
            return true;
        }
        if (Objects.equals(rule.getWmsReadyRequired(), 1)) {
            if (!"READY".equalsIgnoreCase(StrUtil.blankToDefault(resource.getWmsReadyStatus(), ""))) {
                return false;
            }
        }
        if (Objects.equals(rule.getAppointmentRequired(), 1)) {
            if (resource.getAppointmentId() == null) {
                return false;
            }
        }
        List<YmsCallRuleConditionRespVO> conditions = rule.getConditions();
        if (conditions == null || conditions.isEmpty()) {
            return true;
        }
        for (YmsCallRuleConditionRespVO cond : conditions) {
            if (!matchCondition(cond, resource)) {
                return false;
            }
        }
        return true;
    }

    @Override
    public void recordCall(YmsCallRuleRespVO rule, YmsCallResourceCandidate resource, Long dockId, String dockCode, String callType) {
        if (resource == null || resource.getYardTaskId() == null) {
            return;
        }
        int callNo = callRecordMapper.countByYardTaskId(resource.getYardTaskId()) + 1;
        Date now = new Date();
        YmsCallRecordDO record = new YmsCallRecordDO();
        record.setId(IdUtil.getSnowflakeNextId());
        record.setWarehouseId(resource.getWarehouseId());
        record.setYardTaskId(resource.getYardTaskId());
        record.setYardTaskNo(resource.getYardTaskNo());
        record.setCallRuleId(rule != null ? rule.getId() : null);
        record.setCallNo(callNo);
        record.setCallStatus("CALLED");
        record.setCallType(StrUtil.blankToDefault(callType, "MANUAL"));
        record.setDockId(dockId);
        record.setDockCode(dockCode);
        record.setCallTime(now);
        if (rule != null && rule.getCallTimeoutMinutes() != null) {
            record.setTimeoutTime(new Date(now.getTime() + rule.getCallTimeoutMinutes() * 60_000L));
        }
        try {
            record.setCallerId(cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils.getLoginUserId());
            record.setCallerName(cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils.getLoginUserNickname());
        } catch (Exception ignored) {
            // 系统自动叫号时可能无登录用户
        }
        record.setCreateTime(now);
        callRecordMapper.insert(record);
    }

    @Override
    public YmsCallResourceCandidate buildCandidateFromContainer(YmsContainerResourceDO container) {
        YmsCallResourceCandidate candidate = YmsCallResourceCandidate.builder()
            .resourceType(RESOURCE_CONTAINER)
            .resourceId(container.getId())
            .resourceNo(container.getContainerNo())
            .warehouseId(container.getWarehouseId())
            .containerStatus(container.getContainerStatus())
            .yardPositionId(container.getYardPositionId())
            .arriveTime(container.getArrivedTime())
            .lfdReturn(container.getLfdReturn())
            .appointmentTime(container.getEtaTime())
            .priority(0)
            .customerLevel(0)
            .build();
        fillWaitingMinutes(candidate);
        resolveYardTaskForContainer(candidate, container);
        fillAppointmentFromCheckIn(candidate, container.getId(), null);
        return candidate;
    }

    @Override
    public YmsCallResourceCandidate buildCandidateFromTrailer(YmsTrailerResourceDO trailer) {
        YmsCallResourceCandidate candidate = YmsCallResourceCandidate.builder()
            .resourceType(RESOURCE_TRAILER)
            .resourceId(trailer.getId())
            .resourceNo(StrUtil.blankToDefault(trailer.getTrailerNo(), trailer.getPlateNo()))
            .warehouseId(trailer.getWarehouseId())
            .trailerStatus(trailer.getTrailerStatus())
            .wmsReadyStatus(trailer.getWmsReadyStatus())
            .wmsReadyTime(trailer.getWmsReadyTime())
            .yardPositionId(trailer.getYardPositionId())
            .arriveTime(trailer.getArriveTime())
            .priority(0)
            .customerLevel(0)
            .build();
        fillWaitingMinutes(candidate);
        if (trailer.getRelatedLoadingTaskId() != null) {
            YmsYardTaskDO task = yardTaskMapper.selectById(trailer.getRelatedLoadingTaskId());
            if (task != null) {
                candidate.setYardTaskId(task.getId());
                candidate.setYardTaskNo(task.getYardTaskNo());
            }
        }
        if (candidate.getYardTaskId() == null) {
            resolveYardTaskForTrailer(candidate, trailer);
        }
        fillAppointmentFromCheckIn(candidate, null, trailer.getId());
        return candidate;
    }

    private List<YmsCallResourceCandidate> loadCandidates(Long warehouseId, String resourceType) {
        List<YmsCallResourceCandidate> list = new ArrayList<>();
        if (RESOURCE_CONTAINER.equalsIgnoreCase(resourceType)) {
            List<YmsContainerResourceDO> rows = containerMapper.selectList(
                Wrappers.<YmsContainerResourceDO>lambdaQuery()
                    .eq(YmsContainerResourceDO::getWarehouseId, warehouseId)
                    .eq(YmsContainerResourceDO::getDeleted, 0)
                    .eq(YmsContainerResourceDO::getExceptionFlag, 0)
                    .in(YmsContainerResourceDO::getContainerStatus, "WAIT_DEVANNING", "YARD_ASSIGNED")
            );
            for (YmsContainerResourceDO row : rows) {
                list.add(buildCandidateFromContainer(row));
            }
        } else if (RESOURCE_TRAILER.equalsIgnoreCase(resourceType)) {
            List<YmsTrailerResourceDO> rows = trailerMapper.selectList(
                Wrappers.<YmsTrailerResourceDO>lambdaQuery()
                    .eq(YmsTrailerResourceDO::getWarehouseId, warehouseId)
                    .eq(YmsTrailerResourceDO::getDeleted, 0)
                    .eq(YmsTrailerResourceDO::getExceptionFlag, 0)
                    .in(YmsTrailerResourceDO::getTrailerStatus, "WAIT_LOADING", "ARRIVED_EMPTY")
            );
            for (YmsTrailerResourceDO row : rows) {
                list.add(buildCandidateFromTrailer(row));
            }
        }
        return list;
    }

    private Comparator<YmsCallResourceCandidate> buildComparator(List<YmsCallRuleSortRespVO> sorts) {
        if (sorts == null || sorts.isEmpty()) {
            return Comparator.comparing(YmsCallResourceCandidate::getArriveTime,
                Comparator.nullsLast(Date::compareTo));
        }
        Comparator<YmsCallResourceCandidate> combined = (a, b) -> 0;
        List<YmsCallRuleSortRespVO> ordered = sorts.stream()
            .sorted(Comparator.comparing(YmsCallRuleSortRespVO::getPriorityOrder, Comparator.nullsLast(Integer::compareTo)))
            .toList();
        for (YmsCallRuleSortRespVO sort : ordered) {
            Comparator<YmsCallResourceCandidate> fieldComp = fieldComparator(sort.getSortField());
            if ("DESC".equalsIgnoreCase(sort.getSortDirection())) {
                fieldComp = fieldComp.reversed();
            }
            combined = combined.thenComparing(fieldComp);
        }
        return combined;
    }

    private Comparator<YmsCallResourceCandidate> fieldComparator(String sortField) {
        return switch (StrUtil.blankToDefault(sortField, "")) {
            case "appointment_time" -> Comparator.comparing(YmsCallResourceCandidate::getAppointmentTime,
                Comparator.nullsLast(Date::compareTo));
            case "arrive_time" -> Comparator.comparing(YmsCallResourceCandidate::getArriveTime,
                Comparator.nullsLast(Date::compareTo));
            case "wms_ready_time" -> Comparator.comparing(YmsCallResourceCandidate::getWmsReadyTime,
                Comparator.nullsLast(Date::compareTo));
            case "lfd_return" -> Comparator.comparing(YmsCallResourceCandidate::getLfdReturn,
                Comparator.nullsLast(Date::compareTo));
            case "customer_level" -> Comparator.comparing(YmsCallResourceCandidate::getCustomerLevel,
                Comparator.nullsLast(Integer::compareTo));
            case "priority" -> Comparator.comparing(YmsCallResourceCandidate::getPriority,
                Comparator.nullsLast(Integer::compareTo));
            case "waiting_minutes" -> Comparator.comparing(YmsCallResourceCandidate::getWaitingMinutes,
                Comparator.nullsLast(Long::compareTo));
            default -> (a, b) -> 0;
        };
    }

    private boolean matchCondition(YmsCallRuleConditionRespVO cond, YmsCallResourceCandidate resource) {
        String actual = resolveFieldValue(cond.getConditionField(), resource);
        String expected = cond.getConditionValue();
        String op = StrUtil.blankToDefault(cond.getOperator(), "EQ").toUpperCase();
        return switch (op) {
            case "EQ" -> Objects.equals(actual, expected);
            case "NEQ" -> !Objects.equals(actual, expected);
            case "IN" -> expected != null && Arrays.asList(expected.split(",")).contains(actual);
            case "GTE" -> compareAsNumber(actual, expected) >= 0;
            case "LTE" -> compareAsNumber(actual, expected) <= 0;
            default -> Objects.equals(actual, expected);
        };
    }

    private String resolveFieldValue(String field, YmsCallResourceCandidate resource) {
        return switch (StrUtil.blankToDefault(field, "")) {
            case "container_status" -> StrUtil.blankToDefault(resource.getContainerStatus(), resource.getTrailerStatus());
            case "trailer_status" -> resource.getTrailerStatus();
            case "wms_status" -> resource.getWmsReadyStatus();
            case "yard_position_assigned" -> resource.getYardPositionId() != null ? "1" : "0";
            default -> null;
        };
    }

    private int compareAsNumber(String actual, String expected) {
        try {
            double a = Double.parseDouble(StrUtil.blankToDefault(actual, "0"));
            double b = Double.parseDouble(StrUtil.blankToDefault(expected, "0"));
            return Double.compare(a, b);
        } catch (NumberFormatException e) {
            return StrUtil.blankToDefault(actual, "").compareTo(StrUtil.blankToDefault(expected, ""));
        }
    }

    private void fillWaitingMinutes(YmsCallResourceCandidate candidate) {
        if (candidate.getArriveTime() != null) {
            candidate.setWaitingMinutes((System.currentTimeMillis() - candidate.getArriveTime().getTime()) / 60_000L);
        }
    }

    private void resolveYardTaskForContainer(YmsCallResourceCandidate candidate, YmsContainerResourceDO container) {
        YmsYardTaskDO task = yardTaskMapper.selectOne(
            Wrappers.<YmsYardTaskDO>lambdaQuery()
                .eq(YmsYardTaskDO::getWarehouseId, container.getWarehouseId())
                .eq(YmsYardTaskDO::getContainerNo, container.getContainerNo())
                .notIn(YmsYardTaskDO::getYardStatus, "LEFT_YARD", "CANCELLED")
                .orderByDesc(YmsYardTaskDO::getCreateTime)
                .last("LIMIT 1")
        );
        if (task != null) {
            candidate.setYardTaskId(task.getId());
            candidate.setYardTaskNo(task.getYardTaskNo());
        }
    }

    private void resolveYardTaskForTrailer(YmsCallResourceCandidate candidate, YmsTrailerResourceDO trailer) {
        YmsYardTaskDO task = yardTaskMapper.selectOne(
            Wrappers.<YmsYardTaskDO>lambdaQuery()
                .eq(YmsYardTaskDO::getWarehouseId, trailer.getWarehouseId())
                .eq(YmsYardTaskDO::getTruckNo, StrUtil.blankToDefault(trailer.getPlateNo(), trailer.getTrailerNo()))
                .notIn(YmsYardTaskDO::getYardStatus, "LEFT_YARD", "CANCELLED")
                .orderByDesc(YmsYardTaskDO::getCreateTime)
                .last("LIMIT 1")
        );
        if (task != null) {
            candidate.setYardTaskId(task.getId());
            candidate.setYardTaskNo(task.getYardTaskNo());
        }
    }

    private void fillAppointmentFromCheckIn(YmsCallResourceCandidate candidate, Long containerId, Long trailerId) {
        YmsCheckInDO checkIn = checkInMapper.selectOne(
            Wrappers.<YmsCheckInDO>lambdaQuery()
                .eq(containerId != null, YmsCheckInDO::getContainerResourceId, containerId)
                .eq(trailerId != null, YmsCheckInDO::getTrailerResourceId, trailerId)
                .isNull(YmsCheckInDO::getCheckOutTime)
                .orderByDesc(YmsCheckInDO::getCheckInTime)
                .last("LIMIT 1")
        );
        if (checkIn == null) {
            return;
        }
        if (checkIn.getAptId() != null) {
            candidate.setAppointmentId(checkIn.getAptId());
            YmsAppointmentDO apt = appointmentMapper.selectById(checkIn.getAptId());
            if (apt != null && apt.getAptDate() != null) {
                candidate.setAppointmentTime(DateUtil.parseDate(apt.getAptDate()));
            }
        }
        if (candidate.getYardTaskId() == null && checkIn.getYardTaskId() != null) {
            candidate.setYardTaskId(checkIn.getYardTaskId());
            candidate.setYardTaskNo(checkIn.getYardTaskNo());
        }
    }

}
