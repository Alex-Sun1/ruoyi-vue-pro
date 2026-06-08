package cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo;

import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingrule.vo.CargoGroupingRuleTestReqVO;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class CargoGroupingRuleTestReqVO {
    @NotNull(message = "仓库不能为空")
    private Long warehouseId;
    private Long cargoOrderId;
    private Long shipmentId;
    private String orderContext;
    private String shipmentContext;
}
