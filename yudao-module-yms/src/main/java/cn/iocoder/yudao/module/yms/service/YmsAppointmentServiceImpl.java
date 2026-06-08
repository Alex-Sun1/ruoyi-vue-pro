package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.module.yms.util.YmsPageUtils;

import cn.hutool.core.util.IdUtil;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.exception.ServiceException;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsAppointmentDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentAddReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentEditReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentBoardSlotRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentRuleSlotRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentRuleRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentRespVO;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsAppointmentMapper;
import cn.iocoder.yudao.module.yms.service.YmsAppointmentRuleService;
import cn.iocoder.yudao.module.yms.service.YmsAppointmentService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.hutool.core.util.StrUtil;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;


@Service
public class YmsAppointmentServiceImpl implements YmsAppointmentService {

    @Resource
    private YmsAppointmentMapper baseMapper;
    @Resource
    private YmsAppointmentRuleService appointmentRuleService;

    @Override
    public PageResult<YmsAppointmentRespVO> queryPageList(YmsAppointmentQueryReqVO bo, PageParam pageParam) {
        return YmsPageUtils.toPageResult(baseMapper.selectPageList(YmsPageUtils.toPage(pageParam), bo));
    }

    @Override
    public YmsAppointmentRespVO queryById(Long id) {
        return BeanUtils.toBean(baseMapper.selectById(id), YmsAppointmentRespVO.class);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public YmsAppointmentRespVO createAppointment(YmsAppointmentAddReqVO bo) {
        String businessType = StrUtil.isNotBlank(bo.getBusinessType()) ? bo.getBusinessType() : bo.getTaskType();
        YmsAppointmentRuleRespVO rule = appointmentRuleService.matchRule(
            bo.getWarehouseId(), businessType, bo.getVehicleSource());
        if (rule == null) {
            throw new ServiceException(500, "未找到适用的预约规则，请联系管理员配置");
        }
        validateAdvanceDays(rule, bo.getAptDate());

        YmsAppointmentRuleSlotRespVO matchedSlot = appointmentRuleService.findMatchingSlot(
            rule, bo.getAptDate(), bo.getAptSlot());
        if (matchedSlot == null) {
            throw new ServiceException(500, "所选预约时段不在规则允许范围内");
        }

        int used = baseMapper.countBySlot(bo.getWarehouseId(), bo.getAptDate(), bo.getAptSlot());
        if (used >= matchedSlot.getCapacity()) {
            throw new ServiceException(500, "该时段预约已满，请选择其他时段");
        }

        YmsAppointmentDO apt = BeanUtils.toBean(bo, YmsAppointmentDO.class);
        apt.setId(IdUtil.getSnowflakeNextId());
        apt.setAptNo(generateAptNo());
        apt.setBusinessType(businessType);
        apt.setStatus(rule.getAutoConfirm() != null && rule.getAutoConfirm() == 1 ? "CONFIRMED" : "PENDING");
        baseMapper.insert(apt);
        return BeanUtils.toBean(baseMapper.selectById(apt.getId()), YmsAppointmentRespVO.class);
    }

    private void validateAdvanceDays(YmsAppointmentRuleRespVO rule, String aptDate) {
        LocalDate target = LocalDate.parse(aptDate, DateTimeFormatter.ISO_LOCAL_DATE);
        long daysAhead = ChronoUnit.DAYS.between(LocalDate.now(), target);
        int min = rule.getAdvanceDaysMin() != null ? rule.getAdvanceDaysMin() : 1;
        int max = rule.getAdvanceDaysMax() != null ? rule.getAdvanceDaysMax() : 7;
        if (daysAhead < min) {
            throw new ServiceException(500, "预约日期需至少提前" + min + "天");
        }
        if (daysAhead > max) {
            throw new ServiceException(500, "预约日期最多提前" + max + "天");
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean updateByBo(YmsAppointmentEditReqVO bo) {
        YmsAppointmentDO existing = baseMapper.selectById(bo.getId());
        if (existing == null) throw new ServiceException(500, "预约记录不存在");
        if (!"PENDING".equals(existing.getStatus())) throw new ServiceException(500, "只有待确认状态可编辑");
        YmsAppointmentDO update = BeanUtils.toBean(bo, YmsAppointmentDO.class);
        return baseMapper.updateById(update) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean cancelAppointment(Long id, String reason) {
        YmsAppointmentDO apt = baseMapper.selectById(id);
        if (apt == null) throw new ServiceException(500, "预约记录不存在");
        if (List.of("CANCELLED", "COMPLETED").contains(apt.getStatus()))
            throw new ServiceException(500, "当前状态不允许取消");
        return baseMapper.update(null, Wrappers.<YmsAppointmentDO>lambdaUpdate()
            .eq(YmsAppointmentDO::getId, id)
            .set(YmsAppointmentDO::getStatus, "CANCELLED")
            .set(YmsAppointmentDO::getCancelReason, reason)) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean confirmAppointment(Long id) {
        return baseMapper.update(null, Wrappers.<YmsAppointmentDO>lambdaUpdate()
            .eq(YmsAppointmentDO::getId, id)
            .eq(YmsAppointmentDO::getStatus, "PENDING")
            .set(YmsAppointmentDO::getStatus, "CONFIRMED")) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean markNoShow(Long id) {
        return baseMapper.update(null, Wrappers.<YmsAppointmentDO>lambdaUpdate()
            .eq(YmsAppointmentDO::getId, id)
            .set(YmsAppointmentDO::getStatus, "NO_SHOW")) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean deleteByIds(List<Long> ids) {
        return baseMapper.deleteByIds(ids) > 0;
    }

    private String generateAptNo() {
        String date = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        return "APT" + date + String.format("%06d", System.currentTimeMillis() % 1000000);
    }

    @Override
    public List<YmsAppointmentBoardSlotRespVO> queryBoard(Long warehouseId, String aptDate,
                                                      String businessType, String vehicleSource) {
        if (warehouseId == null || StrUtil.isBlank(aptDate)) {
            throw new ServiceException(500, "仓库和日期不能为空");
        }
        YmsAppointmentRuleRespVO rule = appointmentRuleService.matchRule(warehouseId, businessType, vehicleSource);
        if (rule == null || rule.getSlots() == null || rule.getSlots().isEmpty()) {
            return List.of();
        }
        int weekday = LocalDate.parse(aptDate).getDayOfWeek().getValue();
        List<YmsAppointmentRespVO> dayApts = baseMapper.selectListByDate(warehouseId, aptDate);
        List<YmsAppointmentBoardSlotRespVO> board = new ArrayList<>();
        for (YmsAppointmentRuleSlotRespVO slot : rule.getSlots()) {
            if (slot.getWeekday() == null || !slot.getWeekday().equals(weekday)) continue;
            if (slot.getEnabled() != null && slot.getEnabled() == 0) continue;
            String slotLabel = slot.getStartTime() + "-" + slot.getEndTime();
            List<YmsAppointmentRespVO> matched = dayApts.stream()
                .filter(a -> slotLabel.equals(a.getAptSlot()) || StrUtil.startWith(a.getAptSlot(), slot.getStartTime()))
                .collect(Collectors.toList());
            int used = matched.size();
            int capacity = slot.getCapacity() != null ? slot.getCapacity() : 0;
            YmsAppointmentBoardSlotRespVO vo = new YmsAppointmentBoardSlotRespVO();
            vo.setSlotLabel(slotLabel);
            vo.setStartTime(slot.getStartTime());
            vo.setEndTime(slot.getEndTime());
            vo.setCapacity(capacity);
            vo.setUsed(used);
            vo.setRemaining(Math.max(capacity - used, 0));
            vo.setAppointments(matched);
            board.add(vo);
        }
        return board;
    }
}
