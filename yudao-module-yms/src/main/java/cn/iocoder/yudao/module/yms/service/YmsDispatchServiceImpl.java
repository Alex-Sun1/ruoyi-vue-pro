package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.module.yms.util.YmsPageUtils;

import cn.hutool.core.util.IdUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.module.base.dal.dataobject.yarddock.YardDockDO;
import cn.iocoder.yudao.module.base.dal.mysql.yarddock.YardDockMapper;
import cn.iocoder.yudao.framework.common.exception.ServiceException;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsDockQueueDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsInternalTaskDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsYardTaskDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsYardTaskLogDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.*;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsDockBoardRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsDispatchStatsRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardTaskLogRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardTaskRespVO;
import cn.iocoder.yudao.module.yms.integration.YmsSourceOrderSyncHandler;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsContainerResourceDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsTrailerResourceDO;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsContainerResourceMapper;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsDockQueueMapper;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsInternalTaskMapper;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsTrailerResourceMapper;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsYardTaskLogMapper;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsYardTaskMapper;
import cn.iocoder.yudao.module.yms.service.YmsDispatchService;
import cn.iocoder.yudao.module.yms.service.YmsInternalTaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;


@Service
public class YmsDispatchServiceImpl implements YmsDispatchService {

    private static final Set<String> TERMINAL = Set.of("LEFT_YARD", "CANCELLED", "EXCEPTION_CLOSED");
    private static final Set<String> WORKING   = Set.of("DOCK_WORKING", "DEVANNING", "LOADING", "OPERATION_PAUSED");
    private static final Set<String> PAUSABLE  = Set.of("DOCK_WORKING", "DEVANNING", "LOADING");
    private static final Set<String> CONTAINER_ON_DOCK_STATUS = Set.of("ON_DOCK", "DEVANNING", "WMS_WORKING");
    private static final Set<String> TRAILER_ON_DOCK_STATUS = Set.of("ON_DOCK", "LOADING");
    private static final Set<String> DEVANNING_DOCK_TYPES = Set.of("CONTAINER_DOCK", "MIXED_DOCK", "UNLOADING", "DEVANNING");
    private static final Set<String> LOADING_DOCK_TYPES   = Set.of("TRUCK_DOCK", "SELF_PICKUP_DOCK", "MIXED_DOCK", "LOADING");
    private static final String PAUSED_FROM_PREFIX = "PAUSED:";

    @Resource
    private YmsYardTaskMapper   yardTaskMapper;
    @Resource
    private YmsDockQueueMapper  dockQueueMapper;
    @Resource
    private YmsYardTaskLogMapper taskLogMapper;
    @Resource
    private YardDockMapper      yardDockMapper;
    @Resource
    private YmsContainerResourceMapper containerResourceMapper;
    @Resource
    private YmsTrailerResourceMapper   trailerResourceMapper;
    @Resource
    private YmsInternalTaskMapper      internalTaskMapper;
    @Resource
    private YmsInternalTaskService    internalTaskService;
    @Autowired(required = false)
    private List<YmsSourceOrderSyncHandler> sourceOrderSyncHandlers;

    // ─── 查询 ───────────────────────────────────────────

    @Override
    public PageResult<YmsYardTaskRespVO> queryPageList(YmsYardTaskQueryReqVO bo, PageParam pageParam) {
        return YmsPageUtils.toPageResult(yardTaskMapper.selectPageList(YmsPageUtils.toPage(pageParam), bo));
    }

    @Override
    public YmsYardTaskRespVO queryById(Long id) {
        return BeanUtils.toBean(yardTaskMapper.selectById(id), YmsYardTaskRespVO.class);
    }

    @Override
    public List<YmsDockBoardRespVO> queryDockBoard(Long warehouseId, String taskGroup) {
        LambdaQueryWrapper<YardDockDO> dq = Wrappers.lambdaQuery();
        dq.eq(warehouseId != null, YardDockDO::getWarehouseId, warehouseId)
          .eq(YardDockDO::getLocationType, "DOCK")
          .eq(YardDockDO::getEnabledFlag, 1);
        applyDockTypeFilter(dq, taskGroup);
        dq.orderByAsc(YardDockDO::getDockLocation)
          .orderByAsc(YardDockDO::getGridRow)
          .orderByAsc(YardDockDO::getGridCol);
        List<YardDockDO> docks = new ArrayList<>(yardDockMapper.selectList(dq));

        // 补充：dockType 与过滤条件不符，但当前有该类型活跃任务的 Dock 也加入看板。
        // 防止任务被分配到配置类型不匹配的 Dock 时整个卡片消失。
        if (taskGroup != null) {
            Set<String> matchTaskTypes = "DEVANNING".equals(taskGroup) ? DEVANNING_TYPES : LOADING_TYPES;
            Set<Long> existingIds = docks.stream().map(YardDockDO::getId).collect(Collectors.toSet());
            List<Long> extraDockIds = yardTaskMapper.selectList(
                    Wrappers.<YmsYardTaskDO>lambdaQuery()
                        .in(YmsYardTaskDO::getTaskType, matchTaskTypes)
                        .notIn(YmsYardTaskDO::getYardStatus, TERMINAL)
                        .isNotNull(YmsYardTaskDO::getDockId)
                        .eq(warehouseId != null, YmsYardTaskDO::getWarehouseId, warehouseId))
                .stream()
                .map(YmsYardTaskDO::getDockId)
                .filter(id -> !existingIds.contains(id))
                .distinct()
                .toList();
            if (!extraDockIds.isEmpty()) {
                docks.addAll(yardDockMapper.selectList(
                    Wrappers.<YardDockDO>lambdaQuery().in(YardDockDO::getId, extraDockIds)));
                docks.sort(Comparator
                    .comparing(YardDockDO::getDockLocation, Comparator.nullsLast(Comparator.naturalOrder()))
                    .thenComparingInt(d -> d.getGridRow() == null ? 0 : d.getGridRow())
                    .thenComparingInt(d -> d.getGridCol() == null ? 0 : d.getGridCol()));
            }
        }

        if (docks.isEmpty()) return List.of();

        List<Long> dockIds = docks.stream().map(YardDockDO::getId).collect(Collectors.toList());

        // 活跃任务（已分配Dock且非终态）
        Map<Long, List<YmsYardTaskDO>> tasksByDock = yardTaskMapper.selectList(
            Wrappers.<YmsYardTaskDO>lambdaQuery()
                .in(YmsYardTaskDO::getDockId, dockIds)
                .notIn(YmsYardTaskDO::getYardStatus, TERMINAL))
            .stream().collect(Collectors.groupingBy(YmsYardTaskDO::getDockId));

        // 排队记录
        Map<Long, List<YmsDockQueueDO>> queuesByDock = dockQueueMapper.selectList(
            Wrappers.<YmsDockQueueDO>lambdaQuery()
                .in(YmsDockQueueDO::getDockId, dockIds)
                .eq(YmsDockQueueDO::getQueueStatus, "WAITING")
                .orderByAsc(YmsDockQueueDO::getQueueNo))
            .stream().collect(Collectors.groupingBy(YmsDockQueueDO::getDockId));

        return docks.stream().map(dock -> {
            YmsDockBoardRespVO vo = toDockBoardVo(dock);
            List<YmsYardTaskDO> tasks = tasksByDock.getOrDefault(dock.getId(), List.of());
            Map<Long, YmsYardTaskDO> tasksById = tasks.stream()
                .collect(Collectors.toMap(YmsYardTaskDO::getId, t -> t));

            tasks.stream().filter(t -> "DOCK_ASSIGNED".equals(t.getYardStatus()) || WORKING.contains(t.getYardStatus())).findFirst()
                .ifPresent(t -> vo.setActiveTask(toTaskVo(t)));

            tasks.stream()
                .filter(t -> "ARRIVED".equals(t.getYardStatus()) && hasOpenDockInTask(t.getId(), dock.getId()))
                .forEach(t -> vo.getIncomingTasks().add(toTaskVo(t)));

            queuesByDock.getOrDefault(dock.getId(), List.of()).forEach(q -> {
                YmsYardTaskDO t = tasksById.get(q.getYardTaskId());
                if (t != null) vo.getQueuedTasks().add(toTaskVo(t));
            });
            return vo;
        }).collect(Collectors.toList());
    }

