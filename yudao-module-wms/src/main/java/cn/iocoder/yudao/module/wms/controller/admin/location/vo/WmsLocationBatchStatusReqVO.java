package cn.iocoder.yudao.module.wms.controller.admin.location.vo;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

import java.util.List;

@Data
public class WmsLocationBatchStatusReqVO {

    @NotEmpty(message = "库位不能为空")
    private List<Long> ids;
    @NotBlank(message = "状态不能为空")
    private String status;

}
