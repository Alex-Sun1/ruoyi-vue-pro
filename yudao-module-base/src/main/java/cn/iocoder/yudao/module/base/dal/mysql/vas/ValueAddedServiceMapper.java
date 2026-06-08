package cn.iocoder.yudao.module.base.dal.mysql.vas;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.controller.admin.vas.vo.ValueAddedServicePageReqVO;
import cn.iocoder.yudao.module.base.dal.dataobject.vas.ValueAddedServiceDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ValueAddedServiceMapper extends BaseMapperX<ValueAddedServiceDO> {

    default PageResult<ValueAddedServiceDO> selectPage(ValueAddedServicePageReqVO reqVO) {
        LambdaQueryWrapperX<ValueAddedServiceDO> wrapper = new LambdaQueryWrapperX<>();
        wrapper.and(StrUtil.isNotBlank(reqVO.getKeyword()), w -> w
                .like(ValueAddedServiceDO::getServiceCode, reqVO.getKeyword())
                .or()
                .like(ValueAddedServiceDO::getServiceName, reqVO.getKeyword()));
        wrapper.eqIfPresent(ValueAddedServiceDO::getServiceCategory, reqVO.getServiceCategory());
        wrapper.eqIfPresent(ValueAddedServiceDO::getStatus, reqVO.getStatus());
        wrapper.orderByAsc(ValueAddedServiceDO::getSortOrder).orderByAsc(ValueAddedServiceDO::getPriority)
                .orderByAsc(ValueAddedServiceDO::getServiceCode);
        return selectPage(reqVO, wrapper);
    }

    default ValueAddedServiceDO selectByUnique(String serviceCode) {
        return selectOne(new LambdaQueryWrapperX<ValueAddedServiceDO>().eq(ValueAddedServiceDO::getServiceCode, serviceCode));
    }

    default List<ValueAddedServiceDO> selectSimpleList(Integer status, String serviceCategory) {
        LambdaQueryWrapperX<ValueAddedServiceDO> wrapper = new LambdaQueryWrapperX<>();
        wrapper.eqIfPresent(ValueAddedServiceDO::getStatus, status);
        wrapper.eqIfPresent(ValueAddedServiceDO::getServiceCategory, serviceCategory);
        return selectList(wrapper.orderByAsc(ValueAddedServiceDO::getSortOrder)
                .orderByAsc(ValueAddedServiceDO::getPriority).orderByAsc(ValueAddedServiceDO::getServiceCode));
    }

}
