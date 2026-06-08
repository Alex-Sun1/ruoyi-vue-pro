package cn.iocoder.yudao.module.base.dal.mysql.currency;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.controller.admin.currency.vo.CurrencyPageReqVO;
import cn.iocoder.yudao.module.base.dal.dataobject.currency.CurrencyDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface CurrencyMapper extends BaseMapperX<CurrencyDO> {

    default PageResult<CurrencyDO> selectPage(CurrencyPageReqVO reqVO) {
        LambdaQueryWrapperX<CurrencyDO> wrapper = new LambdaQueryWrapperX<>();
        wrapper.and(StrUtil.isNotBlank(reqVO.getKeyword()), w -> w
                .like(CurrencyDO::getCode, reqVO.getKeyword())
                .or()
                .like(CurrencyDO::getNameEn, reqVO.getKeyword()));
        wrapper.eqIfPresent(CurrencyDO::getStatus, reqVO.getStatus());
        wrapper.orderByDesc(CurrencyDO::getIsBase).orderByAsc(CurrencyDO::getSortOrder).orderByDesc(CurrencyDO::getId);
        return selectPage(reqVO, wrapper);
    }

    default CurrencyDO selectByUnique(String code) {
        return selectOne(new LambdaQueryWrapperX<CurrencyDO>()
                .eq(CurrencyDO::getCode, code));
    }

    default List<CurrencyDO> selectSimpleList(Integer status) {
        LambdaQueryWrapperX<CurrencyDO> wrapper = new LambdaQueryWrapperX<>();
        if (status != null) {
            wrapper.eq(CurrencyDO::getStatus, status);
        }
        return selectList(wrapper.orderByDesc(CurrencyDO::getIsBase).orderByAsc(CurrencyDO::getSortOrder).orderByAsc(CurrencyDO::getId));
    }

}
