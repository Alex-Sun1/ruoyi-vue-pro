package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.util.Date;

@Data
public class YmsCheckInRespVO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long warehouseId;
    private String checkInType;
    private Long aptId;
    private String aptNo;
    private Long yardTaskId;
    private String yardTaskNo;
    private Long containerResourceId;
    private Long trailerResourceId;
    private String plateNo;
    private String driverName;
    private String driverPhone;
    private String idCardNo;
    private String containerNo;
    private String trailerNo;
    private String vehicleSource;
    private String taskType;
    private String checkResult;
    private String rejectReason;
    private String matchType;
    private Date checkInTime;
    private Date checkOutTime;
    private Integer stayMinutes;
    private Long operatorId;
    private String operatorName;
    private String remark;
    private String photoUrls;
    private String receiptNo;
    /** 登记来源：GATE / DRIVER_SELF */
    private String checkinSource;
    private Long positionId;
    private String positionCode;
    /** OMS数据不符标记 */
    private Integer omsMismatchFlag;
    /** 不符字段列表JSON */
    private String omsMismatchFields;
    private Date createTime;
}
