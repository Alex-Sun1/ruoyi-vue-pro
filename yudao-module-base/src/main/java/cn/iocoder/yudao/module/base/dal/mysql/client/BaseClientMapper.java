package cn.iocoder.yudao.module.base.dal.mysql.client;

import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.dal.dataobject.client.ClientDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.Collection;
import java.util.List;

/**
 * 海外仓基础资料-客户 Mapper。
 * 勿命名为 ClientMapper：Bean 名 clientMapper 与 MES {@code MesMdClientMapper} 注入字段冲突。
 */
@Mapper
public interface BaseClientMapper extends BaseMapperX<ClientDO> {

    default List<ClientDO> selectSimpleList(Integer status) {
        LambdaQueryWrapperX<ClientDO> wrapper = new LambdaQueryWrapperX<>();
        if (status != null) {
            wrapper.eq(ClientDO::getStatus, status);
        }
        return selectList(wrapper.orderByAsc(ClientDO::getClientCode));
    }

    default List<ClientDO> selectListByIds(Collection<Long> ids) {
        return selectList(new LambdaQueryWrapperX<ClientDO>().in(ClientDO::getId, ids));
    }

}
