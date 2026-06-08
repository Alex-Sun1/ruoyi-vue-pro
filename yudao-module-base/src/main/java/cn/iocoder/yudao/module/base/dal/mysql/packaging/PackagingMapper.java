package cn.iocoder.yudao.module.base.dal.mysql.packaging;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.controller.admin.packaging.vo.PackagingPageReqVO;
import cn.iocoder.yudao.module.base.dal.dataobject.packaging.PackagingDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.Collection;
import java.util.List;

@Mapper
public interface PackagingMapper extends BaseMapperX<PackagingDO> {

    default PageResult<PackagingDO> selectPage(PackagingPageReqVO reqVO) {
        LambdaQueryWrapperX<PackagingDO> wrapper = new LambdaQueryWrapperX<>();
        wrapper.and(StrUtil.isNotBlank(reqVO.getKeyword()), w -> w
                .like(PackagingDO::getPkgCode, reqVO.getKeyword())
                .or()
                .like(PackagingDO::getPkgName, reqVO.getKeyword()));
        wrapper.eqIfPresent(PackagingDO::getPkgType, reqVO.getPkgType());
        wrapper.eqIfPresent(PackagingDO::getStatus, reqVO.getStatus());
        wrapper.orderByAsc(PackagingDO::getSortOrder).orderByDesc(PackagingDO::getId);
        return selectPage(reqVO, wrapper);
    }

    default PackagingDO selectByUnique(String pkgCode) {
        return selectOne(new LambdaQueryWrapperX<PackagingDO>()
                .eq(PackagingDO::getPkgCode, pkgCode));
    }

    default List<PackagingDO> selectSimpleList(Integer status) {
        LambdaQueryWrapperX<PackagingDO> wrapper = new LambdaQueryWrapperX<>();
        if (status != null) {
            wrapper.eq(PackagingDO::getStatus, status);
        }
        return selectList(wrapper.orderByAsc(PackagingDO::getSortOrder).orderByAsc(PackagingDO::getPkgCode));
    }

    default List<PackagingDO> selectListByIds(Collection<Long> ids) {
        return selectList(new LambdaQueryWrapperX<PackagingDO>().in(PackagingDO::getId, ids));
    }

}
