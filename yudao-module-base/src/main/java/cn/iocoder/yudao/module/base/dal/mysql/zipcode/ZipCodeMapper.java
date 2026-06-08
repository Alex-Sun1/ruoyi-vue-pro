package cn.iocoder.yudao.module.base.dal.mysql.zipcode;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.controller.admin.zipcode.vo.ZipCodePageReqVO;
import cn.iocoder.yudao.module.base.dal.dataobject.zipcode.ZipCodeDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ZipCodeMapper extends BaseMapperX<ZipCodeDO> {

    default PageResult<ZipCodeDO> selectPage(ZipCodePageReqVO reqVO) {
        LambdaQueryWrapperX<ZipCodeDO> wrapper = new LambdaQueryWrapperX<>();
        wrapper.like(StrUtil.isNotBlank(reqVO.getZip()), ZipCodeDO::getZip, reqVO.getZip());
        wrapper.eqIfPresent(ZipCodeDO::getCountryCode, reqVO.getCountryCode());
        wrapper.eqIfPresent(ZipCodeDO::getStateCode, reqVO.getStateCode());
        wrapper.orderByAsc(ZipCodeDO::getZip).orderByDesc(ZipCodeDO::getId);
        return selectPage(reqVO, wrapper);
    }

    default ZipCodeDO selectByUnique(String countryCode, String zip) {
        return selectOne(new LambdaQueryWrapperX<ZipCodeDO>()
                .eq(ZipCodeDO::getCountryCode, countryCode)
                .eq(ZipCodeDO::getZip, zip));
    }

    default ZipCodeDO selectByCountryAndZip(String countryCode, String zip) {
        return selectOne(new LambdaQueryWrapperX<ZipCodeDO>()
                .eq(ZipCodeDO::getCountryCode, countryCode)
                .eq(ZipCodeDO::getZip, zip)
                .last("LIMIT 1"));
    }

    default List<ZipCodeDO> selectSimpleList(String countryCode, String zip) {
        LambdaQueryWrapperX<ZipCodeDO> wrapper = new LambdaQueryWrapperX<>();
        wrapper.eqIfPresent(ZipCodeDO::getCountryCode, countryCode);
        wrapper.like(StrUtil.isNotBlank(zip), ZipCodeDO::getZip, zip);
        return selectList(wrapper.orderByAsc(ZipCodeDO::getZip).orderByAsc(ZipCodeDO::getId));
    }

    default Long selectCountByCountryAndState(String countryCode, String stateCode) {
        return selectCount(new LambdaQueryWrapperX<ZipCodeDO>()
                .eq(ZipCodeDO::getCountryCode, countryCode)
                .eq(ZipCodeDO::getStateCode, stateCode));
    }

    default Long selectCountByCountryStateAndCityName(String countryCode, String stateCode, String cityName) {
        return selectCount(new LambdaQueryWrapperX<ZipCodeDO>()
                .eq(ZipCodeDO::getCountryCode, countryCode)
                .eq(ZipCodeDO::getStateCode, stateCode)
                .eq(ZipCodeDO::getCityName, cityName));
    }

}
