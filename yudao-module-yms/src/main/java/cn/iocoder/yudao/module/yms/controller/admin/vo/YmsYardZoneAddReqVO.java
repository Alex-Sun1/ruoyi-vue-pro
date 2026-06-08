package cn.iocoder.yudao.module.yms.controller.admin.vo;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsYardZoneDO;

@Data
public class YmsYardZoneAddReqVO {

    @NotNull(message = "仓库不能为空")
    private Long warehouseId;

    @NotBlank(message = "区域编码不能为空")
    private String zoneCode;

    @NotBlank(message = "区域名称不能为空")
    private String zoneName;

    @NotBlank(message = "区域类型不能为空")
    private String zoneType;

    private Integer sortOrder;
    private String remark;
}
