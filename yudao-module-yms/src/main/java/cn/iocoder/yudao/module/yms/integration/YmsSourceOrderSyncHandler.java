package cn.iocoder.yudao.module.yms.integration;

import java.util.Date;

/**
 * YMS 园区作业完成后回写来源 OMS 单据（可选实现，由 OMS 模块提供 Bean）。
 */
public interface YmsSourceOrderSyncHandler {

    /**
     * 状态动作回写（通用）
     *
     * @param action DOCK_ASSIGNED / START_DOCK / FINISH_DOCK / LEAVE_YARD
     */
    void onYardTaskAction(String sourceOrderType, Long sourceOrderId, String taskType, String action);

    /**
     * 到仓回写（Check-in 时调用）
     * 同步实际到仓时间、堆场位/道口等字段到 OMS 来源单据。
     *
     * @param arrivalTime  实际到仓时间
     * @param positionCode 堆场位或道口编码（可为 null）
     */
    default void onYardTaskArrival(String sourceOrderType, Long sourceOrderId, String taskType,
                                   Date arrivalTime, String positionCode) {
        // 默认不处理，由 OMS 模块实现
    }
}
