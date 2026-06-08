package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.framework.common.util.object.BeanUtils;

import cn.iocoder.yudao.module.yms.util.YmsPageUtils;

import cn.hutool.core.util.IdUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.module.base.dal.dataobject.yarddock.YardDockDO;
import cn.iocoder.yudao.module.base.dal.mysql.yarddock.YardDockMapper;
import cn.iocoder.yudao.framework.common.exception.ServiceException;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsContainerResourceDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsDockQueueDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsTrailerResourceDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsYardTaskLogDO;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsContainerResourceMapper;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsDockQueueMapper;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsTrailerResourceMapper;
import cn.iocoder.yudao.module.yms.support.YmsYardLocationSupport;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsInternalTaskDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsYardTaskDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsInternalTaskAssignReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsInternalTaskCompleteReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsInternalTaskCreateReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsInternalTaskQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsInternalTaskBoardRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsInternalTaskRespVO;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsInternalTaskMapper;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsYardTaskLogMapper;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsYardTaskMapper;
import cn.iocoder.yudao.module.yms.service.YmsInternalTaskService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;


@Service
public class YmsInternalTaskServiceImpl implements YmsInternalTaskService {

    private static final Set<String> TERMINAL = Set.of("COMPLETED", "FAILED", "CANCELLED");
    private static final Set<String> YARD_TERMINAL = Set.of("LEFT_YARD", "CANCELLED", "EXCEPTION_CLOSED");
    private static final Set<String> DEVANNING_TYPES = Set.of("DEVANNING");
    private static final Set<String> CONTAINER_ON_DOCK_STATUS = Set.of("ON_DOCK", "DEVANNING", "WMS_WORKING");
    private static final Set<String> TRAILER_ON_DOCK_STATUS = Set.of("ON_DOCK", "LOADING");
    private static final List<String> BOARD_COLUMNS = List.of(
        "PENDING", "ACCEPTED", "IN_PROGRESS", "FAILED"
    );
    private static final Map<String, String> BOARD_LABELS = Map.of(
        "PENDING", "待领取",
        "ASSIGNED", "已分配",
        "ACCEPTED", "已领取",
        "IN_PROGRESS", "执行中",
        "FAILED", "异常"
    );

    @Resource
    private YmsInternalTaskMapper baseMapper;
    @Resource
    private YmsYardTaskMapper yardTaskMapper;
    @Resource
    private YmsDockQueueMapper dockQueueMapper;
    @Resource
    private YmsYardTaskLogMapper yardTaskLogMapper;
    @Resource
    private YardDockMapper yardDockMapper;
    @Resource
    private YmsContainerResourceMapper containerResourceMapper;
    @Resource
    private YmsTrailerResourceMapper   trailerResourceMapper;
    @Resource
    private YmsYardLocationSupport     locationSupport;

    @Override
    public PageResult<YmsInternalTaskRespVO> queryPageList(YmsInternalTaskQueryReqVO bo, PageParam pageParam) {
        return YmsPageUtils.toPageResult(baseMapper.selectPageList(YmsPageUtils.toPage(pageParam), bo));
    }

    @Override
    public YmsInternalTaskRespVO queryById(Long id) {
        return BeanUtils.toBean(baseMapper.selectById(id), YmsInternalTaskRespVO.class);
    }

