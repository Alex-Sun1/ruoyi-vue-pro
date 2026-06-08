package cn.iocoder.yudao.module.base.controller.admin.shippingroute.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Schema(description = "管理后台 - 航线分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class ShippingRoutePageReqVO extends PageParam {

    private String routeCode;
    private String routeName;
    private Long shippingLineId;
    private Long originPortId;
    private Long destinationPortId;
    private Integer status;

}
