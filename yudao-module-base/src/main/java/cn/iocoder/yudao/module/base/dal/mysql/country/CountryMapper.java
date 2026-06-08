package cn.iocoder.yudao.module.base.dal.mysql.country;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.controller.admin.country.vo.CountryPageReqVO;
import cn.iocoder.yudao.module.base.dal.dataobject.country.CountryDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface CountryMapper extends BaseMapperX<CountryDO> {

    default PageResult<CountryDO> selectPage(CountryPageReqVO reqVO) {
        LambdaQueryWrapperX<CountryDO> wrapper = new LambdaQueryWrapperX<>();
        wrapper.and(StrUtil.isNotBlank(reqVO.getKeyword()), w -> w
                .like(CountryDO::getCode, reqVO.getKeyword())
                .or()
                .like(CountryDO::getNameEn, reqVO.getKeyword()));
        wrapper.eqIfPresent(CountryDO::getIsActive, reqVO.getIsActive());
        wrapper.orderByAsc(CountryDO::getSortOrder).orderByDesc(CountryDO::getId);
        return selectPage(reqVO, wrapper);
    }

    default CountryDO selectByUnique(String code) {
        return selectOne(new LambdaQueryWrapperX<CountryDO>()
                .eq(CountryDO::getCode, code));
    }

    default List<CountryDO> selectSimpleList(Integer isActive) {
        LambdaQueryWrapperX<CountryDO> wrapper = new LambdaQueryWrapperX<>();
        if (isActive != null) {
            wrapper.eq(CountryDO::getIsActive, isActive);
        }
        return selectList(wrapper.orderByAsc(CountryDO::getSortOrder).orderByAsc(CountryDO::getId));
    }

    default Long selectCountByTimezoneDefault(String timezoneDefault) {
        return selectCount(new LambdaQueryWrapperX<CountryDO>()
                .eq(CountryDO::getTimezoneDefault, timezoneDefault));
    }

    default Long selectCountByCurrencyCode(String currencyCode) {
        return selectCount(new LambdaQueryWrapperX<CountryDO>()
                .eq(CountryDO::getCurrencyCode, currencyCode));
    }

}
