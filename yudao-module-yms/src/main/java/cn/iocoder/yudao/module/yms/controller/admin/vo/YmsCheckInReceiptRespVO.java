package cn.iocoder.yudao.module.yms.controller.admin.vo;

import lombok.Data;

import java.io.Serializable;
import java.util.Date;

@Data
public class YmsCheckInReceiptRespVO implements Serializable {

    private String receiptNo;
    private String warehouseName;
    private String checkInType;
    private String plateNo;
    private String driverName;
    private String containerNo;
    private String trailerNo;
    private String aptNo;
    private String checkResult;
    private Date checkInTime;
    private String operatorName;
}
