package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.framework.common.util.object.BeanUtils;

import cn.iocoder.yudao.module.yms.util.YmsPageUtils;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.IdUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.exception.ServiceException;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.dal.dataobject.yarddock.YardDockDO;
import cn.iocoder.yudao.module.base.dal.dataobject.yardzone.YardZoneDO;
import cn.iocoder.yudao.module.base.dal.mysql.yarddock.YardDockMapper;
import cn.iocoder.yudao.module.base.dal.mysql.yardzone.YardZoneMapper;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsContainerResourceDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsTrailerResourceDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsYardInventoryItemDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsYardInventoryTaskDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardInventoryScanReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardInventoryTaskCreateReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardInventoryTaskQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardInventoryItemRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardInventoryTaskRespVO;
import cn.iocoder.yudao.module.yms.dal.mysql.*;
import cn.iocoder.yudao.module.yms.service.YmsYardInventoryService;
import cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;


@Service
public class YmsYardInventoryServiceImpl implements YmsYardInventoryService {

    private static final Set<String> IN_YARD_CONTAINER_STATUS = Set.of(
        "LEFT_YARD", "RETURNED", "EXPECTED_ARRIVAL");
    private static final Set<String> IN_YARD_TRAILER_STATUS = Set.of(
        "LEFT_YARD", "EXPECTED_ARRIVAL");

    @Resource
    private YmsYardInventoryTaskMapper taskMapper;
    @Resource
    private YmsYardInventoryItemMapper itemMapper;
    @Resource
    private YardZoneMapper zoneMapper;
    @Resource
    private YardDockMapper yardDockMapper;
    @Resource
    private YmsContainerResourceMapper containerMapper;
    @Resource
    private YmsTrailerResourceMapper trailerMapper;

    @Override
    public PageResult<YmsYardInventoryTaskRespVO> queryPageList(YmsYardInventoryTaskQueryReqVO bo, PageParam pageParam) {
        return YmsPageUtils.toPageResult(taskMapper.selectPageList(YmsPageUtils.toPage(pageParam), bo));
    }

