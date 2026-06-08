package cn.iocoder.yudao.module.base.service.shippingline;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.controller.admin.shippingline.vo.*;

import java.util.List;

public interface ShippingLineService {

    Long createShippingLine(ShippingLineSaveReqVO createReqVO);

    void updateShippingLine(ShippingLineSaveReqVO updateReqVO);

    void updateShippingLineStatus(ShippingLineUpdateStatusReqVO reqVO);

    ShippingLineRespVO getShippingLine(Long id);

    PageResult<ShippingLineRespVO> getShippingLinePage(ShippingLinePageReqVO pageReqVO);

    List<ShippingLineRespVO> getShippingLineSimpleList(Integer status);

}
