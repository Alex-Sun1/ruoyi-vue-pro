package cn.iocoder.yudao.module.yms.service;

import cn.iocoder.yudao.module.yms.util.YmsPageUtils;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.exception.ServiceException;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsContainerResourceDO;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsTrailerResourceDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsExceptionQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsExceptionRespVO;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsContainerResourceMapper;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsExceptionMapper;
import cn.iocoder.yudao.module.yms.dal.mysql.YmsTrailerResourceMapper;
import cn.iocoder.yudao.module.yms.service.YmsDispatchService;
import cn.iocoder.yudao.module.yms.service.YmsExceptionService;
import cn.iocoder.yudao.module.yms.service.YmsGateService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


@Service
public class YmsExceptionServiceImpl implements YmsExceptionService {

    @Resource
    private YmsExceptionMapper exceptionMapper;
    @Resource
    private YmsContainerResourceMapper containerResourceMapper;
    @Resource
    private YmsTrailerResourceMapper trailerResourceMapper;
    @Resource
    private YmsGateService gateService;
    @Resource
    private YmsDispatchService dispatchService;

    @Override
    public PageResult<YmsExceptionRespVO> queryPageList(YmsExceptionQueryReqVO bo, PageParam pageParam) {
        Page<YmsExceptionRespVO> page = exceptionMapper.selectPageList(YmsPageUtils.toPage(pageParam), bo);
        return YmsPageUtils.toPageResult(page);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean resolve(String sourceType, Long refId, String remark) {
        return switch (sourceType) {
            case "CHECK_IN" -> {
                gateService.manualPass(refId, remark);
                yield true;
            }
            case "TASK" -> dispatchService.clearException(refId);
            case "CONTAINER" -> resolveContainer(refId, remark);
            case "TRAILER" -> resolveTrailer(refId, remark);
            default -> throw new ServiceException(500, "不支持的异常来源：" + sourceType);
        };
    }

    private Boolean resolveContainer(Long id, String remark) {
        YmsContainerResourceDO container = containerResourceMapper.selectById(id);
        if (container == null) throw new ServiceException(500, "海柜资源不存在");
        YmsContainerResourceDO update = new YmsContainerResourceDO();
        update.setId(id);
        update.setContainerStatus("WAIT_DEVANNING");
        update.setExceptionFlag(0);
        update.setExceptionReason(null);
        if (remark != null) update.setRemark(remark);
        return containerResourceMapper.updateById(update) > 0;
    }

    private Boolean resolveTrailer(Long id, String remark) {
        YmsTrailerResourceDO trailer = trailerResourceMapper.selectById(id);
        if (trailer == null) throw new ServiceException(500, "车厢资源不存在");
        YmsTrailerResourceDO update = new YmsTrailerResourceDO();
        update.setId(id);
        update.setTrailerStatus("WAIT_LOADING");
        update.setExceptionFlag(0);
        update.setExceptionReason(null);
        if (remark != null) update.setRemark(remark);
        return trailerResourceMapper.updateById(update) > 0;
    }
}
