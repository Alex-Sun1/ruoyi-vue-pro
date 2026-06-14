package cn.iocoder.yudao.module.oms.support;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil;
import cn.iocoder.yudao.module.oms.enums.ErrorCodeConstants;

import java.util.List;
import java.util.Map;
import java.util.Set;

public final class OmsStatusTransitionGuard {

    public static final List<String> CONTAINER_FLOW = List.of(
        "DRAFT", "PENDING_ACCEPT", "IN_TRANSIT", "ARRIVED_PORT",
        "AVAILABLE_FOR_PICKUP", "PICKUP_APPOINTED", "PICKED_UP",
        "ARRIVED_WAREHOUSE", "DEVANNING", "DEVANNED", "EMPTY_RETURNED", "COMPLETED"
    );

    public static final List<String> CARGO_FLOW = List.of(
        "PENDING_ACCEPT", "ACCEPTED", "IN_TRANSIT", "ARRIVED_PORT", "PICKED_UP",
        "ARRIVED_WAREHOUSE", "DEVANNING", "DEVANNED", "INBOUNDED",
        "OUTBOUND_ORDERED", "DELIVERY_APPOINTED", "OUTBOUNDED", "DELIVERING",
        "DELIVERED", "POD_UPLOADED", "BILLED", "COMPLETED"
    );

    public static final Map<String, Set<String>> CARGO_ALLOWED = Map.ofEntries(
        Map.entry("PENDING_ACCEPT", Set.of("ACCEPTED", "CANCELLED")),
        Map.entry("ACCEPTED", Set.of("IN_TRANSIT", "CANCELLED")),
        Map.entry("IN_TRANSIT", Set.of("ARRIVED_PORT", "CANCELLED")),
        Map.entry("ARRIVED_PORT", Set.of("PICKED_UP", "CANCELLED")),
        Map.entry("PICKED_UP", Set.of("ARRIVED_WAREHOUSE", "CANCELLED")),
        Map.entry("ARRIVED_WAREHOUSE", Set.of("DEVANNING", "CANCELLED")),
        Map.entry("DEVANNING", Set.of("DEVANNED", "CANCELLED")),
        Map.entry("DEVANNED", Set.of("INBOUNDED", "CANCELLED")),
        Map.entry("INBOUNDED", Set.of("OUTBOUND_ORDERED", "CANCELLED")),
        Map.entry("OUTBOUND_ORDERED", Set.of("DELIVERY_APPOINTED", "OUTBOUNDED", "CANCELLED")),
        Map.entry("DELIVERY_APPOINTED", Set.of("OUTBOUNDED", "CANCELLED")),
        Map.entry("OUTBOUNDED", Set.of("DELIVERING")),
        Map.entry("DELIVERING", Set.of("DELIVERED")),
        Map.entry("DELIVERED", Set.of("POD_UPLOADED")),
        Map.entry("POD_UPLOADED", Set.of("BILLED")),
        Map.entry("BILLED", Set.of("COMPLETED"))
    );

    public static final List<String> PRE_OUTBOUND_FLOW = List.of(
        "PENDING_INBOUND", "PRE_CREATED", "READY_TO_CONVERT", "CONVERTED"
    );

    public static final List<String> OUTBOUND_FLOW = List.of(
        "CREATED", "APPOINTMENT_CONFIRMED", "OUTBOUNDED", "SIGNED", "POD_UPLOADED", "COMPLETED"
    );

    public static void requireKnown(String bizName, List<String> flow, String target) {
        if (flow.contains(target) || "CANCELLED".equals(target)) {
            return;
        }
        throw ServiceExceptionUtil.exception(ErrorCodeConstants.OMS_BIZ_ERROR,
            bizName + " status is not supported: " + target);
    }

    private OmsStatusTransitionGuard() {
    }

    public static void requireForward(String bizName, List<String> flow, String current, String target) {
        if (StrUtil.equals(current, target)) {
            return;
        }
        int currentIndex = flow.indexOf(current);
        int targetIndex = flow.indexOf(target);
        if (currentIndex < 0 || targetIndex < 0) {
            throw ServiceExceptionUtil.exception(ErrorCodeConstants.OMS_BIZ_ERROR,
                bizName + " status is not supported: " + current + " -> " + target);
        }
        if (targetIndex <= currentIndex) {
            throw ServiceExceptionUtil.exception(ErrorCodeConstants.OMS_BIZ_ERROR,
                bizName + " status cannot jump back or stay in normal flow: " + current + " -> " + target);
        }
    }

    public static void requireAllowed(String bizName, Map<String, Set<String>> allowed, String current, String target) {
        if (StrUtil.equals(current, target)) {
            return;
        }
        if (!allowed.getOrDefault(current, Set.of()).contains(target)) {
            throw ServiceExceptionUtil.exception(ErrorCodeConstants.OMS_BIZ_ERROR,
                bizName + " status transition is not allowed: " + current + " -> " + target);
        }
    }

    public static void requireManualReason(String reason) {
        if (StrUtil.isBlank(reason)) {
            throw ServiceExceptionUtil.exception(ErrorCodeConstants.OMS_PARAM_INVALID, "manual status change reason is required");
        }
    }
}
