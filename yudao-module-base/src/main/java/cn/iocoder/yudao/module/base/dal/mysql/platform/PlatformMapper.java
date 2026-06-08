package cn.iocoder.yudao.module.base.dal.mysql.platform;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.controller.admin.platform.vo.PlatformPageReqVO;
import cn.iocoder.yudao.module.base.dal.dataobject.platform.PlatformDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface PlatformMapper extends BaseMapperX<PlatformDO> {

    default PageResult<PlatformDO> selectPage(PlatformPageReqVO reqVO) {
        LambdaQueryWrapperX<PlatformDO> wrapper = new LambdaQueryWrapperX<>();
        wrapper.and(StrUtil.isNotBlank(reqVO.getKeyword()), w -> w
                .like(PlatformDO::getCode, reqVO.getKeyword())
                .or()
                .like(PlatformDO::getNameEn, reqVO.getKeyword()));
        wrapper.eqIfPresent(PlatformDO::getTypeCode, reqVO.getTypeCode());
        wrapper.eqIfPresent(PlatformDO::getStatus, reqVO.getStatus());
        wrapper.orderByAsc(PlatformDO::getSortOrder).orderByDesc(PlatformDO::getId);
        return selectPage(reqVO, wrapper);
    }

    default PlatformDO selectByUnique(String code) {
        return selectOne(new LambdaQueryWrapperX<PlatformDO>()
                .eq(PlatformDO::getCode, code));
    }

    default List<PlatformDO> selectSimpleList(Integer status) {
        LambdaQueryWrapperX<PlatformDO> wrapper = new LambdaQueryWrapperX<>();
        if (status != null) {
            wrapper.eq(PlatformDO::getStatus, status);
        }
        return selectList(wrapper.orderByAsc(PlatformDO::getSortOrder).orderByAsc(PlatformDO::getId));
    }

}
