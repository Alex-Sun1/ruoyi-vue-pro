package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.module.yms.util.YmsPageUtils;

import cn.hutool.core.util.IdUtil;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsBlacklistDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsBlacklistAddReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsBlacklistEditReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsBlacklistQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsBlacklistRespVO;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsBlacklistMapper;
import cn.iocoder.yudao.module.yms.service.YmsBlacklistService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;


@Service
public class YmsBlacklistServiceImpl implements YmsBlacklistService {

    @Resource
    private YmsBlacklistMapper baseMapper;

    @Override
    public PageResult<YmsBlacklistRespVO> queryPageList(YmsBlacklistQueryReqVO bo, PageParam pageParam) {
        return YmsPageUtils.toPageResult(baseMapper.selectPageList(YmsPageUtils.toPage(pageParam), bo));
    }

    @Override
    public YmsBlacklistRespVO queryById(Long id) {
        return BeanUtils.toBean(baseMapper.selectById(id), YmsBlacklistRespVO.class);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean insertByBo(YmsBlacklistAddReqVO bo) {
        YmsBlacklistDO add = BeanUtils.toBean(bo, YmsBlacklistDO.class);
        add.setId(IdUtil.getSnowflakeNextId());
        add.setStatus("ACTIVE");
        if (add.getBlacklistTime() == null) add.setBlacklistTime(new Date());
        return baseMapper.insert(add) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean updateByBo(YmsBlacklistEditReqVO bo) {
        YmsBlacklistDO update = BeanUtils.toBean(bo, YmsBlacklistDO.class);
        return baseMapper.updateById(update) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean removeByIds(List<Long> ids) {
        return baseMapper.update(null, Wrappers.<YmsBlacklistDO>lambdaUpdate()
            .in(YmsBlacklistDO::getId, ids)
            .set(YmsBlacklistDO::getStatus, "REMOVED")) > 0;
    }

    @Override
    public boolean isBlacklisted(String targetType, String targetValue) {
        return baseMapper.selectCount(Wrappers.<YmsBlacklistDO>lambdaQuery()
            .eq(YmsBlacklistDO::getTargetType, targetType)
            .eq(YmsBlacklistDO::getTargetValue, targetValue)
            .eq(YmsBlacklistDO::getStatus, "ACTIVE")) > 0;
    }

    @Override
    public boolean isPlateBlacklisted(String plateNo) {
        return isBlacklisted("PLATE_NO", plateNo);
    }

    @Override
    public boolean isDriverPhoneBlacklisted(String phone) {
        return isBlacklisted("DRIVER_PHONE", phone);
    }
}
