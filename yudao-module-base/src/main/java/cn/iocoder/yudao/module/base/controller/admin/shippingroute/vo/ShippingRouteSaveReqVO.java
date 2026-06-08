package cn.iocoder.yudao.module.base.controller.admin.shippingroute.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.math.BigDecimal;

@Schema(description = "管理后台 - 航线创建/更新 Request VO")
@Data
public class ShippingRouteSaveReqVO {

    private Long id;

    @NotBlank(message = "航线代码不能为空")
    private String routeCode;

    @NotBlank(message = "航线名称不能为空")
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
