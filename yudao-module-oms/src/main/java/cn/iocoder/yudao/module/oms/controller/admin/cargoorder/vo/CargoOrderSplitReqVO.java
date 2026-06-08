package cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo;

import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderSplitReqVO;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Data
public class CargoOrderSplitReqVO {

    @NotBlank(message = "拆单来源不能为空")
    private String splitSource;

    private Integer customerVisibleFlag;
    private String splitRequestedBy;
    private String customerSplitReason;
    private String internalSplitReason;
    private String splitMode;
    private String remark;

    @Valid
    @NotEmpty(message = "子单明细不能为空")
    private List<Child> children;

    @Data
    public static class Child {
        private String cargoOrderNoSuffix;
        private List<Long> shipmentIds;
        private BigDecimal cartonQty;
        private BigDecimal weight;
        private BigDecimal cbm;
        private Integer holdFlag;
        private String holdReason;
        private Integer customerVisibleFlag;
        private String remark;
    }
}
