package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.module.yms.util.YmsPageUtils;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.exception.ServiceException;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.dal.dataobject.yarddock.YardDockDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsTrailerResourceDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsInternalTaskCreateReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsTrailerResourceAddReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsTrailerResourceEditReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsTrailerResourceQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsTrailerResourceRespVO;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsTrailerResourceMapper;
import cn.iocoder.yudao.module.yms.support.YmsYardLocationConverter;
import cn.iocoder.yudao.module.yms.support.YmsYardLocationSupport;
import cn.iocoder.yudao.module.yms.service.YmsInternalTaskService;
import cn.iocoder.yudao.module.yms.service.YmsTrailerResourceService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;


@Service
public class YmsTrailerResourceServiceImpl implements YmsTrailerResourceService {

    @Resource
    private YmsTrailerResourceMapper baseMapper;
    @Resource
    private YmsYardLocationSupport locationSupport;
    @Resource
    private YmsInternalTaskService internalTaskService;

    @Override
    public PageResult<YmsTrailerResourceRespVO> queryPageList(YmsTrailerResourceQueryReqVO bo, PageParam pageParam) {
        Page<YmsTrailerResourceRespVO> result = baseMapper.selectPageList(YmsPageUtils.toPage(pageParam), bo);
        return YmsPageUtils.toPageResult(result);
    }

    @Override
    public YmsTrailerResourceRespVO queryById(Long id) {
        return BeanUtils.toBean(baseMapper.selectById(id), YmsTrailerResourceRespVO.class);
    }

    @Override
    public List<YmsTrailerResourceRespVO> queryList(YmsTrailerResourceQueryReqVO bo) {
        Page<YmsTrailerResourceRespVO> page = baseMapper.selectPageList(new Page<>(1, 10_000), bo);
        return page.getRecords();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean insertByBo(YmsTrailerResourceAddReqVO bo) {
        YmsTrailerResourceDO add = BeanUtils.toBean(bo, YmsTrailerResourceDO.class);
        add.setTrailerStatus("EXPECTED_ARRIVAL");
        add.setWmsReadyStatus("NOT_REQUIRED");
        if (add.getExceptionFlag() == null) add.setExceptionFlag(0);
        return baseMapper.insert(add) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean updateByBo(YmsTrailerResourceEditReqVO bo) {
        YmsTrailerResourceDO update = BeanUtils.toBean(bo, YmsTrailerResourceDO.class);
        return baseMapper.updateById(update) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean deleteWithValidByIds(List<Long> ids, Boolean isValid) {
        if (isValid) {
            for (Long id : ids) {
                YmsTrailerResourceDO trailer = baseMapper.selectById(id);
                if (trailer != null) {
                    String s = trailer.getTrailerStatus();
                    if ("ON_DOCK".equals(s) || "LOADING".equals(s)) {
                        throw new ServiceException(500, "车厢 " + trailer.getTrailerNo() + " 当前状态不允许删除");
                    }
                }
            }
        }
        return baseMapper.deleteByIds(ids) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean assignPosition(Long id, Long positionId) {
        YmsTrailerResourceDO trailer = baseMapper.selectById(id);
        if (trailer == null) throw new ServiceException(500, "车厢资源不存在");

        YardDockDO position = locationSupport.requireSlot(positionId);
        if (!YmsYardLocationConverter.isFree(position) && !positionId.equals(trailer.getYardPositionId())) {
            throw new ServiceException(500, "堆场位 " + position.getDockCode() + " 已被占用");
        }

        if (trailer.getYardPositionId() != null) {
            locationSupport.releaseSlot(trailer.getYardPositionId());
        }

        locationSupport.occupySlot(positionId, "TRAILER", id, trailer.getTrailerNo());

        YmsTrailerResourceDO update = new YmsTrailerResourceDO();
        update.setId(id);
        update.setYardPositionId(positionId);
        update.setYardZoneId(position.getZoneId());
        return baseMapper.updateById(update) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean markArrived(Long id) {
        YmsTrailerResourceDO update = new YmsTrailerResourceDO();
        update.setId(id);
        update.setTrailerStatus("ARRIVED_EMPTY");
        update.setArriveTime(new Date());
        return baseMapper.updateById(update) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean markWmsReady(Long id) {
        YmsTrailerResourceDO update = new YmsTrailerResourceDO();
        update.setId(id);
        update.setWmsReadyStatus("READY");
        update.setWmsReadyTime(new Date());
        // 若已到仓，进入等待叫号
        YmsTrailerResourceDO trailer = baseMapper.selectById(id);
        if (trailer != null && "ARRIVED_EMPTY".equals(trailer.getTrailerStatus())) {
            update.setTrailerStatus("WAIT_LOADING");
        }
        return baseMapper.updateById(update) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean callToDock(Long id, Long dockId) {
        YmsTrailerResourceDO trailer = baseMapper.selectById(id);
        if (trailer == null) throw new ServiceException(500, "车厢资源不存在");
        if (!"WAIT_LOADING".equals(trailer.getTrailerStatus())
            && !"ARRIVED_EMPTY".equals(trailer.getTrailerStatus())) {
            throw new ServiceException(500, "当前状态不允许叫号：" + trailer.getTrailerStatus());
        }



        YmsTrailerResourceDO update = new YmsTrailerResourceDO();
        update.setId(id);
        update.setTrailerStatus("ON_DOCK");
        update.setDockId(dockId);
        boolean ok = baseMapper.updateById(update) > 0;
        if (ok) {
            YmsInternalTaskCreateReqVO taskBo = new YmsInternalTaskCreateReqVO();
            taskBo.setWarehouseId(trailer.getWarehouseId());
            taskBo.setInternalTaskType("TRAILER_TO_DOCK");
            taskBo.setObjectType("TRAILER");
            taskBo.setObjectId(id);
            taskBo.setObjectNo(StrUtil.blankToDefault(trailer.getTrailerNo(), trailer.getPlateNo()));
            taskBo.setFromPositionId(trailer.getYardPositionId());
            taskBo.setToDockId(dockId);
            taskBo.setParentYardTaskId(trailer.getRelatedLoadingTaskId());
            internalTaskService.createToDockTask(taskBo);
        }
        return ok;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean markOnDock(Long id, Long dockId, String dockCode) {
        YmsTrailerResourceDO update = new YmsTrailerResourceDO();
        update.setId(id);
        update.setTrailerStatus("ON_DOCK");
        update.setDockId(dockId);
        update.setDockCode(dockCode);
        return baseMapper.updateById(update) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean markLoaded(Long id) {
        YmsTrailerResourceDO update = new YmsTrailerResourceDO();
        update.setId(id);
        update.setTrailerStatus("LOADED");
        update.setLoadingFinishTime(new Date());
        return baseMapper.updateById(update) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean markLeftYard(Long id) {
        YmsTrailerResourceDO update = new YmsTrailerResourceDO();
        update.setId(id);
        update.setTrailerStatus("LEFT_YARD");
        update.setLeaveTime(new Date());
        return baseMapper.updateById(update) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean markException(Long id, String reason) {
        YmsTrailerResourceDO update = new YmsTrailerResourceDO();
        update.setId(id);
        update.setTrailerStatus("EXCEPTION");
        update.setExceptionFlag(1);
        update.setExceptionReason(reason);
        return baseMapper.updateById(update) > 0;
    }
}
