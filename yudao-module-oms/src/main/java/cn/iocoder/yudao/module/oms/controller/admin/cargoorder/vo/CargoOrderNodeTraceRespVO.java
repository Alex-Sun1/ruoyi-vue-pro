package cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo;

import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderNodeTraceRespVO;

import lombok.Data;

import java.io.Serializable;
import java.util.Date;

@Data
public class CargoOrderNodeTraceRespVO implements Serializable {

    private Long id;
    private Long cargoOrderId;
    private Long bizRootId;
    private String nodeCode;
    private String nodeName;
    private String nodeStatus;
    private String statusFrom;
    private String statusTo;
    private String action;
    private Date actualTime;
    private String sourceType;
    private String sourceOrderNo;
    private Long operatorId;
    private String operatorName;
    private String remark;
    private Date createTime;
}
