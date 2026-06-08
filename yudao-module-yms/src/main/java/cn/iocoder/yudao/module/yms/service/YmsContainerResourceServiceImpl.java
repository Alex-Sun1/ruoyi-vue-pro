package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.module.yms.util.YmsPageUtils;

import cn.hutool.core.util.IdUtil;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.exception.ServiceException;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.dal.dataobject.yarddock.YardDockDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsContainerResourceDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsContainerResourceAddReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsContainerResourceEditReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsContainerResourceQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsInternalTaskCreateReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsContainerResourceRespVO;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsContainerResourceMapper;
import cn.iocoder.yudao.module.yms.support.YmsYardLocationConverter;
import cn.iocoder.yudao.module.yms.support.YmsYardLocationSupport;
import cn.iocoder.yudao.module.yms.service.YmsContainerResourceService;
import cn.iocoder.yudao.module.yms.service.YmsInternalTaskService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;


@Service
public class YmsContainerResourceServiceImpl implements YmsContainerResourceService {

    @Resource
    private YmsContainerResourceMapper baseMapper;
    @Resource
    private YmsYardLocationSupport locationSupport;
    @Resource
    private YmsInternalTaskService internalTaskService;

    @Override
    public PageResult<YmsContainerResourceRespVO> queryPageList(YmsContainerResourceQueryReqVO bo, PageParam pageParam) {
        Page<YmsContainerResourceRespVO> result = baseMapper.selectPageList(YmsPageUtils.toPage(pageParam), bo);
        return YmsPageUtils.toPageResult(result);
    }

    @Override
    public YmsContainerResourceRespVO queryById(Long id) {
        return BeanUtils.toBean(baseMapper.selectById(id), YmsContainerResourceRespVO.class);
    }