    @Override
    public List<YmsInternalTaskBoardRespVO> queryBoard(Long warehouseId, String internalTaskType) {
        List<YmsInternalTaskRespVO> all = baseMapper.selectBoardList(warehouseId, internalTaskType);
        Map<String, List<YmsInternalTaskRespVO>> grouped = all.stream()
            .collect(Collectors.groupingBy(YmsInternalTaskRespVO::getTaskStatus));

        List<YmsInternalTaskBoardRespVO> board = new ArrayList<>();
        for (String status : BOARD_COLUMNS) {
            YmsInternalTaskBoardRespVO col = new YmsInternalTaskBoardRespVO();
            col.setStatus(status);
            col.setStatusLabel(BOARD_LABELS.getOrDefault(status, status));
            List<YmsInternalTaskRespVO> tasks = grouped.getOrDefault(status, List.of());
            col.setTasks(tasks);
            col.setCount(tasks.size());
            board.add(col);
        }
        return board;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public YmsInternalTaskRespVO createByBo(YmsInternalTaskCreateReqVO bo) {
        return doCreate(bo);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public YmsInternalTaskRespVO createToDockTask(YmsInternalTaskCreateReqVO bo) {
        return doCreate(bo);
    }

    private YmsInternalTaskRespVO doCreate(YmsInternalTaskCreateReqVO bo) {
        enrichFromReferences(bo);

        YmsInternalTaskDO task = new YmsInternalTaskDO();
        task.setId(IdUtil.getSnowflakeNextId());
        task.setWarehouseId(bo.getWarehouseId());
        task.setTaskNo(generateTaskNo());
        task.setParentYardTaskId(bo.getParentYardTaskId());
        task.setParentYardTaskNo(bo.getParentYardTaskNo());
        task.setInternalTaskType(bo.getInternalTaskType());
        task.setObjectType(bo.getObjectType());
        task.setObjectId(bo.getObjectId());
        task.setObjectNo(bo.getObjectNo());
        task.setFromPositionId(bo.getFromPositionId());
        task.setFromPositionCode(bo.getFromPositionCode());
        task.setToPositionId(bo.getToPositionId());
        task.setToPositionCode(bo.getToPositionCode());
        task.setToDockId(bo.getToDockId());
        task.setToDockCode(bo.getToDockCode());
        task.setTaskStatus("PENDING");
        task.setPriority(bo.getPriority());
        task.setRemark(bo.getRemark());
        if (task.getPriority() == null) {
            task.setPriority(5);
        }
        baseMapper.insert(task);
        return BeanUtils.toBean(baseMapper.selectById(task.getId()), YmsInternalTaskRespVO.class);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean assign(YmsInternalTaskAssignReqVO bo) {
        YmsInternalTaskDO task = requireActive(bo.getId(), Set.of("PENDING", "ASSIGNED"));
        return baseMapper.update(null, Wrappers.<YmsInternalTaskDO>lambdaUpdate()
            .eq(YmsInternalTaskDO::getId, task.getId())
            .set(YmsInternalTaskDO::getTaskStatus, "ASSIGNED")
            .set(YmsInternalTaskDO::getExecutorType, bo.getExecutorType())
            .set(YmsInternalTaskDO::getExecutorId, bo.getExecutorId())
            .set(YmsInternalTaskDO::getExecutorName, bo.getExecutorName())
            .set(YmsInternalTaskDO::getAssignTime, new Date())) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean accept(Long id) {
        requireActive(id, Set.of("PENDING", "ASSIGNED"));
        return updateStatus(id, "ACCEPTED", Map.of("acceptTime", new Date()));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean start(Long id) {
        requireActive(id, Set.of("ASSIGNED", "ACCEPTED"));
        return updateStatus(id, "IN_PROGRESS", Map.of("startTime", new Date()));
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean complete(Long id, YmsInternalTaskCompleteReqVO bo) {
        YmsInternalTaskDO task = requireActive(id, Set.of("IN_PROGRESS"));
        var update = Wrappers.<YmsInternalTaskDO>lambdaUpdate()
            .eq(YmsInternalTaskDO::getId, id)
            .set(YmsInternalTaskDO::getTaskStatus, "COMPLETED")
            .set(YmsInternalTaskDO::getFinishTime, new Date());
        if (bo != null && StrUtil.isNotBlank(bo.getPhotoUrls())) {
            update.set(YmsInternalTaskDO::getPhotoUrls, bo.getPhotoUrls());
        }
        boolean ok = baseMapper.update(null, update) > 0;
        if (ok) {
            if ("DOCK_IN".equals(task.getInternalTaskType())) {
                onDockInCompleted(task);
            } else if ("DOCK_OUT".equals(task.getInternalTaskType())) {
                onDockOutCompleted(task);
            }
        }
        return ok;
    }

    /** 上口/换口任务完成：yard_task → DOCK_ASSIGNED，更新资源 dockId，占用目标道口 */
    private void onDockInCompleted(YmsInternalTaskDO task) {
        if (task.getParentYardTaskId() != null) {
            yardTaskMapper.update(null, Wrappers.<YmsYardTaskDO>lambdaUpdate()
                .eq(YmsYardTaskDO::getId, task.getParentYardTaskId())
                .set(YmsYardTaskDO::getYardStatus, "DOCK_ASSIGNED"));
        }
        if (task.getToDockId() == null || task.getObjectId() == null) return;
        if ("CONTAINER".equals(task.getObjectType())) {
            YmsContainerResourceDO upd = new YmsContainerResourceDO();
            upd.setId(task.getObjectId());
            upd.setDockId(task.getToDockId());
            upd.setDockCode(task.getToDockCode());
            upd.setYardPositionId(null);
            upd.setYardZoneId(null);
            containerResourceMapper.updateById(upd);
            locationSupport.occupySlot(task.getToDockId(), "CONTAINER", task.getObjectId(), task.getObjectNo());
        } else if ("TRAILER".equals(task.getObjectType())) {
            YmsTrailerResourceDO upd = new YmsTrailerResourceDO();
            upd.setId(task.getObjectId());
            upd.setDockId(task.getToDockId());
            upd.setDockCode(task.getToDockCode());
            upd.setYardPositionId(null);
            upd.setYardZoneId(null);
            trailerResourceMapper.updateById(upd);
            locationSupport.occupySlot(task.getToDockId(), "TRAILER", task.getObjectId(), task.getObjectNo());
        }
        if (task.getFromPositionId() != null && !Objects.equals(task.getFromPositionId(), task.getToDockId())) {
            locationSupport.releaseSlot(task.getFromPositionId());
        }
    }

    /** 下口任务完成：清除道口，更新资源到新位置，释放原道口 */
    private void onDockOutCompleted(YmsInternalTaskDO task) {
        if (task.getObjectId() == null) return;
        if ("CONTAINER".equals(task.getObjectType())) {
            YmsContainerResourceDO upd = new YmsContainerResourceDO();
            upd.setId(task.getObjectId());
            upd.setDockId(null);
            upd.setDockCode(null);
            if (task.getToPositionId() != null) {
                upd.setYardPositionId(task.getToPositionId());
                locationSupport.occupySlot(task.getToPositionId(), "CONTAINER", task.getObjectId(), task.getObjectNo());
            } else if (task.getToDockId() != null) {
                upd.setDockId(task.getToDockId());
                upd.setDockCode(task.getToDockCode());
                locationSupport.occupySlot(task.getToDockId(), "CONTAINER", task.getObjectId(), task.getObjectNo());
            }
            containerResourceMapper.updateById(upd);
        } else if ("TRAILER".equals(task.getObjectType())) {
            YmsTrailerResourceDO upd = new YmsTrailerResourceDO();
            upd.setId(task.getObjectId());
            upd.setDockId(null);
            upd.setDockCode(null);
            if (task.getToPositionId() != null) {
                upd.setYardPositionId(task.getToPositionId());
                locationSupport.occupySlot(task.getToPositionId(), "TRAILER", task.getObjectId(), task.getObjectNo());
            } else if (task.getToDockId() != null) {
                upd.setDockId(task.getToDockId());
                upd.setDockCode(task.getToDockCode());
                locationSupport.occupySlot(task.getToDockId(), "TRAILER", task.getObjectId(), task.getObjectNo());
            }
            trailerResourceMapper.updateById(upd);
        }
        // 释放原道口
        if (task.getFromPositionId() != null) {
            locationSupport.releaseSlot(task.getFromPositionId());
            if (task.getParentYardTaskId() != null) {
                yardTaskMapper.update(null, Wrappers.<YmsYardTaskDO>lambdaUpdate()
                    .eq(YmsYardTaskDO::getId, task.getParentYardTaskId())
                    .set(YmsYardTaskDO::getDockId, null)
                    .set(YmsYardTaskDO::getDockCode, null));
            }
            promoteNextQueue(task.getFromPositionId());
        }
    }

    /** 道口释放后推进下一条排队任务；如果资源不在目标道口，则生成待领取的 YardGo 上口/换口任务。 */
    private void promoteNextQueue(Long dockId) {
        YmsDockQueueDO next = dockQueueMapper.selectOne(
            Wrappers.<YmsDockQueueDO>lambdaQuery()
                .eq(YmsDockQueueDO::getDockId, dockId)
                .eq(YmsDockQueueDO::getQueueStatus, "WAITING")
                .orderByAsc(YmsDockQueueDO::getQueueNo)
                .last("LIMIT 1"));
        if (next == null) {
            return;
        }

        YmsYardTaskDO yardTask = yardTaskMapper.selectById(next.getYardTaskId());
        YardDockDO dock = yardDockMapper.selectById(dockId);
        dockQueueMapper.update(null, Wrappers.<YmsDockQueueDO>lambdaUpdate()
            .eq(YmsDockQueueDO::getId, next.getId())
            .set(YmsDockQueueDO::getQueueStatus, "ENTERED")
            .set(YmsDockQueueDO::getEnterDockTime, new Date()));
        if (yardTask == null || dock == null || YARD_TERMINAL.contains(yardTask.getYardStatus())) {
            return;
        }

        boolean moveTaskCreated = createDockInTask(yardTask, dock);
        String newStatus = moveTaskCreated ? "ARRIVED" : "DOCK_ASSIGNED";
        yardTaskMapper.update(null, Wrappers.<YmsYardTaskDO>lambdaUpdate()
            .eq(YmsYardTaskDO::getId, yardTask.getId())
            .set(YmsYardTaskDO::getYardStatus, newStatus)
            .set(YmsYardTaskDO::getDockId, dock.getId())
            .set(YmsYardTaskDO::getDockCode, dock.getDockCode())
            .set(YmsYardTaskDO::getDockAssignTime, new Date()));
        writeYardLog(yardTask.getId(),
            moveTaskCreated ? "DOCK_MOVE_TASK_CREATED" : "QUEUE_ENTER_DOCK",
            yardTask.getYardStatus(), newStatus,
            moveTaskCreated ? "道口释放后生成 YardGo 上口/换口任务，等待司机领取" : "道口释放后排队任务直接进入道口");
    }

    private boolean createDockInTask(YmsYardTaskDO yardTask, YardDockDO dock) {
        if (hasOpenDockInTask(yardTask.getId(), dock.getId())) {
            return true;
        }
        boolean isContainer = DEVANNING_TYPES.contains(yardTask.getTaskType());
        Long objectId = null;
        String objectNo = null;
        Long fromPositionId = null;
        String fromPositionCode = null;
        Long currentDockId = null;

        if (isContainer) {
            YmsContainerResourceDO resource = findContainerResource(yardTask);
            if (resource != null) {
                objectId = resource.getId();
                objectNo = resource.getContainerNo();
                boolean onDock = isContainerPhysicallyOnDock(resource);
                currentDockId = onDock ? resource.getDockId() : null;
                fromPositionId = onDock ? resource.getDockId() : resource.getYardPositionId();
                fromPositionCode = onDock ? resource.getDockCode() : null;
            }
        } else if (!isContainer) {
            YmsTrailerResourceDO resource = findTrailerResource(yardTask);
            if (resource != null) {
                objectId = resource.getId();
                objectNo = StrUtil.blankToDefault(resource.getTrailerNo(), resource.getPlateNo());
                boolean onDock = isTrailerPhysicallyOnDock(resource);
                currentDockId = onDock ? resource.getDockId() : null;
                fromPositionId = onDock ? resource.getDockId() : resource.getYardPositionId();
                fromPositionCode = onDock ? resource.getDockCode() : null;
            }
        }

        if (objectId == null || Objects.equals(currentDockId, dock.getId())) {
            return false;
        }

        YmsInternalTaskCreateReqVO bo = new YmsInternalTaskCreateReqVO();
        bo.setWarehouseId(yardTask.getWarehouseId());
        bo.setInternalTaskType("DOCK_IN");
        bo.setObjectType(isContainer ? "CONTAINER" : "TRAILER");
        bo.setObjectId(objectId);
        bo.setObjectNo(objectNo);
        bo.setFromPositionId(fromPositionId);
        bo.setFromPositionCode(fromPositionCode);
        bo.setToDockId(dock.getId());
        bo.setToDockCode(dock.getDockCode());
        bo.setParentYardTaskId(yardTask.getId());
        bo.setParentYardTaskNo(yardTask.getYardTaskNo());
        bo.setPriority(yardTask.getPriority());
        doCreate(bo);
        return true;
    }

    private boolean isContainerPhysicallyOnDock(YmsContainerResourceDO resource) {
        return resource.getDockId() != null && CONTAINER_ON_DOCK_STATUS.contains(resource.getContainerStatus());
    }

    private boolean isTrailerPhysicallyOnDock(YmsTrailerResourceDO resource) {
        return resource.getDockId() != null && TRAILER_ON_DOCK_STATUS.contains(resource.getTrailerStatus());
    }

    private YmsContainerResourceDO findContainerResource(YmsYardTaskDO yardTask) {
        if (yardTask.getContainerResourceId() != null) {
            YmsContainerResourceDO resource = containerResourceMapper.selectById(yardTask.getContainerResourceId());
            if (resource != null
                && Objects.equals(resource.getWarehouseId(), yardTask.getWarehouseId())
                && !"LEFT_YARD".equals(resource.getContainerStatus())
                && !"RETURNED".equals(resource.getContainerStatus())) {
                return resource;
            }
        }
        if (StrUtil.isBlank(yardTask.getContainerNo())) {
            return null;
        }
        return containerResourceMapper.selectOne(
            Wrappers.<YmsContainerResourceDO>lambdaQuery()
                .eq(YmsContainerResourceDO::getWarehouseId, yardTask.getWarehouseId())
                .eq(YmsContainerResourceDO::getContainerNo, yardTask.getContainerNo())
                .ne(YmsContainerResourceDO::getContainerStatus, "LEFT_YARD")
                .ne(YmsContainerResourceDO::getContainerStatus, "RETURNED")
                .last("LIMIT 1"));
    }

    private boolean hasOpenDockInTask(Long yardTaskId, Long targetDockId) {
        return baseMapper.selectCount(Wrappers.<YmsInternalTaskDO>lambdaQuery()
            .eq(YmsInternalTaskDO::getParentYardTaskId, yardTaskId)
            .eq(YmsInternalTaskDO::getInternalTaskType, "DOCK_IN")
            .eq(YmsInternalTaskDO::getToDockId, targetDockId)
            .notIn(YmsInternalTaskDO::getTaskStatus, "COMPLETED", "FAILED", "CANCELLED")) > 0;
    }

    private YmsTrailerResourceDO findTrailerResource(YmsYardTaskDO yardTask) {
        if (yardTask.getTrailerResourceId() != null) {
            YmsTrailerResourceDO resource = trailerResourceMapper.selectById(yardTask.getTrailerResourceId());
            if (resource != null
                && Objects.equals(resource.getWarehouseId(), yardTask.getWarehouseId())
                && !"LEFT_YARD".equals(resource.getTrailerStatus())) {
                return resource;
            }
        }
        if (StrUtil.isNotBlank(yardTask.getTruckNo())) {
            YmsTrailerResourceDO resource = trailerResourceMapper.selectOne(
                Wrappers.<YmsTrailerResourceDO>lambdaQuery()
                    .eq(YmsTrailerResourceDO::getWarehouseId, yardTask.getWarehouseId())
                    .and(w -> w.eq(YmsTrailerResourceDO::getPlateNo, yardTask.getTruckNo())
                        .or()
                        .eq(YmsTrailerResourceDO::getTrailerNo, yardTask.getTruckNo()))
                    .ne(YmsTrailerResourceDO::getTrailerStatus, "LEFT_YARD")
                    .last("LIMIT 1"));
            if (resource != null) {
                return resource;
            }
        }
        if (StrUtil.isBlank(yardTask.getSourceOrderNo())) {
            return null;
        }
        return trailerResourceMapper.selectOne(
            Wrappers.<YmsTrailerResourceDO>lambdaQuery()
                .eq(YmsTrailerResourceDO::getWarehouseId, yardTask.getWarehouseId())
                .eq(YmsTrailerResourceDO::getRelatedOrderNo, yardTask.getSourceOrderNo())
                .ne(YmsTrailerResourceDO::getTrailerStatus, "LEFT_YARD")
                .last("LIMIT 1"));
    }

    private void writeYardLog(Long taskId, String type, String before, String after, String content) {
        YmsYardTaskLogDO log = new YmsYardTaskLogDO();
        log.setId(IdUtil.getSnowflakeNextId());
        log.setYardTaskId(taskId);
        log.setActionType(type);
        log.setBeforeStatus(before);
        log.setAfterStatus(after);
        log.setActionContent(content);
        log.setActionTime(new Date());
        yardTaskLogMapper.insert(log);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean fail(Long id, String reason) {
        YmsInternalTaskDO task = requireActive(id, Set.of("PENDING", "ASSIGNED", "ACCEPTED", "IN_PROGRESS"));
        if (StrUtil.isBlank(reason)) {
            throw new ServiceException(500, "请填写失败原因");
        }
        return baseMapper.update(null, Wrappers.<YmsInternalTaskDO>lambdaUpdate()
            .eq(YmsInternalTaskDO::getId, task.getId())
            .set(YmsInternalTaskDO::getTaskStatus, "FAILED")
            .set(YmsInternalTaskDO::getFailReason, reason)
            .set(YmsInternalTaskDO::getFinishTime, new Date())) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean cancel(Long id, String reason) {
        YmsInternalTaskDO task = requireActive(id, Set.of("PENDING", "ASSIGNED", "ACCEPTED"));
        return baseMapper.update(null, Wrappers.<YmsInternalTaskDO>lambdaUpdate()
            .eq(YmsInternalTaskDO::getId, task.getId())
            .set(YmsInternalTaskDO::getTaskStatus, "CANCELLED")
            .set(StrUtil.isNotBlank(reason), YmsInternalTaskDO::getFailReason, reason)
            .set(YmsInternalTaskDO::getFinishTime, new Date())) > 0;
    }

    private void enrichFromReferences(YmsInternalTaskCreateReqVO bo) {
        if (bo.getParentYardTaskId() != null && StrUtil.isBlank(bo.getParentYardTaskNo())) {
            YmsYardTaskDO yardTask = yardTaskMapper.selectById(bo.getParentYardTaskId());
            if (yardTask != null) {
                bo.setParentYardTaskNo(yardTask.getYardTaskNo());
                if (bo.getWarehouseId() == null) {
                    bo.setWarehouseId(yardTask.getWarehouseId());
                }
            }
        }
        if (bo.getFromPositionId() != null && StrUtil.isBlank(bo.getFromPositionCode())) {
            YardDockDO pos = yardDockMapper.selectById(bo.getFromPositionId());
            if (pos != null) {
                bo.setFromPositionCode(pos.getDockCode());
            }
        }
        if (bo.getToPositionId() != null && StrUtil.isBlank(bo.getToPositionCode())) {
            YardDockDO pos = yardDockMapper.selectById(bo.getToPositionId());
            if (pos != null) {
                bo.setToPositionCode(pos.getDockCode());
            }
        }
        if (bo.getToDockId() != null && StrUtil.isBlank(bo.getToDockCode())) {
            YardDockDO dock = yardDockMapper.selectById(bo.getToDockId());
            if (dock != null) {
                bo.setToDockCode(dock.getDockCode());
            }
        }
    }

    private YmsInternalTaskDO requireActive(Long id, Set<String> allowed) {
        YmsInternalTaskDO task = baseMapper.selectById(id);
        if (task == null) {
            throw new ServiceException(500, "院内任务不存在");
        }
        if (TERMINAL.contains(task.getTaskStatus())) {
            throw new ServiceException(500, "任务已结束，不可操作");
        }
        if (!allowed.contains(task.getTaskStatus())) {
            throw new ServiceException(500, "当前状态[" + task.getTaskStatus() + "]不允许此操作");
        }
        return task;
    }

    private Boolean updateStatus(Long id, String newStatus, Map<String, Object> extra) {
        var uw = Wrappers.<YmsInternalTaskDO>lambdaUpdate().eq(YmsInternalTaskDO::getId, id)
            .set(YmsInternalTaskDO::getTaskStatus, newStatus);
        extra.forEach((k, v) -> {
            switch (k) {
                case "acceptTime" -> uw.set(YmsInternalTaskDO::getAcceptTime, (Date) v);
                case "startTime" -> uw.set(YmsInternalTaskDO::getStartTime, (Date) v);
                case "finishTime" -> uw.set(YmsInternalTaskDO::getFinishTime, (Date) v);
                default -> { }
            }
        });
        return baseMapper.update(null, uw) > 0;
    }

    private String generateTaskNo() {
        String date = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        return "IT" + date + String.format("%06d", System.currentTimeMillis() % 1000000);
    }
}
