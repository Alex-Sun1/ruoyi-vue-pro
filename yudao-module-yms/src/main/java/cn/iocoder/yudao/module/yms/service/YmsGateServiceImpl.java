package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.framework.common.util.object.BeanUtils;

import cn.iocoder.yudao.module.yms.util.YmsPageUtils;

import cn.hutool.core.util.IdUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import cn.iocoder.yudao.module.base.dal.dataobject.yarddock.YardDockDO;
import cn.iocoder.yudao.module.base.dal.mysql.yarddock.YardDockMapper;
import cn.iocoder.yudao.framework.common.exception.ServiceException;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsCheckInDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsContainerResourceDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsInternalTaskDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsTrailerResourceDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsYardTaskDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCheckInReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCheckInQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCheckOutReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsDriverSelfCheckInReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsInYardQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsUnifiedCheckInReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCheckInReceiptRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCheckInRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCheckOutRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsDriverSelfCheckInRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsInYardRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsParkingSlotRespVO;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsCheckInMapper;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsContainerResourceMapper;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsInternalTaskMapper;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsTrailerResourceMapper;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsYardTaskMapper;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsTrailerCheckinReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsTrailerCheckinLookupRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsTrailerCheckinResultRespVO;
import cn.iocoder.yudao.module.yms.integration.YmsSourceOrderSyncHandler;
import cn.iocoder.yudao.module.yms.integration.YmsTrailerDispatchQueryHandler;
import cn.iocoder.yudao.module.yms.service.YmsContainerResourceService;
import cn.iocoder.yudao.module.yms.service.YmsDispatchService;
import cn.iocoder.yudao.module.yms.service.YmsGateService;
import cn.iocoder.yudao.module.yms.service.YmsTrailerResourceService;
import cn.iocoder.yudao.module.yms.support.YmsYardLocationSupport;
import cn.iocoder.yudao.module.yms.support.YmsYardLocationTypes;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Set;


@Service
@Slf4j
public class YmsGateServiceImpl implements YmsGateService {

    // OMS 同步 handlers（由 OMS 模块注入，无实现时为空列表）
    @Autowired(required = false)
    private List<YmsSourceOrderSyncHandler> sourceOrderSyncHandlers;
    // 派送明细查询集成（由 OMS 模块注入，可选）
    @Resource
    private ObjectProvider<YmsTrailerDispatchQueryHandler> trailerDispatchQueryHandlerProvider;

    private static final Set<String> CONTAINER_BLOCK_STATUS = Set.of("ON_DOCK", "DEVANNING", "CALLED");
    private static final Set<String> CONTAINER_PASS_STATUS = Set.of("EMPTY_WAIT_RETURN", "DEVANNED");
    private static final Set<String> TRAILER_BLOCK_STATUS = Set.of("ON_DOCK", "LOADING");
    private static final Set<String> TRAILER_PASS_STATUS = Set.of("LOADED", "WAIT_PICKUP");

    @Resource
    private YmsCheckInMapper checkInMapper;
    @Resource
    private YmsYardTaskMapper yardTaskMapper;
    @Resource
    private YmsInternalTaskMapper internalTaskMapper;
    @Resource
    private YmsContainerResourceMapper containerResourceMapper;
    @Resource
    private YmsTrailerResourceMapper trailerResourceMapper;
    @Resource
    private YardDockMapper yardDockMapper;
    @Resource
    private YmsYardLocationSupport locationSupport;
    @Resource
    private YmsContainerResourceService containerResourceService;
    @Resource
    private YmsTrailerResourceService trailerResourceService;
    @Resource
    private YmsDispatchService dispatchService;

    // ─── 列表查询 ──────────────────────────────────────────────────────────────

    @Override
    public PageResult<YmsCheckInRespVO> queryPageList(YmsCheckInQueryReqVO bo, PageParam pageParam) {
        return YmsPageUtils.toPageResult(checkInMapper.selectPageList(YmsPageUtils.toPage(pageParam), bo));
    }

    @Override
    public PageResult<YmsInYardRespVO> queryInYardList(YmsInYardQueryReqVO bo, PageParam pageParam) {
        return YmsPageUtils.toPageResult(checkInMapper.selectInYardPageList(YmsPageUtils.toPage(pageParam), bo));
    }

    // ─── 门岗统一 Check-in ────────────────────────────────────────────────────

