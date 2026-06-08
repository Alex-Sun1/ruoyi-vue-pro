package cn.iocoder.yudao.module.oms.dal.dataobject.preoutbound;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import cn.iocoder.yudao.module.oms.controller.admin.preoutbound.vo.PreOutboundRespVO;

import java.math.BigDecimal;
import java.util.Date;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("oms_pre_outbound")
public class PreOutboundDO extends TenantBaseDO {

    @TableId(type = IdType.ASSIGN_ID)
    private Long id;
    private Long bizRootId;
    private String bizRootIds;
    private Long cargoOrderId;
    private String cargoOrderNo;
    /** 关联货物订单数（1:N明细由 oms_pre_outbound_item 管理） */
    private Integer cargoOrderCount;
    private String preOutboundNo;
    private String preOutboundStatus;
    private String outboundDirection;
    private Long outboundWarehouseId;
    private String outboundWarehouseName;
    private String customerName;
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
}
