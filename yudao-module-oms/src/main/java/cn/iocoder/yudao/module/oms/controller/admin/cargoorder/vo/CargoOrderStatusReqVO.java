package cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo;

import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderStatusReqVO;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class CargoOrderStatusReqVO {

    @NotBlank(message = "目标状态不能为空")
    private String targetStatus;

    private String remark;
}