    @Override
    @Transactional(rollbackFor = Exception.class)
    public YmsCheckInRespVO unifiedCheckIn(YmsUnifiedCheckInReqVO bo) {
        boolean hasContainer = StrUtil.isNotBlank(bo.getContainerNo());
        boolean hasTrailer = StrUtil.isNotBlank(bo.getTrailerNo());
        boolean hasLoadingNo = StrUtil.isNotBlank(bo.getLoadingNo());
        boolean hasPlate = StrUtil.isNotBlank(bo.getPlateNo());

        if (!hasContainer && !hasTrailer && !hasLoadingNo && !hasPlate) {
            throw new ServiceException(500, "海柜号、装车号、车厢号、车牌号至少填写一项");
        }

        // 同车牌已在场校验
        if (hasPlate && isAlreadyInYard(bo.getWarehouseId(), bo.getPlateNo())) {
            return buildBlockedRecord(bo.getWarehouseId(),
                hasContainer ? "CONTAINER" : "TRUCK_TRAILER",
                bo.getPlateNo(), bo.getContainerNo(), bo.getTrailerNo(),
                bo.getDriverName(), bo.getDriverPhone(), bo.getVehicleSource(),
                "REJECTED", "同车牌今日已在场", "GATE", bo.getPhotoUrls(), bo.getRemark());
        }

        String checkInType = hasContainer ? "CONTAINER" : "TRUCK_TRAILER";

        // 查找关联的已推送 yard_task，用于 OMS 数据比对
        YmsYardTaskDO relatedTask = findRelatedTask(bo.getWarehouseId(), bo.getContainerNo(),
            bo.getTrailerNo(), bo.getLoadingNo(), bo.getPlateNo());

        if (!hasContainer && hasLoadingNo && relatedTask == null) {
            return buildBlockedRecord(bo.getWarehouseId(), "TRUCK_TRAILER",
                bo.getPlateNo(), null, bo.getTrailerNo(),
                bo.getDriverName(), bo.getDriverPhone(), bo.getVehicleSource(),
                "REJECTED", "未找到可入场的装车任务，请确认装车号是否已进入任务池",
                "GATE", bo.getPhotoUrls(), bo.getRemark());
        }

        // OMS 数据比对（仅当有关联任务时才比对）
        List<String> mismatchFields = new ArrayList<>();
        if (relatedTask != null) {
            if (hasPlate && StrUtil.isNotBlank(relatedTask.getTruckNo())
                    && !StrUtil.equalsIgnoreCase(bo.getPlateNo(), relatedTask.getTruckNo())) {
                mismatchFields.add("plate_no");
            }
            if (StrUtil.isNotBlank(bo.getDriverName()) && StrUtil.isNotBlank(relatedTask.getDriverName())
                    && !StrUtil.equalsIgnoreCase(bo.getDriverName(), relatedTask.getDriverName())) {
                mismatchFields.add("driver_name");
            }
            if (StrUtil.isNotBlank(bo.getDriverPhone()) && StrUtil.isNotBlank(relatedTask.getDriverPhone())
                    && !StrUtil.equalsIgnoreCase(bo.getDriverPhone(), relatedTask.getDriverPhone())) {
                mismatchFields.add("driver_phone");
            }
        }

        // 解析位置（道口或堆场位）
        YardDockDO positionSlot = null;
        String positionCode = bo.getPositionCode();
        Long positionId = null;
        if (StrUtil.isNotBlank(positionCode)) {
            positionSlot = findSlotByCode(bo.getWarehouseId(), positionCode);
            if (positionSlot != null) positionId = positionSlot.getId();
        }

        // 生成或更新资源记录
        Long containerResourceId = null;
        Long trailerResourceId = null;
        if (hasContainer) {
            containerResourceId = upsertContainerResource(bo.getWarehouseId(), bo.getContainerNo(),
                bo.getPlateNo(), bo.getDriverName(), bo.getDriverPhone(), positionSlot);
        } else if (hasLoadingNo && !hasTrailer && !hasPlate) {
            trailerResourceId = null;
        } else {
            trailerResourceId = upsertTrailerResource(bo.getWarehouseId(), bo.getPlateNo(), bo.getTrailerNo(),
                bo.getVehicleSource(), bo.getDriverName(), bo.getDriverPhone(), null, positionSlot);
        }

        // 推进 yard_task 状态，并同步到 OMS。直达道口不生成院内任务，实物已到作业点。
        Date checkInTime = new Date();
        if (relatedTask != null) {
            advanceTaskByCheckInLocation(relatedTask, checkInTime, positionSlot, containerResourceId, trailerResourceId);
            notifyArrival(relatedTask, checkInTime, positionCode);
        }

        // 构建 check-in 记录
        YmsCheckInDO record = new YmsCheckInDO();
        record.setId(IdUtil.getSnowflakeNextId());
        record.setWarehouseId(bo.getWarehouseId());
        record.setCheckInType(checkInType);
        record.setPlateNo(StrUtil.blankToDefault(bo.getPlateNo(), ""));
        record.setContainerNo(bo.getContainerNo());
        record.setTrailerNo(bo.getTrailerNo());
        record.setVehicleSource(bo.getVehicleSource());
        record.setDriverName(bo.getDriverName());
        record.setDriverPhone(bo.getDriverPhone());
        record.setIdCardNo(bo.getIdCardNo());
        record.setTaskType(relatedTask != null ? relatedTask.getTaskType() : (hasContainer ? "DEVANNING" : "LOADING"));
        record.setCheckResult("PASSED");
        record.setMatchType("WALK_IN");
        record.setCheckinSource("GATE");
        record.setPositionId(positionId);
        record.setPositionCode(positionCode);
        record.setOmsMismatchFlag(mismatchFields.isEmpty() ? 0 : 1);
        record.setOmsMismatchFields(mismatchFields.isEmpty() ? null : mismatchFields.toString());
        record.setContainerResourceId(containerResourceId);
        record.setTrailerResourceId(trailerResourceId);
        record.setCheckInTime(checkInTime);
        record.setPhotoUrls(bo.getPhotoUrls());
        record.setRemark(bo.getRemark());
        record.setReceiptNo(generateReceiptNo());

        if (relatedTask != null) {
            record.setYardTaskId(relatedTask.getId());
            record.setYardTaskNo(relatedTask.getYardTaskNo());
        }

        checkInMapper.insert(record);
        return BeanUtils.toBean(checkInMapper.selectById(record.getId()), YmsCheckInRespVO.class);
    }

    // ─── 司机自助 Check-in（H5 公开接口）────────────────────────────────────

