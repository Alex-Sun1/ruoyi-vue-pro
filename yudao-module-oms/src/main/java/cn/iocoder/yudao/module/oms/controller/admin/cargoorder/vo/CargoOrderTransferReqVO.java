package cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo;

import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderTransferReqVO;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * 货物订单转仓业务动作参数
 */
@Data
public class CargoOrderTransferReqVO {

    @NotBlank(message = "转仓仓库代码不能为空")
    private String transferWarehouseCode;

    private String remark;
}
