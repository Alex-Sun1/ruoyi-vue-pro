package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

/**
 * 装车司机 H5 预登记 — 提货号查询结果
 */
@Data
public class YmsTrailerCheckinLookupRespVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    /** 提货号（来源单据编号 source_order_no） */
    private String pickupNo;

    /** 车次号（yardTaskNo） */
    private String truckRouteNo;

    /** 司机电话（已登记则回填） */
    private String driverPhone;

    /** 司机驾照号码（已登记则回填） */
    private String driverLicenseNo;

    /** 车厢号（truck_no，已登记则回填） */
    private String trailerNo;

    /** 预约到场时间（eta_yard_time，格式：yyyy-MM-dd HH:mm） */
    private String scheduledTime;

    /** 状态编码：pending / pre_arrived / checked_in / completed / cancelled */
    private String status;

    /** 状态显示文本 */
    private String statusLabel;

    /** 派送明细（由 OMS 集成层填充，未集成时为空列表） */
    private List<YmsTrailerCheckinDispatchItemRespVO> dispatchItems;

    // ── 内嵌：派送明细行 ──────────────────────────────────────────────────

    @Data
    public static class YmsTrailerCheckinDispatchItemRespVO implements Serializable {

        @Serial
        private static final long serialVersionUID = 1L;

        /** PC单号 */
        private String pcNo;

        /** 预约方（客户/货主名称） */
        private String booker;

        /** 预约时间 */
        private String bookedTime;

        /** 起始仓库名称 */
        private String fromWarehouse;

        /** 目的地 */
        private String destination;

        /** 板数 */
        private Integer palletCount;

        /** 重量(kg) */
        private BigDecimal weight;

        /** 装车类型（卡板/地板 等） */
        private String loadingType;

        /** 箱数 */
        private Integer boxCount;

        /** 优先级（1=最高） */
        private Integer priority;

        /** 方数(CBM) */
        private BigDecimal cbm;
    }
}
