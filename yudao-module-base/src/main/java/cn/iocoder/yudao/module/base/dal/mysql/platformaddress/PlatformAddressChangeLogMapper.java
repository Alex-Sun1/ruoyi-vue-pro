package cn.iocoder.yudao.module.base.dal.mysql.platformaddress;

import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.dal.dataobject.platformaddress.PlatformAddressChangeLogDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface PlatformAddressChangeLogMapper extends BaseMapperX<PlatformAddressChangeLogDO> {

    default List<PlatformAddressChangeLogDO> selectListByPlatformAddressId(Long platformAddressId) {
        return selectList(new LambdaQueryWrapperX<PlatformAddressChangeLogDO>()
                .eq(PlatformAddressChangeLogDO::getPlatformAddressId, platformAddressId)
                .orderByDesc(PlatformAddressChangeLogDO::getCreateTime)
                .orderByDesc(PlatformAddressChangeLogDO::getId));
    }

}
