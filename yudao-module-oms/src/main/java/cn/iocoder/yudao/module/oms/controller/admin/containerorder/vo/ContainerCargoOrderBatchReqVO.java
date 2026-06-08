package cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo;

import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderSaveReqVO;

import cn.iocoder.yudao.module.oms.controller.admin.containerorder.vo.ContainerCargoOrderBatchReqVO;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

/**
 * 海柜订单批量新增关联货物订单
 */
@Data
public class ContainerCargoOrderBatchReqVO {

    @NotEmpty(message = "货物订单不能为空")
    @Valid
    private List<CargoOrderSaveReqVO> cargoOrders = new ArrayList<>();
}
