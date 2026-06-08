package cn.iocoder.yudao.module.base.dal.mysql.company;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.controller.admin.company.vo.CompanyPageReqVO;
import cn.iocoder.yudao.module.base.dal.dataobject.company.CompanyDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.Collection;
import java.util.List;

@Mapper
public interface CompanyMapper extends BaseMapperX<CompanyDO> {

    default PageResult<CompanyDO> selectPage(CompanyPageReqVO reqVO) {
        LambdaQueryWrapperX<CompanyDO> wrapper = new LambdaQueryWrapperX<>();
        wrapper.and(StrUtil.isNotBlank(reqVO.getKeyword()), w -> w
                .like(CompanyDO::getCompanyCode, reqVO.getKeyword())
                .or()
                .like(CompanyDO::getCompanyName, reqVO.getKeyword()));
        wrapper.eqIfPresent(CompanyDO::getStatus, reqVO.getStatus());
        wrapper.eqIfPresent(CompanyDO::getCountryCode, reqVO.getCountryCode());
        wrapper.eqIfPresent(CompanyDO::getCurrencyCode, reqVO.getCurrencyCode());
        wrapper.eqIfPresent(CompanyDO::getTimezone, reqVO.getTimezone());
        wrapper.orderByAsc(CompanyDO::getSort).orderByDesc(CompanyDO::getId);
        return selectPage(reqVO, wrapper);
    }

    default CompanyDO selectByUnique(String companyCode) {
        return selectOne(new LambdaQueryWrapperX<CompanyDO>()
                .eq(CompanyDO::getCompanyCode, companyCode));
    }

    default List<CompanyDO> selectSimpleList(Integer status) {
        LambdaQueryWrapperX<CompanyDO> wrapper = new LambdaQueryWrapperX<>();
        if (status != null) {
            wrapper.eq(CompanyDO::getStatus, status);
        }
        return selectList(wrapper.orderByAsc(CompanyDO::getSort).orderByAsc(CompanyDO::getCompanyCode));
    }

    default List<CompanyDO> selectListByIds(Collection<Long> ids) {
        return selectList(new LambdaQueryWrapperX<CompanyDO>().in(CompanyDO::getId, ids));
    }

}
