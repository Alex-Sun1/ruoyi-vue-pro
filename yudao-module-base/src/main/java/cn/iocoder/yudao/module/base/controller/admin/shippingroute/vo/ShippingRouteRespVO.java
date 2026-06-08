package cn.iocoder.yudao.module.base.controller.admin.shippingroute.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Schema(description = "管理后台 - 航线 Response VO")
@Data
public class ShippingRouteRespVO {

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
    private LocalDateTime createTime;

}
