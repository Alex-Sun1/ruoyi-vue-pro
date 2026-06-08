package cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderShipmentRespVO;

import java.math.BigDecimal;
import java.util.Date;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("oms_cargo_order_shipment")
public class CargoOrderShipmentDO extends TenantBaseDO {

    @TableId
    private Long id;

    private Long cargoOrderId;
    private Long bizRootId;

    private String shipmentNo;
    private String poNo;
    private String shippingMark;
    private BigDecimal cartonQty;
    private BigDecimal palletQty;
    private BigDecimal weight;
    private BigDecimal cbm;
    private Date dwTime;
    private String groupCode;
    private String remark;}
