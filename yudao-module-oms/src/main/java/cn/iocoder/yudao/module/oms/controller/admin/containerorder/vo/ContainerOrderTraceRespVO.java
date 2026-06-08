package cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo;

import cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerOrderTraceRespVO;

import cn.idev.excel.annotation.ExcelIgnoreUnannotated;
import lombok.Data;
import cn.iocoder.yudao.module.oms.dal.dataobject.containerorder.ContainerOrderTraceDO;

import java.io.Serializable;
import java.util.Date;

/**
 * 海柜订单轨迹视图
 */
@Data
@ExcelIgnoreUnannotated
public class ContainerOrderTraceRespVO implements Serializable {

    private Long id;
    private Long containerOrderId;
    private String containerOrderNo;
    private String containerNo;
    private String statusFrom;
    private String statusTo;
    private String action;
    private String actionDesc;
    private Long operatorId;
    private String operatorName;
    private String remark;
    private Date createTime;
}
