package cn.iocoder.yudao.module.wms.controller.admin.location.vo;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class WmsLocationSaveReqVO {

    private Long id;
    private Long companyId;
    @NotNull(message = "仓库不能为空")
    private Long warehouseId;
    private String warehouseCode;
    private String warehouseName;
    @NotNull(message = "库区不能为空")
    private Long zoneId;
    private String zoneName;
    @NotBlank(message = "库位编码不能为空")
    private String locationCode;
    private String rowNo;
    private String columnNo;
    private Integer capacity;
    private String status;
    private String remark;

}
