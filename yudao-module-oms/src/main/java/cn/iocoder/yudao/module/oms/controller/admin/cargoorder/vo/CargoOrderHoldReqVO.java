package cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo;

import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderHoldReqVO;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class CargoOrderHoldReqVO {

    @NotBlank(message = "暂扣类型不能为空")
    private String holdType;

    @NotBlank(message = "暂扣原因不能为空")
    private String holdReason;

    private String remark;
}
