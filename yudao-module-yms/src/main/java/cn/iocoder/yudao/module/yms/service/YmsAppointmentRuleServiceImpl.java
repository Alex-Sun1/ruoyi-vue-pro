package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.module.yms.util.YmsPageUtils;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.IdUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.exception.ServiceException;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsAppointmentRuleDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsAppointmentRuleSlotDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentRuleAddReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentRuleEditReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentRuleQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentRuleSlotReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentRuleSlotRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentRuleRespVO;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsAppointmentRuleMapper;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsAppointmentRuleSlotMapper;
import cn.iocoder.yudao.module.yms.service.YmsAppointmentRuleService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;


@Service
public class YmsAppointmentRuleServiceImpl implements YmsAppointmentRuleService {

    @Resource
    private YmsAppointmentRuleMapper baseMapper;
    @Resource
    private YmsAppointmentRuleSlotMapper slotMapper;

    @Override
    public PageResult<YmsAppointmentRuleRespVO> queryPageList(YmsAppointmentRuleQueryReqVO bo, PageParam pageParam) {
        return YmsPageUtils.toPageResult(baseMapper.selectPageList(YmsPageUtils.toPage(pageParam), bo));
    }

    @Override
    public YmsAppointmentRuleRespVO queryById(Long id) {
        YmsAppointmentRuleRespVO vo = baseMapper.selectVoDetailById(id);
        if (vo == null) {
            throw new ServiceException(500, "预约规则不存在");
        }
        vo.setSlots(slotMapper.selectByRuleId(id));
        return vo;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean insertByBo(YmsAppointmentRuleAddReqVO bo) {
        validateAdvanceDays(bo.getAdvanceDaysMin(), bo.getAdvanceDaysMax());
        YmsAppointmentRuleDO add = BeanUtils.toBean(bo, YmsAppointmentRuleDO.class);
        add.setId(IdUtil.getSnowflakeNextId());
        applyDefaults(add);
        baseMapper.insert(add);
        saveSlots(add.getId(), String.valueOf(add.getTenantId()), bo.getSlots());
        return true;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean updateByBo(YmsAppointmentRuleEditReqVO bo) {
        validateAdvanceDays(bo.getAdvanceDaysMin(), bo.getAdvanceDaysMax());
        YmsAppointmentRuleDO existing = baseMapper.selectById(bo.getId());
        if (existing == null) {
            throw new ServiceException(500, "预约规则不存在");
        }
        YmsAppointmentRuleDO update = BeanUtils.toBean(bo, YmsAppointmentRuleDO.class);
        baseMapper.updateById(update);
        slotMapper.deleteByRuleId(bo.getId());
        saveSlots(bo.getId(), String.valueOf(existing.getTenantId()), bo.getSlots());
        return true;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean deleteByIds(List<Long> ids) {
        for (Long id : ids) {
            slotMapper.deleteByRuleId(id);
        }
        return baseMapper.deleteByIds(ids) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean toggleEnabled(Long id, Integer enabled) {
        return baseMapper.update(null, Wrappers.<YmsAppointmentRuleDO>lambdaUpdate()
            .eq(YmsAppointmentRuleDO::getId, id)
            .set(YmsAppointmentRuleDO::getEnabled, enabled)) > 0;
    }

    @Override
    public YmsAppointmentRuleRespVO matchRule(Long warehouseId, String businessType, String vehicleSource) {
        YmsAppointmentRuleRespVO rule = baseMapper.selectMatchRule(warehouseId, businessType, vehicleSource);
        if (rule != null) {
            rule.setSlots(slotMapper.selectByRuleId(rule.getId()));
        }
        return rule;
    }

    @Override
    public YmsAppointmentRuleSlotRespVO findMatchingSlot(YmsAppointmentRuleRespVO rule, String aptDate, String aptSlot) {
        if (rule == null || CollUtil.isEmpty(rule.getSlots())) {
            return null;
        }
        LocalDate date = LocalDate.parse(aptDate, DateTimeFormatter.ISO_LOCAL_DATE);
        int weekday = date.getDayOfWeek().getValue();
        String slotStart = parseSlotStart(aptSlot);
        if (slotStart == null) {
            return null;
        }
        return rule.getSlots().stream()
            .filter(s -> s.getEnabled() != null && s.getEnabled() == 1)
            .filter(s -> weekday == s.getWeekday())
            .filter(s -> slotStart.compareTo(s.getStartTime()) >= 0
                && slotStart.compareTo(s.getEndTime()) < 0)
            .findFirst()
            .orElse(null);
    }

    private void saveSlots(Long ruleId, String tenantId, List<YmsAppointmentRuleSlotReqVO> slots) {
        if (CollUtil.isEmpty(slots)) {
            return;
        }
        for (YmsAppointmentRuleSlotReqVO slotBo : slots) {
            YmsAppointmentRuleSlotDO slot = new YmsAppointmentRuleSlotDO();
            slot.setId(IdUtil.getSnowflakeNextId());
            slot.setTenantId(tenantId);
            slot.setRuleId(ruleId);
            slot.setWeekday(slotBo.getWeekday());
            slot.setStartTime(slotBo.getStartTime());
            slot.setEndTime(slotBo.getEndTime());
            slot.setSlotMinutes(slotBo.getSlotMinutes());
            slot.setCapacity(slotBo.getCapacity());
            slot.setEnabled(slotBo.getEnabled() != null ? slotBo.getEnabled() : 1);
            slotMapper.insert(slot);
        }
    }

    private void applyDefaults(YmsAppointmentRuleDO rule) {
        if (rule.getEnabled() == null) rule.setEnabled(1);
        if (rule.getSortOrder() == null) rule.setSortOrder(0);
        if (rule.getCancelDeadlineMinutes() == null) rule.setCancelDeadlineMinutes(60);
        if (rule.getLateGraceMinutes() == null) rule.setLateGraceMinutes(30);
        if (rule.getNoShowMinutes() == null) rule.setNoShowMinutes(60);
        if (rule.getAutoConfirm() == null) rule.setAutoConfirm(0);
        if (rule.getHolidayFlag() == null) rule.setHolidayFlag(0);
    }

    private void validateAdvanceDays(Integer min, Integer max) {
        if (min != null && max != null && min > max) {
            throw new ServiceException(500, "最少提前预约天数不能大于最多提前预约天数");
        }
    }

    private String parseSlotStart(String aptSlot) {
        if (StrUtil.isBlank(aptSlot)) {
            return null;
        }
        String[] parts = aptSlot.split("-");
        return parts.length > 0 ? parts[0].trim() : null;
    }
}
