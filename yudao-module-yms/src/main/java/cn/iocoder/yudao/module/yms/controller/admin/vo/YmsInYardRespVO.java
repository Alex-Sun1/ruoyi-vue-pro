package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.util.Date;

/**
 * 在场车辆/海柜/车厢统一视图
 */
@Data
public class YmsInYardRespVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    /** 对象类型：CONTAINER / TRAILER */
    private String objectType;

    /** 资源ID（海柜或车厢） */
    private Long resourceId;

    private Long warehouseId;

    private String plateNo;
    private String trailerNo;
    private String containerNo;
    /** 车辆来源（车厢） */
    private String vehicleSource;

    /** 资源状态编码 */
    private String currentStatus;

    /** 当前区域：WAITING / YARD / DOCK */
    private String currentArea;
    /** 区域展示（Dock号/堆场位/区名） */
    private String areaLabel;

    /** 到场时间（Check-in / 资源到仓时间） */
    private Date gateInTime;

    /** 在场时长（分钟，服务端计算） */
    private Integer stayMinutes;

    private String relatedOrderNo;
    private Long relatedTaskId;
    private String driverName;
    private String driverPhone;

    private Integer exceptionFlag;
    private String exceptionReason;
}
