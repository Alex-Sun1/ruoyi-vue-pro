package cn.iocoder.yudao.module.base.dal.mysql.platformaddress;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.controller.admin.platformaddress.vo.PlatformAddressPageReqVO;
import cn.iocoder.yudao.module.base.dal.dataobject.platformaddress.PlatformAddressDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface PlatformAddressMapper extends BaseMapperX<PlatformAddressDO> {

    default PageResult<PlatformAddressDO> selectPage(PlatformAddressPageReqVO reqVO) {
        LambdaQueryWrapperX<PlatformAddressDO> wrapper = new LambdaQueryWrapperX<>();
        wrapper.and(StrUtil.isNotBlank(reqVO.getKeyword()), w -> w
                .like(PlatformAddressDO::getAddressCode, reqVO.getKeyword())
                .or()
                .like(PlatformAddressDO::getNameEn, reqVO.getKeyword()));
        wrapper.eqIfPresent(PlatformAddressDO::getPlatformId, reqVO.getPlatformId());
        wrapper.eqIfPresent(PlatformAddressDO::getCountryCode, reqVO.getCountryCode());
        wrapper.eqIfPresent(PlatformAddressDO::getStateCode, reqVO.getStateCode());
        wrapper.eqIfPresent(PlatformAddressDO::getAddressType, reqVO.getAddressType());
        wrapper.eqIfPresent(PlatformAddressDO::getStatus, reqVO.getStatus());
        wrapper.orderByDesc(PlatformAddressDO::getId);
        return selectPage(reqVO, wrapper);
    }

    default PlatformAddressDO selectByUnique(Long platformId, String addressCode) {
        return selectOne(new LambdaQueryWrapperX<PlatformAddressDO>()
                .eq(PlatformAddressDO::getPlatformId, platformId)
                .eq(PlatformAddressDO::getAddressCode, addressCode));
    }

    default List<PlatformAddressDO> selectSimpleList() {
        return selectSimpleList(null, cn.iocoder.yudao.framework.common.enums.CommonStatusEnum.ENABLE.getStatus());
    }

    default List<PlatformAddressDO> selectSimpleList(Long platformId, Integer status) {
        LambdaQueryWrapperX<PlatformAddressDO> w = new LambdaQueryWrapperX<>();
        w.eqIfPresent(PlatformAddressDO::getPlatformId, platformId);
        w.eqIfPresent(PlatformAddressDO::getStatus, status);
        return selectList(w.orderByAsc(PlatformAddressDO::getAddressCode).orderByAsc(PlatformAddressDO::getId));
    }

    default Long selectCountByCountryStateAndCity(String countryCode, String stateCode, String city) {
        return selectCount(new LambdaQueryWrapperX<PlatformAddressDO>()
                .eq(PlatformAddressDO::getCountryCode, countryCode)
                .eq(PlatformAddressDO::getStateCode, stateCode)
                .eq(PlatformAddressDO::getCity, city));
    }

    default Long selectCountByCountryAndZipCode(String countryCode, String zipCode) {
        return selectCount(new LambdaQueryWrapperX<PlatformAddressDO>()
                .eq(PlatformAddressDO::getCountryCode, countryCode)
                .eq(PlatformAddressDO::getZipCode, zipCode));
    }

    default Long selectCountByPlatformId(Long platformId) {
        return selectCount(PlatformAddressDO::getPlatformId, platformId);
    }

}
