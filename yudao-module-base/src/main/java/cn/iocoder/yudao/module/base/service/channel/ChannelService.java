package cn.iocoder.yudao.module.base.service.channel;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.controller.admin.channel.vo.*;

import java.util.List;

public interface ChannelService {

    Long createChannel(ChannelSaveReqVO createReqVO);

    void updateChannel(ChannelSaveReqVO updateReqVO);

    void updateChannelStatus(ChannelUpdateStatusReqVO reqVO);

    void deleteChannel(Long id);

    ChannelRespVO getChannel(Long id);

    PageResult<ChannelRespVO> getChannelPage(ChannelPageReqVO pageReqVO);

    List<ChannelRespVO> getChannelSimpleList(Integer status, String channelType, String containerMode);

    List<ChannelRespVO> getChannelExportList(ChannelPageReqVO pageReqVO);

}