    @Override
    public YmsYardInventoryTaskRespVO queryById(Long id) {
        YmsYardInventoryTaskRespVO vo = taskMapper.selectDetailById(id);
        if (vo == null) {
            throw new ServiceException(500, "盘点任务不存在");
        }
        vo.setItems(itemMapper.selectListByInventoryId(id));
        return vo;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public YmsYardInventoryTaskRespVO create(YmsYardInventoryTaskCreateReqVO bo) {
        validateCreateBo(bo);

        YmsYardInventoryTaskDO task = new YmsYardInventoryTaskDO();
        task.setId(IdUtil.getSnowflakeNextId());
        task.setWarehouseId(bo.getWarehouseId());
        task.setInventoryNo(generateInventoryNo());
        task.setInventoryType(bo.getInventoryType());
        task.setStatus("PENDING");
        task.setExpectedCount(0);
        task.setActualCount(0);
        task.setDiffCount(0);
        task.setRemark(bo.getRemark());

        if ("ZONE".equals(bo.getInventoryType())) {
            YardZoneDO zone = zoneMapper.selectById(bo.getZoneId());
            if (zone == null) {
                throw new ServiceException(500, "盘点区域不存在");
            }
            task.setZoneId(zone.getId());
            task.setZoneCode(zone.getZoneCode());
        }

        List<YmsYardInventoryItemDO> items = buildExpectedItems(task, bo);
        task.setExpectedCount(items.size());
        taskMapper.insert(task);

        for (YmsYardInventoryItemDO item : items) {
            item.setId(IdUtil.getSnowflakeNextId());
            item.setInventoryId(task.getId());
            item.setScanStatus("PENDING");
            itemMapper.insert(item);
        }

        return queryById(task.getId());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean start(Long id) {
        YmsYardInventoryTaskDO task = requireTask(id, Set.of("PENDING"));
        return taskMapper.update(null, Wrappers.<YmsYardInventoryTaskDO>lambdaUpdate()
            .eq(YmsYardInventoryTaskDO::getId, task.getId())
            .set(YmsYardInventoryTaskDO::getStatus, "IN_PROGRESS")
            .set(YmsYardInventoryTaskDO::getStartTime, new Date())
            .set(YmsYardInventoryTaskDO::getOperatorId, SecurityFrameworkUtils.getLoginUserId())
            .set(YmsYardInventoryTaskDO::getOperatorName, resolveOperatorName())) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public YmsYardInventoryItemRespVO scan(YmsYardInventoryScanReqVO bo) {
        YmsYardInventoryTaskDO task = requireTask(bo.getInventoryId(), Set.of("IN_PROGRESS"));

        String objectNo = bo.getObjectNo().trim().toUpperCase();
        YmsYardInventoryItemDO item = itemMapper.selectOne(
            Wrappers.<YmsYardInventoryItemDO>lambdaQuery()
                .eq(YmsYardInventoryItemDO::getInventoryId, task.getId())
                .eq(YmsYardInventoryItemDO::getObjectNo, objectNo)
                .last("LIMIT 1"));

        Date now = new Date();
        if (item == null) {
            item = new YmsYardInventoryItemDO();
            item.setId(IdUtil.getSnowflakeNextId());
            item.setInventoryId(task.getId());
            item.setObjectNo(objectNo);
            item.setObjectType(StrUtil.blankToDefault(bo.getObjectType(), guessObjectType(objectNo, task)));
            item.setScanStatus("EXTRA");
            item.setDiffType("EXTRA");
        } else {
            item.setScanStatus("SCANNED");
            item.setDiffType(null);
        }

        enrichActualPosition(item, bo);
        detectPositionMismatch(item);

        item.setPhotoUrls(bo.getPhotoUrls());
        item.setRemark(bo.getRemark());
        item.setScanTime(now);

        if (itemMapper.selectById(item.getId()) == null) {
            itemMapper.insert(item);
        } else {
            itemMapper.updateById(item);
        }

        recalcTaskCounts(task.getId());
        return BeanUtils.toBean(itemMapper.selectById(item.getId()), YmsYardInventoryItemRespVO.class);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public YmsYardInventoryTaskRespVO complete(Long id) {
        YmsYardInventoryTaskDO task = requireTask(id, Set.of("IN_PROGRESS"));

        List<YmsYardInventoryItemDO> pendingItems = itemMapper.selectList(
            Wrappers.<YmsYardInventoryItemDO>lambdaQuery()
                .eq(YmsYardInventoryItemDO::getInventoryId, id)
                .eq(YmsYardInventoryItemDO::getScanStatus, "PENDING"));

        for (YmsYardInventoryItemDO pending : pendingItems) {
            pending.setScanStatus("MISSING");
            pending.setDiffType("MISSING");
            itemMapper.updateById(pending);
        }

        int diffCount = recalcTaskCounts(id);
        String newStatus = diffCount > 0 ? "DIFF_FOUND" : "COMPLETED";

        taskMapper.update(null, Wrappers.<YmsYardInventoryTaskDO>lambdaUpdate()
            .eq(YmsYardInventoryTaskDO::getId, id)
            .set(YmsYardInventoryTaskDO::getStatus, newStatus)
            .set(YmsYardInventoryTaskDO::getFinishTime, new Date()));

        return queryById(id);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean confirmDiff(Long id) {
        requireTask(id, Set.of("DIFF_FOUND"));
        return taskMapper.update(null, Wrappers.<YmsYardInventoryTaskDO>lambdaUpdate()
            .eq(YmsYardInventoryTaskDO::getId, id)
            .set(YmsYardInventoryTaskDO::getStatus, "COMPLETED")
            .set(YmsYardInventoryTaskDO::getFinishTime, new Date())) > 0;
    }

    private void validateCreateBo(YmsYardInventoryTaskCreateReqVO bo) {
        if ("ZONE".equals(bo.getInventoryType()) && bo.getZoneId() == null) {
            throw new ServiceException(500, "区域盘点需选择分区");
        }
        if ("CONTAINER_LIST".equals(bo.getInventoryType()) && CollUtil.isEmpty(bo.getObjectNos())) {
            throw new ServiceException(500, "指定列表盘点需提供对象编号");
        }
    }

    private List<YmsYardInventoryItemDO> buildExpectedItems(YmsYardInventoryTaskDO task,
                                                            YmsYardInventoryTaskCreateReqVO bo) {
        return switch (bo.getInventoryType()) {
            case "ZONE" -> buildZoneItems(task.getWarehouseId(), bo.getZoneId());
            case "FULL" -> buildFullItems(task.getWarehouseId());
            case "CONTAINER_LIST" -> buildListItems(task.getWarehouseId(), bo.getObjectNos());
            default -> throw new ServiceException(500, "不支持的盘点类型: " + bo.getInventoryType());
        };
    }

    private List<YmsYardInventoryItemDO> buildZoneItems(Long warehouseId, Long zoneId) {
        List<YardDockDO> positions = yardDockMapper.selectList(
            Wrappers.<YardDockDO>lambdaQuery()
                .eq(YardDockDO::getWarehouseId, warehouseId)
                .eq(YardDockDO::getZoneId, zoneId)
                .eq(YardDockDO::getDockStatus, "OCCUPIED")
                .isNotNull(YardDockDO::getOccupiedObjectNo));

        List<YmsYardInventoryItemDO> items = new ArrayList<>();
        for (YardDockDO pos : positions) {
            items.add(toExpectedItem(pos));
        }
        return items;
    }

    private List<YmsYardInventoryItemDO> buildFullItems(Long warehouseId) {
        List<YmsYardInventoryItemDO> items = new ArrayList<>();

        List<YmsContainerResourceDO> containers = containerMapper.selectList(
            Wrappers.<YmsContainerResourceDO>lambdaQuery()
                .eq(YmsContainerResourceDO::getWarehouseId, warehouseId)
                .notIn(YmsContainerResourceDO::getContainerStatus, IN_YARD_CONTAINER_STATUS));
        for (YmsContainerResourceDO c : containers) {
            items.add(toExpectedItem("CONTAINER", c.getContainerNo(), c.getYardPositionId(), null));
        }

        List<YmsTrailerResourceDO> trailers = trailerMapper.selectList(
            Wrappers.<YmsTrailerResourceDO>lambdaQuery()
                .eq(YmsTrailerResourceDO::getWarehouseId, warehouseId)
                .notIn(YmsTrailerResourceDO::getTrailerStatus, IN_YARD_TRAILER_STATUS));
        for (YmsTrailerResourceDO t : trailers) {
            String no = StrUtil.blankToDefault(t.getTrailerNo(), t.getPlateNo());
            if (StrUtil.isNotBlank(no)) {
                items.add(toExpectedItem("TRAILER", no, t.getYardPositionId(), null));
            }
        }
        return dedupeItems(items);
    }

    private List<YmsYardInventoryItemDO> buildListItems(Long warehouseId, List<String> objectNos) {
        List<YmsYardInventoryItemDO> items = new ArrayList<>();
        for (String raw : objectNos) {
            if (StrUtil.isBlank(raw)) {
                continue;
            }
            String no = raw.trim().toUpperCase();
            YmsContainerResourceDO container = containerMapper.selectOne(
                Wrappers.<YmsContainerResourceDO>lambdaQuery()
                    .eq(YmsContainerResourceDO::getWarehouseId, warehouseId)
                    .eq(YmsContainerResourceDO::getContainerNo, no)
                    .notIn(YmsContainerResourceDO::getContainerStatus, IN_YARD_CONTAINER_STATUS)
                    .last("LIMIT 1"));
            if (container != null) {
                items.add(toExpectedItem("CONTAINER", no, container.getYardPositionId(), null));
                continue;
            }
            YmsTrailerResourceDO trailer = trailerMapper.selectOne(
                Wrappers.<YmsTrailerResourceDO>lambdaQuery()
                    .eq(YmsTrailerResourceDO::getWarehouseId, warehouseId)
                    .and(w -> w.eq(YmsTrailerResourceDO::getTrailerNo, no).or().eq(YmsTrailerResourceDO::getPlateNo, no))
                    .notIn(YmsTrailerResourceDO::getTrailerStatus, IN_YARD_TRAILER_STATUS)
                    .last("LIMIT 1"));
            if (trailer != null) {
                items.add(toExpectedItem("TRAILER", no, trailer.getYardPositionId(), null));
            } else {
                YmsYardInventoryItemDO item = new YmsYardInventoryItemDO();
                item.setObjectType("CONTAINER");
                item.setObjectNo(no);
                items.add(item);
            }
        }
        return items;
    }

    private YmsYardInventoryItemDO toExpectedItem(YardDockDO pos) {
        return toExpectedItem(
            pos.getOccupiedObjectType(),
            pos.getOccupiedObjectNo(),
            pos.getId(),
            pos.getDockCode());
    }

    private YmsYardInventoryItemDO toExpectedItem(String objectType, String objectNo,
                                                  Long positionId, String positionCode) {
        YmsYardInventoryItemDO item = new YmsYardInventoryItemDO();
        item.setObjectType(StrUtil.blankToDefault(objectType, "CONTAINER"));
        item.setObjectNo(objectNo);
        item.setSystemPositionId(positionId);
        if (StrUtil.isBlank(positionCode) && positionId != null) {
            YardDockDO pos = yardDockMapper.selectById(positionId);
            if (pos != null) {
                item.setSystemPositionCode(pos.getDockCode());
            }
        } else {
            item.setSystemPositionCode(positionCode);
        }
        return item;
    }

    private List<YmsYardInventoryItemDO> dedupeItems(List<YmsYardInventoryItemDO> items) {
        Map<String, YmsYardInventoryItemDO> map = new LinkedHashMap<>();
        for (YmsYardInventoryItemDO item : items) {
            if (StrUtil.isNotBlank(item.getObjectNo())) {
                map.putIfAbsent(item.getObjectNo().toUpperCase(), item);
            }
        }
        return new ArrayList<>(map.values());
    }

    private void enrichActualPosition(YmsYardInventoryItemDO item, YmsYardInventoryScanReqVO bo) {
        if (bo.getActualPositionId() != null) {
            item.setActualPositionId(bo.getActualPositionId());
            if (StrUtil.isBlank(bo.getActualPositionCode())) {
                YardDockDO pos = yardDockMapper.selectById(bo.getActualPositionId());
                if (pos != null) {
                    item.setActualPositionCode(pos.getDockCode());
                }
            } else {
                item.setActualPositionCode(bo.getActualPositionCode());
            }
            return;
        }
        if (StrUtil.isNotBlank(bo.getActualPositionCode())) {
            item.setActualPositionCode(bo.getActualPositionCode());
            YardDockDO pos = yardDockMapper.selectOne(
                Wrappers.<YardDockDO>lambdaQuery()
                    .eq(YardDockDO::getDockCode, bo.getActualPositionCode())
                    .last("LIMIT 1"));
            if (pos != null) {
                item.setActualPositionId(pos.getId());
            }
        }
    }

    private void detectPositionMismatch(YmsYardInventoryItemDO item) {
        if ("EXTRA".equals(item.getScanStatus())) {
            return;
        }
        if (item.getSystemPositionId() != null && item.getActualPositionId() != null
            && !Objects.equals(item.getSystemPositionId(), item.getActualPositionId())) {
            item.setDiffType("POSITION_MISMATCH");
        } else if (StrUtil.isNotBlank(item.getSystemPositionCode())
            && StrUtil.isNotBlank(item.getActualPositionCode())
            && !item.getSystemPositionCode().equalsIgnoreCase(item.getActualPositionCode())) {
            item.setDiffType("POSITION_MISMATCH");
        }
    }

    private int recalcTaskCounts(Long inventoryId) {
        List<YmsYardInventoryItemDO> all = itemMapper.selectList(
            Wrappers.<YmsYardInventoryItemDO>lambdaQuery()
                .eq(YmsYardInventoryItemDO::getInventoryId, inventoryId));

        int actual = (int) all.stream()
            .filter(i -> "SCANNED".equals(i.getScanStatus()) || "EXTRA".equals(i.getScanStatus()))
            .count();
        int diff = (int) all.stream()
            .filter(i -> StrUtil.isNotBlank(i.getDiffType())
                || "MISSING".equals(i.getScanStatus())
                || "EXTRA".equals(i.getScanStatus()))
            .count();

        taskMapper.update(null, Wrappers.<YmsYardInventoryTaskDO>lambdaUpdate()
            .eq(YmsYardInventoryTaskDO::getId, inventoryId)
            .set(YmsYardInventoryTaskDO::getActualCount, actual)
            .set(YmsYardInventoryTaskDO::getDiffCount, diff));

        return diff;
    }

    private String guessObjectType(String objectNo, YmsYardInventoryTaskDO task) {
        YmsContainerResourceDO c = containerMapper.selectOne(
            Wrappers.<YmsContainerResourceDO>lambdaQuery()
                .eq(YmsContainerResourceDO::getWarehouseId, task.getWarehouseId())
                .eq(YmsContainerResourceDO::getContainerNo, objectNo)
                .last("LIMIT 1"));
        if (c != null) {
            return "CONTAINER";
        }
        return "TRAILER";
    }

    private YmsYardInventoryTaskDO requireTask(Long id, Set<String> allowedStatus) {
        YmsYardInventoryTaskDO task = taskMapper.selectById(id);
        if (task == null) {
            throw new ServiceException(500, "盘点任务不存在");
        }
        if (!allowedStatus.contains(task.getStatus())) {
            throw new ServiceException(500, "当前状态[" + task.getStatus() + "]不允许此操作");
        }
        return task;
    }

    private String generateInventoryNo() {
        String date = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        return "INV" + date + String.format("%04d", System.currentTimeMillis() % 10000);
    }

    private String resolveOperatorName() {
        String nickname = SecurityFrameworkUtils.getLoginUserNickname();
        if (StrUtil.isNotBlank(nickname)) {
            return nickname;
        }
        return String.valueOf(SecurityFrameworkUtils.getLoginUserId());
    }
}
