package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.module.yms.util.YmsPageUtils;

import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsSlotTemplateDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsSlotTemplateAddReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsSlotTemplateEditReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsSlotTemplateQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsSlotTemplateRespVO;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsSlotTemplateMapper;
import cn.iocoder.yudao.module.yms.service.YmsSlotTemplateService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;


@Service
public class YmsSlotTemplateServiceImpl implements YmsSlotTemplateService {

    @Resource
    private YmsSlotTemplateMapper baseMapper;

    @Override
    public PageResult<YmsSlotTemplateRespVO> queryPageList(YmsSlotTemplateQueryReqVO bo, PageParam pageParam) {
        return YmsPageUtils.toPageResult(baseMapper.selectPageList(YmsPageUtils.toPage(pageParam), bo));
    }

    @Override
    public List<YmsSlotTemplateRespVO> queryEnabledByWarehouse(Long warehouseId, String taskType) {
        return baseMapper.selectEnabledByWarehouse(warehouseId, taskType);
    }

    @Override
    public YmsSlotTemplateRespVO queryById(Long id) {
        return BeanUtils.toBean(baseMapper.selectById(id), YmsSlotTemplateRespVO.class);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean insertByBo(YmsSlotTemplateAddReqVO bo) {
        YmsSlotTemplateDO add = BeanUtils.toBean(bo, YmsSlotTemplateDO.class);
        if (add.getEnabled() == null) add.setEnabled(1);
        return baseMapper.insert(add) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean updateByBo(YmsSlotTemplateEditReqVO bo) {
        YmsSlotTemplateDO update = BeanUtils.toBean(bo, YmsSlotTemplateDO.class);
        return baseMapper.updateById(update) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean deleteByIds(List<Long> ids) {
        return baseMapper.deleteByIds(ids) > 0;
    }
}
