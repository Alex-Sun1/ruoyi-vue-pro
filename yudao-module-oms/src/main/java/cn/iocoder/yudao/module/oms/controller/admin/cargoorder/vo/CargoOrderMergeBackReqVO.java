package cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo;

import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderMergeBackReqVO;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

@Data
public class CargoOrderMergeBackReqVO {

    @NotNull(message = "原单ID不能为空")
    private Long rootCargoOrderId;

    @NotEmpty(message = "回并子单不能为空")
    private List<Long> childCargoOrderIds;

    @NotBlank(message = "回并原因不能为空")
    private String mergeBackReason;

    private String mergeBackType;
}