    @Override
    @Transactional(rollbackFor = Exception.class)
    public YmsDriverSelfCheckInRespVO driverSelfCheckIn(YmsDriverSelfCheckInReqVO bo) {
        YmsDriverSelfCheckInRespVO result = new YmsDriverSelfCheckInRespVO();

        // 查找堆场位
        YardDockDO slot = findSlotByCode(bo.getWarehouseId(), bo.getPositionCode());
        if (slot == null) {
            result.setSuccess(false);
            result.setMessage("堆场位不存在，请确认编码正确");
            return result;
        }

        String objectNo = StrUtil.trim(bo.getObjectNo());
        YmsYardTaskDO relatedTask = findSelfCheckInTask(bo.getWarehouseId(), objectNo);
        if (relatedTask == null) {
            result.setSuccess(false);
            result.setMessage("未找到可签到的园区任务，请联系门岗或调度员确认任务池");
            return result;
        }
        boolean isDevanningTask = "DEVANNING".equals(relatedTask.getTaskType());

        // 按柜号查海柜资源
        YmsContainerResourceDO container = containerResourceMapper.selectOne(
            Wrappers.<YmsContainerResourceDO>lambdaQuery()
                .eq(YmsContainerResourceDO::getWarehouseId, bo.getWarehouseId())
                .eq(YmsContainerResourceDO::getContainerNo, objectNo)
                .ne(YmsContainerResourceDO::getContainerStatus, "LEFT_YARD")
                .ne(YmsContainerResourceDO::getContainerStatus, "RETURNED")
                .last("LIMIT 1"));

        // 按车厢号查车厢资源
        YmsTrailerResourceDO trailer = null;
        if (container == null) {
            trailer = trailerResourceMapper.selectOne(
                Wrappers.<YmsTrailerResourceDO>lambdaQuery()
                    .eq(YmsTrailerResourceDO::getWarehouseId, bo.getWarehouseId())
                    .eq(YmsTrailerResourceDO::getTrailerNo, objectNo)
                    .ne(YmsTrailerResourceDO::getTrailerStatus, "LEFT_YARD")
                    .last("LIMIT 1"));
        }


        if (isDevanningTask && container == null) {
            container = createTaskBackedContainerResource(relatedTask, objectNo, bo.getDriverPhone(), bo.getDriverName());
        }
        if (!isDevanningTask && trailer == null) {
            trailer = createTaskBackedTrailerResource(relatedTask, objectNo, bo.getDriverPhone(), bo.getDriverName());
        }

        // 分配堆场位
        String objectType;
        Long objectId;
        if (isDevanningTask) {
            objectType = "CONTAINER";
            objectId = container.getId();
            YmsContainerResourceDO update = new YmsContainerResourceDO();
            update.setId(container.getId());
            applySlotToContainer(update, slot);
            if (!"ARRIVED".equals(container.getContainerStatus())) {
                update.setContainerStatus("ARRIVED");
                update.setArrivedTime(new Date());
            }
            if (StrUtil.isNotBlank(bo.getDriverPhone())) update.setDriverPhone(bo.getDriverPhone());
            if (StrUtil.isNotBlank(bo.getDriverName())) update.setDriverName(bo.getDriverName());
            containerResourceMapper.updateById(update);
        } else {
            objectType = "TRAILER";
            objectId = trailer.getId();
            YmsTrailerResourceDO update = new YmsTrailerResourceDO();
            update.setId(trailer.getId());
            applySlotToTrailer(update, slot);
            if (!"ARRIVED_EMPTY".equals(trailer.getTrailerStatus())) {
                update.setTrailerStatus("ARRIVED_EMPTY");
                update.setArriveTime(new Date());
            }
            if (StrUtil.isNotBlank(bo.getDriverPhone())) update.setDriverPhone(bo.getDriverPhone());
            if (StrUtil.isNotBlank(bo.getDriverName())) update.setDriverName(bo.getDriverName());
            trailerResourceMapper.updateById(update);
        }

        // 占用堆场位
        locationSupport.occupySlot(slot.getId(), objectType, objectId, objectNo);

        // 推进关联 yard_task 状态，并同步到 OMS。司机自助如果直接填道口，也视为实物已到道口。
        Date selfCheckInTime = new Date();
        advanceTaskByCheckInLocation(relatedTask, selfCheckInTime, slot,
            "CONTAINER".equals(objectType) ? objectId : null,
            "TRAILER".equals(objectType) ? objectId : null);
        notifyArrival(relatedTask, selfCheckInTime, bo.getPositionCode());

        // 创建 check-in 流水
        YmsCheckInDO record = new YmsCheckInDO();
        record.setId(IdUtil.getSnowflakeNextId());
        record.setWarehouseId(bo.getWarehouseId());
        record.setCheckInType("CONTAINER".equals(objectType) ? "CONTAINER" : "TRUCK_TRAILER");
        record.setContainerNo("CONTAINER".equals(objectType) ? objectNo : null);
        record.setTrailerNo("TRAILER".equals(objectType) ? objectNo : null);
        record.setDriverPhone(bo.getDriverPhone());
        record.setDriverName(bo.getDriverName());
        record.setPlateNo(StrUtil.blankToDefault(relatedTask.getTruckNo(), ""));
        record.setCheckResult("PASSED");
        record.setMatchType("WALK_IN");
        record.setCheckinSource("DRIVER_SELF");
        record.setPositionId(slot.getId());
        record.setPositionCode(bo.getPositionCode());
        record.setOmsMismatchFlag(0);
        record.setPhotoUrls(bo.getPhotoUrls());
        record.setCheckInTime(new Date());
        if ("CONTAINER".equals(objectType)) {
            record.setContainerResourceId(objectId);
        } else {
            record.setTrailerResourceId(objectId);
        }
        if (relatedTask != null) {
            record.setYardTaskId(relatedTask.getId());
            record.setYardTaskNo(relatedTask.getYardTaskNo());
        }
        checkInMapper.insert(record);

        result.setSuccess(true);
        result.setMessage("签到成功，位置：" + bo.getPositionCode());
        result.setPositionCode(bo.getPositionCode());
        result.setObjectNo(objectNo);
        if (relatedTask != null) {
            result.setYardTaskNo(relatedTask.getYardTaskNo());
        }
        return result;
    }

    // ─── Check-out ─────────────────────────────────────────────────────────────

