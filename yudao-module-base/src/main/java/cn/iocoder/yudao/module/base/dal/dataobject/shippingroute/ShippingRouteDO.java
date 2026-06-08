package cn.iocoder.yudao.module.base.dal.dataobject.shippingroute;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;

import java.math.BigDecimal;

@TableName("base_shipping_route")
@KeySequence("base_shipping_route_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ShippingRouteDO extends TenantBaseDO {

    @TableId
    private Long id;
    private String routeCode;
    private String routeName;
    private String routeNameEn;
    private Long shippingLineId;
    private String shippingLineCode;
    private String shippingLineName;
    private Long originPortId;
    private String originPortCode;
    private String originPortName;
    private Long destinationPortId;
    private String destinationPortCode;
    private String destinationPortName;
    private Integer defaultTransitDays;
    private String routeType;
    private Integer referenceMinDays;
    private Integer referenceAvgDays;
    private Integer referenceMaxDays;
    private BigDecimal referenceFreight;
    private Integer status;
    private String remark;

}
