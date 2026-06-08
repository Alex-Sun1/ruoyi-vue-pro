package cn.iocoder.yudao.module.base.dal.mysql.channel;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.controller.admin.channel.vo.ChannelPageReqVO;
import cn.iocoder.yudao.module.base.dal.dataobject.channel.ChannelDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ChannelMapper extends BaseMapperX<ChannelDO> {

    default PageResult<ChannelDO> selectPage(ChannelPageReqVO reqVO) {
        LambdaQueryWrapperX<ChannelDO> wrapper = new LambdaQueryWrapperX<>();
        wrapper.and(StrUtil.isNotBlank(reqVO.getKeyword()), w -> w
                .like(ChannelDO::getChannelCode, reqVO.getKeyword())
                .or()
                .like(ChannelDO::getChannelName, reqVO.getKeyword()));
        wrapper.eqIfPresent(ChannelDO::getChannelType, reqVO.getChannelType());
        wrapper.eqIfPresent(ChannelDO::getContainerMode, reqVO.getContainerMode());
        wrapper.eqIfPresent(ChannelDO::getStatus, reqVO.getStatus());
        wrapper.orderByAsc(ChannelDO::getSortOrder).orderByAsc(ChannelDO::getPriority).orderByDesc(ChannelDO::getId);
        return selectPage(reqVO, wrapper);
    }

    default ChannelDO selectByUnique(String channelCode) {
        return selectOne(new LambdaQueryWrapperX<ChannelDO>().eq(ChannelDO::getChannelCode, channelCode));
    }

    default List<ChannelDO> selectSimpleList(Integer status, String channelType, String containerMode) {
        LambdaQueryWrapperX<ChannelDO> wrapper = new LambdaQueryWrapperX<>();
        wrapper.eqIfPresent(ChannelDO::getStatus, status);
        wrapper.eqIfPresent(ChannelDO::getChannelType, channelType);
        wrapper.eqIfPresent(ChannelDO::getContainerMode, containerMode);
        return selectList(wrapper.orderByAsc(ChannelDO::getSortOrder).orderByAsc(ChannelDO::getPriority)
                .orderByAsc(ChannelDO::getChannelCode));
    }

}
