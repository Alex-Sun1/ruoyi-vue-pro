package cn.iocoder.yudao.module.oms.support;

import cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder.CargoOrderDO;

import java.math.BigDecimal;
import java.util.List;

public final class OutboundReadinessUtils {

    public static final String NOT_INBOUNDED = "NOT_INBOUNDED";
    public static final String DEVANNING = "DEVANNING";
    public static final String INBOUNDED = "INBOUNDED";

    private OutboundReadinessUtils() {
    }

    public static String resolveReadiness(CargoOrderDO order) {
        if (order == null) {
            return NOT_INBOUNDED;
        }
        if ("INBOUNDED".equals(order.getFulfillmentStatus())
            && nvl(order.getActualCartonQty()).compareTo(nvl(order.getDeclaredCartonQty())) >= 0) {
            return INBOUNDED;
        }
        if (List.of("DEVANNING", "DEVANNED").contains(order.getFulfillmentStatus())) {
            return DEVANNING;
        }
        return NOT_INBOUNDED;
    }

    public static String resolvePreOutboundStatus(CargoOrderDO order) {
        String readiness = resolveReadiness(order);
        if (INBOUNDED.equals(readiness)) {
            return "READY_TO_CONVERT";
        }
        if (DEVANNING.equals(readiness)) {
            return "DEVANNING";
        }
        return "PENDING_INBOUND";
    }

    public static String resolveGroupPreOutboundStatus(List<String> readinessList) {
        if (readinessList == null || readinessList.isEmpty()) {
            return "PENDING_INBOUND";
        }
        boolean allInbounded = readinessList.stream().allMatch(INBOUNDED::equals);
        if (allInbounded) {
            return "READY_TO_CONVERT";
        }
        if (readinessList.stream().anyMatch(DEVANNING::equals)) {
            return "DEVANNING";
        }
        return "PENDING_INBOUND";
    }

    private static BigDecimal nvl(BigDecimal value) {
        return value == null ? BigDecimal.ZERO : value;
    }
}
