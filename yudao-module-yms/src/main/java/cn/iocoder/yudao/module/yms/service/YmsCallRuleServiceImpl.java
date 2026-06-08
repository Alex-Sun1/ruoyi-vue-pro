package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.module.yms.util.YmsPageUtils;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.IdUtil;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.exception.ServiceException;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsCallRuleDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsCallRuleConditionDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsCallRuleSortDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCallRuleAddReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCallRuleConditionReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCallRuleEditReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCallRuleQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCallRuleSortReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCallRuleConditionRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCallRuleSortRespVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsCallRuleRespVO;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsCallRuleConditionMapper;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsCallRuleMapper;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsCallRuleSortMapper;
import cn.iocoder.yudao.module.yms.service.YmsCallRuleService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;


@Service
public class YmsCallRuleServiceImpl implements YmsCallRuleService {

    @Resource
    private YmsCallRuleMapper baseMapper;
    @Resource
    private YmsCallRuleConditionMapper conditionMapper;
    @Resource
    private YmsCallRuleSortMapper sortMapper;

    @Override
    public PageResult<YmsCallRuleRespVO> queryPageList(YmsCallRuleQueryReqVO bo, PageParam pageParam) {
        return YmsPageUtils.toPageResult(baseMapper.selectPageList(YmsPageUtils.toPage(pageParam), bo));
    }

    @Override
    public YmsCallRuleRespVO queryById(Long id) {
        YmsCallRuleRespVO vo = BeanUtils.toBean(baseMapper.selectById(id), YmsCallRuleRespVO.class);
        if (vo == null) {
            return null;
        }
        vo.setConditions(BeanUtils.toBean(conditionMapper.selectList(
            Wrappers.<YmsCallRuleConditionDO>lambdaQuery()
                .eq(YmsCallRuleConditionDO::getRuleId, id)
                .orderByAsc(YmsCallRuleConditionDO::getSortOrder)
        ), YmsCallRuleConditionRespVO.class));
        vo.setSorts(BeanUtils.toBean(sortMapper.selectList(
            Wrappers.<YmsCallRuleSortDO>lambdaQuery()
                .eq(YmsCallRuleSortDO::getRuleId, id)
                .orderByAsc(YmsCallRuleSortDO::getPriorityOrder)
        ), YmsCallRuleSortRespVO.class));
        return vo;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean insertByBo(YmsCallRuleAddReqVO bo) {
        YmsCallRuleDO add = BeanUtils.toBean(bo, YmsCallRuleDO.class);
        add.setId(IdUtil.getSnowflakeNextId());
        applyDefaults(add);
        boolean ok = baseMapper.insert(add) > 0;
        if (ok) {
            saveSubTables(add.getId(), bo.getConditions(), bo.getSorts());
        }
        return ok;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean updateByBo(YmsCallRuleEditReqVO bo) {
        YmsCallRuleDO existing = baseMapper.selectById(bo.getId());
        if (existing == null) {
            throw new ServiceException(500, "叫号规则不存在");
        }
        YmsCallRuleDO update = BeanUtils.toBean(bo, YmsCallRuleDO.class);
        boolean ok = baseMapper.updateById(update) > 0;
        if (ok) {
            conditionMapper.delete(Wrappers.<YmsCallRuleConditionDO>lambdaQuery()
                .eq(YmsCallRuleConditionDO::getRuleId, bo.getId()));
            sortMapper.delete(Wrappers.<YmsCallRuleSortDO>lambdaQuery()
                .eq(YmsCallRuleSortDO::getRuleId, bo.getId()));
            saveSubTables(bo.getId(), bo.getConditions(), bo.getSorts());
        }
        return ok;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean deleteByIds(List<Long> ids) {
        for (Long id : ids) {
            conditionMapper.delete(Wrappers.<YmsCallRuleConditionDO>lambdaQuery()
                .eq(YmsCallRuleConditionDO::getRuleId, id));
            sortMapper.delete(Wrappers.<YmsCallRuleSortDO>lambdaQuery()
                .eq(YmsCallRuleSortDO::getRuleId, id));
        }
        return baseMapper.deleteByIds(ids) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean toggle(Long id) {
        YmsCallRuleDO rule = baseMapper.selectById(id);
        if (rule == null) {
            throw new ServiceException(500, "叫号规则不存在");
        }
        YmsCallRuleDO update = new YmsCallRuleDO();
        update.setId(id);
        update.setEnabled(rule.getEnabled() != null && rule.getEnabled() == 1 ? 0 : 1);
        return baseMapper.updateById(update) > 0;
    }

    private void applyDefaults(YmsCallRuleDO rule) {
        if (rule.getWmsReadyRequired() == null) rule.setWmsReadyRequired(0);
        if (rule.getAppointmentRequired() == null) rule.setAppointmentRequired(0);
        if (rule.getAllowManualInsert() == null) rule.setAllowManualInsert(1);
        if (rule.getAutoCallEnabled() == null) rule.setAutoCallEnabled(0);
        if (rule.getRequireDispatchConfirm() == null) rule.setRequireDispatchConfirm(1);
        if (rule.getMaxCallCount() == null) rule.setMaxCallCount(3);
        if (rule.getCallTimeoutMinutes() == null) rule.setCallTimeoutMinutes(15);
        if (rule.getEnabled() == null) rule.setEnabled(1);
        if (rule.getSortOrder() == null) rule.setSortOrder(0);
    }

    private void saveSubTables(Long ruleId, List<YmsCallRuleConditionReqVO> conditions, List<YmsCallRuleSortReqVO> sorts) {
        if (CollUtil.isNotEmpty(conditions)) {
            int idx = 1;
            for (YmsCallRuleConditionReqVO bo : conditions) {
                YmsCallRuleConditionDO row = new YmsCallRuleConditionDO();
                row.setId(IdUtil.getSnowflakeNextId());
                row.setRuleId(ruleId);
                row.setConditionField(bo.getConditionField());
                row.setOperator(bo.getOperator());
                row.setConditionValue(bo.getConditionValue());
                row.setSortOrder(bo.getSortOrder() != null ? bo.getSortOrder() : idx++);
                conditionMapper.insert(row);
            }
        }
        if (CollUtil.isNotEmpty(sorts)) {
            for (YmsCallRuleSortReqVO bo : sorts) {
                YmsCallRuleSortDO row = new YmsCallRuleSortDO();
                row.setId(IdUtil.getSnowflakeNextId());
                row.setRuleId(ruleId);
                row.setSortField(bo.getSortField());
                row.setSortDirection(bo.getSortDirection());
                row.setPriorityOrder(bo.getPriorityOrder());
                sortMapper.insert(row);
            }
        }
    }
}
