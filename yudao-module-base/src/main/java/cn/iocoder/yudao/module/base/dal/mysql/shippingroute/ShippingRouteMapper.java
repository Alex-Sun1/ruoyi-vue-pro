package cn.iocoder.yudao.module.base.dal.mysql.shippingroute;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.controller.admin.shippingroute.vo.ShippingRoutePageReqVO;
import cn.iocoder.yudao.module.base.dal.dataobject.shippingroute.ShippingRouteDO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ShippingRouteMapper extends BaseMapperX<ShippingRouteDO> {

    default PageResult<ShippingRouteDO> selectPage(ShippingRoutePageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<ShippingRouteDO>()
                .likeIfPresent(ShippingRouteDO::getRouteCode, reqVO.getRouteCode())
                .likeIfPresent(ShippingRouteDO::getRouteName, reqVO.getRouteName())
                .eqIfPresent(ShippingRouteDO::getShippingLineId, reqVO.getShippingLineId())
                .eqIfPresent(ShippingRouteDO::getOriginPortId, reqVO.getOriginPortId())
                .eqIfPresent(ShippingRouteDO::getDestinationPortId, reqVO.getDestinationPortId())
                .eqIfPresent(ShippingRouteDO::getStatus, reqVO.getStatus())
                .orderByAsc(ShippingRouteDO::getShippingLineCode, ShippingRouteDO::getRouteCode));
    }

    default ShippingRouteDO selectByUnique(String routeCode) {
        return selectOne(ShippingRouteDO::getRouteCode, routeCode);
    }

    default PageResult<ShippingRouteDO> selectExportPage(ShippingRoutePageReqVO reqVO) {
        if (StrUtil.isNotBlank(reqVO.getRouteCode())) {
            reqVO.setRouteCode(reqVO.getRouteCode().trim());
        }
        return selectPage(reqVO);
    }

}