    private static final Set<String> DEVANNING_TYPES = Set.of("DEVANNING");
    private static final Set<String> LOADING_TYPES  = Set.of("DELIVERY_LOADING","TRANSFER_LOADING","PICKUP_LOADING","RETURN_LOADING");

    @Override
    public YmsDispatchStatsRespVO queryStats(Long warehouseId, String taskGroup) {
        List<YmsYardTaskDO> tasks = yardTaskMapper.selectList(
            Wrappers.<YmsYardTaskDO>lambdaQuery()
                .eq(warehouseId != null, YmsYardTaskDO::getWarehouseId, warehouseId)
                .notIn(YmsYardTaskDO::getYardStatus, TERMINAL));

        YmsDispatchStatsRespVO s = new YmsDispatchStatsRespVO();
        s.setTotalTasks(tasks.size());
        for (YmsYardTaskDO t : tasks) {
            String st = t.getYardStatus();
            if (Set.of("CREATED","PRE_ARRIVAL","ARRIVED","WAITING","QUEUED","DOCK_ASSIGNED").contains(st))
                s.setWaitingTasks(s.getWaitingTasks() + 1);
            if (WORKING.contains(st))           s.setWorkingTasks(s.getWorkingTasks() + 1);
            if ("DEVANNING".equals(st))         s.setDevanningTasks(s.getDevanningTasks() + 1);
            if ("LOADING".equals(st))           s.setLoadingTasks(s.getLoadingTasks() + 1);
            if (Set.of("OPERATION_FINISHED","RELEASED").contains(st))
                s.setFinishedTasks(s.getFinishedTasks() + 1);
            if (t.getGateInTime() != null && t.getGateOutTime() == null)
                s.setInYardVehicles(s.getInYardVehicles() + 1);
        }
        if (warehouseId != null) {
            LambdaQueryWrapper<YardDockDO> dockCountQ = Wrappers.lambdaQuery();
            dockCountQ.eq(YardDockDO::getWarehouseId, warehouseId)
                .eq(YardDockDO::getLocationType, "DOCK")
                .eq(YardDockDO::getEnabledFlag, 1);
            applyDockTypeFilter(dockCountQ, taskGroup);
            s.setTotalDocks(yardDockMapper.selectCount(dockCountQ).intValue());
        }
        s.setOccupiedDocks((int) tasks.stream()
            .filter(t -> t.getDockId() != null && WORKING.contains(t.getYardStatus()))
            .map(YmsYardTaskDO::getDockId).distinct().count());
        // 按 taskGroup 过滤后再统计各状态数量，供前端状态 Tab 显示
        List<YmsYardTaskDO> countSource = tasks;
        if ("DEVANNING".equals(taskGroup)) {
            countSource = tasks.stream().filter(t -> DEVANNING_TYPES.contains(t.getTaskType())).toList();
        } else if ("LOADING".equals(taskGroup)) {
            countSource = tasks.stream().filter(t -> LOADING_TYPES.contains(t.getTaskType())).toList();
        }
        Map<String, Integer> statusCounts = countSource.stream().collect(
            Collectors.groupingBy(YmsYardTaskDO::getYardStatus, Collectors.summingInt(t -> 1)));
        s.setStatusCounts(statusCounts);
        return s;
    }

    // ─── 业务动作 ────────────────────────────────────────

