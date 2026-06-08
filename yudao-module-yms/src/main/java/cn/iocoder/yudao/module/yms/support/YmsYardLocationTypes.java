package cn.iocoder.yudao.module.yms.support;

import java.util.Set;

/** 堆场位置类型常量（与 yard_dock.location_type 对齐） */
public final class YmsYardLocationTypes {

    public static final String DOCK = "DOCK";

    public static final Set<String> SLOT_TYPES = Set.of(
        "PARKING",
        "CONTAINER_SLOT",
        "EMPTY_CONTAINER_SLOT",
        "TRAILER_SLOT",
        "WAITING_SLOT",
        "BLOCKED_SLOT"
    );

    public static boolean isSlot(String locationType) {
        return locationType != null && SLOT_TYPES.contains(locationType);
    }

    private YmsYardLocationTypes() {
    }
}
