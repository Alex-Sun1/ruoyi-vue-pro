package cn.iocoder.yudao.module.oms.api.devanning;

import java.math.BigDecimal;
import java.util.Date;

/**
 * WMS → OMS 拆柜执行结果回写（实现类在 ruoyi-oms 模块）。
 */
public interface OmsContainerDevanningSyncService {

    void assignDevanningOrderNo(Long containerOrderId, String devanningNo);

    void syncArrival(Long containerOrderId, Date actualArrivalTime);

    void syncPlannedDevanningTime(Long containerOrderId, Date plannedDevanningTime);

    void syncDevanningStart(Long containerOrderId, Date devanningStartTime);

    void syncDevanningFinish(Long containerOrderId, Date devanningFinishTime, BigDecimal actualBoxQty);

    void syncCancel(Long containerOrderId, String reason);
}
