package cn.iocoder.yudao.module.wms.service.devanningorder;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.wms.controller.admin.devanningorder.vo.*;

import java.util.Date;
import java.util.List;

public interface WmsDevanningOrderService {

    PageResult<WmsDevanningOrderRespVO> getDevanningOrderPage(WmsDevanningOrderPageReqVO pageReqVO);

    List<WmsDevanningOrderRespVO> getDevanningOrderList(WmsDevanningOrderPageReqVO pageReqVO);

    WmsDevanningOrderRespVO getDevanningOrder(Long id);

    Long createDevanningOrder(WmsDevanningOrderSaveReqVO createReqVO);

    void updateDevanningOrder(WmsDevanningOrderSaveReqVO updateReqVO);

    void deleteDevanningOrderList(List<Long> ids);

    Long pushFromOms(WmsDevanningOrderPushReqVO reqVO);

    void syncPickupFromOms(Long containerOrderId, Date pickupTime);

    void syncDock(WmsDevanningOrderSyncDockReqVO reqVO);

    void confirmPickup(Long id, WmsDevanningOrderActionReqVO reqVO);

    void confirmArrival(Long id, WmsDevanningOrderActionReqVO reqVO);

    void startDevanning(Long id, WmsDevanningOrderActionReqVO reqVO);

    void completeDevanning(Long id, WmsDevanningOrderActionReqVO reqVO);

    void markException(Long id, WmsDevanningOrderActionReqVO reqVO);

    void clearException(Long id, WmsDevanningOrderActionReqVO reqVO);

    void cancel(Long id, WmsDevanningOrderActionReqVO reqVO);

}
