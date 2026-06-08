package cn.iocoder.yudao.module.base.dal.mysql.shippingline;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.controller.admin.shippingline.vo.ShippingLinePageReqVO;
import cn.iocoder.yudao.module.base.dal.dataobject.shippingline.ShippingLineDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ShippingLineMapper extends BaseMapperX<ShippingLineDO> {

    default PageResult<ShippingLineDO> selectPage(ShippingLinePageReqVO reqVO) {
        LambdaQueryWrapperX<ShippingLineDO> wrapper = new LambdaQueryWrapperX<>();
        wrapper.and(StrUtil.isNotBlank(reqVO.getKeyword()), w -> w
                .like(ShippingLineDO::getCode, reqVO.getKeyword())
                .or()
                .like(ShippingLineDO::getNameEn, reqVO.getKeyword())
                .or()
                .like(ShippingLineDO::getNameAbbr, reqVO.getKeyword()));
        wrapper.eqIfPresent(ShippingLineDO::getCountryCode, reqVO.getCountryCode());
        wrapper.eqIfPresent(ShippingLineDO::getStatus, reqVO.getStatus());
        wrapper.orderByDesc(ShippingLineDO::getId);
        return selectPage(reqVO, wrapper);
    }

    default ShippingLineDO selectByUnique(String code) {
        return selectOne(new LambdaQueryWrapperX<ShippingLineDO>()
                .eq(ShippingLineDO::getCode, code));
    }

    default List<ShippingLineDO> selectSimpleList(Integer status) {
        LambdaQueryWrapperX<ShippingLineDO> wrapper = new LambdaQueryWrapperX<>();
        if (status != null) {
            wrapper.eq(ShippingLineDO::getStatus, status);
        }
        return selectList(wrapper.orderByAsc(ShippingLineDO::getCode));
    }

}
