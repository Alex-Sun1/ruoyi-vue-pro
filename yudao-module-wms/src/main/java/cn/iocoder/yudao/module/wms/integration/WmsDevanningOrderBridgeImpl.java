package cn.iocoder.yudao.module.wms.integration;

import cn.iocoder.yudao.module.oms.api.devanning.WmsDevanningOrderBridge;
import cn.iocoder.yudao.module.oms.api.devanning.dto.OmsDevanningPushDTO;
import cn.iocoder.yudao.module.wms.controller.admin.devanningorder.vo.WmsDevanningOrderPushReqVO;
import cn.iocoder.yudao.module.wms.service.devanningorder.WmsDevanningOrderService;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.Date;

@Service
public class WmsDevanningOrderBridgeImpl implements WmsDevanningOrderBridge {

    @Resource
    private WmsDevanningOrderService devanningOrderService;

    @Override
    public Long pushFromOms(OmsDevanningPushDTO bo) {
        return devanningOrderService.pushFromOms(toPushBo(bo));
    }

    private WmsDevanningOrderPushReqVO toPushBo(OmsDevanningPushDTO bo) {
        WmsDevanningOrderPushReqVO push = new WmsDevanningOrderPushReqVO();
        push.setSourceOrderId(bo.getSourceOrderId());
        push.setSourceOrderNo(bo.getSourceOrderNo());
        push.setSourceOrderType("CONTAINER_ORDER");
        push.setBizRootId(bo.getBizRootId());
        push.setCompanyId(bo.getCompanyId());
        push.setContainerNo(bo.getContainerNo());
        push.setCustomerId(bo.getCustomerId());
        push.setCustomerName(bo.getCustomerName());
        push.setChannelId(bo.getChannelId());
        push.setChannelName(bo.getChannelName());
        push.setCustomerServiceId(bo.getCustomerServiceId());
        push.setCustomerServiceName(bo.getCustomerServiceName());
        push.setWarehouseId(bo.getWarehouseId());
        push.setEtaWarehouseTime(bo.getEtaWarehouseTime());
        push.setPickupTime(bo.getPickupTime());
        push.setTotalBoxQty(bo.getTotalBoxQty());
        push.setTotalWeight(bo.getTotalWeight());
        push.setTotalCbm(bo.getTotalCbm());
        return push;
    }

    @Override
    public void syncPickupFromOms(Long containerOrderId, Date pickupTime) {
        devanningOrderService.syncPickupFromOms(containerOrderId, pickupTime);
    }
}
