package cn.iocoder.yudao.module.oms.api.devanning;

import cn.iocoder.yudao.module.oms.api.devanning.dto.OmsDevanningPushDTO;

import java.util.Date;

/**
 * OMS → WMS 拆柜订单桥接（实现类在 ruoyi-wms 模块）。
 */
public interface WmsDevanningOrderBridge {

    /**
     * OMS 推单创建/更新 WMS 拆柜工单（幂等）。
     */
    Long pushFromOms(OmsDevanningPushDTO bo);

    /**
     * OMS 提柜后同步 WMS 状态与提柜时间。
     */
    void syncPickupFromOms(Long containerOrderId, Date pickupTime);
}
