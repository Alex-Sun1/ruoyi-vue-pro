package cn.iocoder.yudao.module.base.service.shippingroute;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.controller.admin.shippingroute.vo.*;

import java.util.List;

public interface ShippingRouteService {

    Long createShippingRoute(ShippingRouteSaveReqVO createReqVO);

    void updateShippingRoute(ShippingRouteSaveReqVO updateReqVO);

    void deleteShippingRoute(Long id);

    ShippingRouteRespVO getShippingRoute(Long id);

    PageResult<ShippingRouteRespVO> getShippingRoutePage(ShippingRoutePageReqVO pageReqVO);

    List<ShippingRouteRespVO> getShippingRouteExportList(ShippingRoutePageReqVO pageReqVO);

    /** 下拉精简列表（默认仅启用） */
    List<ShippingRouteRespVO> getShippingRouteSimpleList(Integer status);

}