    @Override
    public YmsCheckOutRespVO lookupCheckOut(Long warehouseId, String keyword) {
        String kw = StrUtil.trim(keyword);
        if (StrUtil.isBlank(kw)) {
            return buildCheckOutBlock(null, "请输入车牌/柜号/车厢号");
        }
        List<YmsInYardRespVO> matches = checkInMapper.selectInYardByKeyword(warehouseId, kw);
        if (matches.isEmpty()) {
            return buildCheckOutBlock(null, "未找到在场记录");
        }
        if (matches.size() > 1) {
            return buildCheckOutBlock(null, "匹配到多条在场记录，请输入更精确的车牌/柜号/车厢号");
        }
        YmsInYardRespVO item = matches.get(0);
        YmsCheckOutRespVO vo = toCheckOutVo(item);
        enrichGateInDriver(vo);
        enrichOpenInternalTask(vo);
        String checkOutResult = evaluateCheckOut(item.getObjectType(), item.getCurrentStatus());
        vo.setCheckOutResult(checkOutResult);
        if ("REJECTED".equals(checkOutResult)) {
            vo.setRejectReason("当前状态不允许离场：" + item.getCurrentStatus());
        } else if ("PENDING".equals(checkOutResult)) {
            vo.setRejectReason(buildWarnReason(item));
        }
        return vo;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public YmsCheckOutRespVO checkOut(YmsCheckOutReqVO bo) {
        YmsCheckOutRespVO preview = lookupCheckOut(bo.getWarehouseId(), bo.getKeyword());
        if (preview.getResourceId() == null) return preview;
        if ("REJECTED".equals(preview.getCheckOutResult())) return preview;
        if ("PENDING".equals(preview.getCheckOutResult()) && !Boolean.TRUE.equals(bo.getConfirmed())) {
            return preview;
        }

        String exitPlate = resolveCheckOutPlate(bo, preview);
        Date now = new Date();
        int stayMinutes = calcStayMinutes(preview.getGateInTime(), now);

        if ("CONTAINER".equals(preview.getObjectType())) {
            YmsContainerResourceDO container = containerResourceMapper.selectById(preview.getResourceId());
            if (container != null) releasePosition(container.getYardPositionId());
            syncContainerLeaveDriver(preview.getResourceId(), exitPlate, bo);
            containerResourceService.markLeftYard(preview.getResourceId());
        } else {
            YmsTrailerResourceDO trailer = trailerResourceMapper.selectById(preview.getResourceId());
            if (trailer != null) releasePosition(trailer.getYardPositionId());
            syncTrailerLeaveDriver(preview.getResourceId(), exitPlate, bo);
            trailerResourceService.markLeftYard(preview.getResourceId());
        }

        YmsCheckInDO openCheckIn = findOpenCheckIn(preview);
        if (openCheckIn != null) {
            checkInMapper.update(null, Wrappers.<YmsCheckInDO>lambdaUpdate()
                .eq(YmsCheckInDO::getId, openCheckIn.getId())
                .set(YmsCheckInDO::getCheckOutTime, now)
                .set(YmsCheckInDO::getStayMinutes, stayMinutes)
                .set(YmsCheckInDO::getCheckOutPlateNo, exitPlate)
                .set(YmsCheckInDO::getCheckOutDriverName, bo.getDriverName())
                .set(YmsCheckInDO::getCheckOutDriverPhone, bo.getDriverPhone())
                .set(YmsCheckInDO::getCheckOutIdCardNo, bo.getIdCardNo())
                .set(YmsCheckInDO::getCheckOutPhotoUrls, bo.getPhotoUrls())
                .set(StrUtil.isNotBlank(bo.getRemark()), YmsCheckInDO::getRemark, bo.getRemark()));
            preview.setCheckInId(openCheckIn.getId());
            if (openCheckIn.getYardTaskId() != null) {
                dispatchService.leaveYard(openCheckIn.getYardTaskId());
                preview.setYardTaskId(openCheckIn.getYardTaskId());
                preview.setYardTaskNo(openCheckIn.getYardTaskNo());
            }
        } else if (preview.getYardTaskId() != null) {
            dispatchService.leaveYard(preview.getYardTaskId());
        }

        preview.setCheckOutResult("PASSED");
        preview.setRejectReason(null);
        preview.setGateOutTime(now);
        preview.setStayMinutes(stayMinutes);
        preview.setCurrentStatus("LEFT_YARD");
        preview.setCheckOutPlateNo(exitPlate);
        preview.setCheckOutDriverName(bo.getDriverName());
        preview.setCheckOutDriverPhone(bo.getDriverPhone());
        if (StrUtil.isNotBlank(exitPlate)) preview.setPlateNo(exitPlate);
        return preview;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public YmsCheckInRespVO manualPass(Long checkInId, String remark) {
        YmsCheckInDO existing = checkInMapper.selectById(checkInId);
        if (existing == null) {
            throw new ServiceException(500, "Check-in 记录不存在");
        }
        Date arrivalTime = existing.getCheckInTime() != null ? existing.getCheckInTime() : new Date();
        YmsYardTaskDO relatedTask = existing.getYardTaskId() != null
            ? yardTaskMapper.selectById(existing.getYardTaskId())
            : findRelatedTask(existing.getWarehouseId(), existing.getContainerNo(), existing.getTrailerNo(), null, existing.getPlateNo());
        String receiptNo = existing != null && StrUtil.isNotBlank(existing.getReceiptNo())
            ? existing.getReceiptNo() : generateReceiptNo();
        checkInMapper.update(null, Wrappers.<YmsCheckInDO>lambdaUpdate()
            .eq(YmsCheckInDO::getId, checkInId)
            .set(YmsCheckInDO::getCheckResult, "PASSED")
            .set(YmsCheckInDO::getRejectReason, remark)
            .set(YmsCheckInDO::getCheckInTime, arrivalTime)
            .set(relatedTask != null, YmsCheckInDO::getYardTaskId, relatedTask == null ? null : relatedTask.getId())
            .set(relatedTask != null, YmsCheckInDO::getYardTaskNo, relatedTask == null ? null : relatedTask.getYardTaskNo())
            .set(YmsCheckInDO::getReceiptNo, receiptNo));
        if (relatedTask != null) {
            advanceTaskArrived(relatedTask, arrivalTime, existing.getContainerResourceId(), existing.getTrailerResourceId());
            notifyArrival(relatedTask, arrivalTime, existing.getPositionCode());
        }
        return BeanUtils.toBean(checkInMapper.selectById(checkInId), YmsCheckInRespVO.class);
    }

    @Override
    public YmsCheckInReceiptRespVO queryReceipt(Long checkInId) {
        YmsCheckInRespVO vo = BeanUtils.toBean(checkInMapper.selectById(checkInId), YmsCheckInRespVO.class);
        if (vo == null) throw new ServiceException(500, "Check-in 记录不存在");
        YmsCheckInReceiptRespVO receipt = new YmsCheckInReceiptRespVO();
        receipt.setReceiptNo(vo.getReceiptNo());
        receipt.setCheckInType(vo.getCheckInType());
        receipt.setPlateNo(vo.getPlateNo());
        receipt.setDriverName(vo.getDriverName());
        receipt.setContainerNo(vo.getContainerNo());
        receipt.setTrailerNo(vo.getTrailerNo());
        receipt.setAptNo(vo.getAptNo());
        receipt.setCheckResult(vo.getCheckResult());
        receipt.setCheckInTime(vo.getCheckInTime());
        receipt.setOperatorName(vo.getOperatorName());
        return receipt;
    }

    // ─── 私有方法 ───────────────────────────────────────────────────────────────

    private boolean isAlreadyInYard(Long warehouseId, String plateNo) {
        Long cnt = checkInMapper.selectCount(Wrappers.<YmsCheckInDO>lambdaQuery()
            .eq(YmsCheckInDO::getWarehouseId, warehouseId)
            .eq(YmsCheckInDO::getPlateNo, plateNo)
            .in(YmsCheckInDO::getCheckResult, "PASSED")
            .isNull(YmsCheckInDO::getCheckOutTime));
        return cnt != null && cnt > 0;
    }

    private YmsYardTaskDO findRelatedTask(Long warehouseId, String containerNo, String trailerNo,
                                        String loadingNo, String plateNo) {
        if (StrUtil.isNotBlank(containerNo)) {
            return yardTaskMapper.selectOne(Wrappers.<YmsYardTaskDO>lambdaQuery()
                .eq(YmsYardTaskDO::getWarehouseId, warehouseId)
                .eq(YmsYardTaskDO::getContainerNo, containerNo)
                .in(YmsYardTaskDO::getYardStatus, "CREATED", "PRE_ARRIVAL", "WAIT_CONTAINER")
                .last("LIMIT 1"));
        }
        if (StrUtil.isNotBlank(trailerNo)) {
            return yardTaskMapper.selectOne(Wrappers.<YmsYardTaskDO>lambdaQuery()
                .eq(YmsYardTaskDO::getWarehouseId, warehouseId)
                .eq(YmsYardTaskDO::getTruckNo, trailerNo)
                .in(YmsYardTaskDO::getYardStatus, "CREATED", "PRE_ARRIVAL", "WAIT_VEHICLE")
                .last("LIMIT 1"));
        }
        if (StrUtil.isNotBlank(loadingNo)) {
            return yardTaskMapper.selectOne(Wrappers.<YmsYardTaskDO>lambdaQuery()
                .eq(YmsYardTaskDO::getWarehouseId, warehouseId)
                .ne(YmsYardTaskDO::getTaskType, "DEVANNING")
                .and(w -> w.eq(YmsYardTaskDO::getSourceOrderNo, loadingNo)
                    .or()
                    .eq(YmsYardTaskDO::getYardTaskNo, loadingNo))
                .in(YmsYardTaskDO::getYardStatus, "CREATED", "PRE_ARRIVAL", "WAIT_VEHICLE")
                .last("LIMIT 1"));
        }
        if (StrUtil.isNotBlank(plateNo)) {
            return yardTaskMapper.selectOne(Wrappers.<YmsYardTaskDO>lambdaQuery()
                .eq(YmsYardTaskDO::getWarehouseId, warehouseId)
                .eq(YmsYardTaskDO::getTruckNo, plateNo)
                .in(YmsYardTaskDO::getYardStatus, "CREATED", "PRE_ARRIVAL", "WAIT_VEHICLE")
                .last("LIMIT 1"));
        }
        return null;
    }

    private YmsYardTaskDO findSelfCheckInTask(Long warehouseId, String objectNo) {
        if (StrUtil.isBlank(objectNo)) {
            return null;
        }
        return yardTaskMapper.selectOne(Wrappers.<YmsYardTaskDO>lambdaQuery()
            .eq(YmsYardTaskDO::getWarehouseId, warehouseId)
            .and(w -> w.eq(YmsYardTaskDO::getContainerNo, objectNo)
                .or()
                .eq(YmsYardTaskDO::getTruckNo, objectNo)
                .or()
                .eq(YmsYardTaskDO::getSourceOrderNo, objectNo))
            .in(YmsYardTaskDO::getYardStatus, "CREATED", "PRE_ARRIVAL", "WAIT_CONTAINER", "WAIT_VEHICLE")
            .orderByDesc(YmsYardTaskDO::getEtaYardTime)
            .last("LIMIT 1"));
    }

    private void advanceTaskArrived(YmsYardTaskDO task, Date arrivalTime,
                                    Long containerResourceId, Long trailerResourceId) {
        yardTaskMapper.update(null, Wrappers.<YmsYardTaskDO>lambdaUpdate()
            .eq(YmsYardTaskDO::getId, task.getId())
            .set(YmsYardTaskDO::getYardStatus, "ARRIVED")
            .set(YmsYardTaskDO::getGateInTime, arrivalTime)
            .set(containerResourceId != null, YmsYardTaskDO::getContainerResourceId, containerResourceId)
            .set(trailerResourceId != null, YmsYardTaskDO::getTrailerResourceId, trailerResourceId));
    }

    private void advanceTaskByCheckInLocation(YmsYardTaskDO task, Date arrivalTime, YardDockDO location,
                                              Long containerResourceId, Long trailerResourceId) {
        if (location != null && YmsYardLocationTypes.DOCK.equals(location.getLocationType())) {
            yardTaskMapper.update(null, Wrappers.<YmsYardTaskDO>lambdaUpdate()
                .eq(YmsYardTaskDO::getId, task.getId())
                .set(YmsYardTaskDO::getYardStatus, "DOCK_ASSIGNED")
                .set(YmsYardTaskDO::getGateInTime, arrivalTime)
                .set(YmsYardTaskDO::getDockId, location.getId())
                .set(YmsYardTaskDO::getDockCode, location.getDockCode())
                .set(YmsYardTaskDO::getDockAssignTime, arrivalTime)
                .set(containerResourceId != null, YmsYardTaskDO::getContainerResourceId, containerResourceId)
                .set(trailerResourceId != null, YmsYardTaskDO::getTrailerResourceId, trailerResourceId));
            return;
        }
        advanceTaskArrived(task, arrivalTime, containerResourceId, trailerResourceId);
    }

    private void notifyArrival(YmsYardTaskDO task, Date arrivalTime, String positionCode) {
        if (task.getSourceOrderType() == null || task.getSourceOrderId() == null) return;
        if (sourceOrderSyncHandlers == null || sourceOrderSyncHandlers.isEmpty()) {
            return;
        }
        for (YmsSourceOrderSyncHandler handler : sourceOrderSyncHandlers) {
            try {
                handler.onYardTaskArrival(task.getSourceOrderType(), task.getSourceOrderId(),
                    task.getTaskType(), arrivalTime, positionCode);
            } catch (Exception ex) {
                log.warn("YMS 到仓同步来源单据失败: sourceType={}, sourceId={}, taskType={}, taskNo={}",
                    task.getSourceOrderType(), task.getSourceOrderId(), task.getTaskType(), task.getYardTaskNo(), ex);
                // 同步失败不影响主流程
            }
        }
    }

    private YardDockDO findSlotByCode(Long warehouseId, String positionCode) {
        return yardDockMapper.selectOne(Wrappers.<YardDockDO>lambdaQuery()
            .eq(YardDockDO::getWarehouseId, warehouseId)
            .eq(YardDockDO::getDockCode, positionCode)
            .last("LIMIT 1"));
    }

    private Long upsertContainerResource(Long warehouseId, String containerNo, String plateNo,
                                         String driverName, String driverPhone,
                                         YardDockDO slot) {
        YmsContainerResourceDO existing = containerResourceMapper.selectOne(
            Wrappers.<YmsContainerResourceDO>lambdaQuery()
                .eq(YmsContainerResourceDO::getWarehouseId, warehouseId)
                .eq(YmsContainerResourceDO::getContainerNo, containerNo)
                .ne(YmsContainerResourceDO::getContainerStatus, "LEFT_YARD")
                .ne(YmsContainerResourceDO::getContainerStatus, "RETURNED")
                .last("LIMIT 1"));
        if (existing == null) {
            Long id = IdUtil.getSnowflakeNextId();
            YmsContainerResourceDO add = new YmsContainerResourceDO();
            add.setId(id);
            add.setWarehouseId(warehouseId);
            add.setContainerNo(containerNo);
            add.setContainerStatus("ARRIVED");
            add.setArrivedTime(new Date());
            add.setEmptyStatus("FULL");
            add.setPlateNo(plateNo);
            add.setDriverName(driverName);
            add.setDriverPhone(driverPhone);
            applySlotToContainer(add, slot);
            containerResourceMapper.insert(add);
            if (slot != null) {
                locationSupport.occupySlot(slot.getId(), "CONTAINER", id, containerNo);
            }
            return id;
        }
        containerResourceService.markArrived(existing.getId(), plateNo, driverName, driverPhone);
        if (slot != null) {
            YmsContainerResourceDO update = new YmsContainerResourceDO();
            update.setId(existing.getId());
            applySlotToContainer(update, slot);
            containerResourceMapper.updateById(update);
            locationSupport.occupySlot(slot.getId(), "CONTAINER", existing.getId(), containerNo);
        }
        return existing.getId();
    }

    private Long upsertTrailerResource(Long warehouseId, String plateNo, String trailerNo,
                                       String vehicleSource, String driverName, String driverPhone,
                                       String driverIdNo, YardDockDO slot) {
        YmsTrailerResourceDO existing = trailerResourceMapper.selectOne(
            Wrappers.<YmsTrailerResourceDO>lambdaQuery()
                .eq(YmsTrailerResourceDO::getWarehouseId, warehouseId)
                .eq(StrUtil.isNotBlank(trailerNo), YmsTrailerResourceDO::getTrailerNo, trailerNo)
                .eq(StrUtil.isBlank(trailerNo), YmsTrailerResourceDO::getPlateNo, plateNo)
                .ne(YmsTrailerResourceDO::getTrailerStatus, "LEFT_YARD")
                .last("LIMIT 1"));
        if (existing == null) {
            Long id = IdUtil.getSnowflakeNextId();
            YmsTrailerResourceDO add = new YmsTrailerResourceDO();
            add.setId(id);
            add.setWarehouseId(warehouseId);
            add.setPlateNo(plateNo);
            add.setTrailerNo(trailerNo);
            add.setVehicleSource(StrUtil.blankToDefault(vehicleSource, "SUPPLIER_TRUCK"));
            add.setDriverName(driverName);
            add.setDriverPhone(driverPhone);
            add.setDriverIdNo(driverIdNo);
            add.setTrailerStatus("ARRIVED_EMPTY");
            add.setArriveTime(new Date());
            applySlotToTrailer(add, slot);
            trailerResourceMapper.insert(add);
            if (slot != null) {
                locationSupport.occupySlot(slot.getId(), "TRAILER", id, StrUtil.blankToDefault(trailerNo, plateNo));
            }
            return id;
        }
        trailerResourceService.markArrived(existing.getId());
        YmsTrailerResourceDO update = new YmsTrailerResourceDO();
        update.setId(existing.getId());
        update.setPlateNo(plateNo);
        if (StrUtil.isNotBlank(trailerNo)) update.setTrailerNo(trailerNo);
        if (StrUtil.isNotBlank(vehicleSource)) update.setVehicleSource(vehicleSource);
        if (StrUtil.isNotBlank(driverName)) update.setDriverName(driverName);
        if (StrUtil.isNotBlank(driverPhone)) update.setDriverPhone(driverPhone);
        if (slot != null) {
            applySlotToTrailer(update, slot);
            locationSupport.occupySlot(slot.getId(), "TRAILER", existing.getId(),
                StrUtil.blankToDefault(trailerNo, plateNo));
        }
        trailerResourceMapper.updateById(update);
        return existing.getId();
    }

    /** 根据位置类型写入道口或堆场位字段 */
    private void applySlotToContainer(YmsContainerResourceDO resource, YardDockDO slot) {
        if (slot == null) return;
        if (YmsYardLocationTypes.DOCK.equals(slot.getLocationType())) {
            resource.setDockId(slot.getId());
            resource.setDockCode(slot.getDockCode());
        } else {
            resource.setYardPositionId(slot.getId());
            if (slot.getZoneId() != null) resource.setYardZoneId(slot.getZoneId());
        }
    }

    private void applySlotToTrailer(YmsTrailerResourceDO resource, YardDockDO slot) {
        if (slot == null) return;
        if (YmsYardLocationTypes.DOCK.equals(slot.getLocationType())) {
            resource.setDockId(slot.getId());
            resource.setDockCode(slot.getDockCode());
        } else {
            resource.setYardPositionId(slot.getId());
            if (slot.getZoneId() != null) resource.setYardZoneId(slot.getZoneId());
        }
    }

    private YmsContainerResourceDO createTaskBackedContainerResource(YmsYardTaskDO task, String objectNo,
                                                                  String driverPhone, String driverName) {
        YmsContainerResourceDO add = new YmsContainerResourceDO();
        add.setId(IdUtil.getSnowflakeNextId());
        add.setWarehouseId(task.getWarehouseId());
        add.setContainerNo(StrUtil.blankToDefault(task.getContainerNo(), objectNo));
        add.setContainerStatus("ARRIVED");
        add.setArrivedTime(new Date());
        add.setEmptyStatus("FULL");
        add.setPlateNo(task.getTruckNo());
        add.setDriverPhone(StrUtil.blankToDefault(driverPhone, task.getDriverPhone()));
        add.setDriverName(StrUtil.blankToDefault(driverName, task.getDriverName()));
        containerResourceMapper.insert(add);
        return add;
    }

    private YmsTrailerResourceDO createTaskBackedTrailerResource(YmsYardTaskDO task, String objectNo,
                                                              String driverPhone, String driverName) {
        YmsTrailerResourceDO add = new YmsTrailerResourceDO();
        add.setId(IdUtil.getSnowflakeNextId());
        add.setWarehouseId(task.getWarehouseId());
        add.setTrailerNo(StrUtil.blankToDefault(task.getTruckNo(), objectNo));
        add.setPlateNo(task.getTruckNo());
        add.setTrailerStatus("ARRIVED_EMPTY");
        add.setArriveTime(new Date());
        add.setVehicleSource("SUPPLIER_TRUCK");
        add.setDriverPhone(StrUtil.blankToDefault(driverPhone, task.getDriverPhone()));
        add.setDriverName(StrUtil.blankToDefault(driverName, task.getDriverName()));
        trailerResourceMapper.insert(add);
        return add;
    }

    private YmsCheckInRespVO buildBlockedRecord(Long warehouseId, String checkInType, String plateNo,
                                            String containerNo, String trailerNo,
                                            String driverName, String driverPhone, String vehicleSource,
                                            String checkResult, String rejectReason,
                                            String checkinSource, String photoUrls, String remark) {
        YmsCheckInDO record = new YmsCheckInDO();
        record.setId(IdUtil.getSnowflakeNextId());
        record.setWarehouseId(warehouseId);
        record.setCheckInType(checkInType);
        record.setPlateNo(StrUtil.blankToDefault(plateNo, ""));
        record.setContainerNo(containerNo);
        record.setTrailerNo(trailerNo);
        record.setDriverName(driverName);
        record.setDriverPhone(driverPhone);
        record.setVehicleSource(vehicleSource);
        record.setCheckResult(checkResult);
        record.setRejectReason(rejectReason);
        record.setMatchType("WALK_IN");
        record.setCheckinSource(checkinSource);
        record.setOmsMismatchFlag(0);
        record.setCheckInTime(new Date());
        record.setPhotoUrls(photoUrls);
        record.setRemark(remark);
        checkInMapper.insert(record);
        return BeanUtils.toBean(checkInMapper.selectById(record.getId()), YmsCheckInRespVO.class);
    }

    private void enrichGateInDriver(YmsCheckOutRespVO vo) {
        YmsCheckInDO open = findOpenCheckIn(vo);
        if (open == null) return;
        vo.setCheckInId(open.getId());
        vo.setGateInPlateNo(open.getPlateNo());
        vo.setGateInDriverName(open.getDriverName());
        vo.setGateInDriverPhone(open.getDriverPhone());
        vo.setGateInIdCardNo(open.getIdCardNo());
    }

    private YmsCheckOutRespVO toCheckOutVo(YmsInYardRespVO item) {
        YmsCheckOutRespVO vo = new YmsCheckOutRespVO();
        vo.setObjectType(item.getObjectType());
        vo.setResourceId(item.getResourceId());
        vo.setWarehouseId(item.getWarehouseId());
        vo.setPlateNo(item.getPlateNo());
        vo.setTrailerNo(item.getTrailerNo());
        vo.setContainerNo(item.getContainerNo());
        vo.setVehicleSource(item.getVehicleSource());
        vo.setCurrentStatus(item.getCurrentStatus());
        vo.setCurrentArea(item.getCurrentArea());
        vo.setAreaLabel(item.getAreaLabel());
        vo.setGateInTime(item.getGateInTime());
        vo.setStayMinutes(item.getStayMinutes());
        vo.setYardTaskId(item.getRelatedTaskId());
        return vo;
    }

    private String evaluateCheckOut(String objectType, String status) {
        if ("CONTAINER".equals(objectType)) {
            if (CONTAINER_PASS_STATUS.contains(status)) return "PASSED";
            return "PENDING";
        }
        if ("TRAILER".equals(objectType)) {
            if (TRAILER_PASS_STATUS.contains(status)) return "PASSED";
            return "PENDING";
        }
        return "REJECTED";
    }

    private String buildWarnReason(YmsInYardRespVO item) {
        return "CONTAINER".equals(item.getObjectType())
            ? "海柜尚未完成拆柜或空柜待还，确认仍要放行离场？"
            : "车厢/车辆尚未完成装车，确认仍要放行离场？";
    }

    private void enrichOpenInternalTask(YmsCheckOutRespVO vo) {
        YmsInternalTaskDO task = null;
        if (vo.getYardTaskId() != null) {
            task = internalTaskMapper.selectOne(Wrappers.<YmsInternalTaskDO>lambdaQuery()
                .eq(YmsInternalTaskDO::getParentYardTaskId, vo.getYardTaskId())
                .notIn(YmsInternalTaskDO::getTaskStatus, "COMPLETED", "FAILED", "CANCELLED")
                .orderByDesc(YmsInternalTaskDO::getCreateTime)
                .last("LIMIT 1"));
        }
        if (task == null && vo.getResourceId() != null && StrUtil.isNotBlank(vo.getObjectType())) {
            task = internalTaskMapper.selectOne(Wrappers.<YmsInternalTaskDO>lambdaQuery()
                .eq(YmsInternalTaskDO::getObjectType, vo.getObjectType())
                .eq(YmsInternalTaskDO::getObjectId, vo.getResourceId())
                .notIn(YmsInternalTaskDO::getTaskStatus, "COMPLETED", "FAILED", "CANCELLED")
                .orderByDesc(YmsInternalTaskDO::getCreateTime)
                .last("LIMIT 1"));
        }
        if (task == null) return;
        vo.setOpenInternalTaskId(task.getId());
        vo.setOpenInternalTaskNo(task.getTaskNo());
        vo.setOpenInternalTaskType(task.getInternalTaskType());
        vo.setOpenInternalTaskStatus(task.getTaskStatus());
        vo.setOpenInternalTaskTargetCode(StrUtil.blankToDefault(task.getToDockCode(), task.getToPositionCode()));
    }

    private YmsCheckInDO findOpenCheckIn(YmsCheckOutRespVO preview) {
        return checkInMapper.selectOne(Wrappers.<YmsCheckInDO>lambdaQuery()
            .eq(YmsCheckInDO::getWarehouseId, preview.getWarehouseId())
            .eq(YmsCheckInDO::getCheckResult, "PASSED")
            .isNull(YmsCheckInDO::getCheckOutTime)
            .and(w -> {
                if ("CONTAINER".equals(preview.getObjectType())) {
                    w.eq(YmsCheckInDO::getContainerResourceId, preview.getResourceId());
                } else {
                    w.eq(YmsCheckInDO::getTrailerResourceId, preview.getResourceId());
                }
            })
            .orderByDesc(YmsCheckInDO::getCheckInTime)
            .last("LIMIT 1"));
    }

    private void releasePosition(Long positionId) {
        if (positionId == null) return;
        locationSupport.releaseSlot(positionId);
    }

    private String resolveCheckOutPlate(YmsCheckOutReqVO bo, YmsCheckOutRespVO preview) {
        if (StrUtil.isNotBlank(bo.getPlateNo())) return StrUtil.trim(bo.getPlateNo());
        if (StrUtil.isNotBlank(preview.getGateInPlateNo())) return preview.getGateInPlateNo();
        return preview.getPlateNo();
    }

    private void syncContainerLeaveDriver(Long resourceId, String exitPlate, YmsCheckOutReqVO bo) {
        if (resourceId == null) return;
        YmsContainerResourceDO update = new YmsContainerResourceDO();
        update.setId(resourceId);
        if (StrUtil.isNotBlank(exitPlate)) update.setPlateNo(exitPlate);
        if (StrUtil.isNotBlank(bo.getDriverName())) update.setDriverName(bo.getDriverName());
        if (StrUtil.isNotBlank(bo.getDriverPhone())) update.setDriverPhone(bo.getDriverPhone());
        containerResourceMapper.updateById(update);
    }

    private void syncTrailerLeaveDriver(Long resourceId, String exitPlate, YmsCheckOutReqVO bo) {
        if (resourceId == null) return;
        YmsTrailerResourceDO update = new YmsTrailerResourceDO();
        update.setId(resourceId);
        if (StrUtil.isNotBlank(exitPlate)) update.setPlateNo(exitPlate);
        if (StrUtil.isNotBlank(bo.getDriverName())) update.setDriverName(bo.getDriverName());
        if (StrUtil.isNotBlank(bo.getDriverPhone())) update.setDriverPhone(bo.getDriverPhone());
        trailerResourceMapper.updateById(update);
    }

    private YmsCheckOutRespVO buildCheckOutBlock(YmsInYardRespVO item, String reason) {
        YmsCheckOutRespVO vo = item != null ? toCheckOutVo(item) : new YmsCheckOutRespVO();
        vo.setCheckOutResult("REJECTED");
        vo.setRejectReason(reason);
        return vo;
    }

    private int calcStayMinutes(Date gateInTime, Date gateOutTime) {
        if (gateInTime == null || gateOutTime == null) return 0;
        return (int) Math.max((gateOutTime.getTime() - gateInTime.getTime()) / 60000, 0);
    }

    private String generateReceiptNo() {
        return "RC" + LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"))
            + String.format("%06d", System.currentTimeMillis() % 1_000_000);
    }

    @Override
    public List<YmsParkingSlotRespVO> listAvailableParkingSlots(Long warehouseId) {
        return yardDockMapper.selectList(Wrappers.<YardDockDO>lambdaQuery()
                .eq(YardDockDO::getWarehouseId, warehouseId)
                .eq(YardDockDO::getDockStatus, "IDLE")
                .eq(YardDockDO::getEnabledFlag, 1)
                .orderByAsc(YardDockDO::getDockLocation, YardDockDO::getDockCode))
            .stream()
            .map(slot -> {
                YmsParkingSlotRespVO vo = new YmsParkingSlotRespVO();
                vo.setId(slot.getId());
                vo.setDockCode(slot.getDockCode());
                vo.setDockName(StrUtil.blankToDefault(slot.getDockName(), slot.getDockCode()));
                vo.setZoneCode(slot.getZoneCode());
                vo.setDockStatus(slot.getDockStatus());
                return vo;
            })
            .toList();
    }

    // ─── 装车司机 H5 预登记 ───────────────────────────────────────────────────

    @Override
    public YmsTrailerCheckinLookupRespVO lookupTrailerCheckin(String pickupNo) {
        if (StrUtil.isBlank(pickupNo)) {
            throw new ServiceException(500, "提货号不能为空");
        }
        YmsYardTaskDO task = yardTaskMapper.selectOne(Wrappers.<YmsYardTaskDO>lambdaQuery()
            .eq(YmsYardTaskDO::getSourceOrderNo, StrUtil.trim(pickupNo))
            .ne(YmsYardTaskDO::getTaskType, "DEVANNING")
            .ne(YmsYardTaskDO::getYardStatus, "CANCELLED")
            .ne(YmsYardTaskDO::getYardStatus, "EXCEPTION_CLOSED")
            .orderByDesc(YmsYardTaskDO::getCreateTime)
            .last("LIMIT 1"));
        if (task == null) {
            throw new ServiceException(500, "未找到提货号 [" + pickupNo + "] 对应的任务，请确认提货号是否正确");
        }

        YmsTrailerCheckinLookupRespVO vo = new YmsTrailerCheckinLookupRespVO();
        vo.setPickupNo(pickupNo);
        vo.setTruckRouteNo(task.getYardTaskNo());
        vo.setDriverPhone(task.getDriverPhone());
        vo.setDriverLicenseNo(task.getDriverLicenseNo());
        vo.setTrailerNo(task.getTruckNo());
        vo.setScheduledTime(formatDate(task.getEtaYardTime()));
        vo.setStatus(resolveTrailerCheckinStatus(task.getYardStatus()));
        vo.setStatusLabel(resolveTrailerCheckinStatusLabel(task.getYardStatus()));

        // 派送明细由 OMS 集成层填充
        List<YmsTrailerCheckinLookupRespVO.YmsTrailerCheckinDispatchItemRespVO> items = Collections.emptyList();
        if (task.getSourceOrderType() != null && task.getSourceOrderId() != null) {
            YmsTrailerDispatchQueryHandler handler = trailerDispatchQueryHandlerProvider.getIfAvailable();
            if (handler != null) {
                items = handler.queryDispatchItems(task.getSourceOrderType(), task.getSourceOrderId());
            }
        }
        vo.setDispatchItems(items);
        return vo;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public YmsTrailerCheckinResultRespVO trailerCheckin(YmsTrailerCheckinReqVO bo) {
        YmsTrailerCheckinResultRespVO result = new YmsTrailerCheckinResultRespVO();

        YmsYardTaskDO task = yardTaskMapper.selectOne(Wrappers.<YmsYardTaskDO>lambdaQuery()
            .eq(YmsYardTaskDO::getSourceOrderNo, StrUtil.trim(bo.getPickupNo()))
            .ne(YmsYardTaskDO::getTaskType, "DEVANNING")
            .ne(YmsYardTaskDO::getYardStatus, "CANCELLED")
            .ne(YmsYardTaskDO::getYardStatus, "EXCEPTION_CLOSED")
            .orderByDesc(YmsYardTaskDO::getCreateTime)
            .last("LIMIT 1"));
        if (task == null) {
            result.setSuccess(false);
            result.setMessage("未找到提货号 [" + bo.getPickupNo() + "] 对应的任务，请确认提货号是否正确");
            return result;
        }

        // 已到场以后不允许再重复预登记
        Set<String> arrivedStatuses = Set.of("ARRIVED", "DOCK_ASSIGNED", "DOCK_WORKING",
            "LOADING", "OPERATION_FINISHED", "RELEASED", "LEFT_YARD");
        if (arrivedStatuses.contains(task.getYardStatus())) {
            result.setSuccess(false);
            result.setMessage("该提货号已完成签到，无需重复登记");
            return result;
        }

        // 更新任务：司机信息 + 推进至 PRE_ARRIVAL
        YmsYardTaskDO update = new YmsYardTaskDO();
        update.setId(task.getId());
        update.setDriverPhone(StrUtil.trim(bo.getDriverPhone()));
        update.setDriverLicenseNo(StrUtil.trim(bo.getDriverLicenseNo()));
        update.setTruckNo(StrUtil.trim(bo.getTrailerNo()));
        if ("CREATED".equals(task.getYardStatus())) {
            update.setYardStatus("PRE_ARRIVAL");
        }
        yardTaskMapper.updateById(update);

        result.setSuccess(true);
        result.setMessage("登记成功，请按时到场");
        result.setCheckInNo(task.getYardTaskNo());
        return result;
    }

    // ─── 装车预登记私有辅助 ────────────────────────────────────────────────────

    private String resolveTrailerCheckinStatus(String yardStatus) {
        if (yardStatus == null) return "pending";
        return switch (yardStatus) {
            case "CREATED", "PRE_ARRIVAL" -> "pending";
            case "ARRIVED", "DOCK_ASSIGNED", "DOCK_WORKING", "LOADING" -> "checked_in";
            case "OPERATION_FINISHED", "RELEASED", "LEFT_YARD" -> "completed";
            default -> "cancelled";
        };
    }

    private String resolveTrailerCheckinStatusLabel(String yardStatus) {
        if (yardStatus == null) return "待登记";
        return switch (yardStatus) {
            case "CREATED" -> "待登记";
            case "PRE_ARRIVAL" -> "已预登记";
            case "ARRIVED" -> "已签到";
            case "DOCK_ASSIGNED" -> "已分配月台";
            case "DOCK_WORKING", "LOADING" -> "装车中";
            case "OPERATION_FINISHED" -> "装车完成";
            case "RELEASED" -> "已放行";
            case "LEFT_YARD" -> "已离场";
            default -> "已取消";
        };
    }

    private String formatDate(Date date) {
        if (date == null) return null;
        return new SimpleDateFormat("yyyy-MM-dd HH:mm").format(date);
    }
}
