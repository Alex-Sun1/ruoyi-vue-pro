package cn.iocoder.yudao.module.base.dal.mysql.timezone;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.controller.admin.timezone.vo.TimezonePageReqVO;
import cn.iocoder.yudao.module.base.dal.dataobject.timezone.TimezoneDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface TimezoneMapper extends BaseMapperX<TimezoneDO> {

    default PageResult<TimezoneDO> selectPage(TimezonePageReqVO reqVO) {
        LambdaQueryWrapperX<TimezoneDO> wrapper = new LambdaQueryWrapperX<>();
        wrapper.and(StrUtil.isNotBlank(reqVO.getKeyword()), w -> w
                .like(TimezoneDO::getTzCode, reqVO.getKeyword())
                .or()
                .like(TimezoneDO::getNameEn, reqVO.getKeyword()));
        wrapper.eqIfPresent(TimezoneDO::getCountryCode, reqVO.getCountryCode());
        wrapper.eqIfPresent(TimezoneDO::getStatus, reqVO.getStatus());
        wrapper.orderByAsc(TimezoneDO::getSortOrder).orderByDesc(TimezoneDO::getId);
        return selectPage(reqVO, wrapper);
    }

    default TimezoneDO selectByUnique(String tzCode) {
        return selectOne(new LambdaQueryWrapperX<TimezoneDO>()
                .eq(TimezoneDO::getTzCode, tzCode));
    }

    default List<TimezoneDO> selectSimpleList(Integer status) {
        LambdaQueryWrapperX<TimezoneDO> wrapper = new LambdaQueryWrapperX<>();
        if (status != null) {
            wrapper.eq(TimezoneDO::getStatus, status);
        }
        return selectList(wrapper.orderByAsc(TimezoneDO::getSortOrder).orderByAsc(TimezoneDO::getId));
    }

}
