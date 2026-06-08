package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.framework.common.util.object.BeanUtils;

import cn.iocoder.yudao.module.yms.util.YmsPageUtils;

import cn.hutool.core.util.IdUtil;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.exception.ServiceException;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsYardTaskDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsYardgoTaskDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsRobotCallbackReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardgoTaskQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsYardgoTaskRespVO;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsYardTaskMapper;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsYardgoTaskMapper;
import cn.iocoder.yudao.module.yms.service.YmsYardgoService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;


@Service
public class YmsYardgoServiceImpl implements YmsYardgoService {

    @Resource
    private YmsYardgoTaskMapper baseMapper;
    @Resource
    private YmsYardTaskMapper yardTaskMapper;

    @Override
    public PageResult<YmsYardgoTaskRespVO> queryPageList(YmsYardgoTaskQueryReqVO bo, PageParam pageParam) {
        return YmsPageUtils.toPageResult(baseMapper.selectPageList(YmsPageUtils.toPage(pageParam), bo));
    }

    @Override
    public YmsYardgoTaskRespVO queryById(Long id) {
        return BeanUtils.toBean(baseMapper.selectById(id), YmsYardgoTaskRespVO.class);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public YmsYardgoTaskRespVO createFromYardTask(Long yardTaskId) {
        YmsYardTaskDO yardTask = yardTaskMapper.selectById(yardTaskId);
        if (yardTask == null) throw new ServiceException(500, "园区任务不存在");

        YmsYardgoTaskDO task = new YmsYardgoTaskDO();
        task.setId(IdUtil.getSnowflakeNextId());
        task.setYardTaskId(yardTaskId);
        task.setWarehouseId(yardTask.getWarehouseId());
        task.setDockId(yardTask.getDockId());
        task.setDockCode(yardTask.getDockCode());
        task.setTaskType(yardTask.getTaskType());
        task.setRobotStatus("PENDING");
        task.setProgress(java.math.BigDecimal.ZERO);
        baseMapper.insert(task);

        return BeanUtils.toBean(baseMapper.selectById(task.getId()), YmsYardgoTaskRespVO.class);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean robotCallback(YmsRobotCallbackReqVO bo) {
        YmsYardgoTaskDO task = baseMapper.selectOne(
            Wrappers.<YmsYardgoTaskDO>lambdaQuery()
                .eq(YmsYardgoTaskDO::getRobotTaskId, bo.getRobotTaskId()));
        if (task == null) return false;

        com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper<YmsYardgoTaskDO> uw =
            Wrappers.<YmsYardgoTaskDO>lambdaUpdate()
                .eq(YmsYardgoTaskDO::getId, task.getId())
                .set(YmsYardgoTaskDO::getRobotStatus, bo.getStatus())
                .set(bo.getProgress() != null, YmsYardgoTaskDO::getProgress, bo.getProgress())
                .set(bo.getPayload() != null, YmsYardgoTaskDO::getCallbackPayload, bo.getPayload());

        if ("COMPLETED".equals(bo.getStatus())) {
            uw.set(YmsYardgoTaskDO::getFinishTime, new Date());
        } else if ("RUNNING".equals(bo.getStatus()) && task.getStartTime() == null) {
            uw.set(YmsYardgoTaskDO::getStartTime, new Date());
        }
        return baseMapper.update(null, uw) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean cancelRobotTask(Long id) {
        return baseMapper.update(null, Wrappers.<YmsYardgoTaskDO>lambdaUpdate()
            .eq(YmsYardgoTaskDO::getId, id)
            .set(YmsYardgoTaskDO::getRobotStatus, "CANCELLED")) > 0;
    }
}