    @Override
    @Transactional(rollbackFor = Exception.class, propagation = Propagation.REQUIRES_NEW)
    public YmsYardTaskRespVO pushTask(YmsPushTaskReqVO bo) {
        String key = bo.getSourceOrderType() + ":" + bo.getSourceOrderId();
        YmsYardTaskDO existing = yardTaskMapper.selectOne(
            Wrappers.<YmsYardTaskDO>lambdaQuery().eq(YmsYardTaskDO::getActiveTaskKey, key));

        if (existing != null) {
            // 幂等更新快照
            yardTaskMapper.update(null, Wrappers.<YmsYardTaskDO>lambdaUpdate()
                .eq(YmsYardTaskDO::getId, existing.getId())
                .set(StrUtil.isNotBlank(bo.getTruckNo()),      YmsYardTaskDO::getTruckNo,      bo.getTruckNo())
                .set(StrUtil.isNotBlank(bo.getDriverName()),   YmsYardTaskDO::getDriverName,   bo.getDriverName())
                .set(StrUtil.isNotBlank(bo.getDriverPhone()),  YmsYardTaskDO::getDriverPhone,  bo.getDriverPhone())
                .set(bo.getEtaYardTime() != null,              YmsYardTaskDO::getEtaYardTime,  bo.getEtaYardTime())
                .set(StrUtil.isNotBlank(bo.getContainerNo()),  YmsYardTaskDO::getContainerNo,  bo.getContainerNo()));
            return BeanUtils.toBean(yardTaskMapper.selectById(existing.getId()), YmsYardTaskRespVO.class);
        }

        int visitNo = yardTaskMapper.selectCount(
            Wrappers.<YmsYardTaskDO>lambdaQuery()
                .eq(YmsYardTaskDO::getSourceOrderType, bo.getSourceOrderType())
                .eq(YmsYardTaskDO::getSourceOrderId,   bo.getSourceOrderId())).intValue() + 1;

        YmsYardTaskDO task = buildTask(bo.getTaskType(), bo.getWarehouseId(),
            bo.getSourceOrderType(), bo.getSourceOrderId(), bo.getSourceOrderNo(),
            bo.getContainerNo(), bo.getTruckNo(), bo.getDriverName(), bo.getDriverPhone(),
            bo.getEtaYardTime(), visitNo, "PRE_ARRIVAL", "OMS_PUSH", null);
        yardTaskMapper.insert(task);
        writeLog(task.getId(), "TASK_CREATED", null, "PRE_ARRIVAL", "OMS推送创建");
        return BeanUtils.toBean(yardTaskMapper.selectById(task.getId()), YmsYardTaskRespVO.class);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public YmsYardTaskRespVO createTask(YmsYardTaskCreateReqVO bo) {
        boolean isManual = "MANUAL".equals(bo.getSourceOrderType());
        int visitNo = 1;
        if (!isManual) {
            String key = bo.getSourceOrderType() + ":" + bo.getSourceOrderId();
            if (yardTaskMapper.selectOne(
                Wrappers.<YmsYardTaskDO>lambdaQuery().eq(YmsYardTaskDO::getActiveTaskKey, key)) != null) {
                throw new ServiceException(500, "该来源单据已有活跃园区任务");
            }
            visitNo = yardTaskMapper.selectCount(
                Wrappers.<YmsYardTaskDO>lambdaQuery()
                    .eq(YmsYardTaskDO::getSourceOrderType, bo.getSourceOrderType())
                    .eq(YmsYardTaskDO::getSourceOrderId,   bo.getSourceOrderId())).intValue() + 1;
        }

        YmsYardTaskDO task = buildTask(bo.getTaskType(), bo.getWarehouseId(),
            bo.getSourceOrderType(), bo.getSourceOrderId(), bo.getSourceOrderNo(),
            bo.getContainerNo(), bo.getTruckNo(), bo.getDriverName(), bo.getDriverPhone(),
            bo.getEtaYardTime(), visitNo, "CREATED", "MANUAL", bo.getRemark());
        yardTaskMapper.insert(task);
        writeLog(task.getId(), "TASK_CREATED", null, "CREATED", "手动创建");
        return BeanUtils.toBean(yardTaskMapper.selectById(task.getId()), YmsYardTaskRespVO.class);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean checkIn(Long taskId) {
        YmsYardTaskDO task = require(taskId);
        assertStatus(task, Set.of("CREATED", "PRE_ARRIVAL"), "签到");
        return doUpdate(task, "ARRIVED",
            Wrappers.<YmsYardTaskDO>lambdaUpdate()
                .eq(YmsYardTaskDO::getId, taskId)
                .set(YmsYardTaskDO::getYardStatus, "ARRIVED")
                .set(YmsYardTaskDO::getGateInTime, new Date()));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean assignDock(YmsAssignDockReqVO bo) {
        YmsYardTaskDO task = require(bo.getYardTaskId());

        if (bo.getDockId() == null) {
            // 取消分配
            Long releasedDockId = task.getDockId();
            boolean shouldPromoteQueue = releasedDockId != null && !"QUEUED".equals(task.getYardStatus());
            dockQueueMapper.delete(Wrappers.<YmsDockQueueDO>lambdaQuery()
                .eq(YmsDockQueueDO::getYardTaskId, task.getId())
                .eq(YmsDockQueueDO::getQueueStatus, "WAITING"));
            cancelOpenDockInTasks(task.getId(), null);
            boolean ok = doUpdate(task, "ARRIVED",
                Wrappers.<YmsYardTaskDO>lambdaUpdate()
                    .eq(YmsYardTaskDO::getId, task.getId())
                    .set(YmsYardTaskDO::getYardStatus, "ARRIVED")
                    .set(YmsYardTaskDO::getDockId, null)
                    .set(YmsYardTaskDO::getDockCode, null)
                    .set(YmsYardTaskDO::getDockAssignTime, null));
            if (ok && shouldPromoteQueue) {
                promoteNextQueue(releasedDockId);
            }
            return ok;
        }

        if (LOADING_TYPES.contains(task.getTaskType()) && "PENDING".equals(task.getWmsReadyStatus())) {
            throw new ServiceException(500, "WMS备货未完成，暂不可分配Dock");
        }

        YardDockDO dock = yardDockMapper.selectById(bo.getDockId());
        if (dock == null) throw new ServiceException(500, "Dock不存在");
        if (Set.of("DISABLED", "MAINTENANCE").contains(dock.getDockStatus()))
            throw new ServiceException(500, "Dock当前不可用：" + dock.getDockStatus());

        boolean busy = yardTaskMapper.selectCount(
            Wrappers.<YmsYardTaskDO>lambdaQuery()
                .ne(YmsYardTaskDO::getId, task.getId())
                .eq(YmsYardTaskDO::getDockId, bo.getDockId())
                .in(YmsYardTaskDO::getYardStatus, Set.of("DOCK_ASSIGNED","DOCK_WORKING","DEVANNING","LOADING","OPERATION_PAUSED"))) > 0;
        boolean incomingBusy = internalTaskMapper.selectCount(
            Wrappers.<YmsInternalTaskDO>lambdaQuery()
                .ne(YmsInternalTaskDO::getParentYardTaskId, task.getId())
                .eq(YmsInternalTaskDO::getInternalTaskType, "DOCK_IN")
                .eq(YmsInternalTaskDO::getToDockId, bo.getDockId())
                .notIn(YmsInternalTaskDO::getTaskStatus, "COMPLETED", "FAILED", "CANCELLED")) > 0;

        if (busy || incomingBusy) {
            if (dock.getEnableQueue() == null || dock.getEnableQueue() == 0)
                throw new ServiceException(500, "该Dock未开启排队功能");
            long cnt = dockQueueMapper.selectCount(
                Wrappers.<YmsDockQueueDO>lambdaQuery()
                    .eq(YmsDockQueueDO::getDockId, bo.getDockId())
                    .eq(YmsDockQueueDO::getQueueStatus, "WAITING"));
            if (dock.getMaxQueueCount() != null && cnt >= dock.getMaxQueueCount())
                throw new ServiceException(500, "该Dock排队已满（最大" + dock.getMaxQueueCount() + "）");

            YmsDockQueueDO q = new YmsDockQueueDO();
            q.setId(IdUtil.getSnowflakeNextId());
            q.setDockId(dock.getId());
            q.setYardTaskId(task.getId());
            q.setContainerNo(task.getContainerNo() != null ? task.getContainerNo() : task.getSourceOrderNo());
            q.setQueueNo((int) (cnt + 1));
            q.setQueueStatus("WAITING");
            q.setQueuedTime(new Date());
            dockQueueMapper.insert(q);
            boolean queued = doUpdate(task, "QUEUED",
                Wrappers.<YmsYardTaskDO>lambdaUpdate()
                    .eq(YmsYardTaskDO::getId, task.getId())
                    .set(YmsYardTaskDO::getYardStatus, "QUEUED")
                    .set(YmsYardTaskDO::getDockId, dock.getId())
                    .set(YmsYardTaskDO::getDockCode, dock.getDockCode())
                    .set(YmsYardTaskDO::getDockAssignTime, new Date()));
            return queued;
        }

        cancelOpenDockInTasks(task.getId(), dock.getId());
        boolean moveTaskCreated = createDockInTask(task, dock);
        if (moveTaskCreated) {
            boolean ok = yardTaskMapper.update(null, Wrappers.<YmsYardTaskDO>lambdaUpdate()
                .eq(YmsYardTaskDO::getId, task.getId())
                .set(YmsYardTaskDO::getYardStatus, "ARRIVED")
                .set(YmsYardTaskDO::getDockId, dock.getId())
                .set(YmsYardTaskDO::getDockCode, dock.getDockCode())
                .set(YmsYardTaskDO::getDockAssignTime, new Date())) > 0;
            if (ok) {
                writeLog(task.getId(), "DOCK_MOVE_TASK_CREATED", task.getYardStatus(), "ARRIVED",
                    "已生成 YardGo 上口/换口任务，等待司机领取");
            }
            return ok;
        }

        boolean ok = doUpdate(task, "DOCK_ASSIGNED",
            Wrappers.<YmsYardTaskDO>lambdaUpdate()
                .eq(YmsYardTaskDO::getId, task.getId())
                .set(YmsYardTaskDO::getYardStatus, "DOCK_ASSIGNED")
                .set(YmsYardTaskDO::getDockId, dock.getId())
                .set(YmsYardTaskDO::getDockCode, dock.getDockCode())
                .set(YmsYardTaskDO::getDockAssignTime, new Date()));
        if (ok) {
            notifySourceOrders(task, "DOCK_ASSIGNED");
        }
        return ok;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean pauseWork(Long taskId) {
        YmsYardTaskDO task = require(taskId);
        assertStatus(task, PAUSABLE, "暂停作业");
        String pausedMarker = PAUSED_FROM_PREFIX + task.getYardStatus();
        return doUpdate(task, "OPERATION_PAUSED",
            Wrappers.<YmsYardTaskDO>lambdaUpdate()
                .eq(YmsYardTaskDO::getId, taskId)
                .set(YmsYardTaskDO::getYardStatus, "OPERATION_PAUSED")
                .set(YmsYardTaskDO::getOperationStatus, pausedMarker));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean resumeWork(Long taskId) {
        YmsYardTaskDO task = require(taskId);
        assertStatus(task, Set.of("OPERATION_PAUSED"), "恢复作业");
        String resumeStatus = resolvePausedFromStatus(task);
        return doUpdate(task, resumeStatus,
            Wrappers.<YmsYardTaskDO>lambdaUpdate()
                .eq(YmsYardTaskDO::getId, taskId)
                .set(YmsYardTaskDO::getYardStatus, resumeStatus)
                .set(YmsYardTaskDO::getOperationStatus,
                    StrUtil.startWith(task.getOperationStatus(), PAUSED_FROM_PREFIX) ? null : task.getOperationStatus()));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean updatePriority(YmsUpdatePriorityReqVO bo) {
        YmsYardTaskDO task = require(bo.getYardTaskId());
        if (TERMINAL.contains(task.getYardStatus())) {
            throw new ServiceException(500, "终态任务不可调整优先级");
        }
        yardTaskMapper.update(null, Wrappers.<YmsYardTaskDO>lambdaUpdate()
            .eq(YmsYardTaskDO::getId, bo.getYardTaskId())
            .set(YmsYardTaskDO::getPriority, bo.getPriority()));
        writeLog(task.getId(), "PRIORITY_CHANGE", String.valueOf(task.getPriority()),
            String.valueOf(bo.getPriority()), "调整任务优先级");
        return true;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean syncWmsReady(YmsSyncWmsReadyReqVO bo) {
        YmsYardTaskDO task = require(bo.getYardTaskId());
        if (!Set.of("NOT_REQUIRED", "PENDING", "READY").contains(bo.getWmsReadyStatus())) {
            throw new ServiceException(500, "无效的WMS备货状态");
        }
        Date readyTime = "READY".equals(bo.getWmsReadyStatus())
            ? (bo.getWmsReadyTime() != null ? bo.getWmsReadyTime() : new Date())
            : null;
        yardTaskMapper.update(null, Wrappers.<YmsYardTaskDO>lambdaUpdate()
            .eq(YmsYardTaskDO::getId, bo.getYardTaskId())
            .set(YmsYardTaskDO::getWmsReadyStatus, bo.getWmsReadyStatus())
            .set(YmsYardTaskDO::getWmsReadyTime, readyTime));
        writeLog(task.getId(), "WMS_READY_SYNC", task.getWmsReadyStatus(),
            bo.getWmsReadyStatus(), "WMS备货状态更新");
        return true;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean startDockWork(Long taskId) {
        YmsYardTaskDO task = require(taskId);
        assertStatus(task, Set.of("DOCK_ASSIGNED", "ON_DOCK"), "开始作业");
        String newStatus = "DEVANNING".equals(task.getTaskType()) ? "DEVANNING" : "LOADING";
        boolean ok = doUpdate(task, newStatus,
            Wrappers.<YmsYardTaskDO>lambdaUpdate()
                .eq(YmsYardTaskDO::getId, taskId)
                .set(YmsYardTaskDO::getYardStatus, newStatus)
                .set(YmsYardTaskDO::getDockStartTime, new Date()));
        if (ok) notifySourceOrders(task, "START_DOCK");
        return ok;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean finishDockWork(Long taskId, YmsFinishWorkReqVO bo) {
        YmsYardTaskDO task = require(taskId);
        assertStatus(task, WORKING, "完成作业");
        boolean ok = doUpdate(task, "OPERATION_FINISHED",
            Wrappers.<YmsYardTaskDO>lambdaUpdate()
                .eq(YmsYardTaskDO::getId, taskId)
                .set(YmsYardTaskDO::getYardStatus, "OPERATION_FINISHED")
                .set(YmsYardTaskDO::getDockFinishTime, new Date())
                .set(YmsYardTaskDO::getOperationProgress, 100));
        if (ok) {
            createDockOutTask(task, bo);
            notifySourceOrders(task, "FINISH_DOCK");
        }
        return ok;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean release(Long taskId) {
        YmsYardTaskDO task = require(taskId);
        if (hasOpenInternalTask(taskId, "DOCK_OUT")) {
            throw new ServiceException(500, "Dock 下口 YardGo 任务未完成，不能放行");
        }
        return doUpdate(task, "RELEASED",
            Wrappers.<YmsYardTaskDO>lambdaUpdate()
                .eq(YmsYardTaskDO::getId, taskId)
                .set(YmsYardTaskDO::getYardStatus, "RELEASED")
                .set(YmsYardTaskDO::getReleaseTime, new Date()));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean leaveYard(Long taskId) {
        YmsYardTaskDO task = require(taskId);
        boolean ok = doUpdate(task, "LEFT_YARD",
            Wrappers.<YmsYardTaskDO>lambdaUpdate()
                .eq(YmsYardTaskDO::getId, taskId)
                .set(YmsYardTaskDO::getYardStatus, "LEFT_YARD")
                .set(YmsYardTaskDO::getGateOutTime, new Date())
                .set(YmsYardTaskDO::getActiveTaskKey, null));
        if (ok) notifySourceOrders(task, "LEAVE_YARD");
        return ok;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean markException(Long taskId, String reason) {
        YmsYardTaskDO task = require(taskId);
        return doUpdate(task, "EXCEPTION_PROCESSING",
            Wrappers.<YmsYardTaskDO>lambdaUpdate()
                .eq(YmsYardTaskDO::getId, taskId)
                .set(YmsYardTaskDO::getYardStatus, "EXCEPTION_PROCESSING")
                .set(YmsYardTaskDO::getExceptionFlag, 1)
                .set(YmsYardTaskDO::getExceptionReason, reason));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean clearException(Long taskId) {
        YmsYardTaskDO task = require(taskId);
        return doUpdate(task, "EXCEPTION_CLOSED",
            Wrappers.<YmsYardTaskDO>lambdaUpdate()
                .eq(YmsYardTaskDO::getId, taskId)
                .set(YmsYardTaskDO::getYardStatus, "EXCEPTION_CLOSED")
                .set(YmsYardTaskDO::getActiveTaskKey, null));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean cancelTask(Long taskId, String reason) {
        YmsYardTaskDO task = require(taskId);
        if (TERMINAL.contains(task.getYardStatus())) throw new ServiceException(500, "任务已处于终态");
        return doUpdate(task, "CANCELLED",
            Wrappers.<YmsYardTaskDO>lambdaUpdate()
                .eq(YmsYardTaskDO::getId, taskId)
                .set(YmsYardTaskDO::getYardStatus, "CANCELLED")
                .set(YmsYardTaskDO::getActiveTaskKey, null)
                .set(YmsYardTaskDO::getRemark, reason));
    }

    // ─── 操作日志 ─────────────────────────────────────────

    @Override
    public List<YmsYardTaskLogRespVO> queryLogs(Long taskId) {
        List<YmsYardTaskLogDO> logs = taskLogMapper.selectList(
            Wrappers.<YmsYardTaskLogDO>lambdaQuery()
                .eq(YmsYardTaskLogDO::getYardTaskId, taskId)
                .orderByDesc(YmsYardTaskLogDO::getActionTime));
        return logs.stream().map(l -> {
            YmsYardTaskLogRespVO vo = new YmsYardTaskLogRespVO();
            vo.setId(l.getId());
            vo.setYardTaskId(l.getYardTaskId());
            vo.setActionType(l.getActionType());
            vo.setBeforeStatus(l.getBeforeStatus());
            vo.setAfterStatus(l.getAfterStatus());
            vo.setActionContent(l.getActionContent());
            vo.setOperatorId(l.getOperatorId());
            vo.setOperatorName(l.getOperatorName());
            vo.setActionTime(l.getActionTime());
            return vo;
        }).collect(Collectors.toList());
    }

    // ─── 私有工具 ─────────────────────────────────────────

    private YmsYardTaskDO require(Long id) {
        YmsYardTaskDO t = yardTaskMapper.selectById(id);
        if (t == null) throw new ServiceException(500, "园区任务不存在");
        return t;
    }

    private void assertStatus(YmsYardTaskDO task, Set<String> allowed, String action) {
        if (!allowed.contains(task.getYardStatus()))
            throw new ServiceException(500, "当前状态[" + task.getYardStatus() + "]不允许" + action);
    }

    private boolean doUpdate(YmsYardTaskDO task, String newStatus,
                              com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper<YmsYardTaskDO> uw) {
        boolean ok = yardTaskMapper.update(null, uw) > 0;
        if (ok) writeLog(task.getId(), "STATUS_CHANGE", task.getYardStatus(), newStatus, null);
        return ok;
    }

    /** 分配道口后，按需创建上口/换口内场任务：堆场位→Dock、等待区→Dock、Dock→Dock 都走 YardGo。 */
    private boolean createDockInTask(YmsYardTaskDO task, YardDockDO dock) {
        if (hasOpenDockInTask(task.getId(), dock.getId())) {
            return true;
        }
        boolean isContainer = DEVANNING_TYPES.contains(task.getTaskType());
        Long objectId = null;
        String objectNo = null;
        Long fromPositionId = null;
        String fromPositionCode = null;
        Long currentDockId = null;

        if (isContainer) {
            YmsContainerResourceDO cr = findContainerResource(task);
            if (cr != null) {
                objectId = cr.getId();
                objectNo = cr.getContainerNo();
                boolean onDock = isContainerPhysicallyOnDock(cr);
                currentDockId = onDock ? cr.getDockId() : null;
                if (onDock) {
                    fromPositionId = cr.getDockId();
                    fromPositionCode = cr.getDockCode();
                } else {
                    fromPositionId = cr.getYardPositionId();
                }
            }
        } else if (!isContainer) {
            YmsTrailerResourceDO tr = findTrailerResource(task);
            if (tr != null) {
                objectId = tr.getId();
                objectNo = StrUtil.blankToDefault(tr.getTrailerNo(), tr.getPlateNo());
                boolean onDock = isTrailerPhysicallyOnDock(tr);
                currentDockId = onDock ? tr.getDockId() : null;
                if (onDock) {
                    fromPositionId = tr.getDockId();
                    fromPositionCode = tr.getDockCode();
                } else {
                    fromPositionId = tr.getYardPositionId();
                }
            }
        }
        if (objectId == null) {
            return false;
        }
        if (Objects.equals(currentDockId, dock.getId())) {
            return false;
        }

        YmsInternalTaskCreateReqVO bo = new YmsInternalTaskCreateReqVO();
        bo.setWarehouseId(task.getWarehouseId());
        bo.setInternalTaskType("DOCK_IN");
        bo.setObjectType(isContainer ? "CONTAINER" : "TRAILER");
        bo.setObjectId(objectId);
        bo.setObjectNo(objectNo);
        bo.setFromPositionId(fromPositionId);
        bo.setFromPositionCode(fromPositionCode);
        bo.setToDockId(dock.getId());
        bo.setToDockCode(dock.getDockCode());
        bo.setParentYardTaskId(task.getId());
        bo.setParentYardTaskNo(task.getYardTaskNo());
        bo.setPriority(task.getPriority());
        internalTaskService.createByBo(bo);
        return true;
    }

    private boolean isContainerPhysicallyOnDock(YmsContainerResourceDO resource) {
        return resource.getDockId() != null && CONTAINER_ON_DOCK_STATUS.contains(resource.getContainerStatus());
    }

    private boolean isTrailerPhysicallyOnDock(YmsTrailerResourceDO resource) {
        return resource.getDockId() != null && TRAILER_ON_DOCK_STATUS.contains(resource.getTrailerStatus());
    }

    private boolean hasOpenDockInTask(Long yardTaskId, Long targetDockId) {
        return internalTaskMapper.selectCount(Wrappers.<YmsInternalTaskDO>lambdaQuery()
            .eq(YmsInternalTaskDO::getParentYardTaskId, yardTaskId)
            .eq(YmsInternalTaskDO::getInternalTaskType, "DOCK_IN")
            .eq(YmsInternalTaskDO::getToDockId, targetDockId)
            .notIn(YmsInternalTaskDO::getTaskStatus, "COMPLETED", "FAILED", "CANCELLED")) > 0;
    }

    /**
     * 取消当前园区任务未完成的上口/换口任务。
     * keepTargetDockId 不为空时保留同一目标 Dock 的任务，用于重复分配同一 Dock 时保持幂等。
     */
    private void cancelOpenDockInTasks(Long yardTaskId, Long keepTargetDockId) {
        var update = Wrappers.<YmsInternalTaskDO>lambdaUpdate()
            .eq(YmsInternalTaskDO::getParentYardTaskId, yardTaskId)
            .eq(YmsInternalTaskDO::getInternalTaskType, "DOCK_IN")
            .notIn(YmsInternalTaskDO::getTaskStatus, "COMPLETED", "FAILED", "CANCELLED")
            .set(YmsInternalTaskDO::getTaskStatus, "CANCELLED")
            .set(YmsInternalTaskDO::getRemark, "Dock分配已取消或改派，系统自动取消旧上口任务");
        if (keepTargetDockId != null) {
            update.ne(YmsInternalTaskDO::getToDockId, keepTargetDockId);
        }
        internalTaskMapper.update(null, update);
    }

    private boolean hasOpenInternalTask(Long yardTaskId, String internalTaskType) {
        return internalTaskMapper.selectCount(Wrappers.<YmsInternalTaskDO>lambdaQuery()
            .eq(YmsInternalTaskDO::getParentYardTaskId, yardTaskId)
            .eq(YmsInternalTaskDO::getInternalTaskType, internalTaskType)
            .notIn(YmsInternalTaskDO::getTaskStatus, "COMPLETED", "FAILED", "CANCELLED")) > 0;
    }

    /** 完成作业后，自动创建下口内场任务（将资源从道口调度到堆场位或其他道口） */
    private void createDockOutTask(YmsYardTaskDO task, YmsFinishWorkReqVO bo) {
        if (bo == null || (bo.getToPositionId() == null && bo.getToDockId() == null)) {
            throw new ServiceException(500, "请选择下口目的地，Dock下口到堆场位或其他道口需要生成 YardGo 任务");
        }
        boolean isContainer = DEVANNING_TYPES.contains(task.getTaskType());
        Long objectId = null;
        String objectNo = null;

        if (isContainer) {
            YmsContainerResourceDO cr = findContainerResource(task);
            if (cr != null) { objectId = cr.getId(); objectNo = cr.getContainerNo(); }
        } else if (!isContainer) {
            YmsTrailerResourceDO tr = findTrailerResource(task);
            if (tr != null) { objectId = tr.getId(); objectNo = StrUtil.blankToDefault(tr.getTrailerNo(), tr.getPlateNo()); }
        }
        if (objectId == null) {
            throw new ServiceException(500, "未找到在场资源，无法生成 Dock 下口 YardGo 任务");
        }

        YmsInternalTaskCreateReqVO createBo = new YmsInternalTaskCreateReqVO();
        createBo.setWarehouseId(task.getWarehouseId());
        createBo.setInternalTaskType("DOCK_OUT");
        createBo.setObjectType(isContainer ? "CONTAINER" : "TRAILER");
        createBo.setObjectId(objectId);
        createBo.setObjectNo(objectNo);
        createBo.setFromPositionId(task.getDockId());
        createBo.setFromPositionCode(task.getDockCode());
        createBo.setParentYardTaskId(task.getId());
        createBo.setParentYardTaskNo(task.getYardTaskNo());
        createBo.setPriority(task.getPriority());
        if (bo != null) {
            createBo.setToPositionId(bo.getToPositionId());
            createBo.setToPositionCode(bo.getToPositionCode());
            createBo.setToDockId(bo.getToDockId());
            createBo.setToDockCode(bo.getToDockCode());
        }
        internalTaskService.createByBo(createBo);
    }

    private YmsContainerResourceDO findContainerResource(YmsYardTaskDO task) {
        if (task.getContainerResourceId() != null) {
            YmsContainerResourceDO resource = containerResourceMapper.selectById(task.getContainerResourceId());
            if (resource != null
                && Objects.equals(resource.getWarehouseId(), task.getWarehouseId())
                && !"LEFT_YARD".equals(resource.getContainerStatus())
                && !"RETURNED".equals(resource.getContainerStatus())) {
                return resource;
            }
        }
        if (StrUtil.isBlank(task.getContainerNo())) {
            return null;
        }
        return containerResourceMapper.selectOne(
            Wrappers.<YmsContainerResourceDO>lambdaQuery()
                .eq(YmsContainerResourceDO::getWarehouseId, task.getWarehouseId())
                .eq(YmsContainerResourceDO::getContainerNo, task.getContainerNo())
                .ne(YmsContainerResourceDO::getContainerStatus, "LEFT_YARD")
                .ne(YmsContainerResourceDO::getContainerStatus, "RETURNED")
                .last("LIMIT 1"));
    }

    private YmsTrailerResourceDO findTrailerResource(YmsYardTaskDO task) {
        if (task.getTrailerResourceId() != null) {
            YmsTrailerResourceDO resource = trailerResourceMapper.selectById(task.getTrailerResourceId());
            if (resource != null
                && Objects.equals(resource.getWarehouseId(), task.getWarehouseId())
                && !"LEFT_YARD".equals(resource.getTrailerStatus())) {
                return resource;
            }
        }
        if (StrUtil.isNotBlank(task.getTruckNo())) {
            YmsTrailerResourceDO resource = trailerResourceMapper.selectOne(
                Wrappers.<YmsTrailerResourceDO>lambdaQuery()
                    .eq(YmsTrailerResourceDO::getWarehouseId, task.getWarehouseId())
                    .and(w -> w.eq(YmsTrailerResourceDO::getPlateNo, task.getTruckNo())
                        .or()
                        .eq(YmsTrailerResourceDO::getTrailerNo, task.getTruckNo()))
                    .ne(YmsTrailerResourceDO::getTrailerStatus, "LEFT_YARD")
                    .last("LIMIT 1"));
            if (resource != null) {
                return resource;
            }
        }
        if (StrUtil.isBlank(task.getSourceOrderNo())) {
            return null;
        }
        return trailerResourceMapper.selectOne(
            Wrappers.<YmsTrailerResourceDO>lambdaQuery()
                .eq(YmsTrailerResourceDO::getWarehouseId, task.getWarehouseId())
                .eq(YmsTrailerResourceDO::getRelatedOrderNo, task.getSourceOrderNo())
                .ne(YmsTrailerResourceDO::getTrailerStatus, "LEFT_YARD")
                .last("LIMIT 1"));
    }

    private void promoteNextQueue(Long dockId) {
        YmsDockQueueDO next = dockQueueMapper.selectOne(
            Wrappers.<YmsDockQueueDO>lambdaQuery()
                .eq(YmsDockQueueDO::getDockId, dockId)
                .eq(YmsDockQueueDO::getQueueStatus, "WAITING")
                .orderByAsc(YmsDockQueueDO::getQueueNo)
                .last("LIMIT 1"));
        if (next == null) return;
        YmsYardTaskDO task = yardTaskMapper.selectById(next.getYardTaskId());
        YardDockDO dock = yardDockMapper.selectById(dockId);
        dockQueueMapper.update(null, Wrappers.<YmsDockQueueDO>lambdaUpdate()
            .eq(YmsDockQueueDO::getId, next.getId())
            .set(YmsDockQueueDO::getQueueStatus, "ENTERED")
            .set(YmsDockQueueDO::getEnterDockTime, new Date()));
        if (task == null || dock == null) return;
        boolean moveTaskCreated = createDockInTask(task, dock);
        yardTaskMapper.update(null, Wrappers.<YmsYardTaskDO>lambdaUpdate()
            .eq(YmsYardTaskDO::getId, next.getYardTaskId())
            .set(YmsYardTaskDO::getYardStatus, moveTaskCreated ? "ARRIVED" : "DOCK_ASSIGNED"));
        writeLog(task.getId(), moveTaskCreated ? "DOCK_MOVE_TASK_CREATED" : "QUEUE_ENTER_DOCK",
            task.getYardStatus(), moveTaskCreated ? "ARRIVED" : "DOCK_ASSIGNED",
            moveTaskCreated ? "排队任务已生成 YardGo 上口任务，等待司机领取" : "排队任务进入道口");
        if (!moveTaskCreated) {
            notifySourceOrders(task, "DOCK_ASSIGNED");
        }
    }

    private void writeLog(Long taskId, String type, String before, String after, String content) {
        YmsYardTaskLogDO log = new YmsYardTaskLogDO();
        log.setId(IdUtil.getSnowflakeNextId());
        log.setYardTaskId(taskId);
        log.setActionType(type);
        log.setBeforeStatus(before);
        log.setAfterStatus(after);
        log.setActionContent(content);
        log.setActionTime(new Date());
        taskLogMapper.insert(log);
    }

    private YmsYardTaskDO buildTask(String taskType, Long warehouseId, String sourceType, Long sourceId,
                                   String sourceNo, String containerNo, String truckNo, String driverName,
                                   String driverPhone, Date etaTime, int visitNo,
                                   String initStatus, String source, String remark) {
        String key = ("MANUAL".equals(sourceType) || sourceId == null) ? null : (sourceType + ":" + sourceId);
        YmsYardTaskDO t = new YmsYardTaskDO();
        t.setId(IdUtil.getSnowflakeNextId());
        t.setYardTaskNo(generateTaskNo());
        t.setTaskType(taskType);
        t.setWarehouseId(warehouseId);
        t.setSourceOrderType(sourceType);
        t.setSourceOrderId(sourceId);
        t.setSourceOrderNo(sourceNo);
        t.setContainerNo(containerNo);
        t.setTruckNo(truckNo);
        t.setDriverName(driverName);
        t.setDriverPhone(driverPhone);
        t.setEtaYardTime(etaTime);
        t.setYardStatus(initStatus);
        t.setVisitNo(visitNo);
        t.setUnloadRoundNo(1);
        t.setIsReentry(visitNo > 1 ? 1 : 0);
        t.setActiveTaskKey(key);
        t.setSource(source);
        t.setRemark(remark);
        t.setExceptionFlag(0);
        t.setPriority(5);
        // Phase 1: WMS 尚未对接，所有任务默认 NOT_REQUIRED，不拦截 Dock 分配
        // WMS 建好后通过 syncWmsReady() 接口更新此状态
        t.setWmsReadyStatus("NOT_REQUIRED");
        return t;
    }

    private void applyDockTypeFilter(LambdaQueryWrapper<YardDockDO> dq, String taskGroup) {
        if ("DEVANNING".equals(taskGroup)) {
            dq.in(YardDockDO::getDockType, DEVANNING_DOCK_TYPES);
        } else if ("LOADING".equals(taskGroup)) {
            dq.in(YardDockDO::getDockType, LOADING_DOCK_TYPES);
        }
    }

    private String resolvePausedFromStatus(YmsYardTaskDO task) {
        String op = task.getOperationStatus();
        if (StrUtil.isNotBlank(op) && op.startsWith(PAUSED_FROM_PREFIX)) {
            return op.substring(PAUSED_FROM_PREFIX.length());
        }
        return "DEVANNING".equals(task.getTaskType()) ? "DEVANNING" : "LOADING";
    }

    private YmsDockBoardRespVO toDockBoardVo(YardDockDO d) {
        YmsDockBoardRespVO vo = new YmsDockBoardRespVO();
        vo.setId(d.getId());
        vo.setDockCode(d.getDockCode());
        vo.setDockName(d.getDockName());
        vo.setDockType(d.getDockType());
        vo.setDockLocation(d.getDockLocation());
        vo.setGridRow(d.getGridRow());
        vo.setGridCol(d.getGridCol());
        vo.setDockStatus(d.getDockStatus());
        vo.setEnableQueue(d.getEnableQueue());
        vo.setMaxQueueCount(d.getMaxQueueCount());
        vo.setSortOrder(d.getSortOrder());
        vo.setEnabledFlag(d.getEnabledFlag());
        return vo;
    }

    private YmsYardTaskRespVO toTaskVo(YmsYardTaskDO t) {
        YmsYardTaskRespVO vo = new YmsYardTaskRespVO();
        vo.setId(t.getId());
        vo.setYardTaskNo(t.getYardTaskNo());
        vo.setTaskType(t.getTaskType());
        vo.setSourceOrderType(t.getSourceOrderType());
        vo.setSourceOrderNo(t.getSourceOrderNo());
        vo.setContainerNo(t.getContainerNo());
        vo.setWmsReadyStatus(t.getWmsReadyStatus());
        vo.setWmsReadyTime(t.getWmsReadyTime());
        vo.setPriority(t.getPriority());
        vo.setTruckNo(t.getTruckNo());
        vo.setDriverName(t.getDriverName());
        vo.setDriverPhone(t.getDriverPhone());
        vo.setEtaYardTime(t.getEtaYardTime());
        vo.setGateInTime(t.getGateInTime());
        vo.setDockStartTime(t.getDockStartTime());
        vo.setDockId(t.getDockId());
        vo.setDockCode(t.getDockCode());
        vo.setOperationStatus(t.getOperationStatus());
        vo.setOperationProgress(t.getOperationProgress());
        vo.setEstimatedFinishTime(t.getEstimatedFinishTime());
        vo.setLoadedQty(t.getLoadedQty());
        vo.setTotalQty(t.getTotalQty());
        vo.setLoadedPalletQty(t.getLoadedPalletQty());
        vo.setTotalPalletQty(t.getTotalPalletQty());
        vo.setYardStatus(t.getYardStatus());
        vo.setExceptionFlag(t.getExceptionFlag());
        vo.setVisitNo(t.getVisitNo());
        vo.setUnloadRoundNo(t.getUnloadRoundNo());
        vo.setIsReentry(t.getIsReentry());
        if (t.getCreateTime() != null) {
            vo.setCreateTime(java.util.Date.from(t.getCreateTime().atZone(java.time.ZoneId.systemDefault()).toInstant()));
        }
        enrichOpenInternalTask(vo);
        return vo;
    }

    private void enrichOpenInternalTask(YmsYardTaskRespVO vo) {
        YmsInternalTaskDO task = internalTaskMapper.selectOne(Wrappers.<YmsInternalTaskDO>lambdaQuery()
            .eq(YmsInternalTaskDO::getParentYardTaskId, vo.getId())
            .notIn(YmsInternalTaskDO::getTaskStatus, "COMPLETED", "FAILED", "CANCELLED")
            .orderByDesc(YmsInternalTaskDO::getCreateTime)
            .last("LIMIT 1"));
        if (task == null) {
            return;
        }
        vo.setOpenInternalTaskId(task.getId());
        vo.setOpenInternalTaskNo(task.getTaskNo());
        vo.setOpenInternalTaskType(task.getInternalTaskType());
        vo.setOpenInternalTaskStatus(task.getTaskStatus());
        vo.setOpenInternalTaskTargetCode(StrUtil.blankToDefault(task.getToDockCode(), task.getToPositionCode()));
    }

    private String generateTaskNo() {
        String date = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        return "YT" + date + String.format("%06d", System.currentTimeMillis() % 1000000);
    }

    private void notifySourceOrders(YmsYardTaskDO task, String action) {
        if (StrUtil.isBlank(task.getSourceOrderType()) || task.getSourceOrderId() == null) {
            return;
        }
        if (sourceOrderSyncHandlers == null || sourceOrderSyncHandlers.isEmpty()) {
            return;
        }
        for (YmsSourceOrderSyncHandler handler : sourceOrderSyncHandlers) {
            handler.onYardTaskAction(task.getSourceOrderType(), task.getSourceOrderId(), task.getTaskType(), action);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void syncOmsArrival(String sourceOrderType, Long sourceOrderId, Date arrivalTime) {
        String key = sourceOrderType + ":" + sourceOrderId;
        YmsYardTaskDO task = yardTaskMapper.selectOne(
            Wrappers.<YmsYardTaskDO>lambdaQuery()
                .eq(YmsYardTaskDO::getActiveTaskKey, key));
        if (task == null) return;

        Date gateTime = arrivalTime != null ? arrivalTime : new Date();
        boolean needStatusAdvance = Set.of("CREATED", "PRE_ARRIVAL").contains(task.getYardStatus());

        yardTaskMapper.update(null, Wrappers.<YmsYardTaskDO>lambdaUpdate()
            .eq(YmsYardTaskDO::getId, task.getId())
            .set(YmsYardTaskDO::getGateInTime, gateTime)
            .set(needStatusAdvance, YmsYardTaskDO::getYardStatus, "ARRIVED"));

        if (needStatusAdvance) {
            writeLog(task.getId(), "OMS_ARRIVAL_SYNC", task.getYardStatus(), "ARRIVED",
                "OMS手动到仓，同步推进状态");
        }
        // 注意：此处不调用 notifySourceOrders，避免回写 OMS 产生循环
    }
}
