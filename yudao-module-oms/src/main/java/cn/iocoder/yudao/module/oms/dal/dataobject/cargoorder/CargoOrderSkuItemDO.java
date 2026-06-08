package cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderSkuItemRespVO;

import java.math.BigDecimal;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("oms_cargo_order_sku_item")
public class CargoOrderSkuItemDO extends TenantBaseDO {

    @TableId
    private Long id;

    private Long cargoOrderId;
    private Long shipmentId;
    private String shipmentNo;
    private String poNo;
    private String shippingMark;

    private String sku;
    private String fnsku;
    private String productName;
    private BigDecimal qty;
    private BigDecimal cartonQty;
    private BigDecimal weight;
    private BigDecimal cbm;
    private String remark;}
