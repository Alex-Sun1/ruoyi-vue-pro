package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.util.Date;

@Data
public class YmsCheckOutRespVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    /** PASSED / PENDING(WARN) / REJECTED(BLOCK) */
    private String checkOutResult;
    private String rejectReason;

    private String objectType;
    private Long resourceId;
    private Long warehouseId;

    private String plateNo;
    private String trailerNo;
    private String containerNo;
    private String vehicleSource;
    private String currentStatus;
    private String currentArea;
    private String areaLabel;

    private Date gateInTime;
    private Date gateOutTime;
    private Integer stayMinutes;

    /** 入场登记司机信息（来自 open check-in） */
    private String gateInPlateNo;
    private String gateInDriverName;
    private String gateInDriverPhone;
    private String gateInIdCardNo;

    /** 本次离场登记（办理后回填） */
    private String checkOutPlateNo;
    private String checkOutDriverName;
    private String checkOutDriverPhone;
    private String checkOutIdCardNo;

    private Long yardTaskId;
    private String yardTaskNo;
    private Long checkInId;

    private Long openInternalTaskId;
    private String openInternalTaskNo;
    private String openInternalTaskType;
    private String openInternalTaskStatus;
    private String openInternalTaskTargetCode;
}
