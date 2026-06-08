package cn.iocoder.yudao.module.base.dal.mysql.state;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.controller.admin.state.vo.StateProvincePageReqVO;
import cn.iocoder.yudao.module.base.dal.dataobject.state.StateProvinceDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface StateProvinceMapper extends BaseMapperX<StateProvinceDO> {

    default PageResult<StateProvinceDO> selectPage(StateProvincePageReqVO reqVO) {
        LambdaQueryWrapperX<StateProvinceDO> wrapper = new LambdaQueryWrapperX<>();
        wrapper.and(StrUtil.isNotBlank(reqVO.getKeyword()), w -> w
                .like(StateProvinceDO::getCode, reqVO.getKeyword())
                .or()
                .like(StateProvinceDO::getNameEn, reqVO.getKeyword()));
        wrapper.eqIfPresent(StateProvinceDO::getCountryCode, reqVO.getCountryCode());
        wrapper.eqIfPresent(StateProvinceDO::getStatus, reqVO.getStatus());
        wrapper.orderByAsc(StateProvinceDO::getSortOrder).orderByDesc(StateProvinceDO::getId);
        return selectPage(reqVO, wrapper);
    }

    default StateProvinceDO selectByUnique(String countryCode, String code) {
        return selectOne(new LambdaQueryWrapperX<StateProvinceDO>()
                .eq(StateProvinceDO::getCountryCode, countryCode)
                .eq(StateProvinceDO::getCode, code));
    }

    default List<StateProvinceDO> selectSimpleList(String countryCode, Integer status) {
        LambdaQueryWrapperX<StateProvinceDO> wrapper = new LambdaQueryWrapperX<>();
        wrapper.eqIfPresent(StateProvinceDO::getCountryCode, countryCode);
        if (status != null) {
            wrapper.eq(StateProvinceDO::getStatus, status);
        }
        return selectList(wrapper.orderByAsc(StateProvinceDO::getSortOrder).orderByAsc(StateProvinceDO::getId));
    }

    default Long selectCountByCountryCode(String countryCode) {
        return selectCount(StateProvinceDO::getCountryCode, countryCode);
    }

}
