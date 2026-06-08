package cn.iocoder.yudao.module.base.dal.mysql.saleschannel;

import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.dal.dataobject.saleschannel.BaseSalesChannelDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface BaseSalesChannelMapper extends BaseMapperX<BaseSalesChannelDO> {

    default List<BaseSalesChannelDO> selectSimpleList(Integer status) {
        return selectList(new LambdaQueryWrapperX<BaseSalesChannelDO>()
                .eqIfPresent(BaseSalesChannelDO::getStatus, status)
                .orderByAsc(BaseSalesChannelDO::getId));
    }

}