    @Override
    public List<YmsContainerResourceRespVO> queryList(YmsContainerResourceQueryReqVO bo) {
        Page<YmsContainerResourceRespVO> page = baseMapper.selectPageList(new Page<>(1, 10_000), bo);
        return page.getRecords();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean insertByBo(YmsContainerResourceAddReqVO bo) {
        // 同一租户下不允许重复柜号（在场）
        Long count = baseMapper.selectCount(
            Wrappers.<YmsContainerResourceDO>lambdaQuery()
                .eq(YmsContainerResourceDO::getContainerNo, bo.getContainerNo())
                .notIn(YmsContainerResourceDO::getContainerStatus, "LEFT_YARD", "RETURNED")
        );
        if (count > 0) {
            throw new ServiceException(500, "柜号 " + bo.getContainerNo() + " 已在场，请检查");
        }
        YmsContainerResourceDO add = BeanUtils.toBean(bo, YmsContainerResourceDO.class);
        add.setContainerStatus("EXPECTED_ARRIVAL");
        if (add.getEmptyStatus() == null) add.setEmptyStatus("FULL");
        if (add.getExceptionFlag() == null) add.setExceptionFlag(0);
        return baseMapper.insert(add) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean updateByBo(YmsContainerResourceEditReqVO bo) {
        YmsContainerResourceDO update = BeanUtils.toBean(bo, YmsContainerResourceDO.class);
        return baseMapper.updateById(update) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean deleteWithValidByIds(List<Long> ids, Boolean isValid) {
        if (isValid) {
            for (Long id : ids) {
                YmsContainerResourceDO container = baseMapper.selectById(id);
                if (container != null) {
                    String s = container.getContainerStatus();
                    if ("ON_DOCK".equals(s) || "DEVANNING".equals(s) || "WMS_WORKING".equals(s)) {
                        throw new ServiceException(500, "柜号 " + container.getContainerNo() + " 当前状态不允许删除");
                    }
                }
            }
        }
        return baseMapper.deleteByIds(ids) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean assignPosition(Long id, Long positionId) {
        YmsContainerResourceDO container = baseMapper.selectById(id);
        if (container == null) throw new ServiceException(500, "海柜资源不存在");

        YardDockDO position = locationSupport.requireSlot(positionId);
        if (!YmsYardLocationConverter.isFree(position) && !positionId.equals(container.getYardPositionId())) {
            throw new ServiceException(500, "堆场位 " + position.getDockCode() + " 已被占用");
        }

        if (container.getYardPositionId() != null) {
            locationSupport.releaseSlot(container.getYardPositionId());
        }

        locationSupport.occupySlot(positionId, "CONTAINER", id, container.getContainerNo());

        YmsContainerResourceDO update = new YmsContainerResourceDO();
        update.setId(id);
        update.setYardPositionId(positionId);
        update.setYardZoneId(position.getZoneId());
        String newStatus = "ARRIVED".equals(container.getContainerStatus()) ? "YARD_ASSIGNED"
            : container.getContainerStatus();
        update.setContainerStatus(newStatus);
        return baseMapper.updateById(update) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean markArrived(Long id, String plateNo, String driverName, String driverPhone) {
        YmsContainerResourceDO update = new YmsContainerResourceDO();
        update.setId(id);
        update.setContainerStatus("ARRIVED");
        update.setArrivedTime(new Date());
        update.setPlateNo(plateNo);
        update.setDriverName(driverName);
        update.setDriverPhone(driverPhone);
        return baseMapper.updateById(update) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean callToDock(Long id, Long dockId) {
        YmsContainerResourceDO container = baseMapper.selectById(id);
        if (container == null) throw new ServiceException(500, "海柜资源不存在");
        if (!"WAIT_DEVANNING".equals(container.getContainerStatus())
            && !"YARD_ASSIGNED".equals(container.getContainerStatus())) {
            throw new ServiceException(500, "当前状态不允许叫号：" + container.getContainerStatus());
        }



        YmsContainerResourceDO update = new YmsContainerResourceDO();
        update.setId(id);
        update.setContainerStatus("CALLED");
        update.setDockId(dockId);
        boolean ok = baseMapper.updateById(update) > 0;
        if (ok) {
            YmsInternalTaskCreateReqVO taskBo = new YmsInternalTaskCreateReqVO();
            taskBo.setWarehouseId(container.getWarehouseId());
            taskBo.setInternalTaskType("CONTAINER_TO_DOCK");
            taskBo.setObjectType("CONTAINER");
            taskBo.setObjectId(id);
            taskBo.setObjectNo(container.getContainerNo());
            taskBo.setFromPositionId(container.getYardPositionId());
            taskBo.setToDockId(dockId);
            internalTaskService.createToDockTask(taskBo);
        }
        return ok;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean markOnDock(Long id, Long dockId, String dockCode) {
        YmsContainerResourceDO update = new YmsContainerResourceDO();
        update.setId(id);
        update.setContainerStatus("ON_DOCK");
        update.setDockId(dockId);
        update.setDockCode(dockCode);
        return baseMapper.updateById(update) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean markDevanned(Long id) {
        YmsContainerResourceDO update = new YmsContainerResourceDO();
        update.setId(id);
        update.setContainerStatus("DEVANNED");
        update.setDevanningFinishTime(new Date());
        update.setEmptyStatus("EMPTY");
        return baseMapper.updateById(update) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean markEmptyWaitReturn(Long id) {
        YmsContainerResourceDO update = new YmsContainerResourceDO();
        update.setId(id);
        update.setContainerStatus("EMPTY_WAIT_RETURN");
        return baseMapper.updateById(update) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean markLeftYard(Long id) {
        YmsContainerResourceDO update = new YmsContainerResourceDO();
        update.setId(id);
        update.setContainerStatus("LEFT_YARD");
        update.setLeaveTime(new Date());
        return baseMapper.updateById(update) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean markException(Long id, String reason) {
        YmsContainerResourceDO update = new YmsContainerResourceDO();
        update.setId(id);
        update.setContainerStatus("EXCEPTION");
        update.setExceptionFlag(1);
        update.setExceptionReason(reason);
        return baseMapper.updateById(update) > 0;
    }
}
