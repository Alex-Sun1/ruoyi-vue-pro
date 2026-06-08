package cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo;

import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderReleaseReqVO;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class CargoOrderReleaseReqVO {

    @NotBlank(message = "放行原因不能为空")
    private String releaseReason;

    private String remark;
}
