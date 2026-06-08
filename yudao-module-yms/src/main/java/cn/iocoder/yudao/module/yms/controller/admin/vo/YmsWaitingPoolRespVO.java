package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.util.Date;

@Data
public class YmsWaitingPoolRespVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    /** 资源ID（海柜/车厢） */
    private Long resourceId;

    /** CONTAINER / TRAILER */
    private String objectType;

    /** 等待对象展示（柜号/车厢号/车牌） */
    private String objectLabel;

    /** 类型：海柜 / 装车车辆 / 租赁车厢 */
    private String waitType;

    /** 车辆来源（车厢专用） */
    private String vehicleSource;

    /** 关联任务ID */
    private Long relatedTaskId;

    /** 关联任务号 */
    private String relatedTaskNo;

    /** 到仓时间 */
    private Date arrivedTime;

    /** 等待时长（分钟） */
    private Integer waitMinutes;

    /** 当前状态编码 */
    private String status;

    /** 阻塞原因 */
    private String blockReason;

    /** 仓库ID */
    private Long warehouseId;

    /** 是否可叫号 */
    private Boolean callable;
}
