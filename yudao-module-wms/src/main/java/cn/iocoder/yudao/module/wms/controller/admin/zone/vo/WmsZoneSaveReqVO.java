package cn.iocoder.yudao.module.wms.controller.admin.zone.vo;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class WmsZoneSaveReqVO {

    private Long id;
    private Long companyId;
    @NotNull(message = "仓库不能为空")
    private Long warehouseId;
    private String warehouseCode;
    private String warehouseName;
    @NotBlank(message = "区域名称不能为空")
    private String zoneName;
    @NotBlank(message = "存放方式不能为空")
    private String storageMethod;
    @NotBlank(message = "库区类型不能为空")
    private String zoneType;
    @NotNull(message = "库位混合存储不能为空")
    private Integer allowMixedStorage;
    private Integer maxMixedQty;
    private String status;
    private String remark;

}
