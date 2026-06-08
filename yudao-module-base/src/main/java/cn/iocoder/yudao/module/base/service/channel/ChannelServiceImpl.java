package cn.iocoder.yudao.module.base.service.channel;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.base.controller.admin.channel.vo.*;
import cn.iocoder.yudao.module.base.dal.dataobject.channel.ChannelDO;
import cn.iocoder.yudao.module.base.dal.mysql.channel.ChannelMapper;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.util.List;
import java.util.Objects;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.base.enums.ErrorCodeConstants.*;

@Service
@Validated
public class ChannelServiceImpl implements ChannelService {

    @Resource
    private ChannelMapper channelMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createChannel(ChannelSaveReqVO createReqVO) {
        normalize(createReqVO);
        validateUnique(null, createReqVO.getChannelCode());
        if (createReqVO.getStatus() == null) {
            createReqVO.setStatus(CommonStatusEnum.ENABLE.getStatus());
        }
        if (createReqVO.getPriority() == null) {
            createReqVO.setPriority(0);
        }
        if (createReqVO.getSortOrder() == null) {
            createReqVO.setSortOrder(0);
        }
        ChannelDO row = BeanUtils.toBean(createReqVO, ChannelDO.class);
        channelMapper.insert(row);
        return row.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateChannel(ChannelSaveReqVO updateReqVO) {
        ChannelDO existing = validateExists(updateReqVO.getId());
        normalize(updateReqVO);
        if (!Objects.equals(existing.getChannelCode(), updateReqVO.getChannelCode())) {
            throw exception(CHANNEL_CODE_NOT_MODIFIABLE);
        }
        ChannelDO update = BeanUtils.toBean(updateReqVO, ChannelDO.class);
        update.setStatus(existing.getStatus());
        if (update.getPriority() == null) {
            update.setPriority(existing.getPriority());
        }
        if (update.getSortOrder() == null) {
            update.setSortOrder(existing.getSortOrder());
        }
        channelMapper.updateById(update);
    }

    @Override
    public void updateChannelStatus(ChannelUpdateStatusReqVO reqVO) {
        validateExists(reqVO.getId());
        ChannelDO update = new ChannelDO();
        update.setId(reqVO.getId());
        update.setStatus(reqVO.getStatus());
        channelMapper.updateById(update);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteChannel(Long id) {
        ChannelDO row = validateExists(id);
        if (CommonStatusEnum.ENABLE.getStatus().equals(row.getStatus())) {
            throw exception(CHANNEL_DELETE_ENABLED);
        }
        channelMapper.deleteById(id);
    }

    @Override
    public ChannelRespVO getChannel(Long id) {
        return BeanUtils.toBean(validateExists(id), ChannelRespVO.class);
    }

    @Override
    public PageResult<ChannelRespVO> getChannelPage(ChannelPageReqVO pageReqVO) {
        return BeanUtils.toBean(channelMapper.selectPage(pageReqVO), ChannelRespVO.class);
    }

    @Override
    public List<ChannelRespVO> getChannelSimpleList(Integer status, String channelType, String containerMode) {
        return BeanUtils.toBean(channelMapper.selectSimpleList(status, channelType, containerMode), ChannelRespVO.class);
    }

    @Override
    public List<ChannelRespVO> getChannelExportList(ChannelPageReqVO pageReqVO) {
        pageReqVO.setPageSize(-1);
        return getChannelPage(pageReqVO).getList();
    }

    private ChannelDO validateExists(Long id) {
        ChannelDO row = channelMapper.selectById(id);
        if (row == null) {
            throw exception(CHANNEL_NOT_EXISTS);
        }
        return row;
    }

    private void validateUnique(Long id, String channelCode) {
        ChannelDO exist = channelMapper.selectByUnique(channelCode);
        if (exist != null && (id == null || !exist.getId().equals(id))) {
            throw exception(CHANNEL_DUPLICATE);
        }
    }

    private void normalize(ChannelSaveReqVO reqVO) {
        if (reqVO.getChannelCode() != null) {
            reqVO.setChannelCode(reqVO.getChannelCode().trim().toUpperCase());
        }
        if (reqVO.getChannelName() != null) {
            reqVO.setChannelName(reqVO.getChannelName().trim());
        }
        if (reqVO.getChannelType() != null) {
            reqVO.setChannelType(StrUtil.trim(reqVO.getChannelType()).toUpperCase());
        }
        if (reqVO.getContainerMode() != null) {
            reqVO.setContainerMode(StrUtil.trim(reqVO.getContainerMode()).toUpperCase());
        }
    }

}
