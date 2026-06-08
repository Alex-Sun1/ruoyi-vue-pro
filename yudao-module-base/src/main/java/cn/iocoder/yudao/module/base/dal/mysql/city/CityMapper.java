package cn.iocoder.yudao.module.base.dal.mysql.city;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.controller.admin.city.vo.CityPageReqVO;
import cn.iocoder.yudao.module.base.dal.dataobject.city.CityDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface CityMapper extends BaseMapperX<CityDO> {

    default PageResult<CityDO> selectPage(CityPageReqVO reqVO) {
        LambdaQueryWrapperX<CityDO> wrapper = new LambdaQueryWrapperX<>();
        wrapper.like(StrUtil.isNotBlank(reqVO.getKeyword()), CityDO::getNameEn, reqVO.getKeyword());
        wrapper.eqIfPresent(CityDO::getCountryCode, reqVO.getCountryCode());
        wrapper.eqIfPresent(CityDO::getStateCode, reqVO.getStateCode());
        wrapper.eqIfPresent(CityDO::getStatus, reqVO.getStatus());
        wrapper.orderByAsc(CityDO::getId);
        return selectPage(reqVO, wrapper);
    }

    default CityDO selectByUnique(String countryCode, String stateCode, String nameEn) {
        return selectOne(new LambdaQueryWrapperX<CityDO>()
                .eq(CityDO::getCountryCode, countryCode)
                .eq(CityDO::getStateCode, stateCode)
                .eq(CityDO::getNameEn, nameEn));
    }

    default List<CityDO> selectSimpleList(String countryCode, String stateCode, Integer status) {
        LambdaQueryWrapperX<CityDO> wrapper = new LambdaQueryWrapperX<>();
        wrapper.eqIfPresent(CityDO::getCountryCode, countryCode);
        wrapper.eqIfPresent(CityDO::getStateCode, stateCode);
        if (status != null) {
            wrapper.eq(CityDO::getStatus, status);
        }
        return selectList(wrapper.orderByAsc(CityDO::getNameEn).orderByAsc(CityDO::getId));
    }

    default Long selectCountByCountryAndState(String countryCode, String stateCode) {
        return selectCount(new LambdaQueryWrapperX<CityDO>()
                .eq(CityDO::getCountryCode, countryCode)
                .eq(CityDO::getStateCode, stateCode));
    }

}
