package cn.iocoder.yudao.module.base.dal.mysql.port;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.controller.admin.port.vo.PortPageReqVO;
import cn.iocoder.yudao.module.base.dal.dataobject.port.PortDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface PortMapper extends BaseMapperX<PortDO> {

    default PageResult<PortDO> selectPage(PortPageReqVO reqVO) {
        LambdaQueryWrapperX<PortDO> wrapper = new LambdaQueryWrapperX<>();
        wrapper.and(StrUtil.isNotBlank(reqVO.getKeyword()), w -> w
                .like(PortDO::getPortCode, reqVO.getKeyword())
                .or()
                .like(PortDO::getNameEn, reqVO.getKeyword()));
        wrapper.eqIfPresent(PortDO::getCountryCode, reqVO.getCountryCode());
        wrapper.eqIfPresent(PortDO::getPortType, reqVO.getPortType());
        wrapper.eqIfPresent(PortDO::getStatus, reqVO.getStatus());
        wrapper.orderByDesc(PortDO::getId);
        return selectPage(reqVO, wrapper);
    }

    default PortDO selectByUnique(String portCode) {
        return selectOne(new LambdaQueryWrapperX<PortDO>()
                .eq(PortDO::getPortCode, portCode));
    }

    default List<PortDO> selectSimpleList(Integer status) {
        LambdaQueryWrapperX<PortDO> wrapper = new LambdaQueryWrapperX<>();
        if (status != null) {
            wrapper.eq(PortDO::getStatus, status);
        }
        return selectList(wrapper.orderByAsc(PortDO::getPortCode));
    }

    default Long selectCountByTimezone(String timezone) {
        return selectCount(new LambdaQueryWrapperX<PortDO>()
                .eq(PortDO::getTimezone, timezone));
    }

}
