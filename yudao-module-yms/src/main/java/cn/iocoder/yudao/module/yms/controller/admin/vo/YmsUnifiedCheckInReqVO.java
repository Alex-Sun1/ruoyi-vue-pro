package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 门岗统一 Check-in BO
 * 替代原海柜/装车两个拆分表单，合并为一个入口。
 * 门岗录入后系统自动比对 OMS 数据，记录不一致字段。
 */
@Data
public class YmsUnifiedCheckInReqVO {

    @NotNull(message = "仓库不能为空")
    private Long warehouseId;

    /** 车牌号（可选，租赁车厢可能无车头） */
    private String plateNo;

    /** 海柜号（拆柜场景必填） */
    private String containerNo;

    /** 车厢号（装车租赁/自有车厢场景） */
    private String trailerNo;

    /** 装车号（装车入场必填，可为来源出库/派送单号或园区装车任务号） */
    private String loadingNo;

    /** 司机姓名 */
    private String driverName;

    /** 司机手机号 */
    private String driverPhone;

    /** 身份证号（可选） */
    private String idCardNo;

    /**
     * 车辆来源：SUPPLIER_TRUCK / RENTED_TRAILER / OWN_TRAILER / TEMP_TRUCK
     * 不传时系统根据 containerNo 是否存在自动推断：有柜号=拆柜, 否则=装车
     */
    private String vehicleSource;

    /**
     * 堆场位或道口编码（可选，门岗可在放行时分配）
     */
    private String positionCode;

    /** 现场照片URL（JSON数组字符串） */
    private String photoUrls;

    /** 备注 */
    private String remark;
}
