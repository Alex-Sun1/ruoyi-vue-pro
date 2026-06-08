package cn.iocoder.yudao.module.oms.controller.admin.preoutbound.vo;

import cn.iocoder.yudao.module.oms.controller.admin.preoutbound.vo.PreOutboundRespVO;

import cn.idev.excel.annotation.ExcelIgnoreUnannotated;
import cn.idev.excel.annotation.ExcelProperty;
import lombok.Data;
import cn.iocoder.yudao.module.oms.dal.dataobject.preoutbound.PreOutboundDO;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

@Data
@ExcelIgnoreUnannotated
public class PreOutboundRespVO implements Serializable {
    private Long id;
    private Long bizRootId;
    private String bizRootIds;
    private Long cargoOrderId;
    private Integer cargoOrderCount;
    @ExcelProperty("预出单号")
    private String preOutboundNo;
    @ExcelProperty("货物订单号")
    private String cargoOrderNo;
    @ExcelProperty("状态")
    private String preOutboundStatus;
    @ExcelProperty("方向")
    private String outboundDirection;
    private Long outboundWarehouseId;
    @ExcelProperty("出库仓")
    private String outboundWarehouseName;
    @ExcelProperty("客户")
    private String customerName;
    @ExcelProperty("柜号")
    private String containerNo;
    private String shipmentCodes;
    private BigDecimal declaredCartonQty;
    private BigDecimal declaredPalletQty;
    private BigDecimal declaredWeight;
    private BigDecimal declaredCbm;
    private BigDecimal actualCartonQty;
    private BigDecimal actualPalletQty;
    private BigDecimal actualWeight;
    private BigDecimal actualCbm;
    private Date earliestDwTime;
    private Date deliveryLfd;
    private Date readyTime;
    private Date convertedTime;
    private String outboundOrderNo;
    private String appointmentNo;
    private Date appointmentTime;
    private String deliveryTruck;
    private String loadingType;
    private String transportType;
    private String deliveryTag;
    private String destination;
    private String deliveryMethod;
    private String followRecord;
    private String remark;
    private String createBy;
    private Date createTime;
}
